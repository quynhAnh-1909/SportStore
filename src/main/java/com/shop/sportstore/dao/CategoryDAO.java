package com.shop.sportstore.dao;



import com.shop.sportstore.model.Category;
import com.shop.sportstore.untils.DBConnection;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;
import java.util.Map;


public class CategoryDAO {
    public List<Category> getAllCategories() {

        List<Category> list = new ArrayList<>();

        String sql = "SELECT * FROM category";

        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql);
             ResultSet rs = ps.executeQuery()) {

            while (rs.next()) {

                Category c = new Category();

                c.setId(rs.getInt("id"));
                c.setName(rs.getString("name"));

                // QUAN TRỌNG: lấy parent_id
                c.setParentId((Integer) rs.getObject("parent_id"));

                list.add(c);
            }

        } catch (Exception e) {
            e.printStackTrace();
        }

        return list;
    }

    public List<Category> buildTree(List<Category> list) {

        List<Category> roots = new ArrayList<>();
        Map<Integer, Category> map = new HashMap<>();

        // B1: đưa tất cả vào map
        for (Category c : list) {
            c.setChildren(new ArrayList<>());
            map.put(c.getId(), c);
        }

        // B2: build cây
        for (Category c : list) {

            if (c.getParentId() == null) {
                roots.add(c);
            } else {
                Category parent = map.get(c.getParentId());
                if (parent != null) {
                    parent.getChildren().add(c);
                }
            }
        }

        return roots;
    }

    public void insertCategory(String name, String parentId) {

        String sql = "INSERT INTO category(name, parent_id) VALUES(?, ?)";

        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {

            ps.setString(1, name);

            if (parentId == null || parentId.isEmpty()) {
                ps.setNull(2, java.sql.Types.INTEGER);
            } else {
                ps.setInt(2, Integer.parseInt(parentId));
            }

            ps.executeUpdate();

        } catch (Exception e) {
            e.printStackTrace();
        }
    }

    public void deleteCategory(int id) {

        String sql = "DELETE FROM category WHERE id=?";

        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {

            ps.setInt(1, id);
            ps.executeUpdate();

        } catch (Exception e) {
            e.printStackTrace();
        }
    }
}