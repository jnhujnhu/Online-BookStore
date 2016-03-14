<%@ page import="pj.*" %>
<%--
  Created by IntelliJ IDEA.
  User: Kevin
  Date: 6/10/15
  Time: 7:22 PM
  To change this template use File | Settings | File Templates.
--%>
<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%
  if (session.getAttribute("connector") != null) {
    ((Connector)session.getAttribute("connector")).closeConnection();
  }
  Connector connector = new Connector();
  session.setAttribute("connector", connector);
  if (session.getAttribute("username") != null) {
    response.sendRedirect(request.getContextPath() + "/user/");
  }
  else if (session.getAttribute("ismanager") !=null) {
    response.sendRedirect(request.getContextPath() + "/manage/");
  }
%>
<html>
  <head>
    <title>Kevin's Book Store</title>
    <script src="js/jquery-2.1.4.min.js"></script>
    <script src="js/bootstrap.min.js"></script>
    <link href="css/bootstrap.min.css" rel="stylesheet">
    <link href="css/indexpage.css" rel="stylesheet">
    <link href="css/formstyle.css" rel="stylesheet">

    <script>
      var f= true;
      $(document).ready(function() {
        setTimeout(function() {
          $(".welcome-instruction").fadeIn(300);
        } ,700);
      });
    </script>

  </head>
  <body>
    <%@include file="navibar.jsp"%>
    <div class="body-container">
      <div class="title">
        <img src="img/background.jpg" width="1440px" height="900px" class="img-background" />
        <div class="body-bottom">
          <label class="bottom-instruction">Copyright@2008-2015  Kevin  沪ICP备2333333号</label>
        </div>
        <div style="text-align: center;">
          <label class="welcome-instruction">Welcome to BookStore!</label>
        </div>
      </div>
      <%@include file="login.jsp"%>
      <%@include file="register.jsp"%>
    </div>
  </body>
</html>
