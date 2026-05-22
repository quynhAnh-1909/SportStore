package com.shop.sportstore.controller.client;

import com.shop.sportstore.dao.OrderDAO;
import com.shop.sportstore.model.User;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;

import java.io.IOException;

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


        int cancelCount = orderDAO.countCanceledOrdersInLastHour(userId);
        if (cancelCount >= 3) {
            session.setAttribute("errorMsg", "Bạn đã hủy quá nhiều đơn hàng. Vui lòng thử lại sau 1 giờ!");
            response.sendRedirect(request.getContextPath() + "/order-history");
            return;
        }


        boolean isSuccess = orderDAO.cancelOrder(orderCode, userId, cancelReason);

        if (isSuccess) {
            session.setAttribute("successMsg", "Hủy đơn hàng #" + orderCode + " thành công!");
        } else {
            session.setAttribute("errorMsg", "Hủy thất bại! Đơn hàng không tồn tại, sai trạng thái hoặc đã quá thời gian cho phép.");
        }


        response.sendRedirect(request.getContextPath() + "/order-history");
    }
}