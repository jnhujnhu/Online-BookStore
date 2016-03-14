<%@ page import="pj.*" %>
<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%
  Connector con = new Connector();
  Order ode = new Order();
  String orderid = "";
  if(request.getParameter("isfirstorder").equals("true"))
  {
    try {
      orderid = String.format("%d", ode.arrangeorderid(con.stmt));
    } catch (Exception e) {e.printStackTrace();}
    session.setAttribute("orderid",orderid);
  }
  else
  {
    orderid = request.getParameter("orderid");
  }
  try {
    ode.insertanorderinfo(Integer.parseInt(orderid),request.getParameter("ISBN"),(String)session.getAttribute("username"),Integer.parseInt(request.getParameter("quantity")),con.stmt);
  } catch (Exception e) {
    e.printStackTrace();
  }
%>
{"orderid":"<%=orderid%>"}