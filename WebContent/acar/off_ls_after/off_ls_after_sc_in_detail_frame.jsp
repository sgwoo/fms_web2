<%@ page language="java" contentType="text/html;charset=euc-kr" %>
<%@ include file="/acar/cookies.jsp" %>
<%
	String auth_rw = request.getParameter("auth_rw")==null?"":request.getParameter("auth_rw");
	String car_mng_id = request.getParameter("car_mng_id")==null?"":request.getParameter("car_mng_id");
	String gubun = request.getParameter("gubun")==null?"":request.getParameter("gubun");
	String gubun_nm = request.getParameter("gubun_nm")==null?"":request.getParameter("gubun_nm");
	String migr_dt = request.getParameter("migr_dt")==null?"":request.getParameter("migr_dt");
	String migr_gu = request.getParameter("migr_gu")==null?"":request.getParameter("migr_gu");
	String st_dt = request.getParameter("st_dt")==null?"":request.getParameter("st_dt");
	String end_dt = request.getParameter("end_dt")==null?"":request.getParameter("end_dt");
	String car_st = request.getParameter("car_st")==null?"":request.getParameter("car_st");
	String com_id = request.getParameter("com_id")==null?"":request.getParameter("com_id");
	String car_cd = request.getParameter("car_cd")==null?"":request.getParameter("car_cd");	
	String from_page = request.getParameter("from_page")==null?"":request.getParameter("from_page");	
%>
<HTML>
<HEAD>
<TITLE>FMS</TITLE>
</HEAD>
<frameset rows="150,*,1" border=1 cols="*"> 
  <frame name="detail_head" src="off_ls_after_sc_in_h.jsp?from_page=<%=from_page%>&auth_rw=<%=auth_rw%>&car_mng_id=<%=car_mng_id%>&gubun=<%=gubun%>&gubun_nm=<%=gubun_nm%>&migr_dt=<%= migr_dt %>&migr_gu=<%= migr_gu %>&st_dt=<%= st_dt %>&end_dt=<%= end_dt %>&car_st=<%= car_st %>&com_id=<%= com_id %>&car_cd=<%= car_cd %>" marginwidth=10 marginheight=10 scrolling='no' noresize>
  <frame name="detail_body" src="off_ls_after_sui_reg.jsp?from_page=<%=from_page%>&auth_rw=<%=auth_rw%>&car_mng_id=<%=car_mng_id%>" marginwidth=10 marginheight=10 scrolling="auto" noresize>
  <FRAME name="nodisplay" SRC="about:blank" frameborder=0 scrolling="no" topmargin=0 marginwidth="10" marginheight="10">
</frameset>
<noframes> 
</noframes> 
</HTML>