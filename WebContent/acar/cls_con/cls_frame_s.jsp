<%@ page language="java" contentType="text/html;charset=euc-kr"%>
<%@ include file="/acar/cookies.jsp" %>
<%@ include file="/acar/access_log.jsp" %>

<HTML>
<HEAD>
<TITLE>FMS</TITLE>
</HEAD>
<%
	String auth_rw	= request.getParameter("auth_rw")==null?"R/W":request.getParameter("auth_rw");
	String r_cls = request.getParameter("r_cls")==null?"0":request.getParameter("r_cls");
	String s_cls_st = request.getParameter("s_cls_st")==null?"0":request.getParameter("s_cls_st");
	String s_kd	= request.getParameter("s_kd")==null?"0":request.getParameter("s_kd");
	String t_wd	= request.getParameter("t_wd")==null?"":request.getParameter("t_wd");
	String t_st_dt = request.getParameter("t_st_dt")==null?"":request.getParameter("t_st_dt");
	String t_end_dt = request.getParameter("t_end_dt")==null?"":request.getParameter("t_end_dt");
%>
<frameset rows="80, *" border=1>
        <frame src="/sian/cls_con/cls_sh.jsp?auth_rw=<%=auth_rw%>&r_cls=<%=r_cls%>&s_cls_st=<%=s_cls_st%>&s_kd=<%=s_kd%>&t_wd=<%=t_wd%>&t_st_dt=<%=t_st_dt%>%t_end_dt=<%=t_end_dt%>" name="c_head" marginwidth=10 marginheight=10 scrolling="no" noresize>
		<frame src="/sian/cls_con/cls_sc.jsp?auth_rw=<%=auth_rw%>&r_cls=<%=r_cls%>&s_cls_st=<%=s_cls_st%>&s_kd=<%=s_kd%>&t_wd=<%=t_wd%>&t_st_dt=<%=t_st_dt%>%t_end_dt=<%=t_end_dt%>" name="c_body" marginwidth=10 marginheight=10 scrolling="no">
</frameset>
</HTML>
