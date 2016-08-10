package pj;

import java.sql.*;
import java.util.Date;
import java.text.SimpleDateFormat;

public class Book{
	public Book() {
	}
	
	public boolean querychecker(String query) throws Exception{
		int l = query.length();
		boolean eqe = false;
		for(int i=0;i<l;i++)
		{
			if(query.charAt(i)=='=')
			{
				int endp = i-1;
				boolean Flag = false;
				while (query.charAt(endp)==' ') endp--;
				int starp = endp;
				while(starp>=0&&query.charAt(starp)!=' ') starp--;
				starp++;
				String argus = query.substring(starp, endp+1);
				String [] candidate = {"authorname","title","ISBN","publisher","price","format","subjectname","year_of_publication","keywords"};
				
				for(int k=0;k<8;k++)
				{
					if(argus.equals(candidate[k]))
					{
						Flag = true;
						break;
					}
				}
				if(!Flag) return false;
				eqe = true;
			}
		}
		if(!eqe) return false;
		else	return true;
	}


	public String pretreat(String query) throws Exception {

		query = query.replaceAll("author", "authorname");
		query = query.replaceAll("authornamename", "authorname");

		query = query.replaceAll("year", "year_of_publication");
		query = query.replaceAll("year_of_publication_of_publication", "year_of_publication");

		query = query.replaceAll("subject", "subjectname");
		query = query.replaceAll("subjectnamename", "subjectname");
		return query;
	}

	public ResultSet bookbrowsering(String loginname, String query, int sortmethod, Statement stmt) throws Exception{

		query = checkString(query);

		String sortm;
		if(sortmethod == 1) sortm = "T1.year_of_publication";
		else if(sortmethod == 2 || loginname == "manager") sortm = "T1.AG";
		else sortm = "T1.AG2";
		
		int l = query.length(), temp=0;
		String rquery = query;
		for(int i=0;i<l;i++)
		{
			if(query.charAt(i)=='=')
			{
				i++;
				while(i<l&&query.charAt(i)==' ') i++;
				i--;
				rquery = rquery.substring(0, i+temp+1) + "'%"+query.substring(i+1, l);
				temp+=2;
				while (i<=l-4&&(!(query.charAt(i)==' '&&((query.substring(i+1,i+4).equals("and"))||query.substring(i+1,i+3).equals("or")))))
				{
					i++;
				}
				while(query.charAt(i)==' ') i--;

				i++;
				if(i<l-4){
					rquery = rquery.substring(0, i+temp) + "%'"+query.substring(i, l);
					temp+=2;
				}
			}
		}
		rquery = rquery + "%'";
		rquery = rquery.replaceAll("=", " like ");

		String que;
		que = String.format("select T1.ISBN, T1.title, T1.price, T1.keywords, T1.format, T1.publisher, T1.year_of_publication,group_concat(T2.authorname) AS GC,T1.AG,T1.AG2\n" +
				"\tfrom\n" +
				"\t(select B.ISBN, title, price, keywords, format, publisher, year_of_publication,tmp1.AG,tmp2.AG2 \n" +
				"\tfrom books B natural join written_by natural join\n" +
				"\tbelong_to natural join authors left outer join\n" +
				"\t\t(select ISBN, AVG(score)AS AG\n" +
				"\t\tfrom feedbacks\n" +
				"\t\tgroup by ISBN\n" +
				"\t\t) AS tmp1 on B.ISBN = tmp1.ISBN left outer join\n" +
				"\t\t(select ISBN, AVG(score) AS AG2\n" +
				"\t\tfrom feedbacks\n" +
				"\t\twhere loginname in (select customer_ln2 from usersrating where customer_ln1 = '%s' and rating = '1')\n" +
				"\t\tgroup by ISBN) AS tmp2 on B.ISBN = tmp2.ISBN\n" +
				"\twhere\t%s\n" +
				"\tgroup by B.ISBN\n" +
				"\t) AS T1,\n" +
				"    (select * from written_by natural join books) AS T2\n" +
				"where T1.ISBN = T2.ISBN\n" +
				"group by ISBN\n" +
				"order by %s desc;", loginname, rquery, sortm);
		ResultSet result;
		try{
			result = stmt.executeQuery(que);
        } catch(Exception e) {
			System.err.println("Unable to execute.\n");
			System.err.println(e.getMessage());
			throw(e);
		}
		return result;
	}

