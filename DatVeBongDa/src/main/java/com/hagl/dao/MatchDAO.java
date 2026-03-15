package com.hagl.dao;

import java.sql.*;
import java.util.*;
import com.hagl.model.Match;
import java.time.LocalDate;
import java.time.LocalTime;

public class MatchDAO extends BaseDAO {

    public MatchDAO() { 
        super(); 
    }

    public List<Match> getAllMatches() throws SQLException {
        List<Match> matchList = new ArrayList<>();
        
        // 1. CẬP NHẬT SQL
        String sql = "SELECT T.MaTD, T.DoiThu, T.NgayThiDau, T.GioThiDau, T.GiaVeCaoNhat, T.GiaVeThapNhat, S.TenSan, T.TenAnh "
                   + "FROM TRANDAU T JOIN SANVANDONG S ON T.MaSan = S.MaSan "
                   + "ORDER BY T.NgayThiDau DESC, T.GioThiDau DESC"; 

        try (Connection conn = getConnection(); 
             PreparedStatement ps = conn.prepareStatement(sql);
             ResultSet rs = ps.executeQuery()) {
            
            while (rs.next()) {
                Timestamp ngayThiDauTs = rs.getTimestamp("NgayThiDau");
                Timestamp gioThiDauTs = rs.getTimestamp("GioThiDau");
                
                java.time.LocalDate ngayThiDau = (ngayThiDauTs != null) 
                                     ? ngayThiDauTs.toLocalDateTime().toLocalDate() 
                                     : null;
                
                java.time.LocalTime gioThiDau = (gioThiDauTs != null) 
                                     ? gioThiDauTs.toLocalDateTime().toLocalTime() 
                                     : null;

                Match match = new Match(
                    rs.getInt("MaTD"),
                    rs.getString("DoiThu"),
                    ngayThiDau, 
                    gioThiDau,  
                    rs.getString("TenSan"), 
                    rs.getDouble("GiaVeCaoNhat"), 
                    rs.getDouble("GiaVeThapNhat")
                );
                
                // 2. GÁN GIÁ TRỊ TÊN ẢNH: Đọc từ cột "TenAnh" và lưu vào Model
                match.setOpponentImageName(rs.getString("TenAnh"));
                
                System.out.println("------------------------------------");
                System.out.println("DAO DEBUG: Đã đọc thành công trận đấu: " + match.getOpponent());
                System.out.println("  Ảnh đối thủ: " + match.getOpponentImageName()); 
                System.out.println("------------------------------------");
                
                matchList.add(match);
            }
            
            System.out.println("DAO DEBUG: Tổng số trận đấu được tìm thấy: " + matchList.size());

        } catch (SQLException e) {
            System.err.println("DAO ERROR: Lỗi truy vấn SQL: " + e.getMessage());
            e.printStackTrace();
            throw e; 
        }
        return matchList;
    }
    public List<Match> getMatchesByMonth(int month, int year) throws SQLException {
        List<Match> matchList = new ArrayList<>();
        String sql = "SELECT T.MaTD, T.DoiThu, T.NgayThiDau, T.GioThiDau, T.GiaVeCaoNhat, T.GiaVeThapNhat, S.TenSan, T.TenAnh "
                   + "FROM TRANDAU T JOIN SANVANDONG S ON T.MaSan = S.MaSan "
                   + "WHERE MONTH(T.NgayThiDau) = ? AND YEAR(T.NgayThiDau) = ? "
                   + "ORDER BY T.NgayThiDau ASC";

        try (Connection conn = getConnection(); 
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setInt(1, month);
            ps.setInt(2, year);
            try (ResultSet rs = ps.executeQuery()) {
                while (rs.next()) {
                    // SỬA LỖI: Trích xuất Ngày và Giờ đúng định dạng
                    Timestamp ngayTs = rs.getTimestamp("NgayThiDau");
                    Timestamp gioTs = rs.getTimestamp("GioThiDau");
                    LocalDate ngay = (ngayTs != null) ? ngayTs.toLocalDateTime().toLocalDate() : null;
                    LocalTime gio = (gioTs != null) ? gioTs.toLocalDateTime().toLocalTime() : null;

                    Match match = new Match(
                        rs.getInt("MaTD"),
                        rs.getString("DoiThu"),
                        ngay, gio, rs.getString("TenSan"), 
                        rs.getDouble("GiaVeCaoNhat"), rs.getDouble("GiaVeThapNhat")
                    );
                    match.setOpponentImageName(rs.getString("TenAnh"));
                    matchList.add(match);
                }
            }
        }
        return matchList;
    }
 // Lấy danh sách các vị trí ghế đã được đặt cho một trận đấu và khán đài cụ thể
    public List<String> getOccupiedSeats(int matchId, String standName) throws SQLException {
        List<String> occupiedSeats = new ArrayList<>();
        String sql = "SELECT ViTriNgoi FROM VE WHERE MaTD = ? AND ViTriNgoi LIKE ?";
        try (Connection conn = getConnection(); 
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setInt(1, matchId);
            ps.setString(2, standName + "_%"); // Ví dụ: A1_1, A1_2...
            try (ResultSet rs = ps.executeQuery()) {
                while (rs.next()) {
                    occupiedSeats.add(rs.getString("ViTriNgoi"));
                }
            }
        }
        return occupiedSeats;
    }

