<%@ page language="java" contentType="text/html; charset=euc-kr" %>
<%@ page import="acar.database.*, acar.util.*" %>
<%@ include file="/off/cookies.jsp" %>

<%
	Login login = Login.getInstance();
//	OffAncDatabase oad = OffAncDatabase.getInstance();
	
	int count=0;
	String acar_id = "";
	String ip = "";
	String login_time = "";
	
	if(request.getParameter("ip") != null)	ip = request.getParameter("ip");
	if(request.getParameter("login_time") != null)	login_time = request.getParameter("login_time");	
	login_time = Util.getLoginTime();//로그인시간
	
	login.delCookie(request, response, "acar_id");
//	System.out.println("[로그아웃] DT:"+login_time+", ID:"+user_id);
//	count = oad.updateLogout(ip,acar_id);
//	count = oad.updateLogoutLog(ip, acar_id, login_time);
	
	out.println(count);if(1==1)return;
%>

<html>
<body>
<script language="JavaScript">
<!--

	top.window.opener.close();
	top.window.close();

//-->
</script>
</body>
</html>

