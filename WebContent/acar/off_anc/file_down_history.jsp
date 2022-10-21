<%@ page language="java" contentType="text/html; charset=euc-kr" %>
<%@ page import="java.util.*, acar.util.*, acar.off_anc.*, acar.common.*" %>
<%@ include file="/acar/cookies.jsp" %>

<%
	String file_nm 	= request.getParameter("file_nm")==null?"":request.getParameter("file_nm");
	String user_id 	= request.getParameter("user_id")==null?"":request.getParameter("user_id");
	
	CommonDataBase c_db = CommonDataBase.getInstance();
	
	System.out.println("사내게시판 파일 다운로드 : "+file_nm+", ("+c_db.getNameById(user_id,"USER")+")");
%>
<html>
<head><title>FMS</title>
<link rel=stylesheet type="text/css" href="/include/table.css">
</head>
<body>
</body>
</html>
