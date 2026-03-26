package com.shop.sportstore.model;

public class FacebookUser {

    private String id;
    private String name;
    private String email;

    // ===== GETTER =====
    public String getId() {
        return id;
    }

    public String getName() {
        return name;
    }

    public String getEmail() {
        return email;
    }

    // ===== SETTER =====
    public void setId(String id) {
        this.id = id;
    }

    public void setName(String name) {
        this.name = name;
    }

    public void setEmail(String email) {
        this.email = email;
    }
}