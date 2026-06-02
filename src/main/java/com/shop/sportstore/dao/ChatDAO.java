package com.shop.sportstore.dao;


import com.shop.sportstore.model.ChatMessage;

import java.sql.*;
import java.util.ArrayList;
import java.util.List;

public class ChatDAO {

    private Connection getConnection() throws Exception {
        String url = "jdbc:mysql://localhost:3306/sportstore?useUnicode=true&characterEncoding=utf-8";
        Class.forName("com.mysql.cj.jdbc.Driver");
        return DriverManager.getConnection(url, "root", "");
    }

    public boolean saveMessage(ChatMessage msg) {
        String sql = "INSERT INTO chats (customer_id, sender, message, created_at) VALUES (?, ?, ?, NOW())";
        try (Connection conn = getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {

            ps.setString(1, msg.getCustomerId());
            ps.setString(2, msg.getSender());
            ps.setString(3, msg.getMessage());

            return ps.executeUpdate() > 0;
        } catch (Exception e) {
            e.printStackTrace();
        }
        return false;
    }

    public List<ChatMessage> getMessagesByCustomer(String customerId) {
        List<List<ChatMessage>> list = new ArrayList<>(); // Tránh lỗi logic bọc dữ liệu
        List<ChatMessage> messages = new ArrayList<>();
        String sql = "SELECT * FROM chats WHERE customer_id = ? ORDER BY created_at ASC";

        try (Connection conn = getConnection();
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
            e.printStackTrace();
        }
        return messages;
    }

    public List<String> getActiveCustomers() {
        List<String> customers = new ArrayList<>();
        String sql = "SELECT customer_id, MAX(created_at) as last_chat FROM chats GROUP BY customer_id ORDER BY last_chat DESC";

        try (Connection conn = getConnection();
             PreparedStatement ps = conn.prepareStatement(sql);
             ResultSet rs = ps.executeQuery()) {

            while (rs.next()) {
                customers.add(rs.getString("customer_id"));
            }
        } catch (Exception e) {
            e.printStackTrace();
        }
        return customers;
    }
}
