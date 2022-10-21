<%@ page language="java" contentType="text/html;charset=euc-kr" %>
<%@ page import="acar.util.*"%>
<%@ include file="/acar/cookies.jsp" %>

<%
	String auth_rw 	= request.getParameter("auth_rw")==null?"":request.getParameter("auth_rw");
	String user_id 	= request.getParameter("user_id")==null?"":request.getParameter("user_id");
	String br_id 	= request.getParameter("br_id")==null?"":request.getParameter("br_id");
	
	String s_year 	= request.getParameter("s_year")==null?"":request.getParameter("s_year");
	String s_mon 	= request.getParameter("s_mon")==null?"":request.getParameter("s_mon");
	String s_kd 	= request.getParameter("s_kd")==null?"":request.getParameter("s_kd");
	String t_wd 	= request.getParameter("t_wd")==null?"":request.getParameter("t_wd");
	String gubun1 	= request.getParameter("gubun1")==null?"":request.getParameter("gubun1");
	String gubun2 	= request.getParameter("gubun2")==null?"":request.getParameter("gubun2");
	String gubun3 	= request.getParameter("gubun3")==null?"":request.getParameter("gubun3");
	String gubun4 	= request.getParameter("gubun4")==null?"":request.getParameter("gubun4");
	
	int sh_height = request.getParameter("sh_height")==null?0:Util.parseInt(request.getParameter("sh_height"));//상단길이
	
	int cnt = 3; //sc 출력라인수
	int height = AddUtil.parseInt(s_height)-emp_top_height-sh_height-(cnt*sc_line_height)-100;//현황 라인수만큼 제한 아이프레임 사이즈
	
	String valus = 	"?auth_rw="+auth_rw+"&user_id="+user_id+"&br_id="+br_id+
					"&s_year="+s_year+"&s_mon="+s_mon+"&s_kd="+s_kd+"&t_wd="+t_wd+"&gubun1="+gubun1+"&gubun2="+gubun2+"&gubun3="+gubun3+"&gubun4="+gubun4+
				   	"&sh_height="+height+"";
%>


<html>
<head>
<meta http-equiv="content-type" content="text/html; charset=euc-kr">
<title>FMS</title>
<link rel='stylesheet' type='text/css' href='/include/table_t.css'>
<%@ include file="/acar/getNaviCookies.jsp" %>
<script language="JavaScript">
<!--
	function reg_sch()
	{
		window.open("/fms2/cooperation/cooperation_i.jsp<%=valus%>", "COOPERATION", "left=50, top=50, width=700, height=650, scrollbars=yes");
	}
	
	function view_content(seq, in_dt, in_id)
	{
		window.open("/fms2/cooperation/cooperation_u.jsp<%=valus%>&seq="+seq+"&in_dt="+in_dt+"&in_id="+in_id, "COOPERATION", "left=100, top=100, width=700, height=650, scrollbars=yes");
	}	
//-->
</script>
</head>
<body>
<form name='form1' method='post'>
  <input type='hidden' name='auth_rw' 	value='<%=auth_rw%>'>
  <input type='hidden' name='user_id' 	value='<%=user_id%>'>
  <input type='hidden' name='br_id' 	value='<%=br_id%>'>
  <input type='hidden' name='s_year' 	value='<%=s_year%>'>
  <input type='hidden' name='s_mon' 	value='<%=s_mon%>'>  
  <input type='hidden' name='s_kd' 		value='<%=s_kd%>'>
  <input type='hidden' name='t_wd' 		value='<%=t_wd%>'>  
  <input type='hidden' name='gubun1'	value='<%=gubun1%>'>    
  <input type='hidden' name='gubun2'	value='<%=gubun2%>'>    
  <input type='hidden' name='gubun3'	value='<%=gubun3%>'>    
  <input type='hidden' name='gubun4'	value='<%=gubun4%>'>          
  <input type='hidden' name='sh_height' value='<%=sh_height%>'>    

  <table border=0 cellspacing=0 cellpadding=0 width=100%>
    <tr>
	  <td><span class=style2><img src=/acar/images/center/icon_arrow.gif align=absmiddle> 총<input type='text' name='size' value='' size='4' class=whitenum> 건</span>
	  </td>
	  <td align='right'>
		<a href='javascript:reg_sch()' onMouseOver="window.status=''; return true"><img src="/acar/images/center/button_reg.gif" align="absmiddle" border="0"></a>&nbsp;&nbsp;&nbsp;&nbsp;
	  </td>	
	</tr>
	<tr>
	  <td colspan="2">
		<table border="0" cellspacing="0" cellpadding="0" width=100%>
		  <tr>
			<td>
			  <iframe src="cooperation_sc_in.jsp<%=valus%>" name="inner" width="100%" height="<%=height%>" cellpadding="0" cellspacing="0" border="0" frameborder="0" noresize scrolling=yes, marginwidth=0, marginheight=0 ></iframe>
			</td>
		  </tr>
		</table>
	  </td>
	</tr>	
</table>
</form>
</body>
</html>