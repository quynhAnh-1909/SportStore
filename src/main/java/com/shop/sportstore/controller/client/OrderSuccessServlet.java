package com.shop.sportstore.controller.client;

import com.shop.sportstore.dao.OrderDAO;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;

import java.io.IOException;
import java.util.List;
import java.util.Map;

@WebServlet("/orderSuccess")
public class OrderSuccessServlet extends HttpServlet {
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {


        String orderCode = (String) request.getSession().getAttribute("orderCode");
        if (orderCode == null) {
            response.sendRedirect(request.getContextPath() + "/");
            return;
        }

        try {
            OrderDAO orderDAO = new OrderDAO();
            Map<String, String> orderData = orderDAO.getOrderDetailForEmail(orderCode);
            List<Map<String, String>> orderItems = orderDAO.getOrderItems(orderCode);
            request.setAttribute("order", orderData); // truyền vào JSP
            request.setAttribute("items", orderItems);
            request.getSession().removeAttribute("orderCode"); // xóa session
        } catch (Exception e) {
            e.printStackTrace();
        }

        request.getRequestDispatcher("/WEB-INF/client/orderSuccess.jsp")
                .forward(request, response);
    }
}