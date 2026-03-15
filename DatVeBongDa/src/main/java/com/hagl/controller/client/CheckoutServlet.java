package com.hagl.controller.client;

import com.hagl.dao.OrderDAO;
import com.hagl.model.CartItem;

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.*;

import java.io.IOException;
import java.util.List;

@WebServlet("/checkout")
public class CheckoutServlet extends HttpServlet {

    /* =====================
       HIỂN THỊ TRANG CHECKOUT
    ===================== */

    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        request.getRequestDispatcher("/WEB-INF/views/client/checkout.jsp")
                .forward(request, response);
    }

    /* =====================
       XỬ LÝ ĐẶT HÀNG
    ===================== */

    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        HttpSession session = request.getSession();

        List<CartItem> cart = (List<CartItem>) session.getAttribute("cart");

        if (cart == null || cart.isEmpty()) {
            response.sendRedirect("cart");
            return;
        }

        /* =====================
           LẤY THÔNG TIN FORM
        ===================== */

        String receiverName = request.getParameter("receiverName");
        String receiverPhone = request.getParameter("receiverPhone");
        String address = request.getParameter("address");
        String note = request.getParameter("note");
        String paymentMethod = request.getParameter("paymentMethod");

        Integer userId = (Integer) session.getAttribute("userId");

        /* =====================
           TÍNH TỔNG TIỀN
        ===================== */

        double total = 0;

        for (CartItem item : cart) {
            total += item.getProduct().getPrice() * item.getQuantity();
        }

        total += 30000; // phí ship

        /* =====================
           TẠO ORDER CODE
        ===================== */

        String orderCode = "ORD" + System.currentTimeMillis();

        try {

            OrderDAO orderDAO = new OrderDAO();

            orderDAO.createOrder(
                    userId,
                    orderCode,
                    total,
                    paymentMethod,
                    "Pending",
                    cart
            );

        } catch (Exception e) {
            e.printStackTrace();
        }

        /* =====================
           NẾU VNPAY
        ===================== */

        if ("VNPAY".equals(paymentMethod)) {

            session.setAttribute("orderCode", orderCode);

            response.sendRedirect(request.getContextPath() + "/vnpayPayment");

            return;
        }

        /* =====================
           NẾU COD
        ===================== */

        session.removeAttribute("cart");

        response.sendRedirect(request.getContextPath() + "/orderSuccess");
    }
}