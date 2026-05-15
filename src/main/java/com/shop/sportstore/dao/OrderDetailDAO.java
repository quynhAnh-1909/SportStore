package com.shop.sportstore.dao;

import com.shop.sportstore.model.OrderDetail;
import com.shop.sportstore.model.Product;
import com.shop.sportstore.untils.DBConnection;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.util.ArrayList;
import java.util.List;

public class OrderDetailDAO extends DBConnection {

    public List<OrderDetail> getOrderDetailsByOrderId(int orderId) {

        List<OrderDetail> list = new ArrayList<>();

        String sql =
                "SELECT od.*, " +
                        "p.name, " +
                        "p.image_url, " +
                        "p.price AS productPrice " +
                        "FROM orderdetails od " +
                        "JOIN products p ON od.ProductId = p.id " +
                        "WHERE od.OrderId = ?";

        try (
                Connection conn = getConnection();
                PreparedStatement ps = conn.prepareStatement(sql)
        ) {

            ps.setInt(1, orderId);

            ResultSet rs = ps.executeQuery();

            while (rs.next()) {

                OrderDetail od = new OrderDetail();

                od.setId(rs.getInt("Id"));

                od.setOrderId(rs.getInt("OrderId"));

                od.setProductId(rs.getInt("ProductId"));

                od.setQuantity(rs.getInt("Quantity"));

                od.setPrice(rs.getDouble("Price"));

                Product p = new Product();

                p.setId(rs.getInt("ProductId"));

                p.setName(rs.getString("name"));

                p.setImageUrl(rs.getString("image_url"));

                p.setPrice(rs.getDouble("productPrice"));

                od.setProduct(p);

                list.add(od);
            }

        } catch (Exception e) {
            e.printStackTrace();
        }

        return list;
    }
}