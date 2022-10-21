<%@ page language="java" contentType="text/html; charset=euc-kr" %>
<%@ page import="java.util.*, acar.util.*, acar.estimate_mng.*" %>
<%@ include file="/acar/cookies.jsp" %>

<%
	EstiDatabase e_db = EstiDatabase.getInstance();
	
	Date today0 = new Date (); 
	System.out.println ( today0 );	
	System.out.println("홈페이지 주요차종 견적 업로드");	
	
	String  d_flag1 =  e_db.call_sp_esti_hp_upload();
	
	Date today1 = new Date (); 
	System.out.println ( today1 );
%>	
<html>
<head>

<title>FMS</title>
<meta http-equiv="content-type" content="text/html; charset=euc-kr">
<link rel="stylesheet" type="text/css" href="../../include/table_t.css">
<script language='JavaScript' src='/include/estimate.js'></script>
<script language="JavaScript">
<!--
	function go_parent(){
		var fm = document.form1;
		fm.action = "http://fms1.amazoncar.co.kr/acar/main_car/main_car_frame.jsp";
		fm.target = 'd_content';
		fm.submit();
	}
//-->
</script>
</head>
<body>
<form action="" name="form1" method="POST" >
</form>
<script>
<!--
		alert('홈페이지적용 완료');			
		//go_parent();
		//parent.location.href='';
//-->
</script>
</body>
</html>