<%@ page import="pj.*" %>
<%@ page import="java.sql.ResultSet" %>
<%--
  Created by IntelliJ IDEA.
  User: Kevin
  Date: 6/27/15
  Time: 9:20 PM
  To change this template use File | Settings | File Templates.
--%>
<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%
  if (session.getAttribute("ismanager") == null) {
    response.sendRedirect(request.getContextPath() + "/");
  }
  Connector connector = new Connector();
  Rating rt = new Rating();
  ResultSet result = null;
%>
<html>
<head>
  <title>Kevin's Book Store</title>
  <script src="../js/jquery-2.1.4.min.js"></script>
  <script src="../js/bootstrap.min.js"></script>
  <link href="../css/bootstrap.min.css" rel="stylesheet">
  <link href="../css/indexpage.css" rel="stylesheet">
  <link href="../css/formstyle.css" rel="stylesheet">
</head>
<script>
  $(document).ready(function () {
    $(".stap-container").slideDown(300);
  });
</script>
<body>
<%@include file="navibar.jsp"%>
<%
  try {
    result = rt.toptrusteduser(connector.stmt);
  } catch (Exception e) {
    e.printStackTrace();
  }
  int tunum=0;
%>
<div class="stap-container">
  <div class="stapb-container">
    <div class="user-interface-title stapb-title">
      TOP M MOST TRUSTED USER
      <div class="m-label"><label>m:&nbsp;</label><input type="number" class="form-control input-m"></div>
    </div>
    <table class="table table-hover stap-table stapb-table">
      <thead>
      <th>Loginname</th><th>Trust score</th>
      </thead>
      <tbody>
      <%try {
        while(result.next()){
          tunum++;
      %>
      <tr class="trust-row" rowid="<%=tunum%>">
        <td class="arow"><%=result.getString("loginname")%></td>
        <td class="arow"><%=result.getString("score")%></td>
      </tr>
      <%}

      } catch (Exception e) {
      }
      %>
      </tbody>
    </table>
  </div>
  <%
    try {
      result = rt.topusefuluser(connector.stmt);
    } catch (Exception e) {
      e.printStackTrace();
    }
    int uunum=0;
  %>
  <div class="stapa-container">
    <div class="user-interface-title stapb-title">TOP M MOST USEFUL USER</div>
    <table class="table table-hover stap-table stapb-table">
      <thead>
        <th>Loginname</th><th>Usefulness score</th>
      </thead>
      <tbody>
      <%try {
        while(result.next()){
          uunum++;
      %>
      <tr class="useful-row" rowid="<%=uunum%>">
        <td class="arow"><%=result.getString("loginname")%></td>
        <td class="arow"><%=result.getString("AF")%></td>
      </tr>
      <%}

      } catch (Exception e) {
      }
      %>
      </tbody>
    </table>
  </div>
</div>
<script>
  $(document).ready(function() {

    $(".input-m").val("5");
    for (var i = 1; i <=<%=tunum%>; i++) {
      if (i > 5) {
        $(".trust-row[rowid='" + i.toString() + "']").hide();
      }
      else {
        $(".trust-row[rowid='" + i.toString() + "']").show();
      }
    }
    for (var i = 1; i <=<%=uunum%>; i++) {
      if (i > 5) {
        $(".useful-row[rowid='" + i.toString() + "']").hide();
      }
      else {
        $(".useful-row[rowid='" + i.toString() + "']").show();
      }
    }

    $(".input-m").blur(function() {
      var sn = $(".input-m").val();
      var n = 0;
      if(sn!="") {
        n=parseInt(sn);
      }
      if(n<0) {
        n=0;
      }
      for (var i = 1; i <=<%=tunum%>; i++) {
        if (i > n) {
          $(".trust-row[rowid='" + i.toString() + "']").hide();
        }
        else {
          $(".trust-row[rowid='" + i.toString() + "']").show();
        }
      }
      for (var i = 1; i <=<%=uunum%>; i++) {
        if (i > n) {
          $(".useful-row[rowid='" + i.toString() + "']").hide();
        }
        else {
          $(".useful-row[rowid='" + i.toString() + "']").show();
        }
      }
    });
  });
</script>
<div class="blank"></div>
</body>
</html>
