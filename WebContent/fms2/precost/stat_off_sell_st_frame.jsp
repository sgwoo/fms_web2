<%@ page language="java" contentType="text/html;charset=euc-kr" %>
<%@ page import="java.util.*, acar.util.*"%>
<jsp:useBean id="ad_db" scope="page" class="acar.admin.AdminDatabase"/>
<%@ include file="/acar/cookies.jsp" %>
<%@ include file="/acar/access_log.jsp" %>

<%
	int cnt = 3; //검색 라인수
	int height = cnt*sh_line_height;
%>
<%
	String auth_rw = request.getParameter("auth_rw")==null?"":request.getParameter("auth_rw");
	String br_id = request.getParameter("br_id")==null?"":request.getParameter("br_id");
	String user_id = request.getParameter("user_id")==null?"":request.getParameter("user_id");
	
	
	String s_yy 	= request.getParameter("s_yy")==null?AddUtil.getDate(1):request.getParameter("s_yy");
//	String gubun1 = request.getParameter("gubun1")==null?"3":request.getParameter("gubun1");
	String st_dt = request.getParameter("st_dt")==null?"":request.getParameter("st_dt");
	String end_dt = request.getParameter("end_dt")==null?"":request.getParameter("end_dt");
	String save_dt = request.getParameter("save_dt")==null?"":request.getParameter("save_dt");
	
	if(save_dt.equals(""))	save_dt = ad_db.getMaxSaveDt("stat_off_service");
%>
<HTML>
<HEAD>
<title>FMS</title>
</HEAD>
<FRAMESET rows="<%=height%>, *" border=0>
	<FRAME SRC="stat_off_sell_st_sh.jsp?auth_rw=<%=auth_rw%>&br_id=<%=br_id%>&user_id=<%=user_id%>&s_yy=<%=s_yy%>&st_dt=<%=st_dt%>&end_dt=<%=end_dt%>&save_dt=<%=save_dt%>&sh_height=<%=height%>" name="c_body" frameborder=0 marginwidth="10" marginheight="10" scrolling="no" noresize>
	<FRAME SRC="stat_off_sell_st_sc.jsp?auth_rw=<%=auth_rw%>&br_id=<%=br_id%>&user_id=<%=user_id%>&s_yy=<%=s_yy%>&st_dt=<%=st_dt%>&end_dt=<%=end_dt%>&save_dt=<%=save_dt%>&sh_height=<%=height%>" name="c_foot" frameborder=0 marginwidth="10" topmargin=0 scrolling="yes" noresize>
</FRAMESET>
<NOFRAMES>
<BODY>
<P>이 페이지를 보려면, 프레임을 볼 수 있는 브라우저가 필요합니다.</P>
</body>
</NOFRAMES>
</HTML>