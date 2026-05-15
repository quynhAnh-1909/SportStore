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

        String status = request.getParameter("status");

        List<Order> orders;
        if (status == null || status.isEmpty()) {

            orders = orderDAO.getAllOrders();

        } else {
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
}
