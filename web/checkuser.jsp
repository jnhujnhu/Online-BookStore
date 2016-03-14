<%@ page import="pj.*" %>
<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%
  Connector con = (Connector)session.getAttribute("connector");
  Login login = new Login();
  boolean result;
  if(request.getParameter("ismanager").equals("true"))
  {
    result = true;
  }
  else{
    result = login.checkln(request.getParameter("username"), con.stmt);
  }
%>
{"result":<%=result%>}