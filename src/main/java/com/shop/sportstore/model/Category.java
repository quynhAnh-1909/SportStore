package com.shop.sportstore.model;

import lombok.Data;

import java.util.List;


@Data
public class Category {
    private int id;
    private String name;
    private Integer parentId;
    private List<Category> children;
}






