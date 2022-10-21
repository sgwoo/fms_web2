<%@ page language="java" contentType="text/html; charset=euc-kr" %>
<%@ page import="java.util.*, java.io.*, acar.util.*, acar.estimate_mng.*, acar.car_mst.*, acar.con_ins.*,acar.cont.*" %>
<jsp:useBean id="bean" class="acar.estimate_mng.EstimateBean" scope="page"/>
<jsp:useBean id="cm_bean" class="acar.car_mst.CarMstBean" scope="page"/>
<jsp:useBean id="a_db" scope="page" class="acar.cont.AddContDatabase"/>
<jsp:useBean id="ai_db" scope="page" class="acar.con_ins.AddInsurDatabase"/>
<jsp:useBean id="shDb" class="acar.secondhand.SecondhandDatabase" scope="page"/>
<%@ include file="/acar/cookies.jsp" %>


<%
	String auth_rw 	= request.getParameter("auth_rw")==null?"":request.getParameter("auth_rw");
	String user_id 	= request.getParameter("user_id")==null?"":request.getParameter("user_id");
	String br_id 	= request.getParameter("br_id")  ==null?"":request.getParameter("br_id");
	
	String s_kd 	= request.getParameter("s_kd")==null? "":request.getParameter("s_kd");
	String t_wd 	= request.getParameter("t_wd")==null? "" :request.getParameter("t_wd");
	String gubun1 	= request.getParameter("gubun1")==null?"":request.getParameter("gubun1");
	String gubun2 	= request.getParameter("gubun2")==null?"":request.getParameter("gubun2");
	String gubun3 	= request.getParameter("gubun3")==null?"":request.getParameter("gubun3");
	String gubun4 	= request.getParameter("gubun4")==null?	"":request.getParameter("gubun4");
	String gubun5 	= request.getParameter("gubun5")==null?	"":request.getParameter("gubun5");
	String st_dt 	= request.getParameter("st_dt")==null?	"":request.getParameter("st_dt");
	String end_dt 	= request.getParameter("end_dt")==null?	"":request.getParameter("end_dt");
	
	
	String rent_mng_id	= request.getParameter("rent_mng_id")==null?"":request.getParameter("rent_mng_id");
	String rent_l_cd	= request.getParameter("rent_l_cd")==null?"":request.getParameter("rent_l_cd");
	String add_rent_st	= request.getParameter("add_rent_st")==null?"s":request.getParameter("add_rent_st");
	String fee_rent_st	= request.getParameter("fee_rent_st")==null?"1":request.getParameter("fee_rent_st");
	String esti_stat	= request.getParameter("esti_stat")==null?"":request.getParameter("esti_stat");	
	String o_13 		= request.getParameter("o_13")==null?"0":request.getParameter("o_13");
	String ro_13 		= request.getParameter("ro_13")==null?"0":request.getParameter("ro_13");
	int ro_13_amt 		= request.getParameter("ro_13_amt")==null?0:AddUtil.parseDigit(request.getParameter("ro_13_amt"));
	int o_1 		= request.getParameter("o_1")==null?0:AddUtil.parseDigit(request.getParameter("o_1"));
	int t_dc_amt 		= request.getParameter("t_dc_amt")==null?0:AddUtil.parseDigit(request.getParameter("t_dc_amt"));
	int sh_amt		= request.getParameter("sh_amt")==null?0:AddUtil.parseDigit(request.getParameter("sh_amt"));
	int fee_opt_amt		= request.getParameter("fee_opt_amt")==null?0:AddUtil.parseDigit(request.getParameter("fee_opt_amt"));
	int grt_s_amt		= request.getParameter("grt_s_amt")==null?0:AddUtil.parseDigit(request.getParameter("grt_s_amt"));
	int pp_s_amt		= request.getParameter("pp_s_amt")==null?0:AddUtil.parseDigit(request.getParameter("pp_s_amt"));
	int pp_v_amt		= request.getParameter("pp_v_amt")==null?0:AddUtil.parseDigit(request.getParameter("pp_v_amt"));
	int ifee_s_amt		= request.getParameter("ifee_s_amt")==null?0:AddUtil.parseDigit(request.getParameter("ifee_s_amt"));
	int ifee_v_amt		= request.getParameter("ifee_v_amt")==null?0:AddUtil.parseDigit(request.getParameter("ifee_v_amt"));
	int pere_r_mth		= request.getParameter("pere_r_mth")==null?0:AddUtil.parseDigit(request.getParameter("pere_r_mth"));
	String rent_dt		= request.getParameter("rent_dt")==null?"":request.getParameter("rent_dt");
	String a_b 		= request.getParameter("con_mon")==null?"":request.getParameter("con_mon");
	String mode 		= request.getParameter("mode")==null?"":request.getParameter("mode");
	String s_st = "";
	String car_gu = "";
	
	
	
	AddCarMstDatabase a_cmb = AddCarMstDatabase.getInstance();
	
	
	
	//계약정보
	ContBaseBean base 	= a_db.getCont(rent_mng_id, rent_l_cd);
	
	//대여정보
	ContFeeBean fee 	= a_db.getContFeeNew(rent_mng_id, rent_l_cd, fee_rent_st);
	
	//차량기본정보
	ContCarBean fee_etc 	= a_db.getContFeeEtcAdd(rent_mng_id, rent_l_cd, add_rent_st);
	
	//차량기본정보
	ContCarBean f_fee_etc 	= a_db.getContFeeEtcAdd(rent_mng_id, rent_l_cd, "1");	
	
	//차량기본정보
	ContCarBean max_fee_etc = a_db.getContFeeEtc(rent_mng_id, rent_l_cd, fee_rent_st);
	
	//차량기본정보
	ContCarBean car 	= a_db.getContCarNew(rent_mng_id, rent_l_cd);
	
	//CAR_NM : 차명정보
	cm_bean 		= a_cmb.getCarNmCase(String.valueOf(car.getCar_id()), String.valueOf(car.getCar_seq()));
	
	//보험정보
	String ins_st = ai_db.getInsSt(base.getCar_mng_id());
	InsurBean ins = ai_db.getIns(base.getCar_mng_id(), ins_st);
	
	//출고정보
	ContPurBean pur 	= a_db.getContPur(rent_mng_id, rent_l_cd);
	
	String taecha_no  	= request.getParameter("taecha_no")==null?"":request.getParameter("taecha_no");
	
	if(taecha_no.equals("")){
		taecha_no = a_db.getMaxTaechaNo(rent_mng_id, rent_l_cd)+"";
	}
			
	//출고지연대차
	ContTaechaBean taecha = a_db.getTaecha(rent_mng_id, rent_l_cd, taecha_no);
	
	
	if(add_rent_st.equals("t")){
		cm_bean = a_cmb.getCarNmCase(taecha.getCar_id(), taecha.getCar_seq());
		
		car 	= a_db.getContCarMaxNew(taecha.getCar_mng_id());
		
		base.setCar_mng_id(taecha.getCar_mng_id());
		
		ins_st = ai_db.getInsSt(taecha.getCar_mng_id());
		
		ins = ai_db.getIns(taecha.getCar_mng_id(), ins_st);
	}
	
	
	//계약기타정보
	ContEtcBean cont_etc = a_db.getContEtc(rent_mng_id, rent_l_cd);
	
	
	
	//추가연장대여정보
	Hashtable fee_add = a_db.getContFeeAdd(rent_mng_id, rent_l_cd, add_rent_st);
	
	
	s_st   = cm_bean.getS_st();
	car_gu = "0";
	
	
	EstiDatabase e_db = EstiDatabase.getInstance();
	
	
	//해당계약의 정상요금 계산 견적
	if(!max_fee_etc.getBc_est_id().equals("")){
		bean = e_db.getEstimateCase(max_fee_etc.getBc_est_id()); 
	}
	
	
	bean.setOne_self	(pur.getOne_self());
	
	if(cont_etc.getRent_suc_m_id().equals(rent_mng_id) && !cont_etc.getRent_suc_l_cd().equals("")){
		pur 	= a_db.getContPur(cont_etc.getRent_suc_m_id(), cont_etc.getRent_suc_l_cd());
		bean.setOne_self	(pur.getOne_self());
	}	
	
	bean.setAgree_dist	(max_fee_etc.getAgree_dist());
	
	/*차량정보*/
	bean.setCar_comp_id	(cm_bean.getCar_comp_id());
	bean.setCar_cd		(cm_bean.getCode());
	bean.setCar_id		(cm_bean.getCar_id());
	bean.setCar_seq		(cm_bean.getCar_seq());		
	bean.setJg_opt_st	(car.getJg_opt_st());
	bean.setJg_col_st	(car.getJg_col_st());
	bean.setJg_tuix_st			(car.getJg_tuix_st());
	bean.setJg_tuix_opt_st	(car.getJg_tuix_opt_st());	
	bean.setCar_amt		(car.getCar_cs_amt()+car.getCar_cv_amt());
	bean.setOpt_amt		(car.getOpt_cs_amt()+car.getOpt_cv_amt()+car.getAdd_opt_amt());
	bean.setCol_amt		(car.getClr_cs_amt()+car.getClr_cv_amt());
	bean.setTax_dc_amt	(car.getTax_dc_s_amt()+car.getTax_dc_v_amt());
	if(max_fee_etc.getBc_est_id().equals("")){
		bean.setDc_amt		(car.getDc_cs_amt()+car.getDc_cv_amt());	
	}
	
	bean.setDriver_add_amt(fee_etc.getDriver_add_amt());
	bean.setReturn_select(f_fee_etc.getReturn_select());
	
	bean.setRtn_run_amt_yn(f_fee_etc.getRtn_run_amt_yn());
			
	bean.setLkas_yn		(cont_etc.getLkas_yn());		// 차선이탈 제어형
	bean.setLdws_yn		(cont_etc.getLdws_yn());	// 차선이탈 경고형
	bean.setAeb_yn		(cont_etc.getAeb_yn());		// 긴급제동 제어형
	bean.setFcw_yn		(cont_etc.getFcw_yn());		// 긴급제동 경고형	
	bean.setHook_yn		(cont_etc.getHook_yn());		// 견인고리
	bean.setLegal_yn	(cont_etc.getLegal_yn());		// 법률비용지원금(고급형)
			
	if(add_rent_st.equals("t")){
		bean.setO_1			(sh_amt);
	}else{
		//신차정산
		if(base.getCar_gu().equals("1") && fee_rent_st.equals("1") && add_rent_st.equals("s")){
			if(max_fee_etc.getBc_est_id().equals("")){
				bean.setO_1		(o_1);
			}
			
		}else{
			bean.setO_1		(sh_amt);
			
			if(fee_opt_amt >0){
				bean.setO_1	(fee_opt_amt);
			}
		}
	}
			
	bean.setEst_tel		("0");
			
			
	//대여상품
	String a_a = base.getCar_st();
	if(a_a.equals("3"))					a_a = "1";
	else if(a_a.equals("1"))		a_a = "2";
	
	String rent_way = fee.getRent_way();
	if(rent_way.equals(""))			rent_way = fee.getRent_way();
	if(rent_way.equals("3"))		rent_way = "2";
	
	//출고전대차는 기본식 견적 적용
	if(add_rent_st.equals("t")){
		rent_way = "2";
	}
	
	bean.setA_a			(a_a+""+rent_way);
			
			
	//초기납입구분
	String pp_st = "";
	if(fee.getIfee_s_amt() > 0) 				pp_st = "1";
	if(pp_s_amt+fee.getGrt_amt_s() > 0) pp_st = "2";
	if(pp_st.equals(""))								pp_st = "0";
	
	//적용선납율
	bean.setPp_per		(fee.getPere_r_per());
	//적용선납금액
	bean.setPp_amt		(pp_s_amt+pp_v_amt);
			
	//개시대여료적용개월수
	int g_10 = 0;
	bean.setG_10		(fee.getPere_r_mth());
	if(fee.getPere_r_mth()==0 && fee.getIfee_s_amt() > 0 && fee.getFee_s_amt() > 0){
		g_10 = Math.round(fee.getIfee_s_amt()/fee.getFee_s_amt());
		bean.setG_10		(g_10);
	}
	
	//추가이용은 선수금 중 보증금만 반영한다. 대여료는 초기화
	if(add_rent_st.equals("a") || add_rent_st.indexOf("im") != -1 ){
		pp_st = "0";
		if(grt_s_amt > 0) pp_st = "2";
		bean.setPp_per		(0);
		bean.setPp_amt		(0);
		bean.setPp_s_amt	(0);
		bean.setPp_v_amt	(0);
		bean.setG_10			(0);
		bean.setIfee_s_amt(0);
		bean.setIfee_v_amt(0);
		bean.setO_11			(0);
		bean.setFee_s_amt	(0);
		bean.setFee_v_amt	(0);
	}	
	
			
	//적용보증금율
	bean.setRg_8		(fee.getGur_p_per());
	//적용보증금액
	bean.setRg_8_amt	(fee.getGrt_amt_s());
			
	//적용영업수당율
	bean.setO_11		(request.getParameter("comm_r_rt")==null?0:AddUtil.parseFloat(request.getParameter("comm_r_rt")));
			
	if(!fee.getRent_st().equals("1") || base.getCar_gu().equals("0")){
		bean.setO_11	(0);
	}
			
	//출고전대차는 보증금액,개시대여료 적용, 선납금 미적용
	if(add_rent_st.equals("t")){
		pp_st = "";
		if(ifee_s_amt > 0) 						pp_st = "1";
		if(grt_s_amt > 0) 						pp_st = "2";
		if(pp_st.equals(""))					pp_st = "0";
		//적용선납율
		bean.setPp_per		(0);
		//적용선납금액
		bean.setPp_amt		(0);
		bean.setPp_s_amt	(0);
		bean.setPp_v_amt	(0);
		bean.setG_10			(pere_r_mth);		
		//적용보증금율
		bean.setRg_8			(request.getParameter("gur_p_per")==null?0:AddUtil.parseFloat(request.getParameter("gur_p_per")));
		//적용보증금액
		bean.setRg_8_amt	(grt_s_amt);
		//적용영업수당율
		bean.setO_11		(0);
	}
			
	bean.setPp_st		(pp_st);
			
			
			
	//애니카보험가입여부
	String eme_yn = cont_etc.getEme_yn();
	String ins_good = "0";
	if(eme_yn.equals("Y"))	ins_good = "1";
	bean.setIns_good	(ins_good);
	
	//보험운전자연령
	String driving_age = base.getDriving_age();
	int ins_age = 0;
	if(driving_age.equals(""))			ins_age = 1;//"":선택없슴	->26세 1
	if(driving_age.equals("0"))			ins_age = 1;//0 :26세		->26세 1
	if(driving_age.equals("1"))			ins_age = 2;//1 :21세		->21세 2
	if(driving_age.equals("2"))			ins_age = 2;//2 :모든운전자	->21세 2
	if(driving_age.equals("3"))			ins_age = 3;//3 :24세		->24세 3
	bean.setIns_age		(Integer.toString(ins_age));
	
	//보험대물자손가입금액
	bean.setIns_dj(base.getGcp_kd());
	if(bean.getIns_dj().equals("")) bean.setIns_dj("1");
			
	//자차면책금
	bean.setCar_ja		(base.getCar_ja());
	
	//피보험자
	bean.setIns_per		(cont_etc.getInsur_per());
	bean.setInsurant	(cont_etc.getInsurant());
			
	//LPG 장착여부
	String lpg_yn = "0";
	if(car.getLpg_setter().equals("2"))	lpg_yn = "1";
	bean.setLpg_yn		(lpg_yn);
	bean.setLpg_kit		(car.getLpg_kit());
			
	//고객신용도구분
	bean.setSpr_yn		(base.getSpr_kd());
	if(bean.getSpr_yn().equals(""))		bean.setSpr_yn("3");
			
	//등록자-장기계약번호
	bean.setReg_id		(user_id);
			
	//연장계약
	if(add_rent_st.equals("a") || !fee_rent_st.equals("1") || add_rent_st.indexOf("im") != -1){
		bean.setEst_st		("2");
	}else{
		if(base.getCar_gu().equals("0") && fee_rent_st.equals("1")){
			bean.setEst_st		("1");
		}
	}
	
	
	bean.setUdt_st			(pur.getUdt_st());
	bean.setEcar_loc_st	(pur.getEcar_loc_st());
	bean.setEco_e_tag		(car.getEco_e_tag());
	bean.setHcar_loc_st	(pur.getHcar_loc_st());
		
	if(base.getCar_gu().equals("0") || base.getCar_gu().equals("2") || !fee_rent_st.equals("1") || mode.equals("cmpadd")){//재리스견적
		bean.setToday_dist	(request.getParameter("sh_km")		==null? 0:AddUtil.parseDigit(request.getParameter("sh_km")));
	}
			
	
	int count = 0;
	boolean flag1 = true;
	
	
	if(a_b.equals("0")){
		a_b = "1";
	}
	
	//대여기간 : 위약면제개월수적용
	bean.setA_b			(a_b);
	
	//출고전대차는 1개월 요금
	if(add_rent_st.equals("t")){
		bean.setA_b		("1");
	}
	
	
	//계약일자 : 대여개시일 적용
	bean.setRent_dt		(rent_dt);
	bean.setReg_dt		(AddUtil.getDate(4)+"0000");
	bean.setEst_from	("cmpadd");
	
	bean.setO_13			(0);
	bean.setRo_13			(0);
	bean.setRo_13_amt	(0);
	
	bean.setRent_mng_id	(rent_mng_id);
	bean.setRent_l_cd	(rent_l_cd);
	bean.setRent_st		(add_rent_st);
	bean.setMgr_nm		(base.getCar_mng_id());
	
	
	//등록지역
	bean.setA_h			(car.getCar_ext());
	
	
	
	
	int esti_idx = 1;
	
	String est_id[]	 		= new String[esti_idx];
	
	
	String reg_code  = Long.toString(System.currentTimeMillis());
	
	bean.setReg_code	(reg_code);	
	
	
	for(int i = 0 ; i < esti_idx ; i++){
		EstimateBean a_bean = new EstimateBean();
		
		a_bean = bean;
		
		
		out.println("#### a_b="+a_bean.getA_b()+"-------------------------------<br>");
		
		//견적관리번호 생성
		est_id[i] = Long.toString(System.currentTimeMillis())+""+String.valueOf(i);
		
		//fms2에서 견적함.
		if(AddUtil.lengthb(est_id[i]) < 15)	est_id[i] = est_id[i]+""+"2";
		
		
		a_bean.setEst_type		("L");
		
		/*고객정보*/
		a_bean.setEst_id		(est_id[i]);
		
		//등록자
		a_bean.setTalk_tel		(ck_acar_id);
		
		a_bean.setJob("org");
		
		
		//20150512 재리스/연장 견적은 사고수리비 반영		
		if(AddUtil.parseInt(a_bean.getRent_dt()) >= 20150512){
			if(add_rent_st.equals("t") || add_rent_st.equals("a") || add_rent_st.indexOf("im") != -1 || base.getCar_gu().equals("0") || base.getCar_gu().equals("2") || !fee_rent_st.equals("1")){//재리스견적
				//차량정보
				Vector vt = shDb.getAccidServAmts(base.getCar_mng_id(), a_bean.getRent_dt());
				int vt_size = vt.size();
				for(int j = 0 ; j < vt_size ; j++){
					Hashtable ht = (Hashtable)vt.elementAt(j);
					if(j==0) a_bean.setAccid_serv_amt1(String.valueOf(ht.get("TOT_AMT"))==null?0 :AddUtil.parseDigit(String.valueOf(ht.get("TOT_AMT"))));
					if(j==1) a_bean.setAccid_serv_amt2(String.valueOf(ht.get("TOT_AMT"))==null?0 :AddUtil.parseDigit(String.valueOf(ht.get("TOT_AMT"))));
				}					
			}
		}	
		
		//20150701 재리스/연장 견적은 계개판교환 전 주행거리 반영		
		if(AddUtil.parseInt(a_bean.getRent_dt()) >= 20150701){
			if(add_rent_st.equals("t") || add_rent_st.equals("a") || add_rent_st.indexOf("im") != -1 || base.getCar_gu().equals("0") || base.getCar_gu().equals("2") || !fee_rent_st.equals("1")){//재리스견적
				//차량정보
				Hashtable ht2 = shDb.getBase(base.getCar_mng_id(), a_bean.getRent_dt(), "");				
				a_bean.setCha_st_dt	(String.valueOf(ht2.get("CHA_ST_DT"))==null?"":String.valueOf(ht2.get("CHA_ST_DT")));
				a_bean.setB_dist	(String.valueOf(ht2.get("B_DIST"))==null?0 :AddUtil.parseDigit(String.valueOf(ht2.get("B_DIST"))));
			}
		}				
		
		
		count = e_db.insertEstimate(a_bean);
		
	}
		
	
	
	
	fee_etc.setSh_car_amt		(request.getParameter("sh_car_amt")	==null? 0:AddUtil.parseDigit(request.getParameter("sh_car_amt")));
	fee_etc.setSh_year		(request.getParameter("sh_year")	==null?"":request.getParameter("sh_year"));
	fee_etc.setSh_month		(request.getParameter("sh_month")	==null?"":request.getParameter("sh_month"));
	fee_etc.setSh_day		(request.getParameter("sh_day")		==null?"":request.getParameter("sh_day"));
	fee_etc.setSh_day_bas_dt	(request.getParameter("sh_day_bas_dt")==null?"":request.getParameter("sh_day_bas_dt"));
	fee_etc.setSh_amt		(request.getParameter("sh_amt")		==null? 0:AddUtil.parseDigit(request.getParameter("sh_amt")));
	fee_etc.setSh_ja		(request.getParameter("sh_ja")		==null? 0:AddUtil.parseFloat(request.getParameter("sh_ja")));
	fee_etc.setSh_km		(request.getParameter("sh_km")		==null? 0:AddUtil.parseDigit(request.getParameter("sh_km")));
	fee_etc.setSh_tot_km		(request.getParameter("sh_tot_km")	==null? 0:AddUtil.parseDigit(request.getParameter("sh_tot_km")));
	fee_etc.setSh_km_bas_dt		(request.getParameter("sh_km_bas_dt")==null?"":request.getParameter("sh_km_bas_dt"));
	fee_etc.setSh_init_reg_dt	(request.getParameter("sh_init_reg_dt")==null?"":request.getParameter("sh_init_reg_dt"));	
	fee_etc.setBc_b_e1		(request.getParameter("bc_b_e1")==null?0:AddUtil.parseFloat(request.getParameter("bc_b_e1")));
	fee_etc.setBc_b_e2		(request.getParameter("bc_b_e2")==null?0:AddUtil.parseDigit(request.getParameter("bc_b_e2")));
	fee_etc.setBc_b_g		(request.getParameter("bc_b_g")	==null?0:AddUtil.parseDigit(request.getParameter("bc_b_g")));
	fee_etc.setBc_b_u		(request.getParameter("bc_b_u")	==null?0:AddUtil.parseDigit(request.getParameter("bc_b_u")));
	fee_etc.setBc_b_ac		(request.getParameter("bc_b_ac")==null?0:AddUtil.parseDigit(request.getParameter("bc_b_ac")));
	fee_etc.setBc_b_g_cont		(request.getParameter("bc_b_g_cont")==null?"":request.getParameter("bc_b_g_cont"));
	fee_etc.setBc_b_u_cont		(request.getParameter("bc_b_u_cont")==null?"":request.getParameter("bc_b_u_cont"));
	fee_etc.setBc_b_ac_cont		(request.getParameter("bc_b_ac_cont")==null?"":request.getParameter("bc_b_ac_cont"));
	
	
	//=====[fee_etc_add] update=====
	flag1 = a_db.updateFeeEtcAdd(fee_etc);
