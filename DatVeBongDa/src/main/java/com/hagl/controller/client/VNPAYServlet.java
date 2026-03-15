package com.hagl.controller.client;

import com.hagl.config.VNPAYConfig;
import com.hagl.dao.OrderDAO;
import com.hagl.model.CartItem;

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.*;

import java.io.IOException;
import java.net.URLEncoder;
import java.nio.charset.StandardCharsets;
import java.text.SimpleDateFormat;
import java.util.*;

@WebServlet("/vnpayPayment")
public class VNPAYServlet extends HttpServlet {

    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        HttpSession session = request.getSession();

        List<CartItem> cart = (List<CartItem>) session.getAttribute("cart");

        if (cart == null || cart.isEmpty()) {
            response.sendRedirect("cart");
            return;
        }

        /* =====================
           TÍNH TỔNG TIỀN
        ===================== */

        double total = 0;

        for (CartItem item : cart) {
            total += item.getProduct().getPrice() * item.getQuantity();
        }

        long amount = (long) (total * 100);

        /* =====================
           TẠO ORDERCODE
        ===================== */

        String orderCode = "ORD" + System.currentTimeMillis();

        /* =====================
           LƯU ORDER PENDING
        ===================== */

        try {

            Integer userId = (Integer) session.getAttribute("userId");

            OrderDAO orderDAO = new OrderDAO();

            orderDAO.createOrder(userId, orderCode, total, "VNPAY", "Pending", cart);

        } catch (Exception e) {
            e.printStackTrace();
        }

        /* =====================
           TẠO PARAMETER VNPAY
        ===================== */

        String vnp_TxnRef = orderCode;
        String vnp_IpAddr = VNPAYConfig.getIpAddress(request);

        Map<String, String> vnp_Params = new HashMap<>();

        vnp_Params.put("vnp_Version", "2.1.0");
        vnp_Params.put("vnp_Command", "pay");
        vnp_Params.put("vnp_TmnCode", VNPAYConfig.vnp_TmnCode);
        vnp_Params.put("vnp_Amount", String.valueOf(amount));
        vnp_Params.put("vnp_CurrCode", "VND");

        vnp_Params.put("vnp_TxnRef", vnp_TxnRef);
        vnp_Params.put("vnp_OrderInfo", "Thanh toan don hang SportStore");
        vnp_Params.put("vnp_OrderType", "billpayment");

        vnp_Params.put("vnp_Locale", "vn");
        vnp_Params.put("vnp_ReturnUrl", VNPAYConfig.vnp_Returnurl);
        vnp_Params.put("vnp_IpAddr", vnp_IpAddr);

        /* =====================
           TIME
        ===================== */

        Calendar cld = Calendar.getInstance(TimeZone.getTimeZone("Etc/GMT+7"));
        SimpleDateFormat formatter = new SimpleDateFormat("yyyyMMddHHmmss");

        vnp_Params.put("vnp_CreateDate", formatter.format(cld.getTime()));

        cld.add(Calendar.MINUTE, 15);

        vnp_Params.put("vnp_ExpireDate", formatter.format(cld.getTime()));

        /* =====================
           SORT PARAM
        ===================== */

        List<String> fieldNames = new ArrayList<>(vnp_Params.keySet());
        Collections.sort(fieldNames);

        StringBuilder hashData = new StringBuilder();
        StringBuilder query = new StringBuilder();

        for (int i = 0; i < fieldNames.size(); i++) {

            String fieldName = fieldNames.get(i);
            String fieldValue = vnp_Params.get(fieldName);

            if (fieldValue != null && fieldValue.length() > 0) {

                hashData.append(fieldName);
                hashData.append('=');
                hashData.append(fieldValue);

                query.append(URLEncoder.encode(fieldName, StandardCharsets.UTF_8.toString()));
                query.append('=');
                query.append(URLEncoder.encode(fieldValue, StandardCharsets.UTF_8.toString()));

                if (i < fieldNames.size() - 1) {
                    hashData.append('&');
                    query.append('&');
                }
            }
        }

        /* =====================
           HASH
        ===================== */

        String vnp_SecureHash = VNPAYConfig.hmacSHA512(
                VNPAYConfig.vnp_HashSecret,
                hashData.toString()
        );

        query.append("&vnp_SecureHash=");
        query.append(vnp_SecureHash);

        String paymentUrl = VNPAYConfig.vnp_PayUrl + "?" + query.toString();

        /* =====================
           LƯU SESSION
        ===================== */

        session.setAttribute("orderCode", orderCode);

        /* =====================
           REDIRECT
        ===================== */

        response.sendRedirect(paymentUrl);
    }
}