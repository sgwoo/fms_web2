<%@ page language="java" contentType="text/html;charset=euc-kr"%>
<%@ page import="java.util.*,acar.util.*"%>
<%@ include file="/acar/cookies.jsp" %>
<%@ include file="/acar/access_log.jsp" %>

<%
	int cnt = 4; //검색 라인수
	int height = cnt*sh_line_height+10;

%>
<HTML>
<HEAD>
<TITLE>FMS고현황</TITLE>
</HEAD>
<%
	String auth_rw 		= request.getParameter("auth_rw")==null?"":request.getParameter("auth_rw");
	String car_off_id	= request.getParameter("car_off_id")==null?"":request.getParameter("car_off_id");
	String s_kd 		= request.getParameter("s_kd")==null?"0":request.getParameter("s_kd");
	String t_wd 		= request.getParameter("t_wd")==null?"":request.getParameter("t_wd");
	String dt 			= request.getParameter("dt")==null?"0":request.getParameter("dt");
	String t_st_dt 		= request.getParameter("t_st_dt")==null?"":request.getParameter("t_st_dt");
	String t_end_dt 	= request.getParameter("t_end_dt")==null?"":request.getParameter("t_end_dt");
%>
<frameset rows="<%=height%>, *" border=1>
        <frame src="dlv_condition_sh.jsp?auth_rw=<%=auth_rw%>&car_off_id=<%=car_off_id%>&s_kd=<%=s_kd%>&t_wd=<%=t_wd%>&dt=<%=dt%>&t_st_dt=<%=t_st_dt%>&t_end_dt=<%=t_end_dt%>&sh_height=<%=height%>" name="c_head" marginwidth=10 marginheight=10 scrolling="no" noresize>
	<frame src="dlv_condition_sc.jsp?auth_rw=<%=auth_rw%>&car_off_id=<%=car_off_id%>&s_kd=<%=s_kd%>&t_wd=<%=t_wd%>&dt=<%=dt%>&t_st_dt=<%=t_st_dt%>&t_end_dt=<%=t_end_dt%>&sh_height=<%=height%>" name="c_body" marginwidth=10 marginheight=10 scrolling="auto">
</frameset>
</HTML>
