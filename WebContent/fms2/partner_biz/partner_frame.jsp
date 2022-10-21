<%@ page language="java" contentType="text/html;charset=euc-kr" %>
<%@ page import="java.util.*, acar.util.*"%>
<%@ include file="/acar/cookies.jsp" %>
<%@ include file="/acar/access_log.jsp" %>
<%
	int cnt = 3; //검색 라인수
	int height = cnt*sh_line_height-25;
%>
<HTML>
<HEAD>
<title>FMS</title>
</HEAD>
<%
	String auth_rw = request.getParameter("auth_rw")==null?"":request.getParameter("auth_rw");
	String br_id = request.getParameter("br_id")==null?"":request.getParameter("br_id");
	String user_id = request.getParameter("user_id")==null?"":request.getParameter("user_id");
	
	String member_id = request.getParameter("member_id")==null?"":request.getParameter("member_id");
	String client_id = request.getParameter("client_id")==null?"":request.getParameter("client_id");
	String r_site = request.getParameter("r_site")==null?"":request.getParameter("r_site");
	
	String s_gubun1 = request.getParameter("s_gubun1")==null?"Y":request.getParameter("s_gubun1");
	String s_gubun2 = request.getParameter("s_gubun2")==null?"":request.getParameter("s_gubun2");
	String s_gubun3 = request.getParameter("s_gubun3")==null?"":request.getParameter("s_gubun3");
	String s_gubun4 = request.getParameter("s_gubun4")==null?"":request.getParameter("s_gubun4");
	String s_kd = request.getParameter("s_kd")==null?"1":request.getParameter("s_kd");
	String t_wd = request.getParameter("t_wd")==null?"":request.getParameter("t_wd");
	String idx = request.getParameter("idx")==null?"":request.getParameter("idx");
	int rent_cnt = request.getParameter("rent_cnt")==null?0:AddUtil.parseInt(request.getParameter("rent_cnt"));
	
	if(!br_id.equals("S1"))	s_gubun3 = user_id;
	
	
%>
<frameset rows="<%=height%>, *, 0" border=0>
	<frame name="c_body"    src="./partner_sh.jsp?br_id=<%=br_id%>&user_id=<%=user_id%>&member_id=<%=member_id%>&client_id=<%=client_id%>&r_site=<%=r_site%>&auth_rw=<%=auth_rw%>&s_gubun1=<%=s_gubun1%>&s_gubun2=<%=s_gubun2%>&s_gubun3=<%=s_gubun3%>&s_gubun4=<%=s_gubun4%>&s_kd=<%=s_kd%>&t_wd=<%=t_wd%>&rent_cnt=<%=rent_cnt%>&idx=<%=idx%>&sh_height=<%=height%>" marginwidth=10 marginheight=10 scrolling='no' noresize>
	<frame name="c_foot"    src="./partner_sc.jsp?br_id=<%=br_id%>&user_id=<%=user_id%>&member_id=<%=member_id%>&client_id=<%=client_id%>&r_site=<%=r_site%>&auth_rw=<%=auth_rw%>&s_gubun1=<%=s_gubun1%>&s_gubun2=<%=s_gubun2%>&s_gubun3=<%=s_gubun3%>&s_gubun4=<%=s_gubun4%>&s_kd=<%=s_kd%>&t_wd=<%=t_wd%>&rent_cnt=<%=rent_cnt%>&idx=<%=idx%>&sh_height=<%=height%>" marginwidth=10 marginheight=10 scrolling="auto">
	<FRAME name="nodisplay" src="about:blank" frameborder=0 scrolling="no" topmargin=0 marginwidth="10" marginheight="10">
</frameset>
</HTML>
