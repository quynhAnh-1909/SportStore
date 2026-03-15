package com.hagl.model;

public class User {
    private int userId; // Tương ứng MaND trong DB
    private String fullName;
    private String email;
    private String password;
    private String phoneNumber;
    private String role;

    

    public User() {
		
	}
	// Getter cho userId - Cần thiết cho VNPAYServlet
    public int getUserId() { return userId; }
    public void setUserId(int userId) { this.userId = userId; }

    public String getFullName() { return fullName; }
    public void setFullName(String fullName) { this.fullName = fullName; }

    public String getEmail() { return email; }
    public void setEmail(String email) { this.email = email; }

    public String getPassword() { return password; }
    public void setPassword(String password) { this.password = password; }

    public String getPhoneNumber() { return phoneNumber; }
    public void setPhoneNumber(String phoneNumber) { this.phoneNumber = phoneNumber;}
    public String getRole() { return role; }
    public void setRole(String role) { this.role = role;}
}