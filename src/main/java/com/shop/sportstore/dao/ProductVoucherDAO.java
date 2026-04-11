package com.shop.sportstore.dao;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.util.ArrayList;
import java.util.List;

public class ProductVoucherDAO {
    private Connection conn;

    public ProductVoucherDAO(Connection conn) {
        this.conn = conn;
    }
  public void insert(int productId, int voucherId){
    try{
        String sql ="INSERT INTO product_voucher(product_id,voucher_id)  VALUES(?,?)";
        PreparedStatement ps= conn.prepareStatement(sql);
        ps.setInt(1,productId);
        ps.setInt(2,voucherId);
        ps.executeUpdate();
    }
    catch (Exception e ){
        e.printStackTrace();

    }
    }
    // XÓA hết voucher của product
    public void deleteByProduct(int productId) {
        try {
            String sql = "DELETE FROM product_voucher WHERE product_id=?";
            PreparedStatement ps = conn.prepareStatement(sql);
            ps.setInt(1, productId);
            ps.executeUpdate();
        } catch (Exception e) {
            e.printStackTrace();
        }
    }
    public List<Integer> getVoucherIdsByProduct(int productId){
        List<Integer> list= new ArrayList<>();
        try{
            String sql =" SELECT voucher_id FROM product_voucher WHERE product_id=?";
            PreparedStatement ps =  conn.prepareStatement(sql);
            ps.setInt(1,productId);

            ResultSet rs = ps.executeQuery();
            while (rs.next()){
                list.add(rs.getInt("voucher_id"));
            }
        } catch (Exception e) {
            e.printStackTrace();
        }
        return  list ;
    }

}
