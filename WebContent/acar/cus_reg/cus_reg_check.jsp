<%@ page language="java" contentType="text/html; charset=euc-kr" %>
<%@ page import="java.util.*, acar.util.*, acar.client.*"%>
<jsp:useBean id="al_db" scope="page" class="acar.client.AddClientDatabase"/>
<%@ include file="/acar/cookies.jsp" %>
<%
	String auth_rw = request.getParameter("auth_rw")==null?"":request.getParameter("auth_rw");
	String user_id = request.getParameter("user_id")==null?"":request.getParameter("user_id");
	String br_id = request.getParameter("br_id")==null?"":request.getParameter("br_id");
	String s_kd = request.getParameter("s_kd")==null?"":request.getParameter("s_kd");
	String t_wd = request.getParameter("t_wd")==null?"":request.getParameter("t_wd");
	
	Vector clients = al_db.getClientList(s_kd, t_wd, "0");
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
	parent.opener.location.href = "./cus0401_d_sc_carinfo.jsp?auth_rw=<%= auth_rw %>&car_mng_id=<%= car_mng_id %>&rent_mng_id=<%= rent_mng_id %>&rent_l_cd=<%= rent_l_cd %>";
	parent.close();
<%}else if(client_size == 1){ %>
	parent.location.href = "./cus0401_d_sc_regMaint.jsp?auth_rw=<%= auth_rw %>&car_mng_id=<%= car_mng_id %>";
	this.close();
<%}else{ %>
	alert("해당하는 업체가 없습니다!");
	this.close();	
<%}%>
</script>
</body>
</html>
