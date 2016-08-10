package pj;

import utils.Exceptions;

import java.sql.*;
import java.util.Date;

public class Order {
	public Order(){
	}
	
	public int arrangeorderid(Statement stmt) {
		int orderid = 1;
		ResultSet result;
		try {
			result = stmt.executeQuery("SELECT MAX(orderid) AS MO FROM orders_info");

			if (result.next()) {
				String k = result.getString("MO");
				if (k != null)
					orderid = Integer.parseInt(k) + 1;
			}
		} catch(Exception e) {
			System.err.println("Unable to execute.\n");
			System.err.println(e.getMessage());
		}
		return orderid;
	}


	public ResultSet printorder(int orderid, String loginname, Statement stmt) throws Exception
	{
		ResultSet result;
		try{
			result = stmt.executeQuery(String.format("select * from orders natural join books where orderid = '%d' and loginname = '%s'", orderid, loginname));
        } catch(Exception e) {
			System.err.println("Unable to execute.\n");
			System.err.println(e.getMessage());
			throw (e);
		}
		return result;
	}

	public ResultSet showallorders(String loginname, Statement stmt) throws Exception
	{
		ResultSet result;
		try{
			result = stmt.executeQuery(String.format("SELECT * FROM customers natural join orders natural join books " +
													"where loginname = '%s' order by orderid ;", loginname));
		} catch(Exception e) {
			System.err.println("Unable to execute.\n");
			System.err.println(e.getMessage());
			throw(e);
		}
		return result;
	}

	public ResultSet buyingsuggestion(int orderid, Statement stmt) throws Exception{

		String query = String.format("select *\n" +
									"from (select ISBN, sum(number) AS sn\n" +
									"\tfrom (SELECT  loginname\n" +
									"\t\tFROM orders\n" +
									"\t\twhere ISBN in (select ISBN from orders where orderid = '%s')\n" +
									"\t\t\tand loginname not in (select loginname from orders where orderid = '%s')\n" +
									"\t\tgroup by loginname) AS T,\n" +
									"\t\torders O\n" +
									"\twhere T.loginname = O.loginname\n" +
									"\t\tand O.ISBN not in (select ISBN from orders where orderid = '%s')\n" +
									"\tGroup by ISBN\n) AS tmp,\n" +
									"    books B\n" +
									"where tmp.ISBN = B.ISBN " +
									"order by tmp.sn desc;", orderid, orderid, orderid);

		ResultSet ret;
		ret = Exceptions.handleQueryExp(stmt, query, "Unable to execute.\n");
		return ret;
	}

	public boolean checkinventory(String ISBN, String quantity, Statement stmt) throws Exception{

		int number = Integer.parseInt(quantity);
		ResultSet result;
		try{
			result = stmt.executeQuery(String.format("select number_of_copies from books where ISBN = '%s'", ISBN));
		} catch(Exception e) {
			System.err.println("Unable to execute.\n");
			System.err.println(e.getMessage());
			throw(e);
		}
		while(result.next()){
			if(number>result.getInt("number_of_copies"))
			{
				return false;
			}
		}
		return true;
	}
	
	public void insertanorderinfo(int orderid, String ISBN, String loginname, int number, Statement stmt) {
		Timestamp ts = new Timestamp(new Date().getTime());

		ResultSet result;
		String check = String.format("select * from orders where orderid = '%s'", orderid);
		String insertion;
		result = Exceptions.handleQueryExp(stmt, check, "Unable to check.\n");
		try {
			if (!result.next()) {
				insertion = String.format("insert into orders_info values('%d')", orderid);
				Exceptions.handleUpdateExp(stmt, insertion, "Unable to insert.\n");
			}

			insertion = String.format("insert into orders values ('%d', '%s', '%d','%s','%s')", orderid, ts, number, loginname, ISBN);
			Exceptions.handleUpdateExp(stmt, insertion, "Unable to insert.\n");

			check = String.format("select number_of_copies from books where ISBN = '%s'", ISBN);
			result = Exceptions.handleQueryExp(stmt, check, "Unable to execute.\n");

			int ncopies = 0;
			if (result.next()) {
				ncopies = result.getInt("number_of_copies");
			}


			ncopies -= number;

			insertion = String.format("update books set number_of_copies = '%d' where ISBN = '%s' ", ncopies, ISBN);
			Exceptions.handleUpdateExp(stmt, insertion, "Unable to insert.\n");
		} catch (SQLException e) {
			e.printStackTrace();
		}
	}
}
