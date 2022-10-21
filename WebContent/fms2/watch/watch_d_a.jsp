<%@ page contentType="text/html; charset=euc-kr" %>
<%@ page language="java" %> 
<%@ page import="java.util.*" %>
<%@ page import="acar.util.*" %>
<%@ page import="acar.watch.*" %>
<jsp:useBean id="wc_bean" class="acar.watch.WatchScheBean" scope="page"/>
<%@ include file="/acar/cookies.jsp" %>

<%
	String auth_rw 		= request.getParameter("auth_rw")==null?"":request.getParameter("auth_rw");
	String start_year 	= request.getParameter("start_year")==null?"":request.getParameter("start_year");
	String start_month 	= request.getParameter("start_month")==null?"":request.getParameter("start_month");
	
	String ch_cd[]		= request.getParameterValues("ch_cd");
	String start_day	= "";
	int vid_size 		= ch_cd.length;
	int count = 0;
	String cmd = request.getParameter("cmd")==null?"":request.getParameter("cmd");	
	String watch_type = "";
	
	WatchDatabase csd = WatchDatabase.getInstance();
	
	for(int i=0;i < vid_size;i++){
		start_day = ch_cd[i];
		
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
		}else if(cmd.equals("S2")){
			watch_type  = "5";
		}	
		
		wc_bean = csd.getWatchSche(start_year,start_month,start_day, watch_type);			
			
		if(!wc_bean.getStart_day().equals("")){		
			count = csd.deleteWatchSche(wc_bean, watch_type);					
		}
		
		if(!wc_bean.getMember_id().equals("") ){
			count = 1;
		}
	}
%>
<html>
<head>

<title>FMS</title>
<meta http-equiv="content-type" content="text/html; charset=euc-kr">
<link rel="stylesheet" type="text/css" href="/include/table.css"></link>

</head>
<body>
<script language="JavaScript">
<!--
	<%if(count==1){%>
	alert("정상적으로 취소되었습니다.");
	<%}else{%>
	alert("신청자가 있으면 취소되지 않습니다.");	
	<%}%>
	//parent.LoadSche();
	parent.location.reload();
//-->
</script>
</body>
</html>