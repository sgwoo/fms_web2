<%@ page language="java" contentType="text/html;charset=euc-kr" %>
<%@ page import="java.util.*, acar.util.*, acar.common.* "%>
<jsp:useBean id="sc_db" scope="page" class="acar.car_scrap.ScrapDatabase"/>
<%@ include file="/agent/cookies_base.jsp" %>

<%
	String seq 			= 	request.getParameter("seq")			==null?"":request.getParameter("seq");
	String car_no 		= 	request.getParameter("car_no")		==null?"":request.getParameter("car_no");
	String keep_etc 	= 	request.getParameter("keep_etc")	==null?"":request.getParameter("keep_etc");

	CommonDataBase c_db = CommonDataBase.getInstance();
	
	int result = 0; 
	
	result = sc_db.updateOneCarScrap(seq, car_no, "", keep_etc, "keep_etc");
%> 

<html>
<head>
<title>FMS</title>
<meta http-equiv="Content-Type" content="text/html; charset=euc-kr ">
<link rel=stylesheet type="text/css" href="/include/table_t.css">
<script language='JavaScript' src='/include/common.js'></script>
<script language='javascript'>
</script>
</head>
<body>
<script type="text/javascript">
<%if(result==1){%>
	alert("수정되었습니다.");
<%}else{%>
	alert("수정중 오류발생!");
<%}%>
	window.close();
</script>
</body>
</html>