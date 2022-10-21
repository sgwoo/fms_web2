<%@ page language="java" contentType="text/html;charset=euc-kr"%>
<%@ page import="java.util.*, acar.util.*"%>
<jsp:useBean id="JsDb" scope="page" class="card.JungSanDatabase"/>

<%@ include file="/acar/cookies.jsp"%>

<%
	String st_year	= request.getParameter("st_year")==null?"":request.getParameter("st_year"); //년도
	String st_mon	= request.getParameter("st_mon")==null?"":request.getParameter("st_mon"); //분기
		
	int result  = JsDb.updateOilJungMagam(st_year, st_mon);
	
	%>
<html>
<head><title>FMS</title>
<meta http-equiv="Content-Type" content="text/html; charset=euc-kr">
<link rel=stylesheet type="text/css" href="/include/table.css">
</head>
<body>
<form name='form1' method="POST">
<input type='hidden' name='mode' value=''>
</form>
<script language="JavaScript">
	var fm = document.form1;
<%	if(result < 1 ){ 	//저장 실패%>
 
	 alert('등록 오류!!');

<%	}else{ 			//저장 성공.. %>
	
    alert('처리되었습니다');
    fm.action='/fms2/jungsan/mng_s_frame.jsp'; 
    fm.target='d_content';		
    fm.submit();
<%	
	} %>
</script>
</body>
</html>
