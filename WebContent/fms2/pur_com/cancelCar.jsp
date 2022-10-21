<%@ page language="java" contentType="text/html; charset=euc-kr" %>
<%@ page import="java.util.*, acar.util.*, acar.secondhand.*, acar.car_office.*" %>
<jsp:useBean id="shDb" class="acar.secondhand.SecondhandDatabase" scope="page"/>
<%@ include file="/acar/cookies.jsp" %>

<%
	String auth_rw = request.getParameter("auth_rw")==null?"":request.getParameter("auth_rw");
	String com_con_no = request.getParameter("com_con_no")==null?"":request.getParameter("com_con_no");
	String seq 				= request.getParameter("shres_seq")==null?"":request.getParameter("shres_seq");
	String user_id = request.getParameter("user_id")==null?"":request.getParameter("user_id");
	int result = 0;
	
	CarOfficeDatabase cod = CarOfficeDatabase.getInstance();
	
	//취소처리
	String  d_flag1 =  shDb.call_sp_suc_res("cancel", com_con_no, seq, "", "");
%>

<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN">
<html>
<head>
<title>FMS</title>
<meta http-equiv="Content-Type" content="text/html; charset=euc-kr">
</head>

<body>
<script language="JavaScript">
<!--
<%if(d_flag1.equals("0")){%>
	alert("예약이 취소 되었습니다.");
	parent.location.reload();
<%}else{%>
	alert("데이터베이스에 문제가 발생하였습니다.\n 관리자님께 문의하세요 !");
<%}%>
//-->
</script>
</body>
</html>
