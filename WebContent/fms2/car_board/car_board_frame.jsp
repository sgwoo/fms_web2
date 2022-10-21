<%@ page language="java" contentType="text/html;charset=euc-kr"%>
<%@ page import="java.util.*, acar.util.*"%>
<jsp:useBean id="rs_db" scope="page" class="acar.res_search.ResSearchDatabase"/>
<%@ include file="/acar/cookies.jsp" %>

<HTML>
<HEAD>
<TITLE>FMS</TITLE>
</HEAD>
<%
	String auth_rw 	= request.getParameter("auth_rw")==null?"":request.getParameter("auth_rw");
	String user_id = request.getParameter("user_id")==null?ck_acar_id:request.getParameter("user_id");
	String car_mng_id 	= request.getParameter("car_mng_id")==null?"":request.getParameter("car_mng_id");
	String gubun 	= request.getParameter("gubun")==null?"":request.getParameter("gubun");
	String l_cd 	= request.getParameter("l_cd")==null?"":request.getParameter("l_cd");
	String m_id 	= request.getParameter("m_id")==null?"":request.getParameter("m_id");

	
	//로그인ID&영업소ID&권한
	LoginBean login = LoginBean.getInstance();
	if(user_id.equals(""))	user_id = login.getCookieValue(request, "acar_id");
	
	if(auth_rw.equals(""))	auth_rw = rs_db.getAuthRw(user_id, "03", "01", "01");
	
	
	
%>
<frameset rows="210,*" border=1>
  <frame src="car_board_sh.jsp?auth_rw=<%=auth_rw%>&car_mng_id=<%=car_mng_id%>&m_id=<%=m_id%>&l_cd=<%=l_cd%>&gubun=<%=gubun%>" name="cm_head" marginwidth=10 marginheight=10 scrolling="auto" noresize>
  <frame src="car_board_sc.jsp?auth_rw=<%=auth_rw%>&car_mng_id=<%=car_mng_id%>&m_id=<%=m_id%>&l_cd=<%=l_cd%>&gubun=<%=gubun%>" name="cm_foot" marginwidth=10 marginheight=10 scrolling="auto">
</frameset>
</HTML>