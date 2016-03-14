<%@ page import="pj.*" %>
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
    response.sendRedirect(request.getContextPath()+"/");
  }
  Connector connector = new Connector();

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
    $(document).ready(function () {
      bindListener();
    })
    var subnum = 1;
    var autnum = 1;
    function addsubject(){
      $(".addsubject").append("<div>" +
              "<label>Subject:</label>" +
              " <input class='form-control anb-subject-input anb-added anb-subject' name='sub"+subnum+"' required/> " +
              "<div class='glyphicon glyphicon-minus minus subjectminus'></div>" +
              "</div>");
      $(".subnum").val(subnum.toString());
      subnum++;
      bindListener();
    }
    function addauthor(){
      $(".addauthor").append("<div>" +
              "<label>Author:</label>" +
              " <input class='form-control anb-subject-input anb-added anb-author' name='aut"+autnum+"' required/> " +
              "<div class='glyphicon glyphicon-minus minus authorminus'></div>" +
              "</div>");
      $(".autnum").val(autnum.toString());
      autnum++;
      bindListener();
    }
    function bindListener(){
      $(".subjectminus").click(function () {
        $(this).parent().remove();
      });
      $(".authorminus").click(function () {
        $(this).parent().remove();
      });
    }
  </script>
</head>
<body>
<%@include file="navibar.jsp"%>
<div class="user-interface-title anb-interface-title">ADD NEW BOOKS</div>
<hr class="result-divider">
<div class="anb-container">
  <form class="anb-form" method="post" action="addnewbook_impl.jsp">
    <div>
      <label>ISBN:</label>
      <input class="form-control anb-input anb-isbn" name="isbn" required/>
    </div>
    <div>
      <label>Title:</label>
      <input class="form-control anb-input anb-title" name="title" required/>
    </div>
    <div>
      <label>Price:</label>
      <input type="number" step="0.01" class="form-control anb-input anb-price" name="price" required/>
    </div>
    <div>
      <label>format:</label>
      <select class="form-control anb-input anb-format" name="format">
        <option value="softcover">softcover</option>
        <option value="hardcover">hardcover</option>
      </select>
    </div>
    <div>
    <label>Publisher:</label>
    <input class="form-control anb-input anb-publisher" name="publisher" required/>
  </div>
    <div>
      <label>Keywords:</label>
      <input class="form-control anb-input anb-publisher" name="keywords" required/>
    </div>
    <div>
      <label>year:</label>
      <input type="number" class="form-control anb-input anb-year" name="year" required/>
    </div>
    <div>
      <label>Number of copies:</label>
      <input type="number" class="form-control anb-input anb-inventory" name="number" required/>
    </div>
    <div class="addsubject">
      <input class="subnum" name="subnum" style="display: none" value="0"/>
    </div>
    <div>
        <label>Subject:</label>
        <input class="form-control anb-input anb-subject" name="sub0" required/>
        <a href="javascript: addsubject()" class="glyphicon glyphicon-plus plus subjectplus" ></a>
    </div>
    <div class="addauthor">
      <input class="autnum" name="autnum" style="display: none" value="0"/>
    </div>
    <div>
      <label>Authors:</label>
      <input class="form-control anb-input anb-author" name="aut0" required/>
      <a href="javascript: addauthor()" class="glyphicon glyphicon-plus plus authorplus"></a>
    </div>
    <div>
      <button type="submit" class="btn btn-default anb-input">Submit</button>
    </div>
  </form>
</div>
</body>
</html>
