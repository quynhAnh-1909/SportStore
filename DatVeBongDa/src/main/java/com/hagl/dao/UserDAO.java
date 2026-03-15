package com.hagl.dao;

import com.hagl.model.User;
import java.sql.*;

public class UserDAO extends BaseDAO {

    public UserDAO() { super(); }
    public User checkLogin(String email, String password) throws SQLException {
        // Thêm cột 'Role' vào câu truy vấn
        String sql = "SELECT MaND, HoTen, Email, SoDienThoai, Role FROM NGUOIDUNG WHERE Email = ? AND MatKhau = ?";
        
        try (Connection conn = getConnection(); 
             PreparedStatement ps = conn.prepareStatement(sql)) {
            
            ps.setString(1, email);
            ps.setString(2, password); 
            
            try (ResultSet rs = ps.executeQuery()) {
                if (rs.next()) {
                    User user = new User();
                    user.setUserId(rs.getInt("MaND"));
                    user.setFullName(rs.getString("HoTen"));
                    user.setEmail(rs.getString("Email"));
                    user.setPhoneNumber(rs.getString("SoDienThoai"));
                    // Gán Role từ DB vào đối tượng User
                    user.setRole(rs.getString("Role")); 
                    return user;
                }
            }
        }
        return null;
    }
    
    public boolean registerUser(User user) throws SQLException {
        if (isEmailExists(user.getEmail())) {
            return false; 
        }

        // Không cần chèn Role vì SQL Server đã có DEFAULT 'USER'
        String sql = "INSERT INTO NGUOIDUNG (HoTen, Email, MatKhau, SoDienThoai) VALUES (?, ?, ?, ?)";
        
        try (Connection conn = getConnection(); 
             PreparedStatement ps = conn.prepareStatement(sql, Statement.RETURN_GENERATED_KEYS)) {
            
            ps.setString(1, user.getFullName());
            ps.setString(2, user.getEmail());
            ps.setString(3, user.getPassword());
            ps.setString(4, user.getPhoneNumber());
            
            int rowsAffected = ps.executeUpdate();
            
            if (rowsAffected > 0) {
                try (ResultSet rs = ps.getGeneratedKeys()) {
                    if (rs.next()) {
                        user.setUserId(rs.getInt(1));
                        
                        user.setRole("USER"); 
                    }
                }
                return true;
            }
        }
        return false;
    }

  
    private boolean isEmailExists(String email) throws SQLException {
        String sql = "SELECT COUNT(MaND) FROM NGUOIDUNG WHERE Email = ?";
        
        try (Connection conn = getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            
            ps.setString(1, email);
            try (ResultSet rs = ps.executeQuery()) {
                if (rs.next()) {
                    return rs.getInt(1) > 0;
                }
            }
        }
        return false;
    }
}