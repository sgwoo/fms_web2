<%@ page language="java" contentType="text/html; charset=euc-kr" %>
<%@ page import="java.util.*,acar.util.*"%>
<%@ include file="/acar/cookies.jsp" %>
<%@ include file="/acar/access_log.jsp" %>
<%
	int cnt = 4; //검색 라인수
	int height = cnt*sh_line_height+20;
%>

<%
	String auth_rw 		= request.getParameter("auth_rw")	==null?"":request.getParameter("auth_rw");
	String user_id 		= request.getParameter("user_id")	==null?"":request.getParameter("user_id");
	String br_id 		= request.getParameter("br_id")		==null?"":request.getParameter("br_id");
	
	String gubun 		= request.getParameter("gubun")		==null?"":request.getParameter("gubun");
	String gubun_nm 	= request.getParameter("gubun_nm")	==null?"":request.getParameter("gubun_nm");
	String sort_gubun 	= request.getParameter("sort_gubun")	==null?"car_kind":request.getParameter("sort_gubun");
	String brch_id 		= request.getParameter("brch_id")	==null?"":request.getParameter("brch_id");
	String gubun2 		= request.getParameter("gubun2")	==null?"":request.getParameter("gubun2");
	String res_yn 		= request.getParameter("res_yn")	==null?"":request.getParameter("res_yn");
	String res_mon_yn	= request.getParameter("res_mon_yn")	==null?"":request.getParameter("res_mon_yn");
	String all_car_yn	= request.getParameter("all_car_yn")	==null?"":request.getParameter("all_car_yn");
%>

<HTML>
<HEAD>
<title>FMS</title>
</HEAD>
<FRAMESET rows="<%=height%>, *" border="0">
	<FRAME SRC="./secondhand_sh.jsp?auth_rw=<%=auth_rw%>&user_id=<%=user_id%>&br_id=<%=br_id%>&gubun=<%=gubun%>&gubun2=<%=gubun2%>&gubun_nm=<%=gubun_nm%>&sort_gubun=<%=sort_gubun%>&brch_id=<%=brch_id%>&sh_height=<%=height%>&res_yn=<%=res_yn%>&res_mon_yn=<%=res_mon_yn%>&all_car_yn=<%=all_car_yn%>&sh_height=<%=height%>" name="c_head" frameborder="0" marginwidth="10" marginheight="10" scrolling="no" noresize>
	<FRAME SRC="./secondhand_sc.jsp?auth_rw=<%=auth_rw%>&user_id=<%=user_id%>&br_id=<%=br_id%>&gubun=<%=gubun%>&gubun2=<%=gubun2%>&gubun_nm=<%=gubun_nm%>&sort_gubun=<%=sort_gubun%>&brch_id=<%=brch_id%>&sh_height=<%=height%>&res_yn=<%=res_yn%>&res_mon_yn=<%=res_mon_yn%>&all_car_yn=<%=all_car_yn%>&sh_height=<%=height%>" name="c_body" frameborder="0" marginwidth="10" marginheight="10" topmargin="0" scrolling="auto">
</FRAMESET>
<NOFRAMES>
<BODY>
<P>이 페이지를 보려면, 프레임을 볼 수 있는 브라우저가 필요합니다.</P>
</body>
</NOFRAMES>
</HTML>
