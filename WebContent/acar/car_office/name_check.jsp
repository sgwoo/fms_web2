<%@ page language="java" contentType="text/html; charset=euc-kr" %>
<%@ page import="java.util.*, acar.util.*"%>
<%@ page import="acar.car_office.*" %>
<%@ include file="/acar/cookies.jsp" %>
<%
	String auth_rw = request.getParameter("auth_rw")==null?"":request.getParameter("auth_rw");
	String name = request.getParameter("name")==null?"":request.getParameter("name");
	String from_page = request.getParameter("from_page")==null?"":request.getParameter("from_page");

	CarOfficeDatabase cod = CarOfficeDatabase.getInstance();
	Vector names = cod.getNameList(name);
	int name_size = names.size();
	
%>
<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN">
<html>
<head>
<title>FMS</title>
<meta http-equiv="Content-Type" content="text/html; charset=euc-kr">
<link rel=stylesheet type="text/css" href="/include/table.css">
</head>

<body>
<script language='javascript'>
<%if(from_page.equals("/acar/car_office/car_office_p_u.jsp")){%>
<%	if(name_size > 1){ %>
	var SUBWIN="./name_list.jsp?auth_rw=<%= auth_rw %>&name=<%= name %>";
	window.open(SUBWIN, "nameList", "left=100, top=100, width=750, height=300, scrollbars=yes");
<%	}else{%>
	alert("중복된 성명이 없습니다.");
	parent.document.CarOffEmpForm.emp_h_tel.focus();
<%	}%>
<%}else{%>
<%	if(name_size > 0){ %>
	var SUBWIN="./name_list.jsp?auth_rw=<%= auth_rw %>&name=<%= name %>";
	window.open(SUBWIN, "nameList", "left=100, top=100, width=750, height=300, scrollbars=yes");
<%	}else{%>
	alert("중복된 성명이 없습니다.");
	parent.document.CarOffEmpForm.emp_h_tel.focus();
<%	}%>
<%}%>
</script>
</body>
</html>
