package com.hagl.dao;

import java.sql.*;
import java.util.*;

import com.hagl.model.Product;

public class ProductDAO extends BaseDAO {

    public ProductDAO() {
        super();
    }

    /* ===============================
       1. LẤY TẤT CẢ SẢN PHẨM
    =============================== */

    public List<Product> getAllProducts() {

        List<Product> list = new ArrayList<>();

        String sql = """
            SELECT p.*, c.name AS categoryName
            FROM products p
            LEFT JOIN categories c ON p.category_id = c.id
        """;

        try {
            Connection conn =getConnection();
            PreparedStatement ps = conn.prepareStatement(sql);
            ResultSet rs = ps.executeQuery();

            while (rs.next()) {

                Product p = new Product();

                p.setId(rs.getInt("id"));
                p.setName(rs.getString("name"));
                p.setPrice(rs.getDouble("price"));
                p.setStockQuantity(rs.getInt("stock_quantity"));
                p.setUnit(rs.getString("unit"));
                p.setCategoryId(rs.getInt("category_id"));

                p.setCategoryName(rs.getString("categoryName")); // quan trọng

                list.add(p);
            }

        } catch (Exception e) {
            e.printStackTrace();
        }

        return list;
    }

    /* ===============================
       2. LẤY PRODUCT THEO ID
    =============================== */

