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
  ResultSet result = null;
  try {
    result = bk.showallbooks(connector.stmt);
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
  <link href="../css/indexpage.css" rel="stylesheet">
  <link href="../css/formstyle.css" rel="stylesheet">
  <script>
    $(document).ready(function() {

      setTimeout(function () {
        $(".mtable-container").slideDown(300);
      }, 300);

      $(".trow").click(function() {
        window.open("book.jsp?ISBN=" + $(this).attr("bookid"), "_blank");
      });

      $(".book-order-btn").click(function (){
        $("#"+$(this).attr("bookid")).slideDown(400);
      });

      $(".quantity-cancel").click(function (){
        $("#"+$(this).attr("bookid")).slideUp(400);
      });

      $(".quantity-ok").click(function (){
        var ISBN = $(this).attr("bookid");
        var quantity = $(".quantity-input[bookid='" + ISBN + "']").val();
        if(quantity == "") quantity = "0";
        var number = parseInt(quantity);
        if(number<=0)
        {
          quantity = "0";
          return;
        }

        $.getJSON("increaseinventory.jsp?ISBN="+ISBN+"&number="+quantity, function() {
        });
        $(".addsuccess[bookid='" + ISBN + "']").slideDown(300);
        setTimeout(function (){
          $(".addsuccess[bookid='" + ISBN + "']").slideUp(300);
        },1000);
      });

      $(".addbook-btn").click(function() {
        location.href="addnewbook.jsp";
      });
    });
  </script>
</head>
<body>
<%@include file="navibar.jsp"%>
<div class="user-interface-title">
  ALL BOOKS
  <button class="btn btn-default addbook-btn">
    <div class="glyphicon glyphicon-plus"></div>
    &nbsp;Add a new book
  </button>
</div>
<div class="mtable-container">
  <table  class="table table-hover show-book-table">
    <thead>
    <th>ISBN</th><th>Title</th><th>Author</th><th>Publisher</th><th>Keywords</th><th>Year</th><th>Price</th>
    </thead>
    <tbody>
    <%
      try {
        while(result.next()) {%>
    <tr>
      <td class="trow" bookid="<%=result.getString("ISBN")%>"><%=result.getString("ISBN")%></td>
      <td class="trow" bookid="<%=result.getString("ISBN")%>"><%=result.getString("title")%></td>
      <td class="trow" bookid="<%=result.getString("ISBN")%>"><%=result.getString("GC")%></td>
      <td class="trow" bookid="<%=result.getString("ISBN")%>"><%=result.getString("publisher")%></td>
      <td class="trow" bookid="<%=result.getString("ISBN")%>"><%=result.getString("keywords")%></td>
      <td class="trow" bookid="<%=result.getString("ISBN")%>"><%=result.getString("year_of_publication")%></td>
      <td class="trow" bookid="<%=result.getString("ISBN")%>"><%="¥"+result.getString("price")%></td>
      <td>
        <div class="warning addsuccess" bookid="<%=result.getString("ISBN")%>">Success.</div>
        <input type="button" class="btn btn-default book-order-btn" bookid="<%=result.getString("ISBN")%>" value="Add">
        <div class="quantity-form" id="<%=result.getString("ISBN")%>">
          <input class="form-control quantity-input" type="number" id="quantity" bookid="<%=result.getString("ISBN")%>" name="quantity" placeholder="0"/>
          <input type="button" class="form-control quantity-ok" bookid="<%=result.getString("ISBN")%>" value="OK"/>
          <input type="button" class="form-control quantity-cancel" bookid="<%=result.getString("ISBN")%>" value="Cancel"/>
          <div class="warning quantity-warning" name="qwarningtext" bookid="<%=result.getString("ISBN")%>">Out of stock.</div>
        </div>
      </td>
    </tr>
    <% }
    }
    catch (Exception e){e.printStackTrace();}
    %>
    </tbody>
  </table>
</div>
</body>
</html>
