<%@ page language="java" contentType="text/html;charset=euc-kr" %>
<%@ page import="java.util.*, acar.util.*"%>
<%@ include file="/acar/cookies.jsp" %>

<%
	int cnt = 7; //검색 라인수
	int height = cnt*sh_line_height+50;
%>
<%
	String auth_rw = request.getParameter("auth_rw")==null?"":request.getParameter("auth_rw");
	String br_id = request.getParameter("br_id")==null?"":request.getParameter("br_id");//로그인-영업소
	String off_type 	= request.getParameter("off_type")==null?"1":request.getParameter("off_type");
	String cmd 	= request.getParameter("cmd")==null?"":request.getParameter("cmd");
	String off_id 	= request.getParameter("off_id")==null?"":request.getParameter("off_id");
	
	//로그인사용자정보 가져오기
	LoginBean login = LoginBean.getInstance();
	String user_id = login.getCookieValue(request, "acar_id");
%>
<HTML>
<HEAD>
<TITLE>FMS</TITLE>
</HEAD>
<FRAMESET rows="<%=height%>, *" border=0>
	<FRAME SRC="serv_sd_view_sh.jsp?off_id=<%=off_id%>&auth_rw=<%=auth_rw%>&user_id=<%=user_id%>&br_id=<%=br_id%>&sh_height=<%=height%>" name="c_body" frameborder=0  marginwidth="10" marginheight="10" scrolling="auto" noresize>
	<FRAME SRC="serv_sd_view_sc.jsp?off_id=<%=off_id%>auth_rw=<%=auth_rw%>&user_id=<%=user_id%>&br_id=<%=br_id%>&sh_height=<%=height%>" name="c_foot" frameborder=0 scrolling="auto" topmargin=0 marginwidth="10">
</FRAMESET>
<NOFRAMES>
<BODY>
<P>이 페이지를 보려면, 프레임을 볼 수 있는 브라우저가 필요합니다.</P>
</body>
</NOFRAMES>
</HTML>