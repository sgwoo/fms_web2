<%@ page language="java" contentType="text/html;charset=euc-kr" %>
<%@ page import="java.util.*, acar.common.*, acar.util.*, acar.coolmsg.*, acar.user_mng.*"%>
<%@ page import="acar.cont.*, acar.car_mst.*, acar.car_office.*, acar.res_search.*,  acar.ext.*, acar.client.*, acar.car_sche.*, acar.estimate_mng.*"%>
<jsp:useBean id="cm_db" scope="page" class="acar.coolmsg.CoolMsgDatabase"/>
<jsp:useBean id="a_db" scope="page" class="acar.cont.AddContDatabase"/>
<jsp:useBean id="ae_db" scope="page" class="acar.ext.AddExtDatabase"/>
<jsp:useBean id="cm_bean" scope="page" class="acar.car_mst.CarMstBean"/>
<jsp:useBean id="rs_db" scope="page" class="acar.res_search.ResSearchDatabase"/>
<jsp:useBean id="coe_bean" scope="page" class="acar.car_office.CarOffEmpBean"/>
<jsp:useBean id="coh_bean" scope="page" class="acar.car_office.CarOffEdhBean"/>
<jsp:useBean id="al_db" scope="page" class="acar.client.AddClientDatabase"/>
<jsp:useBean id="ej_bean" class="acar.estimate_mng.EstiJgVarBean" scope="page"/>
<jsp:useBean id="ad_db" scope="page" class="acar.admin.AdminDatabase"/>

<%@ include file="/agent/cookies.jsp" %>

