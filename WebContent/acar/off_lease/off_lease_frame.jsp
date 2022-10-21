<%@ page language="java" contentType="text/html;charset=euc-kr" %>
<%@ include file="/acar/cookies.jsp" %>
<%@ include file="/acar/access_log.jsp" %>

<%
	int cnt = 4; //검색 라인수
	int height = cnt*sh_line_height;
%>
<%
	String auth_rw = request.getParameter("auth_rw")==null?"":request.getParameter("auth_rw");
	String br_id = request.getParameter("br_id")==null?"":request.getParameter("br_id");
	String brch_id = request.getParameter("brch_id")==null?"":request.getParameter("brch_id");
	String gubun = request.getParameter("gubun")==null?"":request.getParameter("gubun");
	String gubun_nm = request.getParameter("gubun_nm")==null?"":request.getParameter("gubun_nm");
	String gubun2 = request.getParameter("gubun2")==null?"":request.getParameter("gubun2");
	String gubun3 = request.getParameter("gubun3")==null?"Y":request.getParameter("gubun3");
	String cjgubun = request.getParameter("cjgubun")==null?"all":request.getParameter("cjgubun");
%>
<HTML>
<HEAD>
<TITLE>FMS</TITLE>
</HEAD>
<frameset rows="<%=height%>,*,1" border=1 cols="*"> 
  <frame name="c_body" src="off_lease_sh.jsp?auth_rw=<%=auth_rw%>&brch_id=<%=brch_id%>&gubun=<%=gubun%>&gubun_nm=<%=gubun_nm%>&gubun2=<%=gubun2%>&gubun3=<%=gubun3%>&cjgubun=<%=cjgubun%>&sh_height=<%=height%>" marginwidth=10 marginheight=10 scrolling='no' noresize>
  <frame name="c_foot" src="off_lease_sc.jsp?auth_rw=<%=auth_rw%>&brch_id=<%=brch_id%>&gubun=<%=gubun%>&gubun_nm=<%=gubun_nm%>&gubun2=<%=gubun2%>&gubun3=<%=gubun3%>&cjgubun=<%=cjgubun%>&sh_height=<%=height%>" marginwidth=10 marginheight=10 scrolling="no" noresize>
  <FRAME name="nodisplay" SRC="about:blank" frameborder=0 scrolling="no" topmargin=0 marginwidth="10" marginheight="10">
</frameset>
<noframes> 
</noframes> 
</HTML>
