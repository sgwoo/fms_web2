<%@ page language="java" contentType="text/html; charset=euc-kr" %>
<%@ page import="java.util.*, java.io.*, acar.util.*, acar.estimate_mng.*, acar.car_mst.*" %>
<%@ page import="acar.con_ins.*,acar.cont.*,acar.client.*, acar.car_register.*, acar.user_mng.*" %>
<%@ page import="acar.coolmsg.* "%>
<jsp:useBean id="em_bean" class="acar.estimate_mng.EstiCommVarBean" scope="page"/>
<jsp:useBean id="ej_bean" class="acar.estimate_mng.EstiJgVarBean" scope="page"/>
<jsp:useBean id="cm_bean" class="acar.car_mst.CarMstBean" scope="page"/>
<jsp:useBean id="a_db" scope="page" class="acar.cont.AddContDatabase"/>
<jsp:useBean id="ai_db" scope="page" class="acar.con_ins.AddInsurDatabase"/>
<jsp:useBean id="al_db" scope="page" class="acar.client.AddClientDatabase"/>
<jsp:useBean id="af_db" scope="page" class="acar.fee.AddFeeDatabase"/>
<jsp:useBean id="shDb" class="acar.secondhand.SecondhandDatabase" scope="page"/>
<jsp:useBean id="cr_bean"   class="acar.car_register.CarRegBean"       scope="page"/>
<jsp:useBean id="cm_db" scope="page" class="acar.coolmsg.CoolMsgDatabase"/>
<%@ include file="/acar/cookies.jsp" %>

