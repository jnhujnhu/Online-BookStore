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
  Connector connector = new Connector();
  String username = (String)session.getAttribute("username");
  Book bk = new Book();
  Feedback fd = new Feedback();

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
      setTimeout(function() {
        $(".all-feedbackinfo-container").slideDown(300);
      },600);
      setTimeout(function() {
        $(".givedetail-container").slideDown(300);
      },900);
      $(".ratefeedback-btn-vuf").click(function() {
        var feedbackid =  $(this).attr("feedbackid");
        var feedbackuser = $(".feedbackinfo-user[feedbackid='"+feedbackid+"']").html();
        var loginname = "<%=username%>";
        if(feedbackuser == loginname)
        {
          $(".ratefeedbackrateself[feedbackid='" + feedbackid + "']").slideDown();
          $(".ratefeedbackrateself[feedbackid='" + feedbackid + "']").css("display","inline-block");
          setTimeout(function () {
            $(".ratefeedbackrateself[feedbackid='" + feedbackid + "']").slideUp();
          }, 2000);
        }
        else {
          $.getJSON("ratefeedback.jsp?feedbackid=" + feedbackid + "&loginname=" + loginname + "&score=2", function (data) {
            if (data.result == true) {
              $(".ratefeedbacksuccess[feedbackid='" + feedbackid + "']").slideDown();
              $(".ratefeedbacksuccess[feedbackid='" + feedbackid + "']").css("display","inline-block");
              setTimeout(function () {
                $(".ratefeedbacksuccess[feedbackid='" + feedbackid + "']").slideUp();
              }, 2000);
            }
          });
        }
      });

      $(".ratefeedback-btn-uf").click(function() {
        var feedbackid =  $(this).attr("feedbackid");
        var feedbackuser = $(".feedbackinfo-user[feedbackid='"+feedbackid+"']").html();
        var loginname = "<%=username%>";
        if(feedbackuser == loginname)
        {
          $(".ratefeedbackrateself[feedbackid='" + feedbackid + "']").slideDown();
          $(".ratefeedbackrateself[feedbackid='" + feedbackid + "']").css("display","inline-block");
          setTimeout(function () {
            $(".ratefeedbackrateself[feedbackid='" + feedbackid + "']").slideUp();
          }, 2000);
        }
        else {
          $.getJSON("ratefeedback.jsp?feedbackid=" + feedbackid + "&loginname=" + loginname + "&score=1", function (data) {
            if (data.result == true) {
              $(".ratefeedbacksuccess[feedbackid='" + feedbackid + "']").slideDown();
              $(".ratefeedbacksuccess[feedbackid='" + feedbackid + "']").css("display","inline-block");
              setTimeout(function () {
                $(".ratefeedbacksuccess[feedbackid='" + feedbackid + "']").slideUp();
              }, 2000);
            }
          });
        }
      });

      $(".ratefeedback-btn-ul").click(function() {
        var feedbackid =  $(this).attr("feedbackid");
        var feedbackuser = $(".feedbackinfo-user[feedbackid='"+feedbackid+"']").html();
        var loginname = "<%=username%>";
        if(feedbackuser == loginname)
        {
          $(".ratefeedbackrateself[feedbackid='" + feedbackid + "']").slideDown();
          $(".ratefeedbackrateself[feedbackid='" + feedbackid + "']").css("display","inline-block");
          setTimeout(function () {
            $(".ratefeedbackrateself[feedbackid='" + feedbackid + "']").slideUp();
          }, 2000);
        }
        else {
          $.getJSON("ratefeedback.jsp?feedbackid=" + feedbackid + "&loginname=" + loginname + "&score=0", function (data) {
            if (data.result == true) {
              $(".ratefeedbacksuccess[feedbackid='" + feedbackid + "']").slideDown();
              $(".ratefeedbacksuccess[feedbackid='" + feedbackid + "']").css("display","inline-block");
              setTimeout(function () {
                $(".ratefeedbacksuccess[feedbackid='" + feedbackid + "']").slideUp();
              }, 2000);
            }
          });
        }
      });
      $(".givefeedback-btn").click(function () {
        var score = $(".givefeedback-score").val();
        var comment = $(".givefeedback-comment").val();
        var username = "<%=username%>";
        var ISBN = "<%=ISBN%>";
        var f = false;
        for(var i=0; i<=10; i++)
        {
          if(score == i.toString())
          {
            f=true;
          }
        }
        if(f) {
          $(".scoreinputwarning").slideUp(300);
          $.getJSON("givefeedback.jsp?username=" + username +"&ISBN="+ISBN+"&score="+score+"&comment="+comment, function(data) {
            if (data.result == false) {
              $(".doubleinputwarning").slideDown(300);
              setTimeout(function () {
                $(".doubleinputwarning").slideUp(300);
              },2000);
            }
            else{
              $(".feedbacksuccess").slideDown(300);
              setTimeout(function () {
                $(".feedbacksuccess").slideUp(300);
                window.location.href=window.location.href;
              },2000);

            }
          });
        }
        else{
          $(".scoreinputwarning").slideDown(300);
        }
      });
      var dclick = false;
      $(".feedbackinfo-user").click(function () {
        var feedbackid = $(this).attr("feedbackid");
        if(!dclick){
          $(".userrating[feedbackid='"+feedbackid+"']").slideDown(300);
          dclick = true;
        }
        else{
          $(".userrating[feedbackid='"+feedbackid+"']").slideUp(300);
          dclick = false;
        }
      });

      $(".userrating-trust").click(function (){
        var feedbackid = $(this).attr("feedbackid");
        var username = "<%=username%>";
        var feedbackuser = $(".feedbackinfo-user[feedbackid='"+feedbackid+"']").html();
        $.getJSON("rateuser.jsp?username=" + username +"&feedbackuser="+feedbackuser+"&istrust="+"1", function(data) {
          if (data.result == false) {
            $(".rateuserfailed[feedbackid='"+feedbackid+"']").slideDown(300);
            $(".rateuserfailed[feedbackid='"+feedbackid+"']").css("display","inline-block");
            setTimeout(function() {
              $(".rateuserfailed[feedbackid='"+feedbackid+"']").slideUp(300);
            },1000);
          }
          else {
            $(".rateusersuccess[feedbackid='"+feedbackid+"']").slideDown(300);
            $(".rateusersuccess[feedbackid='"+feedbackid+"']").css("display","inline-block");
            setTimeout(function() {
              $(".rateusersuccess[feedbackid='"+feedbackid+"']").slideUp(300);
              $(".userrating[feedbackid='"+feedbackid+"']").slideUp(300);
            },1000);
          }
        });
      });

      $(".userrating-untrust").click(function (){
        var feedbackid = $(this).attr("feedbackid");
        var username = "<%=username%>";
        var feedbackuser = $(".feedbackinfo-user[feedbackid='"+feedbackid+"']").html();
        $.getJSON("rateuser.jsp?username=" + username +"&feedbackuser="+feedbackuser+"&istrust="+"0", function(data) {
          if (data.result == false) {
            $(".rateuserfailed[feedbackid='"+feedbackid+"']").slideDown(300);
            $(".rateuserfailed[feedbackid='"+feedbackid+"']").css("display","inline-block");
            setTimeout(function() {
              $(".rateuserfailed[feedbackid='"+feedbackid+"']").slideUp(300);
            },1000);
          }
          else {
            $(".rateusersuccess[feedbackid='"+feedbackid+"']").slideDown(300);
            $(".rateusersuccess[feedbackid='"+feedbackid+"']").css("display","inline-block");
            setTimeout(function() {
              $(".rateusersuccess[feedbackid='"+feedbackid+"']").slideUp(300);
              $(".userrating[feedbackid='"+feedbackid+"']").slideUp(300);
            },1000);
          }
        });
      });

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
    } catch (Exception e) {}
    int feedbacknum = 0;
    try {
      result = fd.showallfeedbacks(ISBN, connector.stmt);
    } catch (Exception e) {
      e.printStackTrace();
    }%>
  <div class="feedback-container">
    <div class="feedback-title">Feedbacks</div>
    <label class="show-topfeedback-checkbox">
      <input class="topfeedback-checkbox" type="checkbox">
      &nbsp;Show top
      <input type="number" class="form-control topnumber" placeholder="n">
      most useful feedbacks
    </label>
    <hr class="bookinfo-divider">
    <div class="all-feedbackinfo-container">
    <%
      try{
      while(result.next()){
      %>
      <div class="feedbackinfo-container">
        <label class="feedbackinfo-user" feedbackid="<%=result.getString("feedbackid")%>"><%=result.getString("loginname")%></label>
        <label class="feedbackinfo-date">&nbsp;&nbsp;&nbsp;<%=result.getString("date")%>&nbsp;&nbsp;&nbsp;</label>
        <%
          int score = Integer.parseInt(result.getString("score"));
          for(int j = 0;j<score/2;j++)
          {
            %>
              <span class="glyphicon glyphicon-star"></span>
            <%
          }
              if(score/2*2<score){
                %>
                    <span class="glyphicon glyphicon-star half"></span>
                <%}
        %>
        &nbsp;&nbsp;&nbsp;
        <input type="button" class="btn btn-default ratefeedback-btn-vuf" feedbackid="<%=result.getString("feedbackid")%>" value="Very useful">
        <input type="button" class="btn btn-default ratefeedback-btn-uf" feedbackid="<%=result.getString("feedbackid")%>" value="Useful">
        <input type="button" class="btn btn-default ratefeedback-btn-ul" feedbackid="<%=result.getString("feedbackid")%>" value="Useless">
        &nbsp;&nbsp;&nbsp;
        <div class="ratefeedbacksuccess" feedbackid="<%=result.getString("feedbackid")%>">Rate success.</div>
        <div class="ratefeedbackrateself" feedbackid="<%=result.getString("feedbackid")%>">Don't rate your feedback.</div>
      </div>
      <div class="userrating" feedbackid="<%=result.getString("feedbackid")%>">
        <input type="button" class="btn btn-default userrating-trust" feedbackid="<%=result.getString("feedbackid")%>" value="Trusted">
        <input type="button" class="btn btn-default userrating-untrust" feedbackid="<%=result.getString("feedbackid")%>" value="Untrusted">
        <div class="warning rateusersuccess" feedbackid="<%=result.getString("feedbackid")%>">Rate success.</div>
        <div class="warning rateuserfailed" feedbackid="<%=result.getString("feedbackid")%>">Don't rate yourself.</div>
      </div>
      <div class="feedbackinfo-container">
        <label class="feedbackinfo-optionaltext"><%=result.getString("optional_text")%></label>
      </div>
      <hr class="bookinfo-divider">
      <%}
      } catch (Exception e) {}
      %>
    </div>
