<%@ page language="java" contentType="text/html;charset=euc-kr"%>
<%@ page import="java.util.*" %>
<%@ page import="acar.util.*" %>

<%@ include file="/acar/cookies.jsp" %>
<%
	String s_kd = request.getParameter("s_kd")==null?"0":request.getParameter("s_kd");
	String t_wd = request.getParameter("t_wd")==null?"":request.getParameter("t_wd");
	String s_bank = request.getParameter("s_bank")==null?"":request.getParameter("s_bank");
	String dt = request.getParameter("dt")==null?"actn_dt":request.getParameter("dt");
	
	String gubun = request.getParameter("gubun")==null?"2":request.getParameter("gubun");
	String br_id = request.getParameter("br_id")==null?"":request.getParameter("br_id");
	String fn_id= "0";
	
	String s_year 	= request.getParameter("s_year")==null?"":request.getParameter("s_year");
	
		
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

function view_actn(s_kd, t_wd, dt, s_year, s_mon)
	{
		var fm = document.form1;
		fm.s_kd.value = s_kd;
		fm.t_wd.value = t_wd;
		fm.dt.value = dt;  
		fm.s_year.value = s_year;
		fm.s_mon.value = s_mon;
		fm.action = '/fms2/condition/auc_s_frame.jsp';
		fm.submit();
	}
//-->
</script>
</head>
<body>
<form name='form1' method='post' target='d_content'>
<input type='hidden' name='s_year' value='<%=s_year%>'>
<input type='hidden' name='s_mon' >
<input type='hidden' name='dt' value='<%=dt%>'>
<input type='hidden' name='s_kd'  value='<%=s_kd%>'>
<input type='hidden' name='t_wd' value='<%=t_wd%>'>	
 <input type='hidden' name='sh_height' value='<%=sh_height%>'> 
</form>

<table border=0 cellspacing=0 cellpadding=0 width='100%'>
    <tr>
    	<td><iframe src="/fms2/condition/auc_s1_sc_in.jsp?s_kd=<%=s_kd%>&t_wd=<%=t_wd%>&dt=<%=dt%>&s_year=<%=s_year%>" name="inner" width="100%" height="<%=height%>" cellpadding="0" cellspacing="0" border="0" frameborder="0" noresize scrolling=yes, marginwidth=0, marginheight=0></iframe></td>
    </tr>
	<tr>
    <td><img src="../../images/blank.gif" height="2"></td>
  </tr>

</table>
</body>
</html>