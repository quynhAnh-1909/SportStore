package com.shop.sportstore.controller.client;

import com.shop.sportstore.dao.OrderDAO;
import com.shop.sportstore.model.Order;
import com.shop.sportstore.model.User;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.*;

import java.io.IOException;
import java.util.List;
import java.util.stream.Collectors;

@WebServlet("/order-history")
public class OrderHistoryServlet extends HttpServlet {

    private final OrderDAO orderDAO = new OrderDAO();

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        HttpSession session = request.getSession(false);
        User user = (session != null) ? (User) session.getAttribute("user") : null;

        if (user == null) {
            response.sendRedirect(request.getContextPath() + "/login.jsp");
            return;
        }
        List<Order> allOrders = orderDAO.getOrdersByUser(user.getUserId());
        String statusParam = request.getParameter("status");
        if (statusParam == null || statusParam.trim().isEmpty()) {
            statusParam = "ALL";
        } else {
            statusParam = statusParam.trim().toUpperCase();
        }
        List<Order> filteredOrders;
        switch (statusParam) {
            case "PENDING":
                filteredOrders = allOrders.stream()
                        .filter(o -> "PENDING".equalsIgnoreCase(o.getStatus())
                                || "CONFIRMED".equalsIgnoreCase(o.getStatus())
                                || "0".equalsIgnoreCase(o.getStatus())
                                || "CHỜ XÁC NHẬN".equalsIgnoreCase(o.getStatus()))
                        .collect(Collectors.toList());
                break;

            case "SHIPPING":
                filteredOrders = allOrders.stream()
                        .filter(o -> "SHIPPING".equalsIgnoreCase(o.getStatus())
                                || "ĐANG GIAO".equalsIgnoreCase(o.getStatus()))
                        .collect(Collectors.toList());
                break;

            case "COMPLETED":
                filteredOrders = allOrders.stream()
                        .filter(o -> "COMPLETED".equalsIgnoreCase(o.getStatus())
                                || "HOÀN TẤT".equalsIgnoreCase(o.getStatus()))
                        .collect(Collectors.toList());
                break;

            case "CANCELLED":
                filteredOrders = allOrders.stream()
                        .filter(o -> "CANCELLED".equalsIgnoreCase(o.getStatus())
                                || "ĐÃ HỦY".equalsIgnoreCase(o.getStatus()))
                        .collect(Collectors.toList());
                break;

            case "REFUND":
                filteredOrders = allOrders.stream()
                        .filter(o -> o.getRefundStatus() != null && !o.getRefundStatus().trim().isEmpty())
                        .collect(Collectors.toList());
                break;

            default:
                filteredOrders = allOrders;
                break;
        }
        request.setAttribute("orders", filteredOrders);
        request.setAttribute("currentStatus", statusParam);

        request.getRequestDispatcher("/WEB-INF/client/account.jsp")
                .forward(request, response);
    }
}