	public ResultSet showallbooks(Statement stmt) throws Exception{
		String query = "select * from(SELECT ISBN,title,group_concat(authorname) AS GC," +
				"publisher,keywords,price,year_of_publication FROM written_by natural join books group by ISBN) AS T";
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

	public ResultSet showbooks(String ISBN,Statement stmt) throws Exception{
		String query = String.format("select * from\n" +
				"(SELECT ISBN,title,group_concat(authorname) AS GC,publisher,keywords,price,year_of_publication,format,number_of_copies \n" +
				"FROM written_by natural join books group by ISBN) AS tmp1,\n" +
				"(SELECT ISBN,title,group_concat(subjectname) AS GS,publisher,keywords,price,year_of_publication,format,number_of_copies \n" +
				"FROM belong_to natural join books group by ISBN) AS tmp2\n" +
				"where tmp1.ISBN = tmp2.ISBN and tmp1.ISBN = '%s';\n" ,ISBN);
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
	public boolean authorexist(String authorname, Statement stmt) throws Exception{
		authorname = checkString(authorname);
		String query = String.format("select authorname from authors where authorname = '%s'",authorname);
		ResultSet result;
		try{
			result = stmt.executeQuery(query);
		} catch(Exception e) {
			System.err.println("Unable to execute.\n");
			System.err.println(e.getMessage());
			throw(e);
		}
		if(result.next()) {
			return true;
		}
		else{
			return false;
		}
	}

	public int authorseparation(String author1, String author2, Statement stmt) throws Exception{

		author1 = checkString(author1);
		author2 = checkString(author2);
		String query = String.format("select authorname " +
									"from written_by " +
									"where ISBN in (SELECT ISBN FROM fudandbd10.written_by where authorname = '%s')" +
									"and authorname = '%s'", author1, author2);
		ResultSet result;
		try{
			result = stmt.executeQuery(query);
		} catch(Exception e) {
			System.err.println("Unable to execute.\n");
			System.err.println(e.getMessage());
			throw(e);
		}
		if(result.next())
		{
			return 1;
		}
		else
		{
			query = String.format("select T1.authorname " +
					 			"from(select authorname from written_by where ISBN in (SELECT ISBN FROM written_by where authorname = '%s'))AS T1, " +
					               " (select authorname from written_by where ISBN in (SELECT ISBN FROM written_by where authorname = '%s'))AS T2 " +
								"where T1.authorname = T2.authorname;", author1, author2);
			try{
				result = stmt.executeQuery(query);
			} catch(Exception e) {
				System.err.println("Unable to execute.\n");
				System.err.println(e.getMessage());
				throw(e);
			}

			if(result.next())
			{
				return 2;
			}
			else return 0;
		}
	}
	public String[] maketime() throws Exception{
		SimpleDateFormat sdf = new SimpleDateFormat("yyyy");
		int year = Integer.parseInt(sdf.format(new Date()));
		SimpleDateFormat sdm = new SimpleDateFormat("MM");
		int month = Integer.parseInt(sdm.format(new Date()));
		String dates, datee;
		if(month >9)
		{
			dates = String.format("%d-%d-1", year, 9);
			datee = String.format("%d-%d-1", year+1, 3);
		}
		else if(month<3)
		{
			dates = String.format("%d-%d-1", year-1, 9);
			datee = String.format("%d-%d-1", year, 3);
		}
		else
		{
			dates = String.format("%d-%d-1", year, 3);
			datee = String.format("%d-%d-1", year, 9);
		}
		String [] time;
		time = new String[2];
		time[0]=dates;
		time[1]=datee;
		return time;
	}
	public ResultSet popularitystabooks(Statement stmt) throws Exception {
		SimpleDateFormat sdf = new SimpleDateFormat("yyyy");
		int year = Integer.parseInt(sdf.format(new Date()));
		SimpleDateFormat sdm = new SimpleDateFormat("MM");
		int month = Integer.parseInt(sdm.format(new Date()));
		String dates, datee;
		if(month >9)
		{
			dates = String.format("%d-%d-1", year, 9);
			datee = String.format("%d-%d-1", year+1, 3);
		}
		else if(month<3)
		{
			dates = String.format("%d-%d-1", year-1, 9);
			datee = String.format("%d-%d-1", year, 3);
		}
		else
		{
			dates = String.format("%d-%d-1", year, 3);
			datee = String.format("%d-%d-1", year, 9);
		}
		String query = String.format("select *\n" +
				"from (select ISBN, sum(number) AS sn \n" +
				"\t\tfrom orders\n" +
				"\t\twhere date>'%s'\n" +
				"\t\t\tand date<'%s'\n" +
				"\t\tgroup by ISBN)AS T,\n" +
				"        books B\n" +
				"where B.ISBN = T.ISBN\n" +
				"order by T.sn desc;", dates, datee);
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

	public ResultSet popularitystaauthors(Statement stmt) throws Exception {
		SimpleDateFormat sdf = new SimpleDateFormat("yyyy");
		int year = Integer.parseInt(sdf.format(new Date()));
		SimpleDateFormat sdm = new SimpleDateFormat("MM");
		int month = Integer.parseInt(sdm.format(new Date()));
		String dates, datee;
		if(month >9)
		{
			dates = String.format("%d-%d-1", year, 9);
			datee = String.format("%d-%d-1", year+1, 3);
		}
		else if(month<3)
		{
			dates = String.format("%d-%d-1", year-1, 9);
			datee = String.format("%d-%d-1", year, 3);
		}
		else
		{
			dates = String.format("%d-%d-1", year, 3);
			datee = String.format("%d-%d-1", year, 9);
		}
		String query = String.format("select sum(T.sn) AS st, authorname\n" +
				"from (select ISBN, sum(number) AS sn \n" +
				"\t\tfrom orders\n" +
				"\t\twhere date>'%s'\n" +
				"\t\t\tand date<'%s'\n" +
				"\t\tgroup by ISBN)AS T natural join\n" +
				"        books B natural join written_by W\n" +
				"group by authorname\n" +
				"order by st desc;", dates, datee);
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

	public ResultSet popularitystapublishers(Statement stmt) throws Exception {
		SimpleDateFormat sdf = new SimpleDateFormat("yyyy");
		int year = Integer.parseInt(sdf.format(new Date()));
		SimpleDateFormat sdm = new SimpleDateFormat("MM");
		int month = Integer.parseInt(sdm.format(new Date()));
		String dates, datee;
		if(month >9)
		{
			dates = String.format("%d-%d-1", year, 9);
			datee = String.format("%d-%d-1", year+1, 3);
		}
		else if(month<3)
		{
			dates = String.format("%d-%d-1", year-1, 9);
			datee = String.format("%d-%d-1", year, 3);
		}
		else
		{
			dates = String.format("%d-%d-1", year, 3);
			datee = String.format("%d-%d-1", year, 9);
		}
		String query = String.format("select sum(T.sn) AS st, publisher\n" +
				"from (select ISBN, sum(number) AS sn \n" +
				"\t\tfrom orders\n" +
				"\t\twhere date>'%s'\n" +
				"\t\t\tand date<'%s'\n" +
				"\t\tgroup by ISBN)AS T natural join\n" +
				"        books B \n" +
				"group by publisher\n" +
				"order by st desc;", dates, datee);
		ResultSet result;
		try{
			result = stmt.executeQuery(query);
		} catch(Exception e) {
			System.err.println("Unable to execute.\n");
			System.err.println(e.getMessage());
			throw (e);
		}
		return result;
	}

	
	public boolean checkExist(String ISBN, Statement stmt) throws Exception{
		String searchq;
		ResultSet result;
		searchq = "select ISBN from books where ISBN = '"+ISBN+"'";
		try{
			result = stmt.executeQuery(searchq);
        } catch(Exception e) {
			System.err.println("Unable to execute.\n");
	                System.err.println(e.getMessage());
			throw(e);
		}
		
		while(result.next())
		{
			if(ISBN. equals(result.getString("ISBN")))
			{
				return true;
			}
		}
		System.out.println("ISBN not exist!");
		return false;
	}

	public String extractbooktitle(String ISBN, Statement stmt) throws Exception {
		String searchq;
		ResultSet result;
		searchq = "select * from books where ISBN = '" + ISBN + "'";
		try {
			result = stmt.executeQuery(searchq);
		} catch (Exception e) {
			System.err.println("Unable to execute.\n");
			System.err.println(e.getMessage());
			throw (e);
		}
		if (result.next()){
			return result.getString("title");
		}
		else
		{
			return "";
		}
	}
	public String checkString(String s) throws Exception{
		s = s.replaceAll("\'","\\\\'");
		s = s.replaceAll("\"","\\\\\"");
		return s;
	}
	public void insertabook(String ISBN, String title, Float price, String format, String publisher, String keywords
			, int year_of_publication, int number_of_copies, int nofa, String[] authors, int nofsb, String[] subjects, Statement stmt) throws Exception{
		String insert;
		title = checkString(title);
		publisher = checkString(publisher);
		keywords = checkString(keywords);
		for(int i=0;i<nofa;i++)
			authors[i] = checkString(authors[i]);
		for(int i=0;i<nofsb;i++)
			subjects[i] = checkString(subjects[i]);
		insert = String.format("insert into books values ('%s', '%s', '%f', '%s', '%s', '%s', '%d', '%d')"
				, ISBN, title, price, format, publisher, keywords, year_of_publication, number_of_copies);
		try{
			stmt.executeUpdate(insert);
        } catch(Exception e) {
			System.err.println("Unable to insert.\n");
			System.err.println(e.getMessage());
			throw(e);
		}
		
		for(int i=0; i<nofa;i++){
			
			String check = String.format("select * from authors where authorname = '%s'", authors[i]);
			ResultSet result;
			try{
				result = stmt.executeQuery(check);
	        } catch(Exception e) {
				System.err.println("Unable to check.\n");
				System.err.println(e.getMessage());
				throw(e);
			}
			
			if(!result.next()){
					insert = String.format("insert into authors values ('%s')", authors[i]);
					try{
						stmt.executeUpdate(insert);
			        } catch(Exception e) {
						System.err.println("Unable to insert.\n");
				                System.err.println(e.getMessage());
						throw(e);
					}
				
			}
			
			insert = String.format("insert into written_by values ('%s', '%s')", authors[i], ISBN);
			try{
				stmt.executeUpdate(insert);
	        } catch(Exception e) {
				System.err.println("Unable to insert.\n");
				System.err.println(e.getMessage());
				throw(e);
			}
		}
		
		for(int i=0; i<nofsb;i++){
			
			String check = String.format("select * from subjects where subjectname = '%s'", subjects[i]);
			ResultSet result;
			try{
				result = stmt.executeQuery(check);
	        } catch(Exception e) {
				System.err.println("Unable to check.\n");
				System.err.println(e.getMessage());
				throw(e);
			}
			if(!result.next()){
				
					insert = String.format("insert into subjects values ('%s')", subjects[i]);
					try{
						stmt.executeUpdate(insert);
			        } catch(Exception e) {
						System.err.println("Unable to insert.\n");
						System.err.println(e.getMessage());
						throw(e);
					}
				
			}
			
			insert = String.format("insert into belong_to values ('%s', '%s')", subjects[i], ISBN);
			try{
				stmt.executeUpdate(insert);
	        } catch(Exception e) {
				System.err.println("Unable to insert.\n");
				System.err.println(e.getMessage());
				throw(e);
			}
		}
	}
	
	public void increaseinventory(String ISBN, int copies, Statement stmt) throws Exception{
		
		int Old_inventory = 0;
		ResultSet result;
		String query = "select number_of_copies from books where ISBN = '"+ISBN+"'";
		try{
			result = stmt.executeQuery(query);
        } catch(Exception e) {
			System.err.println("Unable to execute!");
			System.err.println(e.getMessage());
			throw (e);
		}
		while(result.next())
		{
			Old_inventory = result.getInt("number_of_copies");
		}
		String update;
		update = String.format("update books set number_of_copies = %d where ISBN = '%s'", Old_inventory + copies, ISBN);
		try{
			stmt.executeUpdate(update);
        } catch(Exception e) {
			System.err.println("Unable to update.\n");
			System.err.println(e.getMessage());
			throw (e);
		}
	}
}
