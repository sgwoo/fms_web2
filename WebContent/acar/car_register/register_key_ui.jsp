<%@ page language="java" contentType="text/html; charset=euc-kr" %>
<%@ page import="java.util.*, acar.util.*, acar.car_register.*" %>
<jsp:useBean id="CarMngDb" scope="page" class="acar.car_register.CarMngDatabase"/>
<jsp:useBean id="CarKeyBn" scope="page" class="acar.car_register.CarKeyBean"/>
<%@ include file="/acar/cookies.jsp" %>

<%
	String auth_rw = request.getParameter("auth_rw")==null?"":request.getParameter("auth_rw"); //권한
	String user_id = request.getParameter("user_id")==null?"":request.getParameter("user_id");
	String br_id = request.getParameter("br_id")==null?"":request.getParameter("br_id");

	String brch_id = request.getParameter("brch_id")==null?"":request.getParameter("brch_id");
	
	String rent_mng_id = request.getParameter("rent_mng_id")==null?"":request.getParameter("rent_mng_id");
	String rent_l_cd = request.getParameter("rent_l_cd")==null?"":request.getParameter("rent_l_cd");
	String car_mng_id = request.getParameter("car_mng_id")==null?"":request.getParameter("car_mng_id");
	String cmd = request.getParameter("cmd")==null?"":request.getParameter("cmd");
	boolean flag = true;
	
	CarKeyBn = CarMngDb.getCarKey(car_mng_id);
	
	CarKeyBn.setKey_yn		(request.getParameter("key_yn")==null?"":request.getParameter("key_yn"));
	CarKeyBn.setKey_kd1		(request.getParameter("key_kd1")==null?0:AddUtil.parseInt(request.getParameter("key_kd1")));
	CarKeyBn.setKey_kd2		(request.getParameter("key_kd2")==null?0:AddUtil.parseInt(request.getParameter("key_kd2")));
	CarKeyBn.setKey_kd3		(request.getParameter("key_kd3")==null?0:AddUtil.parseInt(request.getParameter("key_kd3")));
	CarKeyBn.setKey_kd4		(request.getParameter("key_kd4")==null?0:AddUtil.parseInt(request.getParameter("key_kd4")));
	CarKeyBn.setKey_kd5		(request.getParameter("key_kd5")==null?0:AddUtil.parseInt(request.getParameter("key_kd5")));
	CarKeyBn.setKey_kd5_nm	(request.getParameter("key_kd5_nm")==null?"":request.getParameter("key_kd5_nm"));
	CarKeyBn.setReg_id		(user_id);
	CarKeyBn.setUpd_id		(user_id);
	
	if(CarKeyBn.getCar_mng_id().equals("")){
		CarKeyBn.setCar_mng_id	(car_mng_id);
		flag = CarMngDb.insertCarKey(CarKeyBn);
	}else{
		flag = CarMngDb.updateCarKey(CarKeyBn);
	}
%>
<html>
<head>

<title>FMS</title>
<link rel="stylesheet" type="text/css" href="/include/table_t.css"></link>
<script language="JavaScript">
<!--
	<%	if(flag){%>
		alert('정상적으로 처리되었습니다.');
		parent.c_foot.location.reload();		
	<%	}else{%>
		alert('오류발생!!');	
	<%	}%>	
//-->
</script>
</head>
<body >
</body>
</html>