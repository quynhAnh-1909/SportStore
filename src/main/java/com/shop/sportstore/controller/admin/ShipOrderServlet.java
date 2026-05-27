package com.shop.sportstore.controller.admin;

import com.google.gson.Gson;
import com.google.gson.JsonArray;
import com.google.gson.JsonObject;
import com.shop.sportstore.dao.OrderDAO;
import com.shop.sportstore.model.Order;
import com.shop.sportstore.model.OrderDetail;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.*;

import java.io.*;
import java.net.HttpURLConnection;
import java.net.URL;
import java.nio.charset.StandardCharsets;

@WebServlet("/admin/ship-order")
public class ShipOrderServlet extends HttpServlet {

    private static final String TOKEN = "2eb2d430-50e9-11f1-a973-aee5264794df";
    private static final int SHOP_ID = 200403;

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        int orderId = Integer.parseInt(request.getParameter("id"));
        OrderDAO orderDAO = new OrderDAO();

        try {
            Order order = orderDAO.getOrderById(orderId);
            if (order == null) {
                response.getWriter().write("Không tìm thấy đơn hàng");
                return;
            }

            Gson gson = new Gson();
            JsonObject json = new JsonObject();

            /* =========================
               THÔNG TIN CƠ BẢN
            ========================= */
            json.addProperty("payment_type_id", 2);
            json.addProperty("note", order.getNote() != null ? order.getNote() : "");
            json.addProperty("required_note", "KHONGCHOXEMHANG");
            json.addProperty("client_order_code", order.getOrderCode() + "_" + System.currentTimeMillis());

            /* =========================
               NGƯỜI NHẬN (Cấu hình chuẩn Sandbox)
            ========================= */
            String phone = order.getReceiverPhone().replaceAll("[^0-9]", "");
            json.addProperty("to_name", order.getReceiverName());
            json.addProperty("to_phone", phone);
            json.addProperty("to_address", order.getAddress());
            json.addProperty("to_ward_code", "20314");
            json.addProperty("to_district_id", 1444);

            /* =========================
               SHOP GỬI
            ========================= */
            json.addProperty("from_name", "SportStore");
            json.addProperty("from_phone", "0388035132");
            json.addProperty("from_address", "Đại Học Nông Lâm - Quốc Lộ 1, Đông Hòa, Dĩ An, Bình Dương");
            json.addProperty("from_ward_name", "Đông Hòa");
            json.addProperty("from_district_name", "Dĩ An");
            json.addProperty("from_province_name", "Bình Dương");

            /* =========================
               COD
            ========================= */
            int codAmount = order.getPaymentMethod().equals("COD")
                    ? (int) (order.getTotalPrice() - order.getShippingFee())
                    : 0;
            json.addProperty("cod_amount", codAmount);

            /* =========================
               KÍCH THƯỚC
            ========================= */
            json.addProperty("weight", 1000);
            json.addProperty("length", 20);
            json.addProperty("width", 20);
            json.addProperty("height", 10);
            json.addProperty("service_type_id", 2);

            /* =========================
               PICK SHIFT
            ========================= */
            JsonArray shift = new JsonArray();
            shift.add(2);
            json.add("pick_shift", shift);

            /* =========================
               ITEMS
            ========================= */
            JsonArray items = new JsonArray();
            for (OrderDetail detail : order.getOrderDetails()) {
                JsonObject item = new JsonObject();
                item.addProperty("name", detail.getProduct().getName());
                item.addProperty("quantity", detail.getQuantity());
                item.addProperty("price", (int) detail.getPrice());
                item.addProperty("length", 20);
                item.addProperty("width", 20);
                item.addProperty("height", 10);
                item.addProperty("weight", 500);
                items.add(item);
            }
            json.add("items", items);

            /* =========================
               GỬI REQUEST GHN
            ========================= */
            URL url = new URL("https://dev-online-gateway.ghn.vn/shiip/public-api/v2/shipping-order/create");
            HttpURLConnection conn = (HttpURLConnection) url.openConnection();
            conn.setRequestMethod("POST");
            conn.setRequestProperty("Content-Type", "application/json");
            conn.setRequestProperty("Token", TOKEN);
            conn.setRequestProperty("ShopId", String.valueOf(SHOP_ID));
            conn.setDoOutput(true);

            try (OutputStream os = conn.getOutputStream()) {
                byte[] input = gson.toJson(json).getBytes(StandardCharsets.UTF_8);
                os.write(input, 0, input.length);
            }

            BufferedReader br;
            if (conn.getResponseCode() >= 200 && conn.getResponseCode() < 300) {
                br = new BufferedReader(new InputStreamReader(conn.getInputStream()));
            } else {
                br = new BufferedReader(new InputStreamReader(conn.getErrorStream()));
            }

            StringBuilder res = new StringBuilder();
            String line;
            while ((line = br.readLine()) != null) {
                res.append(line);
            }

            System.out.println("GHN RESPONSE = " + res);
            JsonObject result = gson.fromJson(res.toString(), JsonObject.class);
            int code = result.get("code").getAsInt();

            if (code == 200) {
                String ghnCode = result.getAsJsonObject("data").get("order_code").getAsString();
                orderDAO.updateGhnCode(orderId, ghnCode);
                orderDAO.shippingOrder(orderId);
                response.sendRedirect(request.getContextPath() + "/admin/orders");
            } else {
                response.setContentType("application/json");
                response.getWriter().write(result.toString());
            }

        } catch (Exception e) {
            e.printStackTrace();
            response.getWriter().write("Lỗi: " + e.getMessage());
        }
    }
}