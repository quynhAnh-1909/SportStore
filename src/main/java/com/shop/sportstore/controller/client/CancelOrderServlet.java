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
import java.sql.Timestamp;

@WebServlet(name = "CancelOrderServlet", urlPatterns = {"/cancel-order"})
public class CancelOrderServlet extends HttpServlet {

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        // Đảm bảo đồng bộ hóa tiếng Việt chuẩn xác
        request.setCharacterEncoding("UTF-8");
        response.setCharacterEncoding("UTF-8");

        HttpSession session = request.getSession();
        User loginUser = (User) session.getAttribute("user");

        // 1. KIỂM TRA ĐĂNG NHẬP
        if (loginUser == null) {
            response.sendRedirect(request.getContextPath() + "/login");
            return;
        }

        String orderCode = request.getParameter("orderCode");
        String cancelReason = request.getParameter("cancelReason");

        // Xử lý lý do hủy linh hoạt và gọn gàng hơn
        if ("Khác".equals(cancelReason)) {
            String otherReason = request.getParameter("otherReason");
            if (otherReason != null && !otherReason.trim().isEmpty()) {
                cancelReason = otherReason.trim();
            } else {
                cancelReason = "Lý do khác (Người dùng không ghi rõ)";
            }
        }

        OrderDAO orderDAO = new OrderDAO();
        int userId = loginUser.getUserId();

        // 2. GIỚI HẠN TẦN SUẤT HỦY ĐƠN (Chống spam phá hoại hệ thống)
        int cancelCount = orderDAO.countCanceledOrdersInLastHour(userId);
        if (cancelCount >= 3) {
            session.setAttribute("errorMsg", "Bạn đã hủy quá nhiều đơn hàng trong vòng 1 giờ qua. Vui lòng thử lại sau!");
            response.sendRedirect(request.getContextPath() + "/order-history");
            return;
        }

        // 3. KIỂM TRA SỰ TỒN TẠI CỦA ĐƠN HÀNG
        Order order = orderDAO.getOrderByCode(orderCode);
        if (order == null) {
            session.setAttribute("errorMsg", "Đơn hàng không tồn tại trên hệ thống!");
            response.sendRedirect(request.getContextPath() + "/order-history");
            return;
        }

        // 4. KIỂM TRA BẢO MẬT (Chống lỗi IDOR - Sửa tham số để hủy đơn người khác)
        if (order.getUserId() != userId) {
            session.setAttribute("errorMsg", "Bạn không có quyền thao tác trên đơn hàng này!");
            response.sendRedirect(request.getContextPath() + "/order-history");
            return;
        }

        // 5. ĐỒNG BỘ KIỂM TRA TRẠNG THÁI (Bọc chống Null và hỗ trợ cả mã số giống JSP)
        String status = order.getStatus() != null ? order.getStatus().trim().toUpperCase() : "";
        boolean isValidStatus = status.equals("PENDING")
                || status.equals("CONFIRMED")
                || status.equals("0")
                || status.equals("CHỜ XÁC NHẬN");

        if (!isValidStatus) {
            session.setAttribute("errorMsg", "Đơn hàng đã được vận chuyển hoặc hoàn tất, không thể hủy!");
            response.sendRedirect(request.getContextPath() + "/order-history");
            return;
        }

        // 6. GIỚI HẠN THỜI GIAN HỦY ĐƠN (Giả sử thống nhất chọn mốc 30 phút giống Back-end của bạn)
        Timestamp createdAt = order.getCreatedAt();
        if (createdAt != null) {
            long diffMillis = System.currentTimeMillis() - createdAt.getTime();
            long diffMinutes = diffMillis / (1000 * 60);

            if (diffMinutes > 30) {
                session.setAttribute("errorMsg", "Đơn hàng đã quá thời gian cho phép hủy (Tối đa 30 phút kể từ lúc đặt)!");
                response.sendRedirect(request.getContextPath() + "/order-history");
                return;
            }
        }

        // 7. THỰC HIỆN HỦY ĐƠN TRONG DATABASE
        boolean isSuccess = orderDAO.cancelOrder(orderCode, userId, cancelReason);
        if (isSuccess) {
            session.setAttribute("successMsg", "Hủy đơn hàng #" + orderCode + " thành công!");
        } else {
            session.setAttribute("errorMsg", "Hệ thống gặp sự cố, hủy đơn hàng thất bại!");
        }

        response.sendRedirect(request.getContextPath() + "/order-history");
    }
}