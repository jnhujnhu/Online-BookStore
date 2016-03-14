<%--
  Created by IntelliJ IDEA.
  User: Kevin
  Date: 6/10/15
  Time: 7:22 PM
  To change this template use File | Settings | File Templates.
--%>
<%@ page contentType="text/html;charset=UTF-8" language="java" %>


<script>
    function checkuser(){
        var username = $("#username").val();
        var checked;
        var o=document.getElementsByName("checkbox");
        for(var i =0; i <o.length; i++) {
            if (o[i].checked) {
                checked = "true";
            }
            else{
                checked = "false";
            }
        }
        var res;
        $.getJSON("checkuser.jsp?username=" + username +"&ismanager=" + checked, function(data) {
            if (data.result == false) {
                if(username != "") {
                    $(".user-empty-warning").slideUp(300);
                    $(".user-exist-warning").text("Username " + username + " does not exist.").slideDown(300);
                }
                else{
                    $(".user-empty-warning").slideDown(300);
                    $(".user-exist-warning").slideUp(300);
                }
                res = false;
            }
            else {
                $(".user-empty-warning").slideUp(300);
                $(".user-exist-warning").slideUp(300);
                res = true;
            }
        });
        return res;
    }

    function checkpassword() {
        var username = $("#username").val();
        var password = $("#password").val();
        var checked;
        var o=document.getElementsByName("checkbox");
        for(var i =0; i <o.length; i++) {
            if (o[i].checked) {
                checked = "true";
            }
            else{
                checked = "false";
            }
        }
        var res;
        $.getJSON("checkpassword.jsp?username=" + username + "&password=" + password +"&ismanager=" + checked , function(data) {
            if (data.result == false) {
                $(".password-incorrect-warning").slideDown(300);
                res = false;
            }
            else {
                $(".password-incorrect-warning").slideUp(300);
                res = true;
            }
        });
        return res;
    }

    function loginsubmit() {
        $.ajaxSetup({ async: false });
        var res = checkuser() && checkpassword();
        $.ajaxSetup({ async: true });
        return res;
    }

    $(document).ready(function() {
        $(".m-checkbox").click(function () {
            var o=document.getElementsByName("checkbox");
            for(var i =0; i <o.length; i++) {
                if (o[i].checked) {
                    $(".login-username").val("Administer");
                    $(".login-username").attr("disabled", true);
                    checkuser();
                }
                else {
                    $(".login-username").val("");
                    $(".login-username").attr("disabled", false);
                }
            }
        });
        $(".login-btn-submit").click(function () {
            return loginsubmit();
        });
    });
</script>
<body>
<div class="container">
    <div class="box login-box">
        <div class="box-title">Login</div>
        <form class="form-horizontal login-form" method="post" action="index_impl.jsp">
            <div class="login-row">
                <label class="login-label">Username</label>
                <input class="form-control login-info login-username" id="username" name="username" placeholder="username" onblur="checkuser()"/>
                <div class="warning user-exist-warning"></div>
                <div class="warning user-empty-warning">User name cannot be empty.</div>
            </div>
            <div class="login-row">
                <label class="login-label">Password</label>
                <input class="form-control login-info" type="password" id="password" name="password" placeholder="password" onblur="checkpassword()"/>
                <div class="warning password-incorrect-warning">Password incorrect.</div>
            </div>
            <div class="login-row">
                <label class="login-checkbox"><input class="m-checkbox" id="checkbox" name="checkbox" type="checkbox">  Login as manager</label>
                <input type="submit" class="btn btn-primary login-btn-submit" value="Login">
            </div>
        </form>
    </div>
</div>
</body>