<html>
<head>
<title>FMS</title>
</head>
<body leftmargin="15">
<%
	String auth_rw 		= request.getParameter("auth_rw")==null?""        :request.getParameter("auth_rw");
	String user_id 		= request.getParameter("user_id")==null?ck_acar_id:request.getParameter("user_id");
	String br_id 		= request.getParameter("br_id")  ==null?acar_br   :request.getParameter("br_id");
	
	String rent_mng_id 	= request.getParameter("rent_mng_id")==null?"":request.getParameter("rent_mng_id");
	String rent_l_cd 	= request.getParameter("rent_l_cd")==null?"":request.getParameter("rent_l_cd");
	
	String car_gu 		= request.getParameter("car_gu")==null?"1":request.getParameter("car_gu");//신차1,기존0
	String car_st 		= request.getParameter("car_st")==null?"":request.getParameter("car_st");
	
	String firm_nm	= request.getParameter("firm_nm")==null?"":request.getParameter("firm_nm");
	
	boolean flag1 = true;
	boolean flag2 = true;
	boolean flag3 = true;
	boolean flag4 = true;
	boolean flag5 = true;
	boolean flag6 = true;
	boolean flag7 = true;
	boolean flag8 = true;
	boolean flag9 = true;
	boolean flag10 = true;
	boolean flag11 = true;
	boolean flag12 = true;
	
	CommonDataBase c_db = CommonDataBase.getInstance();
	MaMenuDatabase nm_db = MaMenuDatabase.getInstance();
	UserMngDatabase umd = UserMngDatabase.getInstance();
	AddCarMstDatabase cmb = AddCarMstDatabase.getInstance();
	EstiDatabase e_db = EstiDatabase.getInstance();
	CarSchDatabase csd = CarSchDatabase.getInstance();
	
	//cont
	ContBaseBean base = a_db.getCont(rent_mng_id, rent_l_cd);
	


	//차량기본정보-----------------------------------------------------------------------------------------------
	
	//car_etc
	ContCarBean car 	= a_db.getContCarNew(rent_mng_id, rent_l_cd);
	
	//자동차기본정보
	cm_bean = cmb.getCarNmCase(String.valueOf(car.getCar_id()), String.valueOf(car.getCar_seq()));
	
	//차종변수
	ej_bean = e_db.getEstiJgVarCase(cm_bean.getJg_code(), "");
	
	
	car.setCar_cs_amt	(request.getParameter("car_cs_amt")	==null? 0:AddUtil.parseDigit(request.getParameter("car_cs_amt")));
	car.setCar_cv_amt	(request.getParameter("car_cv_amt")	==null? 0:AddUtil.parseDigit(request.getParameter("car_cv_amt")));
	car.setCar_fs_amt	(request.getParameter("car_fs_amt")	==null? 0:AddUtil.parseDigit(request.getParameter("car_fs_amt")));
	car.setCar_fv_amt	(request.getParameter("car_fv_amt")	==null? 0:AddUtil.parseDigit(request.getParameter("car_fv_amt")));
	car.setOpt_cs_amt	(request.getParameter("opt_cs_amt")	==null? 0:AddUtil.parseDigit(request.getParameter("opt_cs_amt")));
	car.setOpt_cv_amt	(request.getParameter("opt_cv_amt")	==null? 0:AddUtil.parseDigit(request.getParameter("opt_cv_amt")));
	car.setOpt_amt_m	(request.getParameter("opt_amt_m")	==null? 0:AddUtil.parseDigit(request.getParameter("opt_amt_m")));
	car.setClr_cs_amt	(request.getParameter("col_cs_amt")	==null? 0:AddUtil.parseDigit(request.getParameter("col_cs_amt")));
	car.setClr_cv_amt	(request.getParameter("col_cv_amt")	==null? 0:AddUtil.parseDigit(request.getParameter("col_cv_amt")));
	car.setSd_cs_amt	(request.getParameter("sd_cs_amt")	==null? 0:AddUtil.parseDigit(request.getParameter("sd_cs_amt")));
	car.setSd_cv_amt	(request.getParameter("sd_cv_amt")	==null? 0:AddUtil.parseDigit(request.getParameter("sd_cv_amt")));
	car.setSd_fs_amt	(request.getParameter("sd_cs_amt")	==null? 0:AddUtil.parseDigit(request.getParameter("sd_cs_amt")));
	car.setSd_fv_amt	(request.getParameter("sd_cv_amt")	==null? 0:AddUtil.parseDigit(request.getParameter("sd_cv_amt")));
	car.setDc_cs_amt	(request.getParameter("dc_cs_amt")	==null? 0:AddUtil.parseDigit(request.getParameter("dc_cs_amt")));
	car.setDc_cv_amt	(request.getParameter("dc_cv_amt")	==null? 0:AddUtil.parseDigit(request.getParameter("dc_cv_amt")));
	car.setS_dc1_amt	(request.getParameter("s_dc1_amt")	==null? 0:AddUtil.parseDigit(request.getParameter("s_dc1_amt")));
	car.setS_dc2_amt	(request.getParameter("s_dc2_amt")	==null? 0:AddUtil.parseDigit(request.getParameter("s_dc2_amt")));
	car.setS_dc3_amt	(request.getParameter("s_dc3_amt")	==null? 0:AddUtil.parseDigit(request.getParameter("s_dc3_amt")));
	car.setPay_st		(request.getParameter("pay_st")		==null?"":request.getParameter("pay_st"));
	car.setSpe_tax		(request.getParameter("spe_tax")	==null? 0:AddUtil.parseDigit(request.getParameter("spe_tax")));
	car.setEdu_tax		(request.getParameter("edu_tax")	==null? 0:AddUtil.parseDigit(request.getParameter("edu_tax")));
	car.setS_dc1_re		(request.getParameter("s_dc1_re")	==null?"":request.getParameter("s_dc1_re"));
	car.setS_dc2_re		(request.getParameter("s_dc2_re")	==null?"":request.getParameter("s_dc2_re"));
	car.setS_dc3_re		(request.getParameter("s_dc3_re")	==null?"":request.getParameter("s_dc3_re"));
	car.setS_dc1_yn		(request.getParameter("s_dc1_yn")	==null?"":request.getParameter("s_dc1_yn"));
	car.setS_dc2_yn		(request.getParameter("s_dc2_yn")	==null?"":request.getParameter("s_dc2_yn"));
	car.setS_dc3_yn		(request.getParameter("s_dc3_yn")	==null?"":request.getParameter("s_dc3_yn"));
	car.setS_dc1_re_etc	(request.getParameter("s_dc1_re_etc")==null?"":request.getParameter("s_dc1_re_etc"));
	car.setS_dc2_re_etc	(request.getParameter("s_dc2_re_etc")==null?"":request.getParameter("s_dc2_re_etc"));
	car.setS_dc3_re_etc	(request.getParameter("s_dc3_re_etc")==null?"":request.getParameter("s_dc3_re_etc"));
	car.setS_dc1_per	(request.getParameter("s_dc1_per")	==null? 0:AddUtil.parseFloat(request.getParameter("s_dc1_per")));
	car.setS_dc2_per	(request.getParameter("s_dc2_per")	==null? 0:AddUtil.parseFloat(request.getParameter("s_dc2_per")));
	car.setS_dc3_per	(request.getParameter("s_dc3_per")	==null? 0:AddUtil.parseFloat(request.getParameter("s_dc3_per")));
	car.setColo		(request.getParameter("color")			==null?"":request.getParameter("color"));
	car.setCar_ext		(request.getParameter("car_ext")		==null?"":request.getParameter("car_ext"));
	car.setSun_per		(request.getParameter("sun_per")		==null? 0:AddUtil.parseDigit(request.getParameter("sun_per")));
	car.setLpg_yn		(request.getParameter("lpg_yn")			==null?"":request.getParameter("lpg_yn"));
	car.setLpg_setter	(request.getParameter("lpg_setter")		==null?"":request.getParameter("lpg_setter"));
	car.setLpg_kit		(request.getParameter("lpg_kit")		==null?"":request.getParameter("lpg_kit"));
	car.setLpg_price	(request.getParameter("lpg_price")		==null? 0:AddUtil.parseDigit(request.getParameter("lpg_price")));
	car.setAdd_opt		(request.getParameter("add_opt")		==null?"":request.getParameter("add_opt"));
	car.setAdd_opt_amt	(request.getParameter("add_opt_amt")	==null? 0:AddUtil.parseDigit(request.getParameter("add_opt_amt")));
	car.setPurc_gu		(request.getParameter("purc_gu")		==null?"":request.getParameter("purc_gu"));
	car.setRemark		(request.getParameter("remark")			==null?"":request.getParameter("remark"));
	car.setImm_amt		(request.getParameter("imm_amt")		==null? 0:AddUtil.parseDigit(request.getParameter("imm_amt")));
	car.setGi_st		(request.getParameter("gi_st")			==null?"":request.getParameter("gi_st"));
	car.setCar_origin	(request.getParameter("car_origin")		==null?"":request.getParameter("car_origin"));
	car.setExtra_set	(request.getParameter("extra_set")		==null?"":request.getParameter("extra_set"));
	car.setExtra_amt	(request.getParameter("extra_amt")		==null? 0:AddUtil.parseDigit(request.getParameter("extra_amt")));
	car.setIn_col		(request.getParameter("in_col")			==null?"":request.getParameter("in_col"));
	car.setGarnish_col		(request.getParameter("garnish_col")			==null?"":request.getParameter("garnish_col"));
	car.setHipass_yn	(request.getParameter("hipass_yn")		==null?"":request.getParameter("hipass_yn"));
	car.setBluelink_yn	(request.getParameter("bluelink_yn")		==null?"":request.getParameter("bluelink_yn"));
	car.setImport_card_amt	(request.getParameter("import_card_amt")	==null? 0:AddUtil.parseDigit(request.getParameter("import_card_amt")));
	car.setImport_cash_back	(request.getParameter("import_cash_back")	==null? 0:AddUtil.parseDigit(request.getParameter("import_cash_back")));
	car.setTint_b_yn	(request.getParameter("tint_b_yn")		==null?"":request.getParameter("tint_b_yn"));
	car.setTint_s_yn	(request.getParameter("tint_s_yn")		==null?"":request.getParameter("tint_s_yn"));
	car.setTint_ps_yn	(request.getParameter("tint_ps_yn")		==null?"":request.getParameter("tint_ps_yn"));	// 고급썬팅 유무	2017.12.26
	car.setTint_ps_nm	(request.getParameter("tint_ps_nm")	==null?"":request.getParameter("tint_ps_nm"));	// 고급썬팅 내용
	car.setTint_ps_amt(request.getParameter("tint_ps_amt")	==null? 0:AddUtil.parseDigit(request.getParameter("tint_ps_amt")));	// 고급썬팅 금액
	car.setTint_n_yn	(request.getParameter("tint_n_yn")		==null?"":request.getParameter("tint_n_yn"));
	car.setTint_bn_yn	(request.getParameter("tint_bn_yn")		==null?"":request.getParameter("tint_bn_yn"));
	car.setTint_bn_nm	(request.getParameter("tint_bn_nm")		==null?"":request.getParameter("tint_bn_nm"));
	car.setTint_sn_yn		(request.getParameter("tint_sn_yn")		==null?"":request.getParameter("tint_sn_yn")); // 전면썬팅 미시공 할인
	car.setNew_license_plate		(request.getParameter("new_license_plate")		==null?"":request.getParameter("new_license_plate"));
	car.setTint_cons_yn		(request.getParameter("tint_cons_yn")		==null?"":request.getParameter("tint_cons_yn"));
	car.setTint_cons_amt	(request.getParameter("tint_cons_amt")	==null? 0:AddUtil.parseDigit(request.getParameter("tint_cons_amt")));
	car.setTint_eb_yn	(request.getParameter("tint_eb_yn")		==null?"":request.getParameter("tint_eb_yn"));
	car.setTint_s_per	(request.getParameter("tint_s_per")		==null? 0:AddUtil.parseDigit(request.getParameter("tint_s_per")));
	car.setServ_b_yn	(request.getParameter("serv_b_yn")		==null?"":request.getParameter("serv_b_yn"));
	car.setServ_sc_yn	(request.getParameter("serv_sc_yn")		==null?"":request.getParameter("serv_sc_yn"));
	car.setTax_dc_s_amt	(request.getParameter("tax_dc_s_amt")	==null? 0:AddUtil.parseDigit(request.getParameter("tax_dc_s_amt")));
	car.setTax_dc_v_amt	(request.getParameter("tax_dc_v_amt")	==null? 0:AddUtil.parseDigit(request.getParameter("tax_dc_v_amt")));
	car.setEcar_pur_sub_amt	(request.getParameter("h_ecar_pur_sub_amt")	==null? 0:AddUtil.parseDigit(request.getParameter("h_ecar_pur_sub_amt")));
	car.setEcar_pur_sub_st	(request.getParameter("h_ecar_pur_sub_st")==null?"":request.getParameter("h_ecar_pur_sub_st"));
	car.setEco_e_tag	(request.getParameter("eco_e_tag")		==null?"":request.getParameter("eco_e_tag"));	
	
	//전기차&수소차가 아니면 인천 : 20190701 수소차는 인천
	if(!ej_bean.getJg_g_7().equals("3") && car_gu.equals("1")){		
		if (ej_bean.getJg_g_7().equals("4")) {
			car.setCar_ext	("7");			
		} else {
			car.setCar_ext	("7");			
		}
	}
	//친환경차(연료종류) 맑은서울스티커 발급은 서울등록
	if((ej_bean.getJg_b().equals("3") || ej_bean.getJg_b().equals("4") || ej_bean.getJg_b().equals("5") || ej_bean.getJg_b().equals("6")) && car_gu.equals("1")){
		if(car.getEco_e_tag().equals("1")){
			car.setCar_ext	("1");
		}
	}

		
	//=====[car_etc] update=====
	flag1 = a_db.updateContCarNew(car);
	
	
	if(car_gu.equals("1") && car.getEcar_pur_sub_amt()>0 && car.getEcar_pur_sub_st().equals("2")){
		//친환경차 구매보조금
		ExtScdBean ecar_pur = ae_db.getAGrtScd(rent_mng_id, rent_l_cd, "1", "7", "1");//기존 등록 여부 조회
		int ecar_pur_gbn = 1;	//기존
		if(ecar_pur == null || ecar_pur.getRent_l_cd().equals("")){
			ecar_pur_gbn = 0;	//신규
			ecar_pur = new ExtScdBean();
			ecar_pur.setRent_mng_id	(rent_mng_id);
			ecar_pur.setRent_l_cd		(rent_l_cd);
			ecar_pur.setRent_st			("1");
			ecar_pur.setRent_seq		("1");
			ecar_pur.setExt_id			("0");
			ecar_pur.setExt_st			("7");
			ecar_pur.setExt_tm			("1");
		}
		ecar_pur.setExt_s_amt			(car.getEcar_pur_sub_amt());
		ecar_pur.setExt_v_amt			(0);
		ecar_pur.setExt_est_dt		("");
		ecar_pur.setUpdate_id			(user_id);
		//=====[scd_pre] update=====
		if(ecar_pur_gbn == 1)	flag6 = ae_db.updateGrt(ecar_pur);
		else									flag6 = ae_db.insertGrt(ecar_pur);			
	}	


	//계약기본정보-----------------------------------------------------------------------------------------------
	
	
	base.setDriving_ext	(request.getParameter("driving_ext")		==null?"":request.getParameter("driving_ext"));
	base.setDriving_age	(request.getParameter("driving_age")		==null?"":request.getParameter("driving_age"));
	base.setGcp_kd		(request.getParameter("gcp_kd")			==null?"":request.getParameter("gcp_kd"));
	base.setBacdt_kd	(request.getParameter("bacdt_kd")		==null?"":request.getParameter("bacdt_kd"));
	base.setCar_ja		(request.getParameter("car_ja")			==null? 0:AddUtil.parseDigit(request.getParameter("car_ja")));
	base.setTax_type	(request.getParameter("tax_type")		==null?"1":request.getParameter("tax_type"));
	base.setOthers		(request.getParameter("others")			==null?"":request.getParameter("others"));
	base.setBus_st		(request.getParameter("bus_st")			==null?"":request.getParameter("bus_st"));
	base.setReg_step	("4");
	
	
	//=====[cont] update=====
	flag2 = a_db.updateContBaseNew(base);


	//계약기타정보-----------------------------------------------------------------------------------------------
	
	//cont_etc
	ContEtcBean cont_etc = a_db.getContEtc(rent_mng_id, rent_l_cd);
	
	cont_etc.setInsur_per	(request.getParameter("insur_per")	==null?"":request.getParameter("insur_per"));
	cont_etc.setCanoisr_yn	(request.getParameter("canoisr_yn")	==null?"":request.getParameter("canoisr_yn"));
	cont_etc.setCacdt_yn	(request.getParameter("cacdt_yn")	==null?"":request.getParameter("cacdt_yn"));
	cont_etc.setEme_yn	(request.getParameter("eme_yn")		==null?"":request.getParameter("eme_yn"));
	cont_etc.setJa_reason	(request.getParameter("ja_reason")	==null?"":request.getParameter("ja_reason"));
	cont_etc.setRea_appr_id	(request.getParameter("rea_appr_id")==null?"":request.getParameter("rea_appr_id"));
	cont_etc.setAir_ds_yn	(request.getParameter("air_ds_yn")	==null?"":request.getParameter("air_ds_yn"));
	cont_etc.setAir_as_yn	(request.getParameter("air_as_yn")	==null?"":request.getParameter("air_as_yn"));
	cont_etc.setAc_dae_yn	(request.getParameter("ac_dae_yn")	==null?"":request.getParameter("ac_dae_yn"));
	cont_etc.setPro_yn	(request.getParameter("pro_yn")		==null?"":request.getParameter("pro_yn"));
	cont_etc.setCyc_yn	(request.getParameter("cyc_yn")		==null?"":request.getParameter("cyc_yn"));
	cont_etc.setMain_yn	(request.getParameter("main_yn")	==null?"":request.getParameter("main_yn"));
	cont_etc.setMa_dae_yn	(request.getParameter("ma_dae_yn")	==null?"":request.getParameter("ma_dae_yn"));
	cont_etc.setInsurant	(request.getParameter("insurant")	==null?"":request.getParameter("insurant"));	
	if(cont_etc.getInsur_per().equals("2")){
		cont_etc.setIp_insur		(request.getParameter("ip_insur")	==null?"":request.getParameter("ip_insur"));
		cont_etc.setIp_agent		(request.getParameter("ip_agent")	==null?"":request.getParameter("ip_agent"));
		cont_etc.setIp_dam		(request.getParameter("ip_dam")		==null?"":request.getParameter("ip_dam"));
		cont_etc.setIp_tel		(request.getParameter("ip_tel")		==null?"":request.getParameter("ip_tel"));
		cont_etc.setCacdt_me_amt	(request.getParameter("cacdt_me_amt")	==null?0:AddUtil.parseDigit(request.getParameter("cacdt_me_amt")));
		cont_etc.setCacdt_memin_amt	(request.getParameter("cacdt_memin_amt")==null?0:AddUtil.parseDigit(request.getParameter("cacdt_memin_amt")));
		cont_etc.setCacdt_mebase_amt	(request.getParameter("cacdt_mebase_amt")==null?0:AddUtil.parseDigit(request.getParameter("cacdt_mebase_amt")));
	}else if(cont_etc.getInsur_per().equals("1")){
		cont_etc.setIp_insur	("");
		cont_etc.setIp_agent	("");
		cont_etc.setIp_dam		("");
		cont_etc.setIp_tel		("");
	}
	cont_etc.setRec_st		(request.getParameter("rec_st")		==null?"":request.getParameter("rec_st"));
	cont_etc.setEle_tax_st	(request.getParameter("ele_tax_st")	==null?"":request.getParameter("ele_tax_st"));
	cont_etc.setTax_extra	(request.getParameter("tax_extra")	==null?"":request.getParameter("tax_extra"));
	cont_etc.setGrt_suc_m_id(request.getParameter("grt_suc_m_id")	==null?"":request.getParameter("grt_suc_m_id"));
	cont_etc.setGrt_suc_l_cd(request.getParameter("grt_suc_l_cd")	==null?"":request.getParameter("grt_suc_l_cd"));
	cont_etc.setGrt_suc_c_no(request.getParameter("grt_suc_c_no")	==null?"":request.getParameter("grt_suc_c_no"));
	cont_etc.setGrt_suc_o_amt(request.getParameter("grt_suc_o_amt")	==null? 0:AddUtil.parseDigit(request.getParameter("grt_suc_o_amt")));
	cont_etc.setGrt_suc_r_amt(request.getParameter("grt_suc_r_amt")	==null? 0:AddUtil.parseDigit(request.getParameter("grt_suc_r_amt")));
	cont_etc.setBlackbox_yn	(request.getParameter("blackbox_yn")	==null?"":request.getParameter("blackbox_yn"));
	cont_etc.setLegal_yn	(request.getParameter("legal_yn")	==null?"":request.getParameter("legal_yn"));
	cont_etc.setEv_yn		(request.getParameter("ev_yn")	==null?"":request.getParameter("ev_yn"));
	cont_etc.setLkas_yn		(request.getParameter("lkas_yn")	==null?"":request.getParameter("lkas_yn"));
	cont_etc.setLdws_yn		(request.getParameter("ldws_yn")	==null?"":request.getParameter("ldws_yn"));
	cont_etc.setAeb_yn		(request.getParameter("aeb_yn")	==null?"":request.getParameter("aeb_yn"));
	cont_etc.setFcw_yn		(request.getParameter("fcw_yn")	==null?"":request.getParameter("fcw_yn"));
	cont_etc.setHook_yn		(request.getParameter("hook_yn")	==null?"":request.getParameter("hook_yn"));
	cont_etc.setTop_cng_yn	(request.getParameter("top_cng_yn")	==null?"":request.getParameter("top_cng_yn"));
	cont_etc.setCom_emp_yn	(request.getParameter("com_emp_yn")		==null?"":request.getParameter("com_emp_yn"));
	cont_etc.setDlv_con_commi_yn(request.getParameter("dlv_con_commi_yn")	==null?"":request.getParameter("dlv_con_commi_yn")); //출고보전수당 지급여부
	cont_etc.setCls_etc		(request.getParameter("cls_etc")		==null?"":request.getParameter("cls_etc"));
	cont_etc.setDir_pur_commi_yn(request.getParameter("dir_pur_commi_yn")	==null?"":request.getParameter("dir_pur_commi_yn")); //특판출고 실적이관가능여부
	
	//계약서상 제조사 할인후 차량가격 표기여부, 신차만. (20190911)
	if(car_gu.equals("1")){
		cont_etc.setView_car_dc	(request.getParameter("view_car_dc")	==null?0:AddUtil.parseDigit(request.getParameter("view_car_dc")));
	}
	
	cont_etc.setOthers_device(request.getParameter("others_device")	==null?"":request.getParameter("others_device"));
	
	if(cont_etc.getRent_mng_id().equals("")){
		//=====[cont_etc] insert=====
		cont_etc.setRent_mng_id	(rent_mng_id);
		cont_etc.setRent_l_cd	(rent_l_cd);
		flag3 = a_db.insertContEtc(cont_etc);
	}else{
		//=====[cont_etc] update=====
		flag3 = a_db.updateContEtc(cont_etc);
	}


	//이행보증보험-----------------------------------------------------------------------------------------------
	
	//gua_ins
	ContGiInsBean gins 	= a_db.getContGiInsNew(rent_mng_id, rent_l_cd, "1");
	
	gins.setGi_st		(request.getParameter("gi_st")			==null?"":request.getParameter("gi_st"));
	
	if(gins.getGi_no().equals("")){
		gins.setGi_no("0");
	}
	if(gins.getGi_st().equals("0")){
		gins.setGi_reason	(request.getParameter("gi_reason")==null?"":request.getParameter("gi_reason"));
		gins.setGi_sac_id	(request.getParameter("gi_sac_id")==null?"":request.getParameter("gi_sac_id"));
		gins.setGi_jijum("");
		gins.setGi_amt(0);
		gins.setGi_fee(0);
	}else if(gins.getGi_st().equals("1")){
		gins.setGi_reason("");
		gins.setGi_sac_id("");
		gins.setGi_jijum	(request.getParameter("gi_jijum")==null?"":request.getParameter("gi_jijum"));
		gins.setGi_amt		(request.getParameter("gi_amt")	==null? 0:AddUtil.parseDigit(request.getParameter("gi_amt")));
		gins.setGi_fee		(request.getParameter("gi_fee")	==null? 0:AddUtil.parseDigit(request.getParameter("gi_fee")));
			
		
		//이행보증보험 가입여부 보증보험담당자에게 메시지 통보
						
		UsersBean gins_target_bean 	= umd.getUsersBean(nm_db.getWorkAuthUser("보증보험담당자"));
										
		String xml_data3 = "";
		xml_data3 =  "<COOLMSG>"+
		  				"<ALERTMSG>"+
 						"    <BACKIMG>4</BACKIMG>"+
 						"    <MSGTYPE>104</MSGTYPE>"+
  						"    <SUB>보증보험가입 계약등록</SUB>"+
		  				"    <CONT>보증보험가입 계약등록 : "+rent_l_cd+"</CONT>"+
 						"    <URL></URL>";
		xml_data3 += "    <TARGET>"+gins_target_bean.getId()+"</TARGET>";
		xml_data3 += "    <SENDER>"+umd.getSenderId(ck_acar_id)+"</SENDER>"+
  						"    <MSGICON>10</MSGICON>"+
  						"    <MSGSAVE>1</MSGSAVE>"+
  						"    <LEAVEDMSG>1</LEAVEDMSG>"+
		  				"    <FLDTYPE>1</FLDTYPE>"+
  						"  </ALERTMSG>"+
  						"</COOLMSG>";
			
		CdAlertBean msg3 = new CdAlertBean();
		msg3.setFlddata(xml_data3);
		msg3.setFldtype("1");
			
		flag12 = cm_db.insertCoolMsg(msg3);				
						
	}
		
	if(gins.getRent_mng_id().equals("")){
		//=====[gua_ins] insert=====
		gins.setRent_mng_id	(rent_mng_id);
		gins.setRent_l_cd	(rent_l_cd);
		gins.setRent_st		("1");
		flag4 = a_db.insertGiInsNew(gins);
	}else{
		//=====[gua_ins] update=====
		flag4 = a_db.updateGiInsNew(gins);
	}
	


	//대여정보-------------------------------------------------------------------------------------------
	
	//fee
	ContFeeBean fee = a_db.getContFeeNew(rent_mng_id, rent_l_cd, "1");
			
	fee.setCon_mon			(request.getParameter("con_mon")		==null?"":request.getParameter("con_mon"));
	fee.setGur_per			(request.getParameter("gur_per")		==null? 0:AddUtil.parseFloat(request.getParameter("gur_per")));
	fee.setGur_p_per		(request.getParameter("gur_p_per")		==null? 0:AddUtil.parseFloat(request.getParameter("gur_p_per")));
	fee.setPere_per			(request.getParameter("pere_per")		==null? 0:AddUtil.parseFloat(request.getParameter("pere_per")));
	fee.setPere_r_per		(request.getParameter("pere_r_per")		==null? 0:AddUtil.parseFloat(request.getParameter("pere_r_per")));
	fee.setMax_ja			(request.getParameter("max_ja")			==null? 0:AddUtil.parseFloat(request.getParameter("max_ja")));
	fee.setApp_ja			(request.getParameter("app_ja")			==null? 0:AddUtil.parseFloat(request.getParameter("app_ja")));
	fee.setPere_mth			(request.getParameter("pere_mth")		==null? 0:AddUtil.parseDigit(request.getParameter("pere_mth")));
	fee.setPere_r_mth		(request.getParameter("pere_r_mth")		==null? 0:AddUtil.parseDigit(request.getParameter("pere_r_mth")));
	fee.setOpt_chk			(request.getParameter("opt_chk")		==null?"":request.getParameter("opt_chk"));
	fee.setOpt_per			(request.getParameter("opt_per")		==null?"":request.getParameter("opt_per"));
	fee.setCls_per			(request.getParameter("cls_per")		==null?"":request.getParameter("cls_per"));
	fee.setCls_r_per		(request.getParameter("cls_r_per")		==null? 0:AddUtil.parseFloat(request.getParameter("cls_r_per")));
	fee.setCls_n_per		(request.getParameter("cls_n_per")		==null? 0:AddUtil.parseFloat(request.getParameter("cls_n_per")));
	fee.setDc_ra			(request.getParameter("dc_ra")			==null? 0:AddUtil.parseFloat(request.getParameter("dc_ra")));
	fee.setBas_dt			(request.getParameter("bas_dt")			==null?"":request.getParameter("bas_dt"));
	fee.setPp_est_dt		(request.getParameter("pp_est_dt")		==null?"":request.getParameter("pp_est_dt"));
	fee.setGrt_amt_s		(request.getParameter("grt_s_amt")		==null? 0:AddUtil.parseDigit(request.getParameter("grt_s_amt")));
	fee.setPp_s_amt			(request.getParameter("pp_s_amt")		==null? 0:AddUtil.parseDigit(request.getParameter("pp_s_amt")));
	fee.setPp_v_amt			(request.getParameter("pp_v_amt")		==null? 0:AddUtil.parseDigit(request.getParameter("pp_v_amt")));
	fee.setIfee_s_amt		(request.getParameter("ifee_s_amt")		==null? 0:AddUtil.parseDigit(request.getParameter("ifee_s_amt")));
	fee.setIfee_v_amt		(request.getParameter("ifee_v_amt")		==null? 0:AddUtil.parseDigit(request.getParameter("ifee_v_amt")));
	fee.setJa_s_amt			(request.getParameter("ja_s_amt")		==null? 0:AddUtil.parseDigit(request.getParameter("ja_s_amt")));
	fee.setJa_v_amt			(request.getParameter("ja_v_amt")		==null? 0:AddUtil.parseDigit(request.getParameter("ja_v_amt")));
	fee.setJa_r_s_amt		(request.getParameter("ja_r_s_amt")		==null? 0:AddUtil.parseDigit(request.getParameter("ja_r_s_amt")));
	fee.setJa_r_v_amt		(request.getParameter("ja_r_v_amt")		==null? 0:AddUtil.parseDigit(request.getParameter("ja_r_v_amt")));
	fee.setOpt_s_amt		(request.getParameter("opt_s_amt")		==null? 0:AddUtil.parseDigit(request.getParameter("opt_s_amt")));
	fee.setOpt_v_amt		(request.getParameter("opt_v_amt")		==null? 0:AddUtil.parseDigit(request.getParameter("opt_v_amt")));
	fee.setFee_s_amt		(request.getParameter("fee_s_amt")		==null? 0:AddUtil.parseDigit(request.getParameter("fee_s_amt")));
	fee.setFee_v_amt		(request.getParameter("fee_v_amt")		==null? 0:AddUtil.parseDigit(request.getParameter("fee_v_amt")));
	fee.setInv_s_amt		(request.getParameter("inv_s_amt")		==null? 0:AddUtil.parseDigit(request.getParameter("inv_s_amt")));
	fee.setInv_v_amt		(request.getParameter("inv_v_amt")		==null? 0:AddUtil.parseDigit(request.getParameter("inv_v_amt")));
	fee.setFee_sac_id		(request.getParameter("fee_sac_id")		==null?"":request.getParameter("fee_sac_id"));
	fee.setFee_pay_tm		(request.getParameter("fee_pay_tm")		==null?"":request.getParameter("fee_pay_tm"));
	fee.setFee_est_day		(request.getParameter("fee_est_day")		==null?"":request.getParameter("fee_est_day"));
	fee.setFee_pay_start_dt		(request.getParameter("fee_pay_start_dt")	==null?"":request.getParameter("fee_pay_start_dt"));
	fee.setFee_pay_end_dt		(request.getParameter("fee_pay_end_dt")		==null?"":request.getParameter("fee_pay_end_dt"));
	fee.setFee_sh			(request.getParameter("fee_sh")			==null?"":request.getParameter("fee_sh"));
	fee.setFee_pay_st		(request.getParameter("fee_pay_st")		==null?"":request.getParameter("fee_pay_st"));
	fee.setFee_bank			(request.getParameter("fee_bank")		==null?"":request.getParameter("fee_bank"));
	fee.setFee_cdt			(request.getParameter("fee_cdt")		==null?"":request.getParameter("fee_cdt"));
	fee.setDef_st			(request.getParameter("def_st")			==null?"":request.getParameter("def_st"));
	fee.setDef_remark		(request.getParameter("def_remark")		==null?"":request.getParameter("def_remark"));
	fee.setDef_sac_id		(request.getParameter("def_sac_id")		==null?"":request.getParameter("def_sac_id"));
	fee.setPrv_dlv_yn		(request.getParameter("prv_dlv_yn")		==null?"":request.getParameter("prv_dlv_yn"));
	fee.setPrv_mon_yn		(request.getParameter("prv_mon_yn")		==null?"":request.getParameter("prv_mon_yn"));
	fee.setCredit_per		(request.getParameter("credit_per")		==null? 0:AddUtil.parseFloat(request.getParameter("credit_per")));
	fee.setCredit_r_per		(request.getParameter("credit_r_per")		==null? 0:AddUtil.parseFloat(request.getParameter("credit_r_per")));
	fee.setCredit_amt		(request.getParameter("credit_amt")		==null? 0:AddUtil.parseDigit(request.getParameter("credit_amt")));
	fee.setCredit_r_amt		(request.getParameter("credit_r_amt")		==null? 0:AddUtil.parseDigit(request.getParameter("credit_r_amt")));
	fee.setFee_chk			(request.getParameter("fee_chk")		==null?"":request.getParameter("fee_chk"));
	fee.setB_max_ja			(request.getParameter("b_max_ja")		==null? 0:AddUtil.parseFloat(request.getParameter("b_max_ja")));
	fee.setPp_chk				(request.getParameter("pp_chk")		==null?"":request.getParameter("pp_chk"));
	fee.setIns_s_amt		(request.getParameter("ins_s_amt")		==null? 0:AddUtil.parseDigit(request.getParameter("ins_s_amt")));
	fee.setIns_v_amt		(request.getParameter("ins_v_amt")		==null? 0:AddUtil.parseDigit(request.getParameter("ins_v_amt")));
	fee.setIns_total_amt	(request.getParameter("ins_total_amt")	==null? 0:AddUtil.parseDigit(request.getParameter("ins_total_amt")));
		
	if(base.getRent_st().equals("3")) 	fee.setGrt_suc_yn(request.getParameter("grt_suc_yn")==null?"":request.getParameter("grt_suc_yn"));
		
	//=====[fee] update=====
	flag5 = a_db.updateContFeeNew(fee);
		
		
	//선수금 스케줄 생성
		
	//보증금
	ExtScdBean grt = ae_db.getAGrtScd(rent_mng_id, rent_l_cd, fee.getRent_st(), "0", "1");//기존 등록 여부 조회
	int grt_gbn = 1;		//기존
	if(grt == null || grt.getRent_l_cd().equals("")){
		grt_gbn = 0;		//신규
		grt = new ExtScdBean();
		grt.setRent_mng_id	(rent_mng_id);
		grt.setRent_l_cd	(rent_l_cd);
		grt.setRent_st		(fee.getRent_st());
		grt.setRent_seq		("1");
		grt.setExt_id		("0");
		grt.setExt_st		("0");
		grt.setExt_tm		("1");
	}
	grt.setExt_s_amt		(fee.getGrt_amt_s());
	grt.setExt_v_amt		(0);
	grt.setExt_est_dt		(fee.getPp_est_dt());
	grt.setUpdate_id		(user_id);
	//=====[scd_pre] update=====
	if(grt_gbn == 1)		flag6 = ae_db.updateGrt(grt);
	else				flag6 = ae_db.insertGrt(grt);
	
	
	//선납금
	ExtScdBean pp = ae_db.getAGrtScd(rent_mng_id, rent_l_cd, fee.getRent_st(), "1", "1");//기존 등록 여부 조회
	int pp_gbn = 1;			//기존
	if(pp == null || pp.getRent_l_cd().equals("")){
		pp_gbn = 0;		//신규
		pp = new ExtScdBean();
		pp.setRent_mng_id	(rent_mng_id);
		pp.setRent_l_cd		(rent_l_cd);
		pp.setRent_st		(fee.getRent_st());
		pp.setRent_seq		("1");
		pp.setExt_id		("0");
		pp.setExt_st		("1");
		pp.setExt_tm		("1");
	}
	pp.setExt_s_amt			(fee.getPp_s_amt());
	pp.setExt_v_amt			(fee.getPp_v_amt());
	pp.setExt_est_dt		(fee.getPp_est_dt());
	pp.setUpdate_id			(user_id);
	//=====[scd_pre] update=====
	if(pp_gbn == 1)			flag6 = ae_db.updateGrt(pp);
	else				flag6 = ae_db.insertGrt(pp);
	
	
	//개시대여료
	ExtScdBean ifee = ae_db.getAGrtScd(rent_mng_id, rent_l_cd, fee.getRent_st(), "2", "1");//기존 등록 여부 조회
	int ifee_gbn = 1;		//기존
	if(ifee == null || ifee.getRent_l_cd().equals("")){
		ifee_gbn = 0;		//신규
		ifee = new ExtScdBean();
		ifee.setRent_mng_id	(rent_mng_id);
		ifee.setRent_l_cd	(rent_l_cd);
		ifee.setRent_st		(fee.getRent_st());
		ifee.setRent_seq	("1");
		ifee.setExt_id		("0");
		ifee.setExt_st		("2");
		ifee.setExt_tm		("1");
	}
	ifee.setExt_s_amt		(fee.getIfee_s_amt());
	ifee.setExt_v_amt		(fee.getIfee_v_amt());
	ifee.setExt_est_dt		(fee.getPp_est_dt());
	ifee.setUpdate_id		(user_id);
	//=====[scd_pre] update=====
	if(ifee_gbn == 1)		flag6 = ae_db.updateGrt(ifee);
	else				flag6 = ae_db.insertGrt(ifee);
	
		
	//fee_etc
	ContCarBean fee_etc = a_db.getContFeeEtc(rent_mng_id, rent_l_cd, "1");
	
	fee_etc.setCms_not_cau		(request.getParameter("cms_not_cau")		==null?"":request.getParameter("cms_not_cau"));
	fee_etc.setBus_agnt_per		(request.getParameter("bus_agnt_per")		==null? 0:AddUtil.parseFloat(request.getParameter("bus_agnt_per")));
	fee_etc.setBus_agnt_r_per	(request.getParameter("bus_agnt_r_per")		==null? 0:AddUtil.parseFloat(request.getParameter("bus_agnt_r_per")));
	fee_etc.setBus_agnt_id		(cont_etc.getBus_agnt_id());
	fee_etc.setCls_n_mon		(request.getParameter("cls_n_mon")		==null?"":request.getParameter("cls_n_mon"));
	fee_etc.setCls_n_amt		(request.getParameter("cls_n_amt")		==null? 0:AddUtil.parseDigit(request.getParameter("cls_n_amt")));
	fee_etc.setBc_b_g		(request.getParameter("bc_b_g")			==null? 0:AddUtil.parseDigit(request.getParameter("bc_b_g")));
	fee_etc.setBc_b_u		(request.getParameter("bc_b_u")			==null? 0:AddUtil.parseDigit(request.getParameter("bc_b_u")));
	fee_etc.setBc_b_ac		(request.getParameter("bc_b_ac")		==null? 0:AddUtil.parseDigit(request.getParameter("bc_b_ac")));
	fee_etc.setBc_b_g_cont		(request.getParameter("bc_b_g_cont")		==null?"":request.getParameter("bc_b_g_cont"));
	fee_etc.setBc_b_u_cont		(request.getParameter("bc_b_u_cont")		==null?"":request.getParameter("bc_b_u_cont"));
	fee_etc.setBc_b_e1		(request.getParameter("bc_b_e1")		==null? 0:AddUtil.parseFloat(request.getParameter("bc_b_e1")));
	fee_etc.setBc_b_e2		(request.getParameter("bc_b_e2")		==null? 0:AddUtil.parseDigit(request.getParameter("bc_b_e2")));
	fee_etc.setBc_b_ac_cont		(request.getParameter("bc_b_ac_cont")		==null?"":request.getParameter("bc_b_ac_cont"));
	fee_etc.setBc_etc		(request.getParameter("bc_etc")			==null?"":request.getParameter("bc_etc"));
	fee_etc.setAgree_dist		(request.getParameter("agree_dist")		==null? 0:AddUtil.parseDigit(request.getParameter("agree_dist")));
	fee_etc.setAgree_dist_yn	(request.getParameter("agree_dist_yn")		==null?"":request.getParameter("agree_dist_yn"));
	fee_etc.setOver_run_amt		(request.getParameter("over_run_amt")		==null? 0:AddUtil.parseDigit(request.getParameter("over_run_amt")));
	fee_etc.setCust_est_km		(request.getParameter("cust_est_km")		==null? 0:AddUtil.parseDigit(request.getParameter("cust_est_km")));
	fee_etc.setCredit_sac_id	(request.getParameter("credit_sac_id")		==null?"":request.getParameter("credit_sac_id"));
	fee_etc.setCredit_sac_dt	(request.getParameter("credit_sac_dt")		==null?"":request.getParameter("credit_sac_dt"));
	fee_etc.setDc_ra_st		(request.getParameter("dc_ra_st")		==null?"":request.getParameter("dc_ra_st"));
	fee_etc.setDc_ra_sac_id		(request.getParameter("dc_ra_sac_id")		==null?"":request.getParameter("dc_ra_sac_id"));
	fee_etc.setDc_ra_etc		(request.getParameter("dc_ra_etc")		==null?"":request.getParameter("dc_ra_etc"));
	fee_etc.setCon_etc		(request.getParameter("con_etc")	==null?"":request.getParameter("con_etc"));
	fee_etc.setDriver_add_amt	(request.getParameter("driver_add_amt")	==null? 0:AddUtil.parseDigit(request.getParameter("driver_add_amt")));
	fee_etc.setDriver_add_v_amt	(request.getParameter("driver_add_v_amt")	==null? 0:AddUtil.parseDigit(request.getParameter("driver_add_v_amt")));	//운전자추가요금(부가세) 추가 (2018.03.30)
	fee_etc.setReturn_select	(request.getParameter("return_select")	==null?"":request.getParameter("return_select"));
	fee_etc.setRtn_run_amt		(request.getParameter("rtn_run_amt")	==null? 0:AddUtil.parseDigit(request.getParameter("rtn_run_amt")));
	fee_etc.setRtn_run_amt_yn	(request.getParameter("rtn_run_amt_yn")	==null?"":request.getParameter("rtn_run_amt_yn"));
	
	if(fee.getOpt_chk().equals("0")){
		fee_etc.setAgree_dist_yn("3"); //매입옵션없음
	}else{
		if(fee.getRent_way().equals("1")){
			fee_etc.setAgree_dist_yn("2"); //50%만 납부(일반식)
		}else{
			fee_etc.setAgree_dist_yn("1"); //전액면제(기본식)
		}	
	}

		
	if(fee_etc.getRent_mng_id().equals("")){
		fee_etc.setRent_mng_id		(rent_mng_id);
		fee_etc.setRent_l_cd		(rent_l_cd);
		fee_etc.setRent_st			("1");
		//=====[fee_etc] insert=====
		flag6 = a_db.insertFeeEtc(fee_etc);
	}else{
		//=====[fee_etc] update=====
		flag6 = a_db.updateFeeEtc(fee_etc);
	}



	//자동이체-------------------------------------------------------------------------------------------
	
	//cms_mng
	ContCmsBean cms = a_db.getCmsMng(rent_mng_id, rent_l_cd);
	
	if(fee.getFee_pay_st().equals("1")){
		cms.setCms_acc_no	(request.getParameter("cms_acc_no")	==null?"":request.getParameter("cms_acc_no"));
		cms.setCms_bank		(request.getParameter("cms_bank")	==null?"":request.getParameter("cms_bank"));
		cms.setCms_dep_nm	(request.getParameter("cms_dep_nm")	==null?"":request.getParameter("cms_dep_nm"));
		cms.setCms_dep_ssn	(request.getParameter("cms_dep_ssn")	==null?"":request.getParameter("cms_dep_ssn"));
		cms.setCms_day		(request.getParameter("fee_est_day")	==null?"":request.getParameter("fee_est_day"));
		cms.setCms_dep_post	(request.getParameter("t_zip")		==null?"":request.getParameter("t_zip"));
		cms.setCms_dep_addr	(request.getParameter("t_addr")		==null?"":request.getParameter("t_addr"));
		cms.setCms_etc		(rent_l_cd);
		cms.setCms_tel		(request.getParameter("cms_tel")	==null?"":request.getParameter("cms_tel"));
		cms.setCms_m_tel	(request.getParameter("cms_m_tel")	==null?"":request.getParameter("cms_m_tel"));
		cms.setCms_email	(request.getParameter("cms_email")	==null?"":request.getParameter("cms_email"));
		cms.setBank_cd		(request.getParameter("cms_bank_cd")	==null?"":request.getParameter("cms_bank_cd"));
		
		if(!cms.getBank_cd().equals("")){
			cms.setCms_bank		(c_db.getNameById(cms.getBank_cd(), "BANK"));
		}
		
		if(cms.getCms_day().equals("99")){
			cms.setCms_day	("31");
		}
		
		
		if(!cms.getCms_acc_no().equals("")){
			
			if(cms.getSeq().equals("")){
				cms.setRent_mng_id	(rent_mng_id);
				cms.setRent_l_cd	(rent_l_cd);
				cms.setReg_st		("1");
				cms.setCms_st		("1");
				cms.setReg_id		(user_id);
				//=====[cms_mng] insert=====
				flag7 = a_db.insertContCmsMng(cms);
			}else{
				cms.setUpdate_id	(user_id);
				//=====[cms_mng] update=====
				flag7 = a_db.updateContCmsMng(cms);
			}
		}
	}


	//출고지연대차-------------------------------------------------------------------------------------------
	
	String taecha_no  	= request.getParameter("taecha_no")==null?"":request.getParameter("taecha_no");
	
	if(taecha_no.equals("")){
		taecha_no = a_db.getMaxTaechaNo(rent_mng_id, rent_l_cd)+"";
	}
			
	//출고지연대차
	ContTaechaBean taecha = a_db.getTaecha(rent_mng_id, rent_l_cd, taecha_no);
	
	
	String tae_car_mng_id = request.getParameter("tae_car_mng_id")	==null?"":request.getParameter("tae_car_mng_id");
	
		
	if(!tae_car_mng_id.equals("") && fee.getPrv_dlv_yn().equals("Y")){
		taecha.setCar_mng_id		(tae_car_mng_id);
		taecha.setCar_no		(request.getParameter("tae_car_no")		==null?"":request.getParameter("tae_car_no"));
		taecha.setCar_nm		(request.getParameter("tae_car_nm")		==null?"":request.getParameter("tae_car_nm"));
		taecha.setCar_id		(request.getParameter("tae_car_id")		==null?"":request.getParameter("tae_car_id"));
		taecha.setCar_seq		(request.getParameter("tae_car_seq")		==null?"":request.getParameter("tae_car_seq"));
		taecha.setCar_rent_st		(request.getParameter("tae_car_rent_st")	==null?"":request.getParameter("tae_car_rent_st"));
		taecha.setCar_rent_et		(request.getParameter("tae_car_rent_et")	==null?"":request.getParameter("tae_car_rent_et"));
		taecha.setRent_fee		(request.getParameter("tae_rent_fee")		==null?"0":AddUtil.parseDigit3(request.getParameter("tae_rent_fee")));
		taecha.setReq_st		(request.getParameter("tae_req_st")		==null?"":request.getParameter("tae_req_st"));
		taecha.setTae_st		(request.getParameter("tae_tae_st")		==null?"":request.getParameter("tae_tae_st"));
		taecha.setTae_sac_id		(request.getParameter("tae_sac_id")		==null?"":request.getParameter("tae_sac_id"));
		taecha.setRent_inv		(request.getParameter("tae_rent_inv")		==null?"0":AddUtil.parseDigit3(request.getParameter("tae_rent_inv")));
		taecha.setEst_id		(request.getParameter("tae_est_id")		==null?"":request.getParameter("tae_est_id"));
		taecha.setRent_s_cd		(request.getParameter("tae_s_cd")		==null?"":request.getParameter("tae_s_cd"));
		taecha.setF_req_yn		(request.getParameter("tae_f_req_yn")		==null?"":request.getParameter("tae_f_req_yn"));
		taecha.setRent_fee_st	(request.getParameter("tae_rent_fee_st")	==null?"":request.getParameter("tae_rent_fee_st"));
		taecha.setRent_fee_cls	(request.getParameter("tae_rent_fee_cls")	==null?"0":AddUtil.parseDigit3(request.getParameter("tae_rent_fee_cls")));
		
		
		if(taecha.getRent_mng_id().equals("")){
			taecha.setRent_mng_id	(rent_mng_id);
			taecha.setRent_l_cd		(rent_l_cd);
			//=====[gua_ins] insert=====
			flag8 = a_db.insertTaechaNew(taecha);
		}else{
			//=====[gua_ins] update=====
			flag8 = a_db.updateTaechaNew(taecha);
		}
		
		//스케줄담당자에게 메시지 발송
		if(AddUtil.parseInt(taecha.getRent_fee()) >0 && taecha.getF_req_yn().equals("Y")){
			UsersBean tae_target_bean 	= umd.getUsersBean(nm_db.getWorkAuthUser("스케줄생성자"));
										
				String xml_data3 = "";
				xml_data3 =  "<COOLMSG>"+
		  				"<ALERTMSG>"+
  						"    <BACKIMG>4</BACKIMG>"+
  						"    <MSGTYPE>104</MSGTYPE>"+
  						"    <SUB>출고전대차 선입금 계약</SUB>"+
		  				"    <CONT>출고전대차 선입금 계약 : "+rent_l_cd+" "+firm_nm+"  월대여료"+taecha.getRent_fee()+"원</CONT>"+
 						"    <URL></URL>";
				xml_data3 += "    <TARGET>"+tae_target_bean.getId()+"</TARGET>";				
				xml_data3 += "    <SENDER>"+umd.getSenderId(ck_acar_id)+"</SENDER>"+
  						"    <MSGICON>10</MSGICON>"+
  						"    <MSGSAVE>1</MSGSAVE>"+
  						"    <LEAVEDMSG>1</LEAVEDMSG>"+
		  				"    <FLDTYPE>1</FLDTYPE>"+
  						"  </ALERTMSG>"+
  						"</COOLMSG>";
			
				CdAlertBean msg3 = new CdAlertBean();
				msg3.setFlddata(xml_data3);
				msg3.setFldtype("1");
			
				flag12 = cm_db.insertCoolMsg(msg3);
				
				taecha.setF_req_dt	(AddUtil.getDate(4));
				flag8 = a_db.updateTaechaNew(taecha);
		}
		//20210101 이후 출고전대차 월대여료가 있고, 신차해지요금정삼이 견적서에 표기되어 있지 않음인 경우 권용식과장한테 메시지 발송
		if(taecha.getRent_fee_cls().equals("0") && AddUtil.parseInt(taecha.getRent_fee()) >0  && AddUtil.parseInt(AddUtil.replace(taecha.getCar_rent_st(),"-","")) >= 20210101){				
			UsersBean tae_target_bean 	= umd.getUsersBean(nm_db.getWorkAuthUser("엑셀견적관리자"));
			
			String xml_data3 = "";
			xml_data3 =  "<COOLMSG>"+
		  				"<ALERTMSG>"+
  						"    <BACKIMG>4</BACKIMG>"+
  						"    <MSGTYPE>104</MSGTYPE>"+
  						"    <SUB>출고전대차 신차해지시요금정산</SUB>"+
		  				"    <CONT>출고전대차 신차해지시요금정산 견적서 미표기 : "+rent_l_cd+"</CONT>"+
 						"    <URL></URL>";
			xml_data3 += "    <TARGET>"+tae_target_bean.getId()+"</TARGET>";
			xml_data3 += "    <MSGICON>10</MSGICON>"+
  						"    <MSGSAVE>1</MSGSAVE>"+
  						"    <LEAVEDMSG>1</LEAVEDMSG>"+
		  				"    <FLDTYPE>1</FLDTYPE>"+
  						"  </ALERTMSG>"+
  						"</COOLMSG>";
			
			CdAlertBean msg3 = new CdAlertBean();
			msg3.setFlddata(xml_data3);
			msg3.setFldtype("1");
			
			//flag12 = cm_db.insertCoolMsg(msg3);									
		}
		
		int tae_rent_inv_s = request.getParameter("tae_rent_inv_s")	==null?0:AddUtil.parseDigit(request.getParameter("tae_rent_inv_s"));
		int tae_rent_inv_v = request.getParameter("tae_rent_inv_v")	==null?0:AddUtil.parseDigit(request.getParameter("tae_rent_inv_v"));
		
		if(tae_rent_inv_s>0){
			//추가연장대여정보 정상요금 수정
			boolean flag30 = a_db.updateContFeeAddInvAmt(rent_mng_id, rent_l_cd, "t", tae_rent_inv_s, tae_rent_inv_v);
		}
		
		if(!tae_car_mng_id.equals("") && !taecha.getRent_s_cd().equals("")){
			RentContBean rc_bean = rs_db.getRentContCase(taecha.getRent_s_cd(), tae_car_mng_id);
			rc_bean.setSub_l_cd		(rent_l_cd);
			int rs_count = 1;
			rs_count = rs_db.updateRentCont(rc_bean);
		}			

	}



	//영업소사원-------------------------------------------------------------------------------------------
	
	//commi
	CommiBean emp1 	= a_db.getCommi(rent_mng_id, rent_l_cd, "1");
	CommiBean emp2 	= a_db.getCommi(rent_mng_id, rent_l_cd, "2");
	
	String emp_id[] 	= request.getParameterValues("emp_id");
	String car_off_nm[] = request.getParameterValues("car_off_nm");
	
	if(!emp_id[0].equals("")){
		
		emp1.setEmp_id		(emp_id[0]);
		emp1.setComm_rt		(request.getParameter("comm_rt")	==null? 0:AddUtil.parseFloat(request.getParameter("comm_rt")));
		emp1.setComm_r_rt	(request.getParameter("comm_r_rt")	==null? 0:AddUtil.parseFloat(request.getParameter("comm_r_rt")));
		emp1.setCh_remark	(request.getParameter("ch_remark")	==null?"":request.getParameter("ch_remark"));
		emp1.setCh_sac_id	(request.getParameter("ch_sac_id")	==null?"":request.getParameter("ch_sac_id"));
		emp1.setEmp_bank	(request.getParameter("emp_bank")	==null?"":request.getParameter("emp_bank"));
		emp1.setEmp_acc_no	(request.getParameter("emp_acc_no")	==null?"":request.getParameter("emp_acc_no"));
		emp1.setEmp_acc_nm	(request.getParameter("emp_acc_nm")	==null?"":request.getParameter("emp_acc_nm"));
		emp1.setCommi		(request.getParameter("commi")		==null? 0:AddUtil.parseDigit(request.getParameter("commi")));
		emp1.setCommi_car_amt	(request.getParameter("commi_car_amt")	==null? 0:AddUtil.parseDigit(request.getParameter("commi_car_amt")));
		emp1.setCommi_car_st	(request.getParameter("commi_car_st")	==null?"1":request.getParameter("commi_car_st"));
		emp1.setAgnt_st		("1");
		emp1.setCommi_st	("1");
		emp1.setBank_cd		(request.getParameter("emp_bank_cd")	==null?"":request.getParameter("emp_bank_cd"));
		
		if(!emp1.getBank_cd().equals("")){
			emp1.setEmp_bank		(c_db.getNameById(emp1.getBank_cd(), "BANK"));
		}
		
		if(emp1.getRent_mng_id().equals("")){
			emp1.setRent_mng_id	(rent_mng_id);
			emp1.setRent_l_cd	(rent_l_cd);
			//=====[commi] insert=====
			flag9 = a_db.insertCommiNew(emp1);
		}else{
			//=====[commi] update=====
			flag9 = a_db.updateCommiNew(emp1);
		}
		
		//영업사원별담당자 업그레이드하기----------------------------------------------------------------
		CarOfficeDatabase cod = CarOfficeDatabase.getInstance();
		//담당자변경이력
		CarOffEdhBean[] cohList  = cod.getCar_off_edh(emp_id[0]); 
		coh_bean = cohList[cohList.length-1];
		String up_emp_id = "";
		if(!coh_bean.getDamdang_id().equals(base.getBus_id())){
			coe_bean = cod.getCarOffEmpBean(emp_id[0]);
			//담당자 이력관리
			coh_bean.setEmp_id		(emp_id[0]);
			coh_bean.setDamdang_id		(base.getBus_id());
			coh_bean.setCng_dt		(base.getRent_dt());
			coh_bean.setCng_rsn		("1");
			coh_bean.setReg_id		(user_id);
			coh_bean.setReg_dt		(base.getRent_dt());
			up_emp_id = cod.updateCarOffEmp(coe_bean, coh_bean);
		}
	}
	
	
		
	String dir_pur_yn 	= request.getParameter("dir_pur_yn")	==null?"":request.getParameter("dir_pur_yn");

		
	if(!emp_id[1].equals("")){
			
		emp2.setEmp_id		(emp_id[1]);
		emp2.setAgnt_st		("2");
		emp2.setCommi_st	("1");
			
		if(emp2.getRent_mng_id().equals("")){
			emp2.setRent_mng_id	(rent_mng_id);
			emp2.setRent_l_cd	(rent_l_cd);
			//=====[commi] insert=====
			flag10 = a_db.insertCommiNew(emp2);
		}else{
			//=====[commi] update=====
			flag10 = a_db.updateCommiNew(emp2);
		}
	}


	//출고정보-------------------------------------------------------------------------------------------
	
	//car_pur
	ContPurBean pur = a_db.getContPur(rent_mng_id, rent_l_cd);
	
	pur.setUdt_st			(request.getParameter("udt_st")		==null?"":request.getParameter("udt_st"));
	pur.setCons_amt1	(request.getParameter("cons_amt1").equals("")?0:AddUtil.parseDigit(request.getParameter("cons_amt1")));
	pur.setCon_amt		(request.getParameter("con_amt")	==null? 0:AddUtil.parseDigit(request.getParameter("con_amt")));
	pur.setCon_bank		(request.getParameter("con_bank")	==null?"":request.getParameter("con_bank"));
	pur.setCon_acc_no	(request.getParameter("con_acc_no")	==null?"":request.getParameter("con_acc_no"));
	pur.setCon_acc_nm	(request.getParameter("con_acc_nm")	==null?"":request.getParameter("con_acc_nm"));
	pur.setOne_self		(request.getParameter("one_self")	==null?"":request.getParameter("one_self"));
	pur.setDlv_brch		(car_off_nm[1]);
	pur.setDir_pur_yn	(request.getParameter("dir_pur_yn")	==null?"":request.getParameter("dir_pur_yn"));
	pur.setPur_req_dt	(request.getParameter("pur_req_dt")	==null?"":request.getParameter("pur_req_dt"));
	pur.setPur_bus_st	(request.getParameter("pur_bus_st")	==null?"":request.getParameter("pur_bus_st"));
	pur.setPur_req_yn	(request.getParameter("pur_req_yn")	==null?"":request.getParameter("pur_req_yn"));
	pur.setEcar_loc_st(request.getParameter("ecar_loc_st")	==null?"":request.getParameter("ecar_loc_st"));
	pur.setHcar_loc_st(request.getParameter("hcar_loc_st")	==null?"":request.getParameter("hcar_loc_st"));
	
	pur.setTrf_st0		(request.getParameter("trf_st0")	==null?"":request.getParameter("trf_st0"));
	pur.setAcc_st0		(request.getParameter("acc_st0")	==null?"":request.getParameter("acc_st0"));
	pur.setCon_est_dt	(request.getParameter("con_est_dt")	==null?"":request.getParameter("con_est_dt"));
	
	pur.setTrf_st5		(request.getParameter("trf_st5")	==null?"":request.getParameter("trf_st5"));
	pur.setTrf_amt5		(request.getParameter("trf_amt5").equals("")	?0:AddUtil.parseDigit(request.getParameter("trf_amt5")));
	pur.setCard_kind5	(request.getParameter("card_kind5")	==null?"":request.getParameter("card_kind5"));
	pur.setCardno5		(request.getParameter("cardno5")	==null?"":request.getParameter("cardno5"));
	pur.setTrf_cont5	(request.getParameter("trf_cont5")	==null?"":request.getParameter("trf_cont5"));
	pur.setAcc_st5		(request.getParameter("acc_st5")	==null?"":request.getParameter("acc_st5"));
	pur.setTrf_est_dt5	(request.getParameter("trf_est_dt5")==null?"":request.getParameter("trf_est_dt5"));
	
	if(pur.getTrf_amt5() >0 && pur.getTrf_st5().equals("")) pur.setTrf_st5("1");
		
		
	//=====[CAR_PUR] update=====
	flag11 = a_db.updateContPur(pur);



	String print_car_st 	= request.getParameter("print_car_st")==null?"":request.getParameter("print_car_st");
	String print_car_st_yn 	= request.getParameter("print_car_st_yn")==null?"":request.getParameter("print_car_st_yn");
	
	ClientBean client = al_db.getNewClient(base.getClient_id());
	
	if(!print_car_st.equals("")){		
		client.setPrint_car_st		(print_car_st);
		client.setUpdate_id		(user_id);
		if(al_db.updateNewClient2(client)){
			//수정완료
		}
	}
	
	//자체출고영업소-현대오금대리점(김인형) 일때 메시지
	if(pur.getOne_self().equals("Y") && pur.getDlv_brch().equals("오금역대리점") && emp_id[1].equals("008126")){
			
		//2. 쿨메신저 메세지 전송------------------------------------------------------------------------------------------
			
		String sub 	= "자체출고영업소 현대오금대리점";
		String cont 	= "[ "+rent_l_cd+" "+firm_nm+" ] 자체출고영업소 현대오금대리점입니다.";
		String target_id = nm_db.getWorkAuthUser("출고관리자");
		
					
			
		//사용자 정보 조회
		UsersBean target_bean 	= umd.getUsersBean(target_id);
			
		String xml_data = "";
		xml_data =  "<COOLMSG>"+
		  				"<ALERTMSG>"+
  						"    <BACKIMG>4</BACKIMG>"+
  						"    <MSGTYPE>104</MSGTYPE>"+
  						"    <SUB>"+sub+"</SUB>"+
		  				"    <CONT>"+cont+"</CONT>"+
 						"    <URL></URL>";
		xml_data += "    <TARGET>"+target_bean.getId()+"</TARGET>";
		xml_data += "    <SENDER>"+umd.getSenderId(ck_acar_id)+"</SENDER>"+
  						"    <MSGICON>10</MSGICON>"+
  						"    <MSGSAVE>1</MSGSAVE>"+
  						"    <LEAVEDMSG>1</LEAVEDMSG>"+
		  				"    <FLDTYPE>1</FLDTYPE>"+
  						"  </ALERTMSG>"+
  						"</COOLMSG>";
			
		CdAlertBean msg = new CdAlertBean();
		msg.setFlddata(xml_data);
		msg.setFldtype("1");
			
		flag12 = cm_db.insertCoolMsg(msg);		
					
	}
	
	
	//미결정시 세금계산서 담당자에게 알림->부가세환급차량 등록 무조건 알림
	if(print_car_st_yn.equals("Y")){
			
		//2. 쿨메신저 메세지 전송------------------------------------------------------------------------------------------
			
		String sub 	= "부가세환급차량 계약등록 알림";
		String cont 	= "[ "+rent_l_cd+" "+firm_nm+" ] 부가세환급차량 계약등록 알립니다.";
		String target_id = nm_db.getWorkAuthUser("세금계산서담당자");
					
			
		//사용자 정보 조회
		UsersBean target_bean 	= umd.getUsersBean(target_id);
			
		String xml_data = "";
		xml_data =  "<COOLMSG>"+
		  				"<ALERTMSG>"+
  						"    <BACKIMG>4</BACKIMG>"+
  						"    <MSGTYPE>104</MSGTYPE>"+
  						"    <SUB>"+sub+"</SUB>"+
		  				"    <CONT>"+cont+"</CONT>"+
 						"    <URL></URL>";
		xml_data += "    <TARGET>"+target_bean.getId()+"</TARGET>";
		xml_data += "    <SENDER>"+umd.getSenderId(ck_acar_id)+"</SENDER>"+
  						"    <MSGICON>10</MSGICON>"+
  						"    <MSGSAVE>1</MSGSAVE>"+
  						"    <LEAVEDMSG>1</LEAVEDMSG>"+
		  				"    <FLDTYPE>1</FLDTYPE>"+
  						"  </ALERTMSG>"+
  						"</COOLMSG>";
			
		CdAlertBean msg = new CdAlertBean();
		msg.setFlddata(xml_data);
		msg.setFldtype("1");
			
		flag12 = cm_db.insertCoolMsg(msg);
					
	}
	
	
	//20150713 자동배정이 안되었을때
	if(base.getBus_id2().equals(nm_db.getWorkAuthUser("본사관리팀장"))){
		//계약 영업담당자 배정처리
		String  d_flag3 =  ad_db.call_sp_rent_busid2_auto_reg(rent_mng_id, rent_l_cd);
	}	
		
	//신규 수입차 계약인 경우 영업기획팀 수입차 담당자에게 메시지 발송
	if(base.getCar_gu().equals("1") && ej_bean.getJg_w().equals("1")){
			
					UsersBean target_bean 	= umd.getUsersBean(nm_db.getWorkAuthUser("수입차출고담당"));	
					UsersBean target_bean2 	= umd.getUsersBean(nm_db.getWorkAuthUser("수입차출고담당2"));	
					//UsersBean target_bean3 	= umd.getUsersBean(nm_db.getWorkAuthUser("수입차출고담당3"));	
					
					CarScheBean cs_bean = csd.getCarScheTodayBean(target_bean.getUser_id());
									
					String xml_data1 = "";
					xml_data1 =  "<COOLMSG>"+
		  						"<ALERTMSG>"+
  								"    <BACKIMG>4</BACKIMG>"+
  								"    <MSGTYPE>104</MSGTYPE>"+
	  							"    <SUB>수입자계약등록</SUB>"+
			  					"    <CONT>수입차 계약이 4단계 등록되었습니다.  &lt;br&gt; &lt;br&gt; "+firm_nm+" "+cm_bean.getCar_comp_nm()+" "+cm_bean.getCar_nm()+" "+cm_bean.getCar_name()+" "+rent_l_cd+" </CONT>"+
 								"    <URL></URL>";
					
					xml_data1 += "    <TARGET>"+target_bean.getId()+"</TARGET>";
					xml_data1 += "    <TARGET>"+target_bean2.getId()+"</TARGET>";
					//xml_data1 += "    <TARGET>"+target_bean3.getId()+"</TARGET>";
					
					xml_data1 += "    <SENDER>"+umd.getSenderId(ck_acar_id)+"</SENDER>"+
  								"    <MSGICON>10</MSGICON>"+
  								"    <MSGSAVE>1</MSGSAVE>"+
	  							"    <LEAVEDMSG>1</LEAVEDMSG>"+
			  					"    <FLDTYPE>1</FLDTYPE>"+
  								"  </ALERTMSG>"+
	  							"</COOLMSG>";
			
					CdAlertBean msg1 = new CdAlertBean();
					msg1.setFlddata(xml_data1);
					msg1.setFldtype("1");
			
					flag5 = cm_db.insertCoolMsg(msg1);
	}
	
	//차종코드를 관리해 등록된 차종코드는 메세지발송(20190930)
	if(base.getCar_gu().equals("1")){
		
		CommonEtcBean ce_bean	= c_db.getCommonEtc("set_msg", "jg_code", "사전계약관리메세지수신코드설정", "", "", "", "", "", "");	
		String c_content = ce_bean.getEtc_content();
		String [] c_content_arr = c_content.split(",");
		boolean result =false;
		for(int i=0;i<c_content_arr.length;i++){
			if(cm_bean.getJg_code().equals(c_content_arr[i])){	result = true;	}
		}
		
		if(ej_bean.getJg_g_7().equals("3")||ej_bean.getJg_g_7().equals("4")){		result = true;		}	//전기차, 수소차는 차종코드등록안해도 메세지발송
		
		if(result){
		
			UsersBean target_bean 	= umd.getUsersBean(nm_db.getWorkAuthUser("전기차담당"));	
			UsersBean target_bean2 	= umd.getUsersBean(nm_db.getWorkAuthUser("엑셀견적관리자"));	
			//UsersBean target_bean3 	= umd.getUsersBean(nm_db.getWorkAuthUser("출고관리자"));	
			//UsersBean target_bean4 	= umd.getUsersBean(nm_db.getWorkAuthUser("에이전트관리"));
			//UsersBean target_bean5 	= umd.getUsersBean(nm_db.getWorkAuthUser("에이전트관리2"));
			
			CarScheBean cs_bean = csd.getCarScheTodayBean(target_bean.getUser_id());
							
			String xml_data1 = "";
			xml_data1 =  "<COOLMSG>"+
	 						"<ALERTMSG>"+
								"    <BACKIMG>4</BACKIMG>"+
								"    <MSGTYPE>104</MSGTYPE>"+
								"    <SUB>사전예약관리 > 관리대상차량 계약등록</SUB>"+
	  					"    <CONT>사전예약관리 > 관리대상차량의 계약이 4단계 등록되었습니다.  &lt;br&gt; &lt;br&gt; "+firm_nm+"  "+cm_bean.getCar_comp_nm()+" "+cm_bean.getCar_nm()+" "+cm_bean.getCar_name()+" "+rent_l_cd+" </CONT>"+
							"    <URL></URL>";
			xml_data1 += "    <TARGET>"+target_bean.getId()+"</TARGET>";
			xml_data1 += "    <TARGET>"+target_bean2.getId()+"</TARGET>";
			//xml_data1 += "    <TARGET>"+target_bean3.getId()+"</TARGET>";		
			//xml_data1 += "    <TARGET>"+target_bean4.getId()+"</TARGET>";
			//xml_data1 += "    <TARGET>"+target_bean5.getId()+"</TARGET>";
			
			
			xml_data1 += "    <SENDER>"+umd.getSenderId(ck_acar_id)+"</SENDER>"+
								"    <MSGICON>10</MSGICON>"+
								"    <MSGSAVE>1</MSGSAVE>"+
								"    <LEAVEDMSG>1</LEAVEDMSG>"+
	  					"    <FLDTYPE>1</FLDTYPE>"+
								"  </ALERTMSG>"+
								"</COOLMSG>";
	
			CdAlertBean msg1 = new CdAlertBean();
			msg1.setFlddata(xml_data1);
			msg1.setFldtype("1");
	
			flag5 = cm_db.insertCoolMsg(msg1);
		}
	}
	
	//신차 전기차는 전기차관련담당자(함윤원)에게 메시지 발송
	/* if(base.getCar_gu().equals("1") && ej_bean.getJg_g_7().equals("3")){
			
					UsersBean target_bean 	= umd.getUsersBean(nm_db.getWorkAuthUser("전기차담당"));	
					UsersBean target_bean2 	= umd.getUsersBean(nm_db.getWorkAuthUser("엑셀견적관리자"));	
					UsersBean target_bean3 	= umd.getUsersBean(nm_db.getWorkAuthUser("출고관리자"));	
					UsersBean target_bean4 	= umd.getUsersBean(nm_db.getWorkAuthUser("에이전트관리"));
					
					CarScheBean cs_bean = csd.getCarScheTodayBean(target_bean.getUser_id());
									
					String xml_data1 = "";
					xml_data1 =  "<COOLMSG>"+
		  						"<ALERTMSG>"+
  								"    <BACKIMG>4</BACKIMG>"+
  								"    <MSGTYPE>104</MSGTYPE>"+
	  							"    <SUB>전기차계약등록</SUB>"+
			  					"    <CONT>전기차 계약이 4단계 등록되었습니다. "+firm_nm+" "+cm_bean.getCar_comp_nm()+" "+cm_bean.getCar_nm()+" "+cm_bean.getCar_name()+" "+rent_l_cd+" </CONT>"+
 								"    <URL></URL>";
					xml_data1 += "    <TARGET>"+target_bean.getId()+"</TARGET>";
					xml_data1 += "    <TARGET>"+target_bean2.getId()+"</TARGET>";
					xml_data1 += "    <TARGET>"+target_bean3.getId()+"</TARGET>";
					
					if(!cs_bean.getUser_id().equals("")){
						xml_data1 += "    <TARGET>"+target_bean4.getId()+"</TARGET>";
					}
					
					xml_data1 += "    <SENDER>"+umd.getSenderId(ck_acar_id)+"</SENDER>"+
  								"    <MSGICON>10</MSGICON>"+
  								"    <MSGSAVE>1</MSGSAVE>"+
	  							"    <LEAVEDMSG>1</LEAVEDMSG>"+
			  					"    <FLDTYPE>1</FLDTYPE>"+
  								"  </ALERTMSG>"+
	  							"</COOLMSG>";
			
					CdAlertBean msg1 = new CdAlertBean();
					msg1.setFlddata(xml_data1);
					msg1.setFldtype("1");
			
					flag5 = cm_db.insertCoolMsg(msg1);
	}	
	//신차 수소차는 전기차관련담당자(함윤원)에게 메시지 발송
	if(base.getCar_gu().equals("1") && ej_bean.getJg_g_7().equals("4")){
			
					UsersBean target_bean 	= umd.getUsersBean(nm_db.getWorkAuthUser("전기차담당"));	
					UsersBean target_bean2 	= umd.getUsersBean(nm_db.getWorkAuthUser("엑셀견적관리자"));	
					UsersBean target_bean3 	= umd.getUsersBean(nm_db.getWorkAuthUser("출고관리자"));	
					UsersBean target_bean4 	= umd.getUsersBean(nm_db.getWorkAuthUser("에이전트관리"));
					
					CarScheBean cs_bean = csd.getCarScheTodayBean(target_bean.getUser_id());
					
					String xml_data1 = "";
					xml_data1 =  "<COOLMSG>"+
		  						"<ALERTMSG>"+
  								"    <BACKIMG>4</BACKIMG>"+
  								"    <MSGTYPE>104</MSGTYPE>"+
	  							"    <SUB>수소차계약등록</SUB>"+
			  					"    <CONT>수소차 계약이 4단계 등록되었습니다. "+firm_nm+" "+cm_bean.getCar_comp_nm()+" "+cm_bean.getCar_nm()+" "+cm_bean.getCar_name()+" "+rent_l_cd+" </CONT>"+
 								"    <URL></URL>";
					xml_data1 += "    <TARGET>"+target_bean.getId()+"</TARGET>";
					xml_data1 += "    <TARGET>"+target_bean2.getId()+"</TARGET>";
					xml_data1 += "    <TARGET>"+target_bean3.getId()+"</TARGET>";
					
					if(!cs_bean.getUser_id().equals("")){
						xml_data1 += "    <TARGET>"+target_bean4.getId()+"</TARGET>";
					}
					
					xml_data1 += "    <SENDER>"+umd.getSenderId(ck_acar_id)+"</SENDER>"+
  								"    <MSGICON>10</MSGICON>"+
  								"    <MSGSAVE>1</MSGSAVE>"+
	  							"    <LEAVEDMSG>1</LEAVEDMSG>"+
			  					"    <FLDTYPE>1</FLDTYPE>"+
  								"  </ALERTMSG>"+
	  							"</COOLMSG>";
			
					CdAlertBean msg1 = new CdAlertBean();
					msg1.setFlddata(xml_data1);
					msg1.setFldtype("1");
			
					flag5 = cm_db.insertCoolMsg(msg1);
	} */
	
	//고객별 최종스캔 동기화
	String  d_flag1 =  ad_db.call_sp_lc_rent_scanfile_syn(rent_mng_id, rent_l_cd, user_id);
