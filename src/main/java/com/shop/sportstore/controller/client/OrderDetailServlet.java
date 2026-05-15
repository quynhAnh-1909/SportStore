package com.shop.sportstore.controller.client;

import com.shop.sportstore.dao.OrderDAO;
import com.shop.sportstore.dao.OrderDetailDAO;
import com.shop.sportstore.model.Order;
import com.shop.sportstore.model.OrderDetail;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.*;

import java.io.IOException;
import java.util.List;

@WebServlet("/order-detail")
public class OrderDetailServlet extends HttpServlet {

    private final OrderDAO orderDAO =
            new OrderDAO();

    private final OrderDetailDAO detailDAO =
            new OrderDetailDAO();

    @Override

    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        try {
            int orderId = Integer.parseInt(request.getParameter("id"));
            Order order = orderDAO.getOrderById(orderId);

            System.out.println("====== KIỂM TRA ĐƠN HÀNG ======");
            System.out.println("Đơn hàng tìm thấy: " + order);
            if (order != null) {
                System.out.println("Mã đơn: " + order.getOrderCode());
                System.out.println("Số lượng SP: " + (order.getOrderDetails() != null ? order.getOrderDetails().size() : 0));
            }
            System.out.println("===============================");

            if (order != null) {
                request.setAttribute("order", order);
                request.getRequestDispatcher("/user/order-detail.jsp").forward(request, response);
            } else {
                response.sendRedirect("order-history");
            }
        } catch (Exception e) {
            e.printStackTrace();
            response.sendRedirect("order-history");
        }
    }
}