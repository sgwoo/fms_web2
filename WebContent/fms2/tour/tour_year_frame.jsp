<%@ page language="java" contentType="text/html;charset=euc-kr" %>
<%@ page import="java.util.*,acar.util.*"%>
<jsp:useBean id="rs_db" scope="page" class="acar.res_search.ResSearchDatabase"/>
<%@ include file="/acar/cookies.jsp" %>

<%
	int cnt = 3; //검색 라인수
	int height = cnt*sh_line_height;
%>
<%
	String auth_rw = "";
	
	if(request.getParameter("auth_rw") != null)	auth_rw = request.getParameter("auth_rw");
	String user_id = request.getParameter("user_id")==null?"":request.getParameter("user_id");
	String gubun = request.getParameter("gubun")==null?"c_year":request.getParameter("gubun");
	
	if(user_id.equals("")) 	user_id = ck_acar_id;
	if(auth_rw.equals(""))	auth_rw = rs_db.getAuthRw(user_id, "13", "01", "02");
	int year =AddUtil.getDate2(1);
%>
<HTML>
<HEAD>
<title>FMS</title>
</HEAD>
<FRAMESET rows="<%=height%>, *" border=0>
	<FRAME SRC="./tour_year_sh.jsp?gubun=<%=gubun%>&auth_rw=<%=auth_rw%>&sh_height=<%=height%>&year=<%=year%>" name="c_body" frameborder=0  marginwidth="10" marginheight="10" scrolling="no" noresize>
	<FRAME SRC="./tour_year_sc.jsp?gubun=<%=gubun%>&auth_rw=<%=auth_rw%>&sh_height=<%=height%>&year=<%=year%>" name="c_foot" frameborder=0 scrolling="auto" topmargin=0 marginwidth="10">
</FRAMESET>

<NOFRAMES>
<BODY>
<P>이 페이지를 보려면, 프레임을 볼 수 있는 브라우저가 필요합니다.</P>
</body>
</NOFRAMES>
</HTML>