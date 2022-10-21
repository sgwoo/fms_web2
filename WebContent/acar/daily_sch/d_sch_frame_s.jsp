<%@ page language="java" contentType="text/html;charset=euc-kr"%>
<%@ include file="/acar/cookies.jsp" %>
<HTML>
<HEAD>
<TITLE>FMS</TITLE>
</HEAD>
<%
	String auth_rw = request.getParameter("auth_rw")==null?"":request.getParameter("auth_rw");
%>
<frameset rows="50, *" border=1>
        <frame src="/acar/daily_sch/d_sch_sh.jsp?auth_rw=<%=auth_rw%>" name="c_head" marginwidth=10 marginheight=10 scrolling="no" noresize>
		<frame src="/acar/daily_sch/d_sch_sc.jsp?auth_rw=<%=auth_rw%>" name="c_body" marginwidth=10 marginheight=10 scrolling="auto">
</frameset>
</HTML>
