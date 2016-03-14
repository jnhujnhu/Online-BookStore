<%@ page import="pj.*" %>
<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%
  Connector con = (Connector)session.getAttribute("connector");
  Book bk = new Book();
  int result = 0;
  boolean exist1 = false,exist2 = false;
   try {
     exist1 = bk.authorexist(request.getParameter("author1"), con.stmt);
     exist2 = bk.authorexist(request.getParameter("author2"), con.stmt);
     if (exist1 && exist2){
      result = bk.authorseparation(request.getParameter("author1"),request.getParameter("author2"), con.stmt);
     }
   } catch (Exception e) {
     e.printStackTrace();
   }

%>
{"exist1":<%=exist1%>, "exist2":<%=exist2%> ,"result":<%=result%>}