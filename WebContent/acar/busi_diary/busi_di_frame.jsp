<%@ page language="java" contentType="text/html;charset=euc-kr" %>
<%@ page import="java.util.*, acar.util.*"%>
<%@ include file="/acar/cookies.jsp" %>
<%@ include file="/acar/access_log.jsp" %>

<%
	String auth_rw = request.getParameter("auth_rw")==null?"":request.getParameter("auth_rw");
	String user_id = request.getParameter("user_id")==null?"":request.getParameter("user_id");
	String br_id = request.getParameter("br_id")==null?"":request.getParameter("br_id");
	String s_brch_id = request.getParameter("s_brch_id")==null?"":request.getParameter("s_brch_id");
	String s_dept_id = request.getParameter("s_dept_id")==null?"":request.getParameter("s_dept_id");
	String s_user_id = request.getParameter("s_user_id")==null?"":request.getParameter("s_user_id");
	
	int s_year = request.getParameter("s_year")==null?AddUtil.getDate2(1):AddUtil.parseInt(request.getParameter("s_year"));
	int s_month = request.getParameter("s_month")==null?AddUtil.getDate2(2):AddUtil.parseInt(request.getParameter("s_month"));
	int s_day = request.getParameter("s_day")==null?AddUtil.getDate2(3):AddUtil.parseInt(request.getParameter("s_day"));	
%>
<HTML>
<HEAD>
<title>FMS</title>
</HEAD>
<FRAMESET rows="100, 250,*" border=0>
	<FRAME SRC="busi_di_sh.jsp?auth_rw=<%=auth_rw%>&user_id=<%=user_id%>&br_id=<%=br_id%>&s_brch_id=<%=s_brch_id%>&s_dept_id=<%=s_dept_id%>&s_user_id=<%=s_user_id%>&s_year=<%=s_year%>&s_month=<%=s_month%>&s_day=<%=s_day%>" name="c_body" frameborder=0  marginwidth="10" marginheight="10" scrolling="no" noresize>
	<FRAME SRC="busi_di_sc.jsp?auth_rw=<%=auth_rw%>&user_id=<%=user_id%>&br_id=<%=br_id%>&s_brch_id=<%=s_brch_id%>&s_dept_id=<%=s_dept_id%>&s_user_id=<%=s_user_id%>&s_year=<%=s_year%>&s_month=<%=s_month%>&s_day=<%=s_day%>" name="c_foot" frameborder=0 scrolling="auto" topmargin=0 marginwidth="10">
	<FRAME SRC="busi_di_cont.jsp?auth_rw=<%=auth_rw%>&user_id=<%=user_id%>&br_id=<%=br_id%>&s_brch_id=<%=s_brch_id%>&s_dept_id=<%=s_dept_id%>&s_user_id=<%=s_user_id%>&s_year=<%=s_year%>&s_month=<%=s_month%>&s_day=<%=s_day%>" name="c_cont" frameborder=0 scrolling="auto" topmargin=0 marginwidth="10">
</FRAMESET>
<NOFRAMES>
<BODY>
<P>이 페이지를 보려면, 프레임을 볼 수 있는 브라우저가 필요합니다.</P>
</body>
</NOFRAMES>
</HTML>
