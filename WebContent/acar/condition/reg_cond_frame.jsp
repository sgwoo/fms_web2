<%@ page contentType="text/html; charset=euc-kr" %>
<%@ page language="java" %>
<%@ include file="/acar/cookies.jsp" %>
<%@ include file="/acar/access_log.jsp" %>
<%
	int cnt = 2; //검색 라인수
	int height = cnt*sh_line_height+20;

%>
<%
	String auth_rw = "";
	
	if(request.getParameter("auth_rw") != null)	auth_rw = request.getParameter("auth_rw");

%> 

<HTML>
<HEAD>
<title>FMS</title>
</HEAD>
 <FRAMESET rows="<%=height%>, *" border=0>
	<FRAME SRC="./reg_cond_sh.jsp?sh_height=<%=height%>" name="c_body" frameborder=0  marginwidth="10" marginheight="10" scrolling="no" noresize>
	<FRAME SRC="./reg_cond_sc.jsp?auth_rw=<%=auth_rw%>&sh_height=<%=height%>" name="c_foot" frameborder=0  topmargin=0 marginwidth="10" scrolling="auto">
</FRAMESET> 

<NOFRAMES>
<BODY>
<P>이 페이지를 보려면, 프레임을 볼 수 있는 브라우저가 필요합니다.</P>
</body>
</NOFRAMES>
</HTML>
