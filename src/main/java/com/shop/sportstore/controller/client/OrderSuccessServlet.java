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

            // ✔ LẤY TỪ REQUEST (chuẩn VNPay flow)
            String orderCode = request.getParameter("orderCode");

            if (orderCode == null || orderCode.isEmpty()) {
                response.sendRedirect(request.getContextPath() + "/");
                return;
            }

            OrderDAO orderDAO = new OrderDAO();

            // ✔ lấy order
            Order order = orderDAO.getOrderByCode(orderCode);

            // ✔ lấy items
            List<OrderItem> items = orderDAO.getOrderItems(orderCode);

            request.setAttribute("order", order);
            request.setAttribute("items", items);

            request.getRequestDispatcher("/WEB-INF/client/orderSuccess.jsp")
                    .forward(request, response);

        } catch (Exception e) {
            e.printStackTrace();
            response.getWriter().println("Lỗi xử lý trang order success");
        }
    }
}