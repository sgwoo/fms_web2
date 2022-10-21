<%@ page language="java" contentType="text/html; charset=UTF-8" %>
<%@ page import="java.io.*, java.util.*, acar.util.*, acar.accid.*"%>
<%@ include file="/acar/cookies.jsp" %>

<%
		
	String auth_rw = request.getParameter("auth_rw")==null?"":request.getParameter("auth_rw");
	String user_id = request.getParameter("user_id")==null?"":request.getParameter("user_id");//로그인-ID
	
	String doc_id 	= request.getParameter("doc_id")==null?"":request.getParameter("doc_id");
	String serv_dt = request.getParameter("serv_dt")==null?"":request.getParameter("serv_dt");

	AccidDatabase as_db = AccidDatabase.getInstance();
%>

<%
	int count = 0;
	boolean flag = true;
	int flag1 = 0;
	
	

		flag1 = as_db.updateServ_dt("법무"+doc_id,serv_dt);
	
	
%>
<html>
<head>
<title>FMS</title>
<meta http-equiv="content-type" content="text/html; charset=euc-kr">
<link rel="stylesheet" type="text/css" href="/include/table.css"></link>
<script language="JavaScript">
<!--
//-->
</script>
</head>
<body>

<script>
<%		if(flag1>0){%>
			alert("정상적으로 처리되었습니다.");
			self.close();
			parent.opener.location.reload();			
<%		}else{%>
			alert("에러발생!");
<%		}%>
</script>
</body>
</html>

