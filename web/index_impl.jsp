<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ page import="pj.*" %>
<%
  String username = request.getParameter("username");
  String password = request.getParameter("password");
  String ismanager[] = request.getParameterValues("checkbox");
  Connector con = new Connector();
  Login login = new Login();
  if(ismanager == null) {
    if (login.tologin(username, password, con.stmt)) {
      session.setAttribute("username", username);
      response.sendRedirect(request.getContextPath() + "/user/");
    }
    else {
      session.setAttribute("username", null);
      response.sendRedirect(request.getContextPath() + "/");
    }
  }
  else
  {
    if (password.equals("7758258")) {
      session.setAttribute("ismanager", "true");
      response.sendRedirect(request.getContextPath() + "/manage/");
    }
    else {
      session.setAttribute("username", null);
      response.sendRedirect(request.getContextPath() + "/");
    }
  }

%>