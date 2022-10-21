<%@ page contentType="text/html; charset=euc-kr" %>
<%@ page language="java" %> 
<%@ include file="/agent/cookies.jsp" %>
<%@ include file="/agent/access_log.jsp" %>

<%
	int cnt = 2; //검색 라인수
	int height = cnt*sh_line_height+20;

%>
<%
	String s_kd 		= request.getParameter("s_kd")==null?"":request.getParameter("s_kd");
	String t_wd 		= request.getParameter("t_wd")==null?"":request.getParameter("t_wd");
	String sort_gubun 	= request.getParameter("sort_gubun")==null?"":request.getParameter("sort_gubun");
	String sort			= request.getParameter("sort")==null?"":request.getParameter("sort");
	String off_id 		= request.getParameter("off_id")==null?"":request.getParameter("off_id");
	String from_page 	= request.getParameter("from_page")==null?"":request.getParameter("from_page");
%>
<HTML>
<HEAD>
<TITLE>FMS</TITLE>
</HEAD>
<FRAMESET rows="<%=height%>, *" border="0">
	<FRAME SRC="./cus0602_sh.jsp?s_kd=<%=s_kd%>&t_wd=<%=t_wd%>&sort_gubun=<%=sort_gubun%>&sort=<%=sort%>&off_id=<%=off_id%>&sh_height=<%=height%>&from_page=<%=from_page%>" name="c_head" frameborder="0" marginwidth="10" marginheight="10" scrolling="no" noresize>
	<FRAME SRC="./cus0602_sc.jsp?s_kd=<%=s_kd%>&t_wd=<%=t_wd%>&sort_gubun=<%=sort_gubun%>&sort=<%=sort%>&off_id=<%=off_id%>&sh_height=<%=height%>&from_page=<%=from_page%>" name="c_body" frameborder="0" marginwidth="10" marginheight="10" topmargin="0" scrolling="auto">
</FRAMESET>
<NOFRAMES>
<BODY>
<P>이 페이지를 보려면, 프레임을 볼 수 있는 브라우저가 필요합니다.</P>
</body>
</NOFRAMES>
</HTML>