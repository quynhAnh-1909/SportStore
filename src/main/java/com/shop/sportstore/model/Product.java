package com.shop.sportstore.model;



public class Product {

    private int id;
    private String name;
    private String brand;
    private double price;
    private int stockQuantity;
    private String size;
    private String color;
    private String description;
    private String imageUrl;
    private int categoryId;
    private String unit;
    private String categoryName; // thêm dòng này

    public String getCategoryName() {
        return categoryName;
    }

    public void setCategoryName(String categoryName) {
        this.categoryName = categoryName;
    }

    // Constructor rỗng
    public Product() {
    }

    // Constructor đầy đủ
    public Product(int id, String name, String brand, double price,
                   int stockQuantity, String size, String color,
                   String description, String imageUrl, int categoryId) {
        this.id = id;
        this.name = name;
        this.brand = brand;
        this.price = price;
        this.stockQuantity = stockQuantity;
        this.size = size;
        this.color = color;
        this.description = description;
        this.imageUrl = imageUrl;
        this.categoryId = categoryId;
    }


    // Getter và Setter

    public String getUnit() {
        return unit;
    }

    public void setUnit(String unit) {
        this.unit = unit;
    }

    public int getId() {
        return id;
    }

    public void setId(int id) {
        this.id = id;
    }

    public String getName() {
        return name;
    }

    public void setName(String name) {
        this.name = name;
    }

    public String getBrand() {
        return brand;
    }

    public void setBrand(String brand) {
        this.brand = brand;
    }

    public double getPrice() {
        return price;
    }

    public void setPrice(double price) {
        this.price = price;
    }

    public int getStockQuantity() {
        return stockQuantity;
    }

    public void setStockQuantity(int stockQuantity) {
        this.stockQuantity = stockQuantity;
    }

    public String getSize() {
        return size;
    }

    public void setSize(String size) {
        this.size = size;
    }

    public String getColor() {
        return color;
    }

    public void setColor(String color) {
        this.color = color;
    }

    public String getDescription() {
        return description;
    }

    public void setDescription(String description) {
        this.description = description;
    }

    public String getImageUrl() {
        return imageUrl;
    }

    public void setImageUrl(String imageUrl) {
        this.imageUrl = imageUrl;
    }

    public int getCategoryId() {
        return categoryId;
    }

    public void setCategoryId(int categoryId) {
        this.categoryId = categoryId;
    }


}