<%
	int o_1 		= request.getParameter("o_1")			==null?0:AddUtil.parseDigit(request.getParameter("o_1"));
	int grt_amt 		= request.getParameter("grt_s_amt")		==null?0:AddUtil.parseDigit(request.getParameter("grt_s_amt"));
	int pp_amt 		= request.getParameter("pp_amt")		==null?0:AddUtil.parseDigit(request.getParameter("pp_amt"));
	int t_ifee_s_amt 	= request.getParameter("ifee_s_amt")		==null?0:AddUtil.parseDigit(request.getParameter("ifee_s_amt"));
	int t_fee_s_amt 	= request.getParameter("fee_s_amt")		==null?0:AddUtil.parseDigit(request.getParameter("fee_s_amt"));
	int add_opt_amt		= request.getParameter("add_opt_amt")		==null?0:AddUtil.parseDigit(request.getParameter("add_opt_amt"));
	int agree_dist		= request.getParameter("new_agree_dist")		==null?0:AddUtil.parseDigit(request.getParameter("new_agree_dist"));
	int cls_n_mon		= request.getParameter("cls_n_mon")		==null?0:AddUtil.parseDigit(request.getParameter("cls_n_mon"));
	int max_agree_dist	= request.getParameter("max_agree_dist")	==null?0:AddUtil.parseDigit(request.getParameter("max_agree_dist"));
	int r_max_agree_dist	= request.getParameter("r_max_agree_dist")	==null?0:AddUtil.parseDigit(request.getParameter("r_max_agree_dist"));
	int sh_km		= request.getParameter("sh_km")			==null?0:AddUtil.parseDigit(request.getParameter("sh_km"));
	int driver_add_amt = request.getParameter("driver_add_amt")==null?0:AddUtil.parseDigit(request.getParameter("driver_add_amt"));
	
	String agree_dist_yn	= request.getParameter("agree_dist_yn")		==null?"":request.getParameter("agree_dist_yn");
	String lpg_setter 	= request.getParameter("lpg_setter")		==null?"":request.getParameter("lpg_setter");
	String lpg_kit	 	= request.getParameter("lpg_kit")		==null?"":request.getParameter("lpg_kit");
	String gi_st 		= request.getParameter("gi_st")			==null?"":request.getParameter("gi_st");
	String s_st 		= request.getParameter("s_st")			==null?"":request.getParameter("s_st");
	String rent_dt 		= request.getParameter("rent_dt")		==null?"":AddUtil.replace(request.getParameter("rent_dt"),"-","");
	String fee_rent_dt 	= request.getParameter("fee_rent_dt")		==null?"":AddUtil.replace(request.getParameter("fee_rent_dt"),"-","");
	String rent_start_dt	= request.getParameter("rent_start_dt")		==null?"":AddUtil.replace(request.getParameter("rent_start_dt"),"-","");
	String ext_rent_dt	= request.getParameter("ext_rent_dt")		==null?"":AddUtil.replace(request.getParameter("ext_rent_dt"),"-","");
	String esti_stat	= request.getParameter("esti_stat")		==null?"":request.getParameter("esti_stat");
	String from_page 	= request.getParameter("from_page")		==null?"":request.getParameter("from_page");
	String from_page2 	= request.getParameter("from_page2")		==null?"":request.getParameter("from_page2");
	String est_from 	= request.getParameter("est_from")		==null?"":request.getParameter("est_from");
	String car_gu 		= request.getParameter("car_gu")		==null?"1":request.getParameter("car_gu");
	String comm_r_rt	= request.getParameter("comm_r_rt")		==null?"":request.getParameter("comm_r_rt");
	String udt_st		= request.getParameter("udt_st")		==null?"":request.getParameter("udt_st");
	String insur_per	= request.getParameter("insur_per")		==null?"":request.getParameter("insur_per");
	String insurant		= request.getParameter("insurant")		==null?"":request.getParameter("insurant");
	String one_self		= request.getParameter("one_self")		==null?"":request.getParameter("one_self");	
	String action_st 	= request.getParameter("action_st")		==null?"":request.getParameter("action_st");
	
	String rent_mng_id	= request.getParameter("rent_mng_id")		==null?"":request.getParameter("rent_mng_id");
	String rent_l_cd	= request.getParameter("rent_l_cd")		==null?"":request.getParameter("rent_l_cd");
	String car_mng_id 	= request.getParameter("car_mng_id")		==null?"":request.getParameter("car_mng_id");
	String rent_st 		= request.getParameter("fee_rent_st")		==null?"1":request.getParameter("fee_rent_st");
	String fee_rent_st	= request.getParameter("fee_rent_st")		==null?"1":request.getParameter("fee_rent_st");
	String opt_chk		= request.getParameter("opt_chk")		==null?"1":request.getParameter("opt_chk");
	String dir_pur_yn	= request.getParameter("dir_pur_yn")		==null?"1":request.getParameter("dir_pur_yn");
	
	String br_to_st	= request.getParameter("br_to_st")	==null?"":request.getParameter("br_to_st");
	String br_to		= request.getParameter("br_to")		==null?"":request.getParameter("br_to");
	String br_from		= request.getParameter("br_from")	==null?"":request.getParameter("br_from");
	
	//조정차액
	String ctr_s_amt	= request.getParameter("ctr_s_amt")	==null?"":request.getParameter("ctr_s_amt");
	String ctr_v_amt	= request.getParameter("ctr_v_amt")	==null?"":request.getParameter("ctr_v_amt");
	
	String cng_dt	= request.getParameter("cng_dt")	==null?"":request.getParameter("cng_dt");
	String reg_id	= request.getParameter("reg_id")	==null?"":request.getParameter("reg_id");
	
	
	int count = 0;
	boolean flag3 = true;
	boolean flag4 = true;
	
	//위약금면제 무시
	cls_n_mon = 0;	
	
	EstiDatabase 		e_db 	= EstiDatabase.getInstance();
	AddCarMstDatabase 	a_cmb 	= AddCarMstDatabase.getInstance();
	CarRegDatabase crd 	= CarRegDatabase.getInstance();	
	MaMenuDatabase nm_db = MaMenuDatabase.getInstance();
	UserMngDatabase umd = UserMngDatabase.getInstance();
	
	//보험정보
	String ins_st = ai_db.getInsSt(car_mng_id);
	acar.con_ins.InsurBean ins = ai_db.getIns(car_mng_id, ins_st);
	
	//계약기본정보
	ContBaseBean base = a_db.getCont(rent_mng_id, rent_l_cd);
	
	rent_dt = base.getRent_dt();
	

	
	//계약기타정보
	ContEtcBean cont_etc = a_db.getContEtc(rent_mng_id, rent_l_cd);
	
	//고객정보
	ClientBean client = al_db.getNewClient(base.getClient_id());
	
	//차량기본정보
	ContCarBean car 	= a_db.getContCarNew(rent_mng_id, rent_l_cd);
	
	//차량등록정보
	if(!base.getCar_mng_id().equals("")){
		cr_bean = crd.getCarRegBean(base.getCar_mng_id());
	}
	
	//CAR_NM : 차명정보
	cm_bean = a_cmb.getCarNmCase(String.valueOf(car.getCar_id()), String.valueOf(car.getCar_seq()));
	
	//잔가변수NEW
	ej_bean = e_db.getEstiJgVarCase(cm_bean.getJg_code(), "");
	
	//공통변수
	em_bean = e_db.getEstiCommVarCase("1", "");
	
	//첫번째대여정보
	ContFeeBean fee = a_db.getContFeeNew(rent_mng_id, rent_l_cd, "1");
	
	//대여료갯수조회(연장여부)
	int fee_size 	= af_db.getMaxRentSt(rent_mng_id, rent_l_cd);
	
	//해당대여정보
	ContFeeBean fees = a_db.getContFeeNew(rent_mng_id, rent_l_cd, Integer.toString(fee_size));
	
	//출고정보
	ContPurBean pur = a_db.getContPur(rent_mng_id, rent_l_cd);
	
	if(fee_rent_st.equals("")){
		rent_st = Integer.toString(fee_size);
	}
	


	//fee_etc
	ContCarBean fee_etc = a_db.getContFeeEtc(rent_mng_id, rent_l_cd, fee_rent_st);	
	
	if(!fee_rent_st.equals("1") && car_gu.equals("1")){
		car_gu = "0";
	}
	
	rent_dt = base.getRent_dt();
	
	if(AddUtil.parseInt(base.getReg_dt()) >= 20220622){
		rent_dt = base.getReg_dt();
	}
	
	EstimateBean bean = new EstimateBean();	
	
	bean.setEst_nm		(client.getFirm_nm());
	bean.setEst_ssn		(client.getEnp_no1()+""+client.getEnp_no2()+""+client.getEnp_no3());
	bean.setEst_tel		(client.getO_tel());
	bean.setEst_fax		(client.getFax());
	
	/*차량정보*/
	bean.setCar_comp_id	(cm_bean.getCar_comp_id());
	bean.setCar_cd		(cm_bean.getCode());
	bean.setCar_id		(cm_bean.getCar_id());
	bean.setCar_seq		(cm_bean.getCar_seq());
	bean.setJg_opt_st	(car.getJg_opt_st());
	bean.setJg_col_st	(car.getJg_col_st());
	bean.setJg_tuix_st			(car.getJg_tuix_st());
	bean.setJg_tuix_opt_st	(car.getJg_tuix_opt_st());	
	bean.setCar_amt		(request.getParameter("car_c_amt")	==null?0:AddUtil.parseDigit(request.getParameter("car_c_amt")));
	bean.setOpt				(request.getParameter("opt")		==null?"":request.getParameter("opt"));
	bean.setOpt_seq		(request.getParameter("opt_code")	==null?"":request.getParameter("opt_code"));
	bean.setOpt_amt		(request.getParameter("opt_c_amt")	==null?0:AddUtil.parseDigit(request.getParameter("opt_c_amt"))+add_opt_amt);
	if(!fee_rent_st.equals("1") || car_gu.equals("0")){
		bean.setOpt_amt	(request.getParameter("opt_c_amt")	==null?0:AddUtil.parseDigit(request.getParameter("opt_c_amt")));
	}
	//신차일때만 잔가 미반영 금액셋팅
	bean.setOpt_amt_m	(request.getParameter("opt_amt_m")	==null?0:AddUtil.parseDigit(request.getParameter("opt_amt_m")));	
	if (!car_gu.equals("1")) {
		bean.setOpt_amt_m(0);
	}
	
	bean.setCol			(request.getParameter("color")		==null?"":request.getParameter("color"));
	bean.setCol_amt		(request.getParameter("col_c_amt")	==null?0:AddUtil.parseDigit(request.getParameter("col_c_amt")));
	bean.setDc_amt		(request.getParameter("t_dc_amt")	==null?0:AddUtil.parseDigit(request.getParameter("t_dc_amt")));
	bean.setO_1			(o_1);
	bean.setTax_dc_amt(request.getParameter("tax_dc_amt")	==null?0:AddUtil.parseDigit(request.getParameter("tax_dc_amt")));
	bean.setDriver_add_amt(driver_add_amt);
	
	bean.setLkas_yn		(cont_etc.getLkas_yn());		// 차선이탈 제어형
	bean.setLdws_yn		(cont_etc.getLdws_yn());		// 차선이탈 경고형
	bean.setAeb_yn		(cont_etc.getAeb_yn());		// 긴급제동 제어형
	bean.setFcw_yn		(cont_etc.getFcw_yn());		// 긴급제동 경고형
	bean.setHook_yn		(cont_etc.getHook_yn());		// 견인고리
	bean.setLegal_yn	(cont_etc.getLegal_yn());		// 법률비용지원금(고급형)
	
	bean.setRtn_run_amt_yn(fee_etc.getRtn_run_amt_yn());
	
	
	//대여상품
	String a_a = request.getParameter("car_st")==null?"":request.getParameter("car_st");
	
	if (a_a.equals("")) {
		a_a = base.getCar_st();
	}
	
	if (a_a.equals("3")) {
		a_a = "1";
	} else if (a_a.equals("1")) {
		a_a = "2";
	}
	
	String rent_way = request.getParameter("rent_way")==null?"":request.getParameter("rent_way");
	if (rent_way.equals(""))	{
		rent_way = fees.getRent_way();
	}
	if (rent_way.equals("3")) {
		rent_way = "2";
	}
	bean.setA_a(a_a+""+rent_way);
		
	if(base.getCar_st().equals("5")){		
		if (cr_bean.getCar_use().equals("1")) {
			a_a = "2";//렌트
		}
		if (cr_bean.getCar_use().equals("2")) {
			a_a = "1";//리스
		}
		rent_way = "2"; //기본식
		bean.setA_a(a_a+""+rent_way);
	}
	
	//대여기간
	bean.setA_b		(request.getParameter("con_mon")==null?"":request.getParameter("con_mon"));
	
	if(cls_n_mon >0){
		bean.setA_b(String.valueOf(AddUtil.parseInt(bean.getA_b())-cls_n_mon));
	}
	
	//등록지역
	String t_car_ext = request.getParameter("car_ext")==null?"":request.getParameter("car_ext");
	String a_h = t_car_ext;
	if(a_h.equals("")) a_h = car.getCar_ext();
	bean.setA_h			(a_h);
	
	//초기납입구분
	String pp_st = "";
	if(t_ifee_s_amt > 0) 			pp_st = "1";
	if(pp_amt+grt_amt > 0) 			pp_st = "2";
	if(pp_st.equals(""))			pp_st = "0";
	bean.setPp_st		(pp_st);
	//적용선납율
	bean.setPp_per		(request.getParameter("pere_r_per")==null?0:AddUtil.parseFloat(request.getParameter("pere_r_per")));
	if(request.getParameter("pere_r_per").equals("NaN")) bean.setPp_per(0);
	//적용선납금액
	bean.setPp_amt		(pp_amt);
	//적용보증금율
	bean.setRg_8		(request.getParameter("gur_p_per")==null?0:AddUtil.parseFloat(request.getParameter("gur_p_per")));
	if(request.getParameter("gur_p_per").equals("Infinity")) bean.setRg_8(0);
	//개시대여료적용개월수
	int g_10 = 0;
	if(t_ifee_s_amt>0 && t_fee_s_amt>0){
		g_10 = Math.round(t_ifee_s_amt/t_fee_s_amt);
		
		float g_10_f = Math.round(AddUtil.parseFloat(String.valueOf(t_ifee_s_amt))/AddUtil.parseFloat(String.valueOf(t_fee_s_amt)));
		g_10 = AddUtil.parseInt(String.valueOf(Math.round(g_10_f)));
	}
	bean.setG_10		(g_10);
	
	//잔존가치율
	/*
	String ro_13 = request.getParameter("ro_13")==null?"0":request.getParameter("ro_13");
	if(ro_13.equals("NaN")) ro_13 = "0";
	bean.setRo_13		(AddUtil.parseFloat(ro_13));
	bean.setO_13		(AddUtil.parseFloat(request.getParameter("o_13")==null?"0":request.getParameter("o_13")));
	
	//적용잔가금액
	int opt_amt = request.getParameter("o_13_amt")==null?0:AddUtil.parseDigit(request.getParameter("o_13_amt"));
	bean.setRo_13_amt	(opt_amt);
	*/
	
	bean.setOpt_chk		(opt_chk);	
	//적용보증금액
	bean.setRg_8_amt	(grt_amt);

	
	//적용영업수당율
	bean.setO_11		(request.getParameter("comm_r_rt")==null?0:AddUtil.parseFloat(request.getParameter("comm_r_rt")));
	
	//애니카보험가입여부
	String eme_yn = request.getParameter("eme_yn")==null?"":request.getParameter("eme_yn");
	if(eme_yn.equals("")) eme_yn = cont_etc.getEme_yn();
	String ins_good = "0";
	if(eme_yn.equals("Y"))	ins_good = "1";
	bean.setIns_good	(ins_good);
	
	//보험운전자연령
	String driving_age = request.getParameter("driving_age")==null?"":request.getParameter("driving_age");
	if(driving_age.equals("")) driving_age = base.getDriving_age();
	int ins_age = 0;
	if(driving_age.equals(""))		ins_age = 1;//"":선택없슴	->26세 1
	if(driving_age.equals("0"))		ins_age = 1;//0 :26세		->26세 1
	if(driving_age.equals("1"))		ins_age = 2;//1 :21세		->21세 2
	if(driving_age.equals("2"))		ins_age = 2;//2 :모든운전자	->21세 2
	if(driving_age.equals("3"))		ins_age = 3;//3 :24세		->24세 3
	bean.setIns_age		(Integer.toString(ins_age));
	
	//보험대물자손가입금액
	bean.setIns_dj		(request.getParameter("gcp_kd")==null?"":request.getParameter("gcp_kd"));
	if(bean.getIns_dj().equals("")) bean.setIns_dj(base.getGcp_kd());
	if(bean.getIns_dj().equals("")) bean.setIns_dj("1");
	
	//자차면책금
	bean.setCar_ja		(request.getParameter("car_ja")==null?0:AddUtil.parseDigit(request.getParameter("car_ja")));
	if(bean.getCar_ja() == 0) bean.setCar_ja(base.getCar_ja());
	
	//LPG 장착여부
	String lpg_yn = "0";
	if(lpg_setter.equals(""))	lpg_setter = car.getLpg_setter();
	if(lpg_setter.equals("2"))	lpg_yn = "1";
	bean.setLpg_yn		(lpg_yn);
	bean.setLpg_kit		(lpg_kit);
	
	//보증보험가입여부
	if(gi_st.equals(""))	gi_st = car.getLpg_setter();
	bean.setGi_yn		(gi_st);
	
	//고객신용도구분
	bean.setSpr_yn		(request.getParameter("spr_kd")==null?"":request.getParameter("spr_kd"));
	if(cont_etc.getDec_gr().equals("")) cont_etc.setDec_gr(base.getSpr_kd());
	if(bean.getSpr_yn().equals(""))		bean.setSpr_yn(cont_etc.getDec_gr());
	if(bean.getSpr_yn().equals(""))		bean.setSpr_yn("3");
	if(base.getCar_st().equals("5"))	bean.setSpr_yn("2"); //업무대여-초우량
	
	
	//등록자-장기계약번호
	//bean.setReg_id	(ck_acar_id);
	bean.setReg_id		(reg_id); //20220520 변경요청서 회신 담당자
	bean.setCng_dt		(cng_dt); //20220520 변경일자
	//계약일자
	bean.setRent_dt		(rent_dt);
	//if     (bean.getRent_dt().equals("") && fee_rent_st.equals("1")) 	bean.setRent_dt(base.getRent_dt());
	//else if(bean.getRent_dt().equals("") && !fee_rent_st.equals("1"))	bean.setRent_dt(fees.getRent_dt());

	
	bean.setAgree_dist		(request.getParameter("new_agree_dist")==null?0 :AddUtil.parseDigit(request.getParameter("new_agree_dist")));
	bean.setB_agree_dist	(request.getParameter("b_agree_dist")==null?0 :AddUtil.parseDigit(request.getParameter("b_agree_dist")));
	bean.setB_o_13			(request.getParameter("b_o_13")==null?0:AddUtil.parseFloat(request.getParameter("b_o_13")));
	bean.setLoc_st			(request.getParameter("loc_st")==null?"":request.getParameter("loc_st"));
	bean.setTint_b_yn		(request.getParameter("tint_b_yn")==null?"":request.getParameter("tint_b_yn"));
	bean.setTint_s_yn		(request.getParameter("tint_s_yn")==null?"":request.getParameter("tint_s_yn"));
	bean.setTint_n_yn		(request.getParameter("tint_n_yn")==null?"":request.getParameter("tint_n_yn"));
	bean.setTint_bn_yn		(request.getParameter("tint_bn_yn")==null?"":request.getParameter("tint_bn_yn"));
	bean.setNew_license_plate		(request.getParameter("new_license_plate")==null?"":request.getParameter("new_license_plate")); // 신형번호판신청

	bean.setTint_cons_yn		(request.getParameter("tint_cons_yn")==null?"":request.getParameter("tint_cons_yn")); // 추가탁송료
	bean.setTint_cons_amt	(request.getParameter("tint_cons_amt")==null? 0:AddUtil.parseDigit(request.getParameter("tint_cons_amt"))); // 추가탁송료

	bean.setTint_eb_yn	(request.getParameter("tint_eb_yn")==null?"":request.getParameter("tint_eb_yn"));
	bean.setEcar_loc_st	(request.getParameter("ecar_loc_st")==null?"":request.getParameter("ecar_loc_st"));
	bean.setEco_e_tag		(request.getParameter("eco_e_tag")==null?"":request.getParameter("eco_e_tag"));
	bean.setHcar_loc_st	(request.getParameter("hcar_loc_st")==null?"":request.getParameter("hcar_loc_st"));
		
	bean.setTint_ps_yn	(request.getParameter("tint_ps_yn")	==null?"":request.getParameter("tint_ps_yn"));	// 고급썬팅 유무	2017.12.22
	bean.setTint_ps_nm	(request.getParameter("tint_ps_nm")	==null?"":request.getParameter("tint_ps_nm"));	// 고급썬팅 내용
	bean.setTint_ps_amt	(request.getParameter("tint_ps_amt")==null? 0:AddUtil.parseDigit(request.getParameter("tint_ps_amt")));	// 고급썬팅 금액
	
	bean.setReturn_select		(request.getParameter("return_select")==null?"":request.getParameter("return_select"));
	bean.setEcar_pur_sub_yn	(request.getParameter("ecar_pur_sub_yn")==null?"":request.getParameter("ecar_pur_sub_yn"));
	
	bean.setEst_from	(est_from);
	bean.setUdt_st		(udt_st);		
	bean.setOne_self	(one_self);
	
	bean.setBr_to_st(br_to_st);
	bean.setBr_to(br_to);
	bean.setBr_from(br_from);
	
	
	String reg_code  = Long.toString(System.currentTimeMillis());
	
	bean.setReg_code	(reg_code);
	bean.setRent_mng_id	(rent_mng_id);
	bean.setRent_l_cd	(rent_l_cd);
	bean.setRent_st		(fee_rent_st);
	bean.setIns_per		(insur_per);
	bean.setInsurant	(insurant);
	bean.setMgr_ssn		("1");	
	
	
	
	int esti_idx = 3;
	
	
	
	
	String est_id[]	 		= new String[esti_idx];
	
	float cls_a_b = AddUtil.parseFloat(bean.getA_b())/36*em_bean.getAx_p();
	
	//20140912 계약기간의 절반으로
	if(AddUtil.parseInt(bean.getRent_dt()) >= 20140912){
		cls_a_b = AddUtil.parseFloat(bean.getA_b())/2;	
	}
	
	for(int i = 0 ; i < esti_idx ; i++){
		EstimateBean a_bean = new EstimateBean();
		
		a_bean = bean;
		
		//견적구분&대여개월&약정주행거리
		if(i==0){
			a_bean.setJob("org");
			a_bean.setA_b(request.getParameter("con_mon")==null?"":request.getParameter("con_mon"));
		}else if(i==1){
			a_bean.setJob("cls");
			a_bean.setA_b(AddUtil.parseFloatCipher2(cls_a_b,0));
			
		}else if(i==2){
			a_bean.setJob("base");
			a_bean.setA_b(request.getParameter("con_mon")==null?"":request.getParameter("con_mon"));
			a_bean.setAgree_dist(0);
		}
		
		
		//견적관리번호 생성
		est_id[i] = Long.toString(System.currentTimeMillis())+""+String.valueOf(i);
		
		//fms2에서 견적함.
		if(AddUtil.lengthb(est_id[i]) < 15)	est_id[i] = est_id[i]+""+"2";
		
		a_bean.setEst_type		("L");
		
		/*고객정보*/
		a_bean.setEst_id		(est_id[i]);
		
		//등록자
		a_bean.setTalk_tel		(ck_acar_id);
		
		
	

		
		count = e_db.insertEstimate(a_bean);
		
		
		
	} 
	
	
			//권용식과장에게 메시지 발송
	
			//쿨메신저 메세지 전송------------------------------------------------------------------------------------------
			
			String sub 		= "신차개시후 약정거리 변경";
			String cont 	= "[ "+rent_l_cd+" "+request.getParameter("car_no")+" "+client.getFirm_nm()+" ]  &lt;br&gt; &lt;br&gt; 신차개시후 약정거리 변경("+agree_dist+"km)이 실행되었습니다.";
			String target_id = nm_db.getWorkAuthUser("엑셀견적관리자");
						
			String xml_data = "";
			xml_data =  "<COOLMSG>"+
		  				"<ALERTMSG>"+
  						"    <BACKIMG>4</BACKIMG>"+
  						"    <MSGTYPE>104</MSGTYPE>"+
  						"    <SUB>"+sub+"</SUB>"+
		  				"    <CONT>"+cont+"</CONT>"+
 						"    <URL></URL>";
			
			xml_data += "    <TARGET>"+umd.getSenderId(target_id)+"</TARGET>";			
			xml_data += "    <SENDER>"+umd.getSenderId(ck_acar_id)+"</SENDER>";
			
			xml_data += "    <MSGICON>10</MSGICON>"+
  						"    <MSGSAVE>1</MSGSAVE>"+
  						"    <LEAVEDMSG>1</LEAVEDMSG>"+
		  				"    <FLDTYPE>1</FLDTYPE>"+
  						"  </ALERTMSG>"+
  						"</COOLMSG>";
			
			CdAlertBean msg = new CdAlertBean();
			msg.setFlddata(xml_data);
			msg.setFldtype("1");
			
			if(!ck_acar_id.equals("000029")){			
				boolean flag12 = cm_db.insertCoolMsg(msg);
			}	
	
	
	
