<%@ page language="java" contentType="text/html;charset=euc-kr" %>
<%@ page import="java.util.*, acar.util.*"%>
<%@ include file="/acar/cookies.jsp" %>
<%@ include file="/acar/access_log.jsp" %>

<%
	int cnt = 2; //검색 라인수
	int height = (cnt*sh_line_height)+(cnt*1)+30;
%>
<%
	String auth_rw 	= request.getParameter("auth_rw")==null?"":request.getParameter("auth_rw");
	String br_id 	= request.getParameter("br_id")==null?"":request.getParameter("br_id");
	String user_id 	= request.getParameter("user_id")==null?"":request.getParameter("user_id");
	
	String s_yy 	= request.getParameter("s_yy")==null?"":request.getParameter("s_yy");
	String s_mm 	= request.getParameter("s_mm")==null?"":request.getParameter("s_mm");
	
	if(s_yy.equals("")) s_yy = AddUtil.getDate(1);
	if(s_mm.equals("")) s_mm = AddUtil.getDate(2);
	
	String valus = 	"?auth_rw="+auth_rw+"&user_id="+user_id+"&br_id="+br_id+
					"&s_yy="+s_yy+"&s_mm="+s_mm+
				   	"&sh_height="+height+"";	
%>
<HTML>
<HEAD>
<title>FMS</title>
</HEAD>
<FRAMESET rows="<%=height%>, *" border=0>
	<FRAME SRC="fee_dly_stat_sh.jsp<%=valus%>" name="c_body" frameborder=0 marginwidth="10" marginheight="10" scrolling="no" noresize>
	<FRAME SRC="fee_dly_stat_sc.jsp<%=valus%>" name="c_foot" frameborder=0 marginwidth="10" topmargin=0 scrolling="yes" noresize>
</FRAMESET>
<NOFRAMES>
<BODY>
<P>이 페이지를 보려면, 프레임을 볼 수 있는 브라우저가 필요합니다.</P>
</body>
</NOFRAMES>
</HTML>