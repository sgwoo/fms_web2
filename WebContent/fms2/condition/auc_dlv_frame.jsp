<%@ page language="java" contentType="text/html;charset=euc-kr"%>
<%@ include file="/acar/cookies.jsp" %>
<%@ include file="/acar/access_log.jsp" %>

<%
	int cnt = 2; //검색 라인수
	int height = cnt*sh_line_height+10;

%>
<HTML>
<HEAD>
<TITLE>FMS고현황</TITLE>
</HEAD>
<%
	String auth_rw 		= request.getParameter("auth_rw")==null?"":request.getParameter("auth_rw");
%>
<frameset rows="<%=height%>, *" border=1>
        <frame src="/fms2/condition/auc_dlv_sh.jsp?auth_rw=<%=auth_rw%>&sh_height=<%=height%>" name="c_head" marginwidth=10 marginheight=10 scrolling="no" noresize>
		<frame src="/fms2/condition/auc_dlv_sc.jsp?auth_rw=<%=auth_rw%>&sh_height=<%=height%>" name="c_body" marginwidth=10 marginheight=10 scrolling="auto">
</frameset>
</HTML>
