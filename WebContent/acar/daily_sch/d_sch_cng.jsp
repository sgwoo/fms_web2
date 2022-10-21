<%@ page language="java" contentType="text/html;charset=euc-kr"%>
<%@ page import="acar.daily_sch.*"%>
<jsp:useBean id="ds_db" scope="page" class="acar.daily_sch.DScdDatabase"/>
<html>
<head><title>FMS</title></head>
<body>
<%
	String s_year	= request.getParameter("s_year");
	String s_mon	= request.getParameter("s_mon");
	String s_day	= request.getParameter("s_day");
	String s_seq	= request.getParameter("s_seq");
	
	DailyScdBean scd = ds_db.getDailyScd(s_year, s_mon, s_day, s_seq);
	scd.setStatus("1");
%>
<script language='javascript'>
<%
	if(!ds_db.updateDScd(scd))
	{
%>		alert('오류발생!');
		location='about:blank';
<%
	}
	else
	{
%>		alert('변경되었습니다');
		parent.parent.c_head.search();
		parent.close();
<%
	}
%>
</script>
</body>
</html>
