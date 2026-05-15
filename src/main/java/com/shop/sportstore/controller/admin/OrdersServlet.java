package com.shop.sportstore.controller.admin;

import com.shop.sportstore.dao.OrderDAO;
import com.shop.sportstore.model.Order;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.*;

import java.io.IOException;
import java.util.List;

@WebServlet("/admin/orders")
public class OrdersServlet extends HttpServlet {

    private OrderDAO orderDAO;

    @Override
    public void init() throws ServletException {
        orderDAO = new OrderDAO();
    }

    @Override
    protected void doGet(HttpServletRequest request,
                         HttpServletResponse response)
            throws ServletException, IOException {

        // lấy status từ URL
        String status = request.getParameter("status");

        List<Order> orders;

        // nếu không có status -> lấy tất cả
        if (status == null || status.isEmpty()) {

            orders = orderDAO.getAllOrders();

        } else {

            // mapping status sidebar -> DB
            switch (status.toLowerCase()) {

                case "pending":
                    status = "PENDING";
                    break;

                case "pickup":
                    status = "CONFIRMED";
                    break;

                case "shipping":
                    status = "SHIPPING";
                    break;

                case "completed":
                    status = "COMPLETED";
                    break;

                case "cancelled":
                    status = "CANCELLED";
                    break;
            }

            orders = orderDAO.getOrdersByStatus(status);
        }

        request.setAttribute("orders", orders);

        request.setAttribute(
                "contentPage",
                "/WEB-INF/admin/order.jsp"
        );

        request.getRequestDispatcher(
                "/WEB-INF/admin/dashboard.jsp"
        ).forward(request, response);
    }
    private void handleConfirm(HttpServletRequest request) {

        int id = Integer.parseInt(
                request.getParameter("id")
        );

        orderDAO.confirmOrder(id);
    }

    private void handleCancel(HttpServletRequest request) {

        int id = Integer.parseInt(
                request.getParameter("id")
        );

        orderDAO.adminCancelOrder(id);
    }

    private void handleShipping(HttpServletRequest request) {

        int id = Integer.parseInt(
                request.getParameter("id")
        );

        orderDAO.shippingOrder(id);
    }

    private void handleComplete(HttpServletRequest request) {

        int id = Integer.parseInt(
                request.getParameter("id")
        );

        orderDAO.completeOrder(id);
    }

    private void handleConfirmAll() {

        orderDAO.confirmAllPendingOrders();
    }
}