<%--
  Created by IntelliJ IDEA.
  User: Kevin
  Date: 6/28/15
  Time: 1:25 PM
  To change this template use File | Settings | File Templates.
--%>
<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%
  if (session.getAttribute("username") == null) {
    response.sendRedirect(request.getContextPath() + "/");
  }
  String username = (String)session.getAttribute("username");
%>
<html>
<head>
  <title>Kevin's Book Store</title>
  <script src="../js/jquery-2.1.4.min.js"></script>
  <script src="../js/bootstrap.min.js"></script>
  <link href="../css/bootstrap.min.css" rel="stylesheet">
  <link href="../css/bookpage.css" rel="stylesheet">
  <link href="../css/formstyle.css" rel="stylesheet">
  <link href="../css/indexpage.css" rel="stylesheet">
</head>
<body>
<%@include file="navibar.jsp"%>
<div>
  <div class="user-interface-title" style="margin-left: 200px">ABOUT</div>
  <hr style="width: 1000px">
  <div style="margin-left: 300px">
    <div><label>Author:&nbsp;</label> Zhou Kaiwen</div>
    <div><label>Email:&nbsp;</label> 13307130228@fudan.edu.cn</div>
    <div><label>Verson:&nbsp;</label> 1.0.1</div>
  </div>
</div>
</body>
</html>
