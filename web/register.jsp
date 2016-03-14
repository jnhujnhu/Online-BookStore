<%--
  Created by IntelliJ IDEA.
  User: Kevin
  Date: 6/10/15
  Time: 7:22 PM
  To change this template use File | Settings | File Templates.
--%>
<%@ page contentType="text/html;charset=UTF-8" language="java" %>

<script>
  function checkreguser(){
    var username = $("#reg-username").val();
    var res = false;
    $.getJSON("checkuser.jsp?username=" + username +"&ismanager=false", function(data) {
      if (data.result == true) {
        $(".reguser-empty-warning").slideUp(300);
        $(".reguser-exist-warning").slideDown(300);
        res = false;
      }
      else if(username!=""){
        $(".reguser-empty-warning").slideUp(300);
        $(".reguser-exist-warning").slideUp(300);
        res = true;
      }
      else
      {
        $(".reguser-empty-warning").slideDown(300);
        $(".reguser-exist-warning").slideUp(300);
        res = false;
      }
    });
    return res;
  }
  function checkregpassword()
  {
    var password = $("#reg-password").val();
    var res;
    if(password != "")
    {
      $(".password-empty-warning").slideUp(300);
      res = true;
    }
    else
    {
      $(".password-empty-warning").slideDown(300);
      res = false;
    }
    return res;
  }
  function reenterpassword()
  {
    var password = $("#reg-password").val();
    var repassword = $("#repassword").val();
    var res;
    console.log(password);
    console.log(repassword);
    console.log(repassword == password);
    if(password != repassword)
    {
      $(".repassword-incorrect-warning").slideDown(300);
      res = false;
    }
    else if(password == repassword && password != "")
    {
      $(".repassword-incorrect-warning").slideUp(300);
      res = true;
    }
    else
    {
      res = false;
    }
    return res;
  }
  function regsubmit() {
    $.ajaxSetup({ async: false });
    var res = checkreguser() && checkregpassword() && reenterpassword();
    $.ajaxSetup({ async: true });
    return res;
  }
  $(document).ready(function () {
    $(".reg-btn-submit").click(function () {
      return regsubmit();
    });
  });
</script>

<body>
<div class="reg-container">
  <div class="box reg-box">
    <div class="box-title">Registration</div>
    <form class="form-horizontal login-form" method="post" action="register_impl.jsp">
      <div class="login-row">
        <label class="login-label">Username</label>
        <input class="form-control login-info" name="reg-username" id="reg-username" onblur="checkreguser()" placeholder="username"/>
        <div class="warning reguser-exist-warning">User name existed.</div>
        <div class="warning reguser-empty-warning">User name cannot be empty.</div>
      </div>
      <div class="login-row">
        <label class="login-label">Password</label>
        <input class="form-control login-info"  name="reg-password" id="reg-password" type="password" onblur="checkregpassword()" placeholder="password"/>
        <div class="warning password-empty-warning">Password cannot be empty.</div>
      </div>
      <div class="login-row">
        <label class="login-label">Confirm password</label>
        <input class="form-control login-info"  name="repassword" id="repassword" type="password" onblur="reenterpassword()" placeholder="re-enter the password"/>
        <div class="warning repassword-incorrect-warning">Password mismatch.</div>
      </div>
      <div class="login-row">
        <label class="login-label">Fullname</label>
        <input class="form-control login-info"  name="fullname" id="fullname" placeholder="fullname"/>
      </div>
      <div class="login-row">
        <label class="login-label">Address</label>
        <input class="form-control login-info"  name="address" id="address" placeholder="address"/>
      </div>
      <div class="login-row">
        <label class="login-label">Phone number</label>
        <input class="form-control login-info"  name="phonenumber" id="phonenumber" placeholder="phone number"/>
      </div>
      <div class="login-row">
        <input type="submit" class="btn btn-primary reg-btn-submit" value="Submit">
      </div>
    </form>
  </div>
</div>
</body>

