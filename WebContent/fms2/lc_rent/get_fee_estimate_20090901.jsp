<%@ page language="java" contentType="text/html; charset=euc-kr" %>
<%@ page import="java.util.*, java.io.*, acar.util.*, acar.estimate_mng.*, acar.car_mst.*" %>
<%@ page import="acar.con_ins.*,acar.cont.*,acar.client.*, acar.car_register.*, acar.user_mng.*" %>
<jsp:useBean id="em_bean" class="acar.estimate_mng.EstiCommVarBean" scope="page"/>
<jsp:useBean id="ej_bean" class="acar.estimate_mng.EstiJgVarBean" scope="page"/>
<jsp:useBean id="cm_bean" class="acar.car_mst.CarMstBean" scope="page"/>
<jsp:useBean id="a_db" scope="page" class="acar.cont.AddContDatabase"/>
<jsp:useBean id="ai_db" scope="page" class="acar.con_ins.AddInsurDatabase"/>
<jsp:useBean id="al_db" scope="page" class="acar.client.AddClientDatabase"/>
<jsp:useBean id="af_db" scope="page" class="acar.fee.AddFeeDatabase"/>
<jsp:useBean id="shDb" class="acar.secondhand.SecondhandDatabase" scope="page"/>
<jsp:useBean id="cr_bean"   class="acar.car_register.CarRegBean"       scope="page"/>
<%@ include file="/acar/cookies.jsp" %>

