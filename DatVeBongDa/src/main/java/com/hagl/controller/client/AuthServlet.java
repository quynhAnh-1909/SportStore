package com.hagl.controller.client;

import com.hagl.dao.UserDAO;
import com.hagl.model.User;
import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;
import java.io.IOException;
import java.sql.SQLException;

@WebServlet(urlPatterns = {"/login", "/register", "/logout"})
public class AuthServlet extends HttpServlet {

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response) 
            throws ServletException, IOException {
        request.setCharacterEncoding("UTF-8");
        String path = request.getServletPath(); // lấy đường dẫn hiện tại (login / register)
        UserDAO dao = new UserDAO();   //làm việc với db 
        HttpSession session = request.getSession(); // lưu uẻ sau khi login , register

        try {
            if (path.equals("/login")) {
                String email = request.getParameter("email"); // lấy email từ jsp 
                String pass = request.getParameter("password"); //lấy pass từ jsp 
                User user = dao.checkLogin(email, pass); // kiểm tra xem có nằm trong db chưa

                if (user != null) {

                    session.setAttribute("user", user);
                    session.setAttribute("userId", user.getUserId());

                    // chuyển sang productList
                    response.sendRedirect(request.getContextPath() + "/productList");

                } else {

                    request.setAttribute("errorMessage", "Email hoặc mật khẩu không chính xác!");
                    request.getRequestDispatcher("/WEB-INF/views/client/login.jsp")
                           .forward(request, response);
                }
                }

        else if (path.equals("/register")) {
                // 1. Khởi tạo đối tượng newUser
                User newUser = new User();
                
                // 2. Lấy dữ liệu từ Form (Đảm bảo tên trong getParameter trùng với thuộc tính 'name' trong JSP)
                String hoTen = request.getParameter("hoTen");
                String email = request.getParameter("email");
                String matKhau = request.getParameter("matKhau");
                String soDienThoai = request.getParameter("soDienThoai");

                // 3. Gán giá trị vào object (Role mặc định là USER khi đăng ký mới)
                newUser.setFullName(hoTen);
                newUser.setEmail(email);
                newUser.setPassword(matKhau);
                newUser.setPhoneNumber(soDienThoai);
                newUser.setRole("USER"); 

                // 4. Gọi DAO để lưu vào Database
                if (dao.registerUser(newUser)) {
                    request.setAttribute("successMessage", "Đăng ký thành công! Hãy đăng nhập.");
                    request.getRequestDispatcher("/WEB-INF/views/client/login.jsp").forward(request, response);
                } else {
                    request.setAttribute("errorMessage", "Email này đã tồn tại hoặc có lỗi xảy ra!");
                    // Giữ lại dữ liệu cũ để người dùng không phải nhập lại (trừ mật khẩu)
                    request.setAttribute("oldUser", newUser); 
                    request.getRequestDispatcher("/WEB-INF/views/client/register.jsp").forward(request, response);
                }
            }
        } catch (SQLException e) {
            e.printStackTrace();
            request.getRequestDispatcher("/WEB-INF/views/client/error.jsp").forward(request, response);
        }
    }

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response) 
            throws ServletException, IOException {
        String path = request.getServletPath();
        if (path.equals("/logout")) {
            request.getSession().invalidate(); // xóa toàn bộ session 
            response.sendRedirect(request.getContextPath() + "/productList");
        } else if (path.equals("/register")) {
            request.getRequestDispatcher("/WEB-INF/views/client/register.jsp").forward(request, response);
        } else {
            request.getRequestDispatcher("/WEB-INF/views/client/login.jsp").forward(request, response);
        }
    }
}