package com.hagl.controller.client;


import java.io.IOException;
import java.sql.SQLException;
import java.util.List;
import java.util.Map;

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;

import com.hagl.dao.TicketDAO;

@WebServlet("/account")
public class AccountServlet extends HttpServlet {
    protected void doGet(HttpServletRequest request, HttpServletResponse response) 
            throws ServletException, IOException {
        
        request.setCharacterEncoding("UTF-8");
        response.setCharacterEncoding("UTF-8");
        
        HttpSession session = request.getSession(false); // Dùng false để tránh tự tạo session mới
        Integer userId = (session != null) ? (Integer) session.getAttribute("userId") : null; 

        if (userId == null) {
           
            response.sendRedirect(request.getContextPath() + "/login"); 
            return;
        }

        try {
            TicketDAO ticketDAO = new TicketDAO();
            List<Map<String, Object>> ticketList = ticketDAO.getTicketsByUserId(userId);
            
            request.setAttribute("ticketList", ticketList);
            
            // SỬA LỖI 404 TẠI ĐÂY: Trỏ đúng vào thư mục views/client/
            request.getRequestDispatcher("/WEB-INF/views/client/account.jsp").forward(request, response);
            
        } catch (SQLException e) {
            e.printStackTrace();
            // Đảm bảo trang error.jsp cũng nằm trong thư mục đúng
            request.getRequestDispatcher("/WEB-INF/views/client/error.jsp").forward(request, response);
        }
    }
}