package com.shop.sportstore.dao;
import com.shop.sportstore.model.ChatMessage;
import com.shop.sportstore.untils.DBConnection;
import java.sql.*;
import java.util.ArrayList;
import java.util.List;

public class ChatDAO {



    public boolean saveMessage(ChatMessage msg) {
        String sql = "INSERT INTO chats (customer_id, sender, message) VALUES (?, ?, ?)";


        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {

            String customerId = (msg.getCustomerId() != null) ? msg.getCustomerId().trim() : "UNKNOWN";
            String sender = (msg.getSender() != null) ? msg.getSender().trim() : "customer";
            String message = (msg.getMessage() != null) ? msg.getMessage().trim() : "";

            ps.setString(1, customerId);
            ps.setString(2, sender);
            ps.setString(3, message);

            return ps.executeUpdate() > 0;
        } catch (Exception e) {
            System.out.println(" LỖI LƯU TIN NHẮN TẠI CHAT_DAO:");
            e.printStackTrace();
        }
        return false;
    }

    public List<ChatMessage> getMessagesByCustomer(String customerId) {
        List<ChatMessage> messages = new ArrayList<>();
        String sql = "SELECT * FROM chats WHERE customer_id = ? ORDER BY created_at ASC";


        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {

            ps.setString(1, customerId);
            try (ResultSet rs = ps.executeQuery()) {
                while (rs.next()) {
                    ChatMessage msg = new ChatMessage();
                    msg.setId(rs.getInt("id"));
                    msg.setCustomerId(rs.getString("customer_id"));
                    msg.setSender(rs.getString("sender"));
                    msg.setMessage(rs.getString("message"));
                    msg.setCreatedAt(rs.getTimestamp("created_at"));
                    messages.add(msg);
                }
            }
        } catch (Exception e) {
            System.out.println(" LỖI LẤY CHI TIẾT TIN NHẮN TẠI CHAT_DAO:");
            e.printStackTrace();
        }
        return messages;
    }

    public List<String> getActiveCustomers() {
        List<String> list = new ArrayList<>();
        String sql = "SELECT customer_id FROM chats GROUP BY customer_id ORDER BY MAX(created_at) DESC";


        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql);
             ResultSet rs = ps.executeQuery()) {

            while (rs.next()) {
                list.add(rs.getString("customer_id"));
            }
        } catch (Exception e) {
            System.out.println(" LỖI LẤY DANH SÁCH KHÁCH HÀNG TẠI CHAT_DAO:");
            e.printStackTrace();
        }
        return list;
    }
}