package com.shop.sportstore.untils;

import java.sql.Connection;
import java.sql.DriverManager;

public class DBConnection {
    public static Connection getConnection() {
        try {
            Class.forName("com.mysql.cj.jdbc.Driver");
            String url = "jdbc:mysql://mysql8:3306/sportstore?useSSL=false&allowPublicKeyRetrieval=true&serverTimezone=UTC";
            String user = "root";
            String password = "123456";


            Connection conn = DriverManager.getConnection(url, user, password);
            System.out.println("Kết nối thành công!");
            return conn;

        } catch (Exception e) {
            e.printStackTrace();
            return null;
        }
    }

}