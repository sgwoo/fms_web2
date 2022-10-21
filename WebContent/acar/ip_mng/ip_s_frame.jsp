<%@ page contentType="text/html; charset=euc-kr" %>
<%@ page language="java" %> 
<%@ include file="/acar/cookies.jsp" %>
<%
	String auth_rw = "";
	
	if(request.getParameter("auth_rw") != null)	auth_rw = request.getParameter("auth_rw");
%>
<HTML>
<HEAD>
<title>FMS</title>
</HEAD>
<FRAMESET rows="*, 130" border=0>
	<FRAME SRC="./ip_s_sc.jsp?auth_rw=<%=auth_rw%>" name="c_body" frameborder=0  marginwidth="10" marginheight="10" scrolling="auto">
	<FRAME SRC="./ip_u.jsp?auth_rw=<%=auth_rw%>" name="c_foot" frameborder=0 marginheight="10" marginwidth="10" scrolling="no" noresize>
</FRAMESET>

<NOFRAMES>
<BODY>
<P>이 페이지를 보려면, 프레임을 볼 수 있는 브라우저가 필요합니다.</P>
</body>
</NOFRAMES>
</HTML>
