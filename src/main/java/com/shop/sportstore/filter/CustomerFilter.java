package com.shop.sportstore.filter;

import com.shop.sportstore.model.User;
import jakarta.servlet.*;
import jakarta.servlet.annotation.WebFilter;
import jakarta.servlet.http.*;

import java.io.IOException;

@WebFilter({
        "/cart",
        "/checkout",
        "/buy-now",
        "/orders",
        "/order-history",
        "/order-detail"
})
public class CustomerFilter implements Filter {

    @Override
    public void doFilter(ServletRequest request,
                         ServletResponse response,
                         FilterChain chain)
            throws IOException, ServletException {

        HttpServletRequest req =
                (HttpServletRequest) request;

        HttpSession session = req.getSession(false);

        if (session != null) {

            User user = (User) session.getAttribute("user");

            if (user != null &&
                    "ADMIN".equals(user.getRole())) {

                req.setAttribute(
                        "errorMessage",
                        "Tài khoản Admin không được phép mua hàng."
                );

                req.getRequestDispatcher("/error.jsp")
                        .forward(req, response);

                return;
            }
        }

        chain.doFilter(request, response);
    }
}