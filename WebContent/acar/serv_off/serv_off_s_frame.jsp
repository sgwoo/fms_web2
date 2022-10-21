<%@ page contentType="text/html; charset=euc-kr" %>
<%@ page language="java" %> 
<%@ include file="/acar/cookies.jsp" %>
<%
	String auth_rw = "";
	String off_id = "";
		
	if(request.getParameter("auth_rw") != null)	auth_rw = request.getParameter("auth_rw");
	if(request.getParameter("off_id") != null)	off_id = request.getParameter("off_id");
	
%>
<HTML>
<HEAD>
<TITLE>FMS</TITLE>
</HEAD>
<FRAMESET rows="250, *, 20" border=0>
	<FRAME SRC="./serv_off_main_s.jsp?auth_rw=<%=auth_rw%>&off_id=<%=off_id%>" name="c_body" frameborder=0  marginwidth="10" marginheight="10" scrolling="no" noresize>
	<FRAME SRC="./serv_off_serv_list_sd.jsp?auth_rw=<%=auth_rw%>&off_id=<%=off_id%>" name="c_foot" frameborder=0 scrolling="auto" topmargin=0 marginwidth="10">
	<FRAME SRC="about:blank" name="nodisplay" frameborder=0 scrolling="no" topmargin=0 marginwidth="10" marginheight="10">
</FRAMESET>

<NOFRAMES>
<BODY>
<P>이 페이지를 보려면, 프레임을 볼 수 있는 브라우저가 필요합니다.</P>
</body>
</NOFRAMES>
</HTML>