<%@ page language="java" contentType="text/html; charset=euc-kr" %>
<%@ page import="java.util.*, acar.util.*, acar.estimate_mng.*" %>

<%
	EstiDatabase e_db = EstiDatabase.getInstance();
	
	String est_tel = request.getParameter("est_tel")==null?"":request.getParameter("est_tel");
	
	String  d_flag1 =  e_db.call_sp_esti_reg_hp(est_tel);
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
		fm.action = "http://fms2.amazoncar.co.kr/acar/main_car/main_car_frame.jsp";
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
		alert('견적완료');	
		
		opener.location.reload();		
		
		//go_parent();
		//parent.location.href='';
//-->
</script>
</body>
</html>