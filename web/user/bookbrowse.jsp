<%@ page import="pj.*" %>
<%@ page import="java.sql.ResultSet" %>
<%--
  Created by IntelliJ IDEA.
  User: Kevin
  Date: 6/26/15
  Time: 10:59 PM
  To change this template use File | Settings | File Templates.
--%>
<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%
  if (session.getAttribute("username") == null) {
    response.sendRedirect(request.getContextPath() + "/");
  }
  String username = (String)session.getAttribute("username");
  Connector connector = new Connector();
  Book bk = new Book();

  ResultSet result = null;
  boolean check = false;
  String query = request.getParameter("query");
  if(!query.contains("="))
  {
    query = "title="+query;
  }

  try {
    query = bk.pretreat(query);
    check = bk.querychecker(query);
    if(check) {
      result = bk.bookbrowsering(username, query, 1, connector.stmt);
    }
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
      $(".table1").slideDown(300);
      var timeout;
      $(".trow").click(function() {
        window.open("book.jsp?ISBN=" + $(this).attr("bookid"), "_blank");
      });
      $(".sortselector").change(function () {
        var value = $(".sortselector").val();
        if(value == 1)
        {
          $(".show-result-table").slideUp(300);
          clearTimeout(timeout);
          timeout = setTimeout(function () {
            $(".table1").slideDown(300);
          },300);
        }
        else if(value == 2)
        {
          $(".show-result-table").slideUp(300);
          clearTimeout(timeout);
          timeout = setTimeout(function () {
            $(".table2").slideDown(300);
          },300);
        }
        else if(value == 3)
        {
          $(".show-result-table").slideUp(300);
          clearTimeout(timeout);
          timeout = setTimeout(function () {
            $(".table3").slideDown(300);
          },300);
        }
      });
    });
  </script>
</head>
<body>
<%@include file="navibar.jsp"%>
  <div class="result-container">
    <div class="user-interface-title">RESULT
      <div class="sortmethod">
        <select  class="form-control sortselector">
          <option value="1">Sort by year.</option>
          <option value="2">Sort by the average numerical score of the feedback.</option>
          <option value="3">Sort by average numerical score of the trusted user feedback.</option>
        </select>
      </div>
    </div>

    <hr class="result-divider">
    <%if(!check) {
      %>
        <div class="illegal-query">Illegal query.</div>
      <%
    }
      else{%>
    <div class="show-result-table table1">
      <table class="table table-hover result-table">
        <thead>
          <th>ISBN</th><th>Title</th><th>Author</th><th>Publisher</th><th>Keywords</th><th>Year</th><th>Price</th>
        </thead>
        <tbody>
          <%try {
            int count = 0;
            while(result.next()){
              count++;%>
          <tr>
            <td class="trow" bookid="<%=result.getString("ISBN")%>"><%=result.getString("ISBN")%></td>
            <td class="trow" bookid="<%=result.getString("ISBN")%>"><%=result.getString("title")%></td>
            <td class="trow" bookid="<%=result.getString("ISBN")%>"><%=result.getString("GC")%></td>
            <td class="trow" bookid="<%=result.getString("ISBN")%>"><%=result.getString("publisher")%></td>
            <td class="trow" bookid="<%=result.getString("ISBN")%>"><%=result.getString("keywords")%></td>
            <td class="trow" bookid="<%=result.getString("ISBN")%>"><%=result.getString("year_of_publication")%></td>
            <td class="trow" bookid="<%=result.getString("ISBN")%>"><%="¥"+result.getString("price")%></td>

          <%}
            if(count==0){
              %>
              <td colspan="7"><div class="empty-query">No book meets that requirement.</div></td>
              </tr>
              <%
            }
            else{
              %>
              </tr>
            <%
            }
            } catch (Exception e) {e.printStackTrace();}
          %>
        </tbody>
      </table>
    </div>
    <%
      try {
        result = bk.bookbrowsering(username, query, 2, connector.stmt);
      } catch (Exception e) {
        e.printStackTrace();
      }
    %>
    <div class="show-result-table table2">
      <table class="table table-hover result-table">
        <thead>
        <th>ISBN</th><th>Title</th><th>Author</th><th>Publisher</th><th>Keywords</th><th>Year</th><th>Price</th><th>AG. score</th>
        </thead>
        <tbody>
        <%try {
          int count = 0;
          while(result.next()){
            count++;%>
        <tr>
          <td class="trow" bookid="<%=result.getString("ISBN")%>"><%=result.getString("ISBN")%></td>
          <td class="trow" bookid="<%=result.getString("ISBN")%>"><%=result.getString("title")%></td>
          <td class="trow" bookid="<%=result.getString("ISBN")%>"><%=result.getString("GC")%></td>
          <td class="trow" bookid="<%=result.getString("ISBN")%>"><%=result.getString("publisher")%></td>
          <td class="trow" bookid="<%=result.getString("ISBN")%>"><%=result.getString("keywords")%></td>
          <td class="trow" bookid="<%=result.getString("ISBN")%>"><%=result.getString("year_of_publication")%></td>
          <td class="trow" bookid="<%=result.getString("ISBN")%>"><%="¥"+result.getString("price")%></td>
          <td class="trow" bookid="<%=result.getString("ISBN")%>"><%=result.getString("AG")%></td>
          <%}
            if(count==0){
          %>
          <td colspan="7"><div class="empty-query">No book meets that requirement.</div></td>
        </tr>
        <%
        }
        else{
        %>
        </tr>
        <%
            }
          } catch (Exception e) {e.printStackTrace();}
        %>
        </tbody>
      </table>
    </div>
    <%
      try {
        result = bk.bookbrowsering(username, query, 3, connector.stmt);
      } catch (Exception e) {
        e.printStackTrace();
      }
    %>
    <div class="show-result-table table3">
      <table class="table table-hover result-table">
        <thead>
        <th>ISBN</th><th>Title</th><th>Author</th><th>Publisher</th><th>Keywords</th><th>Year</th><th>Price</th><th>AG.(trusted)score</th>
        </thead>
        <tbody>
        <%try {
          int count = 0;
          while(result.next()){
            count++;%>
        <tr>
          <td class="trow" bookid="<%=result.getString("ISBN")%>"><%=result.getString("ISBN")%></td>
          <td class="trow" bookid="<%=result.getString("ISBN")%>"><%=result.getString("title")%></td>
          <td class="trow" bookid="<%=result.getString("ISBN")%>"><%=result.getString("GC")%></td>
          <td class="trow" bookid="<%=result.getString("ISBN")%>"><%=result.getString("publisher")%></td>
          <td class="trow" bookid="<%=result.getString("ISBN")%>"><%=result.getString("keywords")%></td>
          <td class="trow" bookid="<%=result.getString("ISBN")%>"><%=result.getString("year_of_publication")%></td>
          <td class="trow" bookid="<%=result.getString("ISBN")%>"><%="¥"+result.getString("price")%></td>
          <td class="trow" bookid="<%=result.getString("ISBN")%>"><%=result.getString("AG2")%></td>
          <%}
            if(count==0){
          %>
          <td colspan="7"><div class="empty-query">No book meets that requirement.</div></td>
        </tr>
        <%
        }
        else{
        %>
        </tr>
        <%
            }
          } catch (Exception e) {e.printStackTrace();}
        %>
        </tbody>
      </table>
    </div>
    <%}%>
  </div>
</body>
</html>
