<%@ page language="java" contentType="text/html;charset=euc-kr" %>
<%@ page import="java.util.*, acar.util.*, acar.cont.*, acar.car_mst.*, acar.car_office.*, acar.res_search.*,  acar.ext.*"%>
<%@ page import="acar.coolmsg.*, acar.user_mng.*, acar.car_sche.*, acar.car_register.*"%>
<jsp:useBean id="a_db" scope="page" class="acar.cont.AddContDatabase"/>
<jsp:useBean id="ae_db" scope="page" class="acar.ext.AddExtDatabase"/>
<jsp:useBean id="af_db" scope="page" class="acar.fee.AddFeeDatabase"/>
<jsp:useBean id="cm_db" scope="page" class="acar.coolmsg.CoolMsgDatabase"/>
<jsp:useBean id="cr_bean" class="acar.car_register.CarRegBean" scope="page"/>
<jsp:useBean id="ec_db" scope="page" class="acar.cont.EtcContDatabase"/>

<%@ include file="/acar/cookies.jsp" %>

<html>
<head>
<title>FMS</title>
</head>
<body leftmargin="15">
<%
	//if(1==1)return;
	
	String auth_rw 		= request.getParameter("auth_rw")==null?""        :request.getParameter("auth_rw");
	String user_id 		= request.getParameter("user_id")==null?ck_acar_id:request.getParameter("user_id");
	String br_id 		= request.getParameter("br_id")  ==null?acar_br   :request.getParameter("br_id");
	
	String rent_mng_id 	= request.getParameter("rent_mng_id")==null?"":request.getParameter("rent_mng_id");
	String rent_l_cd 	= request.getParameter("rent_l_cd")==null?"":request.getParameter("rent_l_cd");
	String rent_st	 	= request.getParameter("rent_st")==null?"":request.getParameter("rent_st");
	
	String car_gu 		= request.getParameter("car_gu")==null?"1":request.getParameter("car_gu");//신차1,기존0
	String car_st 		= request.getParameter("car_st")==null?"":request.getParameter("car_st");	
	String client_st	= request.getParameter("client_st")==null?"":request.getParameter("client_st");
	
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
	int flag = 0;
	
	
	MaMenuDatabase nm_db = MaMenuDatabase.getInstance();
	UserMngDatabase umd = UserMngDatabase.getInstance();
	AddCarMstDatabase cmb 	= AddCarMstDatabase.getInstance();
	CarRegDatabase crd = CarRegDatabase.getInstance();


	//System.out.println(rent_l_cd+" 연장 납입횟수 : "+request.getParameter("fee_pay_tm"));
	

	
	//차량기본정보
	ContCarBean car 	= a_db.getContCarNew(rent_mng_id, rent_l_cd);
	
	//자동차기본정보
	CarMstBean cm_bean = cmb.getCarNmCase(String.valueOf(car.getCar_id()), String.valueOf(car.getCar_seq()));

	
	//대여료갯수조회(연장여부)
	int fee_size 			= af_db.getMaxRentSt(rent_mng_id, rent_l_cd);


	//계약기본정보-----------------------------------------------------------------------------------------------
	
	//cont
	ContBaseBean base = a_db.getCont(rent_mng_id, rent_l_cd);
	
	String o_lic = base.getLic_no();
	String o_m_lic = base.getMgr_lic_no()+""+base.getMgr_lic_emp()+""+base.getMgr_lic_rel();
	
	String car_no="";
	//차량등록정보
	if(!base.getCar_mng_id().equals("")){
		cr_bean = crd.getCarRegBean(base.getCar_mng_id());
		car_no = cr_bean.getCar_no();
	}
	base.setRent_end_dt	(request.getParameter("rent_end_dt")		==null?"":request.getParameter("rent_end_dt"));
	base.setDriving_age	(request.getParameter("driving_age")		==null?"":request.getParameter("driving_age"));
	base.setGcp_kd			(request.getParameter("gcp_kd")			==null?"":request.getParameter("gcp_kd"));
	base.setBacdt_kd		(request.getParameter("bacdt_kd")		==null?"":request.getParameter("bacdt_kd"));
	base.setLic_no			(request.getParameter("lic_no")==null?"":request.getParameter("lic_no"));	
	base.setMgr_lic_no	(request.getParameter("mgr_lic_no")==null?"":request.getParameter("mgr_lic_no"));	
	base.setMgr_lic_emp	(request.getParameter("mgr_lic_emp")==null?"":request.getParameter("mgr_lic_emp"));	
	base.setMgr_lic_rel	(request.getParameter("mgr_lic_rel")==null?"":request.getParameter("mgr_lic_rel"));	
	base.setSanction_type("연장등록");
	
	
	//=====[cont] update=====
	flag2 = a_db.updateContBaseNew(base);
	

	String n_lic = base.getLic_no();
	String n_m_lic = base.getMgr_lic_no()+""+base.getMgr_lic_emp()+""+base.getMgr_lic_rel();
			
	//변경이력 관리
	if(!o_lic.equals(n_lic)){
		LcRentCngHBean lrc_bean = new LcRentCngHBean();
		lrc_bean.setRent_mng_id		(rent_mng_id);
		lrc_bean.setRent_l_cd		(rent_l_cd);
		lrc_bean.setCng_item		("lic_no");
		lrc_bean.setOld_value		(o_lic);
		lrc_bean.setNew_value		(n_lic);
		lrc_bean.setCng_cau			("연장계약 계약자 운전면허번호 변경");
		lrc_bean.setCng_id			(user_id);
		lrc_bean.setRent_st			("1");
		flag2 = a_db.updateLcRentCngH(lrc_bean);
	}
	//변경이력 관리
	if(!o_m_lic.equals(n_m_lic)){
		LcRentCngHBean lrc_bean = new LcRentCngHBean();
		lrc_bean.setRent_mng_id		(rent_mng_id);
		lrc_bean.setRent_l_cd		(rent_l_cd);
		lrc_bean.setCng_item		("mgr_lic_no");
		lrc_bean.setOld_value		(o_m_lic);
		lrc_bean.setNew_value		(n_m_lic);
		lrc_bean.setCng_cau			("연장계약 차량이용자 운전면허번호 변경");
		lrc_bean.setCng_id			(user_id);
		lrc_bean.setRent_st			("1");
		flag2 = a_db.updateLcRentCngH(lrc_bean);
	}		
	


	//대여기타정보-------------------------------------------------------------------------------------------
	
	//fee_etc
	ContCarBean fee_etc = a_db.getContFeeEtc(rent_mng_id, rent_l_cd, rent_st);
	fee_etc.setSh_car_amt		(request.getParameter("sh_car_amt")			==null? 0:AddUtil.parseDigit(request.getParameter("sh_car_amt")));
	fee_etc.setSh_year			(request.getParameter("sh_year")			==null?"":request.getParameter("sh_year"));
	fee_etc.setSh_month			(request.getParameter("sh_month")			==null?"":request.getParameter("sh_month"));
	fee_etc.setSh_day			(request.getParameter("sh_day")				==null?"":request.getParameter("sh_day"));
	fee_etc.setSh_day_bas_dt	(request.getParameter("sh_day_bas_dt")		==null?"":request.getParameter("sh_day_bas_dt"));
	fee_etc.setSh_amt			(request.getParameter("sh_amt")				==null? 0:AddUtil.parseDigit(request.getParameter("sh_amt")));
	fee_etc.setSh_ja			(request.getParameter("sh_ja")				==null? 0:AddUtil.parseFloat(request.getParameter("sh_ja")));
	fee_etc.setSh_km			(request.getParameter("sh_km")				==null? 0:AddUtil.parseDigit(request.getParameter("sh_km")));
	fee_etc.setSh_km_bas_dt		(request.getParameter("sh_km_bas_dt")		==null?"":request.getParameter("sh_km_bas_dt"));
	fee_etc.setBus_agnt_id		(request.getParameter("bus_agnt_id")		==null?"":request.getParameter("bus_agnt_id"));
	fee_etc.setBus_agnt_per		(request.getParameter("bus_agnt_per")		==null? 0:AddUtil.parseFloat(request.getParameter("bus_agnt_per")));
	fee_etc.setBus_agnt_r_per	(request.getParameter("bus_agnt_r_per")		==null? 0:AddUtil.parseFloat(request.getParameter("bus_agnt_r_per")));
	fee_etc.setCls_n_mon		(request.getParameter("cls_n_mon")			==null?"":request.getParameter("cls_n_mon"));
	fee_etc.setBc_b_e1			(request.getParameter("bc_b_e1")			==null? 0:AddUtil.parseFloat(request.getParameter("bc_b_e1")));
	fee_etc.setBc_b_e2			(request.getParameter("bc_b_e2")			==null? 0:AddUtil.parseDigit(request.getParameter("bc_b_e2")));
	fee_etc.setSh_tot_km		(request.getParameter("sh_tot_km")			==null? 0:AddUtil.parseDigit(request.getParameter("sh_tot_km")));
	fee_etc.setSh_init_reg_dt	(request.getParameter("sh_init_reg_dt")		==null?"":request.getParameter("sh_init_reg_dt"));
	fee_etc.setBc_b_g			(request.getParameter("bc_b_g")				==null? 0:AddUtil.parseDigit(request.getParameter("bc_b_g")));
	fee_etc.setBc_b_u			(request.getParameter("bc_b_u")				==null? 0:AddUtil.parseDigit(request.getParameter("bc_b_u")));
	fee_etc.setBc_b_ac			(request.getParameter("bc_b_ac")			==null? 0:AddUtil.parseDigit(request.getParameter("bc_b_ac")));
	fee_etc.setBc_b_g_cont		(request.getParameter("bc_b_g_cont")		==null?"":request.getParameter("bc_b_g_cont"));
	fee_etc.setBc_b_u_cont		(request.getParameter("bc_b_u_cont")		==null?"":request.getParameter("bc_b_u_cont"));
	fee_etc.setBc_b_ac_cont		(request.getParameter("bc_b_ac_cont")		==null?"":request.getParameter("bc_b_ac_cont"));
	fee_etc.setBc_etc			(request.getParameter("bc_etc")				==null?"":request.getParameter("bc_etc"));
	fee_etc.setCon_etc			(request.getParameter("con_etc")			==null?"":request.getParameter("con_etc"));
	fee_etc.setAgree_dist_yn	(request.getParameter("agree_dist_yn")		==null?"":request.getParameter("agree_dist_yn"));
	fee_etc.setAgree_dist		(request.getParameter("agree_dist")			==null? 0:AddUtil.parseDigit(request.getParameter("agree_dist")));
	fee_etc.setOver_run_amt		(request.getParameter("over_run_amt")		==null? 0:AddUtil.parseDigit(request.getParameter("over_run_amt")));
	fee_etc.setDriver_add_amt	(request.getParameter("driver_add_amt")		==null? 0:AddUtil.parseDigit(request.getParameter("driver_add_amt")));	
	fee_etc.setDriver_add_v_amt	(request.getParameter("driver_add_v_amt")	==null? 0:AddUtil.parseDigit(request.getParameter("driver_add_v_amt")));	////운전자추가요금 부가세 추가(2018.03.30)
	//fee_etc.setOver_bas_km		(request.getParameter("over_bas_km")	==null? 0:AddUtil.parseDigit(request.getParameter("over_bas_km")));
	fee_etc.setRtn_run_amt		(request.getParameter("rtn_run_amt")	==null? 0:AddUtil.parseDigit(request.getParameter("rtn_run_amt")));
	fee_etc.setRtn_run_amt_yn	(request.getParameter("rtn_run_amt_yn")	==null?"":request.getParameter("rtn_run_amt_yn"));
	
	if(fee_etc.getRent_l_cd().equals("")){
		fee_etc.setRent_mng_id		(rent_mng_id);
		fee_etc.setRent_l_cd		(rent_l_cd);
		fee_etc.setRent_st		(rent_st);
		//=====[fee_etc] insert=====
		flag1 = a_db.insertFeeEtc(fee_etc);
	}else{
		//=====[fee_etc] update=====
		flag1 = a_db.updateFeeEtc(fee_etc);
	}
	
	flag1 = a_db.updateFeeEtcCngCheckInit(rent_mng_id, rent_l_cd, rent_st, nm_db.getWorkAuthUser("연장/승계담당자"), "계약연장");





	//대여정보-------------------------------------------------------------------------------------------
	
	
	//fee
	ContFeeBean fee = a_db.getContFeeNew(rent_mng_id, rent_l_cd, Integer.toString(fee_size));
	
	fee.setRent_st			(rent_st);//연장 일련번호
	fee.setExt_agnt			(request.getParameter("ext_agnt")	==null? "":request.getParameter("ext_agnt"));
	fee.setRent_dt			(request.getParameter("rent_dt")	==null? "":request.getParameter("rent_dt"));
	fee.setCon_mon			(request.getParameter("con_mon")		==null?"":request.getParameter("con_mon"));
	fee.setRent_start_dt	(request.getParameter("rent_start_dt")	==null?"":request.getParameter("rent_start_dt"));
	fee.setRent_end_dt		(request.getParameter("rent_end_dt")	==null?"":request.getParameter("rent_end_dt"));
	
	fee.setGrt_amt_s		(request.getParameter("grt_s_amt")		==null? 0:AddUtil.parseDigit(request.getParameter("grt_s_amt")));
	fee.setGur_per			(request.getParameter("gur_per")		==null? 0:AddUtil.parseFloat(request.getParameter("gur_per")));
	fee.setGur_p_per		(request.getParameter("gur_p_per")		==null? 0:AddUtil.parseFloat(request.getParameter("gur_p_per")));
	fee.setGrt_suc_yn		(request.getParameter("grt_suc_yn")		==null?"":request.getParameter("grt_suc_yn"));
	
	if(!fee.getGrt_suc_yn().equals("1") && fee.getGrt_amt_s()>0){
		fee.setGrt_suc_yn("0");
	}
	
	fee.setPp_s_amt			(request.getParameter("pp_s_amt")		==null? 0:AddUtil.parseDigit(request.getParameter("pp_s_amt")));
	fee.setPp_v_amt			(request.getParameter("pp_v_amt")		==null? 0:AddUtil.parseDigit(request.getParameter("pp_v_amt")));
	fee.setPere_per			(request.getParameter("pere_per")		==null? 0:AddUtil.parseFloat(request.getParameter("pere_per")));
	fee.setPere_r_per		(request.getParameter("pere_r_per")		==null? 0:AddUtil.parseFloat(request.getParameter("pere_r_per")));
	fee.setPp_est_dt		(request.getParameter("pp_est_dt")		==null?"":request.getParameter("pp_est_dt"));
	
	if(fee.getPp_est_dt().equals("")){
		fee.setPp_est_dt	(request.getParameter("rent_start_dt")		==null?"":request.getParameter("rent_start_dt"));
	}
	
	fee.setIfee_s_amt		(request.getParameter("ifee_s_amt")		==null? 0:AddUtil.parseDigit(request.getParameter("ifee_s_amt")));
	fee.setIfee_v_amt		(request.getParameter("ifee_v_amt")		==null? 0:AddUtil.parseDigit(request.getParameter("ifee_v_amt")));
	fee.setPere_mth			(request.getParameter("pere_mth")		==null? 0:AddUtil.parseDigit(request.getParameter("pere_mth")));
	fee.setPere_r_mth		(request.getParameter("pere_r_mth")		==null? 0:AddUtil.parseDigit(request.getParameter("pere_r_mth")));
	fee.setIfee_suc_yn		(request.getParameter("ifee_suc_yn")	==null?"":request.getParameter("ifee_suc_yn"));	
	
	if(!fee.getIfee_suc_yn().equals("1") && fee.getIfee_s_amt()>0){
		fee.setIfee_suc_yn("0");
	}
	
	fee.setOpt_s_amt		(request.getParameter("opt_s_amt")		==null? 0:AddUtil.parseDigit(request.getParameter("opt_s_amt")));
	fee.setOpt_v_amt		(request.getParameter("opt_v_amt")		==null? 0:AddUtil.parseDigit(request.getParameter("opt_v_amt")));
	fee.setOpt_chk			(request.getParameter("opt_chk")		==null?"":request.getParameter("opt_chk"));
	fee.setOpt_per			(request.getParameter("opt_per")		==null?"":request.getParameter("opt_per"));
	
	if(!fee.getOpt_chk().equals("1") && fee.getOpt_s_amt()>0){
		fee.setOpt_chk("1");
	}
	
	fee.setMax_ja			(request.getParameter("max_ja")			==null? 0:AddUtil.parseFloat(request.getParameter("max_ja")));
	fee.setApp_ja			(request.getParameter("app_ja")			==null? 0:AddUtil.parseFloat(request.getParameter("app_ja")));
	fee.setJa_s_amt			(request.getParameter("ja_s_amt")		==null? 0:AddUtil.parseDigit(request.getParameter("ja_s_amt")));
	fee.setJa_v_amt			(request.getParameter("ja_v_amt")		==null? 0:AddUtil.parseDigit(request.getParameter("ja_v_amt")));
	fee.setJa_r_s_amt		(request.getParameter("ja_r_s_amt")		==null? 0:AddUtil.parseDigit(request.getParameter("ja_r_s_amt")));
	fee.setJa_r_v_amt		(request.getParameter("ja_r_v_amt")		==null? 0:AddUtil.parseDigit(request.getParameter("ja_r_v_amt")));
	
	fee.setFee_s_amt		(request.getParameter("fee_s_amt")		==null? 0:AddUtil.parseDigit(request.getParameter("fee_s_amt")));
	fee.setFee_v_amt		(request.getParameter("fee_v_amt")		==null? 0:AddUtil.parseDigit(request.getParameter("fee_v_amt")));
	fee.setInv_s_amt		(request.getParameter("inv_s_amt")		==null? 0:AddUtil.parseDigit(request.getParameter("inv_s_amt")));
	fee.setInv_v_amt		(request.getParameter("inv_v_amt")		==null? 0:AddUtil.parseDigit(request.getParameter("inv_v_amt")));
	fee.setDc_ra			(request.getParameter("dc_ra")			==null? 0:AddUtil.parseFloat(request.getParameter("dc_ra")));
	fee.setBas_dt			(request.getParameter("bas_dt")			==null?"":request.getParameter("bas_dt"));
	
	fee.setCls_per			(request.getParameter("cls_per")		==null?"":request.getParameter("cls_per"));
	fee.setCls_r_per		(request.getParameter("cls_r_per")		==null? 0:AddUtil.parseFloat(request.getParameter("cls_r_per")));
	fee.setCls_n_per		(0);
	
	fee.setCredit_per		(request.getParameter("credit_per")		==null? 0:AddUtil.parseFloat(request.getParameter("credit_per")));
	fee.setCredit_r_per		(request.getParameter("credit_r_per")	==null? 0:AddUtil.parseFloat(request.getParameter("credit_r_per")));
	fee.setCredit_amt		(request.getParameter("credit_amt")		==null? 0:AddUtil.parseDigit(request.getParameter("credit_amt")));
	fee.setCredit_r_amt		(request.getParameter("credit_r_amt")	==null? 0:AddUtil.parseDigit(request.getParameter("credit_r_amt")));
	
	fee.setFee_sac_id		(request.getParameter("fee_sac_id")		==null?"":request.getParameter("fee_sac_id"));
	fee.setFee_pay_tm		(request.getParameter("fee_pay_tm")		==null?"":request.getParameter("fee_pay_tm"));
	fee.setFee_est_day		(request.getParameter("fee_est_day")	==null?"":request.getParameter("fee_est_day"));
	fee.setFee_pay_start_dt	(request.getParameter("fee_pay_start_dt")==null?"":request.getParameter("fee_pay_start_dt"));
	fee.setFee_pay_end_dt	(request.getParameter("fee_pay_end_dt")	==null?"":request.getParameter("fee_pay_end_dt"));
	fee.setFee_cdt			(request.getParameter("fee_cdt")		==null?"":request.getParameter("fee_cdt"));	
	
	fee.setFee_fst_dt		(request.getParameter("fee_fst_dt")		==null?"":request.getParameter("fee_fst_dt"));
	fee.setFee_fst_amt		(request.getParameter("fee_fst_amt")	==null? 0:AddUtil.parseDigit(request.getParameter("fee_fst_amt")));
	
	fee.setF_opt_per			(request.getParameter("f_opt_per")		==null?"":request.getParameter("f_opt_per"));
	fee.setF_gur_p_per		(request.getParameter("f_gur_p_per")	==null?"":request.getParameter("f_gur_p_per"));
	fee.setF_pere_r_per		(request.getParameter("f_pere_r_per")	==null?"":request.getParameter("f_pere_r_per"));
	fee.setRent_way				(request.getParameter("rent_way")==null?"":request.getParameter("rent_way"));
	
	fee.setIns_s_amt		(request.getParameter("ins_s_amt")		==null? 0:AddUtil.parseDigit(request.getParameter("ins_s_amt")));
	fee.setIns_v_amt		(request.getParameter("ins_v_amt")		==null? 0:AddUtil.parseDigit(request.getParameter("ins_v_amt")));
	fee.setIns_total_amt	(request.getParameter("ins_total_amt")	==null? 0:AddUtil.parseDigit(request.getParameter("ins_total_amt")));
	
	/*
	fee.setFee_sh			(request.getParameter("fee_sh")			==null?"":request.getParameter("fee_sh"));
	fee.setFee_pay_st		(request.getParameter("fee_pay_st")		==null?"":request.getParameter("fee_pay_st"));
	fee.setFee_bank			(request.getParameter("fee_bank")		==null?"":request.getParameter("fee_bank"));
	fee.setDef_st			(request.getParameter("def_st")			==null?"":request.getParameter("def_st"));
	fee.setDef_remark		(request.getParameter("def_remark")		==null?"":request.getParameter("def_remark"));
	fee.setDef_sac_id		(request.getParameter("def_sac_id")		==null?"":request.getParameter("def_sac_id"));
	fee.setPrv_dlv_yn		(request.getParameter("prv_dlv_yn")		==null?"":request.getParameter("prv_dlv_yn"));
	*/
	
	
	//사용자 정보 조회
	UsersBean sender_bean 	= umd.getUsersBean(fee.getExt_agnt());
	fee.setBrch_id			(sender_bean.getBr_id());

	
