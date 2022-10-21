<%@ page contentType="text/html; charset=euc-kr" %>
<%@ page language="java" %> 
<%@ page import="java.util.*" %>
<%@ page import="acar.util.*" %>
<%@ page import="acar.watch.*" %>
<jsp:useBean id="wc_bean" class="acar.watch.WatchScheBean" scope="page"/>
<%@ include file="/acar/cookies.jsp" %>

<%
	WatchDatabase wc_db = WatchDatabase.getInstance();
	
	String auth_rw 		= request.getParameter("auth_rw")==null?"":request.getParameter("auth_rw");
	String start_year 	= request.getParameter("start_year")==null?"":request.getParameter("start_year");
	String start_month 	= request.getParameter("start_month")==null?"":request.getParameter("start_month");
	String start_day 	= request.getParameter("start_day")==null?"":request.getParameter("start_day");
	String member_st 	= request.getParameter("member_st")==null?"":request.getParameter("member_st");
	String member_id 	= request.getParameter("member_id")==null?"":request.getParameter("member_id");
	int count = 0;
	String cmd = request.getParameter("cmd")==null?"":request.getParameter("cmd");	
	String watch_type = "";

	if(cmd.equals("S")){
		watch_type  = "1";
	}else if(cmd.equals("B")){
		watch_type  = "3";
	}else if(cmd.equals("D")){
		watch_type  = "4";
	}else if(cmd.equals("J")){
		watch_type  = "6";
	}else if(cmd.equals("G")){
		watch_type  = "7";
	}else if(cmd.equals("s2")){
		watch_type  = "5";		
	}else if(cmd.equals("i1")){
		watch_type  = "8";		
	}	

	wc_bean.setMember_id("");
	wc_bean.setMember_dt("");
	wc_bean.setWatch_time_st("");
	wc_bean.setWatch_ot("");
	wc_bean.setWatch_time_ed("");
	wc_bean.setWatch_gtext("");
	wc_bean.setWatch_ch_nm("");
		
	wc_bean.setStart_year(start_year);
	wc_bean.setStart_mon(start_month);
	wc_bean.setStart_day(start_day);
		
	count = wc_db.updateWatchSche(wc_bean, watch_type);


%>
<html>
<head>

<title>FMS</title>
<meta http-equiv="content-type" content="text/html; charset=euc-kr">
<link rel="stylesheet" type="text/css" href="/include/table.css"></link>
<%@ include file="/acar/getNaviCookies.jsp" %>
</head>
<body>
<script language="JavaScript">
<!--
	alert("정상적으로 취소되었습니다.");
	parent.location.reload();
//-->
</script>
</body>
</html>