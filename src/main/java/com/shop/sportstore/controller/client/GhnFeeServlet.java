package com.shop.sportstore.controller.client;

import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.*;

import java.io.*;
import java.net.HttpURLConnection;
import java.net.URL;
import java.nio.charset.StandardCharsets;

@WebServlet("/api/get-shipping-fee")
public class GhnFeeServlet extends HttpServlet {

    private static final String GHN_TOKEN = "2eb2d430-50e9-11f1-a973-aee5264794df";

    // SHOP CONFIG
    private static final int FROM_DISTRICT_ID = 3440;
    private static final String FROM_WARD_CODE = "21211";

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws IOException {

        response.setContentType("application/json;charset=UTF-8");

        String districtIdRaw = request.getParameter("districtId");
        String wardCode = request.getParameter("wardCode");
        String subtotalRaw = request.getParameter("subtotal");

        // validate input
        if (districtIdRaw == null || wardCode == null
                || districtIdRaw.isEmpty() || wardCode.isEmpty()) {

            response.getWriter().write(
                    "{\"status\":\"error\",\"message\":\"Thiếu districtId hoặc wardCode\"}"
            );
            return;
        }

        int toDistrictId;

        try {
            toDistrictId = Integer.parseInt(districtIdRaw);
        } catch (Exception e) {
            response.getWriter().write(
                    "{\"status\":\"error\",\"message\":\"districtId không hợp lệ\"}"
            );
            return;
        }

        // insurance value
        int insuranceValue = 0;

        try {
            if (subtotalRaw != null) {
                double subtotal = Double.parseDouble(subtotalRaw);
                insuranceValue = (int) Math.min(subtotal, 5000000);
            }
        } catch (Exception ignored) {}

        try {

            // JSON request GHN
            String json = "{"
                    + "\"service_type_id\":2,"
                    + "\"from_district_id\":" + FROM_DISTRICT_ID + ","
                    + "\"from_ward_code\":\"" + FROM_WARD_CODE + "\","
                    + "\"to_district_id\":" + toDistrictId + ","
                    + "\"to_ward_code\":\"" + wardCode + "\","
                    + "\"height\":15,"
                    + "\"length\":20,"
                    + "\"weight\":1000,"
                    + "\"width\":15,"
                    + "\"insurance_value\":" + insuranceValue
                    + "}";

            URL url = new URL(
                    "https://dev-online-gateway.ghn.vn/shiip/public-api/v2/shipping-order/fee"
            );

            HttpURLConnection conn = (HttpURLConnection) url.openConnection();

            conn.setRequestMethod("POST");
            conn.setRequestProperty("Content-Type", "application/json");
            conn.setRequestProperty("Token", GHN_TOKEN);
            conn.setDoOutput(true);

            // send request
            try (OutputStream os = conn.getOutputStream()) {
                os.write(json.getBytes(StandardCharsets.UTF_8));
            }

            // read response safely
            int status = conn.getResponseCode();

            InputStream is = (status >= 200 && status < 300)
                    ? conn.getInputStream()
                    : conn.getErrorStream();

            BufferedReader br = new BufferedReader(
                    new InputStreamReader(is, StandardCharsets.UTF_8)
            );

            StringBuilder result = new StringBuilder();
            String line;

            while ((line = br.readLine()) != null) {
                result.append(line);
            }

            String output = result.toString();

            System.out.println("GHN FEE RESPONSE: " + output);

            response.getWriter().write(output);

        } catch (Exception e) {
            e.printStackTrace();

            response.getWriter().write(
                    "{\"status\":\"error\",\"message\":\"" + e.getMessage() + "\"}"
            );
        }
    }
}