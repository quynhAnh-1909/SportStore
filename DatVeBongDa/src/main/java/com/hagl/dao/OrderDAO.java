package com.hagl.dao;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

import com.hagl.model.CartItem;

public class OrderDAO extends BaseDAO {

    // Cập nhật trạng thái đơn hàng
    public void updateOrderStatus(String orderCode, String status) throws SQLException {

        String sql = "UPDATE Orders SET Status = ? WHERE OrderCode = ?";

        try (Connection conn = getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {

            ps.setString(1, status);
            ps.setString(2, orderCode);

            ps.executeUpdate();
        }
    }

    // Lấy thông tin đơn hàng để gửi email
    public Map<String, String> getOrderDetailForEmail(String orderCode) throws SQLException {

        Map<String, String> data = new HashMap<>();

        String sql =
                "SELECT o.Id, o.TotalPrice, u.Id AS userId, u.FullName, u.Email " +
                "FROM Orders o " +
                "JOIN Users u ON o.UserId = u.Id " +
                "WHERE o.OrderCode = ?";

        try (Connection conn = getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {

            ps.setString(1, orderCode);

            ResultSet rs = ps.executeQuery();

            if (rs.next()) {

                data.put("orderId", rs.getString("Id"));
                data.put("userId", rs.getString("userId"));
                data.put("fullName", rs.getString("FullName"));
                data.put("email", rs.getString("Email"));
                data.put("totalPrice", rs.getString("TotalPrice"));
            }
        }

        return data;
    }

    // Kiểm tra trạng thái đơn hàng
    public String getOrderStatus(String orderCode) throws SQLException {

        String status = null;

        String sql = "SELECT Status FROM Orders WHERE OrderCode = ?";

        try (Connection conn = getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {

            ps.setString(1, orderCode);

            ResultSet rs = ps.executeQuery();

            if (rs.next()) {
                status = rs.getString("Status");
            }
        }

        return status;
    }

	public void createOrder(Integer userId, String orderCode, double total, String string, String string2,
			List<CartItem> cart) {
		// TODO Auto-generated method stub
		
	}
}