<%--
  Created by IntelliJ IDEA.
  User: Kevin
  Date: 6/20/15
  Time: 9:08 PM
  To change this template use File | Settings | File Templates.
--%>
<%@ page contentType="text/html;charset=UTF-8" language="java" %>

<script>
  var f = true;
  var df = true;
  var dclick = true;
  var timeout;
  $(document).ready(function() {
    $("#login-button").click(function() {
      if(f == true&& dclick == true) {
        dclick = false;
        $(".welcome-instruction").css("transition", "all ease 1s");
        var now = $(".welcome-instruction").css("margin-top");
        now = parseInt(now.replace("px", ""));
        if (!now) now = 0;
        $(".welcome-instruction").css("margin-top", now - 230);
        clearTimeout(timeout);
        timeout = setTimeout(function () {
          $(".login-box").fadeIn(300);
           $(".reg-box").fadeOut(300);
        }, 1000);
        setTimeout(function () {
          f = false;
          df = false;
          dclick = true;
        }, 1300);
      }
      else if(df == false) {
          $(".reg-box").fadeOut(300);
          clearTimeout(timeout);
          timeout = setTimeout(function () {
            $(".login-box").fadeIn(300);
          }, 300);
        }
    });
    $("#register-button").click(function() {
      if(f == true && dclick == true) {
        dclick = false;
        $(".welcome-instruction").css("transition", "all ease 1s");
        var now = $(".welcome-instruction").css("margin-top");
        now = parseInt(now.replace("px", ""));
        if (!now) now = 0;
        $(".welcome-instruction").css("margin-top", now - 230);
        clearTimeout(timeout);
        timeout = setTimeout(function () {
          $(".login-box").fadeOut(300);
          $(".reg-box").fadeIn(300);
        }, 1000);
        setTimeout(function () {
          f = false;
          df = false;
          dclick = true;
        }, 1300);
      }
      else if(df == false)
      {
        $(".login-box").fadeOut(300);
        clearTimeout(timeout);
        timeout = setTimeout(function () {
          $(".reg-box").fadeIn(300);
        }, 300);
      }

    });
    $(".navbar-brand").click(function() {
      if(f == false && dclick == true) {
        dclick = false;
        $(".welcome-instruction").css("transition", "all ease 1s");
        $(".login-box").fadeOut(300);
        $(".reg-box").fadeOut(300);
        clearTimeout(timeout);
        timeout = setTimeout(function () {
          var now = $(".welcome-instruction").css("margin-top");
          now = parseInt(now.replace("px", ""));
          if (!now) now = 0;
          $(".welcome-instruction").css("margin-top", now + 230);
        }, 300);
        df = true;
        setTimeout(function () {
          f = true;
          dclick = true;
        }, 1300);
      }
    });
  });
</script>

<body>
  <nav class="navbar navbar-default">
  <div class="container-fluid">

    <div class="navbar-header">
      <button type="button" class="navbar-toggle collapsed" data-toggle="collapse" data-target="#bs-collapse-1" aria-expanded="false">
        <span class="sr-only">Toggle navigation</span>
        <span class="icon-bar"></span>
        <span class="icon-bar"></span>
        <span class="icon-bar"></span>
      </button>
      <a class="navbar-brand" href="#">BookStore</a>
    </div>

    <div class="collapse navbar-collapse" id="bs-collapse-1">
      <ul class="nav navbar-nav">
        <li id="login-button"><a href="#">Login <span class="sr-only">(current)</span></a></li>
        <li id="register-button"><a href="#">Register</a></li>
      </ul>
    </div>
  </div>
</nav>
</body>