<%
	int o_1 		= request.getParameter("o_1")			==null?0:AddUtil.parseDigit(request.getParameter("o_1"));
	int grt_amt 		= request.getParameter("grt_s_amt")		==null?0:AddUtil.parseDigit(request.getParameter("grt_s_amt"));
	int pp_amt 		= request.getParameter("pp_amt")		==null?0:AddUtil.parseDigit(request.getParameter("pp_amt"));
	int t_ifee_s_amt 	= request.getParameter("ifee_s_amt")		==null?0:AddUtil.parseDigit(request.getParameter("ifee_s_amt"));
	int t_fee_s_amt 	= request.getParameter("fee_s_amt")		==null?0:AddUtil.parseDigit(request.getParameter("fee_s_amt"));
	int add_opt_amt		= request.getParameter("add_opt_amt")		==null?0:AddUtil.parseDigit(request.getParameter("add_opt_amt"));
	int agree_dist		= request.getParameter("agree_dist")		==null?0:AddUtil.parseDigit(request.getParameter("agree_dist"));
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
	String est_from 	= request.getParameter("est_from")		==null?"car_rent":request.getParameter("est_from");
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
	
	String est_rent_dt		= request.getParameter("est_rent_dt")	==null?"":request.getParameter("est_rent_dt");
	
	
		
	int count = 0;
	boolean flag3 = true;
	boolean flag4 = true;
	
	//위약금면제 무시
	cls_n_mon = 0;	
	
	EstiDatabase 		e_db 	= EstiDatabase.getInstance();
	AddCarMstDatabase 	a_cmb 	= AddCarMstDatabase.getInstance();
	CarRegDatabase crd 	= CarRegDatabase.getInstance();	
	MaMenuDatabase nm_db = MaMenuDatabase.getInstance();
	
	//보험정보
	String ins_st = ai_db.getInsSt(car_mng_id);
	acar.con_ins.InsurBean ins = ai_db.getIns(car_mng_id, ins_st);
	
	//계약기본정보
	ContBaseBean base = a_db.getCont(rent_mng_id, rent_l_cd);
	
	
	if(rent_dt.equals("")) rent_dt = base.getRent_dt();
	


	//견적기준일 변경권한자만
	if(!est_rent_dt.equals("") && est_rent_dt.length()>=8) rent_dt = AddUtil.replace(est_rent_dt,"-","");
		
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
	
	if(!fee_rent_dt.equals("")){
		rent_dt = fee_rent_dt;
	}
	
	if(!fee_rent_st.equals("1") && !ext_rent_dt.equals("")){
	 	rent_dt = ext_rent_dt;
	}	
	
	if(rent_st.equals("1") && AddUtil.parseInt(base.getReg_dt()) >= 20220622){
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
	bean.setTop_cng_yn	(cont_etc.getTop_cng_yn());		// 탑차(구조변경)
	
	/* if (!bean.getOpt_seq().equals("")) {
		String temp_opt_seq = bean.getOpt_seq();
		String[] split_opt_seq = temp_opt_seq.split("(?<=\\G.{" + 2 + "})"); // 2글자마다 잘라내어 배열 생성
		for (int i=0; i<split_opt_seq.length; i++) {		
			System.out.println(split_opt_seq[i]);
		}
		
		StringBuilder b = new StringBuilder(bean.getOpt_seq());
		for (int i = b.length()-1; i > 0; i--) {
			if (i%2==0) {
				b.insert(i, "|");
			}
		}
		
		String test = b.toString();
		System.out.println(test);
	} */
	
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
	String ro_13 = request.getParameter("ro_13")==null?"0":request.getParameter("ro_13");
	if(ro_13.equals("NaN")) ro_13 = "0";
	bean.setRo_13		(AddUtil.parseFloat(ro_13));
	bean.setO_13		(AddUtil.parseFloat(request.getParameter("o_13")==null?"0":request.getParameter("o_13")));
	
	//적용잔가금액
	int opt_amt = request.getParameter("o_13_amt")==null?0:AddUtil.parseDigit(request.getParameter("o_13_amt"));
	bean.setRo_13_amt	(opt_amt);
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
	bean.setReg_id		(ck_acar_id);
	//계약일자
	bean.setRent_dt		(rent_dt);
	if     (bean.getRent_dt().equals("") && fee_rent_st.equals("1")) 	bean.setRent_dt(base.getRent_dt());
	else if(bean.getRent_dt().equals("") && !fee_rent_st.equals("1"))	bean.setRent_dt(fees.getRent_dt());
	//연장계약
	if(!fee_rent_st.equals("1")){
		bean.setRent_dt		(rent_start_dt);
		rent_dt = rent_start_dt;
		bean.setO_11	(0);
	}
	//연장계약
	if(est_from.equals("lc_renew")){
		bean.setRent_dt		(rent_start_dt);
		rent_dt = rent_start_dt;
		bean.setO_11	(0);
	}
	
	//재리스견적
	if(car_gu.equals("0")){
		bean.setEst_st("1");
		bean.setMgr_nm		(car_mng_id);
		bean.setSpe_dc_per	(cr_bean.getSpe_dc_per());
	}	
	//중고차리스
	if(car_gu.equals("2")){
		bean.setEst_st("3");
		bean.setMgr_nm	(car_mng_id);
	}
	//연장계약
	if(!fee_rent_st.equals("1")){
		bean.setEst_st("2");
	}
	//연장계약
	if(est_from.equals("lc_renew")){
		bean.setEst_st("2");
	}
	//업무대여
	if(base.getCar_st().equals("5")){
		bean.setEst_st("4");
	}
	
	
	
	bean.setAgree_dist	(request.getParameter("agree_dist")==null?0 :AddUtil.parseDigit(request.getParameter("agree_dist")));
	bean.setB_agree_dist(request.getParameter("e_agree_dist")==null?0 :AddUtil.parseDigit(request.getParameter("e_agree_dist")));
	bean.setB_o_13			(request.getParameter("b_o_13")==null?0:AddUtil.parseFloat(request.getParameter("b_o_13")));
	bean.setLoc_st			(request.getParameter("loc_st")==null?"":request.getParameter("loc_st"));
	bean.setTint_b_yn		(request.getParameter("tint_b_yn")==null?"":request.getParameter("tint_b_yn"));
	bean.setTint_s_yn		(request.getParameter("tint_s_yn")==null?"":request.getParameter("tint_s_yn"));
	bean.setTint_n_yn		(request.getParameter("tint_n_yn")==null?"":request.getParameter("tint_n_yn"));
	bean.setTint_bn_yn		(request.getParameter("tint_bn_yn")==null?"":request.getParameter("tint_bn_yn"));
	bean.setTint_sn_yn		(request.getParameter("tint_sn_yn")==null?"":request.getParameter("tint_sn_yn"));
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
	bean.setRtn_run_amt_yn(request.getParameter("rtn_run_amt_yn")==null?"":request.getParameter("rtn_run_amt_yn"));	
	
	bean.setEst_from	(est_from);
	bean.setUdt_st		(udt_st);		
	bean.setOne_self	(one_self);
	
	bean.setBr_to_st(br_to_st);
	bean.setBr_to(br_to);
	bean.setBr_from(br_from);
	
	//20141223 신차는 약정운행거리 이미 계산 : 재리스는 종전방식에 일반식은 기본식과 같게..
	if(AddUtil.parseInt(bean.getRent_dt()) < 20150217 && bean.getEst_st().equals("1")){
	
		if(agree_dist == 0 && agree_dist_yn.equals("N")){
			if(ej_bean.getJg_s().equals("1")){//무제한견적가능
				bean.setAgree_dist	(r_max_agree_dist);
			}else{
				bean.setAgree_dist	(max_agree_dist);
			}
		}
		if(agree_dist == 0 && agree_dist_yn.equals("Y")){
			if(ej_bean.getJg_s().equals("1")){//무제한견적가능
				bean.setAgree_dist	(r_max_agree_dist);
			}else{
				bean.setAgree_dist	(max_agree_dist);
			}
		}
		if(agree_dist >0 && agree_dist > max_agree_dist){
			bean.setAgree_dist	(r_max_agree_dist);
		}
	
		//20090915 이후계약 약정주행거리 취소
		if(AddUtil.parseInt(bean.getRent_dt()) > 20090914){
			bean.setAgree_dist	(0);
		}
	
		//20130605 이후계약 약정주행거리 시작
		if(AddUtil.parseInt(bean.getRent_dt()) > 20130604){
			bean.setAgree_dist	(60000);
		}
	
		//20140603 약정운행거리
		if(AddUtil.parseInt(bean.getRent_dt()) > 20140602){
			bean.setAgree_dist(45000);
			//일반식 +5000
			if(bean.getA_a().equals("11") || bean.getA_a().equals("21")){
				bean.setAgree_dist(bean.getAgree_dist()+5000);
			}
			//엔진 가솔린 -5000
			if(ej_bean.getJg_b().equals("0")){
				bean.setAgree_dist(bean.getAgree_dist()-5000);
			}
			//수입 디젤 -5000
			if(ej_bean.getJg_w().equals("1") && ej_bean.getJg_b().equals("1")){
				bean.setAgree_dist(bean.getAgree_dist()-5000);
			}
		}	
	
		//20140725 약정운행거리
		if(AddUtil.parseInt(bean.getRent_dt()) > 20140724){
			bean.setAgree_dist(40000);
			//국산 디젤 +5000
			if(!ej_bean.getJg_w().equals("1") && ej_bean.getJg_b().equals("1")){
				bean.setAgree_dist(bean.getAgree_dist()+5000);
			}				
			//LPG +5000
			if(ej_bean.getJg_b().equals("2")){
				bean.setAgree_dist(bean.getAgree_dist()+5000);
			}		
			//20141223 기본식과 일반식 약정운행거리를 같게한다.
			if(AddUtil.parseInt(bean.getRent_dt()) < 20141223){	
				//일반식 +5000
				if(bean.getA_a().equals("11") || bean.getA_a().equals("21")){
					bean.setAgree_dist(bean.getAgree_dist()+5000);
				}				
			}
		}				
	}
	
	
	String reg_code  = Long.toString(System.currentTimeMillis());
	
	bean.setReg_code	(reg_code);
	bean.setRent_mng_id	(rent_mng_id);
	bean.setRent_l_cd	(rent_l_cd);
	bean.setRent_st		(fee_rent_st);
	bean.setIns_per		(insur_per);
	bean.setInsurant	(insurant);
	bean.setMgr_ssn		("1");	
	
	int esti_idx = 3;
	
	if(est_from.equals("lc_renew") || car_gu.equals("0") || car_gu.equals("2")){//재리스견적
		esti_idx = 1;
		bean.setMgr_ssn		("0");
		//메이커DC없다.
		bean.setDc_amt		(0);
		bean.setToday_dist	(sh_km);
	}
	
	
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
		
		
		//20150512 재리스/연장 견적은 사고수리비 반영		
		if(AddUtil.parseInt(a_bean.getRent_dt()) >= 20150512){
			if(a_bean.getEst_st().equals("2") || est_from.equals("lc_renew") || car_gu.equals("0") || car_gu.equals("2")){
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
			if(a_bean.getEst_st().equals("2") || est_from.equals("lc_renew") || car_gu.equals("0") || car_gu.equals("2")){
				//차량정보
				Hashtable ht2 = shDb.getBase(base.getCar_mng_id(), a_bean.getRent_dt(), "");				
				a_bean.setCha_st_dt	(String.valueOf(ht2.get("CHA_ST_DT"))==null?"":String.valueOf(ht2.get("CHA_ST_DT")));
				a_bean.setB_dist	(String.valueOf(ht2.get("B_DIST"))==null?0 :AddUtil.parseDigit(String.valueOf(ht2.get("B_DIST"))));
			}
		}		

		
		count = e_db.insertEstimate(a_bean);
		
		
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
  <input type="hidden" name="rent_st" value="">  
  <input type="hidden" name="fee_rent_st" value="<%=rent_st%>">    
  <input type="hidden" name="est_from" value="<%=est_from%>">  
  <input type="hidden" name="insur_per" value="<%=insur_per%>">  
  <input type="hidden" name="insurant" value="<%=insurant%>">  
  <input type="hidden" name="one_self" value="<%=one_self%>">   
  <input type="hidden" name="action_st" value="<%=action_st%>">	 
  <input type="hidden" name="esti_table" value="estimate">       
  <input type="hidden" name="car_st" value="<%=base.getCar_st()%>">    
  <input type="hidden" name="reg_code" value="<%=reg_code%>">    
  <%for(int i = 0 ; i < esti_idx ; i++){%>   
  <input type="hidden" name="est_id" value="<%=est_id[i]%>">          
  <%}%>       
</form>
<script>

<%	if(count==1){%>

		
		<%if(est_from.equals("lc_renew") || car_gu.equals("0") || car_gu.equals("2")){//재리스견적%>
	
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

