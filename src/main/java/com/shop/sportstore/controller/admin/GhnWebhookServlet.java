package com.shop.sportstore.controller.admin;

import com.shop.sportstore.dao.OrderDAO;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import org.json.JSONObject;
import java.io.BufferedReader;
import java.io.IOException;

@WebServlet("/ghn-webhook")
public class GhnWebhookServlet extends HttpServlet {
    private static final long serialVersionUID = 1L;

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        response.setHeader("ngrok-skip-browser-warning", "true");
        response.setHeader("Access-Control-Allow-Origin", "*");
        response.setContentType("application/json");
        response.setCharacterEncoding("UTF-8");

        StringBuilder sb = new StringBuilder();
        String line;

        try (BufferedReader reader = request.getReader()) {
            while ((line = reader.readLine()) != null) {
                sb.append(line);
            }
        }

        String jsonPayload = sb.toString();
        System.out.println("GHN Webhook Payload: " + jsonPayload);

        if (jsonPayload.trim().isEmpty()) {
            response.setStatus(400);
            response.getWriter().write("{\"success\": false, \"message\": \"Payload empty\"}");
            return;
        }

        try {
            JSONObject jsonObject = new JSONObject(jsonPayload);
            String ghnCode = null;
            String ghnStatus = null;

            if (jsonObject.has("data")) {
                JSONObject dataObject = jsonObject.getJSONObject("data");
                ghnCode = dataObject.optString("OrderCode");
                ghnStatus = dataObject.optString("Status");
            } else {
                ghnCode = jsonObject.optString("OrderCode");
                ghnStatus = jsonObject.optString("Status");
            }

            if (ghnCode == null || ghnCode.isEmpty()) {
                response.setStatus(400);
                response.getWriter().write("{\"success\": false, \"message\": \"OrderCode missing\"}");
                return;
            }

            OrderDAO orderDAO = new OrderDAO();
            boolean isUpdated = false;

            if ("delivered".equalsIgnoreCase(ghnStatus) || "delivered_with_issue".equalsIgnoreCase(ghnStatus)) {
                isUpdated = orderDAO.updateStatusByGhnCode(ghnCode, "DELIVERED");
            } else if ("cancel".equalsIgnoreCase(ghnStatus) || "returned".equalsIgnoreCase(ghnStatus) || "return".equalsIgnoreCase(ghnStatus)) {
                isUpdated = orderDAO.updateStatusByGhnCode(ghnCode, "CANCELLED");
            } else if ("picking".equalsIgnoreCase(ghnStatus) || "storing".equalsIgnoreCase(ghnStatus)) {
                isUpdated = orderDAO.updateStatusByGhnCode(ghnCode, "CONFIRMED");
            } else if ("delivering".equalsIgnoreCase(ghnStatus)) {
                isUpdated = orderDAO.updateStatusByGhnCode(ghnCode, "SHIPPING");
            } else {
                isUpdated = true;
            }

            if (isUpdated) {
                response.setStatus(200);
                response.getWriter().write("{\"success\": true}");
            } else {
                response.setStatus(500);
                response.getWriter().write("{\"success\": false, \"message\": \"Database update failed\"}");
            }

        } catch (Exception e) {
            e.printStackTrace();
            response.setStatus(500);
            response.getWriter().write("{\"success\": false, \"error\": \"" + e.getMessage() + "\"}");
        }
    }
}