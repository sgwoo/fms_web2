<%@ page language="java" contentType="text/html; charset=euc-kr" %>
<%@ page import="java.net.*, acar.util.*, acar.off_anc.*, acar.database.*" %>
<jsp:useBean id="memberBean2" scope="request" class="acar.util.LoginBean"/>
<%@ include file="/acar/cookies.jsp" %>

<%
	//�α׾ƿ� ������
	
	String ip 			= request.getParameter("ip")==null?"":request.getParameter("ip");
	String login_time 	= request.getParameter("login_time")==null?"":request.getParameter("login_time");
	int count=0;
	
	LoginBean login = LoginBean.getInstance();
	
	String acar_id = login.getSessionValue(request, "USER_ID");
	
	//����� ��Ű ����
	login.delCookie(request, response, "fmsCookie");
	login.delCookie(request, response, "currentMenuNavi");

	
	/** �α׾ƿ� ó�� **/
	login.setLogout(request);
	
	OffAncDatabase oad = OffAncDatabase.getInstance();
	//ip_mng �α׾ƿ� ó�� => 2006-08-02 ���� IP����(IP_MNG) ���Ͽ� �ּ�ó��
	//count = oad.updateLogout(ip,acar_id);
	//ip_log �α׾ƿ� ó��
	count = oad.updateLogoutLog(ip, acar_id, login_time);
	
	//attend�� ����Ÿ ó�� - logout
	count = oad.attendLogOut(ip, acar_id);
	System.out.println("[�α׾ƿ� FMS] DT:"+AddUtil.getDate()+", ID:"+acar_id+" " );
			
%>



<html>
<body>
<script language="JavaScript">
<!--
//	top.window.opener.location ="/acar/index.jsp";
//	top.window.opener.close();
//	top.window.close();
//-->
</script>

<%
	response.sendRedirect("/acar/index.jsp");
%>

</body>
</html>

