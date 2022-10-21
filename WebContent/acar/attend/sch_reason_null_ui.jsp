<%@ page contentType="text/html; charset=euc-kr" %>
<%@ page language="java" %> 
<%@ page import="java.util.*" %>
<%@ page import="acar.util.*" %>
<%@ page contentType="text/html; charset=euc-kr" %>
<%@ page language="java" %> 
<%@ page import="java.util.*" %>
<%@ page import="acar.util.*" %>
<%@ page import="acar.attend.*" %>
<jsp:useBean id="bean" class="acar.attend.AttendBean" scope="page"/>
<%@ include file="/acar/cookies.jsp" %>

<%
	AttendDatabase ad = AttendDatabase.getInstance();
	String user_id = "";
    String start_year = "";
    String start_mon = "";
    String start_day = "";
    String remark = "";
    
    int count = 0;
	
	if(request.getParameter("user_id") != null)	   user_id = request.getParameter("user_id");
	if(request.getParameter("start_year") != null)	start_year = request.getParameter("start_year");
	if(request.getParameter("start_mon") != null)	start_mon = request.getParameter("start_mon");
	if(request.getParameter("start_day") != null)	start_day = request.getParameter("start_day");
	if(request.getParameter("remark") != null)	remark = request.getParameter("remark");
	
	bean.setDt	(start_year+start_mon+start_day);
	bean.setUser_id		(user_id);
    bean.setRemark		(remark);

   
	count = ad.updateRemark(bean);

%>

<html>
<head>
<title>FMS</title>
<link rel="stylesheet" type="text/css" href="/include/table_t.css"></link>
<script language="JavaScript">
<!--
function NullAction()
{
<%if(count==1){%>
	alert("정상적으로 등록되었습니다.");
	parent.window.close();
	

<%}else{%>
	alert("입력 오류!!");
<%}%>
}
//-->
</script>
</head>
<body onLoad="javascript:NullAction()">
</body>
</html>