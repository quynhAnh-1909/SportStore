package com.shop.sportstore.model;

public class Banner {

    private int id;
    private String title;
    private String image;
    private boolean status;
    private Integer productId;
    private String link;

    public Banner() {
    }

    public Banner(int id,
                  String title,
                  String image,
                  boolean status) {

        this.id = id;
        this.title = title;
        this.image = image;
        this.status = status;
    }

    public int getId() {
        return id;
    }

    public void setId(int id) {
        this.id = id;
    }

    public String getTitle() {
        return title;
    }

    public void setTitle(String title) {
        this.title = title;
    }

    public String getImage() {
        return image;
    }

    public void setImage(String image) {
        this.image = image;
    }

    public boolean isStatus() {
        return status;
    }

    public void setStatus(boolean status) {
        this.status = status;
    }

    public String getLink() {
        return link;
    }

    public void setProductId(Integer productId) {
        this.productId = productId;
    }

    public void setLink(String link) {
        this.link = link;
    }

    public Integer getProductId() {
        return productId;
    }

}