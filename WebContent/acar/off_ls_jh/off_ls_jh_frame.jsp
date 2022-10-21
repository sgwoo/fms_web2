<%@ page language="java" contentType="text/html;charset=euc-kr" %>
<%@ page import="java.util.*,acar.util.*"%>
<jsp:useBean id="rs_db" scope="page" class="acar.res_search.ResSearchDatabase"/>
<%@ include file="/acar/cookies.jsp" %>
<%@ include file="/acar/access_log.jsp" %>

<%
	int cnt = 4; //검색 라인수
	int height = cnt*sh_line_height;
%>
<%
	String auth_rw 	= request.getParameter("auth_rw")==null?"":request.getParameter("auth_rw");
	String user_id 	= request.getParameter("user_id")==null?"":request.getParameter("user_id");
	String br_id 	= request.getParameter("br_id")==null?"":request.getParameter("br_id");
	
	String brch_id 	= request.getParameter("brch_id")==null?"":request.getParameter("brch_id");
	
	
	//로그인ID&영업소ID&권한
	if(user_id.equals("")) 	user_id = ck_acar_id;
	if(br_id.equals(""))		br_id 	= acar_br;
	if(auth_rw.equals(""))	auth_rw = rs_db.getAuthRw(user_id, "06", "03", "01");
		
%>
<HTML>
<HEAD>
<TITLE>FMS</TITLE>
</HEAD>
<frameset rows="<%=height%>,*,1" border=1 cols="*"> 
  <frame name="c_body" src="off_ls_jh_sh.jsp?auth_rw=<%=auth_rw%>&brch_id=<%=brch_id%>&sh_height=<%=height%>" marginwidth=10 marginheight=10 scrolling='no' noresize>
  <frame name="c_foot" src="off_ls_jh_sc.jsp?auth_rw=<%=auth_rw%>&brch_id=<%=brch_id%>&sh_height=<%=height%>" marginwidth=10 marginheight=10 scrolling="no" noresize>
  <FRAME name="nodisplay" SRC="about:blank" frameborder=0 scrolling="no" topmargin=0 marginwidth="10" marginheight="10">
</frameset>
<noframes> 
</noframes>
</HTML>