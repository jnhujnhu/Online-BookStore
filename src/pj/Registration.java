package pj;

import java.sql.*;

public class Registration{
	public Registration() {
	}
	public boolean checkln(String loginname, Statement stmt) throws Exception{
		String searchq;
		ResultSet result;
		searchq = "select loginname from customers where loginname = '"+loginname+"'";
		try{
			result = stmt.executeQuery(searchq);
        } catch(Exception e) {
			System.err.println("Unable to search.\n");
	                System.err.println(e.getMessage());
			throw(e);
		}
		
		while(result.next())
		{
			if(loginname. equals(result.getString("loginname")))
			{
				System.out.println("The loginname has been used, please select another loginname.\n");
				return false;
			}
		}
		return true;
	}
	public void insertaccount(String loginname, String password, String fullname, String address, String phonenumber, Statement stmt) throws Exception{
		String insert;
		insert = "insert into customers values ('"+loginname+"','"+password+"','"+fullname+"','"+address+"','"+phonenumber+"')";
		try{
			stmt.executeUpdate(insert);
        } catch(Exception e) {
			System.err.println("Unable to insert.\n");
	                System.err.println(e.getMessage());
			throw(e);
		}
	}
}
