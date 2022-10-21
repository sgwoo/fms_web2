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
	String cpt_cd = request.getParameter("cpt_cd")==null?"":request.getParameter("cpt_cd");
	String gubun1 = request.getParameter("gubun1")==null?"":request.getParameter("gubun1");	
	String gubun2 = request.getParameter("gubun2")==null?"":request.getParameter("gubun2");	
	String mon_amt = request.getParameter("mon_amt")==null?"":request.getParameter("mon_amt");	
	String save_dt  = request.getParameter("save_dt")==null?"":request.getParameter("save_dt");	
	
%>
<HTML>
<HEAD>
<TITLE>FMS</TITLE>
</HEAD>
<FRAMESET rows="100, 280, *, 0" border=0>
	<FRAME SRC="./servemp_d_title.jsp?auth_rw=<%=auth_rw%>&s_kd=<%=s_kd%>&t_wd=<%=t_wd%>&sort_gubun=<%=sort_gubun%>&sort=<%=sort%>&off_id=<%=off_id%>&gubun1=<%=gubun1%>&gubun2=<%=gubun2%>&mon_amt=<%=mon_amt%>" name="dc_head" frameborder=0  marginwidth="10" marginheight="10" scrolling="no" noresize>
	<FRAME SRC="./servemp_d_cont.jsp?auth_rw=<%=auth_rw%>&off_id=<%=off_id%>&mon_amt=<%=mon_amt%>&save_dt=<%=save_dt%>" name="dc_body" frameborder=0 scrolling="auto" topmargin=0 marginwidth="10">
	<FRAME SRC="./servemp_ds_frame.jsp?auth_rw=<%=auth_rw%>&off_id=<%=off_id%>&cpt_cd=<%=cpt_cd%>&mon_amt=<%=mon_amt%>&save_dt=<%=save_dt%>&gubun1=<%=gubun1%>" name="dc_foot" frameborder=0 scrolling="auto" topmargin=0 marginwidth="10">
	<FRAME SRC="about:blank" name="nodisplay" frameborder=0 scrolling="no" topmargin=0 marginwidth="0" marginheight="0">
</FRAMESET>

<NOFRAMES>
<BODY>
<P>이 페이지를 보려면, 프레임을 볼 수 있는 브라우저가 필요합니다.</P>
</body>
</NOFRAMES>
</HTML>