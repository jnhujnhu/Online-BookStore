<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ page import="pj.*" %>
<%
  String ISBN = request.getParameter("isbn");
  String title = request.getParameter("title");
  String price = request.getParameter("price");
  String format = request.getParameter("format");
  String publisher = request.getParameter("publisher");
  String keywords = request.getParameter("keywords");
  String year = request.getParameter("year");
  String number = request.getParameter("number");

  int subnum = Integer.parseInt(request.getParameter("subnum"));
  int autnum = Integer.parseInt(request.getParameter("autnum"));
  String[] subjects = new String[100];
  String[] authors = new String[100];
  int rsubnum = 0;
  int rautnum = 0;
  for(int i=0;i<=subnum;i++)
  {
    String temp = request.getParameter(String.format("sub%d",i));
    if(temp!=null) {
      subjects[rsubnum++] = temp;
    }
  }
  for(int i=0;i<=autnum;i++)
  {
    String temp = request.getParameter(String.format("aut%d",i));
    if(temp!=null) {
      authors[rautnum++] = temp;
    }
  }
  Connector con = new Connector();
  Book bk = new Book();
  try {
    bk.insertabook(ISBN, title, Float.parseFloat(price), format, publisher, keywords, Integer.parseInt(year), Integer.parseInt(number), rautnum, authors, rsubnum, subjects, con.stmt);
  } catch (Exception e) {
    e.printStackTrace();
  }
  response.sendRedirect(request.getContextPath() + "/");
%>