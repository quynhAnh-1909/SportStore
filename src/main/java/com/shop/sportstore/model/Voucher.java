package com.shop.sportstore.model;

import java.util.Date;

public class Voucher {
    private int id;
    private String code;
    private String discountType;
    private double discountValue;
    private double minOrderValue;

    private Double maxDiscount;
    private Integer categoryId;

    private int quantity;
    private int usedCount;
    private String paymentMethod;
    private double minProductPrice;
    private Date startDate;
    private Date expiryDate;
    private boolean status;
    private String applicableTier;
    private int usageLimitPerUser;

    // GETTER & SETTER
    public int getId() { return id; }
    public void setId(int id) { this.id = id; }

    public String getCode() { return code; }
    public void setCode(String code) { this.code = code; }

    public String getDiscountType() { return discountType; }
    public void setDiscountType(String discountType) { this.discountType = discountType; }

    public double getDiscountValue() { return discountValue; }
    public void setDiscountValue(double discountValue) { this.discountValue = discountValue; }

    public double getMinOrderValue() { return minOrderValue; }
    public void setMinOrderValue(double minOrderValue) { this.minOrderValue = minOrderValue; }

    public Double getMaxDiscount() { return maxDiscount; }
    public void setMaxDiscount(Double maxDiscount) { this.maxDiscount = maxDiscount; }

    public int getQuantity() { return quantity; }
    public void setQuantity(int quantity) { this.quantity = quantity; }

    public int getUsedCount() { return usedCount; }
    public void setUsedCount(int usedCount) { this.usedCount = usedCount; }

    public String getPaymentMethod() { return paymentMethod; }
    public void setPaymentMethod(String paymentMethod) { this.paymentMethod = paymentMethod; }

    public double getMinProductPrice() { return minProductPrice; }
    public void setMinProductPrice(double minProductPrice) { this.minProductPrice = minProductPrice; }

    public Integer getCategoryId() { return categoryId; }
    public void setCategoryId(Integer categoryId) { this.categoryId = categoryId; }

    public Date getStartDate() { return startDate; }
    public void setStartDate(Date startDate) { this.startDate = startDate; }

    public Date getExpiryDate() { return expiryDate; }
    public void setExpiryDate(Date expiryDate) { this.expiryDate = expiryDate; }

    public boolean isStatus() { return status; }
    public void setStatus(boolean status) { this.status = status; }

    public String getApplicableTier() { return applicableTier; }
    public void setApplicableTier(String applicableTier) { this.applicableTier = applicableTier; }

    public int getUsageLimitPerUser() { return usageLimitPerUser; }
    public void setUsageLimitPerUser(int usageLimitPerUser) { this.usageLimitPerUser = usageLimitPerUser; }
}