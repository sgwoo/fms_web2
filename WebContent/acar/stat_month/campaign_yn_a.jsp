<%@ page language="java" contentType="text/html;charset=euc-kr"%>
<%@ page import="java.util.*, acar.util.*, acar.stat_bus.*"%>
<jsp:useBean id="cmp_db" scope="page" class="acar.stat_bus.CampaignDatabase"/>
<%@ include file="/acar/cookies.jsp"%>

<%
	String auth_rw 		= request.getParameter("auth_rw")	==null?"":request.getParameter("auth_rw"); 	//권한
	String user_id 		= request.getParameter("user_id")	==null?"":request.getParameter("user_id");	//로그인-ID
	String br_id 		= request.getParameter("br_id")		==null?"":request.getParameter("br_id");	//로그인-영업소
	
	String save_dt 		= request.getParameter("save_dt")	==null?"":request.getParameter("save_dt");
	String from_page 	= request.getParameter("from_page")	==null?"":request.getParameter("from_page");
	
	int result = 0;
	
	String vid1[] 		= request.getParameterValues("bus_cmp_user_id");
	
	for(int i=0;i < vid1.length;i++){
		String bus_cmp_yn 	= request.getParameter("bus_cmp_yn"+i)==null?"Y":request.getParameter("bus_cmp_yn"+i);
		result 	= cmp_db.updateBusCamYnUser(vid1[i], bus_cmp_yn);
	}
%>
<html>
<head><title>FMS</title>
<meta http-equiv="Content-Type" content="text/html; charset=euc-kr">
<link rel=stylesheet type="text/css" href="/include/table.css">
</head>
<body>
<form name='form1' action='' method="POST">
<input type='hidden' name='auth_rw' 	value='<%=auth_rw%>'>
<input type='hidden' name='user_id' 	value='<%=user_id%>'>
<input type='hidden' name='br_id' 	    value='<%=br_id%>'>
<input type='hidden' name='save_dt' 	value='<%=save_dt%>'>
<input type='hidden' name='from_page' 	value='<%=from_page%>'>
</form>
<script language="JavaScript">
<!--
	var fm = document.form1;
	fm.target = 'd_content';	
	fm.action = '<%=from_page%>';
	alert("수정되었습니다.");
	fm.submit();	
//-->
</script>
</body>
</html>
