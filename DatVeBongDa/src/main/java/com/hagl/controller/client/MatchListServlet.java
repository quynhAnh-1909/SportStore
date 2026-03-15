package com.hagl.controller.client;

import java.io.IOException;
import java.sql.SQLException;

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import com.hagl.dao.MatchDAO;

@WebServlet("/matchList")
public class MatchListServlet extends HttpServlet {
    private MatchDAO matchDAO;

    @Override
    public void init() {  // khởi tạo dao sau khi sẻvlet load đê tiết kiệm taì nguyên
        matchDAO = new MatchDAO(); 
    }
// chạy sau khi người dùng bấm mở trang chủ , sau khi đăng nhập , sau khi admin thêm sửa xóa 
    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response) 
           throws ServletException, IOException {
        
        try {
            // 1. Gọi DAO để lấy danh sách trận đấu 
            request.setAttribute("matchList", matchDAO.getAllMatches());
            
            // 2. CẬP NHẬT ĐƯỜNG DẪN: Thêm /WEB-INF/ vào trước views
            // Vì thư mục views của bạn nằm trong WEB-INF nên phải gọi như thế này:
            request.getRequestDispatcher("/WEB-INF/views/client/matchList.jsp").forward(request, response);
            
        } catch (SQLException e) {
            e.printStackTrace();
            request.setAttribute("errorMessage", "Lỗi truy vấn CSDL: Không thể lấy danh sách trận đấu.");
            request.getRequestDispatcher("/WEB-INF/views/client/error.jsp").forward(request, response);
        } catch (RuntimeException e) {
            e.printStackTrace();
            request.setAttribute("errorMessage", "Lỗi cấu hình CSDL: Không tìm thấy Connection Pool.");
            request.getRequestDispatcher("/WEB-INF/views/client/error.jsp").forward(request, response);
        }
    }
}