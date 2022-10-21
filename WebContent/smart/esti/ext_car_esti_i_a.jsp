<%@ page language="java" contentType="text/html; charset=euc-kr" %>
<%@ page import="java.util.*, acar.util.*, acar.estimate_mng.*, acar.cont.*, acar.car_mst.*, acar.user_mng.*" %>
<jsp:useBean id="bean" class="acar.estimate_mng.EstimateBean" scope="page"/>
<jsp:useBean id="a_db" class="acar.cont.AddContDatabase" scope="page"/>
<jsp:useBean id="cm_bean" class="acar.car_mst.CarMstBean" scope="page"/>
<%@ include file="/smart/cookies.jsp" %>

<%
	EstiDatabase e_db = EstiDatabase.getInstance();
	AddCarMstDatabase a_cmb = AddCarMstDatabase.getInstance();
	UserMngDatabase umd = UserMngDatabase.getInstance();
	
	UsersBean user_bean = umd.getUsersBean(user_id);
	
	String client_id 	= request.getParameter("client_id")==null?"":request.getParameter("client_id");
	String firm_nm 		= request.getParameter("firm_nm")==null?"":request.getParameter("firm_nm");
	String rent_mng_id 	= request.getParameter("rent_mng_id")==null?"":request.getParameter("rent_mng_id");
	String rent_l_cd 	= request.getParameter("rent_l_cd")==null?"":request.getParameter("rent_l_cd");
	String car_mng_id 	= request.getParameter("car_mng_id")==null?"":request.getParameter("car_mng_id");
	String car_no 		= request.getParameter("car_no")==null?"":request.getParameter("car_no");
	String car_nm 		= request.getParameter("car_nm")==null?"":request.getParameter("car_nm");
	String from_page 	= request.getParameter("from_page")	==null?"":request.getParameter("from_page");
	
	int fee_opt_amt		= request.getParameter("fee_opt_amt")		==null?0:AddUtil.parseDigit(request.getParameter("fee_opt_amt"));
	int today_dist		= request.getParameter("today_dist")==null?0:AddUtil.parseDigit(request.getParameter("today_dist"));
	String fee_rent_st 	= request.getParameter("fee_rent_st")	==null?"":request.getParameter("fee_rent_st");
	String fee_start_dt = request.getParameter("fee_start_dt")	==null?"":request.getParameter("fee_start_dt");
	
	
	int count = 0;
	
	
	//차량기본정보
	ContCarBean car 	= a_db.getContCarNew(rent_mng_id, rent_l_cd);
	
	//차명정보
	cm_bean = a_cmb.getCarNmCase(car.getCar_id(), car.getCar_seq());
	
	
	String reg_code  = Long.toString(System.currentTimeMillis());
	
	
	/*차량정보*/
	bean.setCar_comp_id	(cm_bean.getCar_comp_id());
	bean.setCar_cd		(cm_bean.getCode());
	bean.setCar_id		(cm_bean.getCar_id());
	bean.setCar_seq		(cm_bean.getCar_seq());
	bean.setJg_opt_st	("");
	bean.setJg_col_st	("");
	
	bean.setCar_amt		(car.getCar_cs_amt()+car.getCar_cv_amt());
	bean.setOpt			(car.getOpt());
	bean.setOpt_seq		("");
	bean.setOpt_amt		(car.getOpt_cs_amt()+car.getOpt_cv_amt());
	bean.setCol			(car.getColo());
	bean.setCol_amt		(car.getClr_cs_amt()+car.getClr_cv_amt());
	bean.setDc_amt		(0);
	bean.setO_1			(fee_opt_amt);
	bean.setTax_dc_amt	(car.getTax_dc_s_amt()+car.getTax_dc_v_amt());
	
	bean.setEst_nm		(request.getParameter("est_nm")==null?"":request.getParameter("est_nm"));
	bean.setEst_ssn		(request.getParameter("est_ssn")==null?"":request.getParameter("est_ssn"));
	bean.setEst_tel		(request.getParameter("est_tel")==null?"":request.getParameter("est_tel"));
	bean.setEst_fax		(request.getParameter("est_fax")==null?"":request.getParameter("est_fax"));
	bean.setEst_email	(request.getParameter("est_email")==null?"":request.getParameter("est_email").trim());
	bean.setDoc_type	(request.getParameter("doc_type")==null?"":request.getParameter("doc_type"));
	bean.setSpr_yn		(request.getParameter("spr_yn")==null?"0":request.getParameter("spr_yn"));
	bean.setVali_type	(request.getParameter("vali_type")==null?"":request.getParameter("vali_type"));
	
	bean.setA_a			(request.getParameter("a_a")==null?"":request.getParameter("a_a"));
	bean.setA_b			(request.getParameter("a_b")==null?"":request.getParameter("a_b"));
	bean.setRo_13		(request.getParameter("ro_13")==null?0:AddUtil.parseFloat(request.getParameter("ro_13")));
	bean.setOpt_chk		(request.getParameter("opt_chk")==null?"":request.getParameter("opt_chk"));
	bean.setRg_8_amt	(request.getParameter("rg_8_amt")==null?0:AddUtil.parseDigit(request.getParameter("rg_8_amt")));
	bean.setPp_amt		(request.getParameter("pp_amt")==null?0:AddUtil.parseDigit(request.getParameter("pp_amt")));
	bean.setG_10		(request.getParameter("g_10")==null?0:AddUtil.parseDigit(request.getParameter("g_10")));
	
	bean.setIns_per		(request.getParameter("ins_per")==null?"1":request.getParameter("ins_per"));
	bean.setInsurant	(request.getParameter("insurant")==null?"1":request.getParameter("insurant"));
	bean.setIns_age		(request.getParameter("ins_age")==null?"":request.getParameter("ins_age"));
	bean.setIns_dj		(request.getParameter("ins_dj")==null?"":request.getParameter("ins_dj"));
	bean.setCar_ja		(request.getParameter("car_ja")==null?0:AddUtil.parseDigit(request.getParameter("car_ja")));
	
	bean.setUdt_st		(request.getParameter("udt_st")==null?"0":request.getParameter("udt_st"));
	bean.setA_h			(request.getParameter("a_h")==null?"":request.getParameter("a_h"));
	bean.setFee_dc_per	(request.getParameter("fee_dc_per")==null?0:AddUtil.parseFloat(request.getParameter("fee_dc_per")));	
	
	bean.setReg_id		(request.getParameter("damdang_id")==null?"":request.getParameter("damdang_id"));
	bean.setReg_code	(reg_code);
	
	bean.setIns_good	("0");//애니카보험 미가입
	bean.setLpg_yn		("0");//LPG키트 미장착

	if(bean.getGi_yn().equals("")){
		bean.setGi_yn		("0");
	}
	
	//초기납입구분
	bean.setPp_st		("0");
	if(bean.getG_10() > 0) 									bean.setPp_st		("1");//개시대여료
	if(bean.getPp_amt()+bean.getRg_8_amt() > 0) 			bean.setPp_st		("2");//보증금+선납금
	
	//인수지점 없을때
	if(bean.getUdt_st().equals("")){
		if(user_bean.getBr_id().equals("S1")||user_bean.getBr_id().equals("S2")||user_bean.getBr_id().equals("I1")||user_bean.getBr_id().equals("K3")) bean.setUdt_st("1");
		if(user_bean.getBr_id().equals("B1")) bean.setUdt_st("2");
		if(user_bean.getBr_id().equals("D1")) bean.setUdt_st("3");
		if(user_bean.getBr_id().equals("G1")) bean.setUdt_st("5");
		if(user_bean.getBr_id().equals("J1")) bean.setUdt_st("6");
	}
	
	bean.setRent_dt		(fee_start_dt);
	bean.setMgr_nm		(car_mng_id);
	bean.setMgr_ssn		("연장견적");
	bean.setEst_st		("2");//연장견적
	bean.setCls_per		(30);
	
	bean.setRent_mng_id	(rent_mng_id);
	bean.setRent_l_cd	(rent_l_cd);
	bean.setRent_st		(fee_rent_st);
	bean.setFee_opt_amt	(fee_opt_amt);
	bean.setToday_dist	(today_dist);
	bean.setJob			("org");
	bean.setEst_from	("ext_car");
	
	//견적관리번호 생성
	//String est_id = e_db.getNextEst_id("L");
	String est_id = Long.toString(System.currentTimeMillis());
	
	//fms3에서 견적함.
	if(AddUtil.lengthb(est_id) < 15)	est_id = est_id+""+"3";
		
	bean.setEst_type		("L");
	
	/*고객정보*/
	bean.setEst_id		(est_id);
	
	
	
	
	count = e_db.insertEstimate(bean);
