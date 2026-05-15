package com.shop.sportstore.dao;

import com.shop.sportstore.model.Review;
import com.shop.sportstore.untils.DBConnection;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.util.ArrayList;
import java.util.List;

public class ReviewDAO {

    public void addReview(int productId,
                          int userId,
                          int rating,
                          String comment) {

        try {

            Connection conn = DBConnection.getConnection();

            String sql =
                    "INSERT INTO reviews(product_id,user_id,rating,comment) VALUES(?,?,?,?)";

            PreparedStatement ps =
                    conn.prepareStatement(sql);

            ps.setInt(1, productId);
            ps.setInt(2, userId);
            ps.setInt(3, rating);
            ps.setString(4, comment);

            ps.executeUpdate();

        } catch (Exception e) {
            e.printStackTrace();
        }
    }

    public List<Review> getReviewsByProduct(int productId) {

        List<Review> list = new ArrayList<>();

        try {

            Connection conn = DBConnection.getConnection();

            String sql =
                    "SELECT r.*, u.full_name " +
                            "FROM reviews r " +
                            "JOIN users u ON r.user_id = u.user_id " +
                            "WHERE r.product_id=? " +
                            "ORDER BY r.created_at DESC";

            PreparedStatement ps =
                    conn.prepareStatement(sql);

            ps.setInt(1, productId);

            ResultSet rs = ps.executeQuery();

            while (rs.next()) {

                Review r = new Review();

                r.setId(rs.getInt("id"));
                r.setProductId(rs.getInt("product_id"));
                r.setUserId(rs.getInt("user_id"));

                r.setRating(rs.getInt("rating"));
                r.setComment(rs.getString("comment"));

                r.setFullName(rs.getString("full_name"));

                r.setCreatedAt(rs.getTimestamp("created_at"));

                list.add(r);
            }

        } catch (Exception e) {
            e.printStackTrace();
        }

        return list;
    }
}