%>
<html>
<head>

<title>FMS</title>
<meta http-equiv="content-type" content="text/html; charset=euc-kr">
<link rel="stylesheet" type="text/css" href="/include/table.css"></link>
<script language='JavaScript' src='/include/common.js'></script>
<script language='JavaScript' src='/include/estimate_dt.js'></script>
<script language="JavaScript">
<!--
//-->
</script>
</head>
<body>
<form action="" name="form1" method="POST">
  <input type='hidden' name="auth_rw" 			value="<%=auth_rw%>">
  <input type='hidden' name="user_id" 			value="<%=user_id%>">
  <input type='hidden' name="br_id"   			value="<%=br_id%>">
  <input type='hidden' name='s_kd'  			value='<%=s_kd%>'>
  <input type='hidden' name='t_wd' 				value='<%=t_wd%>'>			
  <input type='hidden' name='gubun1' 			value='<%=gubun1%>'>  
  <input type='hidden' name='gubun2' 			value='<%=gubun2%>'>  
  <input type='hidden' name='gubun3' 			value='<%=gubun3%>'>    
  <input type='hidden' name='gubun4' 	value='<%=gubun4%>'>  
  <input type='hidden' name='gubun5' 	value='<%=gubun5%>'>    
  <input type='hidden' name='st_dt' 	value='<%=st_dt%>'>  
  <input type='hidden' name='end_dt' 	value='<%=end_dt%>'>    
  
  <input type="hidden" name="a_e" 			value="<%=s_st%>">
  <input type="hidden" name="esti_stat" 		value="<%=esti_stat%>">      
  <input type="hidden" name="m_id" 			value="<%=rent_mng_id%>">
  <input type="hidden" name="l_cd" 			value="<%=rent_l_cd%>">      
  <input type="hidden" name="fee_rent_st" 		value="<%=fee_rent_st%>">
  <input type="hidden" name="add_rent_st" 		value="<%=add_rent_st%>">
  <input type="hidden" name="car_mng_id" 		value="<%=base.getCar_mng_id()%>">
  <input type="hidden" name="rent_st" 			value="<%=bean.getEst_st()%>">
  <input type="hidden" name="rent_dt" 			value="<%=rent_dt%>">
  <input type="hidden" name="est_from" 			value="cmpadd">  
  <input type="hidden" name="from_page" 		value="car_rent">
  <input type="hidden" name="cmd" 			value="u">
  <input type="hidden" name="e_page" 			value="i">  
  <input type="hidden" name="esti_table" 		value="estimate">       
  <input type="hidden" name="reg_code" 			value="<%=reg_code%>">    
  
  <%for(int i = 0 ; i < esti_idx ; i++){%>   
  <input type="hidden" name="est_id" value="<%=est_id[i]%>">          
  <%}%>       
  
