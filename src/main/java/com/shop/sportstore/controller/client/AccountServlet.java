package com.shop.sportstore.controller.client;



import com.shop.sportstore.model.User;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;

import java.io.IOException;

@WebServlet("/account")
public class AccountServlet extends HttpServlet {
    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        HttpSession session = request.getSession(false);
        if (session != null && session.getAttribute("user") != null) {
            User user = (User) session.getAttribute("user");
            if (user.getAvatar() == null) {
                user.setAvatar("/images/default-avatar.png");
            }
            request.setAttribute("user", user);
            request.setAttribute("user", user);
            request.getRequestDispatcher("/WEB-INF/client/account.jsp").forward(request, response);
        } else {
            response.sendRedirect("/authjsp");
        }
    }
}