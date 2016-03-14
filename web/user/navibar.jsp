<%--
  Created by IntelliJ IDEA.
  User: Kevin
  Date: 6/20/15
  Time: 9:08 PM
  To change this template use File | Settings | File Templates.
--%>
<%@ page contentType="text/html;charset=UTF-8" language="java" %>

<script>
  $(document).ready(function() {
    $(".searching-bar").focus(function () {
      $(".tips").slideDown(300);
    });

    $(".searching-bar").blur(function () {
      $(".tips").slideUp(300);
    });
  })
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
      <a class="navbar-brand" href="../">BookStore</a>
    </div>

    <div class="collapse navbar-collapse" id="bs-collapse-1">
      <ul class="nav navbar-nav">
        <li id="welcoming"><a href="#">Welcome, <%= username%> <span class="sr-only">(current)</span></a></li>
        <li id="logout-button"><a href="../logout.jsp">Logout</a></li>
        <li class="dropdown">
          <a href="#" class="dropdown-toggle" data-toggle="dropdown" role="button" aria-haspopup="true" aria-expanded="false">Functions <span class="caret"></span></a>
          <ul class="dropdown-menu">
            <li><a href="allorders.jsp">My orders</a></li>
            <li><a href="authorseparation.jsp">Author Separation</a></li>
            <li role="separator" class="divider"></li>
            <li><a href="about.jsp">About</a></li>
          </ul>
        </li>
      </ul>
      <form class="navbar-form navbar-left" role="search" action="bookbrowse.jsp">
        <div class="form-group" style="position: relative">
          <input type="text" class="form-control searching-bar" name="query" placeholder="Search">
          <div class="alert alert-success tips" role="alert">For example, "Database"(means book title contains "Database" by default) or "author = wen and publisher = zhou" or "subject=History or year = 1994" is acceptable. </div>
        </div>
        <button type="submit" class="btn btn-default">Search</button>
      </form>
    </div>
  </div>
</nav>
</body>