%>
<html>
<head>

<title>FMS</title>
<meta http-equiv="content-type" content="text/html; charset=euc-kr">
<link rel="stylesheet" type="text/css" href="/include/table_t.css"></link>
<script language="JavaScript">
<!--
//-->
</script>
</head>
<body>
<form action="ext_car_esti_i_a_proc.jsp" name="form1" method="POST">
<%@ include file="/include/search_hidden.jsp" %>
	<input type='hidden' name='client_id' 	value='<%=client_id%>'>
	<input type='hidden' name='firm_nm' 	value='<%=firm_nm%>'>
	<input type='hidden' name='rent_mng_id' value='<%=rent_mng_id%>'>
	<input type='hidden' name='rent_l_cd'	value='<%=rent_l_cd%>'>
	<input type='hidden' name='car_mng_id' 	value='<%=car_mng_id%>'>
	<input type='hidden' name='car_no' 		value='<%=car_no%>'>
	<input type='hidden' name='car_nm' 		value='<%=car_nm%>'>
	<input type='hidden' name='from_page'	value='<%=from_page%>'>

  	<input type="hidden" name="est_id" value="<%=est_id%>">          
  	<input type="hidden" name="acar_id" value="<%=bean.getReg_id()%>">                 
  	<input type="hidden" name="rent_dt" value="<%=bean.getRent_dt()%>">                 	
  	<input type="hidden" name="reg_code" value="<%=reg_code%>">  
  	<input type="hidden" name="mobile_yn" value="Y">             
  	<input type="hidden" name="opt_chk" value="<%=bean.getOpt_chk()%>"> 
</form>
<script>
<%	if(count==1){%>		
		document.form1.action = "ext_car_esti_i_a_proc.jsp";
		document.form1.submit();		
<%	}else{%>
		alert("에러발생!");
<%	}%>
</script>
</body>
</html>

