<%@ page language="java" contentType="text/html; charset=euc-kr" %>
<%@ include file="/acar/cookies.jsp" %>
<%@ include file="/acar/access_log.jsp" %>
<%
	String auth_rw = request.getParameter("auth_rw")==null?"":request.getParameter("auth_rw");
%>
<HTML>
<HEAD>
<title>FMS</title>
</HEAD>
<FRAMESET rows="450, *" border=0>
	<FRAME SRC="./ins_com_sh.jsp?auth_rw=<%=auth_rw%>" name="c_body" frameborder=0  marginwidth="10" marginheight="10" scrolling="yes" noresize>
	<FRAME SRC="./ins_com_sc.jsp?auth_rw=<%=auth_rw%>" name="c_foot" frameborder=0 scrolling="no" topmargin=0 marginwidth="10" marginheight="10" noresize>
</FRAMESET>
<NOFRAMES>
<BODY>
<P>이 페이지를 보려면, 프레임을 볼 수 있는 브라우저가 필요합니다.</P>
</body>
</NOFRAMES>
</HTML>
