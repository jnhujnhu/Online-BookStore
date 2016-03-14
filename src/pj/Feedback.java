package pj;

import java.sql.*;
import java.util.Date;

public class Feedback {
	public Feedback(){
	}

	public String checkString(String s) throws Exception{
		s = s.replaceAll("\'","\\\\'");
		s = s.replaceAll("\"","\\\\\"");
		return s;
	}

	public ResultSet topnusefulfeedbacks(String ISBN, Statement stmt) throws Exception {

		String query = String.format("select * " +
									"from(SELECT optional_text, B.feedbackid, B.loginname, B.score, date,AVG(A.score) as AA " +
									"FROM feedbacksrating A,feedbacks B " +
									"where A.feedbackid = B.feedbackid " +
									"and B.ISBN = '%s' " +
									"group by A.feedbackid) AS T " +
									"order by T.AA desc", ISBN);
		ResultSet result;
		try{
			result = stmt.executeQuery(query);
		} catch(Exception e) {
			System.err.println("Unable to execute.\n");
			System.err.println(e.getMessage());
			throw(e);
		}
		return result;
	}
	public ResultSet showallfeedbacks(String ISBN, Statement stmt) throws Exception {

		String query = String.format("select * from feedbacks where ISBN = '%s'", ISBN);
		ResultSet result;
		try{
			result = stmt.executeQuery(query);
		} catch(Exception e) {
			System.err.println("Unable to execute.\n");
			System.err.println(e.getMessage());
			throw(e);
		}
		return result;
	}
	public boolean insertafeedback(String loginname ,String ISBN, int score, String optional_text, Statement stmt) throws Exception
	{
		Book bk = new Book();
		if(!bk.checkExist(ISBN, stmt))
		{
			return false;
		}
		
		Timestamp ts = new Timestamp(new Date().getTime());
		int feedbackid = 1;
		ResultSet result;
		try{
			result = stmt.executeQuery("select MAX(feedbackid) AS MF from feedbacks");
        } catch(Exception e) {
			System.err.println("Unable to execute.\n");
	                System.err.println(e.getMessage());
			throw(e);
		}
		if(result.next())
		{
			String k = result.getString("MF");
			if(k!=null)
				feedbackid = Integer.parseInt(k) + 1;
		}
		
		try{
			result = stmt.executeQuery(String.format("select * from feedbacks where ISBN = '%s' and loginname = '%s'", ISBN, loginname ));
        } catch(Exception e) {
			System.err.println("Unable to execute.\n");
	                System.err.println(e.getMessage());
			throw(e);
		}
		if(!result.next())
		{
			try{
				stmt.executeUpdate(String.format("insert into feedbacks values('%d' ,'%s', '%s', '%d' ,'%s', '%s')",feedbackid , loginname, ISBN, score, ts, optional_text ));
	        } catch(Exception e) {
				System.err.println("Unable to execute.\n");
		                System.err.println(e.getMessage());
				throw(e);
			}
			return true;
		}
		else
		{
			return false;
		}
	}
}
