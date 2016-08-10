package pj;


import utils.Exceptions;

import java.sql.*;

public class Rating {
	public Rating(){
	}
	
	public boolean rateotheruser(String customer_ln1, String customer_ln2, int istrusted, Statement stmt){
		
		if(customer_ln1.equals(customer_ln2))
		{
			return false;
		}
		
		String check = String.format("select * from usersrating where customer_ln1 = '%s' and customer_ln2 = '%s'", customer_ln1, customer_ln2);
		ResultSet result;

		result = Exceptions.handleQueryExp(stmt, check, "Unable to execute.\n");
		try {
			if (result.next()) {
				if (result.getString("customer_ln1") != null) {
					String update = String.format("update usersrating set rating = '%d' where customer_ln1 = '%s' and customer_ln2 =  '%s'", istrusted, customer_ln1, customer_ln2);
					Exceptions.handleUpdateExp(stmt, update, "Unable to update.\n");
				}
			} else {
				String insert = String.format("insert into usersrating values('%s', '%s', '%d')", customer_ln1, customer_ln2, istrusted);
				Exceptions.handleUpdateExp(stmt, insert, "Unable to insert.\n");
			}
		} catch (SQLException e) {
			e.printStackTrace();
		}
		return true;
	}

	public ResultSet toptrusteduser(Statement stmt) throws Exception{
		String query = "SELECT tmp1.loginname, (tmp1.ic-tmp2.ic) AS score\n" +
				"FROM (SELECT loginname, ifnull(c, 0) AS ic\n" +
				"\tFROM (SELECT count(*) AS c, customer_ln2\n" +
				"\t\t\tFROM usersrating\n" +
				"\t\t\tWHERE rating = 1\n" +
				"\t\t\tGROUP BY customer_ln2) AS T right outer join customers C on C.loginname = T.customer_ln2\n" +
				"\tgroup by loginname) AS tmp1,\n" +
				"\t(SELECT loginname, ifnull(c, 0) AS ic\n" +
				"\tFROM (SELECT count(*) AS c, customer_ln2\n" +
				"\t\t\tFROM usersrating\n" +
				"\t\t\tWHERE rating = 0\n" +
				"\t\t\tGROUP BY customer_ln2) AS T right outer join customers C on C.loginname = T.customer_ln2\n" +
				"\tgroup by loginname) AS tmp2\n" +
				"where tmp1.loginname = tmp2.loginname\n" +
				"order by score desc";
		ResultSet result;
		result = Exceptions.handleQueryExp(stmt, query, "Unable to execute.\n");
		return result;
	}

	public ResultSet topusefuluser(Statement stmt) throws Exception {
		String query = "SELECT C.loginname, IFNULL(AVG(FR.score),0) AS AF\n" +
				"FROM customers C left outer join feedbacks F on C.loginname = F.loginname\n" +
				"\t\tleft outer join feedbacksrating FR on FR.feedbackid = F.feedbackid\n" +
				"GROUP BY C.loginname\n" +
				"ORDER BY AF desc;";
		ResultSet result;
		result = Exceptions.handleQueryExp(stmt, query, "Unable to execute.\n");
		return result;
	}

	public boolean ratefeedback(int feedbackid, String loginname, int score, Statement stmt){
		
		String check = String.format("select * from feedbacks where feedbackid = '%d'", feedbackid);
		ResultSet result;

		result = Exceptions.handleQueryExp(stmt, check, "Unable to execute.\n");
		try {
			if (result.next()) {
				if (result.getString("loginname").equals(loginname)) {
					return false;
				}
			} else {
				return false;
			}

			check = String.format("select * from feedbacksrating where feedbackid = '%d' and loginname = '%s'", feedbackid, loginname);
			result = Exceptions.handleQueryExp(stmt, check, "Unable to execute.\n");
			if (result.next()) {
				if (result.getString("feedbackid") != null) {
					String update = String.format("update feedbacksrating set score = '%d' where feedbackid = '%d' and loginname = '%s'", score, feedbackid, loginname);
					Exceptions.handleUpdateExp(stmt, update, "Unable to update.\n");
				}
			} else {
				String insert = String.format("insert into feedbacksrating values('%d','%s','%d')", feedbackid, loginname, score);
				Exceptions.handleUpdateExp(stmt, insert, "Unable to insert.\n");
			}
		} catch (SQLException e) {
			e.printStackTrace();
		}
		return true;
	}
	
}
