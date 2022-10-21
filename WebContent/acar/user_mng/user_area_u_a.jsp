<%@ page language="java" contentType="text/html; charset=euc-kr" %>
<%@ page import="java.util.*, acar.util.*, acar.user_mng.*" %>

<%@ include file="/acar/cookies.jsp" %>

<%
	//사용자별 정보 등록/수정 처리 페이지
	
	String user_id 		= request.getParameter("user_id")==null?"":request.getParameter("user_id");
	String area_id 		= request.getParameter("area_id")==null?"":request.getParameter("area_id");
	
	int count = 0;
	
	UserMngDatabase umd = UserMngDatabase.getInstance();

	count = umd.updateUseArea(user_id, area_id);
%>
<html>
<head>
<title>FMS</title>
<meta http-equiv="content-type" content="text/html; charset=euc-kr">
<link rel="stylesheet" type="text/css" href="/include/table_t.css"></link>
<script language="JavaScript">
<!--
//-->
</script>
</head>
<body>
<script>
<%	if(count==1){%>
	alert("정상적으로 수정되었습니다.");
	parent.location.reload();
<%	}else{%>
	alert("에러발행!");
<%	}%>

</script>
</body>
</html>