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
	String title	= request.getParameter("title");
	String content	= request.getParameter("content");
	String user_id	= request.getParameter("user_id");
	
	DailyScdBean scd = new DailyScdBean();
	scd.setYear(request.getParameter("s_year")==null?"":request.getParameter("s_year"));
	scd.setMon(request.getParameter("s_mon")==null?"":request.getParameter("s_mon"));
	scd.setDay(request.getParameter("s_day")==null?"":request.getParameter("s_day"));
	scd.setUser_id(request.getParameter("user_id")==null?"":request.getParameter("user_id"));
	scd.setTitle(request.getParameter("title")==null?"":request.getParameter("title"));
	scd.setContent(request.getParameter("content")==null?"":request.getParameter("content"));
	scd.setStatus("0");	// 0 : ��ó��, 1:ó��
%>
<script language='javascript'>
<%
	if(!ds_db.insertDScd(scd))
	{
%>		alert('�����߻�!');
		location='about:blank';
<%
	}
	else
	{
%>		alert('��ϵǾ����ϴ�');
		parent.opener.parent.c_head.search();
		parent.close();
<%
	}
%>
</script>
</body>
</html>
