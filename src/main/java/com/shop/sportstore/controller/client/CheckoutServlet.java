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
    protected void doGet(HttpServletRequest request,
                         HttpServletResponse response)
            throws ServletException, IOException {

        HttpSession session = request.getSession();

        List<CartItem> cart =
                (List<CartItem>) session.getAttribute("cart");

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

        request.getRequestDispatcher("/WEB-INF/client/checkout.jsp")
                .forward(request, response);
    }

    @Override
    protected void doPost(HttpServletRequest request,
                          HttpServletResponse response)
            throws ServletException, IOException {

        HttpSession session = request.getSession();

        Integer userId =
                (Integer) session.getAttribute("userId");

        if (userId == null) {
            response.sendRedirect(
                    request.getContextPath() + "/login"
            );
            return;
        }

        List<CartItem> cart =
                (List<CartItem>) session.getAttribute("cart");

        String selectedIds =
                request.getParameter("selectedIds");

        List<CartItem> selectedCart = new ArrayList<>();

        if (cart != null &&
                selectedIds != null &&
                !selectedIds.isEmpty()) {

            List<Integer> ids =
                    Arrays.stream(selectedIds.split(","))
                            .map(Integer::parseInt)
                            .toList();

            for (CartItem item : cart) {

                if (ids.contains(item.getProduct().getId())) {
                    selectedCart.add(item);
                }
            }

        } else {

            selectedCart =
                    (cart != null) ? cart : new ArrayList<>();
        }

        if (selectedCart.isEmpty()) {

            response.sendRedirect(
                    request.getContextPath() + "/cart"
            );

            return;
        }

        // =========================
        // THÔNG TIN NGƯỜI NHẬN
        // =========================

        String receiverName =
                request.getParameter("receiverName");

        String receiverPhone =
                request.getParameter("receiverPhone");

        String paymentMethod =
                request.getParameter("paymentMethod");

        String note =
                request.getParameter("note");

        // =========================
        // ĐỊA CHỈ
        // =========================

        String province =
                request.getParameter("province");

        String district =
                request.getParameter("district");

        String ward =
                request.getParameter("ward");

        String shippingAddress =
                request.getParameter("shippingAddress");

        String fullAddress =
                shippingAddress + ", "
                        + ward + ", "
                        + district + ", "
                        + province;

        // =========================
        // GHN DATA
        // =========================

        int districtId = 0;

        try {
            districtId = Integer.parseInt(
                    request.getParameter("districtId")
            );
        } catch (Exception e) {
            districtId = 0;
        }

        String wardCode =
                request.getParameter("wardCode");

        // =========================
        // TÍNH TIỀN
        // =========================

        double subtotal = 0;

        for (CartItem item : selectedCart) {

            subtotal +=
                    item.getProduct().getPrice()
                            * item.getQuantity();
        }

        // =========================
        // SHIPPING FEE
        // =========================

        double shippingFee = 30000;

        try {

            shippingFee = Double.parseDouble(
                    request.getParameter("shippingFee")
            );

        } catch (Exception e) {

            shippingFee = 30000;
        }

        // =========================
        // VOUCHER
        // =========================

        double discount = 0;

        Integer voucherId = null;

        String voucherRaw =
                request.getParameter("voucherId");

        if (voucherRaw != null &&
                !voucherRaw.isEmpty()) {

            try {

                voucherId = Integer.parseInt(voucherRaw);

                try (Connection conn =
                             DBConnection.getConnection()) {

                    VoucherDAO voucherDAO =
                            new VoucherDAO(conn);

                    Voucher v =
                            voucherDAO.findById(voucherId);

                    if (v != null) {

                        if ("PERCENT".equalsIgnoreCase(
                                v.getDiscountType())) {

                            discount =
                                    subtotal
                                            * v.getDiscountValue()
                                            / 100.0;

                            if (discount > v.getMaxDiscount()) {
                                discount = v.getMaxDiscount();
                            }

                        } else {

                            discount =
                                    v.getDiscountValue();
                        }
                    }

                }

            } catch (Exception e) {
                e.printStackTrace();
            }
        }

        // =========================
        // TOTAL
        // =========================

        double total =
                subtotal - discount + shippingFee;

        if (total < 0) {
            total = 0;
        }

        // =========================
        // ORDER CODE
        // =========================

        String orderCode =
                "ORD" + System.currentTimeMillis();

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

            // =========================
            // VNPAY
            // =========================

            if ("VNPAY".equalsIgnoreCase(paymentMethod)) {

                session.setAttribute(
                        "paymentAmount",
                        total
                );

                session.setAttribute(
                        "pendingOrderCode",
                        orderCode
                );

                response.sendRedirect(
                        request.getContextPath()
                                + "/vnpayPayment"
                );

                return;
            }

            // =========================
            // UPDATE VOUCHER
            // =========================

            if (voucherId != null) {

                try (Connection conn =
                             DBConnection.getConnection()) {

                    VoucherDAO voucherDAO =
                            new VoucherDAO(conn);

                    voucherDAO.updateUsed(voucherId);

                } catch (Exception e) {
                    e.printStackTrace();
                }
            }

            // =========================
            // REMOVE CART
            // =========================

            cart.removeAll(selectedCart);

            session.setAttribute("cart", cart);

            response.sendRedirect(
                    request.getContextPath()
                            + "/orderSuccess?orderCode="
                            + orderCode
            );

        } catch (Exception e) {

            e.printStackTrace();

            response.setContentType(
                    "text/html;charset=UTF-8"
            );

            response.getWriter().println(
                    "<h2>Lỗi tạo đơn hàng: "
                            + e.getMessage()
                            + "</h2>"
            );
        }
    }
}