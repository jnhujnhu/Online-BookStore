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
  Book bk = new Book();
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
    $(".trow").click(function() {
      window.open("book.jsp?ISBN=" + $(this).attr("bookid"), "_blank");
    });
  });
</script>
<body>
<%@include file="navibar.jsp"%>
<%
  String []time = new String[2];
  try {
    time = bk.maketime();
    result = bk.popularitystabooks(connector.stmt);
  } catch (Exception e) {
    e.printStackTrace();
  }
  int booknum=0;
%>
<div class="stap-container">
  <div class="stapb-container">
    <div class="user-interface-title stapb-title">
      TOP M MOST POPULAR BOOKS
      <div class="m-label"><label>m:&nbsp;</label><input type="number" class="form-control input-m"></div>
    </div>
    <div class="time">This semester starts at: <%=time[0]%>   ends at: <%=time[1]%></div>
    <table class="table table-hover stap-table stapb-table">
      <thead>
        <th>Title</th><th>ISBN</th><th>Format</th><th>Publisher</th><th>Year</th><th>Price</th><th>Copies sold this semester</th>
      </thead>
      <tbody>
        <%try {
          while(result.next()){
            booknum++;
        %>
          <tr class="book-row" rowid="<%=booknum%>">
            <td class="trow" bookid="<%=result.getString("ISBN")%>"><%=result.getString("title")%></td>
            <td class="trow" bookid="<%=result.getString("ISBN")%>"><%=result.getString("ISBN")%></td>
            <td class="trow" bookid="<%=result.getString("ISBN")%>"><%=result.getString("format")%></td>
            <td class="trow" bookid="<%=result.getString("ISBN")%>"><%=result.getString("publisher")%></td>
            <td class="trow" bookid="<%=result.getString("ISBN")%>"><%=result.getString("year_of_publication")%></td>
            <td class="trow" bookid="<%=result.getString("ISBN")%>"><%="¥"+result.getString("price")%></td>
            <td class="trow" bookid="<%=result.getString("ISBN")%>"><%=result.getString("sn")%></td>
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
      result = bk.popularitystaauthors(connector.stmt);
    } catch (Exception e) {
      e.printStackTrace();
    }
    int authornum=0;
  %>
  <div class="stapa-container">
    <div class="user-interface-title stapa-title">TOP M MOST POPULAR AUTHORS</div>
    <div class="time">This semester starts at: <%=time[0]%>   ends at: <%=time[1]%></div>
    <table class="table table-hover stap-table stapa-table">
      <thead>
        <th>Author name</th><th>Sales count</th>
      </thead>
      <tbody>
      <%try {
        while(result.next()){
          authornum++;
      %>
      <tr class="author-row" rowid="<%=authornum%>">
        <td class="arow" ><%=result.getString("authorname")%></td>
        <td class="arow" ><%=result.getString("st")%></td>
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
      result = bk.popularitystapublishers(connector.stmt);
    } catch (Exception e) {
      e.printStackTrace();
    }
    int publishernum=0;
  %>
  <div class="stapp-container">
    <div class="user-interface-title stapp-title">TOP M MOST POPULAR PUBLISHERS</div>
    <div class="time">This semester starts at: <%=time[0]%>   ends at: <%=time[1]%></div>
    <table class="table table-hover stap-table stapp-table">
      <thead>
      <th>Publisher</th><th>Sales count</th>
      </thead>
      <tbody>
      <%try {
        while(result.next()){
          publishernum++;
      %>
      <tr class="publisher-row" rowid="<%=publishernum%>">
        <td class="arow" ><%=result.getString("publisher")%></td>
        <td class="arow" ><%=result.getString("st")%></td>
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
    for (var i = 1; i <=<%=booknum%>; i++) {
      if (i > 5) {
        $(".book-row[rowid='" + i.toString() + "']").hide();
      }
      else {
        $(".book-row[rowid='" + i.toString() + "']").show();
      }
    }
    for (var i = 1; i <=<%=authornum%>; i++) {
      if (i > 5) {
        $(".author-row[rowid='" + i.toString() + "']").hide();
      }
      else {
        $(".author-row[rowid='" + i.toString() + "']").show();
      }
    }
    for (var i = 1; i <=<%=publishernum%>; i++) {
      if (i > 5) {
        $(".publisher-row[rowid='" + i.toString() + "']").hide();
      }
      else {
        $(".publisher-row[rowid='" + i.toString() + "']").show();
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
      for (var i = 1; i <=<%=booknum%>; i++) {
        if (i > n) {
          $(".book-row[rowid='" + i.toString() + "']").hide();
        }
        else {
          $(".book-row[rowid='" + i.toString() + "']").show();
        }
      }
      for (var i = 1; i <=<%=authornum%>; i++) {
        if (i > n) {
          $(".author-row[rowid='" + i.toString() + "']").hide();
        }
        else {
          $(".author-row[rowid='" + i.toString() + "']").show();
        }
      }
      for (var i = 1; i <=<%=publishernum%>; i++) {
        if (i > n) {
          $(".publisher-row[rowid='" + i.toString() + "']").hide();
        }
        else {
          $(".publisher-row[rowid='" + i.toString() + "']").show();
        }
      }
    });
  });
</script>
<div class="blank"></div>
</body>
</html>
