<%@ page language="java" contentType="text/html; charset=euc-kr" %>
<%@ page import="java.util.*, acar.util.*, acar.estimate_mng.*, acar.secondhand.*, acar.car_register.*" %>
<jsp:useBean id="e_bean" class="acar.estimate_mng.EstimateBean" scope="page"/>
<%@ include file="/acar/cookies.jsp" %>

<% 
	String auth_rw = request.getParameter("auth_rw")==null?"":request.getParameter("auth_rw");
	String br_id = request.getParameter("br_id")==null?"":request.getParameter("br_id");
	String user_id = request.getParameter("user_id")==null?"":request.getParameter("user_id");
	String gubun1 = request.getParameter("gubun1")==null?"":request.getParameter("gubun1");
	String gubun2 = request.getParameter("gubun2")==null?"":request.getParameter("gubun2");
	String gubun3 = request.getParameter("gubun3")==null?"1":request.getParameter("gubun3");
	String gubun4 = request.getParameter("gubun4")==null?"2":request.getParameter("gubun4");
	String gubun5 = request.getParameter("gubun5")==null?"":request.getParameter("gubun5");
	String gubun6 = request.getParameter("gubun6")==null?"":request.getParameter("gubun6");
	String s_dt = request.getParameter("s_dt")==null?"":request.getParameter("s_dt");
	String e_dt = request.getParameter("e_dt")==null?"":request.getParameter("e_dt");
	String s_kd = request.getParameter("s_kd")==null?"":request.getParameter("s_kd");
	String t_wd = request.getParameter("t_wd")==null?"":request.getParameter("t_wd");
	String esti_m = request.getParameter("esti_m")==null?"":request.getParameter("esti_m");
	String esti_m_dt = request.getParameter("esti_m_dt")==null?"":request.getParameter("esti_m_dt");
	String esti_m_s_dt = request.getParameter("esti_m_s_dt")==null?"":request.getParameter("esti_m_s_dt");
	String esti_m_e_dt = request.getParameter("esti_m_e_dt")==null?"":request.getParameter("esti_m_e_dt");	
	String cmd = request.getParameter("cmd")==null?"":request.getParameter("cmd");
	String from_page2 = request.getParameter("from_page2")==null?"":request.getParameter("from_page2");
	
	String car_mng_id 	= request.getParameter("car_mng_id")==null?"":request.getParameter("car_mng_id");
	String today_dist 	= request.getParameter("today_dist")==null?"":request.getParameter("today_dist");
	String est_id = request.getParameter("est_id")==null?"":request.getParameter("est_id");
	
	String a_a 			= request.getParameter("a_a")		==null?"22":request.getParameter("a_a");
	String a_b 			= request.getParameter("a_b")		==null?"":request.getParameter("a_b");
	String ins_dj 		= request.getParameter("ins_dj")	==null?"":request.getParameter("ins_dj");
	String ins_age 		= request.getParameter("ins_age")	==null?"":request.getParameter("ins_age");
	String rg_8 		= request.getParameter("rg_8")		==null?"":request.getParameter("rg_8");
	String rg_8_amt		= request.getParameter("rg_8_amt")	==null?"":request.getParameter("rg_8_amt");
	String pp_per 		= request.getParameter("pp_per")	==null?"":request.getParameter("pp_per");
	String pp_amt		= request.getParameter("pp_amt")	==null?"":request.getParameter("pp_amt");
	
	int count = 0;	
	
	EstiDatabase e_db = EstiDatabase.getInstance();
	
	EstimateBean a_bean = e_db.getEstimateCase(est_id);
		
	String reg_code  = Long.toString(System.currentTimeMillis());
	
	
		e_bean.setReg_code			(reg_code);
		e_bean.setA_a				(a_a);
		e_bean.setA_b				(a_b);
		e_bean.setRg_8				(AddUtil.parseFloat(rg_8));
		e_bean.setRg_8_amt			(AddUtil.parseDigit(rg_8_amt));
		e_bean.setIns_dj			(ins_dj);
		e_bean.setIns_age			(ins_age);
		e_bean.setAgree_dist		(request.getParameter("agree_dist")==null?0 :AddUtil.parseDigit(request.getParameter("agree_dist")));
		e_bean.setB_agree_dist		(request.getParameter("b_agree_dist")==null?0 :AddUtil.parseDigit(request.getParameter("b_agree_dist")));
		e_bean.setReg_id			(ck_acar_id);	
		
		e_bean.setPp_per			(AddUtil.parseFloat(pp_per));
		e_bean.setPp_amt			(AddUtil.parseDigit(pp_amt));

	
		e_bean.setRent_dt			(a_bean.getRent_dt());
		e_bean.setCar_comp_id	(a_bean.getCar_comp_id());
		e_bean.setCar_cd			(a_bean.getCar_cd());
		e_bean.setCar_id			(a_bean.getCar_id());
		e_bean.setCar_seq			(a_bean.getCar_seq());
		e_bean.setJg_opt_st		(a_bean.getJg_opt_st());
		e_bean.setJg_col_st		(a_bean.getJg_col_st());
		e_bean.setCar_amt			(a_bean.getCar_amt());
		e_bean.setOpt					(a_bean.getOpt());
		e_bean.setOpt_seq			("");
		e_bean.setOpt_amt			(a_bean.getOpt_amt());
		e_bean.setCol					(a_bean.getCol());
		e_bean.setCol_amt			(a_bean.getCol_amt());
		e_bean.setDc_amt			(0);	
		e_bean.setA_h					(a_bean.getA_h());
		e_bean.setSpr_yn			(a_bean.getSpr_yn());
		e_bean.setO_1					(a_bean.getO_1());
		e_bean.setTax_dc_amt	(a_bean.getTax_dc_amt());
		e_bean.setO_13				(0);
		e_bean.setRo_13				(0);
		e_bean.setJg_tuix_st	(a_bean.getJg_tuix_st());
		e_bean.setJg_tuix_opt_st(a_bean.getJg_tuix_opt_st());
		e_bean.setG_10				(a_bean.getG_10());
		e_bean.setIfee_s_amt	(0);
		
		
		//초기납입구분
		e_bean.setPp_st				("0");
		if(e_bean.getG_10() > 0) 												e_bean.setPp_st		("1");//개시대여료
		if(e_bean.getPp_amt()+e_bean.getRg_8_amt() > 0) e_bean.setPp_st		("2");//보증금+선납금
		if(e_bean.getPp_per()+e_bean.getRg_8() > 0) 		e_bean.setPp_st		("2");//보증금+선납금
		
		e_bean.setFee_dc_per	(a_bean.getFee_dc_per());
		e_bean.setIns_good		(a_bean.getIns_good());
		e_bean.setIns_per			(a_bean.getIns_per());
		e_bean.setInsurant		(a_bean.getInsurant());
		e_bean.setGi_yn				(a_bean.getGi_yn());
		e_bean.setGi_per			(a_bean.getGi_per());
		e_bean.setGi_amt			(a_bean.getGi_amt());
		e_bean.setCar_ja			(a_bean.getCar_ja());
		e_bean.setMgr_nm			(a_bean.getMgr_nm());
		e_bean.setMgr_ssn			(a_bean.getMgr_ssn());
		e_bean.setToday_dist	(a_bean.getToday_dist());
		e_bean.setTot_dt			(a_bean.getTot_dt());
		e_bean.setEst_nm			(a_bean.getEst_nm());
		e_bean.setEst_ssn			(a_bean.getEst_ssn());
		e_bean.setEst_tel			(a_bean.getEst_tel());
		e_bean.setEst_fax			(a_bean.getEst_fax());
		e_bean.setEst_st			(a_bean.getEst_st());
		e_bean.setEst_from		(a_bean.getEst_from());
		e_bean.setUdt_st			(a_bean.getUdt_st());
		e_bean.setCls_per			(a_bean.getCls_per());
		e_bean.setDoc_type		(a_bean.getDoc_type());
		e_bean.setEst_email		(a_bean.getEst_email().trim());
		e_bean.setTint_b_yn		(a_bean.getTint_b_yn());
		e_bean.setTint_s_yn		(a_bean.getTint_s_yn());
		e_bean.setTint_n_yn		(a_bean.getTint_n_yn());
		e_bean.setSpe_dc_per	(a_bean.getSpe_dc_per());
		e_bean.setAccid_serv_amt1(a_bean.getAccid_serv_amt1());
		e_bean.setAccid_serv_amt2(a_bean.getAccid_serv_amt2());
		e_bean.setAccid_serv_zero(a_bean.getAccid_serv_zero());
		e_bean.setPp_ment_yn	(a_bean.getPp_ment_yn());
		e_bean.setCom_emp_yn	(a_bean.getCom_emp_yn());
		
		e_bean.setBr_to_st			(a_bean.getBr_to_st());
		e_bean.setBr_to			(a_bean.getBr_to());
		e_bean.setBr_from		(a_bean.getBr_from());
		
		
		//견적관리번호 생성
		est_id = Long.toString(System.currentTimeMillis());
		
		//fms2에서 견적함.
		if(AddUtil.lengthb(est_id) < 15)	est_id = est_id+""+"2";
		
		e_bean.setEst_type		(a_bean.getEst_type());
		e_bean.setEst_id			(est_id);		
		
		count = e_db.insertEstimate(e_bean);		
		
		//변수기준일자
		String jg_b_dt = e_db.getVar_b_dt("jg", e_bean.getRent_dt());
		String em_a_j 	= e_db.getVar_b_dt("em", e_bean.getRent_dt());
		String ea_a_j 	= e_db.getVar_b_dt("ea", e_bean.getRent_dt());
		
