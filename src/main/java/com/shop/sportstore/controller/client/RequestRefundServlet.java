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

        request.setCharacterEncoding("UTF-8");
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

        String status = order.getStatus() != null ? order.getStatus().trim().toUpperCase() : "";
        boolean isDelivered = status.equals("DELIVERED")
                || status.equals("COMPLETED")
                || status.equals("2")
                || status.equals("HOÀN TẤT")
                || status.equals("ĐÃ GIAO");

        if (!isDelivered) {
            session.setAttribute("errorMsg", "Đơn hàng chưa được giao thành công, không thể yêu cầu hoàn tiền!");
            response.sendRedirect(request.getContextPath() + "/order-history");
            return;
        }

        if ("PENDING_REFUND".equals(status) || "REFUNDED".equals(status) || "REFUND_REJECTED".equals(status)) {
            session.setAttribute("errorMsg", "Đơn hàng này đã gửi yêu cầu hoặc đã được xử lý hoàn tiền trước đó!");
            response.sendRedirect(request.getContextPath() + "/order-history");
            return;
        }

        try {
            boolean success = orderDAO.requestRefund(orderId, reason);

            if (success) {
                orderDAO.updateOrderStatus(order.getOrderCode(), "PENDING_REFUND");
                session.setAttribute("successMsg", "Đã gửi yêu cầu hoàn tiền thành công! Vui lòng chờ Admin duyệt.");
            } else {
                session.setAttribute("errorMsg", "Hệ thống gặp sự cố. Không thể gửi yêu cầu hoàn tiền!");
            }
        } catch (SQLException e) {
            e.printStackTrace();
            session.setAttribute("errorMsg", "Lỗi kết nối cơ sở dữ liệu khi cập nhật trạng thái đơn hàng!");
        }

        response.sendRedirect(request.getContextPath() + "/order-history");
    }
}