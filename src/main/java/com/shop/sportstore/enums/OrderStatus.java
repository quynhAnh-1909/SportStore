package com.shop.sportstore.enums;



public enum OrderStatus {

    PENDING("Chờ xử lý"),
    CONFIRMED("Chờ lấy hàng"),
    SHIPPING("Đang giao"),
    COMPLETED("Hoàn tất"),
    CANCELLED("Đã hủy"),
    REFUND("Hoàn tiền");

    private final String label;

    OrderStatus(String label) {
        this.label = label;
    }

    public String getLabel() {
        return label;
    }
}