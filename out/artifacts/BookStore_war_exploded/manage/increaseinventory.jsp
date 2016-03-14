<%@ page import="pj.*" %>
<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%
  Connector con = new Connector();
  Book bk = new Book();

  try {
    bk.increaseinventory(request.getParameter("ISBN"), Integer.parseInt(request.getParameter("number")),con.stmt);
  } catch (Exception e) {
    e.printStackTrace();
  }
%>