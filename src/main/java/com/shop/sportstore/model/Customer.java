package com.shop.sportstore.model;

public class Customer {
    private int userId;
    private String fullName;
    private String email;
    private String password;
    private String phoneNumber;
    private String role;
    private String provider;
    private String avatar;
    private String address;
    private boolean status;

    public Customer() {

        this.role = "USER";
        this.provider = "LOCAL";
        this.status = true;
    }

    // Getters and Setters
    public int getUserId() { return userId; }
    public void setUserId(int userId) { this.userId = userId; }

    public String getFullName() { return fullName; }
    public void setFullName(String fullName) { this.fullName = fullName; }

    public String getEmail() { return email; }
    public void setEmail(String email) { this.email = email; }

    public String getPassword() { return password; }
    public void setPassword(String password) { this.password = password; }

    public String getPhoneNumber() { return phoneNumber; }
    public void setPhoneNumber(String phoneNumber) { this.phoneNumber = phoneNumber; }

    public String getRole() { return role; }
    public void setRole(String role) { this.role = role; }

    public String getProvider() { return provider; }
    public void setProvider(String provider) { this.provider = provider; }

    public String getAvatar() { return avatar; }
    public void setAvatar(String avatar) { this.avatar = avatar; }

    public String getAddress() { return address; }
    public void setAddress(String address) { this.address = address; }

    public boolean isStatus() { return status; }
    public void setStatus(boolean status) { this.status = status; }
}