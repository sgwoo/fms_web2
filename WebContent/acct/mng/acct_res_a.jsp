<%@ page language="java" contentType="text/html; charset=euc-kr" %>
<%@ page import="java.util.*, acar.util.*, acar.user_mng.*, acct.* "%>
<jsp:useBean id="at_db" scope="page" class="acct.AcctDatabase"/>
<%@ include file="/acct/cookies.jsp" %>

<%	
	String auth_rw 	= request.getParameter("auth_rw")	==null?"":request.getParameter("auth_rw");
	String user_id 	= request.getParameter("user_id")	==null?"":request.getParameter("user_id");
	String br_id 	= request.getParameter("br_id")  	==null?"":request.getParameter("br_id");
	
	String save_dt 	= request.getParameter("save_dt")	==null?"":request.getParameter("save_dt");
	String acct_st 	= request.getParameter("acct_st")	==null?"":request.getParameter("acct_st");	
	String s_dt 	= request.getParameter("s_dt")		==null?"":request.getParameter("s_dt");
	String e_dt 	= request.getParameter("e_dt")		==null?"":request.getParameter("e_dt");	
	String seq 	= request.getParameter("seq")		==null?"":request.getParameter("seq");	
	
	
	boolean flag = true;
	
	flag = at_db.updateRes(save_dt, acct_st, s_dt, e_dt, seq, user_id);

%>


<html>
<head>
<title>FMS</title>
<meta http-equiv="Content-Type" content="text/html; charset=euc-kr">
<link rel="stylesheet" type="text/css" href="/acct/include/table_t.css"></link>
<script language='JavaScript' src='/include/common.js'></script>
<script language='javascript'>
<!--

//-->
</script>
</head>
<body leftmargin="15">
<script language='javascript'>
<!--
	<%if(!flag){%>
		alert('등록오류!!');
	<%}else{%>
		alert('등록되었습니다.');
		parent.opener.f_init();
		parent.window.close();
	<%}%>
//-->
</script>
</body>
</html>
