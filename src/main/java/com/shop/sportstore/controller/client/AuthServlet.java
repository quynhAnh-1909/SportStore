package com.shop.sportstore.controller.client;

import com.shop.sportstore.dao.UserDAO;
import com.shop.sportstore.model.FacebookUser;
import com.shop.sportstore.model.GoogleUser;
import com.shop.sportstore.model.User;
import com.shop.sportstore.untils.FacebookUtils;
import com.shop.sportstore.untils.GoogleUtils;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.*;
import java.io.IOException;

@WebServlet(urlPatterns = {
        "/login",
        "/register",
        "/logout",
        "/login-google",
        "/login-facebook"
})
public class AuthServlet extends HttpServlet {

    private UserDAO dao;

    @Override
    public void init() {
        dao = new UserDAO();
    }

    // Cập nhật hàm loginUser để lưu thêm role và chuyển hướng Admin
    private void loginUser(HttpSession session, HttpServletRequest request,
                           HttpServletResponse response, User user) throws IOException {

        session.setAttribute("user", user);
        session.setAttribute("userId", user.getUserId());
        session.setAttribute("userFullName", user.getFullName());
        session.setAttribute("userRole", user.getRole());

        if ("ADMIN".equals(user.getRole())) {
            response.sendRedirect(request.getContextPath() + "/admin/dashboard");
        } else {
            response.sendRedirect(request.getContextPath() + "/products");
        }
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        request.setCharacterEncoding("UTF-8");
        String path = request.getServletPath();
        HttpSession session = request.getSession();

        switch (path) {
            case "/login":
                handleLogin(request, response, session);
                break;
            case "/register":
                handleRegister(request, response, session);
                break;
            default:
                response.sendRedirect(request.getContextPath() + "/products");
        }
    }


    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        String path = request.getServletPath();
        HttpSession session = request.getSession();

