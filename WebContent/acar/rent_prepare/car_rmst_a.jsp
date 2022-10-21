<%@ page language="java" contentType="text/html;charset=euc-kr" %>
<%@ page import="java.util.*, acar.util.*, acar.res_search.*"%>
<jsp:useBean id="rs_db" scope="page" class="acar.res_search.ResSearchDatabase"/>
<%@ include file="/acar/cookies.jsp" %>

<html>
<head>
<title>FMS</title>
<link rel=stylesheet type="text/css" href="/include/table_t.css">
<script language='JavaScript' src='../../include/common.js'></script>
</head>
<body leftmargin="15">
<%
	String auth_rw 	= request.getParameter("auth_rw")==null?"":request.getParameter("auth_rw");
	String user_id 	= request.getParameter("user_id")==null?"":request.getParameter("user_id");
	String br_id 	= request.getParameter("br_id")==null?"":request.getParameter("br_id");
	String s_cd 	= request.getParameter("s_cd")==null?"":request.getParameter("s_cd");
	
	String c_id 	= request.getParameter("c_id")==null?"":request.getParameter("c_id");
	String car_no 	= request.getParameter("car_no")==null?"":request.getParameter("car_no");	
	
	String rm_st 	= request.getParameter("rm_st")==null?"":request.getParameter("rm_st");
	String rm_cont 	= request.getParameter("rm_cont")==null?"":request.getParameter("rm_cont");
	String checker 	= request.getParameter("checker")==null?"":request.getParameter("checker");
	
	int count = 1;
	int count2 = 0;
	if(checker.equals("")){
	checker = user_id;
	}
	count = rs_db.updateCarRmSt(c_id, rm_st, rm_cont, checker);	
%>
<script language='javascript'>
<%	if(count == 1){%>
		alert('정상적으로 처리되었습니다');
		parent.window.close();
		//parent.opener.location.reload();
<%	}else{ //에러%>
		alert('처리되지 않았습니다\n\n에러발생!');
<%	}%>
<%	if(count2 == 1){%>
		parent.window.close();
		//parent.opener.location.reload();
<%	}%>
</script>
</body>
</html>
