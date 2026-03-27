package com.shop.sportstore.dao;

import com.shop.sportstore.model.Order;
import com.shop.sportstore.untils.DBConnection;
import com.shop.sportstore.model.CartItem;

import java.sql.*;
import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

public class OrderDAO extends DBConnection {

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
        String sql = "SELECT o.Id, o.TotalPrice, u.Id AS userId, u.FullName, u.Email " +
                "FROM Orders o " +
                "JOIN Users u ON o.UserId = u.Id " +
                "WHERE o.OrderCode = ?";
        try (Connection conn = getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setString(1, orderCode);
            try (ResultSet rs = ps.executeQuery()) {
                if (rs.next()) {
                    data.put("orderId", rs.getString("Id"));
                    data.put("userId", rs.getString("userId"));
                    data.put("fullName", rs.getString("FullName"));
                    data.put("email", rs.getString("Email"));
                    data.put("totalPrice", rs.getString("TotalPrice"));
                }
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
            try (ResultSet rs = ps.executeQuery()) {
                if (rs.next()) {
                    status = rs.getString("Status");
                }
            }
        }
        return status;
    }

    // Tạo đơn hàng mới và chi tiết đơn hàng
    public void createOrder(Integer userId, String orderCode, double total,
                            String status, String note, List<CartItem> cart) throws SQLException {

        String insertOrderSQL = "INSERT INTO orders (UserId, OrderCode, TotalPrice, Status, Note, CreatedAt) " +
                "VALUES (?, ?, ?, ?, ?, NOW())";
        String insertDetailSQL = "INSERT INTO orderDetails (OrderId, ProductId, Quantity, Price) VALUES (?, ?, ?, ?)";

        try (Connection conn = getConnection()) {
            conn.setAutoCommit(false);

            int orderId;

            // Thêm Order
            try (PreparedStatement psOrder = conn.prepareStatement(insertOrderSQL, Statement.RETURN_GENERATED_KEYS)) {
                psOrder.setInt(1, userId);
                psOrder.setString(2, orderCode);
                psOrder.setDouble(3, total);
                psOrder.setString(4, status);
                psOrder.setString(5, note);
                psOrder.executeUpdate();

                try (ResultSet rsKeys = psOrder.getGeneratedKeys()) {
                    if (rsKeys.next()) {
                        orderId = rsKeys.getInt(1);
                    } else {
                        throw new SQLException("Không lấy được ID đơn hàng.");
                    }
                }
            }

            try (PreparedStatement psDetail = conn.prepareStatement(insertDetailSQL)) {
                for (CartItem item : cart) {
                    if (item.getProduct() == null) {
                        throw new SQLException("CartItem không có Product hợp lệ.");
                    }
                    if (item.getProduct().getId() <= 0) {
                        throw new SQLException("Product ID không hợp lệ trong CartItem.");
                    }
                    psDetail.setInt(1, orderId);
                    psDetail.setInt(2, item.getProduct().getId());
                    psDetail.setInt(3, item.getQuantity());
                    psDetail.setDouble(4, item.getProduct().getPrice());
                    psDetail.addBatch();
                }
                psDetail.executeBatch();
            }
            conn.commit();
        } catch (SQLException e) {
            throw e; // để servlet xử lý và báo lỗi 500 nếu cần
        }
    }

    public List<Order> getAllOrders() {
        List<Order> orders = new ArrayList<>();
        String sql = "SELECT o.Id, o.UserId, o.OrderCode, o.TotalPrice, o.Status, o.PaymentMethod, o.Note, o.CreatedAt, " +
                "u.Full_Name AS userFullName " +
                "FROM orders o " +
                "JOIN users u ON o.UserId = u.User_id " +
                "ORDER BY o.CreatedAt DESC";

        try (Connection conn = getConnection();
             PreparedStatement ps = conn.prepareStatement(sql);
             ResultSet rs = ps.executeQuery()) {

            while (rs.next()) {
                Order order = new Order();
                order.setId(rs.getInt("Id"));
                order.setUserId(rs.getInt("UserId"));
                order.setOrderCode(rs.getString("OrderCode"));
                order.setTotalPrice(rs.getDouble("TotalPrice"));
                order.setStatus(rs.getString("Status"));
                order.setPaymentMethod(rs.getString("PaymentMethod"));
                order.setNote(rs.getString("Note"));
                order.setCreatedAt(rs.getTimestamp("CreatedAt"));
                order.setUserFullName(rs.getString("userFullName")); // join từ bảng users
                orders.add(order);
            }

        } catch (SQLException e) {
            e.printStackTrace(); // hoặc ném ra servlet để xử lý
        }

        return orders;
    }
    public List<Map<String, String>> getOrderItems(String orderCode) throws SQLException {
        List<Map<String, String>> items = new ArrayList<>();
        String sql = "SELECT p.id AS productId, p.name AS productName, p.price, od.Quantity " +
                "FROM OrderDetails od " +
                "JOIN orders o ON od.OrderId = o.Id " +
                "JOIN products p ON od.ProductId = p.id " +
                "WHERE o.OrderCode = ?";

        try (Connection conn = getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setString(1, orderCode);
            try (ResultSet rs = ps.executeQuery()) {
                while (rs.next()) {
                    Map<String, String> item = new HashMap<>();
                    item.put("productId", rs.getString("productId")); // ID sản phẩm
                    item.put("productName", rs.getString("productName"));
                    item.put("price", rs.getString("price"));
                    item.put("quantity", rs.getString("Quantity"));
                    item.put("subtotal", String.valueOf(rs.getDouble("price") * rs.getInt("Quantity")));
                    items.add(item);
                }
            }
        }
        return items;
    }
}