%>
<form name='form1' method='post'>
  <input type="hidden" name="auth_rw" 			value="<%=auth_rw%>">
  <input type="hidden" name="user_id" 			value="<%=user_id%>">
  <input type="hidden" name="br_id" 			value="<%=br_id%>">    
  <input type="hidden" name="rent_mng_id" 		value="<%=rent_mng_id%>">
  <input type="hidden" name="rent_l_cd" 		value="<%=rent_l_cd%>">  
  <input type='hidden' name="c_st" 			value="client">  
</form>
<script language='javascript'>
	var fm = document.form1;

<%		if(!flag1){	%>
		alert('차량기본정보 등록 에러입니다.\n\n확인하십시오');
<%		}	%>		
	
<%		if(!flag2){	%>
		alert('계약기본정보 등록 에러입니다.\n\n확인하십시오');
<%		}	%>		

<%		if(!flag3){	%>
		alert('계약기타정보 등록 에러입니다.\n\n확인하십시오');
<%		}	%>		

<%		if(!flag4){	%>
		alert('이행보증보험 등록 에러입니다.\n\n확인하십시오');
<%		}	%>		

<%		if(!flag5){	%>
		alert('대여정보 등록 에러입니다.\n\n확인하십시오');
<%		}	%>		

<%		if(!flag6){	%>
		alert('선수금스케줄 등록 에러입니다.\n\n확인하십시오');
<%		}	%>		

<%		if(!flag7){	%>
		alert('자동이체 등록 에러입니다.\n\n확인하십시오');
<%		}	%>		

<%		if(!flag8){	%>
		alert('출고지연대차 등록 에러입니다.\n\n확인하십시오');
<%		}	%>		

<%		if(!flag9){	%>
		alert('영업담당영업사원 등록 에러입니다.\n\n확인하십시오');
<%		}	%>		

<%		if(!flag10){%>
		alert('출고담당영업사원 등록 에러입니다.\n\n확인하십시오');
<%		}	%>		

<%		if(!flag11){%>
		alert('출고정보 등록 에러입니다.\n\n확인하십시오');
<%		}	%>		

	fm.action = '/agent/lc_rent/lc_b_u.jsp';
	fm.target = 'd_content';
	fm.submit();

</script>
</body>
</html>