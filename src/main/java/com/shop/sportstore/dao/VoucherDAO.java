package com.shop.sportstore.dao;

import com.shop.sportstore.model.Voucher;
import java.sql.*;
import java.util.ArrayList;
import java.util.List;
import com.shop.sportstore.untils.DBConnection;
import java.sql.Connection;

public class VoucherDAO {

    private Connection conn;

    public VoucherDAO(Connection conn) {
        this.conn = conn;
    }

    public void insert(Voucher v) {
        try {
            String sql = "INSERT INTO vouchers(code, discount_type, discount_value, min_order_value, max_discount, quantity, payment_method, min_product_price, category_id, start_date, expiry_date, status, applicable_tier, usage_limit_per_user) VALUES (?,?,?,?,?,?,?,?,?,?,?,?,?,?)";
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
            ps.setString(13, v.getApplicableTier());
            ps.setInt(14, v.getUsageLimitPerUser());

            ps.executeUpdate();
        } catch (Exception e) {
            e.printStackTrace();
        }
    }

    public List<Voucher> getAll() {
        List<Voucher> list = new ArrayList<>();
        try {
            String sql = "SELECT * FROM vouchers ORDER BY id DESC";
            PreparedStatement ps = conn.prepareStatement(sql);
            ResultSet rs = ps.executeQuery();
            while (rs.next()) {
                list.add(mapVoucher(rs));
            }
        } catch (Exception e) {
            e.printStackTrace();
        }
        return list;
    }

    public Voucher findById(int id) {
        Voucher v = null;
        try {
            String sql = "SELECT * FROM vouchers WHERE id = ?";
            PreparedStatement ps = conn.prepareStatement(sql);
            ps.setInt(1, id);
            ResultSet rs = ps.executeQuery();
            if (rs.next()) {
                v = mapVoucher(rs);
            }
        } catch (Exception e) {
            e.printStackTrace();
        }
        return v;
    }

    public Voucher findByCode(String code) {
        Voucher v = null;
        try {
            String sql = "SELECT * FROM vouchers WHERE code = ?";
            PreparedStatement ps = conn.prepareStatement(sql);
            ps.setString(1, code);
            ResultSet rs = ps.executeQuery();
            if (rs.next()) {
                v = mapVoucher(rs);
            }
        } catch (Exception e) {
            e.printStackTrace();
        }
        return v;
    }

    public boolean checkCode(String code) {
        try {
            String sql = "SELECT * FROM vouchers WHERE code = ?";
            PreparedStatement ps = conn.prepareStatement(sql);
            ps.setString(1, code);
            ResultSet rs = ps.executeQuery();
            if (rs.next()) return true;
        } catch (Exception e) {
            e.printStackTrace();
        }
        return false;
    }

    public void update(Voucher v) {
        try {
            String sql = "UPDATE vouchers SET code=?, discount_type=?, discount_value=?, min_order_value=?, max_discount=?, quantity=?, payment_method=?, min_product_price=?, category_id=?, start_date=?, expiry_date=?, status=?, applicable_tier=?, usage_limit_per_user=? WHERE id=?";
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
            ps.setString(13, v.getApplicableTier());
            ps.setInt(14, v.getUsageLimitPerUser());
            ps.setInt(15, v.getId());
            ps.executeUpdate();
        } catch (Exception e) {
            e.printStackTrace();
        }
    }

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

    public List<Voucher> getByProductId(int productId) {
        List<Voucher> list = new ArrayList<>();
        try {
            String sql = "SELECT v.* FROM vouchers v JOIN product_voucher pv ON v.id = pv.voucher_id WHERE pv.product_id = ?";
            PreparedStatement ps = conn.prepareStatement(sql);
            ps.setInt(1, productId);
            ResultSet rs = ps.executeQuery();
            while (rs.next()) {
                Voucher v = new Voucher();
                v.setId(rs.getInt("id"));
                v.setCode(rs.getString("code"));
                list.add(v);
            }
        } catch (Exception e) {
            e.printStackTrace();
        }
        return list;
    }

    public List<Voucher> findAllActive() {
        List<Voucher> list = new ArrayList<>();
        try {
            String sql = "SELECT * FROM vouchers WHERE status = true AND (applicable_tier IS NULL OR applicable_tier = 'ALL') AND NOW() BETWEEN start_date AND expiry_date AND used_count < quantity ORDER BY id DESC";
            PreparedStatement ps = conn.prepareStatement(sql);
            ResultSet rs = ps.executeQuery();
            while (rs.next()) {
                list.add(mapVoucher(rs));
            }
        } catch (Exception e) {
            e.printStackTrace();
        }
        return list;
    }

    public int getTotalVoucherQuantity() {
        int total = 0;
        String sql = "SELECT SUM(quantity) FROM vouchers";
        try (PreparedStatement ps = conn.prepareStatement(sql); ResultSet rs = ps.executeQuery()) {
            if (rs.next()) total = rs.getInt(1);
        } catch (Exception e) { e.printStackTrace(); }
        return total;
    }

    public int getTotalVoucherUsedCount() {
        int total = 0;
        String sql = "SELECT SUM(used_count) FROM vouchers";
        try (PreparedStatement ps = conn.prepareStatement(sql); ResultSet rs = ps.executeQuery()) {
            if (rs.next()) total = rs.getInt(1);
        } catch (Exception e) { e.printStackTrace(); }
        return total;
    }


