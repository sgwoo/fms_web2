<%@ page language="java" contentType="text/html;charset=euc-kr" %>
<%@ include file="/acar/cookies.jsp" %>
<%
	String auth_rw = request.getParameter("auth_rw")==null?"":request.getParameter("auth_rw");
	String car_mng_id = request.getParameter("car_mng_id")==null?"":request.getParameter("car_mng_id");
	String seq = request.getParameter("seq")==null?"01":request.getParameter("seq");
%>
<HTML>
<HEAD>
<TITLE>FMS</TITLE>
</HEAD>
<frameset rows="160,*,1" border=1 cols="*"> 
  <frame name="detail_head" src="off_ls_jh_sc_in_h.jsp?auth_rw=<%=auth_rw%>&car_mng_id=<%=car_mng_id%>&seq=<%=seq%>" marginwidth=10 marginheight=10 scrolling='no' noresize>
  <frame name="detail_body" src="off_ls_jh_st_frame.jsp?auth_rw=<%=auth_rw%>&car_mng_id=<%=car_mng_id%>&seq=<%=seq%>" marginwidth=10 marginheight=10 scrolling="auto" noresize>
  <FRAME name="nodisplay" SRC="about:blank" frameborder=0 scrolling="no" topmargin=0 marginwidth="10" marginheight="10">
</frameset>
<noframes> 
</noframes> 
</HTML>