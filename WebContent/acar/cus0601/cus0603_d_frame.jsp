<%@ page contentType="text/html; charset=euc-kr" %>
<%@ page language="java" %> 
<%@ include file="/acar/cookies.jsp" %>
<%
	String auth_rw = request.getParameter("auth_rw")==null?"":request.getParameter("auth_rw");
	String s_kd = request.getParameter("s_kd")==null?"":request.getParameter("s_kd");
	String t_wd = request.getParameter("t_wd")==null?"":request.getParameter("t_wd");
	String sort_gubun = request.getParameter("sort_gubun")==null?"":request.getParameter("sort_gubun");
	String sort = request.getParameter("sort")==null?"":request.getParameter("sort");
	String off_id = request.getParameter("off_id")==null?"":request.getParameter("off_id");
	String from_page = request.getParameter("from_page")==null?"":request.getParameter("from_page");
%>
<HTML>
<HEAD>
<TITLE>FMS</TITLE>
</HEAD>
<%if(from_page.equals("/fms2/consignment_new/cons_i_c.jsp")){%>
<FRAMESET rows="80, 220, *" border=0>
	<FRAME SRC="./cus0603_d_title.jsp?auth_rw=<%=auth_rw%>&s_kd=<%=s_kd%>&t_wd=<%=t_wd%>&sort_gubun=<%=sort_gubun%>&sort=<%=sort%>&off_id=<%=off_id%>&from_page=<%=from_page%>" name="dc_head" frameborder=0  marginwidth="10" marginheight="10" scrolling="no" noresize>
	<FRAME SRC="./cus0603_d_cont.jsp?auth_rw=<%=auth_rw%>&off_id=<%=off_id%>&from_page=<%=from_page%>" name="dc_body" frameborder=0 scrolling="auto" topmargin=0 marginwidth="10">
	<FRAME SRC="about:blank" name="nodisplay" frameborder=0 scrolling="no" topmargin=0 marginwidth="0" marginheight="0">
</FRAMESET>
<%}else{%>
<FRAMESET rows="75, 170, *, 0" border=0>
	<FRAME SRC="./cus0603_d_title.jsp?auth_rw=<%=auth_rw%>&s_kd=<%=s_kd%>&t_wd=<%=t_wd%>&sort_gubun=<%=sort_gubun%>&sort=<%=sort%>&off_id=<%=off_id%>&from_page=<%=from_page%>" name="dc_head" frameborder=0  marginwidth="10" marginheight="10" scrolling="no" noresize>
	<FRAME SRC="./cus0603_d_cont.jsp?auth_rw=<%=auth_rw%>&off_id=<%=off_id%>&from_page=<%=from_page%>" name="dc_body" frameborder=0 scrolling="auto" topmargin=0 marginwidth="10">
	<FRAME SRC="./cus0603_ds_frame.jsp?auth_rw=<%=auth_rw%>&off_id=<%=off_id%>&from_page=<%=from_page%>" name="dc_foot" frameborder=0 scrolling="auto" topmargin=0 marginwidth="10">
	<FRAME SRC="about:blank" name="nodisplay" frameborder=0 scrolling="no" topmargin=0 marginwidth="0" marginheight="0">
</FRAMESET>
<%}%>

<NOFRAMES>
<BODY>
<P>이 페이지를 보려면, 프레임을 볼 수 있는 브라우저가 필요합니다.</P>
</body>
</NOFRAMES>
</HTML>