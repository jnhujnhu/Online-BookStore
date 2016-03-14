<%@ page import="pj.*" %>
<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%
  Connector con = (Connector)session.getAttribute("connector");
  Login login = new Login();
  boolean result;

  if(request.getParameter("ismanager").equals("true"))
  {
    if(request.getParameter("password").equals("7758258"))
    {
      result = true;
    }
    else
    {
      result = false;
    }
  }
  else{
    result = login.tologin(request.getParameter("username"),request.getParameter("password"), con.stmt);
  }
%>
{"result":<%=result%>}