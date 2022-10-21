<%@ page language="java" contentType="text/html;charset=euc-kr" %>
<%@ page import="java.util.*,acar.util.*"%>
<%@ include file="/acar/cookies.jsp" %>
<%@ include file="/acar/access_log.jsp" %>

<%
	int cnt = 4; //검색 라인수
	int height = cnt*sh_line_height-20;
%>
<%
	String auth_rw = request.getParameter("auth_rw")==null?"":request.getParameter("auth_rw");
	String br_id = request.getParameter("br_id")==null?"":request.getParameter("br_id");
	String user_id = request.getParameter("user_id")==null?"":request.getParameter("user_id");
	
	int st_year = request.getParameter("st_year")==null?AddUtil.getDate2(1):Integer.parseInt(request.getParameter("st_year"));	
	int st_mon = request.getParameter("st_mon")==null?AddUtil.getDate2(2):Integer.parseInt(request.getParameter("st_mon"));		
	String dt = request.getParameter("dt")==null?"1":request.getParameter("dt");

	String valus = 	"?auth_rw="+auth_rw+"&user_id="+user_id+"&br_id="+br_id+"&st_year="+st_year+"&st_mon="+st_mon+
			   	"&sh_height="+height+"&dt="+dt+"";
	
	
%>
<HTML>
<HEAD>
<title>FMS</title>
</HEAD>
<FRAMESET rows="<%=height%>, *" border=0>
	<FRAME SRC="./year_mon_sh.jsp<%=valus%>" name="c_body" frameborder=0  marginwidth="10" marginheight="10" scrolling="no" noresize>
	<FRAME SRC="./year_mon_sc_in_d.jsp<%=valus%>" name="c_foot" frameborder=0 scrolling="auto" topmargin=10 marginwidth="10">
</FRAMESET>

<NOFRAMES>
<BODY>
<P>이 페이지를 보려면, 프레임을 볼 수 있는 브라우저가 필요합니다.</P>
</body>
</NOFRAMES>
</HTML>
