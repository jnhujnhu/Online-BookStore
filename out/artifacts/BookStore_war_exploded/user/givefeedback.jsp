<%@ page import="pj.*" %>
<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%
  Connector con = (Connector)session.getAttribute("connector");
  Feedback fd = new Feedback();
  boolean result = false;
  try {
    String comment = fd.checkString(request.getParameter("comment"));
    result = fd.insertafeedback(request.getParameter("username"),request.getParameter("ISBN"), Integer.parseInt(request.getParameter("score")), comment, con.stmt);
  } catch (Exception e) {
    e.printStackTrace();
  }

%>
{"result":<%=result%>}