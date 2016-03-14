<%@ page import="pj.*" %>
<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%
  Connector con = (Connector)session.getAttribute("connector");
  Book bk = new Book();
  String title = "";
  try {
    title= bk.extractbooktitle(request.getParameter("ISBN"),con.stmt);
  } catch (Exception e) {
    e.printStackTrace();
  }

%>
{"title":"<%=title%>"}