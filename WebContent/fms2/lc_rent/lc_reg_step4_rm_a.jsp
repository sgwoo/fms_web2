<%@ page language="java" contentType="text/html;charset=euc-kr" %>
<%@ page import="java.util.*, acar.common.*, acar.util.*"%>
<%@ page import="acar.cont.*, acar.car_mst.*, acar.car_office.*, acar.res_search.*,  acar.ext.*, acar.client.*"%>
<%@ page import="acar.coolmsg.*, acar.user_mng.*, acar.car_sche.*, acar.estimate_mng.*, acar.short_fee_mng.*, acar.res_search.*"%>
<jsp:useBean id="a_db" scope="page" class="acar.cont.AddContDatabase"/>
<jsp:useBean id="ae_db" scope="page" class="acar.ext.AddExtDatabase"/>
<jsp:useBean id="cm_bean" class="acar.car_mst.CarMstBean" scope="page"/>
<jsp:useBean id="rs_db" scope="page" class="acar.res_search.ResSearchDatabase"/>
<jsp:useBean id="coe_bean" class="acar.car_office.CarOffEmpBean" scope="page"/>
<jsp:useBean id="cm_db" scope="page" class="acar.coolmsg.CoolMsgDatabase"/>
<jsp:useBean id="al_db" scope="page" class="acar.client.AddClientDatabase"/>
<jsp:useBean id="sfm_db" scope="page" class="acar.short_fee_mng.ShortFeeMngDatabase"/>
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
	String old_rent_mng_id 	= request.getParameter("old_rent_mng_id")==null?"":request.getParameter("old_rent_mng_id");
	String old_rent_l_cd 	= request.getParameter("old_rent_l_cd")==null?"":request.getParameter("old_rent_l_cd");
	
	String car_gu 		= request.getParameter("car_gu")==null?"1":request.getParameter("car_gu");//신차1,기존0
	String car_st 		= request.getParameter("car_st")==null?"":request.getParameter("car_st");
	
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
	int count 	= 1;
	
	CommonDataBase c_db = CommonDataBase.getInstance();
	MaMenuDatabase nm_db = MaMenuDatabase.getInstance();
	UserMngDatabase umd = UserMngDatabase.getInstance();
	AddCarMstDatabase cmb = AddCarMstDatabase.getInstance();
	EstiDatabase 		e_db 	= EstiDatabase.getInstance();
	CarSchDatabase csd = CarSchDatabase.getInstance();


	//차량기본정보-----------------------------------------------------------------------------------------------
	
	//car_etc
	ContCarBean car 	= a_db.getContCarNew(rent_mng_id, rent_l_cd);
	

	car.setSh_car_amt	(request.getParameter("sh_car_amt")	==null? 0:AddUtil.parseDigit(request.getParameter("sh_car_amt")));
	car.setSh_year		(request.getParameter("sh_year")	==null?"":request.getParameter("sh_year"));
	car.setSh_month		(request.getParameter("sh_month")	==null?"":request.getParameter("sh_month"));
	car.setSh_day		(request.getParameter("sh_day")		==null?"":request.getParameter("sh_day"));
	car.setSh_day_bas_dt	(request.getParameter("sh_day_bas_dt")	==null?"":request.getParameter("sh_day_bas_dt"));
	car.setSh_amt		(request.getParameter("sh_amt")		==null? 0:AddUtil.parseDigit(request.getParameter("sh_amt")));
	car.setSh_ja		(request.getParameter("sh_ja")		==null? 0:AddUtil.parseFloat(request.getParameter("sh_ja")));
	car.setSh_km		(request.getParameter("sh_km")		==null? 0:AddUtil.parseDigit(request.getParameter("sh_km")));
	car.setSh_tot_km	(request.getParameter("sh_tot_km")	==null? 0:AddUtil.parseDigit(request.getParameter("sh_tot_km")));
	car.setSh_km_bas_dt	(request.getParameter("sh_km_bas_dt")	==null?"":request.getParameter("sh_km_bas_dt"));		
	car.setRemark		(request.getParameter("remark")		==null?"":request.getParameter("remark"));
	car.setImm_amt		(request.getParameter("imm_amt")	==null? 0:AddUtil.parseDigit(request.getParameter("imm_amt")));
	
	
	//=====[car_etc] update=====
	flag1 = a_db.updateContCarNew(car);


	//계약기본정보-----------------------------------------------------------------------------------------------
	
	//cont
	ContBaseBean base = a_db.getCont(rent_mng_id, rent_l_cd);
	
	base.setDriving_ext	(request.getParameter("driving_ext")	==null?"":request.getParameter("driving_ext"));
	base.setDriving_age	(request.getParameter("driving_age")	==null?"":request.getParameter("driving_age"));
	base.setGcp_kd		(request.getParameter("gcp_kd")		==null?"":request.getParameter("gcp_kd"));
	base.setBacdt_kd	(request.getParameter("bacdt_kd")	==null?"":request.getParameter("bacdt_kd"));
	base.setCar_ja		(request.getParameter("car_ja")		==null? 0:AddUtil.parseDigit(request.getParameter("car_ja")));
	base.setRent_start_dt	(request.getParameter("rent_start_dt")	==null?"":request.getParameter("rent_start_dt"));
	base.setRent_end_dt	(request.getParameter("rent_end_dt")	==null?"":request.getParameter("rent_end_dt"));
	base.setTax_type	(request.getParameter("tax_type")	==null?"1":request.getParameter("tax_type"));
	base.setBus_st		(request.getParameter("bus_st")		==null?"":request.getParameter("bus_st"));
	base.setReg_step	("4");
	base.setUse_yn		("Y");	
	
	
	
	//=====[cont] update=====
	flag2 = a_db.updateContBaseNew(base);


	//계약기타정보-----------------------------------------------------------------------------------------------
	
	//cont_etc
	ContEtcBean cont_etc = a_db.getContEtc(rent_mng_id, rent_l_cd);
	
	cont_etc.setInsur_per	(request.getParameter("insur_per")	==null?"":request.getParameter("insur_per"));
	cont_etc.setInsurant	(request.getParameter("insurant")	==null?"":request.getParameter("insurant"));
	cont_etc.setCanoisr_yn	(request.getParameter("canoisr_yn")	==null?"":request.getParameter("canoisr_yn"));
	cont_etc.setCacdt_yn	(request.getParameter("cacdt_yn")	==null?"":request.getParameter("cacdt_yn"));
	cont_etc.setEme_yn	(request.getParameter("eme_yn")		==null?"":request.getParameter("eme_yn"));
	cont_etc.setJa_reason	(request.getParameter("ja_reason")	==null?"":request.getParameter("ja_reason"));
	cont_etc.setRea_appr_id	(request.getParameter("rea_appr_id")	==null?"":request.getParameter("rea_appr_id"));
	cont_etc.setRec_st	(request.getParameter("rec_st")		==null?"":request.getParameter("rec_st"));
	cont_etc.setEle_tax_st	(request.getParameter("ele_tax_st")	==null?"":request.getParameter("ele_tax_st"));
	cont_etc.setTax_extra	(request.getParameter("tax_extra")	==null?"":request.getParameter("tax_extra"));
	cont_etc.setGrt_suc_m_id(request.getParameter("grt_suc_m_id")	==null?"":request.getParameter("grt_suc_m_id"));
	cont_etc.setGrt_suc_l_cd(request.getParameter("grt_suc_l_cd")	==null?"":request.getParameter("grt_suc_l_cd"));
	cont_etc.setGrt_suc_c_no(request.getParameter("grt_suc_c_no")	==null?"":request.getParameter("grt_suc_c_no"));
	cont_etc.setGrt_suc_o_amt(request.getParameter("grt_suc_o_amt")	==null? 0:AddUtil.parseDigit(request.getParameter("grt_suc_o_amt")));
	cont_etc.setGrt_suc_r_amt(request.getParameter("grt_suc_r_amt")	==null? 0:AddUtil.parseDigit(request.getParameter("grt_suc_r_amt")));
	cont_etc.setCom_emp_yn	(request.getParameter("com_emp_yn")	==null?"":request.getParameter("com_emp_yn"));
	cont_etc.setCls_etc	(request.getParameter("cls_etc")		==null?"":request.getParameter("cls_etc"));
	
	
	if(cont_etc.getRent_mng_id().equals("")){
		//=====[cont_etc] insert=====
		cont_etc.setRent_mng_id	(rent_mng_id);
		cont_etc.setRent_l_cd	(rent_l_cd);
		flag3 = a_db.insertContEtc(cont_etc);
	}else{
		//=====[cont_etc] update=====
		flag3 = a_db.updateContEtc(cont_etc);
	}






	//대여정보-------------------------------------------------------------------------------------------
	
	//fee
	ContFeeBean fee = a_db.getContFeeNew(rent_mng_id, rent_l_cd, "1");
	

		
		fee.setCon_mon			(request.getParameter("con_mon")		==null?"":request.getParameter("con_mon"));
	