    public Product getProductById(int id) throws SQLException {

        String sql = "SELECT * FROM product WHERE id=?";

        try (Connection conn = getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {

            ps.setInt(1, id);

            ResultSet rs = ps.executeQuery();

            if (rs.next()) {
                return mapResultSetToProduct(rs);
            }
        }

        return null;
    }
   //search
    public List<Product> searchProducts(String keyword, int categoryId, int offset, int limit) {

        List<Product> productList = new ArrayList<>();

        StringBuilder sql = new StringBuilder("SELECT * FROM product WHERE 1=1");

        if (keyword != null && !keyword.trim().isEmpty()) {
            sql.append(" AND name LIKE ?");
        }

        if (categoryId > 0) {
            sql.append(" AND category_id = ?");
        }

        sql.append(" ORDER BY id DESC OFFSET ? ROWS FETCH NEXT ? ROWS ONLY");

        try (Connection conn = getConnection();
             PreparedStatement ps = conn.prepareStatement(sql.toString())) {

            int index = 1;

            if (keyword != null && !keyword.trim().isEmpty()) {
                ps.setString(index++, "%" + keyword + "%");
            }

            if (categoryId > 0) {
                ps.setInt(index++, categoryId);
            }

            ps.setInt(index++, offset);
            ps.setInt(index++, limit);

            ResultSet rs = ps.executeQuery();

            while (rs.next()) {

                Product p = mapResultSetToProduct(rs);

                productList.add(p);
            }

        } catch (SQLException e) {
            e.printStackTrace();
        }

        return productList;
    }

    /* ===============================
       3. THÊM SẢN PHẨM
    =============================== */

    public void insertProduct(Product p) throws SQLException {

        String sql = "INSERT INTO product(name,brand,price,stock_quantity,size,color,description,image_url,category_id)"
                   + " VALUES(?,?,?,?,?,?,?,?,?)";

        try (Connection conn = getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {

            ps.setString(1, p.getName());
            ps.setString(2, p.getBrand());
            ps.setDouble(3, p.getPrice());
            ps.setInt(4, p.getStockQuantity());
            ps.setString(5, p.getSize());
            ps.setString(6, p.getColor());
            ps.setString(7, p.getDescription());
            ps.setString(8, p.getImageUrl());
            ps.setInt(9, p.getCategoryId());

            ps.executeUpdate();
        }
    }

    /* ===============================
       4. CẬP NHẬT SẢN PHẨM
    =============================== */

    public void updateProduct(Product p) throws SQLException {

        String sql = "UPDATE product SET name=?,brand=?,price=?,stock_quantity=?,size=?,color=?,description=?,image_url=?,category_id=? WHERE id=?";

        try (Connection conn = getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {

            ps.setString(1, p.getName());
            ps.setString(2, p.getBrand());
            ps.setDouble(3, p.getPrice());
            ps.setInt(4, p.getStockQuantity());
            ps.setString(5, p.getSize());
            ps.setString(6, p.getColor());
            ps.setString(7, p.getDescription());
            ps.setString(8, p.getImageUrl());
            ps.setInt(9, p.getCategoryId());
            ps.setInt(10, p.getId());

            ps.executeUpdate();
        }
    }

    /* ===============================
       5. XÓA SẢN PHẨM
    =============================== */

    public void deleteProduct(int id) throws SQLException {

        String sql = "DELETE FROM product WHERE id=?";

        try (Connection conn = getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {

            ps.setInt(1, id);

            ps.executeUpdate();
        }
    }

    /* ===============================
       6. SEARCH + FILTER + STOCK
       (GIỐNG FRESHMART)
    =============================== */

    public List<Product> filterProducts(String search, Integer categoryId, String stockStatus) {

        List<Product> list = new ArrayList<>();

        StringBuilder sql = new StringBuilder("SELECT * FROM product WHERE 1=1");

        if (search != null && !search.trim().isEmpty()) {
            sql.append(" AND name LIKE ?");
        }

        if (categoryId != null && categoryId > 0) {
            sql.append(" AND category_id=?");
        }

        if ("in".equals(stockStatus)) {
            sql.append(" AND stock_quantity > 0");
        }

        if ("out".equals(stockStatus)) {
            sql.append(" AND stock_quantity <= 0");
        }

        sql.append(" ORDER BY id DESC");

        try (Connection conn = getConnection();
             PreparedStatement ps = conn.prepareStatement(sql.toString())) {

            int index = 1;

            if (search != null && !search.trim().isEmpty()) {
                ps.setString(index++, "%" + search + "%");
            }

            if (categoryId != null && categoryId > 0) {
                ps.setInt(index++, categoryId);
            }

            ResultSet rs = ps.executeQuery();

            while (rs.next()) {
                list.add(mapResultSetToProduct(rs));
            }

        } catch (Exception e) {
            e.printStackTrace();
        }

        return list;
    }

    /* ===============================
       7. COUNT PRODUCT (PAGINATION)
    =============================== */

    public int countProducts(String keyword, Integer categoryId) {

        int count = 0;

        StringBuilder sql = new StringBuilder("SELECT COUNT(*) FROM product WHERE 1=1");

        if (keyword != null && !keyword.trim().isEmpty()) {
            sql.append(" AND name LIKE ?");
        }

        if (categoryId != null && categoryId > 0) {
            sql.append(" AND category_id=?");
        }

        try (Connection conn = getConnection();
             PreparedStatement ps = conn.prepareStatement(sql.toString())) {

            int index = 1;

            if (keyword != null && !keyword.trim().isEmpty()) {
                ps.setString(index++, "%" + keyword + "%");
            }

            if (categoryId != null && categoryId > 0) {
                ps.setInt(index++, categoryId);
            }

            ResultSet rs = ps.executeQuery();

            if (rs.next()) {
                count = rs.getInt(1);
            }

        } catch (Exception e) {
            e.printStackTrace();
        }

        return count;
    }

    /* ===============================
       MAP RESULTSET -> PRODUCT
    =============================== */

    private Product mapResultSetToProduct(ResultSet rs) throws SQLException {

        Product p = new Product();

        p.setId(rs.getInt("id"));
        p.setName(rs.getString("name"));
        p.setBrand(rs.getString("brand"));
        p.setPrice(rs.getDouble("price"));
        p.setStockQuantity(rs.getInt("stock_quantity"));
        p.setSize(rs.getString("size"));
        p.setColor(rs.getString("color"));
        p.setDescription(rs.getString("description"));
        p.setImageUrl(rs.getString("image_url"));
        p.setCategoryId(rs.getInt("category_id"));

        return p;
    }
}