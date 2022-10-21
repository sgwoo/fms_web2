<%@ page contentType="text/html; charset=euc-kr" %>
<%@ page language="java" %> 
<%@ page import="java.util.*" %>
<%@ page import="acar.util.*" %>
<%@ page import="acar.schedule.*, acar.res_search.*" %>
<jsp:useBean id="cs_bean" class="acar.car_sche.CarScheBean" scope="page"/>
<jsp:useBean id="rs_db" scope="page" class="acar.res_search.ResSearchDatabase"/>

<%@ include file="/acar/cookies.jsp" %>

<%
	String auth_rw 	= request.getParameter("auth_rw")==null?"":request.getParameter("auth_rw");

	String sch_id 	= request.getParameter("sch_id")==null?"":request.getParameter("sch_id");
	String start_year 	= request.getParameter("start_year")==null?"":request.getParameter("start_year");
	String start_mon 	= request.getParameter("start_mon")==null?"":request.getParameter("start_mon");
	String start_day 	= request.getParameter("start_day")==null?"":request.getParameter("start_day");
	
	int seq 	= request.getParameter("seq")==null?0:AddUtil.parseInt(request.getParameter("seq"));
	
	int count = 0;
			
	ScheduleDatabase csd = ScheduleDatabase.getInstance();
		
	count = csd.deleteCarSche(sch_id, start_year, start_mon, start_day, seq);
	
%>
<html>
<head>
<title>FMS</title>
<link rel="stylesheet" type="text/css" href="/include/table_t.css"></link>
<script language="JavaScript">
<!--
function NullAction()
{
<%if(count==1){%>
	alert("정상적으로 삭제되었습니다.");
//	parent.LoadSche();
<%}else{%>
	alert("오류!!");
<%}%>
}
//-->
</script>
</head>
<body onLoad="javascript:NullAction()">
</body>
</html>