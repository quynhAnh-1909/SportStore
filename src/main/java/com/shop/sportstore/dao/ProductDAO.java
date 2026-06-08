package com.shop.sportstore.dao;

import com.shop.sportstore.model.Product;
import com.shop.sportstore.model.Voucher;
import com.shop.sportstore.untils.DBConnection;

import java.sql.*;
import java.util.*;

public class ProductDAO extends DBConnection {

    public ProductDAO() {

        super();
    }

    //ListProduct

    public List<Product> getAllProducts() {

        List<Product> list = new ArrayList<>();

        String sql = """
        SELECT p.*, c.name AS categoryName
        FROM products p
        LEFT JOIN category c ON p.category_id = c.id
        ORDER BY p.id DESC
    """;

        try (Connection conn = getConnection();
             PreparedStatement ps = conn.prepareStatement(sql);
             ResultSet rs = ps.executeQuery()) {

            while (rs.next()) {

                Product p = mapResultSetToProduct(rs);

                p.setCategoryName(
                        rs.getString("categoryName")
                );

                list.add(p);
            }

            VoucherDAO voucherDAO =
                    new VoucherDAO(conn);

            for (Product p : list) {

                List<Voucher> vouchers =
                        voucherDAO.getByProductId(
                                p.getId()
                        );

                p.setVouchers(vouchers);
            }

        } catch (Exception e) {

            e.printStackTrace();
        }

        return list;
    }

    public Product getProductById(int id) {

        String sql = """
        SELECT p.*, c.name AS categoryName
        FROM products p
        LEFT JOIN category c ON p.category_id = c.id
        WHERE p.id=?
    """;

        try (Connection conn = getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {

            ps.setInt(1, id);

            ResultSet rs = ps.executeQuery();

            if (rs.next()) {

                Product p = mapResultSetToProduct(rs);

                p.setCategoryName(
                        rs.getString("categoryName")
                );

                VoucherDAO voucherDAO =
                        new VoucherDAO(conn);

                p.setVouchers(
                        voucherDAO.getByProductId(
                                p.getId()
                        )
                );

                return p;
            }

        } catch (Exception e) {
            e.printStackTrace();
        }

        return null;
    }
    //search
    public List<Product> searchProducts(String keyword, int categoryId, int offset, int limit) {

        List<Product> list = new ArrayList<>();

        StringBuilder sql = new StringBuilder("SELECT * FROM products WHERE 1=1");

        if (keyword != null && !keyword.trim().isEmpty()) {
            sql.append(" AND name LIKE ?");
        }

        if (categoryId > 0) {
            sql.append(" AND category_id = ?");
        }

        sql.append(" ORDER BY id DESC LIMIT ?, ?");

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

                System.out.println(
                        rs.getInt("id")
                                + " | "
                                + rs.getString("name")
                                + " | "
                                + rs.getInt("category_id")
                );

                list.add(mapResultSetToProduct(rs));
            }

        } catch (Exception e) {
            e.printStackTrace();
        }

