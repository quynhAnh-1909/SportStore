package com.shop.sportstore.dao;

import com.shop.sportstore.model.User;
import com.shop.sportstore.untils.DBConnection;
import java.sql.*;

public class UserDAO extends DBConnection {

    public User checkLogin(String email, String password) {
        if (email == null || password == null) return null;

        String cleanEmail = email.trim().toLowerCase();
        String sql = "SELECT * FROM users WHERE email = ?";

        try (Connection conn = getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {

            ps.setString(1, cleanEmail);

            try (ResultSet rs = ps.executeQuery()) {
                if (rs.next()) {
                    String dbPassword = rs.getString("password");

                    if (dbPassword != null && dbPassword.trim().equals(password.trim())) {
                        return mapResultSetToUser(rs);
                    } else {
                        System.out.println("Mật khẩu nhập vào không khớp với mật khẩu được lưu trong DB!");
                    }
                } else {
                    System.out.println(" Không tìm thấy tài khoản nào khớp với Email: " + cleanEmail);
                }
            }
        } catch (Exception e) {
            System.out.println(" LỖI HỆ THỐNG TẠI USERDAO.CHECKLOGIN:");
            e.printStackTrace();
        }
        return null;
    }

    public boolean registerUser(User user) {
        if (user == null || user.getEmail() == null) return false;

        String sql = "INSERT INTO users (full_name, email, password, phone_number, gender, role, provider, status, tier_name) " +
                "VALUES (?, ?, ?, ?, ?, ?, ?, 1, 'Đồng')";

        try (Connection conn = getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {

            ps.setString(1, user.getFullName());
            ps.setString(2, user.getEmail().trim().toLowerCase());
            ps.setString(3, user.getPassword());

            String phone = user.getPhoneNumber();
            if (phone != null) {
                phone = phone.replaceAll("\\s+", "");
            }
            ps.setString(4, phone);
            ps.setString(5, user.getGioiTinh());

            String role = (user.getRole() == null || user.getRole().trim().isEmpty()) ? "USER" : user.getRole().trim();
            ps.setString(6, role);
            ps.setString(7, "LOCAL");

            int rowsAffected = ps.executeUpdate();
            return rowsAffected > 0;

        } catch (java.sql.SQLIntegrityConstraintViolationException e) {
            System.out.println("LỖI ĐĂNG KÝ: Email [" + user.getEmail() + "] đã tồn tại trong Database!");
        } catch (Exception e) {
            System.out.println("LỖI HỆ THỐNG TẠI USERDAO.REGISTERUSER:");
            e.printStackTrace();
        }
        return false;
    }


    public User findByEmail(String email) {
        if (email == null) return null;

        String cleanEmail = email.trim().toLowerCase();
        String sql = "SELECT * FROM users WHERE email = ?";
        try (Connection conn = getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {

            ps.setString(1, cleanEmail);
            try (ResultSet rs = ps.executeQuery()) {
                if (rs.next()) {
                    return mapResultSetToUser(rs);
                }
            }
        } catch (Exception e) {
            e.printStackTrace();
        }
        return null;
    }


    public User findOrCreateSocialUser(String email, String name, String provider, String avatar) {
        if (email == null) return null;

        String cleanEmail = email.trim().toLowerCase();
        User user = findByEmail(cleanEmail);

        if (user == null) {
            String sql = "INSERT INTO users (full_name, email, password, role, provider, avatar, status, tier_name) VALUES (?, ?, '', 'USER', ?, ?, 1, 'Đồng')";
            try (Connection conn = getConnection();
                 PreparedStatement ps = conn.prepareStatement(sql, Statement.RETURN_GENERATED_KEYS)) {

                ps.setString(1, name);
                ps.setString(2, cleanEmail);
                ps.setString(3, provider);
                ps.setString(4, avatar);

                ps.executeUpdate();

                try (ResultSet rs = ps.getGeneratedKeys()) {
                    if (rs.next()) {
                        user = new User();
                        user.setUserId(rs.getInt(1));
                        user.setFullName(name);
                        user.setEmail(cleanEmail);
                        user.setRole("USER");
                        user.setProvider(provider);
                        user.setAvatar(avatar);
                        user.setStatus(true);
                        user.setLoyal(false);
                        user.setTierName("Đồng");
                    }
                }
            } catch (Exception e) {
                e.printStackTrace();
            }
        } else {
            String sql = "UPDATE users SET avatar = ?, provider = ? WHERE email = ?";
            try (Connection conn = getConnection();
                 PreparedStatement ps = conn.prepareStatement(sql)) {

                ps.setString(1, avatar);
                ps.setString(2, provider);
                ps.setString(3, cleanEmail);

                ps.executeUpdate();

                user.setAvatar(avatar);
                user.setProvider(provider);
            } catch (Exception e) {
                e.printStackTrace();
            }
        }
        return user;
    }


    private User mapResultSetToUser(ResultSet rs) throws SQLException {
        User user = new User();
        user.setUserId(rs.getInt("user_id"));
        user.setFullName(rs.getString("full_name"));

        String dbEmail = rs.getString("email");
        user.setEmail(dbEmail != null ? dbEmail.trim().toLowerCase() : null);

        user.setPassword(rs.getString("password"));
        user.setPhoneNumber(rs.getString("phone_number"));
        user.setRole(rs.getString("role"));
        user.setAvatar(rs.getString("avatar"));
        user.setProvider(rs.getString("provider"));
        user.setAddress(rs.getString("address"));

        int statusInt = rs.getInt("status");
        user.setStatus(statusInt == 1);


        try {
            user.setLoyal(rs.getInt("is_loyal") == 1);
            user.setLoyalDate(rs.getTimestamp("loyal_date"));

            user.setTierName(rs.getString("tier_name"));
        } catch (SQLException e) {
            System.out.println("  Cột dữ liệu phân hạng (Loyal/Tier) chưa đồng bộ đầy đủ.");
        }

        try {
            user.setGioiTinh(rs.getString("gender"));
        } catch (SQLException e) {
            System.out.println("Cột giới tính (gender) chưa tồn tại hoặc bị lỗi cấu trúc bảng.");
        }
        return user;
    }


    public User getUserById(int id) throws SQLException {
        String sql = "SELECT * FROM users WHERE user_id = ?";
        try (Connection conn = getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {

            ps.setInt(1, id);
            try (ResultSet rs = ps.executeQuery()) {
                if (rs.next()) {
                    return mapResultSetToUser(rs);
                }
            }
        } catch (Exception e) {
            e.printStackTrace();
        }
        return null;
    }


    public boolean checkLoyalStatus(int userId) {
        String sql = "SELECT is_loyal FROM users WHERE user_id = ?";
        try (Connection conn = getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setInt(1, userId);
            try (ResultSet rs = ps.executeQuery()) {
                if (rs.next()) {
                    return rs.getInt("is_loyal") == 1;
                }
            }
        } catch (Exception e) {
            e.printStackTrace();
        }
        return false;
    }


    public boolean lockUserAccount(int userId) {
        String sql = "UPDATE users SET status = 0 WHERE user_id = ?";
        try (Connection conn = getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setInt(1, userId);
            return ps.executeUpdate() > 0;
        } catch (Exception e) {
            e.printStackTrace();
        }
        return false;
    }


    public boolean updateBasicInfo(int userId, String fullName, String phone, String address) {
        String sql = "UPDATE users SET full_name = ?, phone_number = ?, address = ? WHERE user_id = ?";
        try (Connection conn = getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setString(1, fullName);

            if (phone != null) {
                phone = phone.replaceAll("\\s+", "");
            }
            ps.setString(2, phone);
            ps.setString(3, address);
            ps.setInt(4, userId);
            return ps.executeUpdate() > 0;
        } catch (Exception e) {
            e.printStackTrace();
        }
        return false;
    }


    public boolean updatePhoneNumber(int userId, String newPhone) {
        String sql = "UPDATE users SET phone_number = ? WHERE user_id = ?";
        try (Connection conn = getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {

            if (newPhone != null) {
                newPhone = newPhone.replaceAll("\\s+", "");
            }
            ps.setString(1, newPhone);
            ps.setInt(2, userId);
            return ps.executeUpdate() > 0;
        } catch (Exception e) {
            e.printStackTrace();
        }
        return false;
    }


    public boolean updatePassword(String email, String newPassword) {
        if (email == null) return false;

        String sql = "UPDATE users SET password = ? WHERE email = ?";
        try (Connection conn = getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {

            ps.setString(1, newPassword);
            ps.setString(2, email.trim().toLowerCase());
            return ps.executeUpdate() > 0;
        } catch (Exception e) {
            e.printStackTrace();
        }
        return false;
    }


    public boolean changePassword(int userId, String newPassword) {
        String sql = "UPDATE users SET password = ? WHERE user_id = ?";
        try (Connection conn = getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {

            ps.setString(1, newPassword);
            ps.setInt(2, userId);

            int result = ps.executeUpdate();
            return result > 0;
        } catch (Exception e) {
            e.printStackTrace();
        }
        return false;
    }

    public java.util.List<Integer> getAllUserIds() {
        java.util.List<Integer> list = new java.util.ArrayList<>();
        String sql = "SELECT user_id FROM users WHERE status = 1";

        try (Connection conn = getConnection();
             PreparedStatement ps = conn.prepareStatement(sql);
             ResultSet rs = ps.executeQuery()) {

            while (rs.next()) {
                list.add(rs.getInt("user_id"));
            }
        } catch (Exception e) {
            System.out.println(" LỖI HỆ THỐNG TẠI USERDAO.GETALLUSERIDS:");
            e.printStackTrace();
        }
        return list;
    }
}