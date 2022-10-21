<%@ page language="java" contentType="text/html; charset=euc-kr" %>
<%@ page import="java.util.*, acar.util.*, acar.estimate_mng.*, acar.secondhand.*, acar.car_register.*" %>
<jsp:useBean id="e_bean" class="acar.estimate_mng.EstimateBean" scope="page"/>
<jsp:useBean id="shDb" class="acar.secondhand.SecondhandDatabase" scope="page"/>
<%@ include file="/agent/cookies.jsp" %>

<%
	String auth_rw 		= request.getParameter("auth_rw")	==null?"":request.getParameter("auth_rw");
	String br_id 		= request.getParameter("br_id")		==null?"":request.getParameter("br_id");
	String user_id 		= request.getParameter("user_id")	==null?"":request.getParameter("user_id");
	
	String s_kd 	= request.getParameter("s_kd")==null? "":request.getParameter("s_kd");
	String t_wd 	= request.getParameter("t_wd")==null? "" :request.getParameter("t_wd");
	String gubun1 	= request.getParameter("gubun1")==null?"":request.getParameter("gubun1");
	String gubun2 	= request.getParameter("gubun2")==null?"":request.getParameter("gubun2");
	String gubun3 	= request.getParameter("gubun3")==null?"":request.getParameter("gubun3");
	
	String car_mng_id 	= request.getParameter("car_mng_id")==null?"":request.getParameter("car_mng_id");
	
	String esti_nm 		= request.getParameter("esti_nm")	==null?"":request.getParameter("esti_nm");
	String a_a 			= request.getParameter("a_a")		==null?"22":request.getParameter("a_a");
	String a_b 			= request.getParameter("a_b")		==null?"":request.getParameter("a_b");
	String pp_st 		= request.getParameter("pp_st")		==null?"0":request.getParameter("pp_st");
	String g_10 		= request.getParameter("g_10")		==null?"":request.getParameter("g_10");
	String ifee_amt		= request.getParameter("ifee_amt")	==null?"":request.getParameter("ifee_amt");
	String rg_8 		= request.getParameter("rg_8")		==null?"":request.getParameter("rg_8");
	String rg_8_amt		= request.getParameter("rg_8_amt")	==null?"":request.getParameter("rg_8_amt");
	String pp_per 		= request.getParameter("pp_per")	==null?"":request.getParameter("pp_per");
	String pp_amt		= request.getParameter("pp_amt")	==null?"":request.getParameter("pp_amt");
	String rent_st 		= request.getParameter("rent_st")	==null?"":request.getParameter("rent_st");
	String spr_yn 		= request.getParameter("spr_yn")	==null?"":request.getParameter("spr_yn");
	String lpg_yn 		= request.getParameter("lpg_yn")	==null?"":request.getParameter("lpg_yn");
	String lpg_kit 		= request.getParameter("lpg_kit")	==null?"0":request.getParameter("lpg_kit");
	String a_h 			= request.getParameter("a_h")		==null?"":request.getParameter("a_h");
	String udt_st		= request.getParameter("udt_st")	==null?"":request.getParameter("udt_st");
	String ins_dj 		= request.getParameter("ins_dj")	==null?"":request.getParameter("ins_dj");
	String ins_age 		= request.getParameter("ins_age")	==null?"":request.getParameter("ins_age");
	String ins_good 	= request.getParameter("ins_good")	==null?"":request.getParameter("ins_good");
	String gi_yn 		= request.getParameter("gi_yn")		==null?"":request.getParameter("gi_yn");
	String gi_per 		= request.getParameter("gi_per")	==null?"":request.getParameter("gi_per");
	String gi_amt		= request.getParameter("gi_amt")	==null?"":request.getParameter("gi_amt");
	String car_ja 		= request.getParameter("car_ja")	==null?"":request.getParameter("car_ja");
	String o_13 		= request.getParameter("o_13")		==null?"":request.getParameter("o_13");
	String ro_13 		= request.getParameter("ro_13")		==null?"":request.getParameter("ro_13");
	String ro_13_amt	= request.getParameter("ro_13_amt")	==null?"":request.getParameter("ro_13_amt");
	String o_1			= request.getParameter("o_1")		==null?"":request.getParameter("o_1");
	String fee_dc_per	= request.getParameter("fee_dc_per")==null?"":request.getParameter("fee_dc_per");
	String rent_dt 		= request.getParameter("rent_dt")	==null?"":request.getParameter("rent_dt");
	String st 			= request.getParameter("st")		==null?"":request.getParameter("st");
	String ins_per		= request.getParameter("ins_per")	==null?"1":request.getParameter("ins_per");
	String insurant		= request.getParameter("insurant")	==null?"1":request.getParameter("insurant");
	String one_self		= request.getParameter("one_self")	==null?"":request.getParameter("one_self");
	String doc_type		= request.getParameter("doc_type")	==null?"":request.getParameter("doc_type");
	String com_emp_yn 	= request.getParameter("com_emp_yn")==null?"":request.getParameter("com_emp_yn");
	String gi_grade		= request.getParameter("gi_grade")	==null?"":request.getParameter("gi_grade");
	
	if(ins_per.equals("")) 	ins_per = "1";
	if(insurant.equals("")) insurant = "1";
	
	String cust_nm 		= request.getParameter("cust_nm")==null?"":request.getParameter("cust_nm");
	String damdang_id	= request.getParameter("damdang_id")==null?"":request.getParameter("damdang_id");
	String cust_tel		= request.getParameter("cust_tel")==null?"":request.getParameter("cust_tel");
	String cust_fax 	= request.getParameter("cust_fax")==null?"":request.getParameter("cust_fax");
	String cust_email 	= request.getParameter("cust_email")==null?"":request.getParameter("cust_email");
	
	String cmd 			= request.getParameter("cmd")		==null?"u":request.getParameter("cmd");
	String e_page 		= request.getParameter("e_page")	==null?"i":request.getParameter("e_page");
	String from_page 	= request.getParameter("from_page")	==null?"":request.getParameter("from_page");
	String esti_stat	= request.getParameter("esti_stat")	==null?"":request.getParameter("esti_stat");
	String est_st		= request.getParameter("est_st")	==null?"":request.getParameter("est_st");	
	String l_cd 		= request.getParameter("l_cd")		==null?"":request.getParameter("l_cd");
	String m_id 		= request.getParameter("m_id")		==null?"":request.getParameter("m_id");
	String rent_mng_id 	= request.getParameter("rent_mng_id")==null?"":request.getParameter("rent_mng_id");
	String rent_l_cd 	= request.getParameter("rent_l_cd")==null?"":request.getParameter("rent_l_cd");
	String fee_rent_st = request.getParameter("fee_rent_st")==null?"":request.getParameter("fee_rent_st");
	String est_id 		= request.getParameter("est_id")==null?"":request.getParameter("est_id");
	String a_e 			= request.getParameter("a_e")==null?"":request.getParameter("a_e");
	String est_from 	= request.getParameter("est_from")	==null?"":request.getParameter("est_from");
	String fee_opt_amt 	= request.getParameter("fee_opt_amt")	==null?"":request.getParameter("fee_opt_amt");	
	String cng_item	 	= request.getParameter("cng_item")==null?"":request.getParameter("cng_item");
	int accid_serv_amt1	= request.getParameter("accid_serv_amt1").equals("")	?0:AddUtil.parseDigit(request.getParameter("accid_serv_amt1"));
	int accid_serv_amt2	= request.getParameter("accid_serv_amt2").equals("")	?0:AddUtil.parseDigit(request.getParameter("accid_serv_amt2"));
	String accid_serv_zero	= request.getParameter("accid_serv_zero")==null?"":request.getParameter("accid_serv_zero");
	int count = 0;
	
	EstiDatabase e_db = EstiDatabase.getInstance();
	
	
	//차량정보
	Hashtable ht = shDb.getShBase(car_mng_id);
	
	//잔가 차량정보
	Hashtable sh_var = shDb.getShBaseVar(car_mng_id);
	
	if(rent_st.equals("3")){
		ht = shDb.getShBase(l_cd);
		sh_var = shDb.getShBaseVar(l_cd);
	}
	
	if(lpg_yn.equals("Y")) 	lpg_yn = "1";
	else 					lpg_yn = "0";
	
	if(lpg_kit.equals("")) 	lpg_kit = "0";
	
	if(rent_dt.equals("")) 	rent_dt = String.valueOf(sh_var.get("RENT_DT"));
	
	int today_dist = AddUtil.parseInt(String.valueOf(ht.get("TODAY_DIST")));
	today_dist = AddUtil.parseInt(String.valueOf(ht.get("TOT_DIST"))); //20170629 재리스,월렌트,출고전대차는 최종주행거리로 견적
	if(today_dist == 0) 	today_dist = AddUtil.parseInt(String.valueOf(sh_var.get("TODAY_DIST")));
	
	String reg_code  = Long.toString(System.currentTimeMillis());
	
	String jg_b_dt		= "";
	String em_a_j		= "";
	String ea_a_j		= "";
	
	String car_comp_id		= String.valueOf(ht.get("CAR_COMP_ID"));
	String car_cd			= String.valueOf(ht.get("CAR_CD"));
	String car_id			= String.valueOf(ht.get("CAR_ID"));
	String car_seq			= String.valueOf(ht.get("CAR_SEQ"));
	String jg_opt_st		= String.valueOf(ht.get("JG_OPT_ST"));
	String jg_col_st		= String.valueOf(ht.get("JG_COL_ST"));
	String jg_tuix_st		= String.valueOf(ht.get("JG_TUIX_ST"));
	String jg_tuix_opt_st		= String.valueOf(ht.get("JG_TUIX_OPT_ST"));	
	String serv_dt	 		= String.valueOf(ht.get("SERV_DT"));
	String opt		 	= String.valueOf(ht.get("OPT"));
	String colo		 	= String.valueOf(ht.get("COL"));
	int car_amt 			= AddUtil.parseInt((String)ht.get("CAR_AMT"));
	int opt_amt 			= AddUtil.parseInt((String)ht.get("OPT_AMT"));
	int clr_amt 			= AddUtil.parseInt((String)ht.get("COL_AMT"));
	int tax_dc_amt 		= AddUtil.parseInt((String)ht.get("TAX_DC_AMT"));
	
	
	//견적관리
	if(e_bean.getEst_id().equals("")){
		/*차량정보*/
		e_bean.setCar_comp_id	(car_comp_id);
		e_bean.setCar_cd		(car_cd);
		e_bean.setCar_id		(car_id);
		e_bean.setCar_seq		(car_seq);
		e_bean.setJg_opt_st		(jg_opt_st);
		e_bean.setJg_col_st		(jg_col_st);
		e_bean.setJg_tuix_st		(jg_tuix_st);
		e_bean.setJg_tuix_opt_st		(jg_tuix_opt_st);
		e_bean.setCar_amt		(car_amt);
		e_bean.setOpt			(opt);
		e_bean.setOpt_seq		("");
		e_bean.setOpt_amt		(opt_amt);
		e_bean.setCol			(colo);
		e_bean.setCol_amt		(clr_amt);
		e_bean.setDc_amt		(0);	
		e_bean.setReg_code		(reg_code);
		e_bean.setA_a			(a_a);
		e_bean.setA_h			(a_h);
		e_bean.setA_b			(a_b);
		e_bean.setSpr_yn		(spr_yn);
		e_bean.setO_1			(AddUtil.parseDigit(o_1));
		e_bean.setTax_dc_amt(tax_dc_amt);
		
		e_bean.setO_13			(AddUtil.parseFloat(ro_13));
		e_bean.setRo_13			(AddUtil.parseFloat(ro_13));
		e_bean.setPp_st			(pp_st);
		e_bean.setG_10			(AddUtil.parseDigit(g_10));
		e_bean.setIfee_s_amt	(AddUtil.parseDigit(ifee_amt));
		e_bean.setRg_8			(AddUtil.parseFloat(rg_8));
		e_bean.setRg_8_amt		(AddUtil.parseDigit(rg_8_amt));
		e_bean.setPp_per		(AddUtil.parseFloat(pp_per));
		e_bean.setPp_amt		(AddUtil.parseDigit(pp_amt));
		
		e_bean.setGi_grade(gi_grade);
		
		//초기납입구분
		e_bean.setPp_st		("0");
		if(e_bean.getG_10() > 0) 								e_bean.setPp_st		("1");//개시대여료
		if(e_bean.getPp_amt()+e_bean.getRg_8_amt() > 0) 		e_bean.setPp_st		("2");//보증금+선납금
		if(e_bean.getPp_per()+e_bean.getRg_8() > 0) 			e_bean.setPp_st		("2");//보증금+선납금
		
		
		e_bean.setFee_dc_per	(AddUtil.parseFloat(fee_dc_per));
		e_bean.setLpg_yn		(lpg_yn);
		e_bean.setLpg_kit		(lpg_kit);
		e_bean.setIns_dj		(ins_dj);
		e_bean.setIns_age		(ins_age);
		e_bean.setIns_good		(ins_good);
		e_bean.setIns_per		(ins_per);
		e_bean.setInsurant		(insurant);
		e_bean.setGi_yn			(gi_yn);
		if(gi_yn.equals("1")){
			e_bean.setGi_per		(AddUtil.parseFloat(gi_per));
			e_bean.setGi_amt		(AddUtil.parseDigit(gi_amt));
		}
		e_bean.setCar_ja		(AddUtil.parseDigit(car_ja));
		if(from_page.equals("secondhand")){//재리스현황-보유차재리스
		}else{
			e_bean.setReg_id	(l_cd);
		}
		e_bean.setRent_dt		(rent_dt);
		e_bean.setMgr_nm		(car_mng_id);
		e_bean.setMgr_ssn		(esti_nm);
		e_bean.setToday_dist(today_dist);
		e_bean.setTot_dt		(serv_dt);
		e_bean.setEst_nm		(cust_nm);
		e_bean.setEst_tel		(cust_tel);
		e_bean.setEst_fax		(cust_fax);
		e_bean.setEst_st		(rent_st);
		e_bean.setEst_from		(from_page);
		e_bean.setUdt_st		(udt_st);
		e_bean.setCls_per		(30);
		if(st.equals("1")){ //출고전대차
			e_bean.setEst_from		("tae_car");
		}
		if(damdang_id.equals("")){
			e_bean.setReg_id	(user_id);
		}else{
			e_bean.setReg_id	(damdang_id);
		}
		
		if(est_st.equals("2") && !rent_l_cd.equals("")){
			e_bean.setRent_mng_id	(rent_mng_id);
			e_bean.setRent_l_cd		(rent_l_cd);
			e_bean.setRent_st		(fee_rent_st);
			e_bean.setEst_st		(est_st);
			e_bean.setEst_from		("lc_c_h");
			
			if(!fee_opt_amt.equals("0")) 	e_bean.setO_1(AddUtil.parseDigit(fee_opt_amt));
		}
		
		if(cng_item.equals("taecha") && !rent_l_cd.equals("")){
			e_bean.setRent_mng_id	(rent_mng_id);
			e_bean.setRent_l_cd		(rent_l_cd);
			e_bean.setRent_st		(fee_rent_st);
			e_bean.setEst_st		(est_st);
			e_bean.setEst_from		("lc_c_u");
		}
		
		e_bean.setDoc_type		(doc_type);
		e_bean.setEst_email		(cust_email.trim());
		
		//e_bean.setAgree_dist	(request.getParameter("agree_dist")==null?0 :AddUtil.parseDigit(request.getParameter("agree_dist")));
		//e_bean.setB_agree_dist	(request.getParameter("b_agree_dist")==null?0 :AddUtil.parseDigit(request.getParameter("b_agree_dist")));
		
		e_bean.setRtn_run_amt_yn(request.getParameter("rtn_run_amt_yn")==null? "":request.getParameter("rtn_run_amt_yn"));
		
		//20150512 사고수리비 반영
		e_bean.setAccid_serv_amt1(accid_serv_amt1);
		e_bean.setAccid_serv_amt2(accid_serv_amt2);
		
		//무사고기준
		if(accid_serv_zero.equals("Y")){
			e_bean.setAccid_serv_amt1(0);
			e_bean.setAccid_serv_amt2(0);		
			
			e_bean.setO_1			(0);
			e_bean.setO_13			(0);
			e_bean.setRo_13			(0);
		}
		
		e_bean.setPp_ment_yn(request.getParameter("pp_ment_yn")==null?"N":request.getParameter("pp_ment_yn"));
		e_bean.setCom_emp_yn(com_emp_yn);
		
		
		
		//견적관리번호 생성
		//est_id = e_db.getNextEst_id("S");
		est_id = Long.toString(System.currentTimeMillis());
		
		//fms4에서 견적함.
		if(AddUtil.lengthb(est_id) < 15)	est_id = est_id+""+"4";
		
		
		e_bean.setEst_type	("S");
		e_bean.setEst_id		(est_id);
		
		count = e_db.insertEstimate(e_bean);
		
		
		//변수기준일자
		jg_b_dt = e_db.getVar_b_dt("jg", e_bean.getRent_dt());
		em_a_j 	= e_db.getVar_b_dt("em", e_bean.getRent_dt());
		ea_a_j 	= e_db.getVar_b_dt("ea", e_bean.getRent_dt());
		
		/*
		System.out.println("#### esti_mng_i_20090901_a.jsp-------------------------<br>");
		System.out.println("#### rent_dt="+e_bean.getRent_dt()+"------------------<br>");
		System.out.println("#### jg_b_dt="+jg_b_dt+"-------------------------------<br>");
		System.out.println("#### em_a_j="+em_a_j+"---------------------------------<br>");
		System.out.println("#### ea_a_j="+ea_a_j+"---------------------------------<br>");
		*/
		
		//재리스 계산
//		String  d_flag1 =  e_db.call_sp_esti_reg_sh_case(reg_code, jg_b_dt, em_a_j, ea_a_j);
	}
