package pj;

import utils.Exceptions;

import java.sql.*;

public class Registration{
	public Registration() {
	}
	public boolean checkln(String loginname, Statement stmt){
		String searchq;
		ResultSet result = null;
		searchq = "select loginname from customers where loginname = '"+loginname+"'";
		try {
			result = stmt.executeQuery(searchq);
			while (result.next()) {
				if (loginname.equals(result.getString("loginname"))) {
					System.out.println("The loginname has been used, please select another loginname.\n");
					return false;
				}
			}
		} catch(Exception e) {
			System.err.println("Unable to search.\n");
			System.err.println(e.getMessage());
		}
		return true;
	}
	public void insertaccount(String loginname, String password, String fullname, String address, String phonenumber, Statement stmt){
		String insert;
		insert = "insert into customers values ('"+loginname+"','"+password+"','"+fullname+"','"+address+"','"+phonenumber+"')";
        Exceptions.handleUpdateExp(stmt, insert, "Unable to insert.\n");
	}
}
