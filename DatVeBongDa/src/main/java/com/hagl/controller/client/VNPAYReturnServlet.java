package com.hagl.controller.client;

import java.io.IOException;
import java.sql.SQLException;
import java.util.Enumeration;
import java.util.HashMap;
import java.util.Map;

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.*;

import com.hagl.config.VNPAYConfig;
import com.hagl.dao.OrderDAO;
import com.hagl.utils.EmailUtils;

@WebServlet("/vnpayReturn")
public class VNPAYReturnServlet extends HttpServlet {

    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        Map<String, String> fields = new HashMap<>();

        // Lấy parameter từ VNPAY
        for (Enumeration<String> params = request.getParameterNames(); params.hasMoreElements();) {
            String fieldName = params.nextElement();
            String fieldValue = request.getParameter(fieldName);

            if (fieldValue != null && fieldValue.length() > 0) {
                fields.put(fieldName, fieldValue);
            }
        }

        String vnp_SecureHash = request.getParameter("vnp_SecureHash");

        fields.remove("vnp_SecureHashType");
        fields.remove("vnp_SecureHash");

        // tạo hash để so sánh
        String signValue = VNPAYConfig.hashAllFields(fields);

        String vnp_ResponseCode = request.getParameter("vnp_ResponseCode");
        String vnp_TxnRef = request.getParameter("vnp_TxnRef");

        OrderDAO orderDAO = new OrderDAO();

        try {

            // kiểm tra chữ ký hợp lệ
            if (signValue.equals(vnp_SecureHash)) {

                if ("00".equals(vnp_ResponseCode)) {

                    // thanh toán thành công
                    orderDAO.updateOrderStatus(vnp_TxnRef, "Paid");

                    Map<String, String> data = orderDAO.getOrderDetailForEmail(vnp_TxnRef);

                    if (data != null) {

                        HttpSession session = request.getSession(true);

                        if (session.getAttribute("userId") == null) {
                            session.setAttribute("userId", data.get("userId"));
                            session.setAttribute("userName", data.get("fullName"));
                            session.setAttribute("userEmail", data.get("email"));
                        }

                        // gửi mail
                        new Thread(() -> {
                            try {
                                String content = createEmailTemplate(data);

                                EmailUtils.sendEmail(
                                        data.get("email"),
                                        "Xác nhận đơn hàng - SportStore",
                                        content);

                            } catch (Exception e) {
                                e.printStackTrace();
                            }
                        }).start();
                    }

                    request.setAttribute("status", "success");

                } else {
                    request.setAttribute("status", "failed");
                }

            } else {
                request.setAttribute("status", "invalid");
            }

        } catch (SQLException e) {
            e.printStackTrace();
            request.setAttribute("status", "error");
        }

        request.getRequestDispatcher("/WEB-INF/views/client/paymentResult.jsp")
                .forward(request, response);
    }

    private String createEmailTemplate(Map<String, String> data) {

        return "<h2>Đặt hàng thành công</h2>"
                + "<p>Xin chào <b>" + data.get("fullName") + "</b></p>"
                + "<p>Mã đơn hàng: <b>" + data.get("orderId") + "</b></p>"
                + "<p>Tổng tiền: <b>" + data.get("totalPrice") + " VNĐ</b></p>"
                + "<p>Cảm ơn bạn đã mua hàng tại SportStore!</p>";
    }
}