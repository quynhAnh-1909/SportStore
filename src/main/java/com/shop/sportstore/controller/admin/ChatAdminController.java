package com.shop.sportstore.controller.admin;

import com.shop.sportstore.dao.ChatDAO;
import com.shop.sportstore.model.ChatMessage;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import java.io.IOException;
import java.io.PrintWriter;
import java.util.List;

@WebServlet("/api/chat-admin")
public class ChatAdminController extends HttpServlet {
    private final ChatDAO chatDAO = new ChatDAO();

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        response.setContentType("application/json; charset=UTF-8");
        response.setCharacterEncoding("UTF-8");

        String action = request.getParameter("action");
        PrintWriter out = response.getWriter();

        if ("getChatList".equals(action)) {
            List<String> customers = chatDAO.getActiveCustomers();
            StringBuilder json = new StringBuilder("[");
            for (int i = 0; i < customers.size(); i++) {
                json.append("\"").append(customers.get(i)).append("\"");
                if (i < customers.size() - 1) json.append(",");
            }
            json.append("]");
            out.print(json.toString());
        }

        else if ("getDetail".equals(action)) {
            String customerId = request.getParameter("customerId");
            if (customerId != null) {
                List<ChatMessage> list = chatDAO.getMessagesByCustomer(customerId);
                out.print(convertToJson(list));
            }
        }
        out.flush();
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        request.setCharacterEncoding("UTF-8");
        response.setContentType("application/json; charset=UTF-8");

        String customerId = request.getParameter("customerId");
        String message = request.getParameter("message");

        if (customerId != null && message != null && !message.trim().isEmpty()) {
            ChatMessage msg = new ChatMessage(customerId, "ADMIN", message);
            boolean success = chatDAO.saveMessage(msg);
            response.getWriter().print("{\"success\":" + success + "}");
        }
    }

    private String convertToJson(List<ChatMessage> list) {
        StringBuilder json = new StringBuilder("[");
        for (int i = 0; i < list.size(); i++) {
            ChatMessage m = list.get(i);
            String safeMsg = m.getMessage().replace("\"", "\\\"");
            json.append("{")
                    .append("\"id\":").append(m.getId()).append(",")
                    .append("\"customerId\":\"").append(m.getCustomerId()).append("\",")
                    .append("\"sender\":\"").append(m.getSender()).append("\",")
                    .append("\"text\":\"").append(safeMsg).append("\"")
                    .append("}");
            if (i < list.size() - 1) json.append(",");
        }
        json.append("]");
        return json.toString();
    }
}