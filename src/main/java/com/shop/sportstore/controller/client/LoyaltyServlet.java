package com.shop.sportstore.controller.client;

import com.shop.sportstore.dao.UserDAO;
import com.shop.sportstore.model.User;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
import java.io.IOException;
import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.SQLException;

@WebServlet("/register-loyalty")
public class LoyaltyServlet extends HttpServlet {
    private static final long serialVersionUID = 1L;
    private final UserDAO userDAO = new UserDAO();

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        HttpSession session = request.getSession(false);


        if (session == null || session.getAttribute("user") == null) {
            response.sendRedirect(request.getContextPath() + "/auth.jsp");
            return;
        }

        User user = (User) session.getAttribute("user");
        String sql = "UPDATE users SET is_loyal = 1, loyal_date = NOW() WHERE user_id = ?";
        boolean isSuccess = false;


        try (Connection conn = userDAO.getConnection()) {
            if (conn != null) {
                try (PreparedStatement ps = conn.prepareStatement(sql)) {
                    ps.setInt(1, user.getUserId());

                    int rows = ps.executeUpdate();
                    if (rows > 0) {
                        isSuccess = true;


                        user.setLoyal(true);
                        user.setLoyalDate(new java.util.Date());
                        if (user.getTierName() == null || user.getTierName().isEmpty()) {
                            user.setTierName("Đồng");
                        }
                        session.setAttribute("user", user);
                    }
                }
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }


        if (isSuccess) {
            session.setAttribute("successMsg", "Kích hoạt thành viên Khách hàng quen thành công! Hệ thống đã mở khóa tiến trình tích lũy thăng hạng của bạn.");
        } else {
            session.setAttribute("errorMsg", "Hệ thống gặp sự cố khi lưu trạng thái. Vui lòng thử lại sau!");
        }

        response.sendRedirect(request.getContextPath() + "/account");
    }

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        doPost(request, response);
    }
}