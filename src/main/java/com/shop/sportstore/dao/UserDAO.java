package com.shop.sportstore.dao;

import com.shop.sportstore.model.User;
import com.shop.sportstore.untils.DBConnection;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;

import java.io.IOException;
import java.sql.*;

public class UserDAO extends DBConnection {


    public User checkLogin(String email, String password) {

        String sql = "SELECT * FROM users WHERE LOWER(email) = LOWER(?)";

        try (Connection conn = getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {


            ps.setString(1, email.trim());

            try (ResultSet rs = ps.executeQuery()) {
                if (rs.next()) {
                    String dbPassword = rs.getString("password");


                    if (dbPassword != null && dbPassword.trim().equals(password.trim())) {
                        return mapResultSetToUser(rs);
                    } else {
                        System.out.println("⚠Mật khẩu nhập vào không khớp với mật khẩu được lưu trong DB!");
                    }
                } else {
                    System.out.println(" Không tìm thấy tài khoản nào khớp với Email: " + email);
                }
            }
        } catch (Exception e) {
            System.out.println(" LỖI HỆ THỐNG TẠI USERDAO.CHECKLOGIN:");
            e.printStackTrace();
        }
        return null;
    }

    public boolean registerUser(User user) {

        String sql = "INSERT INTO users (full_name, email, password, phone_number, gender, role, provider, status) " +
                "VALUES (?, ?, ?, ?, ?, ?, ?, 1)";

        try (Connection conn = getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {

            ps.setString(1, user.getFullName());
            ps.setString(2, user.getEmail());
            ps.setString(3, user.getPassword());
            String phone = user.getPhoneNumber();
            if (phone != null) {
                phone = phone.replaceAll("\\s+", "");
            }
            ps.setString(4, phone);

            ps.setString(5, user.getGioiTinh()); 
            ps.setString(4, user.getPhoneNumber());
            ps.setString(5, user.getGioiTinh());


            String role = (user.getRole() == null || user.getRole().trim().isEmpty()) ? "USER" : user.getRole();
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

        String sql = "SELECT * FROM users WHERE LOWER(email) = LOWER(?)";
        try (Connection conn = getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setString(1, email.trim());
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

    public User findOrCreateSocialUser(
            String email,
            String name,
            String provider,
            String avatar) {

        User user = findByEmail(email);

        if (user == null) {

            String sql =
                    "INSERT INTO users " +
                            "(full_name, email, password, role, provider, avatar) " +
                            "VALUES (?, ?, '', 'USER', ?, ?)";

            try (Connection conn = getConnection();
                 PreparedStatement ps =
                         conn.prepareStatement(
                                 sql,
                                 Statement.RETURN_GENERATED_KEYS)) {

                ps.setString(1, name);
                ps.setString(2, email);
                ps.setString(3, provider);
                ps.setString(4, avatar);

                ps.executeUpdate();

                try (ResultSet rs = ps.getGeneratedKeys()) {

                    if (rs.next()) {

                        user = new User();

                        user.setUserId(rs.getInt(1));
                        user.setFullName(name);
                        user.setEmail(email);
                        user.setRole("USER");
                        user.setProvider(provider);
                        user.setAvatar(avatar);
                        user.setStatus(true);
                    }
                }

            } catch (Exception e) {
                e.printStackTrace();
            }

        } else {

            String sql =
                    "UPDATE users " +
                            "SET avatar = ?, provider = ? " +
                            "WHERE email = ?";

            try (Connection conn = getConnection();
                 PreparedStatement ps =
                         conn.prepareStatement(sql)) {

                ps.setString(1, avatar);
                ps.setString(2, provider);
                ps.setString(3, email);

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
        user.setEmail(rs.getString("email"));
        user.setPassword(rs.getString("password"));
        user.setPhoneNumber(rs.getString("phone_number"));
        user.setRole(rs.getString("role"));
        user.setAvatar(rs.getString("avatar"));
        user.setProvider(rs.getString("provider"));

        user.setStatus(rs.getInt("status") == 1 || rs.getBoolean("status"));

        try {
            user.setGioiTinh(rs.getString("gender"));
        } catch (SQLException e) {
            System.out.println("Cột giới tính chưa tồn tại trong ResultSet");
        }
        return user;
    }

    public User getUserById(int id) throws SQLException {

        System.out.println("SEARCH USER ID = " + id);

        String sql =
                "SELECT * FROM users WHERE user_id = ?";

        try (Connection conn = getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {

            ps.setInt(1, id);

            try (ResultSet rs = ps.executeQuery()) {

                if (rs.next()) {

                    System.out.println("FOUND USER IN DB");

                    return mapResultSetToUser(rs);
                }

                System.out.println("NOT FOUND USER IN DB");
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

        String sql =
                "UPDATE users SET password = ? WHERE email = ?";

        try (Connection conn = getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {

            ps.setString(1, newPassword);
            ps.setString(2, email);

            return ps.executeUpdate() > 0;

        } catch (Exception e) {
            e.printStackTrace();
        }

        return false;
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

    public boolean changePassword(int userId, String newPassword) {

        String sql =
                "UPDATE users SET password = ? WHERE user_id = ?";

        try (Connection conn = getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {

            ps.setString(1, newPassword);
            ps.setInt(2, userId);

            int result = ps.executeUpdate();

            System.out.println("UPDATE RESULT = " + result);

            return result > 0;

        } catch (Exception e) {
            e.printStackTrace();
        }

        return false;
    }

}
