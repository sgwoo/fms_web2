<%@ page language="java" contentType="text/html;charset=euc-kr"%>
<%@ page import="java.util.*" %>
<%@ page import="acar.util.*" %>
<%@ page import="acar.condition.*" %>
<%@ include file="/acar/cookies.jsp" %>
<%
	String s_kd = request.getParameter("s_kd")==null?"0":request.getParameter("s_kd");
	String t_wd = request.getParameter("t_wd")==null?"":request.getParameter("t_wd");
	String s_bank = request.getParameter("s_bank")==null?"":request.getParameter("s_bank");
	String dt = request.getParameter("dt")==null?"2":request.getParameter("dt");
	String t_st_dt = request.getParameter("t_st_dt")==null?"":request.getParameter("t_st_dt");
	String t_end_dt = request.getParameter("t_end_dt")==null?"":request.getParameter("t_end_dt");
	String gubun = request.getParameter("gubun")==null?"2":request.getParameter("gubun");
	String br_id = request.getParameter("br_id")==null?"":request.getParameter("br_id");
	String fn_id= "0";
	
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

function view_cont(m_id, l_cd)
	{
		var fm = document.form1;
		fm.m_id.value = m_id;
		fm.l_cd.value = l_cd;
		fm.mode.value = '4'; /*조회*/
		fm.g_fm.value = '1';
		fm.submit();
	}
//-->
</script>
</head>
<body>
<table border=0 cellspacing=0 cellpadding=0 width='100%'>
    <tr>
    	<td><iframe src="/acar/condition/dlv_condition_sc_in.jsp?height=<%=height%>&s_kd=<%=s_kd%>&t_wd=<%=t_wd%>&dt=<%=dt%>&t_st_dt=<%=t_st_dt%>&t_end_dt=<%=t_end_dt%>" name="inner" width="100%" height="<%=height%>" cellpadding="0" cellspacing="0" border="0" frameborder="0" noresize scrolling=yes, marginwidth=0, marginheight=0></iframe></td>
    </tr>
	<tr>
    <td><img src="../../images/blank.gif" height="2"></td>
  </tr>

</table>
</body>
</html>