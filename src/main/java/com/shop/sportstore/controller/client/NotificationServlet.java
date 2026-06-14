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
                        .append("\"title\":\"").append(n.getTitle().replace("\"", "\\\"")).append("\",")
                        .append("\"content\":\"").append(n.getContent().replace("\"", "\\\"")).append("\",")
                        .append("\"linkUrl\":\"").append(n.getLinkUrl()).append("\",")
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
}