%>
<html>
<head>

<title>FMS</title>
<meta http-equiv="content-type" content="text/html; charset=euc-kr">
<link rel="stylesheet" type="text/css" href="/include/table_t.css">
<script language='JavaScript' src='/include/estimate.js'></script>
<script language="JavaScript">
<!--
	//비용비교보기
	function go_esti_print(){  
		var fm = document.form1;
		fm.action = "/acar/secondhand_hp/estimate.jsp";
		fm.submit();
	}	
	
	function go_sp_esti(){
		var fm = document.form1;
		fm.action = "/acar/secondhand_hp/sp_esti_reg_sh_case.jsp";
		fm.submit();
	}

	
//-->
</script>
</head>
<body>
<form action="./esti_mng_i_a_3_20080716.jsp" name="form1" method="POST" >
  <input type="hidden" name="auth_rw" 		value="<%=auth_rw%>">
  <input type="hidden" name="br_id" 		value="<%=br_id%>">
  <input type="hidden" name="user_id" 		value="<%=user_id%>">
  <input type="hidden" name="acar_id" 		value="<%=ck_acar_id%>">  
  <input type='hidden' name='s_kd'  		value='<%=s_kd%>'>
  <input type='hidden' name='t_wd' 			value='<%=t_wd%>'>			
  <input type='hidden' name='gubun1' 		value='<%=gubun1%>'>  
  <input type='hidden' name='gubun2' 		value='<%=gubun2%>'>  
  <input type='hidden' name='gubun3' 		value='<%=gubun3%>'>    
 
  <input type="hidden" name="car_mng_id" 	value="<%=car_mng_id%>">
  <input type="hidden" name="esti_nm"		value="<%=esti_nm%>">
  <input type="hidden" name="a_a"			value="<%=a_a%>">
  <input type="hidden" name="a_b"			value="<%=a_b%>">
  <input type="hidden" name="spr_yn" 		value="<%=spr_yn%>">
  <input type="hidden" name="lpg_yn" 		value="<%=lpg_yn%>">
  <input type="hidden" name="lpg_kit" 		value="<%=lpg_kit%>">
  <input type="hidden" name="st" 			value="<%=st%>">	
  <input type="hidden" name="est_id" 		value="<%=est_id%>">
  <input type="hidden" name="cmd" 			value="<%=cmd%>">
  <input type="hidden" name="e_page" 		value="<%=e_page%>">
  <input type="hidden" name="from_page" 	value="<%=from_page%>">
  <input type="hidden" name="est_from" 		value="<%=est_from%>">  
  <input type="hidden" name="l_cd" 			value='<%=l_cd%>'>		    
  <input type="hidden" name="m_id" 			value='<%=m_id%>'>
  <input type="hidden" name="fee_rent_st"	value='<%=fee_rent_st%>'>    
  <input type="hidden" name="rg_8" 			value="<%=rg_8%>">
  <input type="hidden" name="ins_good"		value="<%=ins_good%>">  
  <input type="hidden" name="reg_code"		value="<%=reg_code%>">   
  <input type="hidden" name="jg_b_dt"		value="<%=jg_b_dt%>">   
  <input type="hidden" name="em_a_j"		value="<%=em_a_j%>">   
  <input type="hidden" name="ea_a_j"		value="<%=ea_a_j%>">         
  <input type="hidden" name="cng_item"		value="<%=cng_item%>">			   
  <input type="hidden" name="o_13" 			value="">
  <input type="hidden" name="ro_13_amt" 	value="">
  <input type="hidden" name="fee_amt" 		value="">
  <input type="hidden" name="fee_s_amt" 	value="">
  <input type="hidden" name="fee_v_amt" 	value="">
  <input type="hidden" name="ifee_s_amt" 	value="">
  <input type="hidden" name="ifee_v_amt" 	value="">
  <input type="hidden" name="pp_s_amt" 		value="">
  <input type="hidden" name="pp_v_amt" 		value="">          
  <input type="hidden" name="gtr_amt" 		value="">            
  <input type="hidden" name="gi_amt" 		value="">            
  <input type="hidden" name="gi_fee" 		value="">            
  <!--영업효율관련변수-->              
  <input type="hidden" name="bc_s_a" value="">
  <input type="hidden" name="bc_s_b" value="">
  <input type="hidden" name="bc_s_c" value="">
  <input type="hidden" name="bc_s_d" value="">
  <input type="hidden" name="bc_s_e" value="">
  <input type="hidden" name="bc_s_f" value="0">
  <input type="hidden" name="bc_s_g" value="">
  <input type="hidden" name="bc_s_i" value="0">  
  <input type="hidden" name="bc_b_a" value="">
  <input type="hidden" name="bc_b_b" value="">
  <input type="hidden" name="bc_b_d" value="">
  <input type="hidden" name="bc_b_e1" value="">
  <input type="hidden" name="bc_b_e2" value="">
  <input type="hidden" name="bc_b_k" value="">
  <input type="hidden" name="bc_b_n" value="0">
  <input type="hidden" name="one_self" value="<%=one_self%>">  
  <input type="hidden" name="est_st" value="<%=est_st%>">    
  <input type="hidden" name="st" value="<%=st%>">      
  <input type="hidden" name="rent_l_cd" value="<%=rent_l_cd%>">        
</form>
<script>
<!--

	go_sp_esti();	
	

//-->
</script>
</body>
</html>
