package com.shop.sportstore.controller.client;

import com.shop.sportstore.dao.OrderDAO;
import com.shop.sportstore.model.CartItem;
import jakarta.servlet.ServletException;
import jakarta.servlet.ServletRequestWrapper;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;

import java.io.IOException;
import java.util.ArrayList;
import java.util.Arrays;
import java.util.List;

@WebServlet("/checkout")
public class CheckoutServlet extends HttpServlet {

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        HttpSession session = request.getSession();

        String selectedIds = request.getParameter("selectedIds");

        List<CartItem> cart = (List<CartItem>) session.getAttribute("cart");

        List<CartItem> selectedItems = new ArrayList<>();

        if (selectedIds != null && !selectedIds.isEmpty()) {

            List<Integer> ids = Arrays.stream(selectedIds.split(","))
                    .map(Integer::parseInt)
                    .toList();

            for (CartItem item : cart) {
                if (ids.contains(item.getProduct().getId())) {
                    selectedItems.add(item);
                }
            }

        } else {
            selectedItems = cart;
        }

        request.setAttribute("selectedItems", selectedItems);

        request.getRequestDispatcher("/WEB-INF/client/checkout.jsp")
                .forward(request, response);
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        HttpSession session = request.getSession();

        String selectedIds = request.getParameter("selectedIds");

        List<CartItem> cart = (List<CartItem>) session.getAttribute("cart");

        List<CartItem> selectedItems = new ArrayList<>();

        if (selectedIds != null && !selectedIds.isEmpty()) {

            List<Integer> ids = Arrays.stream(selectedIds.split(","))
                    .map(Integer::parseInt)
                    .toList();

            for (CartItem item : cart) {
                if (ids.contains(item.getProduct().getId())) {
                    selectedItems.add(item);
                }
            }

        } else {
            selectedItems = cart; // fallback
        }

        request.setAttribute("selectedItems", selectedItems);

        String selectedIdsStr = request.getParameter("selectedIds");

        List<CartItem> selectedCart = new ArrayList<>();

        if (cart != null && selectedIdsStr != null && !selectedIdsStr.isEmpty()) {

            String[] ids = selectedIdsStr.split(",");

            for (CartItem item : cart) {
                for (String id : ids) {
                    if (item.getProduct().getId() == Integer.parseInt(id)) {
                        selectedCart.add(item);
                    }
                }
            }
        }

        if (selectedCart.isEmpty()) {
            response.sendRedirect(request.getContextPath() + "/cart");
            return;
        }

        // Lấy thông tin form
        String receiverName = request.getParameter("receiverName");
        String receiverPhone = request.getParameter("receiverPhone");
        String address = request.getParameter("address");
        String note = request.getParameter("note");
        String paymentMethod = request.getParameter("paymentMethod");

        Integer userId = (Integer) session.getAttribute("userId");
        if (userId == null) {
            response.sendRedirect(request.getContextPath() + "/login");
            return;
        }

        // Tính tổng
        double total = 0;
        for (CartItem item : selectedCart) {
            if (item.getProduct() != null) {
                total += item.getProduct().getPrice() * item.getQuantity();
            }
        }
        total += 30000; // phí ship

        String orderCode = "ORD" + System.currentTimeMillis();

        try {
            OrderDAO orderDAO = new OrderDAO();
            orderDAO.createOrder(userId, orderCode, total, "Pending", note, selectedCart);
        } catch (Exception e) {
            e.printStackTrace();
            response.sendError(500, "Đặt hàng thất bại. Vui lòng thử lại.");
            return;
        }

        // Nếu VNPay
        if ("VNPAY".equalsIgnoreCase(paymentMethod)) {
            session.setAttribute("orderCode", orderCode);
            response.sendRedirect(request.getContextPath() + "/vnpayPayment");
            return;
        }

        // COD
        session.removeAttribute("cart");
        session.setAttribute("lastOrderCode", orderCode);
        session.setAttribute("lastTotal", total + 30000);
        request.getRequestDispatcher("/WEB-INF/client/orderSuccess.jsp")
                .forward(request, response);
    }
}