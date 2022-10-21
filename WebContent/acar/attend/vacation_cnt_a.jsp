<%@ page language="java" contentType="text/html;charset=euc-kr" %>
<%@ page import="java.util.*, acar.util.*, acar.attend.*"%>

<%//@ include file="/acar/cookies.jsp" %>

<html>
<head>
<title>FMS</title>
<link rel=stylesheet type="text/css" href="/include/table_t.css">
<script language='JavaScript' src='../../include/common.js'></script>
</head>
<body leftmargin="15">
<%
	String auth_rw = request.getParameter("auth_rw")==null?"":request.getParameter("auth_rw");
	String user_id = request.getParameter("user_id")==null?"":request.getParameter("user_id");
	String br_id = request.getParameter("br_id")==null?"":request.getParameter("br_id");
	
	String reg_dt = request.getParameter("reg_dt")==null?"":request.getParameter("reg_dt");
	String cnt_su = request.getParameter("cnt_su")==null?"":request.getParameter("cnt_su");

	int count = 1;
	VacationDatabase v_db = VacationDatabase.getInstance();

	count = v_db.insertCNT_SU(cnt_su, user_id);
	
%>
<script language='javascript'>
<%	if(count == 1){%>
		alert('정상적으로 처리되었습니다');
		parent.window.close();
		parent.opener.location.reload();
<%	}else{ //에러%>
		alert('처리되지 않았습니다\n\n에러발생!');
<%	}%>

</script>
</body>
</html>
