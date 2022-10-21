<%@ page language="java" contentType="text/html; charset=euc-kr" %>
<%@ page import="java.util.*, acar.util.*, acar.user_mng.*" %>
<%@ include file="/acar/cookies.jsp" %>
<jsp:useBean id="bme_bean" class="acar.user_mng.MenuBean" scope="page"/>
<jsp:useBean id="mme_bean" class="acar.user_mng.MenuBean" scope="page"/>
<jsp:useBean id="sme_bean" class="acar.user_mng.MenuBean" scope="page"/>


<%
	UserMngDatabase umd = UserMngDatabase.getInstance();
	
	int count = 0;

	String cmd = request.getParameter("cmd")==null?"":request.getParameter("cmd");
	String ud_id = request.getParameter("ud_id")==null?"":request.getParameter("ud_id");
	String idnum = request.getParameter("idnum")==null?"":request.getParameter("idnum");
	
	String uid2 = request.getParameter("uid2")==null?"":request.getParameter("uid2");
	String user_id = request.getParameter("user_id")==null?"":request.getParameter("user_id");

	if(cmd.equals("d")){

		String del_id = "";
	
		del_id += ud_id+"/";
	
		umd.UdateUser_group2(del_id, user_id);
	}else{
	
		String u_id 	= "";
		String r_id 	= "";
		String full_id = "";

		u_id 	= uid2.substring(0,6);
		r_id 	= uid2.substring(7);

		full_id += u_id+"/";
	
		if(uid2.substring(0,1).equals("0")){
			umd.UdateUser_group(full_id, r_id);
		}	

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
<form action="" name="AuthForm" method="POST" >
</form>
<script>
<%	if(cmd.equals("d")){%>
	alert("정상적으로 삭제되었습니다.");
	parent.self_reload();	
<%	}else{%>
	parent.self_reload();
	alert("정상적으로 등록되었습니다.");
<%}%>
</script>
</body>
</html>
