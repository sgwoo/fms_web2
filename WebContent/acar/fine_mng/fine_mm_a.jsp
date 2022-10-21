<%@ page language="java" contentType="text/html;charset=euc-kr" %>
<%@ page import="java.util.*, acar.fee.*, acar.util.*,acar.fee.*, acar.cont.*"%>
<jsp:useBean id="a_db" scope="page" class="acar.cont.AddContDatabase"/>
<%@ include file="/acar/cookies.jsp" %>

<html>
<head><title>FMS</title>
</head>
<meta http-equiv="Content-Type" content="text/html; charset=euc-kr">
<link rel=stylesheet type="text/css" href="/include/table.css">

<body leftmargin="15">
<%
	int flag = 0;
	
	String m_id 		= request.getParameter("m_id");
	String l_cd 		= request.getParameter("l_cd");
	String fine_mm		= request.getParameter("fine_mm");
	
	if(!a_db.updateFineMM(m_id, l_cd, fine_mm)) flag+=1;
%>
<script language='javascript'>
<%	if(flag != 0){%>
		alert("수정되지 않았습니다");
		location='about:blank';		
<%	}else{		%>		
		alert("수정되었습니다");
		parent.location.reload();
<%	}			%>
</script>