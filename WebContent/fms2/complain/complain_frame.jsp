<%@ page language="java" contentType="text/html;charset=euc-kr" %>
<%@ page import="java.util.*, acar.util.*"%>
<jsp:useBean id="rs_db" scope="page" class="acar.res_search.ResSearchDatabase"/>
<%@ include file="/acar/cookies.jsp" %>
<%@ include file="/acar/access_log.jsp" %>

<%
	int cnt = 4; //검색 라인수
	int height = (cnt*sh_line_height)+(cnt*1)+30;
	
%>
<%
	String auth_rw = request.getParameter("auth_rw")==null?"":request.getParameter("auth_rw");
	String user_id = request.getParameter("user_id")==null?"":request.getParameter("user_id");
	String gubun = request.getParameter("gubun")==null?"c_year":request.getParameter("gubun");
	String gubun_nm = request.getParameter("gubun_nm")==null?"":request.getParameter("gubun_nm");
	String gubun_st = request.getParameter("gubun_st")==null?"1":request.getParameter("gubun_st");
	
	if(user_id.equals("")) 	user_id = ck_acar_id;
	if(auth_rw.equals(""))	auth_rw = rs_db.getAuthRw(user_id, "13", "01", "02");

	
%>
<HTML>
<HEAD>
<title>FMS</title>
</HEAD>
<FRAMESET rows="<%=height%>, *" border=0>
	<FRAME SRC="./complain_sh.jsp?user_id=<%=user_id%>&s_width=<%=s_width%>&s_height=<%=s_height%>&gubun=<%=gubun%>&auth_rw=<%=auth_rw%>&gubun_nm=<%=gubun_nm%>&gubun_st=<%=gubun_st%>" name="c_body" frameborder=0  marginwidth="10" marginheight="10" scrolling="no" noresize>
	<%if(gubun_st.equals("1")){%>
	<FRAME SRC="./complain_sc.jsp?user_id=<%=user_id%>&s_width=<%=s_width%>&s_height=<%=s_height%>&gubun=<%=gubun%>&auth_rw=<%=auth_rw%>&gubun_nm=<%=gubun_nm%>&gubun_st=<%=gubun_st%>" name="c_foot" frameborder=0 scrolling="auto" topmargin=0 marginwidth="10">
	<%}else{%>
	<FRAME SRC="/fms2/m_bbs/m_bbs_sc.jsp?user_id=<%=user_id%>&s_width=<%=s_width%>&s_height=<%=s_height%>&s_kd=<%=gubun%>&auth_rw=<%=auth_rw%>&t_wd=<%=gubun_nm%>&gubun_st=<%=gubun_st%>" name="c_foot" frameborder=0 scrolling="auto" topmargin=0 marginwidth="10">
	<%}%>
</FRAMESET>

<NOFRAMES>
<BODY>
<P>이 페이지를 보려면, 프레임을 볼 수 있는 브라우저가 필요합니다.</P>
</body>
</NOFRAMES>
</HTML>
