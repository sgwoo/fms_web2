<%@ page language="java" contentType="text/html;charset=euc-kr"%>
<%@ page import="java.util.*,acar.util.*"%>
<%@ include file="/acar/cookies.jsp" %>
<%@ include file="/acar/access_log.jsp" %>

<%
	int cnt = 2; //�˻� ���μ�
	int height = cnt*sh_line_height+10;
		
	String s_sys = Util.getDate();
	String s_year = s_sys.substring(0,4);
	
	
%>
<HTML>
<HEAD>
<TITLE>FMS����Ȳ</TITLE>
</HEAD>
<%
	String auth_rw 		= request.getParameter("auth_rw")==null?"":request.getParameter("auth_rw");
%>
<frameset rows="<%=height%>, *" border=1>
        <frame src="/fms2/condition/auc_s1_sh.jsp?auth_rw=<%=auth_rw%>&sh_height=<%=height%>&s_year=<%=s_year%>" name="c_head" marginwidth=10 marginheight=10 scrolling="no" noresize>
		<frame src="/fms2/condition/auc_s1_sc.jsp?auth_rw=<%=auth_rw%>&sh_height=<%=height%>&s_year=<%=s_year%>" name="c_body" marginwidth=10 marginheight=10 scrolling="auto">
</frameset>
</HTML>
