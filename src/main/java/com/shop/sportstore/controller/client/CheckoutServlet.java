package com.shop.sportstore.controller.client;

import com.shop.sportstore.dao.OrderDAO;
import com.shop.sportstore.dao.VoucherDAO;
import com.shop.sportstore.model.CartItem;
import com.shop.sportstore.model.Voucher;
import com.shop.sportstore.service.GhnShippingService;
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
                try (Connection conn = DBConnection.getConnection()) {
                    VoucherDAO voucherDAO = new VoucherDAO(conn);
                    Voucher v = voucherDAO.findById(voucherId);
                    if (v != null) {
                        discount = v.getDiscountValue();
                    }
                } catch (Exception e) {
                    System.err.println("Lỗi hệ thống khi lấy giá trị Voucher: " + e.getMessage());
                }
            } catch (NumberFormatException e) {
                voucherId = null;
            }
        }

        double shippingFee = 30000;
        try {
            GhnShippingService ghn = new GhnShippingService(
                    "2eb2d430-50e9-11f1-a973-aee5264794df",
                    "200403"
            );

            int fee = ghn.calculateShippingFee(
                    1440,
                    districtId,
                    wardCode,
                    1000,
                    20,
                    20,
                    10,
                    (int) subtotal
            );
            if (fee > 0) {
                shippingFee = fee;
            } else {
                shippingFee = 30000;
            }

        } catch (Exception e) {

            System.out.println("GHN calculate error: " + e.getMessage());
            shippingFee = 30000;
        }

        // --- ĐOẠN THÊM DUY NHẤT: Ưu tiên lấy phí ship từ Giao diện gửi lên để chuẩn số tiền hiển thị ---
        String shippingFeeRaw = request.getParameter("shippingFee");
        if (shippingFeeRaw != null && !shippingFeeRaw.isEmpty()) {
            try { shippingFee = Double.parseDouble(shippingFeeRaw); } catch (Exception e) {}
        }
        // -----------------------------------------------------------------------------------------

        double total = subtotal - discount + shippingFee;

        if (total < 0) {
            total = 0;
        }

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
                response.sendRedirect(request.getContextPath() + "/vnpayPayment");
            } else {
                if (voucherId != null) {
                    try (Connection conn = DBConnection.getConnection()) {
                        VoucherDAO voucherDAO = new VoucherDAO(conn);
                        voucherDAO.updateUsed(voucherId);
                    } catch (Exception e) {
                        System.err.println("Lỗi cập nhật lượt dùng Voucher: " + e.getMessage());
                    }
                }

                cart.removeAll(selectedCart);
                session.setAttribute("cart", cart);
                response.sendRedirect(request.getContextPath() + "/orderSuccess?orderCode=" + orderCode);
            }
        } catch (Exception e) {
            e.printStackTrace();
            response.setContentType("text/html;charset=UTF-8");
            response.getWriter().println("<h2>Lỗi tạo đơn hàng trên hệ thống: " + e.getMessage() + "</h2>");
        }
    }
}