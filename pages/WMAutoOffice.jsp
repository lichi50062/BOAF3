<%
//105.03.09 add 排程產檔至官網提供官網公示揭露查詢 by 2968
%>
<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="java.net.URLEncoder" %>
<%@ page import="com.tradevan.util.*" %>
<%
	  System.out.println("AutoOffice begin");
		AutoOffice a = new AutoOffice();
		a.exeOffice();
		System.out.println("AutoOffice end");

%>
<HTML>
<HEAD>
</HEAD>
<BODY>WMAutoOffice各機構營業項目
</BODY>

</HTML>




