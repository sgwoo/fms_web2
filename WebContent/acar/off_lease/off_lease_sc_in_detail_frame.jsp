<%@ page language="java" contentType="text/html;charset=euc-kr" %>
<%@ include file="/acar/cookies.jsp" %>
<%
	String auth_rw = request.getParameter("auth_rw")==null?"":request.getParameter("auth_rw");
	String car_mng_id = request.getParameter("car_mng_id")==null?"":request.getParameter("car_mng_id");
	String gubun = request.getParameter("gubun")==null?"":request.getParameter("gubun");
	String gubun_nm = request.getParameter("gubun_nm")==null?"":request.getParameter("gubun_nm");
%>
<HTML>
<HEAD>
<TITLE>오프리스 프레임</TITLE>
</HEAD>
<frameset rows="135,*,1" border=1 cols="*"> 
  <frame name="detail_head" src="off_lease_sc_in_h.jsp?auth_rw=<%=auth_rw%>&car_mng_id=<%=car_mng_id%>&gubun=<%=gubun%>&gubun_nm=<%=gubun_nm%>" marginwidth=10 marginheight=10 scrolling='no' noresize>
  <frame name="detail_body" src="off_lease_sc_in_b.jsp?auth_rw=<%=auth_rw%>&car_mng_id=<%=car_mng_id%>" marginwidth=10 marginheight=10 scrolling="auto" noresize>
  <FRAME name="nodisplay" SRC="about:blank" frameborder=0 scrolling="no" topmargin=0 marginwidth="10" marginheight="10">
</frameset>
<noframes> 
</noframes> 
</HTML>