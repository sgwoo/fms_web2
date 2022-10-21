<%@ page contentType="text/html; charset=euc-kr" %>
<%@ page language="java" %> 
<%@ page import="java.util.*, acar.util.*"%>
<%@ include file="/acar/cookies.jsp" %>
<%@ include file="/acar/access_log.jsp" %>

<%
	int cnt = 3;//검색 라인수
	int height = cnt*sh_line_height;
%>
<%
	String auth_rw = request.getParameter("auth_rw")==null?"":request.getParameter("auth_rw");
	String s_gubun1 = request.getParameter("s_gubun1")==null?"1":request.getParameter("s_gubun1");
	String s_kd = request.getParameter("s_kd")==null?"":request.getParameter("s_kd");
	String t_wd = request.getParameter("t_wd")==null?"":request.getParameter("t_wd");
	
	String seq = request.getParameter("seq")==null?"":request.getParameter("seq");
	String car_no = request.getParameter("car_no")==null?"":request.getParameter("car_no");
	String from_page = request.getParameter("from_page")==null?"":request.getParameter("from_page");
	
	String st_dt="";
	String end_dt="";
	
	if(t_wd.equals("") && st_dt.equals("") && end_dt.equals("")){
		st_dt 	= AddUtil.getDate(1)+"-"+AddUtil.getDate(2)+"-"+"01";		
	  	end_dt = AddUtil.getDate();
	}
		
%>

<HTML>
<HEAD>
<title>FMS</title>
</HEAD>
<FRAMESET rows="<%=height%>, *" border="0">
	<FRAME SRC="./parts_s_sh.jsp?auth_rw=<%=auth_rw%>&s_gubun1=<%=s_gubun1%>&st_dt=<%=st_dt%>&end_dt=<%=end_dt%>&s_kd=<%=s_kd%>&t_wd=<%=t_wd%>&sh_height=<%=height%>&seq=<%=seq%>&car_no=<%=car_no%>" name="c_head" frameborder="0" marginwidth="10" marginheight="10" scrolling="no" noresize>
	<FRAME SRC="./parts_s_sc.jsp?auth_rw=<%=auth_rw%>&s_gubun1=<%=s_gubun1%>&st_dt=<%=st_dt%>&end_dt=<%=end_dt%>&s_kd=<%=s_kd%>&t_wd=<%=t_wd%>&sh_height=<%=height%>&seq=<%=seq%>&car_no=<%=car_no%>" name="c_body" frameborder="0" marginwidth="10" marginheight="10" topmargin="0" scrolling="auto">
	
</FRAMESET>
<NOFRAMES>
<BODY>
<P>이 페이지를 보려면, 프레임을 볼 수 있는 브라우저가 필요합니다.</P>
</body>
</NOFRAMES>
</HTML>
