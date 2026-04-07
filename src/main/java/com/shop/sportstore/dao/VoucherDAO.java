package com.shop.sportstore.dao;

import com.shop.sportstore.model.Voucher;

import java.sql.*;
import java.util.ArrayList;
import java.util.List;

public class VoucherDAO {

    private Connection conn;

    public VoucherDAO(Connection conn) {
        this.conn = conn;
    }

    // ================== THÊM ==================
    public void insert(Voucher v) {
        try {
            String sql = "INSERT INTO vouchers(code, discount_type, discount_value, min_order_value, max_discount, quantity, payment_method, min_product_price, category_id, start_date, expiry_date, status) VALUES (?,?,?,?,?,?,?,?,?,?,?,?)";

            PreparedStatement ps = conn.prepareStatement(sql);

            ps.setString(1, v.getCode());
            ps.setString(2, v.getDiscountType());
            ps.setDouble(3, v.getDiscountValue());
            ps.setDouble(4, v.getMinOrderValue());
            ps.setDouble(5, v.getMaxDiscount());
            ps.setInt(6, v.getQuantity());
            ps.setString(7, v.getPaymentMethod());
            ps.setDouble(8, v.getMinProductPrice());

            if (v.getCategoryId() == 0) {
                ps.setNull(9, Types.INTEGER);
            } else {
                ps.setInt(9, v.getCategoryId());
            }

            ps.setTimestamp(10, new Timestamp(v.getStartDate().getTime()));
            ps.setTimestamp(11, new Timestamp(v.getExpiryDate().getTime()));
            ps.setBoolean(12, v.isStatus());

            ps.executeUpdate();

        } catch (Exception e) {
            e.printStackTrace();
        }
    }

    // ================== LẤY TẤT CẢ ==================
    public List<Voucher> getAll() {
        List<Voucher> list = new ArrayList<>();

        try {
            String sql = "SELECT * FROM vouchers ORDER BY id DESC";
            PreparedStatement ps = conn.prepareStatement(sql);
            ResultSet rs = ps.executeQuery();

            while (rs.next()) {
                Voucher v = new Voucher();

                v.setId(rs.getInt("id"));
                v.setCode(rs.getString("code"));
                v.setDiscountType(rs.getString("discount_type"));
                v.setDiscountValue(rs.getDouble("discount_value"));
                v.setMinOrderValue(rs.getDouble("min_order_value"));
                v.setMaxDiscount(rs.getDouble("max_discount"));
                v.setQuantity(rs.getInt("quantity"));
                v.setUsedCount(rs.getInt("used_count"));
                v.setPaymentMethod(rs.getString("payment_method"));
                v.setMinProductPrice(rs.getDouble("min_product_price"));
                v.setCategoryId(rs.getInt("category_id"));
                v.setStartDate(rs.getTimestamp("start_date"));
                v.setExpiryDate(rs.getTimestamp("expiry_date"));
                v.setStatus(rs.getBoolean("status"));

                list.add(v);
            }

        } catch (Exception e) {
            e.printStackTrace();
        }

        return list;
    }

    // ================== TÌM THEO ID ==================
    public Voucher findById(int id) {
        Voucher v = null;

        try {
            String sql = "SELECT * FROM vouchers WHERE id = ?";
            PreparedStatement ps = conn.prepareStatement(sql);
            ps.setInt(1, id);

            ResultSet rs = ps.executeQuery();

            if (rs.next()) {
                v = new Voucher();

                v.setId(rs.getInt("id"));
                v.setCode(rs.getString("code"));
                v.setDiscountType(rs.getString("discount_type"));
                v.setDiscountValue(rs.getDouble("discount_value"));
                v.setMinOrderValue(rs.getDouble("min_order_value"));
                v.setMaxDiscount(rs.getDouble("max_discount"));
                v.setQuantity(rs.getInt("quantity"));
                v.setUsedCount(rs.getInt("used_count"));
                v.setPaymentMethod(rs.getString("payment_method"));
                v.setMinProductPrice(rs.getDouble("min_product_price"));
                v.setCategoryId(rs.getInt("category_id"));
                v.setStartDate(rs.getTimestamp("start_date"));
                v.setExpiryDate(rs.getTimestamp("expiry_date"));
                v.setStatus(rs.getBoolean("status"));
            }

        } catch (Exception e) {
            e.printStackTrace();
        }

        return v;
    }

