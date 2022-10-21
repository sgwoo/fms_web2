<%@ page language="java" contentType="text/html;charset=euc-kr" %>
<%@ page import="java.util.*,acar.util.*"%>
<%@ include file="/agent/cookies.jsp" %>
<%@ include file="/agent/access_log.jsp" %>

<%
	int cnt = 2; //검색 라인수
	int height = cnt*sh_line_height+10;
%>

<HTML>
<%
	String auth_rw 	= request.getParameter("auth_rw")==null?"":request.getParameter("auth_rw");
	String br_id 	= request.getParameter("br_id")==null?"":request.getParameter("br_id");
	String user_id 	= request.getParameter("user_id")==null?"":request.getParameter("user_id");
	
	String s_kd 	= request.getParameter("s_kd")==null?"1":request.getParameter("s_kd");
	String t_wd 	= request.getParameter("t_wd")==null?"":request.getParameter("t_wd");
	String asc 	= request.getParameter("asc")==null?"0":request.getParameter("asc");
	String from_page = request.getParameter("from_page")==null?"":request.getParameter("from_page");  //popup 요청한 페이지
	
	String incom_dt = request.getParameter("incom_dt")==null?"":request.getParameter("incom_dt");
	int incom_seq	= request.getParameter("incom_seq")==null? 0:AddUtil.parseDigit(request.getParameter("incom_seq"));
	
	
	int sh_height = request.getParameter("sh_height")==null?0:Util.parseInt(request.getParameter("sh_height"));//상단길이
	

%>
<frameset rows="<%=height%>, *" border=1>
		<frame src="/agent/client/client_sh.jsp?auth_rw=<%=auth_rw%>&br_id=<%=br_id%>&user_id=<%=user_id%>&s_kd=<%=s_kd%>&t_wd=<%=t_wd%>&asc=<%=asc%>&sh_height=<%=height%>&from_page=<%=from_page%>&incom_dt=<%=incom_dt%>&incom_seq=<%=incom_seq%>" name="c_body" marginwidth=10 marginheight=10 scrolling='no' noresize>
		<frame src="/agent/client/client_sc.jsp?auth_rw=<%=auth_rw%>&br_id=<%=br_id%>&user_id=<%=user_id%>&s_kd=<%=s_kd%>&t_wd=<%=t_wd%>&asc=<%=asc%>&sh_height=<%=height%>&from_page=<%=from_page%>&incom_dt=<%=incom_dt%>&incom_seq=<%=incom_seq%>" name="c_foot" marginwidth=10 marginheight=10 scrolling="auto">
</frameset>
</HTML>