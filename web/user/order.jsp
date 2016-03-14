<%@ page import="pj.*" %>
<%@ page import="java.sql.ResultSet" %>
<%--
  Created by IntelliJ IDEA.
  User: Kevin
  Date: 6/23/15
  Time: 5:14 PM
  To change this template use File | Settings | File Templates.
--%>
<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%
    if (session.getAttribute("username") == null || session.getAttribute("orderid") ==null) {
        response.sendRedirect(request.getContextPath() + "/");
    }
    String username = (String)session.getAttribute("username");
    String orderid = (String)session.getAttribute("orderid");
    Order ode = new Order();
    Connector connector = new Connector();
    float totalprice = 0;
    ResultSet result = null;
    try {
        result = ode.printorder(Integer.parseInt(orderid),username,connector.stmt);
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

    $(document).ready(function (){
        setTimeout(function (){
            $(".otable-container").slideDown(300);
        } ,300);
        setTimeout(function (){
            $(".buying-suggestion-container").slideDown(300);
        } ,600);
        $(".orow").click(function() {
            window.open("book.jsp?ISBN=" + $(this).attr("bookid"), "_blank");
        });
        $(".view-all-orders-btn").click(function () {
           location.href = "allorders.jsp";
        });
    });
    </script>
</head>
<body>
<%@include file="navibar.jsp"%>
<div class="user-interface-title">YOUR ORDER FORM</div>
<div class="otable-container">
    <div class="orderid-title">Orderid :  <%=orderid%></div>
    <table  class="table table-hover show-order-table">
        <thead>
        <th>ISBN</th><th>Title</th><th>Date</th><th>Number</th><th>Price</th>
        </thead>
        <tbody>
        <%try {
                while(result.next()) {
                    totalprice += result.getFloat("price") * result.getFloat("number");
        %>
        <tr>
            <td class="orow" bookid="<%=result.getString("ISBN")%>"><%=result.getString("ISBN")%></td>
            <td class="orow" bookid="<%=result.getString("ISBN")%>"><%=result.getString("title")%></td>
            <td class="orow" bookid="<%=result.getString("ISBN")%>"><%=result.getString("date")%></td>
            <td class="orow" bookid="<%=result.getString("ISBN")%>"><%=result.getString("number")%></td>
            <td class="orow" bookid="<%=result.getString("ISBN")%>"><%="¥"+Float.toString(result.getFloat("price") * result.getFloat("number"))%></td>
        </tr>
        <% }
        }
        catch (Exception e){e.printStackTrace();}
        %>
        </tbody>
    </table>
    <div class="total-price">Total Price :  <%="¥"+totalprice%></div>
    <button type="button" class="btn btn-default view-all-orders-btn">View all my orders</button>
</div>
<div class="buying-suggestion-container">
    <div class="user-interface-title buying-suggestion-title">BUYING SUGGESTION</div>
    <table  class="table table-hover show-buysuggest-table">
        <thead>
        <th>ISBN</th><th>Title</th><th>Keywords</th><th>Year</th><th>Sales count</th>
        </thead>
        <tbody>
        <%
            try {
                result = ode.buyingsuggestion(Integer.parseInt(orderid), connector.stmt);
                while(result.next()) {
        %>
        <tr>
            <td class="orow" bookid="<%=result.getString("ISBN")%>"><%=result.getString("ISBN")%></td>
            <td class="orow" bookid="<%=result.getString("ISBN")%>"><%=result.getString("title")%></td>
            <td class="orow" bookid="<%=result.getString("ISBN")%>"><%=result.getString("keywords")%></td>
            <td class="orow" bookid="<%=result.getString("ISBN")%>"><%=result.getString("year_of_publication")%></td>
            <td class="orow" bookid="<%=result.getString("ISBN")%>"><%=result.getString("sn")%></td>
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
