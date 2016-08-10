package pj;

import java.sql.*;

public class Connector {
	public Connection con;
	public Statement stmt;
	public Connector(){
		try {
			String userName = "root";
			String password = "5181";
			String url = "jdbc:mysql://127.0.0.1:3306/bookstore";
			Class.forName("com.mysql.jdbc.Driver").newInstance();
			con = DriverManager.getConnection(url, userName, password);
			stmt = con.createStatement();
		} catch(Exception e) {
			System.err.println("Unable to open mysql jdbc connection. The error is as follows,\n");
			System.err.println(e.getMessage());
		}
	}
	
	public void closeConnection() throws Exception{
		con.close();
	}
}
