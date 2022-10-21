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
	String watch_type = request.getParameter("watch_type")==null?"":request.getParameter("watch_type");	
	String no 	= request.getParameter("no")==null?"":request.getParameter("no");
	
	String cmd = request.getParameter("cmd")==null?"":request.getParameter("cmd");	
	int watch_amt = request.getParameter("watch_amt")==null?0:Util.parseInt(request.getParameter("watch_amt"));
	String time_st 		= request.getParameter("time_st")==null?"":request.getParameter("time_st");
	int count = 0;
	
	wc_bean.setStart_year(start_year);
	wc_bean.setStart_mon(start_month);
	wc_bean.setStart_day(start_day);
	
if(watch_type.equals("3")||watch_type.equals("7")){
	watch_type = "3";
}else if(watch_type.equals("4")||watch_type.equals("6")){
	watch_type = "4";
}else if(watch_type.equals("5")||watch_type.equals("8")||watch_type.equals("9")){
	watch_type = "5";
}
	if(no.equals("3")){	
		wc_bean.setMember_id(member_id);
		wc_bean.setWatch_amt(watch_amt);
	}else if(no.equals("4")){	
		wc_bean.setMember_id(member_id);
		wc_bean.setWatch_amt(watch_amt);
	}else if(no.equals("5")){	
		wc_bean.setMember_id(member_id);
	}else if(no.equals("6")){	
		wc_bean.setMember_id(member_id);		
	}else if(no.equals("8")){	
		wc_bean.setMember_id(member_id);		
	}else if(watch_type.equals("1")&&no.equals("7")){	//종로
		wc_bean.setMember_id(member_id);
	}else if(watch_type.equals("1")&&no.equals("8")){	//송파
		wc_bean.setMember_id(member_id);
	}
	
	//System.out.println(watch_type);
	
	count = wc_db.updateSaleWatchSche(wc_bean, watch_type, no);
	
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
	//alert("정상적으로 신청되었습니다.");

	parent.opener.location.reload();
	parent.window.close();
	
//-->
</script>
</body>
</html>