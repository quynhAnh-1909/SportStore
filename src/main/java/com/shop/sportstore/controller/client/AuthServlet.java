package com.shop.sportstore.controller.client;

import com.shop.sportstore.dao.UserDAO;
import com.shop.sportstore.model.FacebookUser;
import com.shop.sportstore.model.GoogleUser;
import com.shop.sportstore.model.User;
import com.shop.sportstore.untils.FacebookUtils;
import com.shop.sportstore.untils.GoogleUtils;

import com.shop.sportstore.untils.MailUtils;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.*;
import java.io.IOException;

@WebServlet(urlPatterns = {
        "/login",
        "/register",
        "/logout",
        "/login-google",
        "/login-facebook",
        "/forgot-password",
        "/verify-otp",
        "/reset-password"
})
public class AuthServlet extends HttpServlet {

    private UserDAO dao;

    @Override
    public void init() {
        dao = new UserDAO();
    }

    private void loginUser(HttpSession session, HttpServletRequest request,
                           HttpServletResponse response, User user) throws IOException {

        session.setAttribute("user", user);
        session.setAttribute("userId", user.getUserId());
        session.setAttribute("userFullName", user.getFullName());
        session.setAttribute("userRole", user.getRole());


        session.removeAttribute("errorMessage");
        session.removeAttribute("activeTab");
        session.removeAttribute("oldUser");

        if ("ADMIN".equals(user.getRole())) {
            response.sendRedirect(request.getContextPath() + "/admin/");
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

            case "/forgot-password":
                forgotPassword(request,response,session);
                break;

            case "/verify-otp":
                verifyOTP(request,response,session);
                break;

            case "/reset-password":
                resetPassword(request,response,session);
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

    private void handleLogin(HttpServletRequest request, HttpServletResponse response, HttpSession session)
            throws ServletException, IOException {

        String email = request.getParameter("email");
        String pass = request.getParameter("password");

        User oldUser = new User();
        oldUser.setEmail(email);
        session.setAttribute("oldUser", oldUser);


        session.setAttribute("activeTab", "login");


        Long lockTime = (Long) session.getAttribute("lockTime");
        if (lockTime != null) {
            long currentTime = System.currentTimeMillis();
            long unlockTime = lockTime + (15 * 60 * 1000);

            if (currentTime < unlockTime) {
                long remainingMinutes = (unlockTime - currentTime) / (60 * 1000);
                if (remainingMinutes == 0) remainingMinutes = 1;

                session.setAttribute("errorMessage", "Tài khoản tạm khóa. Vui lòng thử lại sau " + remainingMinutes + " phút.");
                response.sendRedirect(request.getContextPath() + "/products?showLogin=true");
                return;
            } else {

                session.removeAttribute("lockTime");
                session.removeAttribute("loginAttempts");
            }
        }

        User user = dao.checkLogin(email, pass);

        if (user != null) {
            if (!user.isStatus()) {
                session.setAttribute("errorMessage", "Tài khoản của bạn đã bị khóa do vi phạm chính sách hủy đơn!");
                response.sendRedirect(request.getContextPath() + "/products?showLogin=true");
                return;
            }
            session.removeAttribute("loginAttempts");
            loginUser(session, request, response, user);

        } else {

            Integer attempts = (Integer) session.getAttribute("loginAttempts");
            if (attempts == null) attempts = 0;
            attempts++;
            session.setAttribute("loginAttempts", attempts);

            if (attempts >= 5) {
                session.setAttribute("lockTime", System.currentTimeMillis());
                session.setAttribute("errorMessage", "Sai mật khẩu 5 lần. Tài khoản bị khóa 15 phút!");
            } else {
                session.setAttribute("errorMessage", "Email hoặc mật khẩu không chính xác! (Lần " + attempts + "/5)");
            }
            response.sendRedirect(request.getContextPath() + "/products?showLogin=true");
        }
    }

    private void forgotPassword(
            HttpServletRequest request,
            HttpServletResponse response,
            HttpSession session)
            throws IOException {

        String email =
                request.getParameter("email");

        User user =
                dao.findByEmail(email);

        response.setContentType("application/json");

        if(user == null){

            response.getWriter().write(
                    "{\"success\":false,\"message\":\"Email không tồn tại\"}"
            );

            return;
        }

        String otp =
                String.valueOf(
                        (int)(100000 + Math.random()*900000)
                );

        session.setAttribute("OTP", otp);
        session.setAttribute("OTP_EMAIL", email);

        try{

//            MailUtils.sendOTP(email, otp);

            response.getWriter().write(
                    "{\"success\":true}"
            );

        }catch(Exception e){

            e.printStackTrace();

            response.getWriter().write(
                    "{\"success\":false,\"message\":\"Không gửi được OTP\"}"
            );
        }
    }

    private void verifyOTP(
            HttpServletRequest request,
            HttpServletResponse response,
            HttpSession session)
            throws IOException {

        String userOTP =
                request.getParameter("otp");

        String sessionOTP =
                (String)session.getAttribute("OTP");

        response.setContentType("application/json");

        if(sessionOTP != null &&
                sessionOTP.equals(userOTP)){

            response.getWriter().write(
                    "{\"success\":true}"
            );

        }else{

            response.getWriter().write(
                    "{\"success\":false}"
            );
        }
    }

    private void resetPassword(
            HttpServletRequest request,
            HttpServletResponse response,
            HttpSession session)
            throws IOException {

        String newPassword =
                request.getParameter("password");

        String email =
                (String)session.getAttribute("OTP_EMAIL");

        boolean ok =
                dao.updatePassword(
                        email,
                        newPassword
                );

        response.setContentType("application/json");

        response.getWriter().write(
                "{\"success\":"+ok+"}"
        );
    }

    private void handleRegister(HttpServletRequest request, HttpServletResponse response, HttpSession session)
            throws ServletException, IOException {

        User newUser = new User();
        newUser.setFullName(request.getParameter("hoTen"));
        newUser.setEmail(request.getParameter("email"));
        newUser.setPassword(request.getParameter("matKhau"));
        newUser.setGioiTinh(request.getParameter("gioiTinh"));


        String rawPhone = request.getParameter("soDienThoai");
        if (rawPhone != null) {
            rawPhone = rawPhone.replaceAll("\\s+", "");
        }
        newUser.setPhoneNumber(rawPhone);

        newUser.setRole("USER");
        newUser.setStatus(true);

        session.setAttribute("oldUser", newUser);


        session.setAttribute("activeTab", "register");

        if (dao.registerUser(newUser)) {
            User user = dao.findByEmail(newUser.getEmail());
            loginUser(session, request, response, user);
        } else {
            session.setAttribute("errorMessage", "Đăng ký thất bại! Email này đã được đăng ký sử dụng trong hệ thống.");
            response.sendRedirect(request.getContextPath() + "/products?showLogin=true");
        }
    }

    private void handleGoogleLogin(HttpServletRequest request, HttpServletResponse response, HttpSession session)
            throws IOException {

        String code = request.getParameter("code");
        session.setAttribute("activeTab", "login");

        try {
            if (code == null) {
                String clientId = "1021470481637-vv36ulkhn7f0mv47vumauputq70rqnt7.apps.googleusercontent.com";
                String redirectUri = "https://norbert-wintrier-nicol.ngrok-free.dev/login-google";
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

            System.out.println("EMAIL = " + googleUser.getEmail());
            System.out.println("NAME = " + googleUser.getName());
            System.out.println("AVATAR = " + googleUser.getPicture());

            User user =
                    dao.findOrCreateSocialUser(
                            googleUser.getEmail(),
                            googleUser.getName(),
                            "GOOGLE",
                            googleUser.getPicture()
                    );

            if (!user.isStatus()) {
                session.setAttribute("errorMessage", "Tài khoản của bạn đã bị khóa do vi phạm chính sách hủy đơn!");
                response.sendRedirect(request.getContextPath() + "/products?showLogin=true");
                return;
            }

            loginUser(session, request, response, user);

        } catch (Exception e) {
            e.printStackTrace();
            session.setAttribute("errorMessage", "Lỗi xác thực mạng xã hội Google, vui lòng thử lại!");
            response.sendRedirect(request.getContextPath() + "/products?showLogin=true");
        }
    }

    private void handleFacebookLogin(HttpServletRequest request, HttpServletResponse response, HttpSession session)
            throws IOException {

        String code = request.getParameter("code");
        session.setAttribute("activeTab", "login");

        try {
            if (code == null) {

                String appId = "3605093742977294";

                String redirectUri =
                        "https://norbert-wintrier-nicol.ngrok-free.dev/login-facebook";

                String fbURL = "https://www.facebook.com/v18.0/dialog/oauth?"
                        + "client_id=" + appId
                        + "&redirect_uri=" + redirectUri
                        + "&response_type=code"
                        + "&scope=public_profile";

                response.sendRedirect(fbURL);
                return;
            }

            String accessToken = FacebookUtils.getToken(code);
            FacebookUser fbUser = FacebookUtils.getUserInfo(accessToken);
            System.out.println("FB ID = " + fbUser.getId());
            System.out.println("FB NAME = " + fbUser.getName());
            System.out.println("FB EMAIL = " + fbUser.getEmail());

            if (fbUser.getEmail() == null) {
                fbUser.setEmail(fbUser.getId() + "@facebook.com");
            }

            String avatar =
                    "https://graph.facebook.com/"
                            + fbUser.getId()
                            + "/picture?type=large";

            User user = dao.findOrCreateSocialUser(
                    fbUser.getEmail(),
                    fbUser.getName(),
                    "FACEBOOK",
                    avatar
            );

            if (!user.isStatus()) {
                session.setAttribute("errorMessage", "Tài khoản của bạn đã bị khóa do vi phạm chính sách hủy đơn!");
                response.sendRedirect(request.getContextPath() + "/products?showLogin=true");
                return;
            }

            loginUser(session, request, response, user);

        } catch (Exception e) {
            e.printStackTrace();
            session.setAttribute("errorMessage", "Lỗi xác thực mạng xã hội Facebook, vui lòng thử lại!");
            response.sendRedirect(request.getContextPath() + "/products?showLogin=true");
        }
    }
}