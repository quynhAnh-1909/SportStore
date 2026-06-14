package com.shop.sportstore.controller.client;

import com.shop.sportstore.dao.OrderDAO;
import com.shop.sportstore.model.Order;
import com.shop.sportstore.model.User;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;

import java.io.IOException;
import java.sql.SQLException;

@WebServlet("/request-refund")
public class RequestRefundServlet extends HttpServlet {

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        response.setCharacterEncoding("UTF-8");
        HttpSession session = request.getSession();
        User loginUser = (User) session.getAttribute("user");
        if (loginUser == null) {
            response.sendRedirect(request.getContextPath() + "/login");
            return;
        }

        int orderId;
        try {
            orderId = Integer.parseInt(request.getParameter("orderId"));
        } catch (NumberFormatException e) {
            session.setAttribute("errorMsg", "Mã đơn hàng không hợp lệ!");
            response.sendRedirect(request.getContextPath() + "/order-history");
            return;
        }

        String reason = request.getParameter("reason");
        if (reason == null || reason.trim().isEmpty()) {
            session.setAttribute("errorMsg", "Vui lòng nhập lý do hoàn tiền!");
            response.sendRedirect(request.getContextPath() + "/order-history");
            return;
        }
        reason = reason.trim();

        OrderDAO orderDAO = new OrderDAO();
        int userId = loginUser.getUserId();

        Order order = orderDAO.getOrderById(orderId);

        if (order == null) {
            session.setAttribute("errorMsg", "Đơn hàng không tồn tại!");
            response.sendRedirect(request.getContextPath() + "/order-history");
            return;
        }
        if (order.getUserId() != userId) {
            session.setAttribute("errorMsg", "Bạn không có quyền yêu cầu hoàn tiền cho đơn hàng này!");
            response.sendRedirect(request.getContextPath() + "/order-history");
            return;
        }

        if (!order.isPaid()) {
            session.setAttribute("errorMsg",
                    "Đơn hàng chưa thanh toán nên không thể yêu cầu hoàn tiền!");
            response.sendRedirect(request.getContextPath() + "/order-history");
            return;
        }

        if (!"VNPAY".equalsIgnoreCase(order.getPaymentMethod())) {
            session.setAttribute("errorMsg",
                    "Chỉ đơn hàng thanh toán qua VNPAY mới được yêu cầu hoàn tiền!");
            response.sendRedirect(request.getContextPath() + "/order-history");
            return;
        }
        String status = order.getStatus();

        if (!"CANCELLED".equalsIgnoreCase(status)
                && !"FAILED".equalsIgnoreCase(status)) {

            session.setAttribute("errorMsg",
                    "Chỉ đơn hàng đã hủy mới được gửi yêu cầu hoàn tiền!");
            response.sendRedirect(request.getContextPath() + "/order-history");
            return;
        }


        String refundStatus = order.getRefundStatus();
        if ("PENDING_REFUND".equalsIgnoreCase(refundStatus)
                || "REFUNDED".equalsIgnoreCase(refundStatus)
                || "REJECTED".equalsIgnoreCase(refundStatus)) {
            session.setAttribute("errorMsg",
                    "Đơn hàng này đã gửi yêu cầu hoặc đã được xử lý hoàn tiền trước đó!");
            response.sendRedirect(request.getContextPath() + "/order-history");
            return;
        }
        try {
            boolean success = orderDAO.requestRefund(orderId, reason);
            if (success) {
                session.setAttribute("successMsg",
                        "Đã gửi yêu cầu hoàn tiền thành công! Vui lòng chờ Admin duyệt.");
            } else {
                session.setAttribute("errorMsg", "Hệ thống gặp sự cố. Không thể gửi yêu cầu hoàn tiền!");
            }
        } catch (Exception e) {
            e.printStackTrace();
            session.setAttribute("errorMsg", "Lỗi kết nối cơ sở dữ liệu khi cập nhật trạng thái đơn hàng!");
        }

        response.sendRedirect(request.getContextPath() + "/order-history");
    }
}