    public Voucher getAutomaticVoucherByTier(int userId, String tierName) {
        if (tierName == null || tierName.trim().isEmpty() || "Đồng".equalsIgnoreCase(tierName.trim())) {
            return null;
        }
        Voucher v = null;
        String sql = "SELECT * FROM vouchers WHERE status = true "
                + "AND UPPER(applicable_tier) = ? "
                + "AND NOW() BETWEEN start_date AND expiry_date "
                + "AND used_count < quantity LIMIT 1";
        try {
            PreparedStatement ps = conn.prepareStatement(sql);
            ps.setString(1, tierName.trim().toUpperCase());
            ResultSet rs = ps.executeQuery();
            if (rs.next()) {
                v = mapVoucher(rs);
            }
        } catch (Exception e) {
            e.printStackTrace();
        }
        return v;
    }


    public List<Voucher> getAllActiveVouchersForSelect() {
        List<Voucher> list = new ArrayList<>();

        String sql = "SELECT * FROM vouchers WHERE status = true "
                + "AND code NOT LIKE 'RANK%' "
                + "AND NOW() BETWEEN start_date AND expiry_date "
                + "AND used_count < quantity ORDER BY id DESC";
        try (PreparedStatement ps = conn.prepareStatement(sql);
             ResultSet rs = ps.executeQuery()) {
            while (rs.next()) {
                list.add(mapVoucher(rs));
            }
        } catch (Exception e) {
            e.printStackTrace();
        }
        return list;
    }

    public List<Voucher> getNormalVouchersForCheckout() {
        return getAllActiveVouchersForSelect();
    }

    private Voucher mapVoucher(ResultSet rs) throws SQLException {
        Voucher v = new Voucher();
        v.setId(rs.getInt("id"));
        v.setCode(rs.getString("code"));
        v.setDiscountType(rs.getString("discount_type"));
        v.setDiscountValue(rs.getDouble("discount_value"));
        v.setMinOrderValue(rs.getDouble("min_order_value"));


        v.setMaxDiscount(rs.getObject("max_discount") != null ? rs.getDouble("max_discount") : null);

        v.setQuantity(rs.getInt("quantity"));
        v.setUsedCount(rs.getInt("used_count"));
        v.setPaymentMethod(rs.getString("payment_method"));
        v.setMinProductPrice(rs.getDouble("min_product_price"));

        int catId = rs.getInt("category_id");
        v.setCategoryId(rs.wasNull() ? null : catId);

        v.setStartDate(rs.getTimestamp("start_date"));
        v.setExpiryDate(rs.getTimestamp("expiry_date"));
        v.setStatus(rs.getBoolean("status"));
        v.setApplicableTier(rs.getString("applicable_tier"));
        v.setUsageLimitPerUser(rs.getInt("usage_limit_per_user"));
        return v;
    }


    public List<Voucher> getActiveVouchersForPromotionPage(String userTier) {
        List<Voucher> list = new ArrayList<>();

        String sql = "SELECT * FROM vouchers WHERE status = true "
                + "AND NOW() BETWEEN start_date AND expiry_date "
                + "AND used_count < quantity "
                + "ORDER BY FIELD(applicable_tier, 'Đồng', 'Bạc', 'Vàng', 'Kim Cương'), id DESC";
        try (PreparedStatement ps = conn.prepareStatement(sql);
             ResultSet rs = ps.executeQuery()) {
            while (rs.next()) {
                list.add(mapVoucher(rs));
            }
        } catch (Exception e) {
            e.printStackTrace();
        }
        return list;
    }

    public List<Voucher> getSavedVouchersByUserId(int userId) {
        List<Voucher> list = new ArrayList<>();
        String sql = "SELECT v.* FROM vouchers v "
                + "JOIN user_vouchers uv ON v.id = uv.voucher_id "
                + "WHERE uv.user_id = ? "
                + "AND v.status = true "
                + "AND NOW() BETWEEN v.start_date AND v.expiry_date "
                + "AND v.used_count < v.quantity "
                + "AND uv.order_id IS NULL "
                + "ORDER BY v.id DESC";

        try (PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setInt(1, userId);
            try (ResultSet rs = ps.executeQuery()) {
                while (rs.next()) {

                    list.add(mapVoucher(rs));
                }
            }
        } catch (Exception e) {
            e.printStackTrace();
        }
        return list;
    }


    public boolean saveVoucher(int userId, int voucherId) {

        String checkSql = "SELECT 1 FROM user_vouchers WHERE user_id = ? AND voucher_id = ? AND order_id IS NULL LIMIT 1";

        String insertSql = "INSERT INTO user_vouchers (user_id, voucher_id, order_id, used_at) VALUES (?, ?, NULL, NULL)";

        try {

            try (PreparedStatement psCheck = conn.prepareStatement(checkSql)) {
                psCheck.setInt(1, userId);
                psCheck.setInt(2, voucherId);
                try (ResultSet rs = psCheck.executeQuery()) {
                    if (rs.next()) {
                        return false;
                    }
                }
            }


            try (PreparedStatement psInsert = conn.prepareStatement(insertSql)) {
                psInsert.setInt(1, userId);
                psInsert.setInt(2, voucherId);
                return psInsert.executeUpdate() > 0;
            }
        } catch (Exception e) {
            e.printStackTrace();
        }
        return false;
    }
}