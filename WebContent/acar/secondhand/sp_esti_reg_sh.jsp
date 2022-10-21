<%@ page language="java" contentType="text/html; charset=euc-kr" %>
<%@ page import="java.util.*, acar.util.*, acar.estimate_mng.*" %>

<%
	String auth_rw 		= request.getParameter("auth_rw")==null?"":request.getParameter("auth_rw");
	String br_id 		= request.getParameter("br_id")==null?"":request.getParameter("br_id");
	String user_id 		= request.getParameter("user_id")==null?"":request.getParameter("user_id");
	
	String est_st 		= request.getParameter("est_st")==null?"":request.getParameter("est_st");
	String fee_opt_amt 	= request.getParameter("fee_opt_amt")==null?"":request.getParameter("fee_opt_amt");
	String fee_rent_st 	= request.getParameter("fee_rent_st")==null?"":request.getParameter("fee_rent_st");
	
	String car_mng_id 	= request.getParameter("car_mng_id")==null?"":request.getParameter("car_mng_id");
	String rent_mng_id 	= request.getParameter("rent_mng_id")==null?"":request.getParameter("rent_mng_id");
	String rent_l_cd 	= request.getParameter("rent_l_cd")==null?"":request.getParameter("rent_l_cd");
	
	EstiDatabase e_db = EstiDatabase.getInstance();
	
	//재리스 계산
	String  d_flag1 =  "";
	
	if(!car_mng_id.equals("")){
		d_flag1 = e_db.call_sp_esti_reg_sh(car_mng_id);
	}
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
		fm.action = "secondhand_detail_frame.jsp";
		fm.target = 'd_content';
		fm.submit();
	}
//-->
</script>
</head>
<body>
<form action="" name="form1" method="POST" >
<input type="hidden" name="auth_rw" 		value="<%=auth_rw%>">
<input type="hidden" name="br_id" 		value="<%=br_id%>">
<input type="hidden" name="user_id" 		value="<%=user_id%>">
<input type='hidden' name="est_st"		value="<%=est_st%>">      
<input type='hidden' name="fee_opt_amt"		value="<%=fee_opt_amt%>">        
<input type='hidden' name="fee_rent_st"		value="<%=fee_rent_st%>">        
<input type="hidden" name="car_mng_id" 		value="<%=car_mng_id%>">
<input type="hidden" name="rent_mng_id" 	value="<%=rent_mng_id%>">
<input type="hidden" name="rent_l_cd" 		value="<%=rent_l_cd%>">
</form>
<script>
<!--
		//alert('견적완료');			
		go_parent();
		//parent.location.href='';
//-->
</script>
</body>
</html>