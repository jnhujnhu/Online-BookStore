<%@ page import="pj.*" %>
<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%
  Connector con = (Connector)session.getAttribute("connector");
  Rating rt = new Rating();
  boolean result = false;
  try {
    result = rt.rateotheruser(request.getParameter("username"),request.getParameter("feedbackuser"),Integer.parseInt(request.getParameter("istrust")),con.stmt);
  } catch (Exception e) {
    e.printStackTrace();
  }
%>
{"result":<%=result%>}