<%@ page language="java" contentType="text/html;charset=euc-kr"%>
<%@ page import="java.util.*" %>
<%@ page import="acar.util.*" %>
<%@ include file="/acar/cookies.jsp" %>
<html>
<head>
<meta http-equiv="content-type" content="text/html; charset=euc-kr">
<title>FMS</title>
<link rel='stylesheet' type='text/css' href='/include/table.css'>
<%@ include file="/acar/getNaviCookies.jsp" %>
<script language="JavaScript">
<!--
//-->
</script>
</head>
<%
	String auth_rw 		= request.getParameter("auth_rw")==null?"":request.getParameter("auth_rw");
	String s_kd = request.getParameter("s_kd")==null?"0":request.getParameter("s_kd");
	String t_wd = request.getParameter("t_wd")==null?"":request.getParameter("t_wd");
	String ins_com = request.getParameter("ins_com")==null?"":request.getParameter("ins_com");
	
	//height
	int sh_height = request.getParameter("sh_height")==null?0:Util.parseInt(request.getParameter("sh_height"));//상단길이
	
	int cnt = 2; //현황 출력 영업소 총수
	int height = AddUtil.parseInt(s_height)-emp_top_height-sh_height-(cnt*sc_line_height)-90;//현황 라인수만큼 제한 아이프레임 사이즈
%>
<body>
<table border=0 cellspacing=0 cellpadding=0 width='100%'>
    <tr>
    	<td colspan='2'>
			<iframe src="/acar/condition/car_condition_sc_in.jsp?s_kd=<%=s_kd%>&t_wd=<%=t_wd%>&ins_com=<%=ins_com%>" name="inner" width="100%" height="<%=height%>" cellpadding="0" cellspacing="0" border="0" frameborder="0" noresize scrolling=yes, marginwidth=0, marginheight=0 >
			</iframe>    	
    	</td>
    </tr>
</table>
</body>
</html>