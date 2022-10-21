<%@ page language="java" contentType="text/html; charset=euc-kr" %>
<%@ page import="java.util.*, acar.util.*, acar.client.*"%>
<jsp:useBean id="al_db" scope="page" class="acar.client.AddClientDatabase"/>
<%@ include file="/acar/cookies.jsp" %>
<%
	String auth_rw = request.getParameter("auth_rw")==null?"":request.getParameter("auth_rw");
	String br_id = request.getParameter("br_id")==null?"":request.getParameter("br_id");
	String user_id = request.getParameter("user_id")==null?"":request.getParameter("user_id");
	String s_kd = request.getParameter("s_kd")==null?"":request.getParameter("s_kd");
	String t_wd = request.getParameter("t_wd")==null?"":request.getParameter("t_wd");
	String asc = request.getParameter("asc")==null?"0":request.getParameter("asc");
	String from_page = request.getParameter("from_page")==null?"":request.getParameter("from_page");  //popup 요청한 페이지
	
	String s_gubun1 = request.getParameter("s_gubun1")==null?"":request.getParameter("s_gubun1");
	String cng_gubun = request.getParameter("cng_gubun")==null?"":request.getParameter("cng_gubun");
	
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
	var SUBWIN="./cr_l_visit.jsp?auth_rw=<%=auth_rw%>&br_id=<%=br_id%>&user_id=<%=user_id%>&s_kd=<%=s_kd%>&t_wd=<%=t_wd%>&asc=<%=asc%>&from_page=<%=from_page%>&s_gubun1=<%= s_gubun1 %>&cng_gubun=<%= cng_gubun %>";
	window.open(SUBWIN, "clientList", "left=100, top=200, width=1240, height=800, scrollbars=yes");
<%}else if(client_size == 1){
	Hashtable client = (Hashtable)clients.elementAt(0);%>
	<%if(cng_gubun.equals("post")){%>
	parent.location.href = "/fms2/client/client_cont_cng.jsp?client_id=<%= client.get("CLIENT_ID") %>&auth_rw=<%=auth_rw%>&br_id=<%=br_id%>&user_id=<%=user_id%>&s_kd=<%=s_kd%>&t_wd=<%=t_wd%>&asc=<%=asc%>&from_page=<%=from_page%>";	
	<%}else{%>	
	parent.location.href = "client_email.jsp?client_id=<%= client.get("CLIENT_ID") %>&auth_rw=<%=auth_rw%>&br_id=<%=br_id%>&user_id=<%=user_id%>&s_kd=<%=s_kd%>&t_wd=<%=t_wd%>&asc=<%=asc%>&from_page=<%=from_page%>";	
	<%}%>
<%}else{ %>
	alert("해당하는 업체가 없습니다!");
<%}%>
</script>
</body>
</html>
