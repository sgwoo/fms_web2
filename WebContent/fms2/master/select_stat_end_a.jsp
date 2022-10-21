<%@ page language="java" contentType="text/html;charset=euc-kr" %>
<%@ page import="java.util.*, acar.util.*, acar.admin.*"%>
<jsp:useBean id="ad_db" scope="page" class="acar.admin.AdminDatabase"/>
<%@ include file="/acar/cookies.jsp" %>

<html>
<head><title>FMS</title>
</head>
<meta http-equiv="Content-Type" content="text/html; charset=euc-kr">
<link rel=stylesheet type="text/css" href="/include/table.css">

<body leftmargin="15">
<%
	String auth_rw = request.getParameter("auth_rw")==null?"":request.getParameter("auth_rw");
	String br_id = request.getParameter("br_id")==null?"":request.getParameter("br_id");
	String user_id = request.getParameter("user_id")==null?"":request.getParameter("user_id");
	int flag3 = 0;
	
	String  d_flag =  ad_db.call_sp_stat_rent_mon_magam();
   	if (!d_flag.equals("0")) flag3 = 1;
   	System.out.println("계약현황 =" + d_flag);
%>
<script language='javascript'>
<%	if(flag3 != 0){  %>
		alert('계약현황 마감등록 오류 발생!');
<%	}else{		%>
		alert("처리되었습니다");
		parent.location.reload();
<%	}			%>
</script>