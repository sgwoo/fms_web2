<%@ page contentType="text/html; charset=euc-kr" %>
<%@ page language="java" %> 
<%@ page import="java.util.*, acar.util.*"%>
<%@ include file="/acar/cookies.jsp" %>
<%@ include file="/acar/access_log.jsp" %>

<%
	int cnt = 2; //검색 라인수
	int height = cnt*sh_line_height+15;
%>
<%
	String auth_rw = request.getParameter("auth_rw")==null?"":request.getParameter("auth_rw"); //권한
	String user_id = request.getParameter("user_id")==null?"":request.getParameter("user_id");//로그인-ID
	String br_id = request.getParameter("br_id")==null?"":request.getParameter("br_id");//로그인-영업소
	
	String chk1 = request.getParameter("chk1")==null?"m":request.getParameter("chk1");	
	String s_kd = request.getParameter("s_kd")==null?"":request.getParameter("s_kd");	
	String t_wd = request.getParameter("t_wd")==null?"":request.getParameter("t_wd");	
	int s_year = request.getParameter("s_year")==null?AddUtil.getDate2(1):Integer.parseInt(request.getParameter("s_year"));	
	int s_month = request.getParameter("s_month")==null?AddUtil.getDate2(2):Integer.parseInt(request.getParameter("s_month"));	
	int s_day = request.getParameter("s_day")==null?AddUtil.getDate2(3):Integer.parseInt(request.getParameter("s_day"));		
%>
<HTML>
<HEAD>
<title>FMS</title>
</HEAD>
<FRAMESET rows="<%=height%>, *" border=0>
	<FRAME SRC="summer_sh.jsp?ck_acar_id=<%=ck_acar_id%>&s_width=<%=s_width%>&s_height=<%=s_height%>&auth_rw=<%=auth_rw%>&user_id=<%=user_id%>&br_id=<%=br_id%>&chk1=<%=chk1%>&s_kd=<%=s_kd%>&t_wd=<%=t_wd%>&s_year=<%=s_year%>&s_month=<%=s_month%>&s_day=<%=s_day%>&sh_height=<%=height%>" name="c_body" frameborder=0  marginwidth="10" marginheight="10" scrolling="no">
	<FRAME SRC="summer_sc.jsp?ck_acar_id=<%=ck_acar_id%>&s_width=<%=s_width%>&s_height=<%=s_height%>&auth_rw=<%=auth_rw%>&user_id=<%=user_id%>&br_id=<%=br_id%>&chk1=<%=chk1%>&s_kd=<%=s_kd%>&t_wd=<%=t_wd%>&s_year=<%=s_year%>&s_month=<%=s_month%>&s_day=<%=s_day%>&sh_height=<%=height%>" name="c_foot" frameborder=0 marginheight="10" marginwidth="10" scrolling="no" noresize>
</FRAMESET>

<NOFRAMES>
<BODY>
<P>이 페이지를 보려면, 프레임을 볼 수 있는 브라우저가 필요합니다.</P>
</body>
</NOFRAMES>
</HTML>
