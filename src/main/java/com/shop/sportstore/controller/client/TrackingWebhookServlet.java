package com.shop.sportstore.controller.client;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import java.io.BufferedReader;
import java.io.IOException;
import java.io.InputStreamReader;
import java.io.OutputStream;
import java.net.HttpURLConnection;
import java.net.URL;
import java.nio.charset.StandardCharsets;
import java.sql.SQLException;
import java.text.SimpleDateFormat;

import com.shop.sportstore.dao.OrderDAO;
import com.shop.sportstore.model.Order;
import com.google.gson.JsonObject;
import com.google.gson.JsonParser;

@WebServlet("/api/track-order")
public class TrackingWebhookServlet extends HttpServlet {
    private static final long serialVersionUID = 1L;

    private static final String GHN_TOKEN = "2eb2d430-50e9-11f1-a973-aee5264794df";
    private static final String GHN_SHOP_ID = "200323";
    private static final String GHN_TRACKING_URL = "https://dev-online-gateway.ghn.vn/shiip/public-api/v2/shipping-order/detail";

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        response.setContentType("application/json");
        response.setCharacterEncoding("UTF-8");

        String keyword = request.getParameter("keyword");
        JsonObject jsonResponse = new JsonObject();

        if (keyword == null || keyword.trim().isEmpty()) {
            jsonResponse.addProperty("status", "error");
            jsonResponse.addProperty("message", "Vui lòng nhập mã đơn hàng hoặc số điện thoại để tra cứu.");
            response.getWriter().write(jsonResponse.toString());
            return;
        }

        OrderDAO orderDAO = new OrderDAO();

        try {
            Order order = orderDAO.findOrderByCodeOrPhone(keyword.trim());

            if (order == null) {
                jsonResponse.addProperty("status", "error");
                jsonResponse.addProperty("message", "Không tìm thấy thông tin đơn hàng nào khớp với từ khóa tìm kiếm.");
                response.getWriter().write(jsonResponse.toString());
                return;
            }

            String ghnOrderCode = order.getOrderCode();

            if (ghnOrderCode == null || ghnOrderCode.isEmpty()) {
                jsonResponse.addProperty("status", "error");
                jsonResponse.addProperty("message", "Đơn hàng này chưa được đồng bộ mã vận đơn đối tác.");
                response.getWriter().write(jsonResponse.toString());
                return;
            }

            URL url = new URL(GHN_TRACKING_URL);
            HttpURLConnection conn = (HttpURLConnection) url.openConnection();
            conn.setRequestMethod("POST");
            conn.setRequestProperty("Content-Type", "application/json; utf-8");
            conn.setRequestProperty("Token", GHN_TOKEN);
            conn.setRequestProperty("ShopId", GHN_SHOP_ID);
            conn.setDoOutput(true);

            String jsonInputString = "{\"order_code\": \"" + ghnOrderCode + "\"}";

            try (OutputStream os = conn.getOutputStream()) {
                byte[] input = jsonInputString.getBytes(StandardCharsets.UTF_8);
                os.write(input, 0, input.length);
            }

            int responseCode = conn.getResponseCode();
            if (responseCode == HttpURLConnection.HTTP_OK) {
                try (BufferedReader br = new BufferedReader(new InputStreamReader(conn.getInputStream(), StandardCharsets.UTF_8))) {
                    StringBuilder responseBuilder = new StringBuilder();
                    String responseLine;
                    while ((responseLine = br.readLine()) != null) {
                        responseBuilder.append(responseLine.trim());
                    }

                    JsonObject ghnJson = JsonParser.parseString(responseBuilder.toString()).getAsJsonObject();

                    if (ghnJson.get("code").getAsInt() == 200) {
                        JsonObject dataObj = ghnJson.getAsJsonObject("data");
                        String ghnRawStatus = dataObj.get("status").getAsString().toLowerCase();
                        String receiverName = dataObj.has("to_name") ? dataObj.get("to_name").getAsString() : order.getReceiverName();

                        String systemStatus = order.getStatus();
                        switch (ghnRawStatus) {
                            case "ready_to_pick":
                            case "picking":
                            case "money_collect_picking":
                                systemStatus = "PROCESSING";
                                break;
                            case "picked":
                            case "storing":
                            case "transporting":
                            case "sorting":
                            case "delivering":
                                systemStatus = "SHIPPING";
                                break;
                            case "delivered":
                                systemStatus = "DELIVERED";
                                break;
                            case "cancel":
                                systemStatus = "CANCELLED";
                                break;
                            case "return":
                            case "returning":
                            case "returned":
                            case "waiting_to_return":
                                systemStatus = "CANCELLED";
                                break;
                        }

                        try {
                            orderDAO.updateStatusByGhnCode(ghnOrderCode, systemStatus);
                        } catch (SQLException e) {
                            System.err.println("❌ Lỗi đồng bộ trạng thái đơn hàng xuống DB: " + e.getMessage());
                        }

                        String formattedDate = "Đang cập nhật";
                        if (order.getCreatedAt() != null) {
                            formattedDate = new SimpleDateFormat("dd/MM/yyyy HH:mm").format(order.getCreatedAt());
                        }

                        jsonResponse.addProperty("status", "success");
                        jsonResponse.addProperty("orderId", ghnOrderCode);
                        jsonResponse.addProperty("receiverName", receiverName);
                        jsonResponse.addProperty("orderDate", formattedDate);
                        jsonResponse.addProperty("totalPrice", String.format("%,d ₫", (int) order.getTotalPrice()));
                        jsonResponse.addProperty("orderStatus", translateGhnStatus(ghnRawStatus));

                    } else {
                        jsonResponse.addProperty("status", "error");
                        jsonResponse.addProperty("message", "Mã vận đơn không tồn tại hoặc đã hết hạn lưu trữ trên hệ thống GHN.");
                    }
                }
            } else {
                jsonResponse.addProperty("status", "error");
                jsonResponse.addProperty("message", "Không thể liên kết thông tin với tổng đài GHN (Mã phản hồi lỗi: " + responseCode + ")");
            }

        } catch (Exception e) {
            e.printStackTrace();
            jsonResponse.addProperty("status", "error");
            jsonResponse.addProperty("message", "Hệ thống gặp sự cố khi xử lý dữ liệu: " + e.getMessage());
        }

        response.getWriter().write(jsonResponse.toString());
    }

    private String translateGhnStatus(String status) {
        switch (status) {
            case "ready_to_pick": return "Chờ bưu tá đến lấy hàng";
            case "picking": return "Bưu tá đang đến lấy bưu kiện";
            case "money_collect_picking": return "Đang lấy hàng - Thu tiền bưu cục";
            case "picked": return "GHN đã lấy hàng từ shop hoàn tất";
            case "storing": return "Hàng đang nằm tại kho phân loại bưu kiện";
            case "transporting": return "Hàng đang được trung chuyển liên tỉnh";
            case "sorting": return "Đang xử lý phân loại bưu kiện";
            case "delivering": return "Shipper đang giao hàng đến bạn 🚚";
            case "delivered": return "Giao hàng thành công 🎉";
            case "delivery_fail": return "Giao hàng không thành công (Sẽ tiến hành phát lại)";
            case "return":
            case "waiting_to_return": return "Đơn hàng gặp sự cố - Chờ chuyển hoàn";
            case "returning": return "Đang chuyển hoàn bưu kiện về cho Shop";
            case "returned": return "Đã hoàn trả hàng thành công";
            case "cancel": return "Đơn hàng đã bị hủy bỏ";
            default: return "Đang cập nhật tình trạng (" + status + ")";
        }
    }
}