//	if(fee.getRent_l_cd().equals("")){
		fee.setRent_mng_id		(rent_mng_id);
		fee.setRent_l_cd		(rent_l_cd);
		//=====[fee] insert=====
		flag5 = a_db.insertContFee(fee);
//	}
	
	//=====[fee] update=====
	flag5 = a_db.updateContFeeNew(fee);
	
	
	

	
	
	//선수금 스케줄 생성
	
	/*보증금, 선납금, 개시대여료 table에 insert해준다*/
	ExtScdBean grt = new ExtScdBean();
	grt.setRent_mng_id(rent_mng_id);
	grt.setRent_l_cd	(rent_l_cd);
	grt.setRent_st		(rent_st);
	grt.setRent_seq		("1");
	grt.setExt_id			("0");
	grt.setExt_st			("0");					//0:보증금
	grt.setExt_tm			("1");
	grt.setExt_est_dt	(fee.getPp_est_dt());
	grt.setExt_s_amt	(0);  //초기화 (20071224 :승계인 경우는 0로)
	grt.setExt_v_amt	(0);  //초기화 
	//금액 별도일때(위 대여에 대한 승계가 아님)
	if(fee.getGrt_suc_yn().equals("1")){
		grt.setExt_s_amt	(fee.getGrt_amt_s());	//보증금은 부가세 없다
		grt.setExt_v_amt	(0);
	}
	grt.setUpdate_id	(user_id);
	if(grt.getExt_s_amt()==0){
		grt.setExt_est_dt	("");
	}	
	if(!ae_db.insertGrt(grt))		flag += 1;
	
	
	ExtScdBean pp = new ExtScdBean();
	//선납금
	pp.setRent_mng_id	(rent_mng_id);
	pp.setRent_l_cd		(rent_l_cd);
	pp.setRent_st			(rent_st);
	pp.setExt_st			("1");					//1:선납금
	pp.setExt_tm			("1");
	pp.setRent_seq		("1");
	pp.setExt_id			("0");
	pp.setExt_est_dt	(fee.getPp_est_dt());
	pp.setExt_s_amt		(fee.getPp_s_amt());
	pp.setExt_v_amt		(fee.getPp_v_amt());
	pp.setUpdate_id		(user_id);
	if(pp.getExt_s_amt()==0){
		pp.setExt_est_dt	("");
	}
	if(!ae_db.insertGrt(pp))	flag += 1;

	ExtScdBean ifee = new ExtScdBean();
	//개시대여료
	ifee.setRent_mng_id	(rent_mng_id);
	ifee.setRent_l_cd		(rent_l_cd);
	ifee.setRent_st			(rent_st);
	ifee.setRent_seq		("1");
	ifee.setExt_id			("0");
	ifee.setExt_st			("2");					//2:개시대여료
	ifee.setExt_tm			("1");
	ifee.setExt_est_dt	(fee.getPp_est_dt());
	//금액 별도일때(위 대여에 대한 승계가 아님)
	if(fee.getIfee_suc_yn().equals("1")){
		ifee.setExt_s_amt(fee.getIfee_s_amt());
		ifee.setExt_v_amt(fee.getIfee_v_amt());
	}
	ifee.setUpdate_id	(user_id);
	if(ifee.getExt_s_amt()==0){
		ifee.setExt_est_dt	("");
	}
	if(!ae_db.insertGrt(ifee))	flag += 1;


	//보험약정/계약이 틀린경우 메시지 발송
	String ins_chk1 	= request.getParameter("ins_chk1")==null?"":request.getParameter("ins_chk1");
	String ins_chk2 	= request.getParameter("ins_chk2")==null?"":request.getParameter("ins_chk2");
	String ins_chk3 	= request.getParameter("ins_chk3")==null?"":request.getParameter("ins_chk3");
	
	//cont_etc
	ContEtcBean cont_etc = a_db.getContEtc(rent_mng_id, rent_l_cd);
	
	String o_com_emp_yn = cont_etc.getCom_emp_yn();
	String n_com_emp_yn = request.getParameter("com_emp_yn")		==null?"":request.getParameter("com_emp_yn");
	
	cont_etc.setInsur_per				(request.getParameter("insur_per")	==null?"":request.getParameter("insur_per"));
	cont_etc.setInsurant				(request.getParameter("insurant")	==null?"":request.getParameter("insurant"));
	cont_etc.setClient_share_st	(request.getParameter("client_share_st")==null?"":request.getParameter("client_share_st"));
	cont_etc.setCom_emp_yn			(request.getParameter("com_emp_yn")		==null?"":request.getParameter("com_emp_yn"));	
	
	if(fee.getRent_way().equals("1")){
		cont_etc.setMain_yn		("Y");
		cont_etc.setMa_dae_yn	("Y");
	}else{
		cont_etc.setMain_yn		("");
		cont_etc.setMa_dae_yn	("");
	}
	
	if(cont_etc.getRent_mng_id().equals("")){
		//=====[cont_etc] update=====
		cont_etc.setRent_mng_id	(rent_mng_id);
		cont_etc.setRent_l_cd	(rent_l_cd);
		flag3 = a_db.insertContEtc(cont_etc);
	}else{
		//=====[cont_etc] update=====
		flag3 = a_db.updateContEtc(cont_etc);
	}
	
	if(!ins_chk1.equals("") || !ins_chk2.equals("") || !ins_chk3.equals("") ){
		
			//2. 쿨메신저 메세지 전송------------------------------------------------------------------------------------------
			
			String firm_nm	= request.getParameter("firm_nm")==null?"":request.getParameter("firm_nm");
			String sub 		= "보험 현재 가입과 약정이 틀림";
			String cont 	= "보험 현재 가입과 약정이 틀림 &lt;br&gt; &lt;br&gt; [ "+rent_l_cd+" "+firm_nm+" ]  &lt;br&gt; &lt;br&gt; "+ins_chk1+"  &lt;br&gt; &lt;br&gt; "+ins_chk2+"  &lt;br&gt; &lt;br&gt; "+ins_chk3+" &lt;br&gt; &lt;br&gt; ";
			String target_id = nm_db.getWorkAuthUser("부산보험담당");
			
			cont = cont + ec_db.getContCngInsCngMsg(rent_mng_id, rent_l_cd, rent_st);
			
			//보험변경요청 프로시저 호출
			String  d_flag2 =  ec_db.call_sp_ins_cng_req(sub, rent_mng_id, rent_l_cd, rent_st);
			
			//if(base.getBrch_id().equals("B1")||base.getBrch_id().equals("N1")) 	target_id = nm_db.getWorkAuthUser("부산차량등록자");
			
			CarSchDatabase csd = CarSchDatabase.getInstance();
			CarScheBean cs_bean = csd.getCarScheTodayBean(target_id);
			if(!cs_bean.getUser_id().equals("")){
				target_id = nm_db.getWorkAuthUser("본사보험담당");
			}
			
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
			
			//flag12 = cm_db.insertCoolMsg(msg);
		
	}
	
	if(!o_com_emp_yn.equals(n_com_emp_yn)){
		//법인 임직원 한전운전 관련 보험담당자 메시지 발송		
		if(AddUtil.parseInt(cm_bean.getS_st())>101 && AddUtil.parseInt(cm_bean.getS_st()) < 600 && AddUtil.parseInt(cm_bean.getS_st()) != 409){	
			if(client_st.equals("1") || base.getCar_st().equals("5")){
			
				//2. 쿨메신저 메세지 전송------------------------------------------------------------------------------------------
			
				String firm_nm	= request.getParameter("firm_nm")==null?"":request.getParameter("firm_nm");
				String sub 		= "연장등록 임직원전용보험 내용 변경";									
				String cont 		= "[ "+rent_l_cd+" "+firm_nm+" "+car_no+"]  &lt;br&gt; &lt;br&gt; 임직원전용보험 가입대상인 연장계약이 등록되었습니다.  &lt;br&gt; &lt;br&gt; 임직원운전한정특약 내용이 변경 되었으니 확인하시기 바랍니다.";
				String url 		= "/fms2/lc_rent/lc_b_s.jsp?rent_mng_id="+rent_mng_id+"|rent_l_cd="+rent_l_cd;
				String target_id 	= nm_db.getWorkAuthUser("부산보험담당");
				String m_url = "/fms2/lc_rent/lc_b_frame.jsp";
				if(base.getCar_st().equals("5")){
					sub = "업무대여 연장등록 임직원전용보험 내용 변경";
					cont 		= "[ "+rent_l_cd+" "+firm_nm+" "+car_no+"]  &lt;br&gt; &lt;br&gt; 임직원전용보험 가입대상인 업무대여가 등록되었습니다.  &lt;br&gt; &lt;br&gt; 임직원운전한정특약 내용이 변경 되었으니 확인하시기 바랍니다.";
				}	
				
				cont = cont + ec_db.getContCngInsCngMsg(rent_mng_id, rent_l_cd, rent_st);
				
				//보험변경요청 프로시저 호출
				String  d_flag2 =  ec_db.call_sp_ins_cng_req(sub, rent_mng_id, rent_l_cd, rent_st);
									
				CarSchDatabase csd = CarSchDatabase.getInstance();
				CarScheBean cs_bean = csd.getCarScheTodayBean(target_id);
				if(!cs_bean.getUser_id().equals("")){
					target_id = nm_db.getWorkAuthUser("본사보험담당");
					//보험담당자 모두 휴가일때
					cs_bean = csd.getCarScheTodayBean(target_id);
					if(!cs_bean.getWork_id().equals("")) target_id = cs_bean.getWork_id();
				}
			
				//사용자 정보 조회
				UsersBean target_bean 	= umd.getUsersBean(target_id);				
			
				String xml_data = "";
				xml_data =  "<COOLMSG>"+
		  				"<ALERTMSG>"+
  						"    <BACKIMG>4</BACKIMG>"+
  						"    <MSGTYPE>104</MSGTYPE>"+
  						"    <SUB>"+sub+"</SUB>"+
		  				"    <CONT>"+cont+"</CONT>"+
 						"    <URL>http://fms1.amazoncar.co.kr/fms2/coolmsg/cool_index.jsp?id=%ID&pass=%PASS&url="+url+"&m_url="+m_url+"</URL>";
				xml_data += "    <TARGET>"+target_bean.getId()+"</TARGET>";
				xml_data += "    <SENDER>"+sender_bean.getId()+"</SENDER>"+
  						"    <MSGICON>10</MSGICON>"+
  						"    <MSGSAVE>1</MSGSAVE>"+
  						"    <LEAVEDMSG>1</LEAVEDMSG>"+
		  				"    <FLDTYPE>1</FLDTYPE>"+
  						"  </ALERTMSG>"+
  						"</COOLMSG>";
			
				CdAlertBean msg = new CdAlertBean();
				msg.setFlddata(xml_data);
				msg.setFldtype("1");
						
				//flag12 = cm_db.insertCoolMsg(msg);
			}
		}	
	}
	

	//이행보증보험-----------------------------------------------------------------------------------------------
	
	//gua_ins
	ContGiInsBean gins 	= a_db.getContGiInsNew(rent_mng_id, rent_l_cd, rent_st);
	
	
	gins.setGi_no		("[연장]"+rent_st);
	gins.setGi_reason	("");
	gins.setGi_sac_id	("");
	gins.setGi_jijum	(request.getParameter("gi_jijum")==null?"":request.getParameter("gi_jijum"));
	gins.setGi_amt		(request.getParameter("gi_amt")	==null? 0:AddUtil.parseDigit(request.getParameter("gi_amt")));
	gins.setGi_fee		(request.getParameter("gi_fee")	==null? 0:AddUtil.parseDigit(request.getParameter("gi_fee")));
	
	
	String gi_st = request.getParameter("gi_st")==null?"0":request.getParameter("gi_st");
	
	if(gi_st.equals("1") && gins.getGi_jijum().equals("") && gins.getGi_amt() == 0 && gins.getGi_fee() == 0){
		gi_st = "0";
	}

	if(gi_st.equals("0") && gins.getGi_amt() > 0 && gins.getGi_fee() > 0){
		gi_st = "1";
	}
	gins.setGi_st		(gi_st);
	
	//car_etc	
	car.setGi_st		(gi_st);
	//=====[car_etc] update=====
	flag1 = a_db.updateContCarNew(car);
	
	if(gi_st.equals("1") && ( !gins.getGi_jijum().equals("") || gins.getGi_amt() > 0 )){
				
				//이행보증보험 가입여부 보증보험담당자에게 메시지 통보
						
				UsersBean gins_target_bean 	= umd.getUsersBean(nm_db.getWorkAuthUser("보증보험담당자"));
										
				String xml_data3 = "";
				xml_data3 =  "<COOLMSG>"+
		  				"<ALERTMSG>"+
  						"    <BACKIMG>4</BACKIMG>"+
  						"    <MSGTYPE>104</MSGTYPE>"+
  						"    <SUB>보증보험가입 연장계약등록</SUB>"+
		  				"    <CONT>보증보험가입 연장계약등록 : "+rent_l_cd+"</CONT>"+
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
			gins.setRent_st		(rent_st);
			flag2 = a_db.insertGiInsNew(gins);
		}else{
			//=====[gua_ins] update=====
			flag2 = a_db.updateGiInsNew(gins);
		}	


	
