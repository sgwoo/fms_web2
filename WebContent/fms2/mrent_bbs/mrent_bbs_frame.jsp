<%@ page language="java" contentType="text/html;charset=euc-kr" %>
<%@ page import="java.util.*, acar.util.*"%>
<%@ include file="/acar/cookies.jsp" %>
<%@ include file="/acar/access_log.jsp" %>

<HTML>
<HEAD>
<title>FMS</title>
<script language='javascript'>
</script>
</HEAD>
<%
	String br_id = request.getParameter("br_id")==null?"":request.getParameter("br_id");
	String user_id = request.getParameter("user_id")==null?"":request.getParameter("user_id");
	
	String member_id = request.getParameter("member_id")==null?"":request.getParameter("member_id");
	String client_id = request.getParameter("client_id")==null?"":request.getParameter("client_id");
	String r_site = request.getParameter("r_site")==null?"":request.getParameter("r_site");
	String auth_rw = request.getParameter("auth_rw")==null?"":request.getParameter("auth_rw");
	
	String gubun = request.getParameter("gubun")==null?"2":request.getParameter("gubun");
	String s_yy = request.getParameter("s_yy")==null?"":request.getParameter("s_yy");
	String s_mm = request.getParameter("s_mm")==null?"":request.getParameter("s_mm");
	String s_dd = request.getParameter("s_dd")==null?"":request.getParameter("s_dd");
	String s_kd = request.getParameter("s_kd")==null?"":request.getParameter("s_kd");
	String t_wd = request.getParameter("t_wd")==null?"":request.getParameter("t_wd");
	String idx = request.getParameter("idx")==null?"":request.getParameter("idx");
	
	s_yy = AddUtil.getDate(1);
	s_mm = AddUtil.getDate(2);
%>
<frameset rows="130, *, 0" border=1>
	<frame name="c_body"    src="mrent_bbs_sh.jsp?br_id=<%=br_id%>&user_id=<%=user_id%>&member_id=<%=member_id%>&client_id=<%=client_id%>&r_site=<%=r_site%>&auth_rw=<%=auth_rw%>&gubun=<%=gubun%>&s_yy=<%=s_yy%>&s_mm=<%=s_mm%>&s_dd=<%=s_dd%>&s_kd=<%=s_kd%>&t_wd=<%=t_wd%>&idx=<%=idx%>" marginwidth=10 marginheight=10 scrolling='no' noresize>
	<frame name="c_foot"    src="mrent_bbs_sc.jsp?br_id=<%=br_id%>&user_id=<%=user_id%>&member_id=<%=member_id%>&client_id=<%=client_id%>&r_site=<%=r_site%>&auth_rw=<%=auth_rw%>&gubun=<%=gubun%>&s_yy=<%=s_yy%>&s_mm=<%=s_mm%>&s_dd=<%=s_dd%>&s_kd=<%=s_kd%>&t_wd=<%=t_wd%>&idx=<%=idx%>" marginwidth=10 marginheight=10 scrolling="auto">
	<FRAME name="nodisplay" src="about:blank" frameborder=0 scrolling="no" topmargin=0 marginwidth="10" marginheight="10">
</frameset>
</HTML>
