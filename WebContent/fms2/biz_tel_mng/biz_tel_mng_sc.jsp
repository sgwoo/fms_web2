<%@ page contentType="text/html; charset=euc-kr" %>
<%@ page language="java" %> 
<%@ page import="java.util.*" %>
<%@ page import="acar.util.*" %>
<%@ page import="acar.estimate_mng.*" %>
<%@ include file="/acar/cookies.jsp" %>

<%
	String auth_rw = request.getParameter("auth_rw")==null?"":request.getParameter("auth_rw");
	String br_id = request.getParameter("br_id")==null?"":request.getParameter("br_id");
	String user_id = request.getParameter("user_id")==null?"":request.getParameter("user_id");
	String gubun = request.getParameter("gubun")==null?"1":request.getParameter("gubun");
	String s_dt = request.getParameter("s_dt")==null?"":request.getParameter("s_dt");
	String e_dt = request.getParameter("e_dt")==null?"":request.getParameter("e_dt");
	String s_kd = request.getParameter("s_kd")==null?"":request.getParameter("s_kd");
	String t_wd = request.getParameter("t_wd")==null?"":request.getParameter("t_wd");
	
	//height
	int sh_height = request.getParameter("sh_height")==null?0:Util.parseInt(request.getParameter("sh_height"));//상단길이
	
	int cnt = 0; //현황 출력 영업소 총수
	int height = AddUtil.parseInt(s_height)-emp_top_height-sh_height-(cnt*sc_line_height)-110;//현황 라인수만큼 제한 아이프레임 사이즈
%>
<html>
<head>
<meta http-equiv="content-type" content="text/html; charset=euc-kr">
<title>FMS</title>
<link rel="stylesheet" type="text/css" href="../../include/table.css">
<script language="JavaScript">
<!--
	function Biz_tel_reg(){
		var SUBWIN="biz_tel_mng_i.jsp";	
		window.open(SUBWIN, "Biz_tel_Input", "left=25, top=25, width=650, height=700, resizable=yes, scrollbars=yes, status=yes");
	}
	
	function BranchUpdate(tel_mng_id)
{
	
	var SUBWIN="biz_tel_mng_u.jsp?tel_mng_id="+tel_mng_id;	
	window.open(SUBWIN, "Biz_tel_modify", "left=100, top=100, width=650, height=700, resizable=yes, scrollbars=yes, status=yes");
}
	
//-->
</script>
</head>
<body>
<table border=0 cellspacing=0 cellpadding=0 width=100%>
	<tr>
		<td align="right"><a href="javascript:Biz_tel_reg()" onMouseOver="window.status=''; return true"><img src=/acar/images/center/button_reg.gif align=absmiddle border=0></a>&nbsp;&nbsp;&nbsp;&nbsp;</td>
	</tr>
  <tr>
	<td>
		<table border="0" cellspacing="1" cellpadding="0" width=100%>
		  <tr>
			<td colspan=2><iframe src="./biz_tel_mng_in.jsp?auth_rw=<%=auth_rw%>&br_id=<%=br_id%>&user_id=<%=user_id%>&gubun=<%=gubun%>&s_dt=<%=s_dt%>&e_dt=<%=e_dt%>&s_kd=<%=s_kd%>&t_wd=<%=t_wd%>" name="EstiList" width="100%" height="<%=height%>" cellpadding="0" cellspacing="0" topmargin=0 marginwidth="0" border="0" frameborder="0"></iframe></td>
		  </tr>								
	  </table>
    </td>
  </tr>
    
</table>
</body>
</html>