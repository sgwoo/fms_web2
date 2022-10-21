<%@ page language="java" contentType="text/html; charset=euc-kr" %>
<%@ page import="java.util.*, acar.util.*" %>
<%@ include file="/acar/cookies.jsp" %>

<%
	String auth_rw = request.getParameter("auth_rw")==null?"":request.getParameter("auth_rw"); //권한
	String st = request.getParameter("st")==null?"2":request.getParameter("st");
	String f_st = request.getParameter("f_st")==null?"1":request.getParameter("f_st");
	String gubun = request.getParameter("gubun")==null?"":request.getParameter("gubun");
	String gubun_nm = request.getParameter("gubun_nm")==null?"":request.getParameter("gubun_nm");
	int s_year = request.getParameter("s_year")==null?AddUtil.getDate2(1):AddUtil.parseInt(request.getParameter("s_year"));
	
	String rent_mng_id = request.getParameter("rent_mng_id")	==null?"":request.getParameter("rent_mng_id");
	String rent_l_cd = request.getParameter("rent_l_cd")	==null?"":request.getParameter("rent_l_cd");
	String car_mng_id = request.getParameter("car_mng_id")	==null?"":request.getParameter("car_mng_id");
%>
<HTML>
<HEAD>
<TITLE>FMS</TITLE>
</HEAD>
<FRAMESET rows="365, *, 0" border=0>
	<FRAME SRC="./forfeit_i_sh.jsp?auth_rw=<%=auth_rw%>&car_mng_id=<%=car_mng_id%>&rent_mng_id=<%=rent_mng_id%>&rent_l_cd=<%=rent_l_cd%>&st=<%=st%>&f_st=<%=f_st%>&s_year=<%=s_year%>&gubun=<%=gubun%>&gubun_nm=<%=gubun_nm%>" name="c_body" frameborder=0  marginwidth="10" marginheight="10" scrolling="no" noresize>
	<FRAME SRC="./forfeit_i_sc.jsp?auth_rw=<%=auth_rw%>&car_mng_id=<%=car_mng_id%>&rent_mng_id=<%=rent_mng_id%>&rent_l_cd=<%=rent_l_cd%>&st=<%=st%>&f_st=<%=f_st%>&s_year=<%=s_year%>&gubun=<%=gubun%>&gubun_nm=<%=gubun_nm%>" name="c_foot" frameborder=0 scrolling="auto" topmargin=0 marginwidth="10">
	<FRAME SRC="about:blank" name="nodisplay" frameborder=0 scrolling="no" topmargin=0 marginwidth="10" marginheight="10">
</FRAMESET>
<NOFRAMES>
<BODY>
<P>이 페이지를 보려면, 프레임을 볼 수 있는 브라우저가 필요합니다.</P>
</body>
</NOFRAMES>
</HTML>