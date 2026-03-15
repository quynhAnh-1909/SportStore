package com.hagl.dao;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.util.ArrayList;
import java.util.List;

import com.hagl.model.Category;
import com.hagl.utils.DBConnection;

public class CategoryDAO {
	public List<Category> getAllCategories() {

	    List<Category> list = new ArrayList<>();

	    String sql = "SELECT * FROM categories";

	    try (Connection conn =DBConnection.getConnection();
	         PreparedStatement ps = conn.prepareStatement(sql);
	         ResultSet rs = ps.executeQuery()) {

	        while (rs.next()) {

	            Category c = new Category();

	            c.setId(rs.getInt("id"));
	            c.setName(rs.getString("name"));
	            c.setDescription(rs.getString("description"));

	            list.add(c);
	        }

	    } catch (Exception e) {
	        e.printStackTrace();
	    }

	    return list;
	}
}
