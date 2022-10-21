<%@ page language="java" contentType="text/html;charset=euc-kr" %>
<%@ page import="java.util.*, acar.util.*, acar.user_mng.*"%>

<%@ include file="/acar/cookies.jsp" %>

<%

    String s_user =  request.getParameter("s_month")==null?"":request.getParameter("user_id");	
   
	String auth_rw = request.getParameter("auth_rw")==null?"":request.getParameter("auth_rw");	
	String br_id = request.getParameter("br_id")==null?"":request.getParameter("br_id");
	String dept_id = request.getParameter("dept_id")==null?"":request.getParameter("dept_id");
	String user_nm = request.getParameter("user_nm")==null?"":request.getParameter("user_nm");	

    String dt		= request.getParameter("dt")==null?"2":request.getParameter("dt");
	String ref_dt1 	= request.getParameter("ref_dt1")==null?"":request.getParameter("ref_dt1");
	String ref_dt2 	= request.getParameter("ref_dt2")==null?"":request.getParameter("ref_dt2");
   	String st_mon		= request.getParameter("st_mon")==null?"":request.getParameter("st_mon");
	String st_year		= request.getParameter("st_year")==null?"":request.getParameter("st_year");

	int year =AddUtil.getDate2(1);
	int cnt = 3; //현황 출력 총수
	int sh_height = cnt*sh_line_height;
	int height = AddUtil.parseInt(s_height)-emp_top_height-sh_height-(cnt*sc_line_height)-100;//현황 라인수만큼 제한 아이프레임 사이즈
	
%>

<html>
<head>
<title>FMS</title>
<meta http-equiv="content-type" content="text/html; charset=euc-kr">
<link rel="stylesheet" type="text/css" href="/include/table_t.css">
<script language="JavaScript" src="/include/common.js"></script>
<script language="JavaScript">
<!--
	
//-->
</script>
</head>
<body>
<form action="" name="form1" method="POST">
<input type="hidden" name="auth_rw" value="<%= auth_rw %>"> 

<table width="100%" border="0" cellspacing="0" cellpadding="0">
	<tr>
    	<td align='center' width='100%'><font size='5'> </font></td>
    </tr>
    <tr>
        <td><iframe src="mon_list_in.jsp?auth_rw=<%=auth_rw%>&dt=<%=dt%>&st_year=<%=st_year%>&st_mon=<%=st_mon%>&ref_dt1=<%=ref_dt1%>&ref_dt2=<%=ref_dt2%>&dept_id=<%=dept_id%>&br_id=<%=br_id%>&user_nm=<%=user_nm%>" width="100%" height="<%=height%>" cellpadding="0" cellspacing="0" border="0" frameborder="0" noresize scrolling=yes, marginwidth=0, marginheight=0 > 
                    </iframe></td>
     </tr>
    <tr>
        <td class=h></td>
    </tr>
    
</table>
 
 
</form>
</body>
</html>
