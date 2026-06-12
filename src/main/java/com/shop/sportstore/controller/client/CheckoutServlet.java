package com.shop.sportstore.controller.client;

import com.shop.sportstore.dao.OrderDAO;
import com.shop.sportstore.dao.VoucherDAO;
import com.shop.sportstore.model.CartItem;
import com.shop.sportstore.model.Voucher;
import com.shop.sportstore.model.User;
import com.shop.sportstore.untils.DBConnection;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
import java.io.IOException;
import java.sql.Connection;
import java.sql.PreparedStatement;
import java.util.ArrayList;
import java.util.Arrays;
import java.util.List;

@WebServlet("/checkout")
public class CheckoutServlet extends HttpServlet {

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        HttpSession session = request.getSession();
        User user = (User) session.getAttribute("user");
        if (user == null) {
            response.sendRedirect(request.getContextPath() + "/login");
            return;
        }

        String type = request.getParameter("type");
        List<CartItem> cart = "buyNow".equals(type)
                ? (List<CartItem>) session.getAttribute("buyNowItems")
                : (List<CartItem>) session.getAttribute("cart");

        if (cart == null || cart.isEmpty()) {
            response.sendRedirect(request.getContextPath() + "/cart");
            return;
        }

        String selectedIds = request.getParameter("selectedIds");
        List<CartItem> selectedItems = new ArrayList<>();
        if (selectedIds != null && !selectedIds.isEmpty()) {
            List<Integer> ids = Arrays.stream(selectedIds.split(",")).map(Integer::parseInt).toList();
            for (CartItem item : cart) {
                if (ids.contains(item.getProduct().getId())) {
                    selectedItems.add(item);
                }
            }
        } else {
            selectedItems = cart;
        }

        double subtotal = selectedItems.stream()
                .mapToDouble(item -> item.getProduct().getPrice() * item.getQuantity())
                .sum();
        request.setAttribute("subtotal", subtotal);