        switch (path) {

            case "/logout":
                session.invalidate();
                response.sendRedirect(request.getContextPath() + "/products");
                break;

            case "/login":
            case "/register":
                response.sendRedirect(request.getContextPath() + "/products?showLogin=true");
                break;

            case "/login-google":
                handleGoogleLogin(request, response, session);
                break;

            case "/login-facebook":
                handleFacebookLogin(request, response, session);
                break;

            default:
                response.sendRedirect(request.getContextPath() + "/products");
        }
    }

    // ================= LOGIN (XỬ LÝ ĐẾM SAI PASS VÀ KHÓA TÀI KHOẢN) =================
    private void handleLogin(HttpServletRequest request,
                             HttpServletResponse response,
                             HttpSession session)
            throws ServletException, IOException {

        String email = request.getParameter("email");
        String pass = request.getParameter("password");

        // 1. Kiểm tra xem tài khoản có đang bị khóa 15 phút không
        Long lockTime = (Long) session.getAttribute("lockTime");
        if (lockTime != null) {
            long currentTime = System.currentTimeMillis();
            long unlockTime = lockTime + (15 * 60 * 1000); // 15 phút

            if (currentTime < unlockTime) {
                long remainingMinutes = (unlockTime - currentTime) / (60 * 1000);
                if (remainingMinutes == 0) remainingMinutes = 1; // Hiển thị tối thiểu 1 phút

                session.setAttribute("errorLogin", "Tài khoản tạm khóa. Vui lòng thử lại sau " + remainingMinutes + " phút.");
                response.sendRedirect(request.getContextPath() + "/products?showLogin=true");
                return; // Chặn luôn
            } else {
                // Đã hết 15 phút -> Xóa trạng thái khóa
                session.removeAttribute("lockTime");
                session.removeAttribute("loginAttempts");
            }
        }

        User user = dao.checkLogin(email, pass);

        if (user != null) {
            // 2. Kiểm tra xem tài khoản có bị khóa vĩnh viễn (do hủy đơn) trong Database không
            if (!user.isStatus()) {
                session.setAttribute("errorLogin", "Tài khoản của bạn đã bị khóa do vi phạm chính sách hủy đơn!");
                response.sendRedirect(request.getContextPath() + "/products?showLogin=true");
                return;
            }

            // Đăng nhập thành công -> Xóa đếm lỗi và Login
            session.removeAttribute("loginAttempts");
            loginUser(session, request, response, user);

        } else {
            // 3. Đăng nhập thất bại -> Đếm số lần sai
            Integer attempts = (Integer) session.getAttribute("loginAttempts");
            if (attempts == null) attempts = 0;
            attempts++;
            session.setAttribute("loginAttempts", attempts);

            if (attempts >= 5) {
                session.setAttribute("lockTime", System.currentTimeMillis());
                session.setAttribute("errorLogin", "Sai mật khẩu 5 lần. Tài khoản bị khóa 15 phút!");
            } else {
                session.setAttribute("errorLogin", "Email hoặc mật khẩu không chính xác! (Lần " + attempts + "/5)");
            }
            response.sendRedirect(request.getContextPath() + "/products?showLogin=true");
        }
    }

    // ================= REGISTER =================
    private void handleRegister(HttpServletRequest request,
                                HttpServletResponse response,
                                HttpSession session)
            throws ServletException, IOException {

        User newUser = new User();
        newUser.setFullName(request.getParameter("hoTen"));
        newUser.setEmail(request.getParameter("email"));
        newUser.setPassword(request.getParameter("matKhau"));
        newUser.setPhoneNumber(request.getParameter("soDienThoai"));
        newUser.setRole("USER");

        if (dao.registerUser(newUser)) {
            User user = dao.findByEmail(newUser.getEmail());
            loginUser(session, request, response, user);
        } else {
            request.setAttribute("errorRegister", "Email đã tồn tại!");
            request.setAttribute("oldUser", newUser);
            request.getRequestDispatcher("/products.jsp")
                    .forward(request, response);
        }
    }

    /* ================= GOOGLE LOGIN ================= */
    private void handleGoogleLogin(HttpServletRequest request,
                                   HttpServletResponse response,
                                   HttpSession session)
            throws IOException {

        String code = request.getParameter("code");

        try {
            if (code == null) {
                String clientId = "YOUR_CLIENT_ID";
                String redirectUri = "http://localhost:8080/SportStore/login-google";
                String googleURL = "https://accounts.google.com/o/oauth2/v2/auth?"
                        + "scope=email profile"
                        + "&redirect_uri=" + redirectUri
                        + "&response_type=code"
                        + "&client_id=" + clientId;
                response.sendRedirect(googleURL);
                return;
            }

            String accessToken = GoogleUtils.getToken(code);
            GoogleUser googleUser = GoogleUtils.getUserInfo(accessToken);

            User user = dao.findOrCreateSocialUser(
                    googleUser.getEmail(),
                    googleUser.getName(),
                    "GOOGLE"
            );

            // Chặn đăng nhập nếu account Google này đã bị khóa do hủy đơn
            if (!user.isStatus()) {
                session.setAttribute("errorLogin", "Tài khoản của bạn đã bị khóa do vi phạm chính sách hủy đơn!");
                response.sendRedirect(request.getContextPath() + "/products?showLogin=true");
                return;
            }

            loginUser(session, request, response, user);

        } catch (Exception e) {
            e.printStackTrace();
            response.sendRedirect(request.getContextPath() + "/login");
        }
    }

    /* ================= FACEBOOK LOGIN ================= */
    private void handleFacebookLogin(HttpServletRequest request,
                                     HttpServletResponse response,
                                     HttpSession session)
            throws IOException {

        String code = request.getParameter("code");

        try {
            if (code == null) {
                String appId = "YOUR_FB_APP_ID";
                String redirectUri = "http://localhost:8080/SportStore/login-facebook";
                String fbURL = "https://www.facebook.com/v18.0/dialog/oauth?"
                        + "client_id=" + appId
                        + "&redirect_uri=" + redirectUri
                        + "&response_type=code"
                        + "&scope=email,public_profile";
                response.sendRedirect(fbURL);
                return;
            }

            String accessToken = FacebookUtils.getToken(code);
            FacebookUser fbUser = FacebookUtils.getUserInfo(accessToken);

            if (fbUser.getEmail() == null) {
                fbUser.setEmail(fbUser.getId() + "@facebook.com");
            }

            User user = dao.findOrCreateSocialUser(
                    fbUser.getEmail(),
                    fbUser.getName(),
                    "FACEBOOK"
            );

            // Chặn đăng nhập nếu account Facebook này đã bị khóa do hủy đơn
            if (!user.isStatus()) {
                session.setAttribute("errorLogin", "Tài khoản của bạn đã bị khóa do vi phạm chính sách hủy đơn!");
                response.sendRedirect(request.getContextPath() + "/products?showLogin=true");
                return;
            }

            loginUser(session, request, response, user);

        } catch (Exception e) {
            e.printStackTrace();
            response.sendRedirect(request.getContextPath() + "/login");
        }
    }
}