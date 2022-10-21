<%@ page language="java" contentType="text/html; charset=euc-kr" %>
<%@ page import="java.util.*, acar.util.*, acar.actn_scan.*, acar.user_mng.*" %>
<jsp:useBean id="as_db" scope="page" class="acar.actn_scan.Actn_scanDatabase"/>
<%@ include file="/acar/cookies.jsp" %>


<%
	
	
	String auth_rw = request.getParameter("auth_rw")==null?"":request.getParameter("auth_rw");
	String user_id = request.getParameter("user_id")==null?"":request.getParameter("user_id");
	
	String actn_su = request.getParameter("actn_su")==null?"":request.getParameter("actn_su");
	String actn_dt = request.getParameter("actn_dt")==null?"":request.getParameter("actn_dt");
	String actn_nm = request.getParameter("actn_nm")==null?"":request.getParameter("actn_nm");

	int count = 0;
	
	count = as_db.deleteActn_scan(actn_nm, actn_dt, actn_su);
	
%>
<html>
<head>
<title>FMS</title>

</head>
<script language="JavaScript">
<!--

//-->
</script>
<body>
<form name='form1' action='' method="POST" enctype="">
	<input type="hidden" name="auth_rw" value="<%=auth_rw%>">
	<input type='hidden' name='user_id' value='<%=user_id%>'>

</form>
<script language="JavaScript">
<!--
	var fm = document.form1;

<%	if(count==1){ %>
		alert("정상적으로 삭제되었습니다.");
		fm.action='actn_scan_sc_in.jsp';
		//parent.close();					
		fm.submit();
<%}else{ %>
	alert("오류입니다!!!!!!!!!!!!!!!");
<%}%>
//-->
</script>
</body>

</html>
