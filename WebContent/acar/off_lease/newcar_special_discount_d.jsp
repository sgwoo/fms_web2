<%@ page language="java" contentType="text/html; charset=euc-kr" %>
<%@ page import="java.util.*, acar.util.*, acar.car_register.*, acar.estimate_mng.*" %>
<jsp:useBean id="cr_bean" 	class="acar.car_register.CarRegBean" 		scope="page"/>
<%@ include file="/acar/cookies.jsp" %>

<html>
<head>
<title>FMS</title>
</head>
<body leftmargin="15">
<%	
	CarRegDatabase crd 	= CarRegDatabase.getInstance();

	String auth_rw = request.getParameter("auth_rw")==null?"":request.getParameter("auth_rw");
	String car_mng_id = "";
	int result = 0;
	
	String vid[] 	= request.getParameterValues("pr");
	int vid_size = vid.length;
	
	for(int i = 0 ; i < vid_size ; i++){
		
		car_mng_id = vid[i];
		
		cr_bean = crd.getCarRegBean(car_mng_id);
		
		//수정
		cr_bean.setNcar_spe_dc_cau	("");
		cr_bean.setNcar_spe_dc_amt	(0);
		cr_bean.setNcar_spe_dc_day	(0);
		
		result = crd.updateNewCarSpeDc(cr_bean);		
		
	}

	//견적반영
	//String  d_flag1 =  e_db.call_sp_esti_reg_sh(car_mng_id);
	

	%>
<form name='form1' method='post'>
<input type='hidden' name='auth_rw' value='<%=auth_rw%>'>
</form>
<script language='javascript'>
<%	if(result >= 1){%>		
		alert("수정되었습니다.");	
<%	}else{%>
		alert("데이터베이스에 문제가 발생하였습니다.\n 관리자님께 문의하세요 !");			
<%	}%>
parent.window.close();	
</script>
</body>
</html>