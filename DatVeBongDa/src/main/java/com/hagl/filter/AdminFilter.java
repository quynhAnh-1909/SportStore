package com.hagl.filter;

import java.io.IOException;

import javax.servlet.Filter;
import javax.servlet.FilterChain;
import javax.servlet.ServletException;
import javax.servlet.ServletRequest;
import javax.servlet.ServletResponse;
import javax.servlet.annotation.WebFilter;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;

import com.hagl.model.User;





// Filter này chỉ chặn các đường dẫn quản lý thực sự (ví dụ: dashboard, manageMatch, deleteMatch)
@WebFilter(urlPatterns = {"/admin/*", "/manager"}) // "/manager" là Servlet gộp Sửa/Xóa/Thêm chúng ta vừa làm
public class AdminFilter implements Filter {

    @Override
    public void doFilter(ServletRequest request, ServletResponse response, FilterChain chain)
            throws IOException, ServletException {
        
        HttpServletRequest httpRequest = (HttpServletRequest) request;
        HttpServletResponse httpResponse = (HttpServletResponse) response;
        HttpSession session = httpRequest.getSession(false);

        User user = (session != null) ? (User) session.getAttribute("user") : null;//kiểm tra thông tin k tạo session 
        String path = httpRequest.getServletPath();

        // 1. Kiểm tra nếu đang truy cập vào vùng Admin
        if (path.startsWith("/admin") || path.equals("/manager")) {
            if (user != null && "ADMIN".equalsIgnoreCase(user.getRole())) {
                chain.doFilter(request, response);
            } 
            else {
                request.getRequestDispatcher("/WEB-INF/views/client/error.jsp")
                       .forward(request, response);
                return;
            }
        } else {
            chain.doFilter(request, response);
        }

}}