package com.shop.sportstore.dao;

import com.shop.sportstore.model.Customer;
import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.util.ArrayList;
import java.util.List;

public class CustomerDAO {
    private Connection conn;

    public CustomerDAO(Connection conn) {
        this.conn = conn;
    }

    // 1. Lấy tất cả khách hàng
    public List<Customer> getAll() {
        List<Customer> list = new ArrayList<>();
        String sql = "SELECT * FROM users WHERE role = 'USER' ORDER BY user_id DESC";
        try (PreparedStatement ps = conn.prepareStatement(sql);
             ResultSet rs = ps.executeQuery()) {
            while (rs.next()) {
                Customer c = new Customer();
                c.setUserId(rs.getInt("user_id"));
                c.setFullName(rs.getString("full_name"));
                c.setEmail(rs.getString("email"));
                c.setPassword(rs.getString("password"));
                c.setPhoneNumber(rs.getString("phone_number"));
                c.setRole(rs.getString("role"));
                c.setProvider(rs.getString("provider"));
                c.setAvatar(rs.getString("avatar"));
                c.setAddress(rs.getString("address"));
                c.setStatus(rs.getBoolean("status"));


                try {
                    c.setLoyal(rs.getBoolean("is_loyal"));
                    c.setTierName(rs.getString("tier_name"));
                } catch (Exception e) {
                    c.setLoyal(false);
                    c.setTierName(null);
                }

                list.add(c);
            }
        } catch (Exception e) {
            e.printStackTrace();
        }
        return list;
    }

    // 2. Tìm khách hàng theo ID
    public Customer findById(int id) {
        String sql = "SELECT * FROM users WHERE user_id = ? AND role = 'USER'";
        try (PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setInt(1, id);
            ResultSet rs = ps.executeQuery();
            if (rs.next()) {
                Customer c = new Customer();
                c.setUserId(rs.getInt("user_id"));
                c.setFullName(rs.getString("full_name"));
                c.setEmail(rs.getString("email"));
                c.setPassword(rs.getString("password"));
                c.setPhoneNumber(rs.getString("phone_number"));
                c.setRole(rs.getString("role"));
                c.setProvider(rs.getString("provider"));
                c.setAvatar(rs.getString("avatar"));
                c.setAddress(rs.getString("address"));
                c.setStatus(rs.getBoolean("status"));


                try {
                    c.setLoyal(rs.getBoolean("is_loyal"));
                    c.setTierName(rs.getString("tier_name"));
                } catch (Exception e) {
                    c.setLoyal(false);
                    c.setTierName(null);
                }

                return c;
            }
        } catch (Exception e) {
            e.printStackTrace();
        }
        return null;
    }

    // 3. Thêm mới khách hàng
    public void insert(Customer c) {
        String sql = "INSERT INTO users (full_name, email, password, phone_number, role, provider, address, status, is_loyal, tier_name) " +
                "VALUES (?, ?, ?, ?, 'USER', 'LOCAL', ?, ?, FALSE, NULL)";
        try (PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setString(1, c.getFullName());
            ps.setString(2, c.getEmail());
            ps.setString(3, c.getPassword() != null ? c.getPassword() : "123456");
            ps.setString(4, c.getPhoneNumber());
            ps.setString(5, c.getAddress());
            ps.setBoolean(6, c.isStatus());
            ps.executeUpdate();
        } catch (Exception e) {
            e.printStackTrace();
        }
    }

    // 4. Cập nhật khách hàng (Giữ nguyên vẹn 100% không ảnh hưởng chức năng cũ)
    public void update(Customer c) {
        String sql = "UPDATE users SET full_name=?, email=?, phone_number=?, address=?, status=? WHERE user_id=? AND role='USER'";
        try (PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setString(1, c.getFullName());
            ps.setString(2, c.getEmail());
            ps.setString(3, c.getPhoneNumber());
            ps.setString(4, c.getAddress());
            ps.setBoolean(5, c.isStatus());
            ps.setInt(6, c.getUserId());
            ps.executeUpdate();
        } catch (Exception e) {
            e.printStackTrace();
        }
    }

    // 5. Khóa tài khoản
    public void delete(int id) {
        String sql = "UPDATE users SET status = FALSE WHERE user_id = ? AND role = 'USER'";
        try (PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setInt(1, id);
            ps.executeUpdate();
        } catch (Exception e) {
            e.printStackTrace();
        }
    }

    // 6. Kiểm tra trùng Email
    public boolean checkEmail(String email) {
        String sql = "SELECT user_id FROM users WHERE email = ?";
        try (PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setString(1, email);
            ResultSet rs = ps.executeQuery();
            return rs.next();
        } catch (Exception e) {
            e.printStackTrace();
        }
        return false;
    }

    // 7. Thống kê đơn hàng (Tính trên Status hoa/thường linh hoạt)
    public double[] getCustomerStats(int userId) {
        double[] stats = new double[2];
        String sql = "SELECT COUNT(Id) as total_orders, SUM(TotalPrice) as total_spent " +
                "FROM orders WHERE UserId = ? AND UPPER(Status) = 'COMPLETED'";
        try (PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setInt(1, userId);
            ResultSet rs = ps.executeQuery();
            if (rs.next()) {
                stats[0] = rs.getDouble("total_orders");
                stats[1] = rs.getDouble("total_spent");
            }
        } catch (Exception e) {
            e.printStackTrace();
        }
        return stats;
    }

    // 8. Lấy 10 đơn hàng gần đây
    public List<java.util.Map<String, Object>> getOrderHistory(int userId) {
        List<java.util.Map<String, Object>> list = new ArrayList<>();
        String sql = "SELECT OrderCode, TotalPrice, PaymentMethod, Status, CreatedAt " +
                "FROM orders WHERE UserId = ? ORDER BY CreatedAt DESC LIMIT 10";
        try (PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setInt(1, userId);
            ResultSet rs = ps.executeQuery();
            while (rs.next()) {
                java.util.Map<String, Object> order = new java.util.HashMap<>();
                order.put("orderCode", rs.getString("OrderCode"));
                order.put("totalPrice", rs.getDouble("TotalPrice"));
                order.put("paymentMethod", rs.getString("PaymentMethod"));
                order.put("status", rs.getString("Status"));
                order.put("createdAt", rs.getTimestamp("CreatedAt"));
                list.add(order);
            }
        } catch (Exception e) {
            e.printStackTrace();
        }
        return list;
    }
}