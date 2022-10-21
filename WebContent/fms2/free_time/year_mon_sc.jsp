<%@ page language="java" contentType="text/html; charset=euc-kr" %>
<%@ page import="java.util.*, acar.util.*" %>
<%@ include file="/acar/cookies.jsp" %>

<%
	String auth_rw = request.getParameter("auth_rw")==null?"":request.getParameter("auth_rw");
	String br_id = request.getParameter("br_id")==null?"":request.getParameter("br_id");
	String user_id = request.getParameter("user_id")==null?"":request.getParameter("user_id");

	String st_year = request.getParameter("st_year")==null?"":request.getParameter("st_year");	
	String st_mon = request.getParameter("st_mon")==null?"":request.getParameter("st_mon");	
	String dt = request.getParameter("dt")==null?"1":request.getParameter("dt");

	int sh_height = request.getParameter("sh_height")==null?0:Util.parseInt(request.getParameter("sh_height"));//상단길이
	
	int cnt = 2; //sc 출력라인수
	int height = AddUtil.parseInt(s_height)-emp_top_height-sh_height-(cnt*sc_line_height)-150;//현황 라인수만큼 제한 아이프레임 사이즈

	String valus = 	"?auth_rw="+auth_rw+"&user_id="+user_id+"&br_id="+br_id+"&st_year="+st_year+"&st_mon="+st_mon+
				   	"&sh_height="+height+"&dt="+dt+"";
	
	
%>
<html>
<head>
<meta http-equiv="content-type" content="text/html; charset=euc-kr">
<title>FMS</title>
<link rel="stylesheet" type="text/css" href="/include/table_t.css">
<%@ include file="/acar/getNaviCookies.jsp" %>
<script language="JavaScript">
<!--
	
//-->
</script>
</head>
<body>
<table border=0 cellspacing=0 cellpadding=0 width="100%">
	<tr>
		<td colspan="2">
			<table border="0" cellspacing="0" cellpadding="0" width=100%>
				<tr>
					<td>
					<%if(dt.equals("1")){//당일%>
						<iframe src="year_mon_sc_in_d.jsp<%=valus%>" name="inner" width="100%" height="<%=height%>" cellpadding="0" cellspacing="0" border="0" frameborder="0" noresize scrolling=yes, marginwidth=0, marginheight=0 >
						</iframe>
					<%}else if(dt.equals("2")){//기간%>
						<iframe src="year_mon_sc_in_y.jsp<%=valus%>" name="inner" width="100%" height="<%=height%>" cellpadding="0" cellspacing="0" border="0" frameborder="0" noresize scrolling=yes, marginwidth=0, marginheight=0 >
						</iframe>
					<%}%>
					</td>
				</tr>
			</table>
		</td>
	</tr>
</table>
</body>
</html>