package com.hagl.vnpay;

import java.nio.charset.StandardCharsets;
import java.util.*;
import javax.crypto.Mac;
import javax.crypto.spec.SecretKeySpec;
import javax.servlet.http.HttpServletRequest;

public class VnPayConfig {

    // URL thanh toán VNPay Sandbox
    public static final String vnp_PayUrl =
            "  http://sandbox.vnpayment.vn/tryitnow/Home/CreateOrder";

    // URL trả về sau khi thanh toán
    public static final String vnp_Returnurl =
    		"http://localhost:8080/DatVeBongDa/vnpayReturn";;

    // Thông tin merchant
    public static final String vnp_TmnCode = "YOUR_TMN_CODE";
    public static final String vnp_HashSecret = "YOUR_HASH_SECRET";

    // Tạo mã random
    public static String getRandomNumber(int len) {
        Random rnd = new Random();
        String chars = "0123456789";
        StringBuilder sb = new StringBuilder(len);

        for (int i = 0; i < len; i++) {
            sb.append(chars.charAt(rnd.nextInt(chars.length())));
        }

        return sb.toString();
    }

    // Lấy IP client
    public static String getIpAddress(HttpServletRequest request) {

        String ipAddress = request.getHeader("X-FORWARDED-FOR");

        if (ipAddress == null) {
            ipAddress = request.getRemoteAddr();
        }

        return ipAddress;
    }

    // HMAC SHA512
    public static String hmacSHA512(final String key, final String data) {
        try {

            Mac hmac = Mac.getInstance("HmacSHA512");

            SecretKeySpec secretKey =
                    new SecretKeySpec(key.getBytes(), "HmacSHA512");

            hmac.init(secretKey);

            byte[] bytes = hmac.doFinal(data.getBytes(StandardCharsets.UTF_8));

            StringBuilder hash = new StringBuilder(bytes.length * 2);

            for (byte b : bytes) {
                hash.append(String.format("%02x", b & 0xff));
            }

            return hash.toString();

        } catch (Exception ex) {
            return "";
        }
    }

    // Tạo SecureHash cho toàn bộ params
    public static String hashAllFields(Map<String, String> fields) {

        List<String> fieldNames = new ArrayList<>(fields.keySet());

        Collections.sort(fieldNames);

        StringBuilder hashData = new StringBuilder();

        Iterator<String> itr = fieldNames.iterator();

        while (itr.hasNext()) {

            String fieldName = itr.next();
            String fieldValue = fields.get(fieldName);

            if (fieldValue != null && fieldValue.length() > 0) {

                hashData.append(fieldName);
                hashData.append('=');
                hashData.append(fieldValue);

                if (itr.hasNext()) {
                    hashData.append('&');
                }
            }
        }

        return hmacSHA512(vnp_HashSecret, hashData.toString());
    }
}