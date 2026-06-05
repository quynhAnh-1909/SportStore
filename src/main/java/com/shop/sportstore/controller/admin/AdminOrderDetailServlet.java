package com.shop.sportstore.controller.admin;

import com.shop.sportstore.dao.OrderDAO;
import com.shop.sportstore.model.Order;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.*;

import java.io.IOException;

@WebServlet("/admin/orders/details")
public class AdminOrderDetailServlet extends HttpServlet {

    private OrderDAO orderDAO;

    @Override
    public void init() {
        orderDAO = new OrderDAO();
    }

    @Override
    protected void doGet(HttpServletRequest request,
                         HttpServletResponse response)
            throws ServletException, IOException {

        String orderCode = request.getParameter("orderCode");
        System.out.println("orderCode = " + orderCode);
        if (orderCode == null || orderCode.isBlank()) {
            response.sendRedirect(
                    request.getContextPath() + "/admin/orders"
            );
            return;
        }


        Order order = orderDAO.getOrderByCode(orderCode);

        System.out.println("order = " + order);

        if(order != null){
            System.out.println("details = " +
                    order.getOrderDetails().size());
        }


        if (order == null) {
            response.sendRedirect(
                    request.getContextPath() + "/admin/orders"
            );
            return;
        }

        request.setAttribute("order", order);

        request.setAttribute(
                "contentPage",
                "/WEB-INF/admin/order-detail.jsp"
        );

        request.getRequestDispatcher(
                "/WEB-INF/admin/layout-admin.jsp"
        ).forward(request, response);
    }
}