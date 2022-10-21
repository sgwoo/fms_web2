<%@ page language="java" contentType="text/html;charset=euc-kr"%>
<%@ include file="/acar/cookies.jsp" %>
<%@ include file="/acar/access_log.jsp" %>

<HTML>
<HEAD>
<TITLE>FMS</TITLE>
</HEAD>
<%
	String auth_rw = "";
	
	if(request.getParameter("auth_rw") !=null) auth_rw = request.getParameter("auth_rw");
	
	String from_page 	= request.getParameter("from_page")==null?"":request.getParameter("from_page");
	String c_st 		= request.getParameter("c_st")==null?"":request.getParameter("c_st");
%>
<frameset rows="85, *" border=1>
        <frame src="/acar/common/code_sh.jsp?auth_rw=<%=auth_rw%>&from_page=<%=from_page%>&c_st=<%=c_st%>" name="c_head" marginwidth=10 marginheight=10 scrolling="no" noresize>
	<frame src="/acar/common/code_sc.jsp?auth_rw=<%=auth_rw%>&from_page=<%=from_page%>&c_st=<%=c_st%>" name="c_body" marginwidth=10 marginheight=10 scrolling="auto">
</frameset>
</HTML>