<%
  try {
    result = fd.topnusefulfeedbacks(ISBN, connector.stmt);
  } catch (Exception e) {
  e.printStackTrace();
  }%>


  <div class="topfeedbackinfo-container">
    <%
      try{
        while(result.next()){
          feedbacknum++;
          %>
    <div class="chooseablerow" feedbackid="<%=feedbacknum%>">
      <div class="feedbackinfo-container">
        <label class="feedbackinfo-user" feedbackid="<%=result.getString("feedbackid")%>"><%=result.getString("loginname")%></label>
        <label class="feedbackinfo-date">&nbsp;&nbsp;&nbsp;<%=result.getString("date")%>&nbsp;&nbsp;&nbsp;</label>
        <%
          int score = Integer.parseInt(result.getString("score"));
          for(int j = 0;j<score/2;j++)
          {
        %>
        <span class="glyphicon glyphicon-star"></span>
        <%
          }
          if(score/2*2<score){
        %>
        <span class="glyphicon glyphicon-star half"></span>
        <%}
        %>
        &nbsp;&nbsp;&nbsp;
        <input type="button" class="btn btn-default ratefeedback-btn-vuf" feedbackid="<%=result.getString("feedbackid")%>" value="Very useful">
        <input type="button" class="btn btn-default ratefeedback-btn-uf" feedbackid="<%=result.getString("feedbackid")%>" value="Useful">
        <input type="button" class="btn btn-default ratefeedback-btn-ul" feedbackid="<%=result.getString("feedbackid")%>" value="Useless">
        &nbsp;&nbsp;&nbsp;
        <div class="ratefeedbacksuccess" feedbackid="<%=result.getString("feedbackid")%>">Rate success.</div>
        <div class="ratefeedbackrateself" feedbackid="<%=result.getString("feedbackid")%>">Don't rate your feedback.</div>
        <label class="feedbackinfo-usefulratingscore">&nbsp;&nbsp;&nbsp;Usefulness score:&nbsp;<%=result.getString("AA")%></label>
      </div>
      <div class="userrating" feedbackid="<%=result.getString("feedbackid")%>">
        <input type="button" class="btn btn-default userrating-trust" feedbackid="<%=result.getString("feedbackid")%>" value="Trusted">
        <input type="button" class="btn btn-default userrating-untrust" feedbackid="<%=result.getString("feedbackid")%>" value="Untrusted">
        <div class="warning rateusersuccess" feedbackid="<%=result.getString("feedbackid")%>">Rate success.</div>
        <div class="warning rateuserfailed" feedbackid="<%=result.getString("feedbackid")%>">Don't rate yourself.</div>
      </div>
      <div class="feedbackinfo-container">
        <label class="feedbackinfo-optionaltext"><%=result.getString("optional_text")%></label>
      </div>
        <hr class="bookinfo-divider">
    </div>
    <%}
    } catch (Exception e) {}
    %>
  </div>
    <script>
      $(document).ready(function() {
        var checker = false;
        var timeout;
        $(".topnumber").val(<%=feedbacknum%>);
        $(".topfeedback-checkbox").click(function() {
          if(!checker) {
            checker = true;
            $(".all-feedbackinfo-container").slideUp(300);
            var sn = $(".topnumber").val();
            var n = 0;
            if(sn!="")
            {
              n=parseInt(sn);
            }
            if(n<0) {
              n=0;
            }
            for (var i = 1; i <=<%=feedbacknum%>; i++) {
              if (i > n) {
                $(".chooseablerow[feedbackid='" + i.toString() + "']").hide();
              }
              else {
                $(".chooseablerow[feedbackid='" + i.toString() + "']").show();
              }

            }
            clearTimeout(timeout);
            timeout=setTimeout(function() {
              $(".topfeedbackinfo-container").slideDown(300);
            },300)

          }
          else{
            checker = false;
            $(".topfeedbackinfo-container").slideUp(300);
            clearTimeout(timeout);
            timeout=setTimeout(function (){
              $(".all-feedbackinfo-container").slideDown(300);
            },300);

          }
        });
      });
    </script>
  </div>
<div class="givefeedback-container">
  <div class="feedback-title">Give a feedbacks</div>
  <hr class="bookinfo-divider">
  <div class="givedetail-container">
    <div class="givescore">Give a score(0~10):&nbsp;&nbsp;
      <input type="number" class="form-control givefeedback-score">
    </div>
    <div class="givecomment">
      Comment:&nbsp;&nbsp;
      <textarea class="form-control givefeedback-comment"></textarea>
    </div>
    <div class="submitbtn">
      <div class="warning scoreinputwarning">You must give a score from 0 to 10.</div>
      <div class="warning doubleinputwarning">Don't give a feedback to a book twice.</div>
      <div class="warning feedbacksuccess">Thank you for your feedback.</div>
      <input type="button" class="btn btn-default givefeedback-btn" value="Submit">
    </div>
    <div class="blank">
    </div>
  </div>
</div>
</body>
</html>
