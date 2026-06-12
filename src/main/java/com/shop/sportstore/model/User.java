package com.shop.sportstore.model;
import java.io.Serializable;


public class User implements Serializable {

    private int userId;
    private String fullName;
    private String email;
    private String password;
    private String phoneNumber;
    private String role;
    private String avatar;
    private String provider;
    private String address;
    private boolean status = true;
    private String memberLevel;
    private String gioiTinh;
    private boolean isLoyal = false;
    private java.util.Date loyalDate;
    private String tierName;
    private double totalSpending;


    public User() {
    }


    public User(int userId, String fullName, String email, String password, String phoneNumber, String role) {

        this.userId = userId;
        this.fullName = fullName;
        this.email = email;
        this.password = password;
        this.phoneNumber = phoneNumber;
        this.role = role;

    }


    public int getUserId() {
        return userId;

    }

    public void setUserId(int userId) {
        this.userId = userId;

    }

    public String getFullName() {
        return fullName;

    }

    public void setFullName(String fullName) {
        this.fullName = fullName;

    }

    public String getEmail() {
        return email;

    }


    public void setEmail(String email) {
        this.email = email;

    }


    public String getPassword() {
        return password;

    }

    public void setPassword(String password) {
        this.password = password;

    }

    public String getPhoneNumber() {
        return phoneNumber;

    }

    public void setPhoneNumber(String phoneNumber) {
        this.phoneNumber = phoneNumber;

    }


    public String getRole() {
        return role;

    }


    public void setRole(String role) {
        this.role = role;

    }


    public String getAvatar() {
        return avatar;

    }


    public void setAvatar(String avatar) {
        this.avatar = avatar;

    }


    public String getProvider() {
        return provider;

    }


    public void setProvider(String provider) {
        this.provider = provider;

    }


    public String getAddress() {
        return address;

    }


    public void setAddress(String address) {
        this.address = address;

    }


    public boolean isStatus() {
        return status;

    }


    public void setStatus(boolean status) {
        this.status = status;

    }


    public String getMemberLevel() {
        return memberLevel;

    }

    public void setMemberLevel(String memberLevel) {
        this.memberLevel = memberLevel;

    }

    public String getGioiTinh() {
        return gioiTinh;

    }

    public void setGioiTinh(String gioiTinh) {
        this.gioiTinh = gioiTinh;

    }


    public String getTierName() {
        return tierName;

    }

    public void setTierName(String tierName) {
        this.tierName = tierName;

    }

    public double getTotalSpending() {
        return totalSpending;

    }

    public void setTotalSpending(double totalSpending) {
        this.totalSpending = totalSpending;

    }

    public boolean isLoyal() {
        return isLoyal;

    }


    public void setLoyal(boolean loyal) {
        this.isLoyal = loyal;

    }


    public java.util.Date getLoyalDate() {
        return loyalDate;

    }


    public void setLoyalDate(java.util.Date loyalDate) {
        this.loyalDate = loyalDate;

    }

    @Override

    public String toString() {
        return "User{" +
                "userId=" + userId +
                ", fullName='" + fullName + '\'' +
                ", email='" + email + '\'' +
                ", phoneNumber='" + phoneNumber + '\'' +
                ", gioiTinh='" + gioiTinh + '\'' +
                ", role='" + role + '\'' +
                ", status=" + status +
                ", tierName='" + tierName + '\'' +
                ", totalSpending=" + totalSpending +
                '}';

    }
}

