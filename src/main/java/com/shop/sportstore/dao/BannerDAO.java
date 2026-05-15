package com.shop.sportstore.dao;



import com.shop.sportstore.model.Banner;
import com.shop.sportstore.untils.DBConnection;

import java.sql.*;
import java.util.ArrayList;
import java.util.List;

public class BannerDAO {


    public List<Banner> findAll() {

        List<Banner> list = new ArrayList<>();

        String sql = "SELECT * FROM banners ORDER BY id DESC";

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

                list.add(b);
            }

        } catch (Exception e) {
            e.printStackTrace();
        }

        return list;
    }


    public Banner findById(int id) {

        String sql = "SELECT * FROM banners WHERE id=?";

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

                return b;
            }

        } catch (Exception e) {
            e.printStackTrace();
        }

        return null;
    }


    public void insert(Banner banner) {

        String sql =
                "INSERT INTO banners(title, image, status) VALUES(?,?,?)";

        try (
                Connection conn = DBConnection.getConnection();
                PreparedStatement ps = conn.prepareStatement(sql)
        ) {

            ps.setString(1, banner.getTitle());
            ps.setString(2, banner.getImage());
            ps.setBoolean(3, banner.isStatus());

            ps.executeUpdate();

        } catch (Exception e) {
            e.printStackTrace();
        }
    }


    public void delete(int id) {

        String sql = "DELETE FROM banners WHERE id=?";

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


    public void updateStatus(int id, boolean status) {

        String sql =
                "UPDATE banners SET status=? WHERE id=?";

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


    public void update(Banner banner) {

        String sql =
                "UPDATE banners " +
                        "SET title=?, image=?, status=? " +
                        "WHERE id=?";

        try (
                Connection conn = DBConnection.getConnection();
                PreparedStatement ps = conn.prepareStatement(sql)
        ) {

            ps.setString(1, banner.getTitle());
            ps.setString(2, banner.getImage());
            ps.setBoolean(3, banner.isStatus());
            ps.setInt(4, banner.getId());

            ps.executeUpdate();

        } catch (Exception e) {
            e.printStackTrace();
        }
    }
}