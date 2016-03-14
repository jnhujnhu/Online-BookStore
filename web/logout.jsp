<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%
  session.setAttribute("username", null);
  session.setAttribute("ismanager", null);
  response.sendRedirect(request.getContextPath() + "/");
%>