<%@ page language="java" contentType="text/html;charset=euc-kr"%>
<%@ page import="java.util.*" %>
<%@ page import="acar.util.*" %>
<%@ page import="acar.condition.*" %>
<%@ include file="/acar/cookies.jsp" %>
<%
	String auth_rw 		= request.getParameter("auth_rw")==null?"":request.getParameter("auth_rw");
	String car_off_id	= request.getParameter("car_off_id")==null?"":request.getParameter("car_off_id");
	String s_kd 		= request.getParameter("s_kd")==null?"0":request.getParameter("s_kd");
	String t_wd 		= request.getParameter("t_wd")==null?"":request.getParameter("t_wd");
	String dt 		= request.getParameter("dt")==null?"0":request.getParameter("dt");
	String t_st_dt 		= request.getParameter("t_st_dt")==null?"":request.getParameter("t_st_dt");
	String t_end_dt 	= request.getParameter("t_end_dt")==null?"":request.getParameter("t_end_dt");
	
	//height
	int sh_height = request.getParameter("sh_height")==null?0:Util.parseInt(request.getParameter("sh_height"));//상단길이
	
	int cnt = 3; //현황 출력 영업소 총수
	int height = AddUtil.parseInt(s_height)-emp_top_height-sh_height-(cnt*sc_line_height)-75;//현황 라인수만큼 제한 아이프레임 사이즈
%>
<html>
<head>
<meta http-equiv="content-type" content="text/html; charset=euc-kr">
<title>FMS</title>
<link rel='stylesheet' type='text/css' href='/include/table_t.css'>
<script language="JavaScript">
<!--
 	//엑셀
	function execl(){
		var fm = document.form1;
		fm.target ='_blank';
		fm.action = 'dlv_condition_sc_in_excel.jsp';
		fm.submit();
	}	
//-->
</script>
</head>
<body>
<form name='form1' method='post'>
  <input type='hidden' name='auth_rw'  	value='<%=auth_rw%>'>
  <input type='hidden' name='car_off_id' value='<%=car_off_id%>'>			
  <input type='hidden' name='s_kd'  	value='<%=s_kd%>'>
  <input type='hidden' name='t_wd' 	value='<%=t_wd%>'>			  
  <input type='hidden' name='dt' 	value='<%=dt%>'>
  <input type='hidden' name='t_st_dt' 	value='<%=t_st_dt%>'>
  <input type='hidden' name='t_end_dt'	value='<%=t_end_dt%>'>
<table border=0 cellspacing=0 cellpadding=0 width='100%'>
    <tr>
	<td>
	    <a href="javascript:execl();"><img src=/acar/images/center/button_excel.gif border=0 align=absmiddle></a>
	</td>
    </tr>
    <tr>
    	<td><iframe src="dlv_condition_sc_in.jsp?auth_rw=<%=auth_rw%>&car_off_id=<%=car_off_id%>&s_kd=<%=s_kd%>&t_wd=<%=t_wd%>&dt=<%=dt%>&t_st_dt=<%=t_st_dt%>&t_end_dt=<%=t_end_dt%>" name="inner" width="100%" height="<%=height%>" cellpadding="0" cellspacing="0" border="0" frameborder="0" noresize scrolling=yes, marginwidth=0, marginheight=0></iframe></td>
    </tr>
</table>
</form>
</body>
</html>