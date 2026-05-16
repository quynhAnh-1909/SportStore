package com.shop.sportstore.dao;

import com.shop.sportstore.model.Banner;
import com.shop.sportstore.untils.DBConnection;

import java.sql.*;
import java.util.ArrayList;
import java.util.List;

public class BannerDAO {

    // =========================
    // FIND ALL
    // =========================
    public List<Banner> findAll() {

        List<Banner> list = new ArrayList<>();

        String sql =
                "SELECT * FROM banners ORDER BY id DESC";

        try (
                Connection conn = DBConnection.getConnection();
                PreparedStatement ps = conn.prepareStatement(sql);
                ResultSet rs = ps.executeQuery()
        ) {

            while (rs.next()) {

                Banner b = new Banner();

                b.setId(rs.getInt("id"));
                b.setTitle(rs.getString("title"));
                b.setImage(rs.getString("image"));
                b.setStatus(rs.getBoolean("status"));

                b.setProductId(
                        (Integer) rs.getObject("product_id")
                );

                list.add(b);
            }

        } catch (Exception e) {
            e.printStackTrace();
        }

        return list;
    }

    // =========================
    // FIND ACTIVE BANNERS
    // =========================
    public List<Banner> findActiveBanners() {

        List<Banner> list = new ArrayList<>();

        String sql =
                "SELECT * FROM banners " +
                        "WHERE status = true " +
                        "ORDER BY id DESC " +
                        "LIMIT 3";

        try (
                Connection conn = DBConnection.getConnection();
                PreparedStatement ps = conn.prepareStatement(sql);
                ResultSet rs = ps.executeQuery()
        ) {

            while (rs.next()) {

                Banner b = new Banner();

                b.setId(rs.getInt("id"));
                b.setTitle(rs.getString("title"));
                b.setImage(rs.getString("image"));
                b.setStatus(rs.getBoolean("status"));

                b.setProductId(
                        (Integer) rs.getObject("product_id")
                );

                list.add(b);
            }

        } catch (Exception e) {
            e.printStackTrace();
        }

        return list;
    }

    // =========================
    // FIND BY ID
    // =========================
    public Banner findById(int id) {

        String sql =
                "SELECT * FROM banners WHERE id=?";

        try (
                Connection conn = DBConnection.getConnection();
                PreparedStatement ps = conn.prepareStatement(sql)
        ) {

            ps.setInt(1, id);

            ResultSet rs = ps.executeQuery();

            if (rs.next()) {

                Banner b = new Banner();

                b.setId(rs.getInt("id"));
                b.setTitle(rs.getString("title"));
                b.setImage(rs.getString("image"));
                b.setStatus(rs.getBoolean("status"));

                b.setProductId(
                        (Integer) rs.getObject("product_id")
                );

                return b;
            }

        } catch (Exception e) {
            e.printStackTrace();
        }

        return null;
    }

    // =========================
    // INSERT
    // =========================
    public void insert(Banner banner) {

        String sql =
                "INSERT INTO banners(title,image,status,product_id) " +
                        "VALUES(?,?,?,?)";

        try (
                Connection conn = DBConnection.getConnection();
                PreparedStatement ps = conn.prepareStatement(sql)
        ) {

            ps.setString(1, banner.getTitle());
            ps.setString(2, banner.getImage());
            ps.setBoolean(3, banner.isStatus());

            if (banner.getProductId() == null) {

                ps.setNull(4, Types.INTEGER);

            } else {

                ps.setInt(4, banner.getProductId());
            }

            ps.executeUpdate();

        } catch (Exception e) {
            e.printStackTrace();
        }
    }

    // =========================
    // DELETE
    // =========================
    public void delete(int id) {

        String sql =
                "DELETE FROM banners WHERE id=?";

        try (
                Connection conn = DBConnection.getConnection();
                PreparedStatement ps = conn.prepareStatement(sql)
        ) {

            ps.setInt(1, id);

            ps.executeUpdate();

        } catch (Exception e) {
            e.printStackTrace();
        }
    }

    // =========================
    // UPDATE STATUS
    // =========================
    public void updateStatus(int id,
                             boolean status) {

        String sql =
                "UPDATE banners " +
                        "SET status=? " +
                        "WHERE id=?";

        try (
                Connection conn = DBConnection.getConnection();
                PreparedStatement ps = conn.prepareStatement(sql)
        ) {

            ps.setBoolean(1, status);
            ps.setInt(2, id);

            ps.executeUpdate();

        } catch (Exception e) {
            e.printStackTrace();
        }
    }

    // =========================
    // UPDATE
    // =========================
    public void update(Banner banner) {

        String sql =
                "UPDATE banners " +
                        "SET title=?, image=?, status=?, product_id=? " +
                        "WHERE id=?";

        try (
                Connection conn = DBConnection.getConnection();
                PreparedStatement ps = conn.prepareStatement(sql)
        ) {

            ps.setString(1, banner.getTitle());
            ps.setString(2, banner.getImage());
            ps.setBoolean(3, banner.isStatus());

            if (banner.getProductId() == null) {

                ps.setNull(4, Types.INTEGER);

            } else {

                ps.setInt(4, banner.getProductId());
            }

            ps.setInt(5, banner.getId());

            ps.executeUpdate();

        } catch (Exception e) {
            e.printStackTrace();
        }
    }
}