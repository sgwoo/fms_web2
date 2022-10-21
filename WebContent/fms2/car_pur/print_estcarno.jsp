<%@ page language="java" contentType="text/html;charset=euc-kr" %>
<%@ page import="java.util.*"%>
<%@ page import="acar.common.*"%>
<%@ page import="acar.util.*, acar.user_mng.*"%>
<%@ include file="/acar/cookies.jsp" %>

<%
	String auth_rw 	= request.getParameter("auth_rw")==null?"":request.getParameter("auth_rw");
	String user_id 	= request.getParameter("user_id")==null?"":request.getParameter("user_id");
	String br_id 	= request.getParameter("br_id")==null?"":request.getParameter("br_id");
	
	String[] check_print_car = request.getParameterValues("check_print_car");
	int check_print_car_size = check_print_car==null? 0 : check_print_car.length;	
	
%>

<html>
<meta http-equiv="content-type" content="text/html; charset=euc-kr">
<meta http-equiv="X-UA-Compatible" content="IE=edge,chrome=1">
<head><title>FMS</title>
<script src="https://ajax.googleapis.com/ajax/libs/jquery/2.1.4/jquery.min.js"></script>
<script language="JavaScript" src="/include/common.js"></script>
<script language="JavaScript" src="/include/table_fix.js?ver=0.2"></script>

<script language='javascript'>

function IE_Print() {
	factory.printing.header = ""; //폐이지상단 인쇄
	factory.printing.footer = ""; //폐이지하단 인쇄
	factory.printing.portrait = false; //true-세로인쇄, false-가로인쇄    
	factory.printing.leftMargin = 15.0; //좌측여백   
	factory.printing.rightMargin = 0.0; //우측여백
	factory.printing.topMargin = 0.0; //상단여백    
	factory.printing.bottomMargin = 0.0; //하단여백
	factory.printing.Print(true, window);//arg1-대화상자표시여부(true or false), arg2-전체윈도우or특정프레임
}

function onprint() {
	var userAgent = navigator.userAgent.toLowerCase();
	
	if (userAgent.indexOf("edge") > -1) {
		window.print();
	} else if (userAgent.indexOf("whale") > -1) {
		window.print();
	} else if (userAgent.indexOf("chrome") > -1) {
		window.print();
	} else if (userAgent.indexOf("firefox") > -1) {
		window.print();
	} else if (userAgent.indexOf("safari") > -1) {
		window.print();
	} else {
		IE_Print();
	}
}
</script>
<style>
body{
	margin: 0;
	padding: 0;
}

@media print{ 
 	@page { size: landscape; } 
}
</style>
</head>
<body onload="javascript: onprint();">
<object id=factory style="display:none" classid="clsid:1663ed61-23eb-11d2-b92f-008048fdd814" codebase="/smsx.cab#Version=6,3,439,30">
</object>
<%
for(int i=0; i<check_print_car_size; i++){
	String print_car = check_print_car[i];
	String car_no = print_car.split("/")[0];
	String car_num = print_car.split("/")[1];
	String car_nm = print_car.split("/")[2];
%>
<div class="page" style="width: 100%; height: 100%; text-aling: center; font-size: 93px; font-weight: bold; line-height: 2; display: flex; justify-content: center; align-items: center;">
	<%=car_num%><br>
	<%=car_nm%><br>
	<%=car_no%> 
</div>
<%
}
%>
</body>
</html>

