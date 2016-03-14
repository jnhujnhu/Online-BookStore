<%@ page import="pj.*" %>
<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%
  Connector con = (Connector)session.getAttribute("connector");
  Order ode = new Order();
  boolean result = false;
  if(request.getParameter("quantity").equals(""))
  {
    result = false;
  }
  else {
    try {
      result = ode.checkinventory(request.getParameter("ISBN"), request.getParameter("quantity"), con.stmt);
    } catch (Exception e) {
      e.printStackTrace();
    }
  }
%>
{"result":<%=result%>}