package com.shop.sportstore.controller.client;

import com.shop.sportstore.dao.OrderDAO;
import com.shop.sportstore.dao.UserDAO;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;

import java.io.IOException;

@WebServlet("/cancel-order")
public class CancelOderServlet extends HttpServlet {

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        HttpSession session = request.getSession(false);

        if (session == null || session.getAttribute("userId") == null) {
            response.sendRedirect(request.getContextPath() + "/products?showLogin=true");
            return;
        }

        Integer userId = (Integer) session.getAttribute("userId");
        String orderCode = request.getParameter("orderCode");

        if (orderCode != null && !orderCode.isEmpty()) {
            OrderDAO orderDAO = new OrderDAO();
            UserDAO userDAO = new UserDAO();

            // 1. Thực hiện Hủy đơn hàng
            boolean isCanceled = orderDAO.cancelOrder(orderCode, userId);

            if (isCanceled) {
                // 2. Đếm số lần hủy trong 1 giờ
                int cancelCount = orderDAO.countCanceledOrdersInLastHour(userId);

                // 3. Khóa tài khoản nếu >= 5 lần
                if (cancelCount >= 5) {
                    userDAO.lockUserAccount(userId); // Khóa DB
                    session.invalidate(); // Xóa Session

                    HttpSession newSession = request.getSession(true);
                    newSession.setAttribute("errorLogin", "Tài khoản của bạn đã bị khóa do hủy đơn quá 5 lần trong 1 giờ!");
                    response.sendRedirect(request.getContextPath() + "/products?showLogin=true");
                    return;
                }

                request.getSession().setAttribute("message", "Hủy đơn hàng thành công!");
            } else {
                request.getSession().setAttribute("error", "Không thể hủy đơn hàng này!");
            }
        }

        String referer = request.getHeader("Referer");
        response.sendRedirect(referer != null ? referer : request.getContextPath() + "/products");
    }
}