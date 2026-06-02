package com.shop.sportstore.model;


import java.sql.Timestamp;

public class ChatMessage {
    private int id;
    private String customerId;
    private String sender;
    private String message;
    private Timestamp createdAt;

    public ChatMessage() {}

    public ChatMessage(String customerId, String sender, String message) {
        this.customerId = customerId;
        this.sender = sender;
        this.message = message;
    }

    // Getters and Setters
    public int getId() { return id; }
    public void setId(int id) { this.id = id; }

    public String getCustomerId() { return customerId; }
    public void setCustomerId(String customerId) { this.customerId = customerId; }

    public String getSender() { return sender; }
    public void setSender(String sender) { this.sender = sender; }

    public String getMessage() { return message; }
    public void setMessage(String message) { this.message = message; }

    public Timestamp getCreatedAt() { return createdAt; }
    public void setCreatedAt(Timestamp createdAt) { this.createdAt = createdAt; }
}