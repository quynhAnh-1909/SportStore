package com.shop.sportstore.controller.client;

import com.shop.sportstore.dao.OrderDAO;
import com.shop.sportstore.dao.VoucherDAO;
import com.shop.sportstore.model.CartItem;
import com.shop.sportstore.model.Voucher;
import com.shop.sportstore.untils.DBConnection;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;

import java.io.IOException;
import java.sql.Connection;
import java.util.ArrayList;
import java.util.Arrays;
import java.util.List;

@WebServlet("/checkout")
public class CheckoutServlet extends HttpServlet {

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        HttpSession session = request.getSession();
        List<CartItem> cart = (List<CartItem>) session.getAttribute("cart");

        if (cart == null || cart.isEmpty()) {
            response.sendRedirect(request.getContextPath() + "/cart");
            return;
        }
        String selectedIds = request.getParameter("selectedIds");
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


        try (Connection conn = DBConnection.getConnection()) {
            VoucherDAO voucherDAO = new VoucherDAO(conn);
            request.setAttribute("vouchers", voucherDAO.getAll());
        } catch (Exception e) {
            e.printStackTrace();
        }

        request.setAttribute("selectedItems", selectedItems);
        request.getRequestDispatcher("/WEB-INF/client/checkout.jsp").forward(request, response);
    }


    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        HttpSession session = request.getSession();


        Integer userId = (Integer) session.getAttribute("userId");
        if (userId == null) {
            response.sendRedirect(request.getContextPath() + "/login");
            return;
        }


        List<CartItem> cart = (List<CartItem>) session.getAttribute("cart");
        String selectedIds = request.getParameter("selectedIds");
        List<CartItem> selectedCart = new ArrayList<>();

        if (cart != null && selectedIds != null && !selectedIds.isEmpty()) {
            List<Integer> ids = Arrays.stream(selectedIds.split(","))
                    .map(Integer::parseInt)
                    .toList();
            for (CartItem item : cart) {
                if (ids.contains(item.getProduct().getId())) {
                    selectedCart.add(item);
                }
            }
        } else {
            selectedCart = (cart != null) ? cart : new ArrayList<>();
        }

        if (selectedCart.isEmpty()) {
            response.sendRedirect(request.getContextPath() + "/cart");
            return;
        }


        String receiverName = request.getParameter("receiverName");
        String receiverPhone = request.getParameter("receiverPhone");
        String note = request.getParameter("note");
        String paymentMethod = request.getParameter("paymentMethod");

        String specific = request.getParameter("specificAddress");
        String ward = request.getParameter("ward");
        String district = request.getParameter("district");
        String province = request.getParameter("province");


        int districtId = 0;
        String wardCode = "";

        try {
            String districtIdRaw = request.getParameter("districtId");
            if (districtIdRaw != null && !districtIdRaw.isEmpty()) {
                districtId = Integer.parseInt(districtIdRaw);
            }

            String wardCodeRaw = request.getParameter("wardCode");
            if (wardCodeRaw != null && !wardCodeRaw.isEmpty()) {
                wardCode = wardCodeRaw;
            }
        } catch (Exception e) {
            System.err.println("Lỗi nhận mã vùng districtId/wardCode: " + e.getMessage());
        }


        String fullAddress = "";
        if (specific != null && !specific.isBlank()) {
            fullAddress = specific + ", " + ward + ", " + district + ", " + province;
        } else {
            fullAddress = "Chưa có địa chỉ chi tiết";
        }


        double subtotal = 0;
        for (CartItem item : selectedCart) {
            subtotal += item.getProduct().getPrice() * item.getQuantity();
        }

        double discount = 0;
        Integer voucherId = null;
        String vIdRaw = request.getParameter("voucherId");
        if (vIdRaw != null && !vIdRaw.isEmpty()) {
            try {
                voucherId = Integer.parseInt(vIdRaw);

            } catch (NumberFormatException e) {
                voucherId = null;
            }
        }


        double shippingFee = 35000;

        if (province != null && !province.isEmpty()) {
            String provinceLower = province.toLowerCase();
            if (provinceLower.contains("hồ chí minh") || provinceLower.contains("hcm")) {
                shippingFee = 15000;
            } else if (provinceLower.contains("hà nội")) {
                shippingFee = 35000;
            }
        }

        double total = subtotal - discount + shippingFee;
        if (total < 0) total = 0;

        String orderCode = "ORD" + System.currentTimeMillis();

        try {
            OrderDAO orderDAO = new OrderDAO();


            orderDAO.createOrder(
                    userId,
                    orderCode,
                    total,
                    paymentMethod,
                    "PENDING",
                    receiverName,
                    receiverPhone,
                    fullAddress,
                    districtId,
                    wardCode,
                    note,
                    voucherId,
                    discount,
                    shippingFee,
                    selectedCart
            );


            if ("VNPAY".equalsIgnoreCase(paymentMethod)) {

                session.setAttribute("paymentAmount", total);

                session.setAttribute("pendingOrderCode", orderCode);

                response.sendRedirect(
                        request.getContextPath() + "/vnpayPayment"
                );

            } else {

                cart.removeAll(selectedCart);

                session.setAttribute("cart", cart);

                response.sendRedirect(
                        request.getContextPath() + "/orderSuccess"
                );
            }
        } catch (Exception e) {
            e.printStackTrace();
            response.setContentType("text/html;charset=UTF-8");
            response.getWriter().println("<h2>Lỗi tạo đơn hàng trên hệ thống: " + e.getMessage() + "</h2>");
        }
    }
}
