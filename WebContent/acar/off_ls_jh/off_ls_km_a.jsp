<%@ page language="java" contentType="text/html;charset=euc-kr"%>
<%@ page import="java.util.*, acar.offls_pre.*, acar.parking.*"%>
<%@ page import="acar.util.*"%>
<jsp:useBean id="olyD" class="acar.offls_pre.Offls_preDatabase" scope="page"/>
<%@ include file="/acar/cookies.jsp"%>
<%
		
	String auth_rw 		= request.getParameter("auth_rw")==null?"":request.getParameter("auth_rw");
	String car_mng_id 	= request.getParameter("car_mng_id")==null?"":request.getParameter("car_mng_id");
	String km 	= request.getParameter("km")==null?"":request.getParameter("km");
	String car_out_dt 	= request.getParameter("car_out_dt")==null?"":request.getParameter("car_out_dt");
	String car_arr_id 	= request.getParameter("car_arr_id")==null?"":request.getParameter("car_arr_id");
	String park_id 	= request.getParameter("park_id")==null?"":request.getParameter("park_id");
	String user_id 	= request.getParameter("user_id")==null?"":request.getParameter("user_id");
	String car_gita 	= request.getParameter("car_gita")==null?"":request.getParameter("car_gita");

	int result = 0;
	int count = 0;
	result = olyD.upApprslKM(car_mng_id, km, car_out_dt);
	ParkIODatabase piod = ParkIODatabase.getInstance();	
	System.out.println("[매각결정차량삭제 처음]");
	System.out.println("삭제한 매각출고차량관리번호: "+car_mng_id);		
	System.out.println("삭제한 매각출고차량 주행거리: "+km);
	System.out.println("매각출고차량 삭제한 사람: "+user_id);
	System.out.println("[매각결정차량삭제 끝]");
	
	count = piod.parking_del2(car_mng_id);
	count = piod.DeleteParkConditon(car_mng_id, park_id);  // 실제park 삭제
	
	Hashtable ht = piod.getParkIOInfo(car_mng_id);
	if(String.valueOf(ht.get("IO_GUBUN")).equals("1")){
		ParkIOBean io_bean 	= new ParkIOBean();
		io_bean.setCar_mng_id(String.valueOf(ht.get("CAR_MNG_ID")));
		io_bean.setPark_seq(Integer.valueOf(String.valueOf(ht.get("PARK_SEQ"))));
		io_bean.setPark_id(String.valueOf(ht.get("PARK_ID")));
		io_bean.setReg_id(ck_acar_id);
		io_bean.setIo_gubun("2");
		io_bean.setCar_st(String.valueOf(ht.get("CAR_ST")));
		io_bean.setCar_no(String.valueOf(ht.get("CAR_NO")));
		io_bean.setCar_nm(String.valueOf(ht.get("CAR_NM")));
		io_bean.setCar_km(Integer.valueOf(String.valueOf(ht.get("CAR_KM"))));
		io_bean.setUsers_comp(String.valueOf(ht.get("USERS_COMP")));
		io_bean.setStart_place(String.valueOf(ht.get("START_PLACE")));
		io_bean.setEnd_place(car_arr_id);
		io_bean.setDriver_nm(String.valueOf(ht.get("DRIVER_NM")));
		io_bean.setPark_mng(session_user_nm);
		io_bean.setBr_id(String.valueOf(ht.get("BR_ID")));
		io_bean.setUse_yn(String.valueOf(ht.get("USE_YN")));
		io_bean.setRent_l_cd(String.valueOf(ht.get("RENT_L_CD")));
		io_bean.setCar_gita(car_gita);
		
		count = piod.insertParkIOInfo(io_bean);
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
	//alert("정상적으로 신청되었습니다.");
<%if(result != 0 && count != 0){%>
	alert("정상적으로 처리 되었습니다.");
	parent.opener.location.reload();
	parent.window.close();
<%}else{%>	
	alert("오류 입니다. 다시 확인하시기 바랍니다.");
<%}%>
//-->
</script>
</body>
</html>