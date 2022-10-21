<%@ page language="java" contentType="text/html;charset=euc-kr" %>
<%@ include file="/acar/cookies.jsp" %>
<%@ include file="/acar/access_log.jsp" %>

<%
	String auth_rw = request.getParameter("auth_rw")==null?"":request.getParameter("auth_rw");
	String br_id = request.getParameter("br_id")==null?"":request.getParameter("br_id");
	String user_id = request.getParameter("user_id")==null?"":request.getParameter("user_id");
	
	String sort = request.getParameter("sort")==null?"3":request.getParameter("sort");
	String asc = request.getParameter("asc")==null?"desc":request.getParameter("asc");	
%>
<HTML>
<HEAD>
<TITLE>FMS</TITLE>
</HEAD>
<FRAMESET rows="85, *" border=0>
	<FRAME SRC="./bus_s_sh.jsp?auth_rw=<%=auth_rw%>&br_id=<%=br_id%>&user_id=<%=user_id%>&sort=<%=sort%>&asc=<%=asc%>" name="c_body" frameborder=0 marginwidth="10" marginheight="10" scrolling="no" noresize>
	<FRAME SRC="./bus_s_sc.jsp?auth_rw=<%=auth_rw%>&br_id=<%=br_id%>&user_id=<%=user_id%>&sort=<%=sort%>&asc=<%=asc%>" name="c_foot" frameborder=0 marginwidth="10" topmargin=0 scrolling="no" noresize>
</FRAMESET>
<NOFRAMES>
<BODY>
<P>이 페이지를 보려면, 프레임을 볼 수 있는 브라우저가 필요합니다.</P>
</body>
</NOFRAMES>
</HTML>