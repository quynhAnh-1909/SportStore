package com.shop.sportstore.controller.client;

import com.shop.sportstore.dao.OrderDAO;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.*;

import java.io.IOException;

@WebServlet("/vnpay-return")
public class VNPayReturnServlet extends HttpServlet {

    @Override
    protected void doGet(HttpServletRequest request,
                         HttpServletResponse response)
            throws ServletException, IOException {

        String responseCode =
                request.getParameter("vnp_ResponseCode");

        String transactionStatus =
                request.getParameter("vnp_TransactionStatus");

        String orderCode =
                request.getParameter("vnp_TxnRef");

        try {

            OrderDAO orderDAO = new OrderDAO();

            if ("00".equals(responseCode)
                    && "00".equals(transactionStatus)) {

                orderDAO.updateOrderStatus(
                        orderCode,
                        "PAID"
                );

            } else {

                orderDAO.updateOrderStatus(
                        orderCode,
                        "FAILED"
                );
            }

            response.sendRedirect(
                    request.getContextPath() + "/orderSuccess"
            );

        } catch (Exception e) {

            e.printStackTrace();

            response.getWriter().println(
                    "Lỗi xử lý callback VNPay"
            );
        }
    }
}