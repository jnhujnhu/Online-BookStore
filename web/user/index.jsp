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
  if (session.getAttribute("username") == null) {
    response.sendRedirect(request.getContextPath() + "/");
  }
  String username = (String)session.getAttribute("username");
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
    var firstorder = true;
    var orderid = "0";
    var orderdata =[];

    function checkquantity(ISBN,quantity) {
      var res;
      $.getJSON("checkquantity.jsp?quantity=" + quantity + "&ISBN=" + ISBN , function(data) {
        if (data.result == false) {
          res = false;
        }
        else {
          res = true;
        }
      });
      return res;
    }

    function ordersubmit() {
      var now = $(".badge").text();
      if(now == 0) {
        return false;
      }
      else {
        return true;
      }
    }

    $(document).ready(function() {

      setTimeout(function() {
        $(".mtable-container").slideDown(300);
      } ,300);

      $(".trow").click(function() {
        window.open("book.jsp?ISBN=" + $(this).attr("bookid"), "_blank");
      });

      $(".book-order-btn").click(function (){
        $("#"+$(this).attr("bookid")).slideDown(400);
      });

      $(".quantity-cancel").click(function (){
        $("#"+$(this).attr("bookid")).slideUp(400);
      });

      var firstclick = false;

      $(".quantity-ok").click(function (){
        var ISBN = $(this).attr("bookid");
        var quantity = $(".quantity-input[bookid='" + ISBN + "']").val();
        if(quantity == "") quantity = "0";
        var number = parseInt(quantity);
        if(number<0) quantity = "0";
        var checkquan = "0";
        var F = false;

        for(var i=0; i<orderdata.length;i++)
        {
          if(orderdata[i].ISBN == ISBN)
          {
            checkquan = (parseInt(orderdata[i].quantity) + parseInt(quantity)).toString();
            F = true;
          }
        }
        if(!F)
        {checkquan = quantity;}

        $.ajaxSetup({ async: false });
        var res = checkquantity(ISBN,checkquan);
        $.ajaxSetup({ async: true });

       if(res){
         var title = "";
         var isduplicate = false;
         var pos = 0;
         for (var i=0; i<orderdata.length;i++) {
           if (ISBN == orderdata[i].ISBN) {
              orderdata[i].quantity = (parseInt(orderdata[i].quantity) + parseInt(quantity)).toString();
             isduplicate = true;
             pos = i;
           }
         }
          $.getJSON("gettitle.jsp?ISBN="+ISBN, function(data) {
            title = data.title;
            if (!isduplicate&&quantity!="0") {
              var now = $(".badge").text();
              now = parseInt(now);
              $(".badge").html(now + 1);
              var trHTML = "<tr ISBN='" + ISBN + "'><td>" + title + "</td><td>" + quantity + "</td></tr>";
              $(".order-list-table tbody").append(trHTML);
              orderdata.push({quantity: quantity, ISBN: ISBN});
              if(!firstclick)
              {
                $(".show-order-list").slideDown(500);
                orderlistpos = false;
              }
              firstclick = true;
              $("#"+ISBN).slideUp(400);
              $(".quantity-input[bookid='" + ISBN + "']").val("");
            }
            else if(quantity!="0"){
              $(".order-list-table tbody tr[ISBN='" + ISBN + "'] td:last-child").text(orderdata[pos].quantity);
              $("#"+ISBN).slideUp(400);
              $(".quantity-input[bookid='" + ISBN + "']").val("");
            }
          });

        }
      });

      $(".quantity-input").blur(function () {
        var ISBN = $(this).attr("bookid");
        var quantity = $(this).val();
        if(quantity == "") quantity = "0";
        var checkquan = "0";
        var F = false;
        for(var i=0; i<orderdata.length;i++)
        {
          if(orderdata[i].ISBN == ISBN)
          {
            checkquan = (parseInt(orderdata[i].quantity) + parseInt(quantity)).toString();
            F = true;
          }
        }
        if(!F) checkquan = quantity;
        $.ajaxSetup({ async: false });
        var res = checkquantity(ISBN,checkquan);
        $.ajaxSetup({ async: true });

        if (res == false) {
            $("div[name='qwarningtext'][bookid='"+ISBN+"']").slideDown(300);
        }
        else {
          $("div[name='qwarningtext'][bookid='"+ISBN+"']").slideUp(300);
        }
      });


      var orderlistpos= true;
      var dclick = true;
      $(".bottom-order-list").click(function (){
        if(dclick) {
          dclick = false;
          var height = $(".show-order-list").css("height");
          if (orderlistpos) {
            $(".show-order-list").slideDown(500);
            orderlistpos = false;
          }
          else{
            $(".show-order-list").slideUp(500);
            orderlistpos = true;
          }
          setTimeout(function () {
            dclick = true;
          }, 500);
        }
      });
      $(".finish-shopping").click(function () {
        $.ajaxSetup({ async: false });
        var orderid = "";
        for(var i=0;i<orderdata.length ;i++) {
          var isfirstorder = false;
          if(i==0) isfirstorder = true;
          $.getJSON("order_impl.jsp?ISBN="+ orderdata[i].ISBN+"&quantity="+orderdata[i].quantity+"&isfirstorder=" +isfirstorder+"&orderid="+orderid, function (data) {
            orderid = data.orderid;
            $(".orderid-submit").attr("value",orderid);
          });
        }
        $.ajaxSetup({ async: true });
        return ordersubmit();
      });
    })
  </script>

</head>
<body>
  <%@include file="navibar.jsp"%>
  <div class="user-interface-title">ALL BOOKS</div>
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
                <input type="button" class="btn btn-default book-order-btn" bookid="<%=result.getString("ISBN")%>" value="Order">
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
    <div class="body-bottom" style="margin-top: 40px; position: absolute; margin-left: -100px; width: 100%;">
      <label class="bottom-instruction">Copyright@2008-2015  Kevin  沪ICP备2333333号</label>
    </div>
  </div>
  <form method="post" action="order.jsp">
    <div class="orderid-submit" name="orderid"></div>
    <div class="shoppingcart">
      <div class="show-order-list">
        <table class="table table-striped order-list-table">
          <thead class="order-list-table-head">
            <th>Title</th><th>Quantity</th>
          </thead>
          <tbody>
          </tbody>
        </table>
      </div>
      <input type="submit" class="btn finish-shopping" value="Finish">
      <a herf="#" class="list-group-item bottom-order-list">
        <span class="badge">
          0
        </span>
        <div class="shopping-label">Shopping List</div>
      </a>
    </div>
  </form>

</body>
</html>
