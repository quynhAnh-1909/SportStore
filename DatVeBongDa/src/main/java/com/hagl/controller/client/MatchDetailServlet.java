package com.hagl.controller.client;

import java.io.IOException;
import java.sql.SQLException;

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import com.hagl.dao.MatchDAO;
import com.hagl.model.Match;

@WebServlet("/matchDetail")
public class MatchDetailServlet extends HttpServlet {
    protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        String idStr = request.getParameter("id");//lấy danh sách trận đấu từ matchdetail.jsp
        if (idStr != null) {
            try {
                int matchId = Integer.parseInt(idStr); // được lấy từ url , chuyển id sang dạng số do db dùng INT maf DAO cần int 
                MatchDAO dao = new MatchDAO();   // dao lay 
                
                Match match = dao.getMatchById(matchId); 
                
                if (match != null) {
                    request.setAttribute("match", match);
                    // SỬA TẠI ĐÂY: Trỏ đúng vào thư mục views/client/
                    request.getRequestDispatcher("/WEB-INF/views/client/matchDetail.jsp").forward(request, response);
                } else {
                    response.sendRedirect("matchList"); // Nếu không tìm thấy trận đấu  trả về trang danh sách trận đấu 
                }
            } catch (SQLException | NumberFormatException e) {
                e.printStackTrace();
                response.sendRedirect("/WEB-INF/views/client/error.jsp");
            }
        } else {
            response.sendRedirect("matchList");
        }
    }
}