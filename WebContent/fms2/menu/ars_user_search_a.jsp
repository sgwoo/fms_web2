<%@ page language="java" contentType="text/html; charset=euc-kr" %>
<%@ page import="java.util.*, acar.util.*, acar.user_mng.*" %>
<%@ include file="/acar/cookies.jsp" %>

<%
	UserMngDatabase umd = UserMngDatabase.getInstance();
	
	int count = 0;

	String user_id = request.getParameter("user_id")==null?"":request.getParameter("user_id");
	String dept_id = request.getParameter("dept_id")==null?"":request.getParameter("dept_id");
	String loan_st = request.getParameter("loan_st")==null?"":request.getParameter("loan_st");
	
	String go_url = request.getParameter("go_url")==null?"":request.getParameter("go_url");
	
	String vid[] = request.getParameterValues("ars_partner_id");
	
	String ars_group = "";
	
	for(int i=0; i < vid.length; i++){
		ars_group = ars_group + vid[i];
		if(i==0){
			ars_group = ars_group + "/";
		}
	}
	
	if(ars_group.equals("/")){
		ars_group = "";
	}
	
	umd.UdateArs_group(ars_group, user_id);

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
<form action="" name="AuthForm" method="POST" >
</form>
<script>
	alert("정상적으로 등록되었습니다.");
	<%if(go_url.equals("homework_sh.jsp")){%>
	<%}else{%>
	parent.self_reload();
	<%}%>
</script>
</body>
</html>
