<%@ page language="java" import="java.util.*, acar.util.*" contentType="text/html;charset=euc-kr" %>
<jsp:useBean id="rs_db" scope="page" class="acar.res_search.ResSearchDatabase"/>
<%@ include file="/acar/cookies.jsp" %>
<%@ include file="/acar/access_log.jsp" %>

<%
	int cnt = 2; //검색 라인수
	int height = cnt*sh_line_height+20;
%>
<%
	String auth_rw = request.getParameter("auth_rw")==null?"":request.getParameter("auth_rw");
	
	String base_dt = request.getParameter("base_dt")==null?"":request.getParameter("base_dt");
	String car_comp_id = request.getParameter("car_comp_id")==null?"":request.getParameter("car_comp_id");
	String t_wd = request.getParameter("t_wd")==null?"":request.getParameter("t_wd");
	
	
	if(auth_rw.equals(""))	auth_rw = rs_db.getAuthRw(ck_acar_id, "11", "02", "02");
	
	
%>
<HTML>
<HEAD>
<TITLE></TITLE>
</HEAD>
<FRAMESET rows="<%=height%>, *, 0" border=0>
	<FRAME SRC="./main_car_sh.jsp?auth_rw=<%=auth_rw%>&base_dt=<%= base_dt %>&car_comp_id=<%= car_comp_id %>&t_wd=<%= t_wd %>&sh_height=<%=height%>" name="c_body" frameborder=0  marginwidth="10" marginheight="10" scrolling="no" noresize>
	<FRAME SRC="./main_car_sc.jsp?auth_rw=<%=auth_rw%>&base_dt=<%= base_dt %>&car_comp_id=<%= car_comp_id %>&t_wd=<%= t_wd %>&sh_height=<%=height%>" name="c_foot" frameborder=0 scrolling="auto" topmargin=0 marginwidth="10">
	<FRAME name="nodisplay" SRC="about:blank" frameborder=0 scrolling="no" topmargin=0 marginwidth="10" marginheight="10">
</FRAMESET>

<NOFRAMES>
<BODY>
<P>이 페이지를 보려면, 프레임을 볼 수 있는 브라우저가 필요합니다.</P>
</body>
</NOFRAMES>
</HTML>