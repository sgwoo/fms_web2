<%@ page language="java" contentType="text/html; charset=euc-kr" %>
<%@ page import="java.util.*, acar.util.*, acar.user_mng.*" %>
<%@ include file="/acar/cookies.jsp" %>
<jsp:useBean id="bme_bean" class="acar.user_mng.MenuBean" scope="page"/>
<jsp:useBean id="mme_bean" class="acar.user_mng.MenuBean" scope="page"/>
<jsp:useBean id="sme_bean" class="acar.user_mng.MenuBean" scope="page"/>

<%
	UserMngDatabase umd = UserMngDatabase.getInstance();
	
	int count = 0;
	
   	String vid[] = request.getParameterValues("auth_rw");
	String user_id 	="";
	String m_st 	="";
	String m_st2 	="";
	String m_cd		= "";
	String auth_rw	= "";
	
	int vid_size = vid.length;
	
	for(int i=0; i < vid_size; i++){
		user_id 	= vid[i].substring(0,6);
		m_st 		= vid[i].substring(6,8);
		m_st2 		= vid[i].substring(8,10);
		m_cd 		= vid[i].substring(10,12);
		auth_rw 	= vid[i].substring(12);
		
	    umd.insertAuthUserCase(user_id, m_st, m_st2, m_cd, auth_rw);
	}
%>

<html>
<head>

<title>FMS</title>
<link rel="stylesheet" type="text/css" href="/include/table_t.css">
<script language='JavaScript' src='/include/common.js'></script>
<script language="JavaScript">
<!--

//-->
</script>
<style type=text/css>

<!--
.style1 {color: #666666}
.style2 {color: #515150; font-weight: bold;}
.style3 {color: #b3b3b3; font-size: 11px;}
.style4 {color: #737373; font-size: 11px;}
.style5 {color: #ef620c; font-weight: bold;}
.style6 {color: #4ca8c2; font-weight: bold;}
.style7 {color: #666666; font-size: 11px;}
-->

</style>
</head>
<body leftmargin="15">
<form action="./user_auth_i.jsp" name="AuthForm" method="POST" >
</form>
<script>
alert('처리되었습니다.');

</script>
</body>
</html>
