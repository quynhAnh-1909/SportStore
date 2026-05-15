package com.shop.sportstore.model;

import java.sql.Timestamp;

public class Order {

    private int id;
    private int userId;

    private String orderCode;

    private double totalPrice;

    private String status;

    private String paymentMethod;

    private Timestamp createdAt;

    private String note;

    private String userFullName;

    /* =========================
        TIME STATUS
    ========================= */

    private Timestamp confirmedAt;

    private Timestamp shippingAt;

    private Timestamp completedAt;

    private Timestamp cancelledAt;

    private Timestamp refundedAt;

    /* =========================
        REFUND / CANCEL
    ========================= */

    private String cancelReason;

    private String refundReason;

    private String transactionCode;

    /* =========================
        REVIEW
    ========================= */

    private Integer rating;

    /* =========================
        GETTER SETTER
    ========================= */

    public int getId() {
        return id;
    }

    public void setId(int id) {
        this.id = id;
    }

    public int getUserId() {
        return userId;
    }

    public void setUserId(int userId) {
        this.userId = userId;
    }

    public String getOrderCode() {
        return orderCode;
    }

    public void setOrderCode(String orderCode) {
        this.orderCode = orderCode;
    }

    public double getTotalPrice() {
        return totalPrice;
    }

    public void setTotalPrice(double totalPrice) {
        this.totalPrice = totalPrice;
    }

    public String getStatus() {
        return status;
    }

    public void setStatus(String status) {
        this.status = status;
    }

    public String getPaymentMethod() {
        return paymentMethod;
    }

    public void setPaymentMethod(String paymentMethod) {
        this.paymentMethod = paymentMethod;
    }

    public Timestamp getCreatedAt() {
        return createdAt;
    }

    public void setCreatedAt(Timestamp createdAt) {
        this.createdAt = createdAt;
    }

    public String getNote() {
        return note;
    }

    public void setNote(String note) {
        this.note = note;
    }

    public String getUserFullName() {
        return userFullName;
    }

    public void setUserFullName(String userFullName) {
        this.userFullName = userFullName;
    }

    public Timestamp getConfirmedAt() {
        return confirmedAt;
    }

    public void setConfirmedAt(Timestamp confirmedAt) {
        this.confirmedAt = confirmedAt;
    }

    public Timestamp getShippingAt() {
        return shippingAt;
    }

    public void setShippingAt(Timestamp shippingAt) {
        this.shippingAt = shippingAt;
    }

    public Timestamp getCompletedAt() {
        return completedAt;
    }

    public void setCompletedAt(Timestamp completedAt) {
        this.completedAt = completedAt;
    }

    public Timestamp getCancelledAt() {
        return cancelledAt;
    }

    public void setCancelledAt(Timestamp cancelledAt) {
        this.cancelledAt = cancelledAt;
    }

    public Timestamp getRefundedAt() {
        return refundedAt;
    }

    public void setRefundedAt(Timestamp refundedAt) {
        this.refundedAt = refundedAt;
    }

    public String getCancelReason() {
        return cancelReason;
    }

    public void setCancelReason(String cancelReason) {
        this.cancelReason = cancelReason;
    }

    public String getRefundReason() {
        return refundReason;
    }

    public void setRefundReason(String refundReason) {
        this.refundReason = refundReason;
    }

    public String getTransactionCode() {
        return transactionCode;
    }

    public void setTransactionCode(String transactionCode) {
        this.transactionCode = transactionCode;
    }

    public Integer getRating() {
        return rating;
    }

    public void setRating(Integer rating) {
        this.rating = rating;
    }
}