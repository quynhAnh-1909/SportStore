package com.hagl.controller.admin;

import java.io.File;
import java.io.IOException;
import java.time.LocalDate;
import java.time.LocalTime;

import javax.servlet.ServletException;
import javax.servlet.annotation.MultipartConfig;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.Part;

import com.hagl.dao.MatchDAO;
import com.hagl.model.Match;

@WebServlet("/admin/manager")
@MultipartConfig(fileSizeThreshold = 1024 * 1024 * 2, maxFileSize = 1024 * 1024 * 10)//cho phép up ảnh 

public class MatchManagerServlet extends HttpServlet {
    private MatchDAO matchDAO = new MatchDAO();//giao tiếp vs db , sẻvlet k làm việc trực tiếp với sql

    @Override//hiển thị form sửa xóa , thêm 
    protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        String action = request.getParameter("action");//lấy action từ url
        try {
            if ("add".equals(action)) { 
                request.getRequestDispatcher("/WEB-INF/views/admin/editMatch.jsp").forward(request, response); //mở form editMatch co admin nhập dl 
            } else if ("edit".equals(action)) {
                int id = Integer.parseInt(request.getParameter("id")); //lấy id trận đấu từ url 
                request.setAttribute("match", matchDAO.getMatchById(id));//gọi DAO lấy dữ liệu trận 
                request.getRequestDispatcher("/WEB-INF/views/admin/editMatch.jsp").forward(request, response);//dẩy sang jsp hiển thị form dữ liệu có sẳn 
            } else if ("delete".equals(action)) {
                matchDAO.deleteMatch(Integer.parseInt(request.getParameter("id")));
                response.sendRedirect(request.getContextPath() + "/matchList");//sau khi xóa trả về matchlist
            }
        } catch (Exception e) { response.sendRedirect(request.getContextPath() + "/matchList"); }
    }
//xử lý thêm cập nhật nhấn save , gửi form lên thêm / sửa trận đấu 
    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        request.setCharacterEncoding("UTF-8");
        try {
            // Xử lý File Ảnh
            Part filePart = request.getPart("imageFile");
            String fileName = filePart.getSubmittedFileName();
            String finalImg = (fileName != null && !fileName.isEmpty()) ? fileName : request.getParameter("oldImageName");// giữ ảnh cũ nếu k upload
            
            if (fileName != null && !fileName.isEmpty()) {
                String path = getServletContext().getRealPath("/") + "resources";//lưu ảnh vào réources
                filePart.write(path + File.separator + fileName);
            }

            // Lấy dữ liệu form
            String idStr = request.getParameter("matchId");
            int id = (idStr == null || idStr.isEmpty()) ? 0 : Integer.parseInt(idStr);
            Match m = new Match(id, request.getParameter("opponent"), 
                               LocalDate.parse(request.getParameter("matchDate")), 
                               LocalTime.parse(request.getParameter("matchTime")), 
                               "", Double.parseDouble(request.getParameter("maxPrice")), 
                               Double.parseDouble(request.getParameter("minPrice")));
            m.setOpponentImageName(finalImg);
            int maSan = Integer.parseInt(request.getParameter("maSan"));

            if (id == 0) matchDAO.insertMatch(m, maSan);
            else matchDAO.updateMatch(m, maSan);

            response.sendRedirect(request.getContextPath() + "/matchList");//cập nhật dữ liệu ngay cho client 
        } catch (Exception e) { e.printStackTrace(); }
    }
}