    // ================== TÌM THEO CODE ==================
    public Voucher findByCode(String code) {
        Voucher v = null;

        try {
            String sql = "SELECT * FROM vouchers WHERE code = ?";
            PreparedStatement ps = conn.prepareStatement(sql);
            ps.setString(1, code);

            ResultSet rs = ps.executeQuery();

            if (rs.next()) {
                v = new Voucher();

                v.setId(rs.getInt("id"));
                v.setCode(rs.getString("code"));
                v.setDiscountType(rs.getString("discount_type"));
                v.setDiscountValue(rs.getDouble("discount_value"));
                v.setMinOrderValue(rs.getDouble("min_order_value"));
                v.setMaxDiscount(rs.getDouble("max_discount"));
                v.setQuantity(rs.getInt("quantity"));
                v.setUsedCount(rs.getInt("used_count"));
                v.setPaymentMethod(rs.getString("payment_method"));
                v.setMinProductPrice(rs.getDouble("min_product_price"));
                v.setCategoryId(rs.getInt("category_id"));
                v.setStartDate(rs.getTimestamp("start_date"));
                v.setExpiryDate(rs.getTimestamp("expiry_date"));
                v.setStatus(rs.getBoolean("status"));
            }

        } catch (Exception e) {
            e.printStackTrace();
        }

        return v;
    }

    // ================== CHECK CODE ==================
    public boolean checkCode(String code) {
        try {
            String sql = "SELECT * FROM vouchers WHERE code = ?";
            PreparedStatement ps = conn.prepareStatement(sql);
            ps.setString(1, code);

            ResultSet rs = ps.executeQuery();

            if (rs.next()) {
                return true;
            }

        } catch (Exception e) {
            e.printStackTrace();
        }

        return false;
    }

    // ================== UPDATE ==================
    public void update(Voucher v) {
        try {
            String sql = "UPDATE vouchers SET "
                    + "code=?, "
                    + "discount_type=?, "
                    + "discount_value=?, "
                    + "min_order_value=?, "
                    + "max_discount=?, "
                    + "quantity=?, "
                    + "payment_method=?, "
                    + "min_product_price=?, "
                    + "category_id=?, "
                    + "start_date=?, "
                    + "expiry_date=?, "
                    + "status=? "
                    + "WHERE id=?";

            PreparedStatement ps = conn.prepareStatement(sql);

            ps.setString(1, v.getCode());
            ps.setString(2, v.getDiscountType());
            ps.setDouble(3, v.getDiscountValue());
            ps.setDouble(4, v.getMinOrderValue());
            ps.setDouble(5, v.getMaxDiscount());
            ps.setInt(6, v.getQuantity());

            ps.setString(7, v.getPaymentMethod());
            ps.setDouble(8, v.getMinProductPrice());

            if (v.getCategoryId() == 0) {
                ps.setNull(9, Types.INTEGER);
            } else {
                ps.setInt(9, v.getCategoryId());
            }

            ps.setTimestamp(10, new Timestamp(v.getStartDate().getTime()));
            ps.setTimestamp(11, new Timestamp(v.getExpiryDate().getTime()));
            ps.setBoolean(12, v.isStatus());

            ps.setInt(13, v.getId());

            ps.executeUpdate();

            System.out.println("Update thành công ID = " + v.getId());

        } catch (Exception e) {
            e.printStackTrace();
        }
    }
    // ================== DELETE ==================
    public void delete(int id) {
        try {
            String sql = "DELETE FROM vouchers WHERE id=?";
            PreparedStatement ps = conn.prepareStatement(sql);
            ps.setInt(1, id);

            ps.executeUpdate();

        } catch (Exception e) {
            e.printStackTrace();
        }
    }

    // ================== TĂNG LƯỢT DÙNG ==================
    public void updateUsed(int id) {
        try {
            String sql = "UPDATE vouchers SET used_count = used_count + 1 WHERE id=?";
            PreparedStatement ps = conn.prepareStatement(sql);
            ps.setInt(1, id);

            ps.executeUpdate();

        } catch (Exception e) {
            e.printStackTrace();
        }
    }
}