package com.shop.sportstore.dao;

import com.shop.sportstore.model.Promotion;
import com.shop.sportstore.untils.DBConnection;
import java.sql.Connection;

import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.util.ArrayList;
import java.util.List;

public class PromotionDAO {

    public List<Promotion> getAllPromotions() {

        List<Promotion> list = new ArrayList<>();

        try {

            Connection conn = DBConnection.getConnection();

            String sql =
                    "SELECT * FROM promotions ORDER BY start_date DESC";

            PreparedStatement ps =
                    conn.prepareStatement(sql);

            ResultSet rs = ps.executeQuery();

            while (rs.next()) {

                Promotion p = new Promotion();

                p.setId(rs.getInt("id"));

                p.setTitle(rs.getString("title"));

                p.setThumbnail(rs.getString("thumbnail"));

                p.setContent(rs.getString("content"));

                p.setDiscountPercent(
                        rs.getInt("discount_percent")
                );

                p.setStartDate(rs.getDate("start_date"));

                p.setEndDate(rs.getDate("end_date"));

                list.add(p);
            }

        } catch (Exception e) {
            e.printStackTrace();
        }

        return list;
    }
}
