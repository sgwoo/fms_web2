<%@ page language="java" contentType="text/html;charset=euc-kr" %>
<%@ page import="java.util.*, acar.util.*, acar.common.*"%>
<%@ include file="/acar/cookies.jsp" %>

<html>
<head>
<title>FMS</title>
<link rel=stylesheet type="text/css" href="/include/table.css">
<script language='JavaScript' src='../../include/common.js'></script>
</head>
<body leftmargin="15">

<%
	String cons_yn 	= request.getParameter("cons_yn")==null?"":request.getParameter("cons_yn");	
	String cmp_app 	= request.getParameter("cmp_app")==null?"":request.getParameter("cmp_app");	
	
	CommonDataBase c_db = CommonDataBase.getInstance();
	
		
	CodeBean code = c_db.getCodeBean("0022", cmp_app);		
%>
<script language='javascript'>

	var fm = parent.form1;
	
	fm.cons_yn.value = 'Y';
	fm.cons1_s_amt.value = parseDecimal(<%=code.getApp_st()%>) ;		
	fm.cons2_s_amt.value = parseDecimal(<%=code.getApp_st()%>) ;		
	
	parent.set_amt(fm.cons1_s_amt);
	parent.set_amt(fm.cons2_s_amt);
	
</script>
</body>
</html>
