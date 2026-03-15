package com.hagl.dao;

import javax.sql.DataSource;
import javax.naming.*;
import java.sql.Connection;
import java.sql.SQLException;

public class BaseDAO {

    protected DataSource dataSource;
    private static final String JNDI_NAME = "java:/comp/env/jdbc/FootballDB";

    public BaseDAO() {
        try {

            Context initContext = new InitialContext();
            dataSource = (DataSource) initContext.lookup(JNDI_NAME);

            if (dataSource == null) {
                throw new RuntimeException("Không tìm thấy DataSource: " + JNDI_NAME);
            }

        } catch (NamingException e) {
            e.printStackTrace();
            throw new RuntimeException("Lỗi cấu hình JNDI.", e);
        }
    }

    /** DAO con gọi để lấy connection */
    protected Connection getConnection() throws SQLException {
        return dataSource.getConnection();
    }
}