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
import java.util.Date;
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

        // CHECK CART

        if (cart == null || cart.isEmpty()) {

            response.sendRedirect(
                    request.getContextPath() + "/cart"
            );

            return;
        }

        String selectedIds =
                request.getParameter("selectedIds");

        List<CartItem> selectedItems =
                new ArrayList<>();

        // FILTER ITEM

        if (selectedIds != null
                && !selectedIds.isEmpty()) {

            List<Integer> ids =
                    Arrays.stream(selectedIds.split(","))
                            .map(Integer::parseInt)
                            .toList();

            for (CartItem item : cart) {

                if (ids.contains(
                        item.getProduct().getId())) {

                    selectedItems.add(item);
                }
            }

        } else {

            selectedItems = cart;
        }

        // LOAD VOUCHERS

        try {

            Connection conn =
                    DBConnection.getConnection();

            VoucherDAO voucherDAO =
                    new VoucherDAO(conn);

            request.setAttribute(
                    "vouchers",
                    voucherDAO.getAll()
            );

        } catch (Exception e) {

            e.printStackTrace();
        }

        request.setAttribute(
                "selectedItems",
                selectedItems
        );

        request.getRequestDispatcher(
                "/WEB-INF/client/checkout.jsp"
        ).forward(request, response);
    }

    @Override
    protected void doPost(HttpServletRequest request,
                          HttpServletResponse response)
            throws ServletException, IOException {

        HttpSession session =
                request.getSession();

        // CHECK LOGIN

        Integer userId =
                (Integer) session.getAttribute("userId");

        if (userId == null) {

            response.sendRedirect(
                    request.getContextPath() + "/login"
            );

            return;
        }

        // GET CART

        List<CartItem> cart =
                (List<CartItem>) session.getAttribute("cart");

        if (cart == null || cart.isEmpty()) {

            response.sendRedirect(
                    request.getContextPath() + "/cart"
            );

            return;
        }

        // GET SELECTED IDS

        String selectedIds =
                request.getParameter("selectedIds");

        List<CartItem> selectedCart =
                new ArrayList<>();

        if (selectedIds != null
                && !selectedIds.isEmpty()) {

            List<Integer> ids =
                    Arrays.stream(selectedIds.split(","))
                            .map(Integer::parseInt)
                            .toList();

            for (CartItem item : cart) {

                if (ids.contains(
                        item.getProduct().getId())) {

                    selectedCart.add(item);
                }
            }

        } else {

            selectedCart = cart;
        }

        // CHECK EMPTY

        if (selectedCart.isEmpty()) {

            response.sendRedirect(
                    request.getContextPath() + "/cart"
            );

            return;
        }

        // CUSTOMER INFO

        String receiverName =
                request.getParameter("receiverName");

        String receiverPhone =
                request.getParameter("receiverPhone");

        String address =
                request.getParameter("address");

        String note =
                request.getParameter("note");

        String paymentMethod =
                request.getParameter("paymentMethod");

        // TOTAL

        double subtotal = 0;

        for (CartItem item : selectedCart) {

            subtotal +=
                    item.getProduct().getPrice()
                            * item.getQuantity();
        }

        // ================= VOUCHER =================

        double discount = 0;

        Integer voucherId = null;

        try {

            Connection conn =
                    DBConnection.getConnection();

            VoucherDAO voucherDAO =
                    new VoucherDAO(conn);

            String voucherIdRaw =
                    request.getParameter("voucherId");

            if (voucherIdRaw != null
                    && !voucherIdRaw.isBlank()) {

                voucherId =
                        Integer.parseInt(voucherIdRaw);

                Voucher voucher =
                        voucherDAO.findById(voucherId);

                if (voucher != null) {

                    boolean valid = true;

                    // STATUS

                    if (!voucher.isStatus()) {

                        valid = false;
                    }

                    // QUANTITY

                    if (voucher.getUsedCount()
                            >= voucher.getQuantity()) {

                        valid = false;
                    }

                    // MIN ORDER

                    if (subtotal
                            < voucher.getMinOrderValue()) {

                        valid = false;
                    }

                    // PAYMENT METHOD

                    if (!voucher.getPaymentMethod()
                            .equalsIgnoreCase("ALL")) {

                        if (!voucher.getPaymentMethod()
                                .equalsIgnoreCase(paymentMethod)) {

                            valid = false;
                        }
                    }

                    // DATE

                    Date now = new Date();

                    if (voucher.getStartDate() != null
                            && now.before(voucher.getStartDate())) {

                        valid = false;
                    }

                    if (voucher.getExpiryDate() != null
                            && now.after(voucher.getExpiryDate())) {

                        valid = false;
                    }

                    // CATEGORY + PRICE

                    if (voucher.getCategoryId() != 0
                            || voucher.getMinProductPrice() > 0) {

                        boolean hasValidProduct = false;

                        for (CartItem item : selectedCart) {

                            boolean ok = true;

                            // CATEGORY

                            if (voucher.getCategoryId() != 0) {

                                if (item.getProduct().getCategoryId()
                                        != voucher.getCategoryId()) {

                                    ok = false;
                                }
                            }

                            // MIN PRODUCT PRICE

                            if (item.getProduct().getPrice()
                                    < voucher.getMinProductPrice()) {

                                ok = false;
                            }

                            if (ok) {

                                hasValidProduct = true;
                                break;
                            }
                        }

                        if (!hasValidProduct) {

                            valid = false;
                        }
                    }

                    // APPLY VOUCHER

                    if (valid) {

                        // FIXED

                        if ("FIXED".equalsIgnoreCase(
                                voucher.getDiscountType())) {

                            discount =
                                    voucher.getDiscountValue();
                        }

                        // PERCENT

                        else if ("PERCENT".equalsIgnoreCase(
                                voucher.getDiscountType())) {

                            discount =
                                    subtotal
                                            * voucher.getDiscountValue()
                                            / 100;

                            // MAX DISCOUNT

                            if (voucher.getMaxDiscount() > 0
                                    && discount >
                                    voucher.getMaxDiscount()) {

                                discount =
                                        voucher.getMaxDiscount();
                            }
                        }

                        // AVOID OVER DISCOUNT

                        if (discount > subtotal) {

                            discount = subtotal;
                        }

                        // UPDATE USED

                        voucherDAO.updateUsed(voucherId);

                    } else {

                        voucherId = null;
                    }
                }
            }

        } catch (Exception e) {

            e.printStackTrace();
        }

        // SHIPPING

        double shippingFee = 30000;

        // FINAL TOTAL

        double total =
                subtotal
                        - discount
                        + shippingFee;

        if (total < 0) {

            total = 0;
        }

        // ORDER CODE

        String orderCode =
                "ORD" + System.currentTimeMillis();

        session.setAttribute(
                "orderCode",
                orderCode
        );

        // CREATE ORDER

        try {

            OrderDAO orderDAO =
                    new OrderDAO();

            orderDAO.createOrder(
                    userId,
                    orderCode,
                    total,
                    paymentMethod,
                    "PENDING",
                    note,
                    voucherId,
                    discount,
                    selectedCart
            );

        } catch (Exception e) {

            e.printStackTrace();

            response.setContentType(
                    "text/html;charset=UTF-8"
            );

            response.getWriter().println(
                    "<h2>Lỗi tạo đơn hàng</h2>"
            );

            response.getWriter().println(
                    "<pre>" + e.getMessage() + "</pre>"
            );

            return;
        }

        // VNPAY

        if ("VNPAY".equalsIgnoreCase(paymentMethod)) {

            response.sendRedirect(
                    request.getContextPath()
                            + "/vnpayPayment"
            );

            return;
        }

        // REMOVE CHECKED OUT ITEMS

        cart.removeAll(selectedCart);

        session.setAttribute(
                "cart",
                cart
        );

        // SUCCESS INFO

        session.setAttribute(
                "lastOrderCode",
                orderCode
        );

        session.setAttribute(
                "lastTotal",
                total
        );

        session.setAttribute(
                "lastDiscount",
                discount
        );

        session.setAttribute(
                "lastShippingFee",
                shippingFee
        );

        request.setAttribute(
                "items",
                selectedCart
        );

        request.getRequestDispatcher(
                "/WEB-INF/client/orderSuccess.jsp"
        ).forward(request, response);
    }
}