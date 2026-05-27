package com.shop.sportstore.dao;

import com.shop.sportstore.model.User;
import com.shop.sportstore.untils.DBConnection;

import java.sql.*;

public class UserDAO extends DBConnection {

    public User checkLogin(String email, String password) {
        String sql = "SELECT * FROM users WHERE email = ? AND password = ?";
        try (Connection conn = getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setString(1, email);
            ps.setString(2, password);
            ResultSet rs = ps.executeQuery();
            if (rs.next()) {
                return mapResultSetToUser(rs);
            }
        } catch (Exception e) {
            e.printStackTrace();
        }
        return null;
    }

    public boolean registerUser(User user) {
        String sql = "INSERT INTO users (full_name, email, password, phone_number, role, provider, gender) " +
                "VALUES (?, ?, ?, ?, ?, ?, ?)";
        try (Connection conn = getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setString(1, user.getFullName());
            ps.setString(2, user.getEmail());
            ps.setString(3, user.getPassword());
            ps.setString(4, user.getPhoneNumber());
            ps.setString(5, user.getRole());
            ps.setString(6, "LOCAL");
            ps.setString(7, user.getGioiTinh());
            return ps.executeUpdate() > 0;
        } catch (SQLIntegrityConstraintViolationException e) {
            System.out.println("Email đã tồn tại!");
        } catch (Exception e) {
            e.printStackTrace();
        }
        return false;
    }

    public User findByEmail(String email) {
        String sql = "SELECT * FROM users WHERE email = ?";
        try (Connection conn = getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setString(1, email);
            ResultSet rs = ps.executeQuery();
            if (rs.next()) {
                return mapResultSetToUser(rs);
            }
        } catch (Exception e) {
            e.printStackTrace();
        }
        return null;
    }

    public User findOrCreateSocialUser(String email, String name, String provider) {
        User user = findByEmail(email);
        if (user == null) {
            String sql = "INSERT INTO users (full_name, email, password, role, provider) VALUES (?, ?, '', 'USER', ?)";
            try (Connection conn = getConnection();
                 PreparedStatement ps = conn.prepareStatement(sql, Statement.RETURN_GENERATED_KEYS)) {
                ps.setString(1, name);
                ps.setString(2, email);
                ps.setString(3, provider);
                ps.executeUpdate();
                ResultSet rs = ps.getGeneratedKeys();
                if (rs.next()) {
                    user = new User();
                    user.setUserId(rs.getInt(1));
                    user.setFullName(name);
                    user.setEmail(email);
                    user.setRole("USER");
                    user.setStatus(true);
                }
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
        user.setEmail(rs.getString("email"));
        user.setPassword(rs.getString("password"));
        user.setPhoneNumber(rs.getString("phone_number"));
        user.setRole(rs.getString("role"));
        user.setStatus(rs.getBoolean("status"));

        try {
            user.setGioiTinh(rs.getString("gender"));
        } catch (SQLException e) {
            System.out.println("Cột giới tính chưa tồn tại trong ResultSet");
        }
        return user;
    }

    public User findOrCreateSocialUser(String email, String name) {
        return findOrCreateSocialUser(email, name, "SOCIAL");
    }


    public User getUserById(int id) throws SQLException {
        String sql = "SELECT user_id, full_name, phone_number, email, password, role, status, gender FROM users WHERE user_id = ?";
        try (Connection conn = getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setInt(1, id);
            ResultSet rs = ps.executeQuery();
            if (rs.next()) {
                return mapResultSetToUser(rs);
            }
        } catch (Exception e) {
            e.printStackTrace();
        }
        return null;
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


    public boolean updateBasicInfo(int userId, String fullName, String phone) {
        String sql = "UPDATE users SET full_name = ?, phone_number = ? WHERE user_id = ?";
        try (Connection conn = getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setString(1, fullName);
            ps.setString(2, phone);
            ps.setInt(3, userId);
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
            ps.setString(1, newPhone);
            ps.setInt(2, userId);
            return ps.executeUpdate() > 0;
        } catch (Exception e) {
            e.printStackTrace();
        }
        return false;
    }
}