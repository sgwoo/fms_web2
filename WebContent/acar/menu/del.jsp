<%@ page language="java" contentType="text/html; charset=euc-kr" %>
<%@ page import="java.net.*, acar.util.*, acar.off_anc.*, acar.database.*" %>
<jsp:useBean id="memberBean2" scope="request" class="acar.util.LoginBean"/>
<%@ include file="/acar/cookies.jsp" %>

<%
	//로그아웃 페이지
	
	String ip 			= request.getParameter("ip")==null?"":request.getParameter("ip");
	String login_time 	= request.getParameter("login_time")==null?"":request.getParameter("login_time");
	int count=0;
	
	LoginBean login = LoginBean.getInstance();
	
	String acar_id = login.getSessionValue(request, "USER_ID");
	
	//사용자 쿠키 삭제
	login.delCookie(request, response, "fmsCookie");
	login.delCookie(request, response, "currentMenuNavi");

	
	/** 로그아웃 처리 **/
	login.setLogout(request);
	
	OffAncDatabase oad = OffAncDatabase.getInstance();
	//ip_mng 로그아웃 처리 => 2006-08-02 현재 IP관리(IP_MNG) 안하여 주석처리
	//count = oad.updateLogout(ip,acar_id);
	//ip_log 로그아웃 처리
	count = oad.updateLogoutLog(ip, acar_id, login_time);
	
	//attend에 데이타 처리 - logout
	count = oad.attendLogOut(ip, acar_id);
	System.out.println("[로그아웃 FMS] DT:"+AddUtil.getDate()+", ID:"+acar_id+" " );
			
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

