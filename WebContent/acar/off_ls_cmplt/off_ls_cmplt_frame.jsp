<%@ page language="java" contentType="text/html;charset=euc-kr" %>
<%@ include file="/acar/cookies.jsp" %>
<%@ include file="/acar/access_log.jsp" %>

<%
	int cnt = 3; //검색 라인수
	int height = cnt*sh_line_height+10;

%>
<%
	String auth_rw 	= request.getParameter("auth_rw")==null?"":request.getParameter("auth_rw");
	String brch_id 	= request.getParameter("brch_id")==null?"":request.getParameter("brch_id");
	String gubun 	= request.getParameter("gubun")==null?"":request.getParameter("gubun");
	String gubun1 = request.getParameter("gubun1")==null?"":request.getParameter("gubun1");
	String gubun_nm = request.getParameter("gubun_nm")==null?"":request.getParameter("gubun_nm");
	String user_id 	= request.getParameter("user_id")==null?"":request.getParameter("user_id");
	String dt	= request.getParameter("dt")==null?"":request.getParameter("dt");
	String ref_dt1 	= request.getParameter("ref_dt1")==null?"":request.getParameter("ref_dt1");
	String ref_dt2 	= request.getParameter("ref_dt2")==null?"":request.getParameter("ref_dt2");
	String s_au 	= request.getParameter("s_au")==null?"":request.getParameter("s_au");
%>
<HTML>
<HEAD>
<TITLE>FMS</TITLE>
</HEAD>
<frameset rows="<%=height%>,*,1" border=0 cols="*"> 
  <frame name="c_body" src="off_ls_cmplt_sh.jsp?auth_rw=<%=auth_rw%>&brch_id=<%=brch_id%>&gubun=<%=gubun%>&gubun1=<%=gubun1%>&gubun_nm=<%=gubun_nm%>&dt=<%=dt%>&ref_dt1=<%=ref_dt1%>&ref_dt2=<%=ref_dt2%>&sh_height=<%=height%>&user_id=<%=user_id%>&s_au=<%=s_au%>" marginwidth=10 marginheight=10 scrolling='no' noresize>
  <frame name="c_foot" src="off_ls_cmplt_sc.jsp?auth_rw=<%=auth_rw%>&brch_id=<%=brch_id%>&gubun=<%=gubun%>&gubun1=<%=gubun1%>&gubun_nm=<%=gubun_nm%>&dt=<%=dt%>&ref_dt1=<%=ref_dt1%>&ref_dt2=<%=ref_dt2%>&sh_height=<%=height%>&user_id=<%=user_id%>&s_au=<%=s_au%>" marginwidth=10 marginheight=10 scrolling="auto">
  <FRAME name="nodisplay" SRC="about:blank" frameborder=0 scrolling="no" topmargin=0 marginwidth="10" marginheight="10">
</frameset>
<noframes> 
</noframes> 
</HTML>