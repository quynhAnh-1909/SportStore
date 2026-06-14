package com.shop.sportstore.controller.client;

import com.shop.sportstore.model.User;
import com.shop.sportstore.untils.DBConnection;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
import java.io.IOException;
import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;

@WebServlet("/save-voucher")
public class SaveVoucherServlet extends HttpServlet {

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {


        response.setContentType("application/json");
        response.setCharacterEncoding("UTF-8");

        HttpSession session = request.getSession();
        User user = (User) session.getAttribute("user");
        if (user == null) {
            user = (User) session.getAttribute("currentUser");
        }


        if (user == null) {
            response.getWriter().write("{\"status\":\"error\",\"message\":\"Vui lòng đăng nhập trước khi thực hiện lưu mã!\"}");
            return;
        }


        String voucherIdStr = request.getParameter("voucherId");
        if (voucherIdStr == null || voucherIdStr.isEmpty()) {
            response.getWriter().write("{\"status\":\"error\",\"message\":\"Dữ liệu mã ưu đãi không hợp lệ!\"}");
            return;
        }

        int voucherId = Integer.parseInt(voucherIdStr);
        int userId = user.getUserId();

        try (Connection conn = DBConnection.getConnection()) {


            String checkSavedSql = "SELECT 1 FROM user_vouchers WHERE user_id = ? AND voucher_id = ? AND order_id IS NULL LIMIT 1";
            try (PreparedStatement psCheck = conn.prepareStatement(checkSavedSql)) {
                psCheck.setInt(1, userId);
                psCheck.setInt(2, voucherId);
                try (ResultSet rsCheck = psCheck.executeQuery()) {
                    if (rsCheck.next()) {
                        response.getWriter().write("{\"status\":\"error\",\"message\":\"Mã giảm giá này đã có trong kho voucher của bạn rồi!\"}");
                        return;
                    }
                }
            }


            String insertSql = "INSERT INTO user_vouchers (user_id, voucher_id, order_id, used_at) VALUES (?, ?, NULL, NULL)";
            try (PreparedStatement psInsert = conn.prepareStatement(insertSql)) {
                psInsert.setInt(1, userId);
                psInsert.setInt(2, voucherId);
                psInsert.executeUpdate();
            }


            response.getWriter().write("{\"status\":\"success\"}");

        } catch (Exception e) {
            e.printStackTrace();
            response.getWriter().write("{\"status\":\"error\",\"message\":\"Lỗi hệ thống: Không thể ghi nhận mã ưu đãi vào kho!\"}");
        }
    }
}