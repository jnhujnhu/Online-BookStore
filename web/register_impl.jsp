<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ page import="pj.*" %>
<%@ page import="pj.Registration" %>
<%
  String username = request.getParameter("reg-username");
  String password = request.getParameter("reg-password");
  String fullname = request.getParameter("fullname");
  String address = request.getParameter("address");
  String phonenumber = request.getParameter("phonenumber");
  Connector con = new Connector();
  Registration reg = new Registration();
  if(username!= "" && password!="" && reg.checkln(username, con.stmt))
  {
    reg.insertaccount(username, password, fullname, address, phonenumber, con.stmt);
    session.setAttribute("username", username);
    response.sendRedirect(request.getContextPath() + "/user/");
  }
  else
  {
    session.setAttribute("username", null);
    response.sendRedirect(request.getContextPath() + "/");
  }
%>