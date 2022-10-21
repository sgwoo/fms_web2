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
	scd.setTitle(request.getParameter("title")==null?"":request.getParameter("title"));
	scd.setContent(request.getParameter("content")==null?"":request.getParameter("content"));
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
%>		alert('수정되었습니다');
		parent.opener.parent.c_head.search();
		parent.close();
<%
	}
%>
</script>
</body>
</html>
