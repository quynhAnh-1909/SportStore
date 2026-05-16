package com.shop.sportstore.controller.client;

import com.shop.sportstore.dao.OrderDAO;
import com.shop.sportstore.model.Order;
import com.shop.sportstore.model.OrderItem;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.*;

import java.io.IOException;
import java.util.List;

@WebServlet("/vnpay-return")
public class VNPayReturnServlet extends HttpServlet {

    @Override
    protected void doGet(HttpServletRequest request,
                         HttpServletResponse response)
            throws ServletException, IOException {

        try {

            // ===== 1. LẤY PARAM TỪ VNPay =====
            String responseCode = request.getParameter("vnp_ResponseCode");
            String orderCode = request.getParameter("vnp_TxnRef");

            if (orderCode == null || orderCode.isEmpty()) {
                throw new Exception("Missing orderCode from VNPay callback");
            }

            // ===== 2. DAO =====
            OrderDAO orderDAO = new OrderDAO();

            // ===== 3. UPDATE STATUS =====
            String status;

            if ("00".equals(responseCode)) {
                status = "PAID";
            } else {
                status = "FAILED";
            }

            orderDAO.updateOrderStatus(orderCode, status);

            // ===== 4. LOAD DATA FROM DB =====
            Order order = orderDAO.getOrderByCode(orderCode);
            List<OrderItem> items = orderDAO.getOrderItems(orderCode);

            if (order == null) {
                throw new Exception("Order not found: " + orderCode);
            }

            // ===== 5. SET ATTRIBUTE FOR JSP =====
            request.setAttribute("order", order);
            request.setAttribute("items", items);
            request.setAttribute("status", status);

            // ===== 6. FORWARD TO SUCCESS PAGE =====
            request.getRequestDispatcher("/WEB-INF/client/orderSuccess.jsp")
                    .forward(request, response);

        } catch (Exception e) {

            e.printStackTrace();

            request.setAttribute("status", "FAILED");
            request.setAttribute("message", "Lỗi xử lý thanh toán VNPay");

            request.getRequestDispatcher("/WEB-INF/client/orderSuccess.jsp")
                    .forward(request, response);
        }
    }
}