%>
<html>
<head>

<title>FMS</title>
<meta http-equiv="content-type" content="text/html; charset=euc-kr">
<link rel="stylesheet" type="text/css" href="/include/table.css"></link>
<script language='JavaScript' src='/include/common.js'></script>
<script language="JavaScript">
<!--
//-->
</script>
</head>
<body>
<form action="" name="form1" method="POST">
  <input type="hidden" name="a_e" value="<%=s_st%>">
  <input type="hidden" name="from_page" value="car_rent">
  <input type="hidden" name="from_page2" value="<%=from_page2%>">
  <input type="hidden" name="cmd" value="u">
  <input type="hidden" name="e_page" value="i">  
  <input type="hidden" name="rent_dt" value="<%=rent_dt%>">    
  <input type="hidden" name="esti_stat" value="<%=esti_stat%>">      
  <input type="hidden" name="l_cd" value="<%=rent_l_cd%>">      
  <input type="hidden" name="m_id" value="<%=rent_mng_id%>">      
  <input type="hidden" name="car_mng_id" value="<%=car_mng_id%>">
  <input type="hidden" name="rent_st" value="1">  
  <input type="hidden" name="fee_rent_st" value="<%=rent_st%>">    
  <input type="hidden" name="est_from" value="<%=est_from%>">  
  <input type="hidden" name="insur_per" value="<%=insur_per%>">  
  <input type="hidden" name="insurant" value="<%=insurant%>">  
  <input type="hidden" name="one_self" value="<%=one_self%>">   
  <input type="hidden" name="action_st" value="<%=action_st%>">	 
  <input type="hidden" name="esti_table" value="estimate">       
  <input type="hidden" name="car_st" value="<%=base.getCar_st()%>">    
  <input type="hidden" name="reg_code" value="<%=reg_code%>">
  <input type="hidden" name="ctr_s_amt" value="<%=ctr_s_amt%>">
  <input type="hidden" name="ctr_v_amt" value="<%=ctr_v_amt%>">
  <input type="hidden" name="cng_dt" value="<%=cng_dt%>">
  <input type="hidden" name="reg_id" value="<%=reg_id%>">
      
  <%for(int i = 0 ; i < esti_idx ; i++){%>   
  <input type="hidden" name="est_id" value="<%=est_id[i]%>">          
  <%}%>       
</form>
<script>

<%	if(count==1){%>
		//신차 견적프로그램 이동
		document.form1.action = "/acar/estimate_mng/sp_esti_reg_re_case.jsp"; 
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

