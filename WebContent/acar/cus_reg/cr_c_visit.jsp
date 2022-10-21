<%@ page language="java" contentType="text/html; charset=euc-kr" %>
<%@ page import="java.util.*, acar.util.*, acar.client.*"%>
<jsp:useBean id="al_db" scope="page" class="acar.client.AddClientDatabase"/>
<%@ include file="/acar/cookies.jsp" %>
<%
	String auth_rw = request.getParameter("auth_rw")==null?"":request.getParameter("auth_rw");
	String s_gubun1 = request.getParameter("s_gubun1")==null?"":request.getParameter("s_gubun1");
	String s_kd = request.getParameter("s_kd")==null?"":request.getParameter("s_kd");
	String t_wd = request.getParameter("t_wd")==null?"":request.getParameter("t_wd");

	Vector clients = al_db.getClientList(s_kd.trim(), t_wd.trim(), "0");
	int client_size = clients.size();
	
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
<%if(client_size >= 2){ %>
	var SUBWIN="./cr_l_visit.jsp?auth_rw=<%= auth_rw %>&s_gubun1=<%= s_gubun1 %>&s_kd=<%= s_kd %>&t_wd=<%= t_wd %>";
	window.open(SUBWIN, "clientList", "left=100, top=200, width=340, height=200, resizable=yes, scrollbars=yes, status=yes");
<%}else if(client_size == 1){
	Hashtable client = (Hashtable)clients.elementAt(0);%>
	parent.parent.c_body.location.href = "cus_reg_visit.jsp?client_id=<%= client.get("CLIENT_ID") %>";	
<%}else{ %>
	alert("해당하는 업체가 없습니다!");
<%}%>
</script>
</body>
</html>
