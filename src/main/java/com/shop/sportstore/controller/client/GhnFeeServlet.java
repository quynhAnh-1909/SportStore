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

@WebServlet("/api/get-shipping-fee")
public class GhnFeeServlet extends HttpServlet {

    private static final String GHN_TOKEN = "2eb2d430-50e9-11f1-a973-aee5264794df";

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        response.setContentType("application/json");
        response.setCharacterEncoding("UTF-8");

        String toDistrictId = request.getParameter("districtId");
        String toWardCode = request.getParameter("wardCode");
        String subtotalRaw = request.getParameter("subtotal");

        if (toDistrictId == null || toWardCode == null || toDistrictId.isEmpty() || toWardCode.isEmpty()) {
            response.getWriter().write("{\"status\": error, \"message\": \"Thừa hoặc thiếu tham số\"}");
            return;
        }

        int insuranceValue = 10000;
        try {
            if (subtotalRaw != null && !subtotalRaw.isEmpty()) {
                double subtotal = Double.parseDouble(subtotalRaw);
                insuranceValue = (int) (subtotal > 5000000 ? 5000000 : subtotal);
            }
        } catch (Exception e) {
            insuranceValue = 10000;
        }

        try {

            String jsonInputString = "{"
                    + "\"from_district_id\": 3440,"
                    + "\"from_ward_code\": \"21211\","
                    + "\"service_id\": 53320,"
                    + "\"service_type_id\": null,"
                    + "\"to_district_id\": " + Integer.parseInt(toDistrictId) + ","
                    + "\"to_ward_code\": \"" + toWardCode + "\","
                    + "\"height\": 15,"
                    + "\"length\": 20,"
                    + "\"weight\": 1000,"
                    + "\"width\": 15,"
                    + "\"insurance_value\": " + insuranceValue + ","
                    + "\"cod_failed_amount\": 0,"
                    + "\"coupon\": null,"
                    + "\"items\": [{\"name\": \"Sản phẩm thể thao\", \"quantity\": 1, \"weight\": 1000}]"
                    + "}";

            URL url = new URL("https://online-gateway.ghn.vn/shiip/public-api/v2/shipping-order/fee");
            HttpURLConnection conn = (HttpURLConnection) url.openConnection();
            conn.setRequestMethod("POST");
            conn.setRequestProperty("Content-Type", "application/json; utf-8");
            conn.setRequestProperty("Accept", "application/json");
            conn.setRequestProperty("Token", GHN_TOKEN);
            conn.setDoOutput(true);

            try (OutputStream os = conn.getOutputStream()) {
                byte[] input = jsonInputString.getBytes(StandardCharsets.UTF_8);
                os.write(input, 0, input.length);
            }

            StringBuilder res = new StringBuilder();
            try (BufferedReader br = new BufferedReader(new InputStreamReader(conn.getInputStream(), StandardCharsets.UTF_8))) {
                String responseLine;
                while ((responseLine = br.readLine()) != null) {
                    res.append(responseLine.trim());
                }
            }


            response.getWriter().write(res.toString());

        } catch (Exception e) {
            e.printStackTrace();
            response.getWriter().write("{\"code\": 500, \"message\": \"" + e.getMessage() + "\"}");
        }
    }
}