package com;

import java.sql.Connection;
import java.sql.DriverManager;
import java.sql.SQLException;

public enum ConnectionPooling {

	INSTACE;
	
	private Connection connection;

	public Connection getConnection() {
		if (connection == null) {
			instantiateConnection();
		}
		return connection;

	}

	private void instantiateConnection() {
		// TODO Auto-generated method stub
		String dbURL = "update here for db connection info";
        String strUserID = "dbusername";
        String strPassword = "dbpass";
        try {
            Class.forName("oracle.jdbc.driver.OracleDriver");
        } catch (ClassNotFoundException e) {
            System.out.println("Where is your Oracle JDBC Driver?");
            e.printStackTrace();
            return;
        }
        try {
			 connection=DriverManager.getConnection(dbURL,strUserID,strPassword);
		} catch (SQLException e) {
			// TODO Auto-generated catch block
			e.printStackTrace();
		}
	}
}