//		fee.setRent_start_dt		(request.getParameter("rent_start_dt")		==null?"":request.getParameter("rent_start_dt"));
//		fee.setRent_end_dt		(request.getParameter("rent_end_dt")		==null?"":request.getParameter("rent_end_dt"));
		fee.setGur_per			(request.getParameter("gur_per")		==null? 0:AddUtil.parseFloat(request.getParameter("gur_per")));
		fee.setGur_p_per		(request.getParameter("gur_p_per")		==null? 0:AddUtil.parseFloat(request.getParameter("gur_p_per")));
		fee.setCls_per			(request.getParameter("cls_per")		==null?"":request.getParameter("cls_per"));
		fee.setCls_r_per		(request.getParameter("cls_r_per")		==null? 0:AddUtil.parseFloat(request.getParameter("cls_r_per")));
		fee.setDc_ra			(request.getParameter("dc_ra")			==null? 0:AddUtil.parseFloat(request.getParameter("dc_ra")));
		fee.setGrt_amt_s		(request.getParameter("grt_s_amt")		==null? 0:AddUtil.parseDigit(request.getParameter("grt_s_amt")));
		fee.setFee_s_amt		(request.getParameter("fee_s_amt")		==null? 0:AddUtil.parseDigit(request.getParameter("fee_s_amt")));
		fee.setFee_v_amt		(request.getParameter("fee_v_amt")		==null? 0:AddUtil.parseDigit(request.getParameter("fee_v_amt")));
		fee.setInv_s_amt		(request.getParameter("inv_s_amt")		==null? 0:AddUtil.parseDigit(request.getParameter("inv_s_amt")));
		fee.setInv_v_amt		(request.getParameter("inv_v_amt")		==null? 0:AddUtil.parseDigit(request.getParameter("inv_v_amt")));
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
		
		if(base.getRent_st().equals("3")) 	fee.setGrt_suc_yn(request.getParameter("grt_suc_yn")==null?"":request.getParameter("grt_suc_yn"));
		
		//=====[fee] update=====
		flag5 = a_db.updateContFeeNew(fee);
		
		
		//선수금 스케줄 생성
		
		//보증금
		ExtScdBean grt = ae_db.getAGrtScd(rent_mng_id, rent_l_cd, fee.getRent_st(), "0", "1");//기존 등록 여부 조회
		int grt_gbn = 1;	//기존
		if(grt == null || grt.getRent_l_cd().equals("")){
			grt_gbn = 0;	//신규
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
		if(grt_gbn == 1)	flag6 = ae_db.updateGrt(grt);
		else				flag6 = ae_db.insertGrt(grt);
		
		
		//fee_etc
		ContCarBean fee_etc = a_db.getContFeeEtc(rent_mng_id, rent_l_cd, "1");
		
		fee_etc.setSh_car_amt		(request.getParameter("sh_car_amt")		==null? 0:AddUtil.parseDigit(request.getParameter("sh_car_amt")));
		fee_etc.setSh_year		(request.getParameter("sh_year")		==null?"":request.getParameter("sh_year"));
		fee_etc.setSh_month		(request.getParameter("sh_month")		==null?"":request.getParameter("sh_month"));
		fee_etc.setSh_day		(request.getParameter("sh_day")			==null?"":request.getParameter("sh_day"));
		fee_etc.setSh_day_bas_dt	(request.getParameter("sh_day_bas_dt")		==null?"":request.getParameter("sh_day_bas_dt"));
		fee_etc.setSh_amt		(request.getParameter("sh_amt")			==null? 0:AddUtil.parseDigit(request.getParameter("sh_amt")));
		fee_etc.setSh_ja		(request.getParameter("sh_ja")			==null? 0:AddUtil.parseFloat(request.getParameter("sh_ja")));
		fee_etc.setSh_km		(request.getParameter("sh_km")			==null? 0:AddUtil.parseDigit(request.getParameter("sh_km")));
		fee_etc.setSh_tot_km		(request.getParameter("sh_tot_km")		==null? 0:AddUtil.parseDigit(request.getParameter("sh_tot_km")));
		fee_etc.setSh_km_bas_dt		(request.getParameter("sh_km_bas_dt")		==null?"":request.getParameter("sh_km_bas_dt"));
		fee_etc.setSh_init_reg_dt	(request.getParameter("sh_init_reg_dt")		==null?"":request.getParameter("sh_init_reg_dt"));
			
		if(fee_etc.getSh_day_bas_dt().equals("") || fee_etc.getSh_day_bas_dt().equals("null"))	fee_etc.setSh_day_bas_dt(base.getRent_dt());
	
		fee_etc.setCms_not_cau		(request.getParameter("cms_not_cau")		==null?"":request.getParameter("cms_not_cau"));
		fee_etc.setAgree_dist		(request.getParameter("agree_dist")		==null? 0:AddUtil.parseDigit(request.getParameter("agree_dist")));
		fee_etc.setOver_run_amt		(request.getParameter("over_run_amt")		==null? 0:AddUtil.parseDigit(request.getParameter("over_run_amt")));
		fee_etc.setCon_day		(request.getParameter("con_day")		==null?"":request.getParameter("con_day"));
		
		if(fee_etc.getRent_mng_id().equals("")){
			fee_etc.setRent_mng_id		(rent_mng_id);
			fee_etc.setRent_l_cd		(rent_l_cd);
			fee_etc.setRent_st		("1");
			//=====[fee_etc] insert=====
			flag6 = a_db.insertFeeEtc(fee_etc);
		}else{
			//=====[fee_etc] update=====
			flag6 = a_db.updateFeeEtc(fee_etc);
		}
	


	//자동이체-------------------------------------------------------------------------------------------
	
	//cms_mng
	ContCmsBean cms = a_db.getCmsMng(rent_mng_id, rent_l_cd);
	
	cms.setCms_acc_no	(request.getParameter("cms_acc_no")	==null?"":request.getParameter("cms_acc_no"));
	
	if(!cms.getCms_acc_no().equals("")){
		cms.setCms_acc_no	(request.getParameter("cms_acc_no")	==null?"":request.getParameter("cms_acc_no"));
		cms.setCms_bank		(request.getParameter("cms_bank")	==null?"":request.getParameter("cms_bank"));
		cms.setCms_dep_nm	(request.getParameter("cms_dep_nm")	==null?"":request.getParameter("cms_dep_nm"));
		cms.setCms_dep_ssn	(request.getParameter("cms_dep_ssn")	==null?"":request.getParameter("cms_dep_ssn"));
		cms.setCms_day			(request.getParameter("fee_est_day")	==null?"":request.getParameter("fee_est_day"));
		cms.setCms_dep_post	(request.getParameter("cms_zip")		==null?"":request.getParameter("cms_zip"));
		cms.setCms_dep_addr	(request.getParameter("cms_addr")		==null?"":request.getParameter("cms_addr"));
		cms.setCms_etc		(rent_l_cd);
		cms.setCms_tel		(request.getParameter("cms_tel")	==null?"":request.getParameter("cms_tel"));
		cms.setCms_m_tel	(request.getParameter("cms_m_tel")	==null?"":request.getParameter("cms_m_tel"));
		cms.setCms_email	(request.getParameter("cms_email")	==null?"":request.getParameter("cms_email"));
		cms.setCms_start_dt	(request.getParameter("cms_start_dt")	==null?"":request.getParameter("cms_start_dt"));
		cms.setBank_cd		(request.getParameter("cms_bank_cd")	==null?"":request.getParameter("cms_bank_cd"));
		
		if(!cms.getBank_cd().equals("")){
			cms.setCms_bank		(c_db.getNameById(cms.getBank_cd(), "BANK"));
		}
		
		if(cms.getCms_day().equals("99")){
			cms.setCms_day	("31");
		}
		
		if(!cms.getCms_start_dt().equals("")){
			cms.setApp_dt(AddUtil.getDate());
			cms.setApp_id(user_id);
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
	
	//신용카드 자동출금
	ContCmsBean card_cms = a_db.getCardCmsMng(rent_mng_id, rent_l_cd);
	
	card_cms.setCms_acc_no		(request.getParameter("c_cms_acc_no")	==null?"":request.getParameter("c_cms_acc_no"));
	card_cms.setCms_bank		(request.getParameter("c_cms_bank")	==null?"":request.getParameter("c_cms_bank"));
	
	if(!card_cms.getCms_acc_no().equals("") || !card_cms.getCms_bank().equals("")){
		card_cms.setCms_acc_no	(request.getParameter("c_cms_acc_no")	==null?"":request.getParameter("c_cms_acc_no"));
		
		card_cms.setCms_dep_nm	(request.getParameter("c_cms_dep_nm")	==null?"":request.getParameter("c_cms_dep_nm"));
		card_cms.setCms_dep_ssn	(request.getParameter("c_cms_dep_ssn")	==null?"":request.getParameter("c_cms_dep_ssn"));
		card_cms.setCms_day		(request.getParameter("fee_est_day")	==null?"":request.getParameter("fee_est_day"));
		card_cms.setCms_dep_post(request.getParameter("c_cms_zip")		==null?"":request.getParameter("c_c_cms_zip"));
		card_cms.setCms_dep_addr(request.getParameter("c_cms_addr")		==null?"":request.getParameter("c_c_cms_addr"));
		card_cms.setCms_etc		(rent_l_cd);
		card_cms.setCms_tel		(request.getParameter("c_cms_tel")	==null?"":request.getParameter("c_cms_tel"));
		card_cms.setCms_m_tel	(request.getParameter("c_cms_m_tel")	==null?"":request.getParameter("c_cms_m_tel"));
		card_cms.setCms_email	(request.getParameter("c_cms_email")	==null?"":request.getParameter("c_cms_email"));
		card_cms.setCms_start_dt(request.getParameter("c_cms_start_dt")	==null?"":request.getParameter("c_cms_start_dt"));
		
		if(card_cms.getCms_day().equals("99")){
			card_cms.setCms_day	("31");
		}		
		
		if(!card_cms.getCms_start_dt().equals("")){
			card_cms.setApp_dt(AddUtil.getDate());
			card_cms.setApp_id(user_id);
		}
		
		if(!card_cms.getCms_acc_no().equals("") || !card_cms.getCms_bank().equals("")){
			
			if(card_cms.getSeq().equals("")){
				card_cms.setRent_mng_id(rent_mng_id);
				card_cms.setRent_l_cd	(rent_l_cd);
				card_cms.setReg_st		("1");
				card_cms.setCms_st		("1");
				card_cms.setReg_id		(user_id);
				//=====[card_cms_mng] insert=====
				flag7 = a_db.insertContCardCmsMng(card_cms);
			}else{
				card_cms.setUpdate_id	(user_id);
				//=====[card_cms_mng] update=====
				flag7 = a_db.updateContCardCmsMng(card_cms);
			}
		}
	}




	//보험약정/계약이 틀린경우 메시지 발송
	String ins_chk1 	= request.getParameter("ins_chk1")==null?"":request.getParameter("ins_chk1");
	String ins_chk2 	= request.getParameter("ins_chk2")==null?"":request.getParameter("ins_chk2");
	String ins_chk3 	= request.getParameter("ins_chk3")==null?"":request.getParameter("ins_chk3");
	String ins_chk4 	= request.getParameter("ins_chk4")==null?"":request.getParameter("ins_chk4");
	
	if(!ins_chk1.equals("") || !ins_chk2.equals("") || !ins_chk3.equals("") || !ins_chk4.equals("")  ){
		
		//2. 쿨메신저 메세지 전송------------------------------------------------------------------------------------------
			
		String firm_nm	= request.getParameter("firm_nm")==null?"":request.getParameter("firm_nm");
		String sub 		= "보험 현재 가입과 약정이 틀림";
		String cont 	= "보험 현재 가입과 약정이 틀림 &lt;br&gt; &lt;br&gt;  [ "+rent_l_cd+" "+firm_nm+" ]  &lt;br&gt; &lt;br&gt; "+ins_chk1+"  &lt;br&gt; &lt;br&gt; "+ins_chk2+"  &lt;br&gt; &lt;br&gt; "+ins_chk3+"  &lt;br&gt; &lt;br&gt; "+ins_chk4+"  &lt;br&gt; &lt;br&gt; 확인바랍니다.";
		String target_id = nm_db.getWorkAuthUser("부산보험담당");
			
		//if(base.getBrch_id().equals("B1")||base.getBrch_id().equals("N1")) 	target_id = nm_db.getWorkAuthUser("부산보험담당");
			
		
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
		System.out.println("쿨메신저("+rent_l_cd+" [미결현황] 보험 현재 가입과 약정이 틀림)-----------------------"+target_bean.getUser_nm());
		//System.out.println(xml_data);	
		
	}
	
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
	
	
	
	//미결정시 세금계산서 담당자에게 알림->부가세환급차량 등록 무조건 알림
	if(print_car_st_yn.equals("Y")){
			
		//2. 쿨메신저 메세지 전송------------------------------------------------------------------------------------------
			
		String firm_nm	= request.getParameter("firm_nm")==null?"":request.getParameter("firm_nm");
		String sub 	= "부가세환급차량 계약등록 알림";
		String cont 	= "[ "+rent_l_cd+" "+firm_nm+" ] 부가세환급차량 계약등록 알립니다.";
		String target_id = nm_db.getWorkAuthUser("세금계산서담당자");
		
		CarScheBean cs_bean = csd.getCarScheTodayBean(target_id);
		if(!cs_bean.getWork_id().equals("")) target_id = cs_bean.getWork_id();
					
			
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
	
	
	
	//fee_rm
	ContFeeRmBean fee_rm = a_db.getContFeeRm(rent_mng_id, rent_l_cd, "1");
		
	fee_rm.setDc_s_amt	(request.getParameter("dc_s_amt")==null?0:Util.parseDigit(request.getParameter("dc_s_amt")));
	fee_rm.setDc_v_amt	(request.getParameter("dc_v_amt")==null?0:Util.parseDigit(request.getParameter("dc_v_amt")));
	fee_rm.setNavi_s_amt	(request.getParameter("navi_s_amt")==null?0:Util.parseDigit(request.getParameter("navi_s_amt")));
	fee_rm.setNavi_v_amt	(request.getParameter("navi_v_amt")==null?0:Util.parseDigit(request.getParameter("navi_v_amt")));
	fee_rm.setEtc_s_amt	(request.getParameter("etc_s_amt")==null?0:Util.parseDigit(request.getParameter("etc_s_amt")));
	fee_rm.setEtc_v_amt	(request.getParameter("etc_v_amt")==null?0:Util.parseDigit(request.getParameter("etc_v_amt")));
	fee_rm.setT_fee_s_amt	(request.getParameter("t_fee_s_amt")==null?0:Util.parseDigit(request.getParameter("t_fee_s_amt")));
	fee_rm.setT_fee_v_amt	(request.getParameter("t_fee_v_amt")==null?0:Util.parseDigit(request.getParameter("t_fee_v_amt")));
	fee_rm.setCons1_s_amt	(request.getParameter("cons1_s_amt")==null?0:Util.parseDigit(request.getParameter("cons1_s_amt")));
	fee_rm.setCons1_v_amt	(request.getParameter("cons1_v_amt")==null?0:Util.parseDigit(request.getParameter("cons1_v_amt")));
	fee_rm.setCons2_s_amt	(request.getParameter("cons2_s_amt")==null?0:Util.parseDigit(request.getParameter("cons2_s_amt")));
	fee_rm.setCons2_v_amt	(request.getParameter("cons2_v_amt")==null?0:Util.parseDigit(request.getParameter("cons2_v_amt")));
	fee_rm.setF_rent_tot_amt(request.getParameter("f_rent_tot_amt")==null?0:Util.parseDigit(request.getParameter("f_rent_tot_amt")));
	fee_rm.setF_paid_way	(request.getParameter("f_paid_way")==null?"":request.getParameter("f_paid_way"));
	fee_rm.setF_paid_way2	(request.getParameter("f_paid_way2")==null?"":request.getParameter("f_paid_way2"));
	fee_rm.setReg_id	(user_id);
	fee_rm.setNavi_yn	(request.getParameter("navi_yn")==null?"":request.getParameter("navi_yn"));
	fee_rm.setCons1_yn	(request.getParameter("cons1_yn")==null?"":request.getParameter("cons1_yn"));
	fee_rm.setCons2_yn	(request.getParameter("cons2_yn")==null?"":request.getParameter("cons2_yn"));
	fee_rm.setEst_id	(request.getParameter("est_id")==null?"":request.getParameter("est_id"));
	fee_rm.setAmt_per	(request.getParameter("amt_per")==null?"":request.getParameter("amt_per"));
	fee_rm.setEtc_cont	(request.getParameter("etc_cont")==null?"":request.getParameter("etc_cont"));
	fee_rm.setF_con_amt	(request.getParameter("f_con_amt")==null?0:Util.parseDigit(request.getParameter("f_con_amt")));		
	fee_rm.setMy_accid_yn	(request.getParameter("my_accid_yn")==null?"":request.getParameter("my_accid_yn"));
	
	String deli_plan_dt	= request.getParameter("deli_plan_dt")==null?"":request.getParameter("deli_plan_dt");
	String deli_plan_h	= request.getParameter("deli_plan_h")==null?"00":request.getParameter("deli_plan_h");
	String deli_plan_m	= request.getParameter("deli_plan_m")==null?"00":request.getParameter("deli_plan_m");
	String ret_plan_dt	= request.getParameter("ret_plan_dt")==null?"":request.getParameter("ret_plan_dt");
	String ret_plan_h	= request.getParameter("ret_plan_h")==null?"00":request.getParameter("ret_plan_h");
	String ret_plan_m	= request.getParameter("ret_plan_m")==null?"00":request.getParameter("ret_plan_m");
	
	if(!deli_plan_dt.equals("")){
		fee_rm.setDeli_plan_dt	(deli_plan_dt+""+deli_plan_h+""+deli_plan_m);
	}
	if(!ret_plan_dt.equals("")){
		fee_rm.setRet_plan_dt	(ret_plan_dt+""+ret_plan_h+""+ret_plan_m);
	}
	
	fee_rm.setDeli_loc	(request.getParameter("deli_loc")==null?"":request.getParameter("deli_loc"));
	fee_rm.setRet_loc	(request.getParameter("ret_loc")==null?"":request.getParameter("ret_loc"));
	

		
	if(fee_rm.getCons1_yn().equals("N") && fee_rm.getCons1_s_amt()>0)	fee_rm.setCons1_yn("Y");
	if(fee_rm.getCons1_yn().equals("Y") && fee_rm.getCons1_s_amt()==0)	fee_rm.setCons1_yn("N");
	if(fee_rm.getCons2_yn().equals("N") && fee_rm.getCons2_s_amt()>0)	fee_rm.setCons2_yn("Y");
	if(fee_rm.getCons2_yn().equals("Y") && fee_rm.getCons2_s_amt()==0)	fee_rm.setCons2_yn("N");
		
	if(!fee_rm.getEst_id().equals("")){
		//견적정보
		EstimateBean e_bean = e_db.getEstimateShCase(fee_rm.getEst_id());
			
		//차종정보
		cm_bean = cmb.getCarNmCase(e_bean.getCar_id(), e_bean.getCar_seq());

		//차종별변수
		String jg_b_dt = e_db.getVar_b_dt("jg", e_bean.getRent_dt());				
		EstiJgVarBean ej_bean = e_db.getEstiJgVarDtCase(cm_bean.getJg_code(), jg_b_dt);

		//단기요금표
		ShortFeeMngBean sf_bean = sfm_db.getShortFeeMngCase(ej_bean.getJg_r(), "2", e_bean.getRent_dt());
						
		fee_rm.setCars		(ej_bean.getJg_v());
		fee_rm.setAmt_01d	(sf_bean.getAmt_01d());
		fee_rm.setAmt_03d	(sf_bean.getAmt_03d());
		fee_rm.setAmt_05d	(sf_bean.getAmt_05d());
		fee_rm.setAmt_07d	(sf_bean.getAmt_07d());
	}
					
		
	if(fee_rm.getRent_mng_id().equals("")){
		fee_rm.setRent_mng_id		(rent_mng_id);
		fee_rm.setRent_l_cd		(rent_l_cd);
		fee_rm.setRent_st		("1");
		//=====[fee_etc] insert=====
		flag6 = a_db.insertFeeRm(fee_rm);
	}else{
		//=====[fee_etc] update=====
		flag6 = a_db.updateFeeRm(fee_rm);
	}
			
	
	//20150713 자동배정이 안되었을때
	if(!base.getBus_id2().equals(nm_db.getWorkAuthUser("대전지점장"))){	
		//base.setBus_id2(nm_db.getWorkAuthUser("대전지점장"));		
	}	
	
	//20150713 자동배정이 안되었을때
	if(base.getMng_id().equals(nm_db.getWorkAuthUser("본사관리팀장"))){
				
			String rm_mng_id 	= "";	
			
			UsersBean busid_bean 	= umd.getUsersBean(base.getBus_id());
						
			if(busid_bean.getLoan_st().equals("1")){ //고객관리군이면 본인이 영업담당
				rm_mng_id = base.getBus_id();	
			}else{		
			
				//기존계약자이면 기존담당자에게로 20130927
				
				//기존 월렌트 계약자
				rm_mng_id = a_db.getRmMng_id_Auto("2", rent_mng_id, rent_l_cd, base.getRent_dt(), cont_etc.getEst_area());
				
				
				//기존 장기 계약자
				if(rm_mng_id.equals("") || rm_mng_id.equals("999999")){	
					rm_mng_id = a_db.getRmMng_id_Auto("1", rent_mng_id, rent_l_cd, base.getRent_dt(), cont_etc.getEst_area());
				}

				
				//대전 박영규과장은 기존계약자여도 제외
				if(rm_mng_id.equals("000052")) rm_mng_id = "";
				
				
				if(rm_mng_id.equals("") || rm_mng_id.equals("999999")){	
								
					
					//영업소별 관리담당 마지막배정자
					String max_mng_id = rs_db.getBrchMaxMngIdLcContRm(base.getBrch_id());
					
					out.println(rent_l_cd+"영업소별 관리담당 마지막배정자 max_mng_id="+max_mng_id+", brch_id="+base.getBrch_id());
					
					Vector mng_users = new Vector();
					
					if(base.getBrch_id().equals("S1")){	
						mng_users = c_db.getUserList("", "", "RM_MNG"); 
					}else if(base.getBrch_id().equals("S2")){	
						mng_users = c_db.getUserList("", "", "RM_MNG"); 
					}else if(base.getBrch_id().equals("S3")){	
						mng_users = c_db.getUserList("", "", "RM_MNG"); 
					}else if(base.getBrch_id().equals("S4")){	
						mng_users = c_db.getUserList("", "", "RM_MNG"); 
					}else if(base.getBrch_id().equals("S5")){	
						mng_users = c_db.getUserList("", "", "RM_MNG"); 
					}else if(base.getBrch_id().equals("S6")){	
						mng_users = c_db.getUserList("", "", "RM_MNG"); 
					}else if(base.getBrch_id().equals("I1")){	
						mng_users = c_db.getUserList("", "", "RM_MNG"); 
					}else if(base.getBrch_id().equals("K3")){	
						mng_users = c_db.getUserList("", "", "RM_MNG_K3"); 
					}else if(base.getBrch_id().equals("B1")){	
						mng_users = c_db.getUserList("", "", "RM_MNG_B");
					}else if(base.getBrch_id().equals("U1")){	
						mng_users = c_db.getUserList("", "", "RM_MNG_B");
					}else if(base.getBrch_id().equals("D1")){	
						mng_users = c_db.getUserList("", "", "RM_MNG_D");
					}else if(base.getBrch_id().equals("G1")){	
						mng_users = c_db.getUserList("", "", "RM_MNG_G");
					}else if(base.getBrch_id().equals("J1")){	
						mng_users = c_db.getUserList("", "", "RM_MNG_J");
					}else{
						mng_users = c_db.getUserList("", "", "RM_MNG"); 
					}				
							
					int mng_user_size = mng_users.size();	
			
	
					int next_mng_idx = 0;
	
					for (int i = 0 ; i < mng_user_size ; i++){
       						Hashtable user = (Hashtable)mng_users.elementAt(i);
        				
       				//박근 조원규 정준형 조영석 제외
       				if(String.valueOf(user.get("USER_NM")).equals("박근") || String.valueOf(user.get("USER_NM")).equals("조원규") || String.valueOf(user.get("USER_NM")).equals("정준형") || String.valueOf(user.get("USER_NM")).equals("조영석")) continue;
        				
	        				if(max_mng_id.equals(String.valueOf(user.get("USER_ID")))){
       							next_mng_idx = i+1;
	        				}
       					}					
					
					//마지막줄이면 첫줄사람으로 이동		
					if(next_mng_idx == mng_user_size || max_mng_id.equals("")){
						next_mng_idx = 0;
					}
						
					Hashtable next_user = (Hashtable)mng_users.elementAt(next_mng_idx);
		
					String next_mng_id = String.valueOf(next_user.get("USER_ID"));
				
					//System.out.println("#월렌트 담담자 배정----------");
					//System.out.println("#영업소별 관리담당 마지막배정자 max_mng_id="+max_mng_id+"----------");
					//System.out.println("#영업소별 관리담당 배정자 next_mng_id="+next_mng_id+"----------");
												
					rm_mng_id = next_mng_id;
					
					out.println("월렌트 담담자 배정 rm_mng_id="+rm_mng_id);
					
				}
				
				out.println(rm_mng_id);
				//if(1==1)return;
				
				
				if(rm_mng_id.equals("") || rm_mng_id.equals("999999")){	
																	
					Vector mng_users = new Vector();
					
					if(base.getBrch_id().equals("S1")){	
						mng_users = c_db.getUserList("", "", "RM_MNG"); 
					}else if(base.getBrch_id().equals("S2")){	
						mng_users = c_db.getUserList("", "", "RM_MNG"); 
					}else if(base.getBrch_id().equals("S3")){	
						mng_users = c_db.getUserList("", "", "RM_MNG"); 
					}else if(base.getBrch_id().equals("S4")){	
						mng_users = c_db.getUserList("", "", "RM_MNG"); 
					}else if(base.getBrch_id().equals("S5")){	
						mng_users = c_db.getUserList("", "", "RM_MNG"); 
					}else if(base.getBrch_id().equals("S6")){	
						mng_users = c_db.getUserList("", "", "RM_MNG"); 
					}else if(base.getBrch_id().equals("I1")){	
						mng_users = c_db.getUserList("", "", "RM_MNG"); 
					}else if(base.getBrch_id().equals("K3")){	
						mng_users = c_db.getUserList("", "", "RM_MNG_K3"); 
					}else if(base.getBrch_id().equals("B1")){	
						mng_users = c_db.getUserList("", "", "RM_MNG_B");
					}else if(base.getBrch_id().equals("U1")){	
						mng_users = c_db.getUserList("", "", "RM_MNG_B");
					}else if(base.getBrch_id().equals("D1")){	
						mng_users = c_db.getUserList("", "", "RM_MNG_D");
					}else if(base.getBrch_id().equals("G1")){	
						mng_users = c_db.getUserList("", "", "RM_MNG_G");
					}else if(base.getBrch_id().equals("J1")){	
						mng_users = c_db.getUserList("", "", "RM_MNG_J");
					}else{
						mng_users = c_db.getUserList("", "", "RM_MNG"); 
					}				
							
					int mng_user_size = mng_users.size();	
			
	
					int next_mng_idx = 0;
	
					for (int i = 0 ; i < 1 ; i++){
       						Hashtable user = (Hashtable)mng_users.elementAt(i);        				
	        				rm_mng_id = String.valueOf(user.get("USER_ID"));	        				
       					}					
									
					//System.out.println("#월렌트 담담자 재배정----------");
					
					out.println("월렌트 담담자 배정 rm_mng_id="+rm_mng_id);
					
				}				
				
								
				if(rm_mng_id.equals("") || rm_mng_id.equals("999999")){	
									
					if(base.getBrch_id().equals("S1")) 	rm_mng_id = nm_db.getWorkAuthUser("본사월렌트담당");
					if(base.getBrch_id().equals("S2")) 	rm_mng_id = nm_db.getWorkAuthUser("본사월렌트담당");
					if(base.getBrch_id().equals("S3")) 	rm_mng_id = nm_db.getWorkAuthUser("본사월렌트담당");
					if(base.getBrch_id().equals("S4")) 	rm_mng_id = nm_db.getWorkAuthUser("본사월렌트담당");
					if(base.getBrch_id().equals("S5")) 	rm_mng_id = nm_db.getWorkAuthUser("본사월렌트담당");
					if(base.getBrch_id().equals("S6")) 	rm_mng_id = nm_db.getWorkAuthUser("본사월렌트담당");
					if(base.getBrch_id().equals("I1")) 	rm_mng_id = nm_db.getWorkAuthUser("본사월렌트담당");
					if(base.getBrch_id().equals("K1")) 	rm_mng_id = nm_db.getWorkAuthUser("본사월렌트담당");
					if(base.getBrch_id().equals("K3")) 	rm_mng_id = nm_db.getWorkAuthUser("본사월렌트담당");
					if(base.getBrch_id().equals("B1")) 	rm_mng_id = "000053";
					if(base.getBrch_id().equals("U1")) 	rm_mng_id = "000053";
					if(base.getBrch_id().equals("N1")) 	rm_mng_id = "000053";
					if(base.getBrch_id().equals("D1")) 	rm_mng_id = "000137";
					if(base.getBrch_id().equals("G1")) 	rm_mng_id = "000053";
					if(base.getBrch_id().equals("J1")) 	rm_mng_id = "000137";
					if(rm_mng_id.equals("")){	
						if(busid_bean.getBr_id().equals("S1")) 	rm_mng_id = nm_db.getWorkAuthUser("본사월렌트담당");
						if(busid_bean.getBr_id().equals("S2")) 	rm_mng_id = nm_db.getWorkAuthUser("본사월렌트담당");
						if(busid_bean.getBr_id().equals("S3")) 	rm_mng_id = nm_db.getWorkAuthUser("본사월렌트담당");
						if(busid_bean.getBr_id().equals("S4")) 	rm_mng_id = nm_db.getWorkAuthUser("본사월렌트담당");
						if(busid_bean.getBr_id().equals("S5")) 	rm_mng_id = nm_db.getWorkAuthUser("본사월렌트담당");
						if(busid_bean.getBr_id().equals("S6")) 	rm_mng_id = nm_db.getWorkAuthUser("본사월렌트담당");
						if(busid_bean.getBr_id().equals("I1")) 	rm_mng_id = nm_db.getWorkAuthUser("본사월렌트담당");
						if(busid_bean.getBr_id().equals("K1")) 	rm_mng_id = nm_db.getWorkAuthUser("본사월렌트담당");
						if(busid_bean.getBr_id().equals("K3")) 	rm_mng_id = nm_db.getWorkAuthUser("본사월렌트담당");
						if(busid_bean.getBr_id().equals("B1")) 	rm_mng_id = "000053";
						if(busid_bean.getBr_id().equals("U1")) 	rm_mng_id = "000053";
						if(busid_bean.getBr_id().equals("N1")) 	rm_mng_id = "000053";
						if(busid_bean.getBr_id().equals("D1")) 	rm_mng_id = "000137";	
						if(busid_bean.getBr_id().equals("G1")) 	rm_mng_id = "000053";
						if(busid_bean.getBr_id().equals("J1")) 	rm_mng_id = "000137";							
					}				
				}
			}
			
			base.setMng_id(rm_mng_id);	
			base.setBus_id2(rm_mng_id);
			
			//=====[cont] insert=====
			flag1 = a_db.updateContBaseNew(base);				
	
	
	}	
%>
<form name='form1' method='post'>
  <input type="hidden" name="auth_rw" 			value="<%=auth_rw%>">
  <input type="hidden" name="user_id" 			value="<%=user_id%>">
  <input type="hidden" name="br_id" 			value="<%=br_id%>">    
  <input type="hidden" name="rent_mng_id" 		value="<%=rent_mng_id%>">
  <input type="hidden" name="rent_l_cd" 		value="<%=rent_l_cd%>">  
  <input type='hidden' name="old_rent_mng_id" 	value="<%=old_rent_mng_id%>">
  <input type='hidden' name="old_rent_l_cd" 	value="<%=old_rent_l_cd%>">
  <%if(base.getCar_st().equals("2")){%>
  <input type='hidden' name="c_st" 				value="car">  
  <%}else{%>
  <input type='hidden' name="c_st" 				value="client">  
  <%}%>
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


<%		if(!flag5){	%>
		alert('대여정보 등록 에러입니다.\n\n확인하십시오');
<%		}	%>		

<%		if(!flag6){	%>
		alert('선수금스케줄 등록 에러입니다.\n\n확인하십시오');
<%		}	%>		

<%		if(!flag7){	%>
		alert('자동이체 등록 에러입니다.\n\n확인하십시오');
<%		}	%>		
		

	fm.action = 'lc_c_frame.jsp';
	fm.target = 'd_content';
	fm.submit();

</script>
</body>
</html>