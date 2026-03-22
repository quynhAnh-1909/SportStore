package com.shop.sportstore.model;

import lombok.Data;

import java.util.List;
@Data
public class CateporyParent {
    private int id;
    private String name;
    private List<Category> categories;
}
