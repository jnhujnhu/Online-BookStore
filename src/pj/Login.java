package pj;

import java.sql.*;

public class Login {
	public Login()
	{}
	public boolean checkln(String loginname, Statement stmt) throws Exception{
		String searchq;
		ResultSet result;
		searchq = "select loginname from customers where loginname = '"+loginname+"'";
		try{
			result = stmt.executeQuery(searchq);
        } catch(Exception e) {
			System.err.println("Unable to execute!");
	                System.err.println(e.getMessage());
			throw(e);
		}
		
		while(result.next())
		{
			if(loginname. equals(result.getString("loginname")))
			{
				return true;
			}
		}
		return false;
	}
	public boolean tologin(String loginname, String password, Statement stmt) throws Exception{
		String query;
		ResultSet results; 
		query="Select password from customers where loginname='"+loginname+"'";
		try{
			results = stmt.executeQuery(query);
        } catch(Exception e) {
			System.err.println("Unable to execute!\n");
	                System.err.println(e.getMessage());
			throw(e);
		}
		while(results.next()){
			if(!password.equals(results.getString("password")))
			{
				return false;
			}
			else
			{
				return true;
			}
		}
		return false;
	}
}
