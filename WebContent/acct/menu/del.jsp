<%@ page language="java" contentType="text/html; charset=euc-kr" %>
<%@ page import="java.net.*, acar.util.*, acar.off_anc.*, acar.database.*" %>
<%@ include file="/acct/cookies.jsp" %>

<%
	//�α׾ƿ� ������
	
	String ip 		= request.getParameter("ip")==null?"":request.getParameter("ip");
	String login_time 	= request.getParameter("login_time")==null?"":request.getParameter("login_time");
	
	int count=0;
	
	LoginBean login = LoginBean.getInstance();
	
	String acar_id = login.getCookieValue(request, "acar_id");
	
	//����� ��Ű ����
	login.delCookie(request, response, "acar_id");
	
	OffAncDatabase oad = OffAncDatabase.getInstance();
	//ip_log �α׾ƿ� ó��
	count = oad.updateLogoutLog(ip, acar_id, login_time);
%>
<html>
<body>
<script language="JavaScript">
<!--
//-->
</script>
<%
response.sendRedirect("/acct/index.jsp");
%>
</body>
</html>

