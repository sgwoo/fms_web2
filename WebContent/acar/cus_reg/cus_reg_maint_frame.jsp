<%@ page contentType="text/html; charset=euc-kr" %>
<%@ page language="java" %> 
<%@ include file="/acar/cookies.jsp" %>
<%@ include file="/acar/access_log.jsp" %>

<%
	int cnt = 3;//검색 라인수
	int height = cnt*sh_line_height;

%>
<%
	String auth_rw = request.getParameter("auth_rw")==null?"":request.getParameter("auth_rw");
	String s_gubun1 = request.getParameter("s_gubun1")==null?"2":request.getParameter("s_gubun1");
	String s_kd = request.getParameter("s_kd")==null?"2":request.getParameter("s_kd");
	String t_wd = request.getParameter("t_wd")==null?"":request.getParameter("t_wd");
	String mdata = request.getParameter("mdata")==null?"":request.getParameter("mdata");
	String seq = request.getParameter("seq")==null?"":request.getParameter("seq");
	String car_no = request.getParameter("car_no")==null?"":request.getParameter("car_no");
	String from_page = request.getParameter("from_page")==null?"":request.getParameter("from_page");
	String car_mng_id = request.getParameter("car_mng_id")==null?"":request.getParameter("car_mng_id");
	String client_id = request.getParameter("client_id")==null?"":request.getParameter("client_id");
	
%>

<HTML>
<HEAD>
<title>FMS</title>
</HEAD>
<FRAMESET rows="<%=height%>, *" border="0">
	<FRAME SRC="./cus_reg_sh.jsp?mdata=<%=mdata%>&auth_rw=<%=auth_rw%>&s_gubun1=<%=s_gubun1%>&s_kd=<%=s_kd%>&t_wd=<%=t_wd%>&car_mng_id=<%=car_mng_id%>&sh_height=<%=height%>&seq=<%=seq%>&car_no=<%=car_no%>" name="c_head" frameborder="0" marginwidth="10" marginheight="10" scrolling="no" noresize>	
	<FRAME SRC="./cus_reg_maint.jsp?mdata=<%=mdata%>&auth_rw=<%=auth_rw%>&s_gubun1=<%=s_gubun1%>&s_kd=<%=s_kd%>&t_wd=<%=t_wd%>&car_mng_id=<%=car_mng_id%>&client_id=<%=client_id%>&sh_height=<%=height%>" name="c_body" frameborder="0" marginwidth="10" marginheight="10" topmargin="0" scrolling="auto">
</FRAMESET>
<NOFRAMES>
<BODY>
<P>이 페이지를 보려면, 프레임을 볼 수 있는 브라우저가 필요합니다.</P>
</body>
</NOFRAMES>
</HTML>
