<%@ page contentType="text/html; charset=euc-kr" %>
<%@ page language="java" %> 
<%@ page import="java.util.*" %>
<%@ page import="acar.util.*" %>
<%@ page import="acar.forfeit_mng.*" %>
<%@ include file="/acar/cookies.jsp" %>

<%
	ForfeitDatabase fdb = ForfeitDatabase.getInstance();

	String auth_rw = "";
	String cmd = "";
	String paid_no = "";
	int count = 0;
	
	if(request.getParameter("auth_rw") != null)	auth_rw = request.getParameter("auth_rw");
	if(request.getParameter("cmd") != null) cmd = request.getParameter("cmd");
	if(request.getParameter("h_paid_no") != null) paid_no = request.getParameter("h_paid_no");
	
	
	count = fdb.getPaidNo(paid_no);

%>
<html>
<head>
<meta http-equiv="content-type" content="text/html; charset=euc-kr">
<title>FMS</title>
<link rel="stylesheet" type="text/css" href="/include/table_t.css"></link>
<script language="JavaScript">
<!--
function NullAction()
{
<%
	if(count==0)
	{
%>

<%
		
	}else{

%>
alert("'<%=paid_no%>' 납부고지서번호가 존재합니다.");

<%

	}
%>
}
//-->
</script>
</head>
<body onLoad="javascript:NullAction()">


</body>
</html>