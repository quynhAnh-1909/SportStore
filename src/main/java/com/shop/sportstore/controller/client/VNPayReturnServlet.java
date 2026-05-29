package com.shop.sportstore.controller.client;

import com.shop.sportstore.dao.OrderDAO;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.*;

import java.io.IOException;
import java.util.ArrayList;

@WebServlet("/vnpay-return")
public class VNPayReturnServlet extends HttpServlet {

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        HttpSession session = request.getSession();

        try {
            String responseCode = request.getParameter("vnp_ResponseCode");
            String orderCode = request.getParameter("vnp_TxnRef");

            if (orderCode == null || orderCode.isEmpty()) {
                response.sendRedirect(request.getContextPath() + "/");
                return;
            }

            OrderDAO orderDAO = new OrderDAO();
            String status;
            boolean isPaymentSuccess = "00".equals(responseCode);

            if (isPaymentSuccess) {
                status = "PENDING";
                orderDAO.updatePaymentStatus(orderCode, true);

                session.setAttribute("cart", new ArrayList<>());
                session.removeAttribute("checkoutItems");
                session.removeAttribute("checkoutVoucherId");
            } else {
                status = "CANCELLED";
                orderDAO.updatePaymentStatus(orderCode, false);
            }

            orderDAO.updateOrderStatus(orderCode, status);

            response.sendRedirect(request.getContextPath() + "/orderSuccess?orderCode=" + orderCode + "&vnp_ResponseCode=" + responseCode);

        }  catch (Exception e) {
        e.printStackTrace();
        response.setContentType("text/html;charset=UTF-8");
        response.getWriter().println("<h1>Hệ thống gặp lỗi tại VNPayReturn: " + e.getMessage() + "</h1>");
        response.sendRedirect(request.getContextPath() + "/");
    }
        }
        }