    public Match getMatchById(int matchId) throws SQLException {
        String sql = "SELECT T.MaTD, T.DoiThu, T.NgayThiDau, T.GioThiDau, T.GiaVeCaoNhat, T.GiaVeThapNhat, S.TenSan, T.TenAnh "
                   + "FROM TRANDAU T JOIN SANVANDONG S ON T.MaSan = S.MaSan "
                   + "WHERE T.MaTD = ?";
        try (Connection conn = getConnection(); 
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setInt(1, matchId);
            try (ResultSet rs = ps.executeQuery()) {
                if (rs.next()) {
                    return mapResultSetToMatch(rs);
                }
            }
        }
        return null;
    }
    private Match mapResultSetToMatch(ResultSet rs) throws SQLException {
        // Trích xuất dữ liệu thô từ database
        Timestamp ngayTs = rs.getTimestamp("NgayThiDau");
        Timestamp gioTs = rs.getTimestamp("GioThiDau");
        
        // Chuyển đổi sang kiểu dữ liệu hiện đại của Java (LocalDate, LocalTime)
        java.time.LocalDate ngay = (ngayTs != null) ? ngayTs.toLocalDateTime().toLocalDate() : null;
        java.time.LocalTime gio = (gioTs != null) ? gioTs.toLocalDateTime().toLocalTime() : null;

        // Khởi tạo đối tượng Match
        Match m = new Match(
            rs.getInt("MaTD"),
            rs.getString("DoiThu"),
            ngay, 
            gio, 
            rs.getString("TenSan"), 
            rs.getDouble("GiaVeCaoNhat"), 
            rs.getDouble("GiaVeThapNhat")
        );
        
        // Gán thêm tên ảnh đối thủ
        m.setOpponentImageName(rs.getString("TenAnh"));
        
        return m;
    }
 // THÊM MỚI TRẬN ĐẤU
    public boolean insertMatch(Match match, int maSan) throws SQLException {
        String sql = "INSERT INTO TRANDAU (DoiThu, NgayThiDau, GioThiDau, GiaVeCaoNhat, GiaVeThapNhat, MaSan, TenAnh) VALUES (?, ?, ?, ?, ?, ?, ?)";
        try (Connection conn = getConnection(); PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setString(1, match.getOpponent());
            ps.setDate(2, java.sql.Date.valueOf(match.getMatchDate()));
            ps.setTime(3, java.sql.Time.valueOf(match.getMatchTime()));
            ps.setDouble(4, match.getMaxPrice());
            ps.setDouble(5, match.getMinPrice());
            ps.setInt(6, maSan);
            ps.setString(7, match.getOpponentImageName());
            return ps.executeUpdate() > 0;
        }
    }

    // CẬP NHẬT TRẬN ĐẤU
    public boolean updateMatch(Match match, int maSan) throws SQLException {
        String sql = "UPDATE TRANDAU SET DoiThu = ?, NgayThiDau = ?, GioThiDau = ?, GiaVeCaoNhat = ?, GiaVeThapNhat = ?, MaSan = ?, TenAnh = ? WHERE MaTD = ?";
        try (Connection conn = getConnection(); PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setString(1, match.getOpponent());
            ps.setDate(2, java.sql.Date.valueOf(match.getMatchDate()));
            ps.setTime(3, java.sql.Time.valueOf(match.getMatchTime()));
            ps.setDouble(4, match.getMaxPrice());
            ps.setDouble(5, match.getMinPrice());
            ps.setInt(6, maSan);
            ps.setString(7, match.getOpponentImageName());
            ps.setInt(8, match.getMatchId());
            return ps.executeUpdate() > 0;
        }
    }

    // XÓA TRẬN ĐẤU
    public boolean deleteMatch(int matchId) throws SQLException {
        String sql = "DELETE FROM TRANDAU WHERE MaTD = ?";
        try (Connection conn = getConnection(); PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setInt(1, matchId);
            return ps.executeUpdate() > 0;
        }
    }
}