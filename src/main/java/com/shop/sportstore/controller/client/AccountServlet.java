package com.shop.sportstore.controller.client;

import com.shop.sportstore.dao.OrderDAO;
import com.shop.sportstore.dao.UserDAO;
import com.shop.sportstore.model.Order;
import com.shop.sportstore.model.User;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.MultipartConfig;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
import jakarta.servlet.http.Part;

import java.io.IOException;
import java.io.InputStream;
import java.nio.charset.StandardCharsets;
import java.util.List;
import java.util.Scanner;

@WebServlet("/account")
@MultipartConfig(
        fileSizeThreshold = 1024 * 1024 * 2,
        maxFileSize = 1024 * 1024 * 10,
        maxRequestSize = 1024 * 1024 * 50
)
public class AccountServlet extends HttpServlet {

    private final OrderDAO orderDAO = new OrderDAO();
    private final UserDAO userDAO = new UserDAO();

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        HttpSession session = request.getSession(false);
        if (session != null && session.getAttribute("user") != null) {
            User user = (User) session.getAttribute("user");


            if (user.getAvatar() == null || user.getAvatar().trim().isEmpty()) {
                user.setAvatar("/resources/default-avatar.png");
            }


            try {
                boolean currentLoyalStatus = userDAO.checkLoyalStatus(user.getUserId());
                user.setLoyal(currentLoyalStatus);
            } catch (Exception e) {
                e.printStackTrace();
            }

            List<Order> listOrders = orderDAO.getOrdersByUser(user.getUserId());
            request.setAttribute("orders", listOrders);


            calculateUserTier(user, request);

            request.setAttribute("user", user);
            request.getRequestDispatcher("/WEB-INF/client/account.jsp").forward(request, response);
        } else {
            response.sendRedirect(request.getContextPath() + "/auth.jsp");
        }
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        request.setCharacterEncoding("UTF-8");
        response.setCharacterEncoding("UTF-8");
        HttpSession session = request.getSession(false);

        if (session == null || session.getAttribute("user") == null) {
            response.sendRedirect(request.getContextPath() + "/auth.jsp");
            return;
        }

        User user = (User) session.getAttribute("user");
        String action = getParamFromMultipart(request, "action");

        if ("editProfile".equals(action)) {
            String fullName = getParamFromMultipart(request, "fullName");
            String phone = getParamFromMultipart(request, "phone");
            String address = getParamFromMultipart(request, "address");

            if (fullName == null || fullName.trim().isEmpty()) {
                fullName = user.getFullName();
            }
            if (phone == null || phone.trim().isEmpty()) {
                phone = user.getPhoneNumber();
            }

            String phoneRegex = "^(0[3|5|7|8|9])+([0-9]{8})$";
            if (!phone.trim().isEmpty() && !phone.matches(phoneRegex)) {
                session.setAttribute("errorMsg", "Cập nhật thất bại! Số điện thoại không đúng cấu trúc.");
                response.sendRedirect(request.getContextPath() + "/account");
                return;
            }

            String finalAddress = (address != null && !address.trim().isEmpty()) ? address.trim() : null;

            try {
                boolean isUpdated = userDAO.updateBasicInfo(user.getUserId(), fullName, phone, finalAddress);

                if (isUpdated) {
                    user.setFullName(fullName);
                    user.setPhoneNumber(phone);
                    user.setAddress(finalAddress);

                    calculateUserTier(user, null);

                    session.setAttribute("user", user);
                    session.setAttribute("successMsg", "Cập nhật thông tin cá nhân thành công!");
                } else {
                    session.setAttribute("errorMsg", "Cập nhật thất bại! Vui lòng kiểm tra lại dữ liệu.");
                }
            } catch (Exception e) {
                e.printStackTrace();
                session.setAttribute("errorMsg", "Lỗi hệ thống khi cập nhật cơ sở dữ liệu!");
            }
        }

        response.sendRedirect(request.getContextPath() + "/account");
    }

    private void calculateUserTier(User user, HttpServletRequest request) {
        double totalSpending = orderDAO.getTotalSpendingByUserId(user.getUserId());
        user.setTotalSpending(totalSpending);

        String tierName = "Đồng";
        int nextTierProgress = 0;

        double MOC_BAC = 5000000;
        double MOC_VANG = 15000000;
        double MOC_KIM_CUONG = 40000000;

        if (totalSpending >= MOC_KIM_CUONG) {
            tierName = "Kim Cương";
            nextTierProgress = 100;
        } else if (totalSpending >= MOC_VANG) {
            tierName = "Vàng";
            double range = MOC_KIM_CUONG - MOC_VANG;
            nextTierProgress = (int) (((totalSpending - MOC_VANG) / range) * 100);
        } else if (totalSpending >= MOC_BAC) {
            tierName = "Bạc";
            double range = MOC_VANG - MOC_BAC;
            nextTierProgress = (int) (((totalSpending - MOC_BAC) / range) * 100);
        } else {
            tierName = "Đồng";
            nextTierProgress = (int) ((totalSpending / MOC_BAC) * 100);
        }

        user.setTierName(tierName);
        if (request != null) {
            request.setAttribute("nextTierProgress", nextTierProgress);
        }
    }

    private String getParamFromMultipart(HttpServletRequest request, String paramName) throws ServletException, IOException {
        try {
            Part part = request.getPart(paramName);
            if (part != null) {
                try (InputStream is = part.getInputStream();
                     Scanner scanner = new Scanner(is, StandardCharsets.UTF_8.name())) {
                    return scanner.hasNext() ? scanner.useDelimiter("\\A").next().trim() : "";
                }
            }
        } catch (Exception e) {

        }
        return request.getParameter(paramName);
    }
}