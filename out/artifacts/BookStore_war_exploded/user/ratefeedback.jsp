<%@ page import="pj.*" %>
<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%
  Connector con = (Connector)session.getAttribute("connector");
  Rating rt = new Rating();
  boolean result = false;
  try {
    result = rt.ratefeedback(Integer.parseInt(request.getParameter("feedbackid")),request.getParameter("loginname"),Integer.parseInt(request.getParameter("score")),con.stmt);
  } catch (Exception e) {
    e.printStackTrace();
  }
%>
{"result":<%=result%>}