%>
<form name='form1' method='post'>
  <input type="hidden" name="auth_rw" 			value="<%=auth_rw%>">
  <input type="hidden" name="user_id" 			value="<%=user_id%>">
  <input type="hidden" name="br_id" 			value="<%=br_id%>">    
  <input type="hidden" name="rent_mng_id" 		value="<%=rent_mng_id%>">
  <input type="hidden" name="rent_l_cd" 		value="<%=rent_l_cd%>">  
  <input type="hidden" name="rent_st" 			value="<%=rent_st%>">    
  <input type="hidden" name="c_st" 				value="fee">    
  <input type="hidden" name="now_stat" 			value="연장">      
</form>
<script language='javascript'>
	var fm = document.form1;

	
<%		if(!flag2){	%>
		alert('계약기본정보 등록 에러입니다.\n\n확인하십시오');
<%		}	%>		

<%		if(!flag5){	%>
		alert('대여정보 등록 에러입니다.\n\n확인하십시오');
<%		}	%>		

<%		if(!flag6){	%>
		alert('선수금스케줄 등록 에러입니다.\n\n확인하십시오');
<%		}	%>		

<%		if(!flag1){	%>
		alert('대여기타정보 등록 에러입니다.\n\n확인하십시오');
<%		}	%>		

	fm.action = 'lc_b_s.jsp';	
	fm.target = 'd_content';
	fm.submit();

</script>
</body>
</html>