package com.shop.sportstore.controller.client;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.*;

import javax.crypto.Mac;
import javax.crypto.spec.SecretKeySpec;
import java.io.IOException;
import java.net.URLEncoder;
import java.nio.charset.StandardCharsets;
import java.text.SimpleDateFormat;
import java.util.*;

@WebServlet("/vnpayPayment")
public class VNPayPaymentServlet extends HttpServlet {

    // ===== CONFIG =====
    private static final String VNP_TMNCODE =
            "SKHL50DJ";

    private static final String VNP_HASH_SECRET =
            "B70Y9KNAN3VMHE3Q0W0IAZ6PGGU8UL5U";

    private static final String VNP_PAY_URL =
            "https://sandbox.vnpayment.vn/paymentv2/vpcpay.html";

    private static final String VNP_RETURN_URL =
            "http://10.208.147.195/vnpay-return";

    @Override
    protected void doGet(HttpServletRequest request,
                         HttpServletResponse response)
            throws ServletException, IOException {

        HttpSession session = request.getSession();

        Double amount =
                (Double) session.getAttribute("paymentAmount");

        String orderCode =
                (String) session.getAttribute("pendingOrderCode");

        if (amount == null || orderCode == null) {

            response.sendRedirect(
                    request.getContextPath() + "/cart"
            );
            return;
        }

        long vnpAmount = (long) (amount * 100);

        Map<String, String> vnpParams = new TreeMap<>();

        vnpParams.put("vnp_Version", "2.1.0");
        vnpParams.put("vnp_Command", "pay");

        vnpParams.put("vnp_TmnCode", VNP_TMNCODE);

        vnpParams.put("vnp_Amount",
                String.valueOf(vnpAmount));

        vnpParams.put("vnp_CurrCode", "VND");

        vnpParams.put("vnp_TxnRef", orderCode);

        vnpParams.put(
                "vnp_OrderInfo",
                "Thanh toan don hang " + orderCode
        );

        vnpParams.put("vnp_OrderType", "other");

        vnpParams.put("vnp_Locale", "vn");

        // ===== FIX LỖI =====
        vnpParams.put("vnp_ReturnUrl", VNP_RETURN_URL);

        vnpParams.put(
                "vnp_IpAddr",
                request.getRemoteAddr()
        );

        Calendar calendar =
                Calendar.getInstance(
                        TimeZone.getTimeZone("Etc/GMT+7")
                );

        SimpleDateFormat formatter =
                new SimpleDateFormat("yyyyMMddHHmmss");

        String createDate =
                formatter.format(calendar.getTime());

        vnpParams.put("vnp_CreateDate", createDate);

        // ===== BUILD QUERY =====

        StringBuilder hashData = new StringBuilder();

        StringBuilder query = new StringBuilder();

        Iterator<Map.Entry<String, String>> itr =
                vnpParams.entrySet().iterator();

        while (itr.hasNext()) {

            Map.Entry<String, String> entry =
                    itr.next();

            String fieldName = entry.getKey();

            String fieldValue = entry.getValue();

            String encodedValue =
                    URLEncoder.encode(
                            fieldValue,
                            StandardCharsets.UTF_8
                    );

            hashData.append(fieldName)
                    .append("=")
                    .append(encodedValue);

            query.append(fieldName)
                    .append("=")
                    .append(encodedValue);

            if (itr.hasNext()) {

                hashData.append("&");

                query.append("&");
            }
        }

        // ===== HASH =====

        String secureHash =
                hmacSHA512(
                        VNP_HASH_SECRET,
                        hashData.toString()
                );

        query.append("&vnp_SecureHash=");
        query.append(secureHash);

        String paymentUrl =
                VNP_PAY_URL + "?" + query;

        response.sendRedirect(paymentUrl);
    }

    // ===== SHA512 =====
    private String hmacSHA512(String key, String data) {

        try {

            Mac hmac512 =
                    Mac.getInstance("HmacSHA512");

            SecretKeySpec secretKey =
                    new SecretKeySpec(
                            key.getBytes(StandardCharsets.UTF_8),
                            "HmacSHA512"
                    );

            hmac512.init(secretKey);

            byte[] bytes =
                    hmac512.doFinal(
                            data.getBytes(StandardCharsets.UTF_8)
                    );

            StringBuilder hash = new StringBuilder();

            for (byte b : bytes) {

                hash.append(
                        String.format("%02x", b)
                );
            }

            return hash.toString();

        } catch (Exception e) {

            e.printStackTrace();

            return "";
        }
    }
}