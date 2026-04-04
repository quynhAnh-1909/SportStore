package com.shop.sportstore.model;

import lombok.Data;

import java.util.Date;
@Data
public class Voucher {
    private int id;
    private String code;
    private String discountType;
    private double discountValue;
    private double minOrderValue;
    private double maxDiscount;
    private int quantity;
    private int usedCount;
    private String paymentMethod;
    private double minProductPrice;
    private int categoryId;
    private Date startDate;
    private Date expiryDate;
    private boolean status;

    // getters & setters
}