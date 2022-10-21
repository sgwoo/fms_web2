<%@ page language="java" contentType="text/html;charset=euc-kr"%>
<%@ page import="java.util.*, acar.util.*, acar.cls.*"%>
<jsp:useBean id="as_db" scope="page" class="acar.cls.AddClsDatabase"/>
<%@ include file="/acar/cookies.jsp" %>

<html>
<head>
<title>FMS</title>
</head>
<link rel=stylesheet type="text/css" href="/include/table.css">
<body leftmargin="15">
<script language='JavaScript' src='/include/common.js'></script>
<script language='javascript'>
<%
	String rent_start_dt =  request.getParameter("rent_start_dt")==null?"":request.getParameter("rent_start_dt");
	String cls_dt =  request.getParameter("cls_dt")==null?"":request.getParameter("cls_dt");
	String mon_day = as_db.getMonDay(rent_start_dt, cls_dt);
	String mon = mon_day.substring(0,mon_day.indexOf('/'));//-1
	String day = mon_day.substring(mon_day.indexOf('/')+1);
	if(mon.equals("")) mon="0";
	if(day.equals("")) day="0";
%>
	t_fm = parent.form1;
	t_fm.r_mon.value	= '<%=mon%>';
	t_fm.r_day.value 	= '<%=day%>';
	
	if(t_fm.r_day.value != '0'){
		t_fm.rcon_mon.value 		= toInt(t_fm.con_mon.value) - toInt(t_fm.r_mon.value) - 1;
		t_fm.rcon_day.value 		= 30-toInt(t_fm.r_day.value);
	}else{
		t_fm.rcon_mon.value 		= toInt(t_fm.con_mon.value) - toInt(t_fm.r_mon.value);
	}		
</script>
</body>
</html>
