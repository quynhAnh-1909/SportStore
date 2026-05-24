package com.shop.sportstore.controller.client;

import com.google.gson.JsonObject;
import com.google.gson.JsonParser;
import com.shop.sportstore.dao.OrderDAO;
import com.shop.sportstore.model.Order;

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
import java.text.SimpleDateFormat;

@WebServlet("/api/track-order")
public class TrackingWebhookServlet extends HttpServlet {

    private static final long serialVersionUID = 1L;

    private static final String GHN_TOKEN =
            "2eb2d430-50e9-11f1-a973-aee5264794df";

    private static final String GHN_SHOP_ID =
            "200403";

    private static final String GHN_TRACKING_URL =
            "https://dev-online-gateway.ghn.vn/shiip/public-api/v2/shipping-order/detail";

    @Override
    protected void doGet(HttpServletRequest request,
                         HttpServletResponse response)
            throws ServletException, IOException {

        response.setContentType("application/json");
        response.setCharacterEncoding("UTF-8");

        JsonObject jsonResponse = new JsonObject();

        try {

            String keyword = request.getParameter("keyword");

            // =========================
            // VALIDATE INPUT
            // =========================
            if (keyword == null || keyword.trim().isEmpty()) {

                jsonResponse.addProperty("status", "error");

                jsonResponse.addProperty(
                        "message",
                        "Vui lòng nhập mã đơn hàng hoặc số điện thoại"
                );

                response.getWriter().write(jsonResponse.toString());

                return;
            }

            OrderDAO orderDAO = new OrderDAO();

            // =========================
            // TÌM ĐƠN
            // =========================
            Order order =
                    orderDAO.findOrderByCodeOrPhone(keyword.trim());

            if (order == null) {

                jsonResponse.addProperty("status", "error");

                jsonResponse.addProperty(
                        "message",
                        "Không tìm thấy đơn hàng"
                );

                response.getWriter().write(jsonResponse.toString());

                return;
            }

            // =========================
            // CHECK GHN CODE
            // =========================
            String ghnOrderCode = order.getGhnCode();

            if (ghnOrderCode == null ||
                    ghnOrderCode.trim().isEmpty()) {

                jsonResponse.addProperty("status", "error");

                jsonResponse.addProperty(
                        "message",
                        "Đơn hàng chưa được giao cho GHN"
                );

                response.getWriter().write(jsonResponse.toString());

                return;
            }

            // =========================
            // CALL GHN API
            // =========================
            URL url = new URL(GHN_TRACKING_URL);

            HttpURLConnection conn =
                    (HttpURLConnection) url.openConnection();

            conn.setRequestMethod("POST");

            conn.setRequestProperty(
                    "Content-Type",
                    "application/json"
            );

            conn.setRequestProperty(
                    "Token",
                    GHN_TOKEN
            );

            conn.setRequestProperty(
                    "ShopId",
                    GHN_SHOP_ID
            );

            conn.setDoOutput(true);

            JsonObject payload = new JsonObject();

            payload.addProperty(
                    "order_code",
                    ghnOrderCode
            );

            try (OutputStream os = conn.getOutputStream()) {

                byte[] input =
                        payload.toString()
                                .getBytes(StandardCharsets.UTF_8);

                os.write(input, 0, input.length);
            }

            BufferedReader br;

            if (conn.getResponseCode() >= 200 &&
                    conn.getResponseCode() < 300) {

                br = new BufferedReader(
                        new InputStreamReader(
                                conn.getInputStream(),
                                StandardCharsets.UTF_8
                        )
                );

            } else {

                br = new BufferedReader(
                        new InputStreamReader(
                                conn.getErrorStream(),
                                StandardCharsets.UTF_8
                        )
                );
            }

            StringBuilder responseBuilder =
                    new StringBuilder();

            String line;

            while ((line = br.readLine()) != null) {

                responseBuilder.append(line);
            }

            System.out.println("========== GHN RESPONSE ==========");
            System.out.println(responseBuilder);

            JsonObject ghnJson =
                    JsonParser.parseString(
                            responseBuilder.toString()
                    ).getAsJsonObject();

            // =========================
            // SUCCESS
            // =========================
            if (ghnJson.has("code") &&
                    ghnJson.get("code").getAsInt() == 200) {

                JsonObject dataObj =
                        ghnJson.getAsJsonObject("data");

                String ghnStatus =
                        dataObj.get("status")
                                .getAsString()
                                .toLowerCase();

                String systemStatus = order.getStatus();

                int statusCode = 1;

                // =========================
                // MAP STATUS
                // =========================
                switch (ghnStatus) {

                    case "ready_to_pick":
                    case "picking":
                    case "money_collect_picking":

                        systemStatus = "CONFIRMED";
                        statusCode = 2;
                        break;

                    case "picked":
                    case "storing":
                    case "transporting":
                    case "sorting":
                    case "delivering":

                        systemStatus = "SHIPPING";
                        statusCode = 3;
                        break;

                    case "delivered":

                        systemStatus = "DELIVERED";
                        statusCode = 4;
                        break;

                    case "cancel":
                    case "return":
                    case "returning":
                    case "returned":
                    case "waiting_to_return":

                        systemStatus = "CANCELLED";
                        statusCode = 5;
                        break;
                }

                // =========================
                // UPDATE DB
                // =========================
                try {

                    orderDAO.updateStatusByGhnCode(
                            order.getOrderCode(),
                            systemStatus
                    );

                } catch (Exception e) {

                    System.out.println(
                            "❌ Lỗi update DB: " + e.getMessage()
                    );
                }

                // =========================
                // FORMAT DATE
                // =========================
                String formattedDate =
                        "Đang cập nhật";

                if (order.getCreatedAt() != null) {

                    formattedDate =
                            new SimpleDateFormat(
                                    "dd/MM/yyyy HH:mm"
                            ).format(order.getCreatedAt());
                }

                // =========================
                // RESPONSE SUCCESS
                // =========================
                jsonResponse.addProperty(
                        "status",
                        "success"
                );

                jsonResponse.addProperty(
                        "orderId",
                        order.getOrderCode()
                );

                jsonResponse.addProperty(
                        "ghnOrderCode",
                        ghnOrderCode
                );

                jsonResponse.addProperty(
                        "receiverName",
                        order.getReceiverName()
                );

                jsonResponse.addProperty(
                        "receiverPhone",
                        order.getReceiverPhone()
                );

                jsonResponse.addProperty(
                        "address",
                        order.getAddress()
                );

                jsonResponse.addProperty(
                        "orderDate",
                        formattedDate
                );

                jsonResponse.addProperty(
                        "paymentMethod",
                        order.getPaymentMethod()
                );

                jsonResponse.addProperty(
                        "totalPrice",
                        String.format(
                                "%,.0f VNĐ",
                                order.getTotalPrice()
                        )
                );

                jsonResponse.addProperty(
                        "orderStatus",
                        translateGhnStatus(ghnStatus)
                );

                jsonResponse.addProperty(
                        "statusCode",
                        statusCode
                );

            } else {

                String ghnMessage =
                        ghnJson.has("message")
                                ? ghnJson.get("message").getAsString()
                                : "Không thể tra cứu đơn hàng";

                jsonResponse.addProperty(
                        "status",
                        "error"
                );

                jsonResponse.addProperty(
                        "message",
                        ghnMessage
                );
            }

        } catch (Exception e) {

            e.printStackTrace();

            jsonResponse.addProperty(
                    "status",
                    "error"
            );

            jsonResponse.addProperty(
                    "message",
                    "Lỗi hệ thống: " + e.getMessage()
            );
        }

        response.getWriter().write(
                jsonResponse.toString()
        );
    }

    // =========================
    // DỊCH STATUS
    // =========================
    private String translateGhnStatus(String status) {

        switch (status) {

            case "ready_to_pick":
                return "Chờ GHN lấy hàng";

            case "picking":
                return "Shipper đang lấy hàng";

            case "money_collect_picking":
                return "Đang lấy hàng";

            case "picked":
                return "Đã lấy hàng";

            case "storing":
                return "Đang lưu kho";

            case "transporting":
                return "Đang trung chuyển";

            case "sorting":
                return "Đang phân loại";

            case "delivering":
                return "Shipper đang giao hàng";

            case "delivered":
                return "Giao hàng thành công";

            case "delivery_fail":
                return "Giao hàng thất bại";

            case "return":
                return "Đang hoàn hàng";

            case "waiting_to_return":
                return "Chờ hoàn hàng";

            case "returning":
                return "Đang chuyển hoàn";

            case "returned":
                return "Đã hoàn hàng";

            case "cancel":
                return "Đơn hàng đã hủy";

            default:
                return "Đang cập nhật";
        }
    }
}