        return list;
    }


    public List<Product> searchSuggestions(String keyword) {

        List<Product> list = new ArrayList<>();

        String sql =
                "SELECT * FROM products " +
                        "WHERE name LIKE ? " +
                        "LIMIT 5";

        try (
                Connection conn = getConnection();
                PreparedStatement ps =
                        conn.prepareStatement(sql)
        ) {

            ps.setString(1, "%" + keyword + "%");

            ResultSet rs = ps.executeQuery();

            while (rs.next()) {

                Product p = new Product();

                p.setId(rs.getInt("id"));
                p.setName(rs.getString("name"));
                p.setImageUrl(rs.getString("image_url"));
                p.setPrice(rs.getDouble("price"));

                list.add(p);
            }

        } catch (Exception e) {
            e.printStackTrace();
        }

        return list;
    }

    public void insertProduct(Product p) throws SQLException {

        String sql = """
            INSERT INTO products(name, brand, price, stock_quantity, size, color, description, image_url, category_id)
            VALUES(?,?,?,?,?,?,?,?,?)
        """;

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


    public void updateProduct(Product p) throws SQLException {

        String sql = """
            UPDATE products 
            SET name=?, brand=?, price=?, stock_quantity=?, size=?, color=?, description=?, image_url=?, category_id=?
            WHERE id=?
        """;

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

    public void deleteProduct(int id) throws SQLException {

        String sql = "DELETE FROM products WHERE id=?";

        try (Connection conn = getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {

            ps.setInt(1, id);
            ps.executeUpdate();
        }
    }


    public List<Product> filterProducts(String search, Integer categoryId, String stockStatus) {

        List<Product> list = new ArrayList<>();

        StringBuilder sql = new StringBuilder("SELECT * FROM products WHERE 1=1");

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

    public int countProducts(String keyword, Integer categoryId) {

        int count = 0;

        StringBuilder sql = new StringBuilder("SELECT COUNT(*) FROM products WHERE 1=1");

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

    public List<Product> getAll() {
        List<Product> list = new ArrayList<>();
        String sql = "SELECT * FROM products ORDER BY id DESC LIMIT 8";

        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql);
             ResultSet rs = ps.executeQuery()) {

            while (rs.next()) {

                Product p = new Product();

                p.setId(rs.getInt("id"));
                p.setName(rs.getString("name"));
                p.setPrice(rs.getDouble("price"));
                p.setImageUrl(rs.getString("image_url"));
                p.setCategoryId(rs.getInt("category_id"));

                list.add(p);
            }

        } catch (Exception e) {
            e.printStackTrace();
        }

        return list;
    }

    private Product mapProduct(ResultSet rs)
            throws SQLException {

        Product p = new Product();

        p.setId(rs.getInt("id"));
        p.setName(rs.getString("name"));
        p.setPrice(rs.getDouble("price"));
        p.setImageUrl(rs.getString("image_url"));
        p.setDescription(rs.getString("description"));
        p.setStockQuantity(rs.getInt("stock_quantity"));
        p.setCategoryId(rs.getInt("category_id"));

        return p;
    }

    public List<Product> getAllExcept(int productId) {

        List<Product> list = new ArrayList<>();

        String sql = """
        SELECT *
        FROM products
        WHERE id != ?
    """;

        try (
                Connection conn = DBConnection.getConnection();
                PreparedStatement ps = conn.prepareStatement(sql)
        ) {

            ps.setInt(1, productId);

            ResultSet rs = ps.executeQuery();

            while (rs.next()) {

                Product p = new Product();

                p.setId(rs.getInt("id"));
                p.setName(rs.getString("name"));
                p.setPrice(rs.getDouble("price"));
                p.setImageUrl(rs.getString("image_url"));
                p.setCategoryId(rs.getInt("category_id"));

                list.add(p);
            }

        } catch (Exception e) {
            e.printStackTrace();
        }

        return list;
    }

    public List<Product> getRelatedProducts(int categoryId, int productId) {

        List<Product> list = new ArrayList<>();

        String sql = """
        SELECT *
        FROM products
        WHERE category_id = ?
        AND id != ?
        LIMIT 4
    """;

        try (
                Connection conn = DBConnection.getConnection();
                PreparedStatement ps = conn.prepareStatement(sql)
        ) {

            ps.setInt(1, categoryId);
            ps.setInt(2, productId);

            ResultSet rs = ps.executeQuery();

            while (rs.next()) {

                Product p = mapProduct(rs);
                list.add(p);
            }

            // nếu chưa đủ 4 sản phẩm
            if (list.size() < 4) {

                String extraSql = """
                SELECT *
                FROM products
                WHERE id != ?
                AND category_id != ?
                LIMIT ?
            """;

                PreparedStatement extraPs =
                        conn.prepareStatement(extraSql);

                extraPs.setInt(1, productId);
                extraPs.setInt(2, categoryId);
                extraPs.setInt(3, 4 - list.size());

                ResultSet extraRs = extraPs.executeQuery();

                while (extraRs.next()) {

                    Product p = mapProduct(extraRs);
                    list.add(p);
                }
            }

        } catch (Exception e) {
            e.printStackTrace();
        }

        return list;
    }

    public List<Product> getProductsByCategory(int categoryId, int limit) {

        List<Product> list = new ArrayList<>();

        String sql = """
        SELECT *
        FROM products
        WHERE category_id = ?
        ORDER BY id DESC
        LIMIT ?
    """;

        try (
                Connection conn = getConnection();
                PreparedStatement ps = conn.prepareStatement(sql)
        ) {

            ps.setInt(1, categoryId);
            ps.setInt(2, limit);

            ResultSet rs = ps.executeQuery();

            while (rs.next()) {
                list.add(mapResultSetToProduct(rs));
            }

        } catch (Exception e) {
            e.printStackTrace();
        }

        return list;
    }

    public List<Product> getBestSellerProducts(int limit) {

        List<Product> list = new ArrayList<>();

        String sql = """
        SELECT * FROM products
        ORDER BY id DESC
        LIMIT ?
    """;

        try (
                Connection conn = getConnection();
                PreparedStatement ps = conn.prepareStatement(sql)
        ) {

            ps.setInt(1, limit);

            ResultSet rs = ps.executeQuery();

            while (rs.next()) {
                list.add(mapResultSetToProduct(rs));
            }

        } catch (Exception e) {
            e.printStackTrace();
        }

        return list;
    }
    public List<Product> getInventoryProducts() {
        List<Product> list = new ArrayList<>();
        String sql = "SELECT * FROM products WHERE stock_quantity > 0 ORDER BY stock_quantity DESC LIMIT 5";

        try (Connection conn = getConnection();
             PreparedStatement ps = conn.prepareStatement(sql);
             ResultSet rs = ps.executeQuery()) {
            while (rs.next()) {
                list.add(mapResultSetToProduct(rs));
            }
        } catch (Exception e) {
            e.printStackTrace();
        }
        return list;
    }
    public List<Product> getSlowMovingProducts() {
        List<Product> list = new ArrayList<>();
        String sql = "SELECT * FROM products ORDER BY stock_quantity ASC LIMIT 5";

        try (Connection conn = getConnection();
             PreparedStatement ps = conn.prepareStatement(sql);
             ResultSet rs = ps.executeQuery()) {
            while (rs.next()) {
                list.add(mapResultSetToProduct(rs));
            }
        } catch (Exception e) {
            e.printStackTrace();
        }
        return list;
    }

    public List<Product> getWeeklyHotProducts() {
        List<Product> list = new ArrayList<>();
        String sql = """
            SELECT p.*, SUM(od.Quantity) AS WeeklySold 
            FROM orderdetails od 
            JOIN orders o ON od.OrderId = o.Id 
            JOIN products p ON od.ProductId = p.id 
            WHERE o.Status = 'COMPLETED' AND o.CreatedAt >= NOW() - INTERVAL 7 DAY 
            GROUP BY p.id, p.name, p.brand, p.price, p.stock_quantity, p.size, p.color, p.description, p.image_url, p.category_id
            ORDER BY WeeklySold DESC LIMIT 5
        """;

        try (Connection conn = getConnection();
             PreparedStatement ps = conn.prepareStatement(sql);
             ResultSet rs = ps.executeQuery()) {
            while (rs.next()) {
                Product p = mapResultSetToProduct(rs);
                p.setPrice(rs.getDouble("WeeklySold"));
                list.add(p);
            }
        } catch (Exception e) {
            e.printStackTrace();
        }
        return list;
    }
}