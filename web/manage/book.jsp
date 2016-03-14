<%@ page import="pj.*" %>
<%@ page import="java.sql.ResultSet" %>
<%--
  Created by IntelliJ IDEA.
  User: Kevin
  Date: 6/10/15
  Time: 7:22 PM
  To change this template use File | Settings | File Templates.
--%>
<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%
  if (session.getAttribute("ismanager") == null) {
    response.sendRedirect(request.getContextPath() + "/");
  }
  Connector connector = new Connector();
  Book bk = new Book();

  String ISBN = request.getParameter("ISBN");
  ResultSet result = null;
  try {
    result = bk.showbooks(ISBN, connector.stmt);
  } catch (Exception e) {
    e.printStackTrace();
  }
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
  <script>
    $(document).ready(function() {
      setTimeout(function() {
        $(".bookinfo-table").slideDown(300);
      },300);
    });
  </script>
</head>
<body>
<%@include file="navibar.jsp"%>
<%  try {
  while(result.next()){
%>
<div class="bookinfo-container">
  <div class="bookinfo-title"><%=result.getString("title")%></div>
  <hr class="bookinfo-divider">
  <div class="bookinfo-table">
    <div class="bookinfo-row">
      <label class="bookinfo-tag">ISBN:</label>
      <label class="bookinfo-info">&nbsp;<%=result.getString("ISBN")%></label>
    </div>
    <div class="bookinfo-row">
      <label class="bookinfo-tag">Author:</label>
      <label class="bookinfo-info">&nbsp;<%=result.getString("GC")%></label>
    </div>
    <div class="bookinfo-row">
      <label class="bookinfo-tag">Publisher:</label>
      <label class="bookinfo-info">&nbsp;<%=result.getString("publisher")%></label>
    </div>
    <div class="bookinfo-row">
      <label class="bookinfo-tag">Number of inventory:</label>
      <label class="bookinfo-info">&nbsp;<%=result.getString("number_of_copies")%></label>
    </div>
    <div class="bookinfo-row">
      <label class="bookinfo-tag">Format:</label>
      <label class="bookinfo-info">&nbsp;<%=result.getString("format")%></label>
    </div>
    <div class="bookinfo-row">
      <label class="bookinfo-tag">Keyword:</label>
      <label class="bookinfo-info">&nbsp;<%=result.getString("keywords")%></label>
    </div>
    <div class="bookinfo-row">
      <label class="bookinfo-tag">Subject:</label>
      <label class="bookinfo-info">&nbsp;<%=result.getString("GS")%></label>
    </div>
    <div class="bookinfo-row">
      <label class="bookinfo-tag">Price:</label>
      <label class="bookinfo-info">&nbsp;<%="¥"+result.getString("price")%></label>
    </div>
  </div>
  <hr class="bookinfo-divider">
</div>
<%}
} catch (Exception e) {}%>
</body>
</html>
