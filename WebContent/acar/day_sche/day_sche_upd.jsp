<%@ page language="java" contentType="text/html;charset=euc-kr"%>
<%@ page import="acar.day_sche.*"%>
<jsp:useBean id="dsch_db" scope="page" class="acar.day_sche.DScheDatabase"/>
<html>
<head><title>FMS</title></head>
<body>
<%
	String s_year	= request.getParameter("s_year");
	String s_mon	= request.getParameter("s_mon");
	String s_day	= request.getParameter("s_day");
	String s_seq	= request.getParameter("s_seq");
		
	DayScheBean scd = dsch_db.getDailyScd(s_year, s_mon, s_day, s_seq);
	scd.setTitle(request.getParameter("title")==null?"":request.getParameter("title"));
	scd.setContent(request.getParameter("content")==null?"":request.getParameter("content"));
	String pr_dt	= request.getParameter("pr_dt_year")+request.getParameter("pr_dt_mon")+request.getParameter("pr_dt_day");
	scd.setPr_dt(pr_dt);
	scd.setPr_id(request.getParameter("pr_id")==null?"":request.getParameter("pr_id"));
%>
<script language='javascript'>
<%
	if(!dsch_db.updateDScd(scd))
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
