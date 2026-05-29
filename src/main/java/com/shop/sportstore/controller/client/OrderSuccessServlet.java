package com.shop.sportstore.controller.client;

import com.shop.sportstore.dao.OrderDAO;
import com.shop.sportstore.model.Order;
import com.shop.sportstore.model.OrderItem;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;

import java.io.IOException;
import java.util.List;

@WebServlet("/orderSuccess")
public class OrderSuccessServlet extends HttpServlet {

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        try {
            String orderCode = request.getParameter("orderCode");
            String vnpResponseCode = request.getParameter("vnp_ResponseCode");

            if (orderCode == null || orderCode.isEmpty()) {
                response.sendRedirect(request.getContextPath() + "/");
                return;
            }

            OrderDAO orderDAO = new OrderDAO();
            Order order = orderDAO.getOrderByCode(orderCode);

            if (order == null) {
                response.sendRedirect(request.getContextPath() + "/");
                return;
            }

            List<OrderItem> items = orderDAO.getOrderItems(orderCode);

            request.setAttribute("order", order);
            request.setAttribute("items", items);

            if (vnpResponseCode != null) {
                request.setAttribute("status", "00".equals(vnpResponseCode) ? "PAID" : "FAILED");
            } else {
                if ("COD".equalsIgnoreCase(order.getPaymentMethod())) {
                    request.setAttribute("status", "COD");
                }
            }

            request.getRequestDispatcher("/WEB-INF/client/orderSuccess.jsp")
                    .forward(request, response);

        } catch (Exception e) {
            e.printStackTrace();
            response.sendError(HttpServletResponse.SC_INTERNAL_SERVER_ERROR, "Lỗi xử lý hóa đơn");
        }
    }
}