        try (Connection conn = DBConnection.getConnection()) {
            VoucherDAO voucherDAO = new VoucherDAO(conn);


            Voucher matchedVoucher = voucherDAO.getAutomaticVoucherByTier(user.getUserId(), user.getTierName());
            double rankDiscount = 0;

            if (matchedVoucher != null) {
                request.setAttribute("appliedVoucher", matchedVoucher);
                if ("PERCENT".equalsIgnoreCase(matchedVoucher.getDiscountType())) {
                    rankDiscount = subtotal * matchedVoucher.getDiscountValue() / 100.0;
                    if (matchedVoucher.getMaxDiscount() > 0 && rankDiscount > matchedVoucher.getMaxDiscount()) {
                        rankDiscount = matchedVoucher.getMaxDiscount();
                    }
                } else {
                    rankDiscount = matchedVoucher.getDiscountValue();
                }
                request.setAttribute("voucherDiscount", rankDiscount);
            } else {
                request.setAttribute("appliedVoucher", null);
                request.setAttribute("voucherDiscount", 0.0);
            }


            List<Voucher> filteredVouchers = voucherDAO.getAllActiveVouchersForSelect();
            request.setAttribute("vouchers", filteredVouchers);

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
        User user = (User) session.getAttribute("user");

        if (userId == null || user == null) {
            response.sendRedirect(request.getContextPath() + "/login");
            return;
        }

        String type = request.getParameter("type");
        List<CartItem> cart = "buyNow".equals(type)
                ? (List<CartItem>) session.getAttribute("buyNowItems")
                : (List<CartItem>) session.getAttribute("cart");

        String selectedIds = request.getParameter("selectedIds");
        List<CartItem> selectedCart = new ArrayList<>();

        if (cart != null && selectedIds != null && !selectedIds.isEmpty()) {
            List<Integer> ids = Arrays.stream(selectedIds.split(",")).map(Integer::parseInt).toList();
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
        String paymentMethod = request.getParameter("paymentMethod");
        String note = request.getParameter("note");
        String fullAddress = request.getParameter("shippingAddress") + ", " + request.getParameter("ward") + ", " + request.getParameter("district") + ", " + request.getParameter("province");

        int districtId = 0;
        try { districtId = Integer.parseInt(request.getParameter("districtId")); } catch (Exception e) {}
        String wardCode = request.getParameter("wardCode");

        double subtotal = selectedCart.stream().mapToDouble(item -> item.getProduct().getPrice() * item.getQuantity()).sum();
        double shippingFee = 30000;
        try { shippingFee = Double.parseDouble(request.getParameter("shippingFee")); } catch (Exception e) {}

        double totalDiscount = 0;
        Integer normalVoucherId = null;
        Integer rankVoucherId = null;

        String voucherRaw = request.getParameter("voucherId");
        String rankVoucherRaw = request.getParameter("rankVoucherId");

        try (Connection conn = DBConnection.getConnection()) {
            VoucherDAO voucherDAO = new VoucherDAO(conn);


            if (rankVoucherRaw != null && !rankVoucherRaw.isEmpty()) {
                rankVoucherId = Integer.parseInt(rankVoucherRaw);
                Voucher rv = voucherDAO.findById(rankVoucherId);
                if (rv != null) {
                    if ("PERCENT".equalsIgnoreCase(rv.getDiscountType())) {
                        double d = subtotal * rv.getDiscountValue() / 100.0;
                        totalDiscount += (rv.getMaxDiscount() > 0 && d > rv.getMaxDiscount()) ? rv.getMaxDiscount() : d;
                    } else {
                        totalDiscount += rv.getDiscountValue();
                    }
                }
            }


            if (voucherRaw != null && !voucherRaw.isEmpty()) {
                normalVoucherId = Integer.parseInt(voucherRaw);
                Voucher nv = voucherDAO.findById(normalVoucherId);
                if (nv != null) {
                    if ("PERCENT".equalsIgnoreCase(nv.getDiscountType())) {
                        double d = subtotal * nv.getDiscountValue() / 100.0;
                        totalDiscount += (nv.getMaxDiscount() > 0 && d > nv.getMaxDiscount()) ? nv.getMaxDiscount() : d;
                    } else {
                        totalDiscount += nv.getDiscountValue();
                    }
                }
            }
        } catch (Exception e) {
            e.printStackTrace();
        }

        double total = subtotal - totalDiscount + shippingFee;
        if (total < 0) total = 0;

        String orderCode = "ORD" + System.currentTimeMillis();

        try {
            OrderDAO orderDAO = new OrderDAO();
            orderDAO.createOrder(
                    userId, orderCode, total, paymentMethod, "PENDING",
                    receiverName, receiverPhone, fullAddress, districtId,
                    wardCode, note, normalVoucherId, totalDiscount, shippingFee, selectedCart
            );

            try (Connection conn = DBConnection.getConnection()) {
                VoucherDAO voucherDAO = new VoucherDAO(conn);

                if (normalVoucherId != null) {
                    voucherDAO.updateUsed(normalVoucherId);
                }

                if (rankVoucherId != null) {
                    voucherDAO.updateUsed(rankVoucherId);

                    String queryOrderId = "SELECT Id FROM orders WHERE OrderCode = ?";
                    String insertUserVoucher = "INSERT INTO user_vouchers (user_id, voucher_id, order_id) VALUES (?, ?, ?)";
                    try (PreparedStatement psGetId = conn.prepareStatement(queryOrderId)) {
                        psGetId.setString(1, orderCode);
                        var rs = psGetId.executeQuery();
                        if (rs.next()) {
                            int generatedOrderId = rs.getInt("Id");
                            try (PreparedStatement psLog = conn.prepareStatement(insertUserVoucher)) {
                                psLog.setInt(1, user.getUserId());
                                psLog.setInt(2, rankVoucherId);
                                psLog.setInt(3, generatedOrderId);
                                psLog.executeUpdate();
                            }
                        }
                    }
                }
            }

            if (!"buyNow".equals(type) && cart != null) {
                cart.removeAll(selectedCart);
                session.setAttribute("cart", cart);
            }

            if ("VNPAY".equalsIgnoreCase(paymentMethod)) {
                session.setAttribute("paymentAmount", total);
                session.setAttribute("pendingOrderCode", orderCode);
                response.sendRedirect(request.getContextPath() + "/vnpayPayment");
                return;
            }

            response.sendRedirect(request.getContextPath() + "/orderSuccess?orderCode=" + orderCode);

        } catch (Exception e) {
            e.printStackTrace();
            response.setContentType("text/html;charset=UTF-8");
            response.getWriter().println("<h2>Lỗi tạo đơn hàng: " + e.getMessage() + "</h2>");
        }
    }
}