</form>
<script>

<%	if(count==1){%>

		
		<%if(add_rent_st.equals("t") || add_rent_st.equals("a") || add_rent_st.indexOf("im") != -1 || base.getCar_gu().equals("0") || base.getCar_gu().equals("2") || !fee_rent_st.equals("1")){//재리스견적%>

			
			<%if(add_rent_st.equals("t") || (base.getCar_gu().equals("0") && fee_rent_st.equals("1")  && add_rent_st.indexOf("im") == -1)){ //출고전대차, 재리스신규%>
			document.form1.rent_st.value = '1'; //재리스
			<%}else if(base.getCar_gu().equals("2") && fee_rent_st.equals("1") && add_rent_st.indexOf("im") == -1){ //중고차신규%>
			document.form1.rent_st.value = '3'; //중고차
			<%}else{%>
			document.form1.rent_st.value = '2'; //연장
			<%}%>			
			
			//재리스 견적프로그램 이동
			document.form1.action = "/acar/secondhand/esti_mng_i_a_2_proc_20090901.jsp";			
			
		
		<%}else{//신차견적%>
		
			//신차 견적프로그램 이동
			document.form1.action = "/acar/estimate_mng/esti_mng_i_a_2_proc_20090901.jsp";

		<%}%>		
		
		document.form1.submit();		
<%	}else{
		if(cm_bean.getJg_code().equals("")){%>
		alert("잔가코드가 없습니다. 차종관리에서 입력하십시오.");
		<%}else{%>
		alert("에러발생!");		
<%		}
	}%>
	


</script>
</body>
</html>

