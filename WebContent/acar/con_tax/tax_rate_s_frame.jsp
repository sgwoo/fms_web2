<%@ page language="java" contentType="text/html; charset=euc-kr" %>
<%@ include file="/acar/cookies.jsp" %>
<%@ include file="/acar/access_log.jsp" %>

<%
	String auth_rw = request.getParameter("auth_rw")==null?"":request.getParameter("auth_rw");
	String user_id = request.getParameter("user_id")==null?"":request.getParameter("user_id");
	String br_id = request.getParameter("br_id")==null?"":request.getParameter("br_id");
	String s_kd = request.getParameter("s_kd")==null?"":request.getParameter("s_kd");
	String t_wd = request.getParameter("t_wd")==null?"":request.getParameter("t_wd");
%>
<HTML>
<HEAD>
<title>FMS</title>
</HEAD>
<FRAMESET rows="65, *" border=0>
	<FRAME SRC="./tax_rate_sh.jsp?auth_rw=<%=auth_rw%>&user_id=<%=user_id%>&br_id=<%=br_id%>&s_kd=<%=s_kd%>&t_wd=<%=t_wd%>" name="c_body" frameborder=0  marginwidth="10" marginheight="10" scrolling="no" noresize>
	<FRAME SRC="./tax_rate_sc.jsp?auth_rw=<%=auth_rw%>&user_id=<%=user_id%>&br_id=<%=br_id%>&s_kd=<%=s_kd%>&t_wd=<%=t_wd%>" name="c_foot" frameborder=0 scrolling="no" topmargin=0 marginwidth="10">
</FRAMESET>
<NOFRAMES>
<BODY>
<P>�� �������� ������, �������� �� �� �ִ� �������� �ʿ��մϴ�.</P>
</body>
</NOFRAMES>
</HTML>
