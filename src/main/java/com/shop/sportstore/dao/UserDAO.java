package com.shop.sportstore.dao;

import com.shop.sportstore.model.User;
import com.shop.sportstore.untils.DBConnection;

import java.sql.*;

public class UserDAO extends DBConnection {

    /* ================= LOGIN ================= */
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

    /* ================= REGISTER ================= */
    public boolean registerUser(User user) {

        String sql = "INSERT INTO users (full_name, email, password, phone_number, role, provider) " +
                "VALUES (?, ?, ?, ?, ?, ?)";

        try (Connection conn = getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {

            ps.setString(1, user.getFullName());
            ps.setString(2, user.getEmail());
            ps.setString(3, user.getPassword());
            ps.setString(4, user.getPhoneNumber());
            ps.setString(5, user.getRole());
            ps.setString(6, "LOCAL");

            return ps.executeUpdate() > 0;

        } catch (SQLIntegrityConstraintViolationException e) {
            // lỗi email trùng
            System.out.println("Email đã tồn tại!");
        } catch (Exception e) {
            e.printStackTrace();
        }

        return false;
    }

    /* ================= FIND BY EMAIL ================= */
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

    /* ================= SOCIAL LOGIN ================= */
    public User findOrCreateSocialUser(String email, String name, String provider) {

        User user = findByEmail(email);

        if (user == null) {

            String sql = "INSERT INTO users (full_name, email, password, role, provider) " +
                    "VALUES (?, ?, '', 'USER', ?)";

            try (Connection conn = getConnection();
                 PreparedStatement ps = conn.prepareStatement(sql, Statement.RETURN_GENERATED_KEYS)) {

                ps.setString(1, name);
                ps.setString(2, email);
                ps.setString(3, provider); // GOOGLE / FACEBOOK

                ps.executeUpdate();

                ResultSet rs = ps.getGeneratedKeys();
                if (rs.next()) {
                    user = new User();
                    user.setUserId(rs.getInt(1));
                    user.setFullName(name);
                    user.setEmail(email);
                    user.setRole("USER");
                }

            } catch (Exception e) {
                e.printStackTrace();
            }
        }

        return user;
    }

    /* ================= MAP RESULT ================= */
    private User mapResultSetToUser(ResultSet rs) throws SQLException {

        User user = new User();

        user.setUserId(rs.getInt("user_id"));
        user.setFullName(rs.getString("full_name"));
        user.setEmail(rs.getString("email"));
        user.setPassword(rs.getString("password"));
        user.setPhoneNumber(rs.getString("phone_number"));
        user.setRole(rs.getString("role"));

        return user;
    }

    public User findOrCreateSocialUser(String email, String name) {
        return findOrCreateSocialUser(email, name, "SOCIAL");
    }

    public User getUserById(int id) throws SQLException {
        String sql = "SELECT Id, FullName, Phone, Address, Email FROM Users WHERE Id = ?";
        try (Connection conn = getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setInt(1, id);
            ResultSet rs = ps.executeQuery();
            if (rs.next()) {
                User u = new User();
                u.setUserId(rs.getInt("Id"));
                u.setFullName(rs.getString("FullName"));
                u.setPhoneNumber(rs.getString("Phone"));
                u.setEmail(rs.getString("Email"));
                return u;
            }
        }
        return null;
    }
}
