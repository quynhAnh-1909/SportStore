package com.shop.sportstore.filter;

import jakarta.servlet.*;
import jakarta.servlet.annotation.WebFilter;
import jakarta.servlet.http.*;

import java.io.IOException;

@WebFilter("/admin/*")
public class AdminFilter implements Filter {

    @Override
    public void doFilter(ServletRequest request,
                         ServletResponse response,
                         FilterChain chain)
            throws IOException, ServletException {

        HttpServletRequest req =
                (HttpServletRequest) request;

        HttpServletResponse resp =
                (HttpServletResponse) response;

        HttpSession session =
                req.getSession(false);

        if (session == null) {
            resp.sendRedirect(
                    req.getContextPath() + "/login");
            return;
        }

        String role =
                (String) session.getAttribute("userRole");

        if (!"ADMIN".equals(role)) {

            req.setAttribute(
                    "errorMessage",
                    "Bạn không có quyền truy cập trang này!"
            );

            req.getRequestDispatcher("/error.jsp")
                    .forward(req, resp);

            return;
        }
        chain.doFilter(request, response);
    }
}