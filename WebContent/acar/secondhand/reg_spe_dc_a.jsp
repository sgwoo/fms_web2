<%@ page language="java" contentType="text/html; charset=euc-kr" %>
<%@ page import="java.util.*, acar.util.*, acar.car_register.*, acar.estimate_mng.*" %>
<jsp:useBean id="cr_bean" 	class="acar.car_register.CarRegBean" 		scope="page"/>
<%@ include file="/acar/cookies.jsp" %>

<%
	String user_id 		= request.getParameter("user_id")==null?"":request.getParameter("user_id");
	String car_mng_id 	= request.getParameter("car_mng_id")==null?"":request.getParameter("car_mng_id");
	
	
	CarRegDatabase crd 	= CarRegDatabase.getInstance();
	EstiDatabase e_db = EstiDatabase.getInstance();
	
	
	cr_bean = crd.getCarRegBean(car_mng_id);
	

	//수정
	cr_bean.setSpe_dc_st		(request.getParameter("spe_dc_st")	==null?"":request.getParameter("spe_dc_st"));				
	cr_bean.setSpe_dc_cau		(request.getParameter("spe_dc_cau")	==null?"":request.getParameter("spe_dc_cau"));			
	cr_bean.setSpe_dc_per		(request.getParameter("spe_dc_per")	==null?0:AddUtil.parseFloat(request.getParameter("spe_dc_per")));
	cr_bean.setSpe_dc_s_dt		(request.getParameter("spe_dc_s_dt")==null?"":request.getParameter("spe_dc_s_dt"));
	cr_bean.setSpe_dc_d_dt		(request.getParameter("spe_dc_d_dt")	==null?"":request.getParameter("spe_dc_d_dt"));
	
	int result = crd.updateCarSpeDc(cr_bean);
	
	
	//견적반영
	String  d_flag1 =  e_db.call_sp_esti_reg_sh(car_mng_id);
	
	

%>

<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN">
<html>
<head>
<title>FMS</title>
<meta http-equiv="Content-Type" content="text/html; charset=euc-kr">
</head>

<body>
<script language="JavaScript">
<!--

<%	if(result >= 1){%>		
		alert("수정되었습니다.");
		parent.opener.location.reload();
		parent.window.close();	
<%	}else{%>
		alert("데이터베이스에 문제가 발생하였습니다.\n 관리자님께 문의하세요 !");
		window.close();				
<%	}%>
//-->
</script>
</body>
</html>
