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
  if (session.getAttribute("username") == null) {
    response.sendRedirect(request.getContextPath() + "/");
  }
  String username = (String)session.getAttribute("username");
  Order ode = new Order();
  Connector connector = new Connector();
  ResultSet result = null;
  try {
    result = ode.showallorders(username,connector.stmt);
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
      $(".brow").click(function() {
        window.open("book.jsp?ISBN=" + $(this).attr("bookid"), "_blank");
      });

      $(".order-detail-btn").click(function (){
        var order_id = $(this).attr("order-id");
        if($(this).attr("value") == "Show detail") {
          $(".show-detail-order-table[order-id='" + order_id + "']").parent().parent().show();
          $(".show-detail-order-table[order-id='" + order_id + "']").slideDown(300);
          $(this).attr("value", "Show Less");
        }
        else
        {

          $(".show-detail-order-table[order-id='" + order_id + "']").slideUp(300);
          setTimeout(function (){
            $(".show-detail-order-table[order-id='" + order_id + "']").parent().parent().hide();
          },300);
          $(this).attr("value", "Show detail");
        }
      });
    });
  </script>
</head>
<body>
<%@include file="navibar.jsp"%>
<div class="user-interface-title">ALL MY ORDERS</div>
<div class="otable-container">
  <table  class="table show-order-table">
    <thead>
    <th>Orderid</th><th>Date</th><th>Number</th>
    </thead>
    <tbody>
    <%
      boolean isempty = true;
      String now_orderid = "";
      float totalprice = 0;
      int totalbooks = 0;
      try {
        while(result.next()) {
          isempty = false;
          if(!result.getString("orderid").equals(now_orderid))
          {%>
              <%if(!now_orderid.equals("")){%>
                    </tbody>
                  </table>
                  <div class="order-total-price">Total Price :  <%="¥"+totalprice%></div>
                  <script>
                    $("#totalnumber[order-id='" + <%=now_orderid%> + "']").text(<%=totalbooks%>);
                  </script>
                </div>
                </td>

              </tr>
              <%totalprice=0;totalbooks=0;}%>
              <tr>
                <td class="orow" order-id="<%=result.getString("orderid")%>"><%=result.getString("orderid")%></td>
                <td class="orow" order-id="<%=result.getString("orderid")%>"><%=result.getString("date")%>
                </td>
                <td class="orow" order-id="<%=result.getString("orderid")%>" id="totalnumber"><%=result.getString("number")%></td>
                <td>
                  <input type="button" class="btn btn-default order-detail-btn" order-id="<%=result.getString("orderid")%>" value="Show detail">
                </td>
              </tr>
                <tr class="orders-detail-list">
                <td colspan="4">
                <div class="show-detail-order-table" order-id="<%=result.getString("orderid")%>">
                  <table class="table table-striped detail-order-table" >
                    <thead>
                    <th>ISBN</th><th>Title</th><th>Number</th><th>Price</th>
                    </thead>
                    <tbody>
                      <tr>
                        <td class="brow" bookid="<%=result.getString("ISBN")%>"><%=result.getString("ISBN")%></td>
                        <td class="brow" bookid="<%=result.getString("ISBN")%>"><%=result.getString("title")%></td>
                        <td class="brow" bookid="<%=result.getString("ISBN")%>"><%=result.getString("number")%></td>
                        <td class="brow" bookid="<%=result.getString("ISBN")%>"><%="¥"+Float.toString(result.getFloat("price") * result.getFloat("number"))%></td>
                      </tr>
          <%totalprice += result.getFloat("price") * result.getFloat("number");
            totalbooks += result.getInt("number");
          }
          else{
            totalprice += result.getFloat("price") * result.getFloat("number");
            totalbooks += result.getInt("number");
              %>
                      <tr>
                        <td class="brow" bookid="<%=result.getString("ISBN")%>"><%=result.getString("ISBN")%></td>
                        <td class="brow" bookid="<%=result.getString("ISBN")%>"><%=result.getString("title")%></td>
                        <td class="brow" bookid="<%=result.getString("ISBN")%>"><%=result.getString("number")%></td>
                        <td class="brow" bookid="<%=result.getString("ISBN")%>"><%="¥"+Float.toString(result.getFloat("price") * result.getFloat("number"))%></td>
                      </tr>
              <%
            }
            now_orderid = result.getString("orderid");
          }
        }
        catch (Exception e){e.printStackTrace();}
        if(!isempty)
        {
                  %>
                      </tbody>
                    </table>
                    <div class="order-total-price">Total Price :  <%="¥"+totalprice%></div>
                    <script>
                        $("#totalnumber[order-id='" + <%=now_orderid%> + "']").text(<%=totalbooks%>);
                    </script>
                  </div>
                  </td>
                  </tr>
                  <%
        }
    %>

    </tbody>
  </table>
</div>
<div style="height: 100px"></div>
</body>
</html>
