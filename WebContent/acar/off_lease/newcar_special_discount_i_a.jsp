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
	String auth_rw = request.getParameter("auth_rw")==null?"":request.getParameter("auth_rw");	
	String car_mng_id = request.getParameter("car_mng_id")==null?"":request.getParameter("car_mng_id");	
	
	CarRegDatabase crd 	= CarRegDatabase.getInstance();
	EstiDatabase e_db = EstiDatabase.getInstance();
		
	cr_bean = crd.getCarRegBean(car_mng_id);
	
	//����
	cr_bean.setNcar_spe_dc_cau	(request.getParameter("ncar_spe_dc_cau")==null?"":request.getParameter("ncar_spe_dc_cau"));
	cr_bean.setNcar_spe_dc_amt	(request.getParameter("ncar_spe_dc_amt")==null?0:AddUtil.parseDigit(request.getParameter("ncar_spe_dc_amt")));
	cr_bean.setNcar_spe_dc_day	(request.getParameter("ncar_spe_dc_day")==null?0:AddUtil.parseDigit(request.getParameter("ncar_spe_dc_day")));
	
	int result = crd.updateNewCarSpeDc(cr_bean);
		
	//�����ݿ�
	//String  d_flag1 =  e_db.call_sp_esti_reg_sh(car_mng_id);
	

	%>
<form name='form1' method='post'>
<input type='hidden' name='auth_rw' value='<%=auth_rw%>'>
</form>
<script language='javascript'>
<%	if(result >= 1){%>		
		alert("�����Ǿ����ϴ�.");	
<%	}else{%>
		alert("�����ͺ��̽��� ������ �߻��Ͽ����ϴ�.\n �����ڴԲ� �����ϼ��� !");			
<%	}%>
parent.window.close();	
</script>
</body>
</html>