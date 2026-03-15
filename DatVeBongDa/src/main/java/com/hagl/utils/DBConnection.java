package com.hagl.utils;

import java.sql.Connection;

import javax.activation.DataSource;
import javax.naming.Context;
import javax.naming.InitialContext;

public class DBConnection {
	  public static Connection getConnection() {

	        Connection conn = null;

	        try {

	            Context initContext = new InitialContext();

	            Context envContext =
	                    (Context) initContext.lookup("java:comp/env");

	            DataSource ds =
	                    (DataSource) envContext.lookup("jdbc/sportshop");

	            conn = ((DBConnection) ds).getConnection();

	        } catch (Exception e) {
	            e.printStackTrace();
	        }

	        return conn;
	    }
}
