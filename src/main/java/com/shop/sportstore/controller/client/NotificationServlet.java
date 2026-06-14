package com.shop.sportstore.controller.client;

import com.shop.sportstore.dao.NotificationDAO;
import com.shop.sportstore.model.Notification;
import com.shop.sportstore.model.User;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
import java.io.IOException;
import java.io.PrintWriter;
import java.util.List;

@WebServlet("/notifications")
public class NotificationServlet extends HttpServlet {
    private static final long serialVersionUID = 1L;
    private final NotificationDAO notificationDAO = new NotificationDAO();

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        response.setContentType("application/json;charset=UTF-8");
        String action = request.getParameter("action");
        HttpSession session = request.getSession();
        User user = (User) session.getAttribute("user");

        if (user == null) {
            try (PrintWriter out = response.getWriter()) {
                out.print("[]");
            }
            return;
        }

        if ("list".equals(action)) {
            List<Notification> list = notificationDAO.getNotificationsByUserId(user.getUserId());

            StringBuilder json = new StringBuilder("[");
            for (int i = 0; i < list.size(); i++) {
                Notification n = list.get(i);
                json.append("{")
                        .append("\"id\":").append(n.getId()).append(",")
                        .append("\"title\":\"").append(escapeJson(n.getTitle())).append("\",")
                        .append("\"content\":\"").append(escapeJson(n.getContent())).append("\",")
                        .append("\"linkUrl\":\"").append(escapeJson(n.getLinkUrl())).append("\",")
                        .append("\"isRead\":").append(n.isRead())
                        .append("}");
                if (i < list.size() - 1) json.append(",");
            }
            json.append("]");

            try (PrintWriter out = response.getWriter()) {
                out.print(json.toString());
            }
        }
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        String action = request.getParameter("action");
        HttpSession session = request.getSession();
        User user = (User) session.getAttribute("user");

        if (user == null) {
            response.setStatus(HttpServletResponse.SC_UNAUTHORIZED);
            return;
        }

        if ("read".equals(action)) {
            int id = Integer.parseInt(request.getParameter("id"));
            notificationDAO.markAsRead(id);
        } else if ("readAll".equals(action)) {
            notificationDAO.markAllAsRead(user.getUserId());
        }
    }

    private String escapeJson(String input) {
        if (input == null) return "";
        StringBuilder sb = new StringBuilder();
        for (int i = 0; i < input.length(); i++) {
            char ch = input.charAt(i);
            switch (ch) {
                case '"' -> sb.append("\\\"");
                case '\\' -> sb.append("\\\\");
                case '/' -> sb.append("\\/");
                case '\b' -> sb.append("\\b");
                case '\f' -> sb.append("\\f");
                case '\n' -> sb.append("\\n");
                case '\r' -> sb.append("\\r");
                case '\t' -> sb.append("\\t");
                default -> {
                    if (ch < ' ') {
                        String t = "000" + Integer.toHexString(ch);
                        sb.append("\\u").append(t.substring(t.length() - 4));
                    } else {
                        sb.append(ch);
                    }
                }
            }
        }
        return sb.toString();
    }
}