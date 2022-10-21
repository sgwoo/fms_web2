<%@ page language="java" contentType="text/html;charset=euc-kr" %>
<%@ include file="/acar/cookies.jsp" %>
<%@ include file="/acar/access_log.jsp" %>

<%
	int cnt = 4; //검색 라인수
	int height = cnt*sh_line_height+15;

%>
<%
	String auth_rw = request.getParameter("auth_rw")==null?"":request.getParameter("auth_rw");
	String brch_id = request.getParameter("brch_id")==null?"":request.getParameter("brch_id");
	String gubun = request.getParameter("gubun")==null?"":request.getParameter("gubun");
	String gubun_nm = request.getParameter("gubun_nm")==null?"":request.getParameter("gubun_nm");
	String dt = request.getParameter("dt")==null?"cont_dt":request.getParameter("dt");
	String migr_dt = request.getParameter("migr_dt")==null?"":request.getParameter("migr_dt");
	String migr_gu = request.getParameter("migr_gu")==null?"3":request.getParameter("migr_gu");
	String st_dt = request.getParameter("st_dt")==null?"":request.getParameter("st_dt");
	String end_dt = request.getParameter("end_dt")==null?"":request.getParameter("end_dt");
	String car_st = request.getParameter("car_st")==null?"":request.getParameter("car_st");
	String com_id = request.getParameter("com_id")==null?"":request.getParameter("com_id");
	String car_cd = request.getParameter("car_cd")==null?"":request.getParameter("car_cd");
%>
<HTML>
<HEAD>
<TITLE>FMS</TITLE>
</HEAD>
<frameset rows="<%=height%>,*,1" border=0 cols="*"> 
  <frame name="c_body" src="off_ls_after_sh.jsp?auth_rw=<%=auth_rw%>&brch_id=<%=brch_id%>&gubun=<%=gubun%>&gubun_nm=<%=gubun_nm%>&dt=<%= dt %>&migr_dt=<%= migr_dt %>&migr_gu=<%= migr_gu %>&st_dt=<%= st_dt %>&end_dt=<%= end_dt %>&car_st=<%= car_st %>&com_id=<%= com_id %>&car_cd=<%= car_cd %>&sh_height=<%=height%>" marginwidth=10 marginheight=10 scrolling='no' noresize>
  <frame name="c_foot" src="off_ls_after_sc.jsp?auth_rw=<%=auth_rw%>&brch_id=<%=brch_id%>&gubun=<%=gubun%>&gubun_nm=<%=gubun_nm%>&dt=<%= dt %>&migr_dt=<%= migr_dt %>&migr_gu=<%= migr_gu %>&st_dt=<%= st_dt %>&end_dt=<%= end_dt %>&car_st=<%= car_st %>&com_id=<%= com_id %>&car_cd=<%= car_cd %>&sh_height=<%=height%>" marginwidth=10 marginheight=10 scrolling="no">
  <FRAME name="nodisplay" SRC="about:blank" frameborder=0 scrolling="no" topmargin=0 marginwidth="10" marginheight="10">
</frameset>
<noframes> 
</noframes> 
</HTML>