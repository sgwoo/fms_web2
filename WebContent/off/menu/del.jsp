<%@ page language="java" contentType="text/html; charset=euc-kr" %>
<%@ page import="java.net.*, acar.util.*, acar.off_anc.*, acar.database.*" %>
<%@ include file="/off/cookies.jsp" %>

<%
	//�α׾ƿ� ������
	
	String ip 		= request.getParameter("ip")==null?"":request.getParameter("ip");
	String login_time 	= request.getParameter("login_time")==null?"":request.getParameter("login_time");
	int count=0;
	
	LoginBean login = LoginBean.getInstance();
	
	String acar_id = login.getSessionValue(request, "USER_ID");
	
	//����� ��Ű ����
	login.delCookie(request, response, "fmsCookie");
	login.delCookie(request, response, "currentMenuNavi");
	
	/** �α׾ƿ� ó�� **/
	login.setLogout(request);
		
	//String acar_id = login.getCookieValue(request, "acar_id");
	//����� ��Ű ����
	//login.delCookie(request, response, "acar_id");
	
	OffAncDatabase oad = OffAncDatabase.getInstance();
	//ip_log �α׾ƿ� ó��
	count = oad.updateLogoutLog(ip, acar_id, login_time);
	System.out.println("[�α׾ƿ� ���¾�ü] DT:"+AddUtil.getDate()+", ID:"+acar_id+" " );
%>
<html>
<body>
<script language="JavaScript">
<!--
//-->
</script>
<%
	response.sendRedirect("/off/index.jsp");
%>
</body>
</html>

