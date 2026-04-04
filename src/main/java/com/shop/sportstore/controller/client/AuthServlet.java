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

    private void loginUser(HttpSession session, HttpServletRequest request,
                           HttpServletResponse response, User user) throws IOException {

        session.setAttribute("user", user);
        session.setAttribute("userId", user.getUserId());

        response.sendRedirect(request.getContextPath() + "/products");
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

    //LOGIN
    private void handleLogin(HttpServletRequest request,
                             HttpServletResponse response,
                             HttpSession session)
            throws ServletException, IOException {

        String email = request.getParameter("email");
        String pass = request.getParameter("password");

        User user = dao.checkLogin(email, pass);

        if (user != null) {
            loginUser(session, request, response, user);
        } else {
            request.setAttribute("errorLogin", "Email hoặc mật khẩu không chính xác!");
            response.sendRedirect(request.getContextPath() + "/products?showLogin=true");
        }
    }

    // REGISTER
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
            request.setAttribute("oldUser", newUser); // lưu dữ liệu cũ
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

            loginUser(session, request, response, user);

        } catch (Exception e) {
            e.printStackTrace();
            response.sendRedirect(request.getContextPath() + "/login");
        }
    }
}