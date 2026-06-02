package com.shop.sportstore.controller.client;

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

@WebServlet("/api/chat-client")
public class ChatClientController extends HttpServlet {

    private final ChatDAO chatDAO = new ChatDAO();

    @Override
    protected void doGet(HttpServletRequest request,
                         HttpServletResponse response)
            throws ServletException, IOException {

        response.setContentType("application/json;charset=UTF-8");
        response.setCharacterEncoding("UTF-8");

        PrintWriter out = response.getWriter();

        try {

            String customerId = request.getParameter("customerId");

            if (customerId == null || customerId.trim().isEmpty()) {
                out.print("[]");
                return;
            }

            List<ChatMessage> messages =
                    chatDAO.getMessagesByCustomer(customerId);

            out.print(convertToJson(messages));

        } catch (Exception e) {

            e.printStackTrace();

            out.print("{\"success\":false,\"message\":\"Server Error\"}");
        }

        out.flush();
    }

    @Override
    protected void doPost(HttpServletRequest request,
                          HttpServletResponse response)
            throws ServletException, IOException {

        request.setCharacterEncoding("UTF-8");

        response.setContentType("application/json;charset=UTF-8");
        response.setCharacterEncoding("UTF-8");

        PrintWriter out = response.getWriter();

        try {

            String customerId = request.getParameter("customerId");
            String message = request.getParameter("message");

            if (customerId == null || customerId.trim().isEmpty()
                    || message == null || message.trim().isEmpty()) {

                out.print(
                        "{\"success\":false,\"message\":\"Invalid data\"}"
                );
                return;
            }

            ChatMessage chatMessage =
                    new ChatMessage(customerId,
                            "CUSTOMER",
                            message.trim());

            boolean success =
                    chatDAO.saveMessage(chatMessage);

            out.print("{\"success\":" + success + "}");

        } catch (Exception e) {

            e.printStackTrace();

            out.print(
                    "{\"success\":false,\"message\":\"Server Error\"}"
            );
        }

        out.flush();
    }

    private String convertToJson(List<ChatMessage> list) {

        StringBuilder json = new StringBuilder("[");

        for (int i = 0; i < list.size(); i++) {

            ChatMessage m = list.get(i);

            json.append("{")
                    .append("\"id\":").append(m.getId()).append(",")
                    .append("\"customerId\":\"")
                    .append(escapeJson(m.getCustomerId()))
                    .append("\",")
                    .append("\"sender\":\"")
                    .append(escapeJson(m.getSender()))
                    .append("\",")
                    .append("\"text\":\"")
                    .append(escapeJson(m.getMessage()))
                    .append("\"")
                    .append("}");

            if (i < list.size() - 1) {
                json.append(",");
            }
        }

        json.append("]");

        return json.toString();
    }

    private String escapeJson(String text) {

        if (text == null) {
            return "";
        }

        return text
                .replace("\\", "\\\\")
                .replace("\"", "\\\"")
                .replace("\n", "\\n")
                .replace("\r", "\\r")
                .replace("\t", "\\t");
    }
}