%>
<html>
<head>

<title>FMS</title>
<meta http-equiv="content-type" content="text/html; charset=euc-kr">
<link rel="stylesheet" type="text/css" href="/include/table_t.css">
<script language='JavaScript' src='/include/estimate.js'></script>
<script language="JavaScript">
<!--
	function go_sp_esti(){
		var fm = document.form1;
		fm.action = "/acar/secondhand_hp/sp_esti_reg_sh_case.jsp";
		fm.submit();
	}
//-->
</script>
</head>
<body>
<form action="" name="form1" method="POST" >
    <input type="hidden" name="auth_rw" value="<%=auth_rw%>">
    <input type="hidden" name="br_id" value="<%=br_id%>">
    <input type="hidden" name="user_id" value="<%=user_id%>">
    <input type="hidden" name="gubun1" value="<%=gubun1%>">
    <input type="hidden" name="gubun2" value="<%=gubun2%>">
    <input type="hidden" name="gubun3" value="<%=gubun3%>">
    <input type="hidden" name="gubun4" value="<%=gubun4%>">
    <input type="hidden" name="gubun5" value="<%=gubun5%>">
    <input type="hidden" name="gubun6" value="<%=gubun6%>">  
    <input type="hidden" name="s_dt" value="<%=s_dt%>">
    <input type="hidden" name="e_dt" value="<%=e_dt%>">
    <input type="hidden" name="s_kd" value="<%=s_kd%>">
    <input type="hidden" name="t_wd" value="<%=t_wd%>">
    <input type="hidden" name="est_id" value="<%=est_id%>">
    <input type="hidden" name="car_mng_id" value="<%=car_mng_id%>">
    <input type="hidden" name="reg_code"		value="<%=reg_code%>">
    <input type="hidden" name="jg_b_dt"		value="<%=jg_b_dt%>">
    <input type="hidden" name="em_a_j"		value="<%=em_a_j%>">
    <input type="hidden" name="ea_a_j"		value="<%=ea_a_j%>">
    <input type="hidden" name="from_page" 	value="secondhand">
    <input type="hidden" name="acar_id" 		value="<%=ck_acar_id%>">
    <input type="hidden" name="est_st" 		value="<%=e_bean.getEst_st()%>">
</form>
<script>
<!--
		go_sp_esti();
//-->
</script>
</body>
</html>
