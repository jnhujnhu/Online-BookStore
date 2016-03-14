<%@ page import="pj.*" %>
<%@ page import="java.sql.ResultSet" %>
<%--
  Created by IntelliJ IDEA.
  User: Kevin
  Date: 6/27/15
  Time: 4:21 PM
  To change this template use File | Settings | File Templates.
--%>
<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%
  if (session.getAttribute("username") == null) {
    response.sendRedirect(request.getContextPath() + "/");
  }
  Connector connector = new Connector();
  String username = (String)session.getAttribute("username");
%>
<html>
<head>
  <title>Kevin's Book Store</title>
  <script src="../js/jquery-2.1.4.min.js"></script>
  <script src="../js/bootstrap.min.js"></script>
  <link href="../css/bootstrap.min.css" rel="stylesheet">
  <link href="../css/formstyle.css" rel="stylesheet">
  <link href="../css/indexpage.css" rel="stylesheet">
</head>
<script>
  $(document).ready(function () {
    $(".assubmit").click(function () {
      var author1 = $(".author1").val();
      var author2 = $(".author2").val();
      $.getJSON("authorsep_impl.jsp?author1="+author1+"&author2="+author2,function(data){
        if(!data.exist1)
        {
          $(".theresult").slideUp(300);
          $(".author1notexist").html("Author '"+author1+"' not exist.");
          $(".author1notexist").slideDown(300);
        }
        if(!data.exist2)
        {
          $(".theresult").slideUp(300);
          $(".author2notexist").html("Author '"+author2+"' not exist.");
          $(".author2notexist").slideDown(300);
        }
        if(data.exist1&&data.exist2)
        {
          $(".author1notexist").slideUp(300);
          $(".author2notexist").slideUp(300);
          if(data.result!=0) {
            $(".theresult").html("Author '" + author1 + "' and author '" + author2 + "' are " + data.result + "-degree away.");
            $(".theresult").slideDown(300);
          }
          else
          {
            $(".theresult").html("Author '" + author1 + "' and author '" + author2 + "' are not 1-degree away or 2-degree away");
            $(".theresult").slideDown(300);
          }
        }
      });
    });
  });
</script>
<body>
<%@include file="navibar.jsp"%>
<div class="as-container">
  <div class="asinput-container">
    <label class="author1-label">Author1:&nbsp;</label>
    <input class="form-control authorinput author1"/>
    <label class="author2-label">Author2:&nbsp;</label>
    <input class="form-control authorinput author2"/>
    <button type="button" class="btn btn-default assubmit">Submit</button>
  </div>
  <div class="asresult">
    <div class="author1notexist"></div>
    <div class="author2notexist"></div>
    <div class="theresult"></div>
  </div>
</div>
</body>
</html>
