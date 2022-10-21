<%@ page language="java" contentType="text/html;charset=euc-kr" %>
<%@ include file="/acar/cookies.jsp" %>

<HTML>
<%
	String auth_rw = request.getParameter("auth_rw")==null?"":request.getParameter("auth_rw");
%>
<frameset rows="60, *" border=1>
		<frame src="/acar/mng_client2/client_sh.jsp?auth_rw=<%=auth_rw%>" name="c_body" marginwidth=10 marginheight=10 scrolling='no' noresize>
		<frame src="about:blank" name="c_foot" marginwidth=10 marginheight=10 scrolling="auto">
</frameset>
</HTML>