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
import java.sql.SQLException;

@WebServlet("/change-password")
public class ChangePasswordServlet extends HttpServlet {

    private final UserDAO userDAO = new UserDAO();

    @Override
    protected void doPost(HttpServletRequest request,
                          HttpServletResponse response)
            throws ServletException, IOException {

        HttpSession session = request.getSession();

        User user =
                (User) session.getAttribute("user");

        if (user == null) {
            response.sendRedirect("products");
            return;
        }

        String currentPassword =
                request.getParameter("currentPassword");

        String newPassword =
                request.getParameter("newPassword");

        String confirmPassword =
                request.getParameter("confirmPassword");


        User dbUser;

        try {

            dbUser = userDAO.getUserById(user.getUserId());

            if (dbUser == null) {

                System.out.println("KHONG TIM THAY USER ID = "
                        + user.getUserId());

                session.setAttribute(
                        "passwordError",
                        "Không tìm thấy tài khoản!"
                );

                response.sendRedirect("account");
                return;
            }

        } catch (SQLException e) {

            e.printStackTrace();

            session.setAttribute(
                    "passwordError",
                    "Lỗi hệ thống!"
            );

            response.sendRedirect("account");
            return;
        }

        if (!dbUser.getPassword().equals(currentPassword)) {

            session.setAttribute(
                    "passwordError",
                    "Mật khẩu hiện tại không đúng"
            );

            response.sendRedirect("account");
            return;
        }

        if (!newPassword.equals(confirmPassword)) {

            session.setAttribute(
                    "passwordError",
                    "Mật khẩu xác nhận không khớp"
            );

            response.sendRedirect("account");
            return;
        }

        System.out.println("USER ID = " + user.getUserId());
        System.out.println("NEW PASSWORD = " + newPassword);

        boolean updated =
                userDAO.changePassword(
                        user.getUserId(),
                        newPassword
                );

        System.out.println("UPDATED = " + updated);

        if (!updated) {

            session.setAttribute(
                    "passwordError",
                    "Không thể cập nhật mật khẩu!"
            );

            response.sendRedirect("account");
            return;
        }

        session.setAttribute(
                "passwordSuccess",
                "Đổi mật khẩu thành công"
        );

        response.sendRedirect("account");
    }
}
