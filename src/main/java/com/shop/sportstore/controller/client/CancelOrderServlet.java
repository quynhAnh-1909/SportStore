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

        request.setCharacterEncoding("UTF-8");
        response.setCharacterEncoding("UTF-8");

        HttpSession session = request.getSession();

        User loginUser = (User) session.getAttribute("user");

        if (loginUser == null) {
            response.sendRedirect(request.getContextPath() + "/login");
            return;
        }

        String orderCode = request.getParameter("orderCode");
        String cancelReason = request.getParameter("cancelReason");

        if ("Khác".equals(cancelReason)) {

            String otherReason = request.getParameter("otherReason");

            if (otherReason != null && !otherReason.trim().isEmpty()) {
                cancelReason = otherReason.trim();
            }
        }

        OrderDAO orderDAO = new OrderDAO();

        int userId = loginUser.getUserId();

        // GIỚI HẠN HỦY ĐƠN
        int cancelCount = orderDAO.countCanceledOrdersInLastHour(userId);

        if (cancelCount >= 3) {

            session.setAttribute(
                    "errorMsg",
                    "Bạn đã hủy quá nhiều đơn hàng. Vui lòng thử lại sau 1 giờ!"
            );

            response.sendRedirect(request.getContextPath() + "/order-history");

            return;
        }

        // CHECK ĐƠN HÀNG
        Order order = orderDAO.getOrderByCode(orderCode);

        if (order == null) {

            session.setAttribute(
                    "errorMsg",
                    "Đơn hàng không tồn tại!"
            );

            response.sendRedirect(request.getContextPath() + "/order-history");

            return;
        }

        // CHECK ĐÚNG USER
        if (order.getUserId() != userId) {

            session.setAttribute(
                    "errorMsg",
                    "Bạn không có quyền hủy đơn này!"
            );

            response.sendRedirect(request.getContextPath() + "/order-history");

            return;
        }

        // CHỈ CHO HỦY PENDING / CONFIRMED
        String status = order.getStatus();

        if (
                !status.equalsIgnoreCase("PENDING")
                        && !status.equalsIgnoreCase("CONFIRMED")
        ) {

            session.setAttribute(
                    "errorMsg",
                    "Đơn hàng không thể hủy ở trạng thái hiện tại!"
            );

            response.sendRedirect(request.getContextPath() + "/order-history");

            return;
        }

        // GIỚI HẠN THỜI GIAN HỦY (30 PHÚT)
        Timestamp createdAt = order.getCreatedAt();

        if (createdAt != null) {

            long diffMillis =
                    System.currentTimeMillis() - createdAt.getTime();

            long diffMinutes = diffMillis / (1000 * 60);

            if (diffMinutes > 30) {

                session.setAttribute(
                        "errorMsg",
                        "Đơn hàng đã quá thời gian cho phép hủy (30 phút)!"
                );

                response.sendRedirect(request.getContextPath() + "/order-history");

                return;
            }
        }

        // HỦY ĐƠN
        boolean isSuccess =
                orderDAO.cancelOrder(orderCode, userId, cancelReason);

        if (isSuccess) {

            session.setAttribute(
                    "successMsg",
                    "Hủy đơn hàng #" + orderCode + " thành công!"
            );

        } else {

            session.setAttribute(
                    "errorMsg",
                    "Hủy thất bại!"
            );
        }

        response.sendRedirect(request.getContextPath() + "/order-history");
    }
}