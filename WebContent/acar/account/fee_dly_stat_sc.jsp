<%@ page language="java" contentType="text/html;charset=euc-kr" %>
<%@ page import="java.util.*,  acar.util.*"%>
<%@ include file="/acar/cookies.jsp" %>

<%
	String auth_rw 	= request.getParameter("auth_rw")==null?"":request.getParameter("auth_rw");
	String br_id 	= request.getParameter("br_id")==null?"":request.getParameter("br_id");
	String user_id 	= request.getParameter("user_id")==null?"":request.getParameter("user_id");
	
	String s_yy 	= request.getParameter("s_yy")==null?"":request.getParameter("s_yy");
	String s_mm 	= request.getParameter("s_mm")==null?"":request.getParameter("s_mm");
	
	int sh_height = request.getParameter("sh_height")==null?0:Util.parseInt(request.getParameter("sh_height"));//상단길이
	
	int cnt = 2; //sc 출력라인수
	int height = AddUtil.parseInt(s_height)-emp_top_height-sh_height-(cnt*sc_line_height)-80;//현황 라인수만큼 제한 아이프레임 사이즈
	
	String valus = 	"?auth_rw="+auth_rw+"&user_id="+user_id+"&br_id="+br_id+
					"&s_yy="+s_yy+"&s_mm="+s_mm+
				   	"&sh_height="+height+"";	
				   		
%>
<html>
<head><title>FMS</title>
<script language='JavaScript' src='/include/common.js'></script>
<script language='javascript'>
<!--

//-->
</script>
<meta http-equiv="content-type" content="text/html; charset=euc-kr">
<link rel=stylesheet type="text/css" href="../../include/table_t.css">
<%@ include file="/acar/getNaviCookies.jsp" %>
</head>
<body leftmargin="15">
<form name='form1' method='post'>
  <input type='hidden' name='auth_rw' 	value='<%=auth_rw%>'>
  <input type='hidden' name='user_id' 	value='<%=user_id%>'>
  <input type='hidden' name='br_id' 	value='<%=br_id%>'>
  <input type='hidden' name='s_yy'  	value='<%=s_yy%>'>
  <input type='hidden' name='s_mm' 	value='<%=s_mm%>'>			
   
  <table border="0" cellspacing="0" cellpadding="0" width=100%>
    <tr>
	<td>
	  <table border="0" cellspacing="0" cellpadding="0" width=100%>
	    <tr>
		<td>
		  <iframe src="fee_dly_stat_sc_in.jsp<%=valus%>" name="inner" width="100%" height="<%=25*14%>" cellpadding="0" cellspacing="0" border="0" frameborder="0" noresize scrolling=yes, marginwidth=0, marginheight=0 ></iframe>
		</td>
	    </tr>
	  </table>
	</td>
    </tr>
    <tr>
	<td>※ 2011-03-30 부터 마감된 현황입니다. 2012-03-22 부터 1개월미만 연체료 분리하여 마감하였음.</td>
    </tr>
    <!--
    <tr>
	<td>
	  <table border="0" cellspacing="0" cellpadding="0" width=100%>
	    <tr>
		<td>
		  <iframe src="fee_dly_stat_sc_graphic.jsp<%=valus%>" name="inner2" width="100%" height="600" cellpadding="0" cellspacing="0" border="0" frameborder="0" noresize scrolling=yes, marginwidth=0, marginheight=0 ></iframe>
		</td>
	    </tr>
	  </table>
	</td>
    </tr>    	
    -->
  </table>
</form>
</body>
</html>
