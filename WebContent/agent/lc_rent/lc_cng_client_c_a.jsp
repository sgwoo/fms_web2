<%@ page language="java" contentType="text/html;charset=euc-kr" %>
<%@ page import="java.util.*, acar.common.*, acar.util.*, acar.cont.*, acar.cls.*,  acar.fee.*, acar.car_office.*, cust.member.*, acar.ext.*,acar.client.*"%>
<%@ page import="acar.coolmsg.*, acar.user_mng.*, acar.car_sche.*, acar.car_mst.*, acar.car_register.*"%>
<jsp:useBean id="a_db" scope="page" class="acar.cont.AddContDatabase"/>
<jsp:useBean id="as_db" scope="page" class="acar.cls.AddClsDatabase"/>
<jsp:useBean id="ad_db" scope="page" class="acar.debt.AddDebtDatabase"/>
<jsp:useBean id="ae_db" scope="page" class="acar.ext.AddExtDatabase"/>
<jsp:useBean id="af_db" scope="page" class="acar.fee.AddFeeDatabase"/>
<jsp:useBean id="m_db" scope="page" class="cust.member.MemberDatabase"/>
<jsp:useBean id="al_db" scope="page" class="acar.client.AddClientDatabase"/>
<jsp:useBean id="cm_db" scope="page" class="acar.coolmsg.CoolMsgDatabase"/>
<jsp:useBean id="admin_db" 	scope="page" class="acar.admin.AdminDatabase"/>
<jsp:useBean id="ec_db" scope="page" class="acar.cont.EtcContDatabase"/>
<%@ include file="/agent/cookies.jsp" %>

<html>
<head>
<title>FMS</title>
</head>
<body>
<%
	//if(1==1)return;
	
	String auth_rw 	= request.getParameter("auth_rw")==null?""        :request.getParameter("auth_rw");
	String user_id 	= request.getParameter("user_id")==null?ck_acar_id:request.getParameter("user_id");
	String br_id 		= request.getParameter("br_id")  ==null?acar_br   :request.getParameter("br_id");
	
	String rent_mng_id 	= request.getParameter("rent_mng_id")==null?"":request.getParameter("rent_mng_id");
	String rent_l_cd 	= request.getParameter("rent_l_cd")==null?"":request.getParameter("rent_l_cd");
	String cls_st	 	= request.getParameter("cls_st")==null?"":request.getParameter("cls_st");
	
	String t_zip[] 			= request.getParameterValues("t_zip");
	String t_addr[] 		= request.getParameterValues("t_addr");
	
	String client_id 	= request.getParameter("client_id")==null?"":request.getParameter("client_id");
	String site_id 		= request.getParameter("site_id")==null?"":request.getParameter("site_id");
	String tax_agnt 	= request.getParameter("tax_agnt")==null?"":request.getParameter("tax_agnt");
	String fee_tm 		= request.getParameter("fee_tm")==null?"":request.getParameter("fee_tm");
	int    fee_size	 	= request.getParameter("fee_size")==null?0:AddUtil.parseInt(request.getParameter("fee_size"));
	String tax_cng_yn 	= request.getParameter("tax_cng_yn")==null?"N":request.getParameter("tax_cng_yn");
	int    grt_s_amt	= request.getParameter("grt_s_amt")	==null? 0:AddUtil.parseDigit(request.getParameter("grt_s_amt"));
	String grt_suc_yn 	= request.getParameter("grt_suc_yn")==null?"":request.getParameter("grt_suc_yn");
	String cng_fee_tm 	= request.getParameter("cng_fee_tm")==null?"":request.getParameter("cng_fee_tm");
	String tax_req 		= request.getParameter("tax_req")==null?"N":request.getParameter("tax_req");
	int    commi_s_amt	= request.getParameter("commi_s_amt")	==null? 0:AddUtil.parseDigit(request.getParameter("commi_s_amt"));
	int    commi_v_amt	= request.getParameter("commi_v_amt")	==null? 0:AddUtil.parseDigit(request.getParameter("commi_v_amt"));
	String rent_suc_fee_tm_b_dt 	= request.getParameter("rent_suc_fee_tm_b_dt")==null?"":request.getParameter("rent_suc_fee_tm_b_dt");
	String o_insur_per 	= request.getParameter("o_insur_per")==null?"":request.getParameter("o_insur_per");
	String o_gi_st 		= request.getParameter("o_gi_st")==null?"":request.getParameter("o_gi_st");
	int    o_gi_amt		= request.getParameter("o_gi_amt")	==null? 0:AddUtil.parseDigit(request.getParameter("o_gi_amt"));
	
	int    pp_amt		= request.getParameter("pp_amt")	==null? 0:AddUtil.parseDigit(request.getParameter("pp_amt"));
	String pp_suc_yn 	= request.getParameter("pp_suc_yn")==null?"":request.getParameter("pp_suc_yn");
	int    ifee_amt		= request.getParameter("ifee_amt")	==null? 0:AddUtil.parseDigit(request.getParameter("ifee_amt"));
	String ifee_suc_yn 	= request.getParameter("ifee_suc_yn")==null?"":request.getParameter("ifee_suc_yn");
	
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
	
	MaMenuDatabase nm_db = MaMenuDatabase.getInstance();
	UserMngDatabase umd = UserMngDatabase.getInstance();
	AddCarMstDatabase cmb 	= AddCarMstDatabase.getInstance();
	CarRegDatabase crd = CarRegDatabase.getInstance();
	CommonDataBase c_db = CommonDataBase.getInstance();
	
	//고객정보
	String client_id_old 	= request.getParameter("client_id_old")==null?"":request.getParameter("client_id_old");
	ClientBean client_old = al_db.getNewClient(client_id_old);
	
	//고객피보험자인 경우 메시지 처리
	Vector vts1 = al_db.getClientInsurFnmList(client_id_old);
	int vt_size1 = vts1.size();		
	
	ClientBean client_new = al_db.getNewClient(client_id);

	//원계약 해지처리-----------------------------------------------------------------------------------------------
	
	//cls_cont
	ClsBean cls = new ClsBean();
	
	cls.setRent_mng_id	(rent_mng_id);
	cls.setRent_l_cd	(rent_l_cd);
	cls.setTerm_yn		("Y");
	cls.setCls_st		(cls_st);
	cls.setCls_dt		(request.getParameter("cls_dt")==null?"":request.getParameter("cls_dt"));
	cls.setR_mon		(request.getParameter("r_mon")==null?"":request.getParameter("r_mon"));
	cls.setR_day		(request.getParameter("r_day")==null?"":request.getParameter("r_day"));
	cls.setCls_cau		(request.getParameter("cls_cau")==null?"":request.getParameter("cls_cau"));
	cls.setReg_id		(user_id);
	
	cls.setCls_cau		(cls.getCls_cau());
	
	if(!cng_fee_tm.equals("")) 		cls.setCls_cau		(cls.getCls_cau()+", [대여료이관]"+cng_fee_tm);
	
	if(!rent_suc_fee_tm_b_dt.equals("")) 	cls.setCls_cau		(cls.getCls_cau()+", [일자계산기준일자]"+rent_suc_fee_tm_b_dt);
	
	flag1 = as_db.insertCls2(cls);


	//승계계약 생성---------------------------------------------------------------------------------------------
	
	String dec_gr 	= request.getParameter("dec_gr")==null?"":request.getParameter("dec_gr");
	
	//cont
	ContBaseBean base = a_db.getCont(rent_mng_id, rent_l_cd);
	
	String md_con_cd = rent_l_cd.substring(0,8);
	base.setRent_l_cd	(md_con_cd);//생성
	base.setClient_id	(client_id);
	base.setR_site		(site_id);
	base.setP_zip			(t_zip[0]);
	base.setP_addr		(t_addr[0]);
	base.setTax_agnt	(tax_agnt);
	base.setUse_yn		("");
	base.setReg_id		(ck_acar_id);
	base.setBus_id		(request.getParameter("ext_agnt")	==null? "":request.getParameter("ext_agnt"));	
	base.setAgent_emp_id	(request.getParameter("agent_emp_id")==null?"":request.getParameter("agent_emp_id"));
	
	base = a_db.insertContBaseNew(base);
	
		
	
	//=====[cont] update=====
	base.setReg_dt		(AddUtil.getDate(4));
	
	base.setOthers		("");
	base.setFine_mm		("");
	base.setSanction_id	("");
	base.setSanction	("");
	base.setCall_st		("");
	base.setLic_no			(request.getParameter("lic_no")==null?"":request.getParameter("lic_no"));	
	base.setMgr_lic_no	(request.getParameter("mgr_lic_no")==null?"":request.getParameter("mgr_lic_no"));	
	base.setMgr_lic_emp	(request.getParameter("mgr_lic_emp")==null?"":request.getParameter("mgr_lic_emp"));	
	base.setMgr_lic_rel	(request.getParameter("mgr_lic_rel")==null?"":request.getParameter("mgr_lic_rel"));	
	base.setSpr_kd		(dec_gr);
	base.setSanction_type("승계등록");
	base.setAgent_users	(base.getAgent_users()+""+ck_acar_id+"/");
	
	base.setTest_lic_emp	(request.getParameter("test_lic_emp")==null?"":request.getParameter("test_lic_emp"));	
	base.setTest_lic_rel	(request.getParameter("test_lic_rel")==null?"":request.getParameter("test_lic_rel"));
	base.setTest_lic_result	(request.getParameter("test_lic_result")==null?"":request.getParameter("test_lic_result"));
	
	base.setTest_lic_emp2	(request.getParameter("test_lic_emp2")==null?"":request.getParameter("test_lic_emp2"));	
	base.setTest_lic_rel2	(request.getParameter("test_lic_rel2")==null?"":request.getParameter("test_lic_rel2"));
	base.setTest_lic_result2(request.getParameter("test_lic_result2")==null?"":request.getParameter("test_lic_result2"));
	
	flag1 = a_db.updateContBaseNew(base);	
	
	String new_rent_l_cd = base.getRent_l_cd();


	//관련테이블 생성 [cont_etc,car_mgr,car_pur,car_etc,fee,allot,fee_etc] insert-------------------------------------------------
	
	flag2 = a_db.insertContEtcRows(rent_mng_id, new_rent_l_cd);
	
	//car_etc
	ContCarBean car = a_db.getContCarNew(rent_mng_id, rent_l_cd);
	car.setRent_mng_id	(rent_mng_id);
	car.setRent_l_cd	(new_rent_l_cd);
	flag3 = a_db.updateContCarNew(car);
	
	
	//allot
	ContDebtBean debt = ad_db.getContDebtReg(rent_mng_id, rent_l_cd);
	debt.setRent_mng_id	(rent_mng_id);
	debt.setRent_l_cd	(new_rent_l_cd);
	flag3 = ad_db.updateContDebt(debt);
	
	for(int i=0; i<fee_size; i++){
		//fee
		ContFeeBean fee = a_db.getContFeeNew(rent_mng_id, rent_l_cd, Integer.toString(i+1));
		fee.setRent_mng_id	(rent_mng_id);
		fee.setRent_l_cd	(new_rent_l_cd);
		fee.setExt_agnt		(request.getParameter("ext_agnt")	==null? "":request.getParameter("ext_agnt"));
		
		if(i == fee_size-1){
						
			if(grt_suc_yn.equals("1")){
				fee.setGrt_amt_s	(request.getParameter("grt_s_amt")	==null? 0:AddUtil.parseDigit(request.getParameter("grt_s_amt")));
				fee.setGrt_suc_yn	(grt_suc_yn);
			}
			/*
			if(pp_suc_yn.equals("1")){
				fee.setPp_s_amt	(request.getParameter("pp_s_amt")	==null? 0:AddUtil.parseDigit(request.getParameter("pp_s_amt")));
				fee.setPp_v_amt	(request.getParameter("pp_v_amt")	==null? 0:AddUtil.parseDigit(request.getParameter("pp_v_amt")));
			}
			
			if(ifee_suc_yn.equals("1")){
				fee.setIfee_s_amt	(request.getParameter("ifee_s_amt")	==null? 0:AddUtil.parseDigit(request.getParameter("ifee_s_amt")));
				fee.setIfee_v_amt	(request.getParameter("ifee_v_amt")	==null? 0:AddUtil.parseDigit(request.getParameter("ifee_v_amt")));
				fee.setIfee_suc_yn	(ifee_suc_yn);
			}
			*/
			
			fee.setFee_sh			(request.getParameter("fee_sh")			==null?"":request.getParameter("fee_sh"));
			fee.setFee_pay_st		(request.getParameter("fee_pay_st")		==null?"":request.getParameter("fee_pay_st"));
			fee.setFee_bank			(request.getParameter("fee_bank")		==null?"":request.getParameter("fee_bank"));
			fee.setDef_st			(request.getParameter("def_st")			==null?"":request.getParameter("def_st"));
			fee.setDef_remark		(request.getParameter("def_remark")		==null?"":request.getParameter("def_remark"));
			fee.setDef_sac_id		(request.getParameter("def_sac_id")		==null?"":request.getParameter("def_sac_id"));
			
		}
		
		
		if(i==0){
			flag3 = a_db.updateContFeeNew(fee);
		}else{
			flag3 = a_db.insertContFee(fee);
			flag3 = a_db.updateContFeeNew(fee);
		}
		//fee_etc
		ContCarBean fee_etc = a_db.getContFeeEtc(rent_mng_id, rent_l_cd, Integer.toString(i+1));
		fee_etc.setRent_mng_id	(rent_mng_id);
		fee_etc.setRent_l_cd	(new_rent_l_cd);
		if(i == fee_size-1){
			fee_etc.setBus_agnt_id		(request.getParameter("bus_agnt_id")	==null?"":request.getParameter("bus_agnt_id"));
			fee_etc.setCms_not_cau		(request.getParameter("cms_not_cau")==null?"":request.getParameter("cms_not_cau"));
			//계약승계담당자와 영업대리인이 같으면 무효처리한다.
			if(fee.getExt_agnt().equals(fee_etc.getBus_agnt_id())){
				fee_etc.setBus_agnt_id	("");
			}
		}
		if(i==0){
			flag3 = a_db.updateFeeEtc(fee_etc);
		}else{
			flag3 = a_db.insertFeeEtc(fee_etc);
			flag3 = a_db.updateFeeEtc(fee_etc);
		}
		
		//fee_rtn
		Vector rtn_vt = af_db.getFeeRtnList(rent_mng_id, rent_l_cd, Integer.toString(i+1));
		int rtn_size = rtn_vt.size();
		for(int j = 0 ; j < rtn_size ; j++){
			Hashtable r_ht = (Hashtable)rtn_vt.elementAt(j);
			FeeRtnBean rtn = af_db.getFeeRtn(rent_mng_id, rent_l_cd, String.valueOf(r_ht.get("RENT_ST")), String.valueOf(r_ht.get("RENT_SEQ")));
			rtn.setRent_mng_id	(rent_mng_id);
			rtn.setRent_l_cd	(new_rent_l_cd);
			rtn.setClient_id	(client_id);
			flag3 = af_db.insertFeeRtn(rtn);
		}
	}
	
	
	String fee_pay_st 	= request.getParameter("fee_pay_st")==null?"":request.getParameter("fee_pay_st");
	String cms_not_cau 	= request.getParameter("cms_not_cau")==null?"":request.getParameter("cms_not_cau");
	
	if(fee_pay_st.equals("1") && !cms_not_cau.equals("")){
		//자동이체-------------------------------------------------------------------------------------------
		
		//cms_mng 자동이체정보-최근평가내용
		ContCmsBean o_cms = a_db.getCmsMng(base.getClient_id());
		
		ContCmsBean cms = new ContCmsBean();
		
		cms.setRent_mng_id	(rent_mng_id);
		cms.setRent_l_cd	(new_rent_l_cd);
		cms.setReg_st		("1");
		cms.setCms_st		("1");
		
		if(!o_cms.getSeq().equals("")){
			cms.setCms_acc_no	(o_cms.getCms_acc_no());
			cms.setCms_bank		(o_cms.getCms_bank());
			cms.setCms_dep_nm	(o_cms.getCms_dep_nm());
			cms.setCms_day		(o_cms.getCms_day());
			cms.setCms_dep_post	(o_cms.getCms_dep_post());
			cms.setCms_dep_addr	(o_cms.getCms_dep_addr());
			cms.setCms_etc		(new_rent_l_cd);
			cms.setCms_tel		(o_cms.getCms_tel());
			cms.setCms_m_tel	(o_cms.getCms_m_tel());
			cms.setCms_email	(o_cms.getCms_email());
			cms.setBank_cd		(o_cms.getBank_cd());
			cms.setCms_bk			(o_cms.getCms_bk());
		}else{
			cms.setCms_acc_no	("");
			cms.setCms_bank		(request.getParameter("cms_bank")	==null?"":request.getParameter("cms_bank"));
			cms.setCms_dep_nm	(client_new.getFirm_nm());
			cms.setCms_day		("");
			cms.setCms_dep_post	(client_new.getO_zip());
			cms.setCms_dep_addr	(client_new.getO_addr());
			cms.setCms_etc		(new_rent_l_cd);
			cms.setCms_tel		(client_new.getO_tel());
			cms.setCms_m_tel	(client_new.getM_tel());
			cms.setCms_email	(client_new.getCon_agnt_email().trim());
			cms.setBank_cd		(request.getParameter("cms_bank_cd")	==null?"":request.getParameter("cms_bank_cd"));			
		}
		
		if(!cms.getBank_cd().equals("")){
			cms.setCms_bank		(c_db.getNameById(cms.getBank_cd(), "BANK"));
		}
		
		//=====[cms_mng] insert=====
		flag3 = a_db.insertContCmsMng(cms);
	}
	
	
	
	flag3 = a_db.updateFeeEtcCngCheckInit(rent_mng_id, new_rent_l_cd, Integer.toString(fee_size), nm_db.getWorkAuthUser("연장/승계담당자"), "계약승계");
	
	//cont_etc
	ContEtcBean o_cont_etc = a_db.getContEtc(rent_mng_id, rent_l_cd);
	
	//cont_etc
	ContEtcBean cont_etc = a_db.getContEtc(rent_mng_id, new_rent_l_cd);
	cont_etc.setRent_mng_id		(rent_mng_id);
	cont_etc.setRent_l_cd		(new_rent_l_cd);
	cont_etc.setRent_suc_commi	(request.getParameter("rent_suc_commi")==null? 0:AddUtil.parseDigit(request.getParameter("rent_suc_commi")));
	cont_etc.setRent_suc_dt		(request.getParameter("rent_suc_dt")==null?"":request.getParameter("rent_suc_dt"));
	if(cont_etc.getRent_suc_dt().equals("")){
		cont_etc.setRent_suc_dt	(cls.getCls_dt());
	}
	cont_etc.setCar_deli_dt		(request.getParameter("car_deli_dt")==null?"":request.getParameter("car_deli_dt"));
	cont_etc.setRent_suc_grt_yn	(grt_suc_yn);
	cont_etc.setGrt_suc_o_amt	(request.getParameter("o_grt_s_amt")==null? 0:AddUtil.parseDigit(request.getParameter("o_grt_s_amt")));
	cont_etc.setGrt_suc_r_amt	(request.getParameter("grt_s_amt")==null? 0:AddUtil.parseDigit(request.getParameter("grt_s_amt")));
	cont_etc.setRent_suc_m_id	(rent_mng_id);
	cont_etc.setRent_suc_l_cd	(rent_l_cd);
	cont_etc.setRent_suc_fee_tm	(fee_tm);
	cont_etc.setInsur_per		(request.getParameter("insur_per")	==null?"":request.getParameter("insur_per"));
	cont_etc.setRent_suc_commi_pay_st(request.getParameter("rent_suc_commi_pay_st")	==null?"":request.getParameter("rent_suc_commi_pay_st"));
	cont_etc.setRent_suc_fee_tm_b_dt(request.getParameter("rent_suc_fee_tm_b_dt")==null?"":request.getParameter("rent_suc_fee_tm_b_dt"));
	cont_etc.setSuc_rent_st		(String.valueOf(fee_size));
	
	if(fee_tm.equals("9999")) 	cont_etc.setRent_suc_fee_tm	("");
	
	cont_etc.setEst_area		(request.getParameter("est_area")		==null?"":request.getParameter("est_area"));
	cont_etc.setCounty			(request.getParameter("county")			==null?"":request.getParameter("county"));
	
	cont_etc.setRent_suc_exem_cau	(request.getParameter("rent_suc_exem_cau")	==null?"":request.getParameter("rent_suc_exem_cau"));
	cont_etc.setRent_suc_exem_id	(request.getParameter("rent_suc_exem_id")	==null?"":request.getParameter("rent_suc_exem_id"));
	cont_etc.setInsurant			(request.getParameter("insurant")		==null?"":request.getParameter("insurant"));
	
	if(cont_etc.getRent_suc_exem_cau().equals("4")){
		cont_etc.setRent_suc_exem_cau	(request.getParameter("rent_suc_exem_cau_sub")	==null?"":request.getParameter("rent_suc_exem_cau_sub"));
	}
	
	cont_etc.setRent_suc_route(request.getParameter("rent_suc_route")	==null?"":request.getParameter("rent_suc_route"));
	cont_etc.setRent_suc_dist	(request.getParameter("rent_suc_dist")==null? 0:AddUtil.parseDigit(request.getParameter("rent_suc_dist")));
	cont_etc.setCom_emp_yn		(request.getParameter("com_emp_yn")		==null?"":request.getParameter("com_emp_yn"));	
	
	// 첨단안전장치 값 전달 2018.03.27
	cont_etc.setLkas_yn		(request.getParameter("lkas_yn")	==null?"":request.getParameter("lkas_yn"));
	cont_etc.setLdws_yn		(request.getParameter("ldws_yn")	==null?"":request.getParameter("ldws_yn"));
	cont_etc.setAeb_yn		(request.getParameter("aeb_yn")	==null?"":request.getParameter("aeb_yn"));
	cont_etc.setFcw_yn		(request.getParameter("fcw_yn")	==null?"":request.getParameter("fcw_yn"));
	cont_etc.setHook_yn		(request.getParameter("hook_yn")	==null?"":request.getParameter("hook_yn"));
	cont_etc.setLegal_yn	(request.getParameter("legal_yn")	==null?"":request.getParameter("legal_yn"));
	cont_etc.setEv_yn		(request.getParameter("ev_yn")	==null?"":request.getParameter("ev_yn"));
	
	cont_etc.setOthers_device(o_cont_etc.getOthers_device());
	cont_etc.setAir_ds_yn	(o_cont_etc.getAir_ds_yn());
	cont_etc.setAir_as_yn	(o_cont_etc.getAir_as_yn());
	cont_etc.setAc_dae_yn	(o_cont_etc.getAc_dae_yn());
	cont_etc.setPro_yn		(o_cont_etc.getPro_yn());
	cont_etc.setCyc_yn		(o_cont_etc.getCyc_yn());
	cont_etc.setMain_yn		(o_cont_etc.getMain_yn());
	cont_etc.setMa_dae_yn	(o_cont_etc.getMa_dae_yn());
	cont_etc.setBlackbox_yn	(o_cont_etc.getBlackbox_yn());	
	cont_etc.setCanoisr_yn	(o_cont_etc.getCanoisr_yn());
	cont_etc.setCacdt_yn	(o_cont_etc.getCacdt_yn());
	cont_etc.setEme_yn		(o_cont_etc.getEme_yn());
	cont_etc.setTop_cng_yn	(o_cont_etc.getTop_cng_yn());
	//관리지점
	cont_etc.setMng_br_id	(o_cont_etc.getMng_br_id());

	cont_etc.setDec_gr		(dec_gr);
	cont_etc.setDec_f_id	(request.getParameter("dec_f_id")==null?"":request.getParameter("dec_f_id"));
	cont_etc.setDec_f_dt	(request.getParameter("dec_f_dt")==null?"":AddUtil.ChangeString(request.getParameter("dec_f_dt")));
	cont_etc.setDec_l_id	(request.getParameter("dec_l_id")==null?"":request.getParameter("dec_l_id"));
	cont_etc.setDec_l_dt	(request.getParameter("dec_l_dt")==null?"":AddUtil.ChangeString(request.getParameter("dec_l_dt")));
	
	cont_etc.setRent_suc_pp_yn	(pp_suc_yn);
	cont_etc.setPp_suc_o_amt	(request.getParameter("o_pp_amt")==null? 0:AddUtil.parseDigit(request.getParameter("o_pp_amt")));
	cont_etc.setPp_suc_r_amt	(request.getParameter("pp_amt")==null? 0:AddUtil.parseDigit(request.getParameter("pp_amt")));
	cont_etc.setRent_suc_ifee_yn(ifee_suc_yn);
	cont_etc.setIfee_suc_o_amt	(request.getParameter("o_ifee_amt")==null? 0:AddUtil.parseDigit(request.getParameter("o_ifee_amt")));
	cont_etc.setIfee_suc_r_amt	(request.getParameter("ifee_amt")==null? 0:AddUtil.parseDigit(request.getParameter("ifee_amt")));
	cont_etc.setN_mon			(request.getParameter("n_mon")==null?"":request.getParameter("n_mon"));
	cont_etc.setN_day			(request.getParameter("n_day")==null?"":request.getParameter("n_day"));
	
	
	flag3 = a_db.insertContEtc(cont_etc);
	

	//scd_ext
	Vector grts 	= ae_db.getGrtScdAll(rent_mng_id, rent_l_cd);
	int grt_size 	= grts.size();
	for(int i = 0 ; i < grt_size ; i++){
		ExtScdBean grt = (ExtScdBean)grts.elementAt(i);
		grt.setRent_mng_id	(rent_mng_id);
		grt.setRent_l_cd	(new_rent_l_cd);
		grt.setRent_seq		("1");
		grt.setExt_id		("0");
		
		grt.setExt_s_amt	(0);
		grt.setExt_v_amt	(0);
		grt.setExt_est_dt	("");
		grt.setExt_pay_amt	(0);
		grt.setExt_pay_dt	("");
		grt.setUpdate_id	(user_id);
		

		
		//=====[scd_pre] insert=====
		flag3 = ae_db.insertGrt(grt);
	}
	
	
	
	//승계수수료
	if(cont_etc.getRent_suc_commi() >0){
		ExtScdBean suc = ae_db.getAGrtScd(rent_mng_id, new_rent_l_cd, "1", "5", "1");//기존 등록 여부 조회
		int suc_gbn = 1;		//기존
		if(suc == null || suc.getRent_l_cd().equals("")){
			suc_gbn = 0;		//신규
			suc = new ExtScdBean();
			suc.setRent_mng_id	(rent_mng_id);
			suc.setRent_l_cd	(new_rent_l_cd);
			suc.setRent_st		("1");
			suc.setRent_seq		("1");
			suc.setExt_id		("0");
			suc.setExt_st		("5");
			suc.setExt_tm		("1");
		}
		suc.setExt_s_amt		(commi_s_amt);
		suc.setExt_v_amt		(commi_v_amt);
		suc.setExt_est_dt		(request.getParameter("rent_suc_commi_est_dt")==null?"":request.getParameter("rent_suc_commi_est_dt"));
		
		//원계약자 승계수수료 부담시 원계약으로 스케줄 생성
		if(cont_etc.getRent_suc_commi_pay_st().equals("1")){	//계약번호를 바꾸지 않고 rent_seq를 원계약자부담처리한다.
			//suc.setRent_l_cd	(rent_l_cd);
			suc.setRent_seq		("2");
		}
		suc.setUpdate_id	(user_id);
		
		//=====[scd_pre] update=====
		if(suc_gbn == 1)	flag6 = ae_db.updateGrt(suc);
		else				flag6 = ae_db.insertGrt(suc);
		
	}
	

	//관계자---------------------------------------------------------------------------------
	
	//car_mgr
	String mgr_st[] 			= request.getParameterValues("mgr_st");
	String mgr_com[] 			= request.getParameterValues("mgr_com");
	String mgr_dept[] 			= request.getParameterValues("mgr_dept");
	String mgr_nm[] 			= request.getParameterValues("mgr_nm");
	String mgr_title[] 			= request.getParameterValues("mgr_title");
	String mgr_tel[] 			= request.getParameterValues("mgr_tel");
	String mgr_m_tel[] 			= request.getParameterValues("mgr_m_tel");
	String mgr_email[] 			= request.getParameterValues("mgr_email");
	
	int mgr_size = mgr_st.length;
	
	for(int i = 0 ; i < mgr_size ; i++){
		
		CarMgrBean mgr = a_db.getCarMgr(rent_mng_id, new_rent_l_cd, mgr_st[i]);
		
		mgr.setMgr_id		(String.valueOf(i));
		mgr.setMgr_st		(mgr_st[i]);
		mgr.setMgr_nm		(mgr_nm[i]);
		mgr.setMgr_dept		(mgr_dept[i]);
		mgr.setMgr_title	(mgr_title[i]);
		mgr.setMgr_tel		(mgr_tel[i]);
		mgr.setMgr_m_tel	(mgr_m_tel[i]);
		mgr.setMgr_email	(mgr_email[i].trim());
		mgr.setUse_yn		("Y");
		mgr.setEmail_yn		("Y");
		mgr.setCom_nm		(mgr_com[i]);
		
		if(i == 0){
			mgr.setMgr_zip		(t_zip[1]);
			mgr.setMgr_addr		(t_addr[1]);
		}
		
		if(mgr.getMgr_st().equals("추가운전자")){
			if(mgr.getMgr_nm().equals("")){
				mgr.setMgr_nm	(request.getParameter("mgr_lic_emp5")	==null?"":request.getParameter("mgr_lic_emp5"));
			}
			mgr.setLic_no		(request.getParameter("mgr_lic_no5")	==null?"":request.getParameter("mgr_lic_no5"));
			mgr.setEtc			(request.getParameter("mgr_lic_rel5")	==null?"":request.getParameter("mgr_lic_rel5"));
			mgr.setLic_result	(request.getParameter("mgr_lic_result5")	==null?"":request.getParameter("mgr_lic_result5"));
		}
		
		if(mgr.getRent_mng_id().equals("")){
			mgr.setRent_mng_id	(rent_mng_id);
			mgr.setRent_l_cd	(new_rent_l_cd);
			//=====[CAR_MGR] insert=====
			flag4 = a_db.insertCarMgr(mgr);
		}else{
			//=====[CAR_MGR] update=====
			flag4 = a_db.updateCarMgrNew(mgr);
		}
	}
	
	//추가운전면허정보만 있고 추가운전자가 없는 경우 처리
	CarMgrBean mgr5 = a_db.getCarMgr(rent_mng_id, new_rent_l_cd, "추가운전자");
	if(mgr5.getRent_mng_id().equals("")){
		mgr5.setRent_mng_id	(rent_mng_id);
		mgr5.setRent_l_cd	(new_rent_l_cd);
		mgr5.setMgr_id		(String.valueOf(mgr_size));
		mgr5.setMgr_st		("추가운전자");
		mgr5.setMgr_nm		(request.getParameter("mgr_lic_emp5")	==null?"":request.getParameter("mgr_lic_emp5"));
		mgr5.setLic_no		(request.getParameter("mgr_lic_no5")	==null?"":request.getParameter("mgr_lic_no5"));
		mgr5.setEtc			(request.getParameter("mgr_lic_rel5")	==null?"":request.getParameter("mgr_lic_rel5"));
		mgr5.setLic_result	(request.getParameter("mgr_lic_result5")	==null?"":request.getParameter("mgr_lic_result5"));
		if(!mgr5.getMgr_nm().equals("") || !mgr5.getLic_no().equals("")){
			//=====[CAR_MGR] insert=====
			flag2 = a_db.insertCarMgr(mgr5);
		}
	}


	//연대보증-----------------------------------------------------------------------------------------------
	
	//cont_etc
	String client_guar_st	= request.getParameter("client_guar_st")==null?"":request.getParameter("client_guar_st");
	String guar_con 	= request.getParameter("guar_con")==null?"":request.getParameter("guar_con");
	String guar_sac_id	= request.getParameter("guar_sac_id")==null?"":request.getParameter("guar_sac_id");
	String guar_st 		= request.getParameter("guar_st")==null?"":request.getParameter("guar_st");
	
	String client_share_st	= request.getParameter("client_share_st")==null?"":request.getParameter("client_share_st");
	
	// ContEtc insert 
	cont_etc = a_db.getContEtc(rent_mng_id, new_rent_l_cd);
	
	cont_etc.setClient_guar_st	(client_guar_st);
	cont_etc.setGuar_st		(guar_st);
	cont_etc.setGuar_con		(guar_con);
	cont_etc.setGuar_sac_id		(guar_sac_id);
	cont_etc.setClient_share_st	(client_share_st);
	
	if(cont_etc.getRent_mng_id().equals("")){
		//=====[cont_etc] insert=====
		cont_etc.setRent_mng_id	(rent_mng_id);
		cont_etc.setRent_l_cd	(new_rent_l_cd);
		flag5 = a_db.insertContEtc(cont_etc);
	}else{
		//=====[cont_etc] update=====
		flag5 = a_db.updateContEtc(cont_etc);
	}
	
	
	//cont_gur
	String gur_nm[] 	= request.getParameterValues("gur_nm");
	String gur_ssn[] 	= request.getParameterValues("gur_ssn");
	String gur_tel[] 	= request.getParameterValues("gur_tel");
	String gur_rel[] 	= request.getParameterValues("gur_rel");
	
	int gur_size = gur_nm.length;
	
	for(int i = 0 ; i < gur_size ; i++){
	
		if(!gur_nm[i].equals("") && guar_st.equals("1")){
			ContGurBean gur = a_db.getContGur(rent_mng_id, new_rent_l_cd, String.valueOf(i));
			gur.setGur_nm		(gur_nm[i]);
			gur.setGur_ssn		(gur_ssn[i]);
			gur.setGur_zip		(t_zip[i+2]);
			gur.setGur_addr		(t_addr[i+2]);
			gur.setGur_tel		(gur_tel[i]);
			gur.setGur_rel		(gur_rel[i]);
			
			if(gur.getRent_l_cd().equals("")){
				gur.setRent_mng_id	(rent_mng_id);
				gur.setRent_l_cd	(new_rent_l_cd);
				gur.setGur_id		(String.valueOf(i));
				//=====[CONT_GUR] update=====
				flag6 = a_db.insertContGur(gur);
				
			}else{
				//=====[CONT_GUR] update=====
				flag6 = a_db.updateContGur(gur);
			}
		}
	}


	// 고객FMS임시아이디 지정-----------------------------------------------------------------------------------------------
	MemberBean m_bean = m_db.getMemberCase(client_id, "", "");
	int count2 = 0;
	if(m_bean.getMember_id().equals("")){
	
		//회원정보 등록
		MemberBean no_m_bean = m_db.getNoMemberCase(client_id, "", "");
		
		int idcnt = m_db.checkMemberIdPwd("amazoncar", no_m_bean.getPwd());
			
		if(idcnt==0){
				count2 = m_db.insertMember(client_id, "", "amazoncar", no_m_bean.getPwd(), "");
		}else{
				count2 = m_db.updateMemberUseYN(client_id); //기존 use_yn='N'를'Y'로 처리 			
		}			
		
	}


	//원계약 해지처리-----------------------------------------------------------------------------------------------
	
	//cont
	base = a_db.getCont(rent_mng_id, rent_l_cd);
	base.setUse_yn		("N");
	
	//=====[cont] update=====
	flag8 = a_db.updateContBaseNew(base);
	
	
	
	String con_f_nm 	= request.getParameter("con_f_nm")==null?"":request.getParameter("con_f_nm");
	String insur_per 	= request.getParameter("insur_per")==null?"":request.getParameter("insur_per");
	String i_com_emp_yn 	= request.getParameter("i_com_emp_yn")==null?"":request.getParameter("i_com_emp_yn");

	String conr_nm 		= request.getParameter("conr_nm")==null?"":request.getParameter("conr_nm");
	String insurant 	= request.getParameter("insurant")==null?"":request.getParameter("insurant");
	String com_emp_yn 		= request.getParameter("com_emp_yn")==null?"":request.getParameter("com_emp_yn");
	
	
	
	
	
	if(!con_f_nm.equals("아마존카") || insur_per.equals("2") || !conr_nm.equals("아마존카") || insurant.equals("2") || !i_com_emp_yn.equals(com_emp_yn)){
		
			//2. 쿨메신저 메세지 전송------------------------------------------------------------------------------------------
			
			String firm_nm	= request.getParameter("firm_nm")==null?"":request.getParameter("firm_nm");
			String sub 	= "계약승계 피보험자/보험계약자/임직원운전한정특약-고객";
			String cont 	= "[ "+rent_l_cd+" "+firm_nm+" ] 계약승계 ";
			String target_id = nm_db.getWorkAuthUser("부산보험담당");
			
			cont = cont + ec_db.getContCngInsCngMsg(rent_mng_id, new_rent_l_cd, String.valueOf(fee_size));
			
			//보험변경요청 프로시저 호출
			String  d_flag2 =  ec_db.call_sp_ins_cng_req(sub, rent_mng_id, new_rent_l_cd, String.valueOf(fee_size));
			
			
			CarSchDatabase csd = CarSchDatabase.getInstance();
			CarScheBean cs_bean = csd.getCarScheTodayBean(target_id);
			if(!cs_bean.getUser_id().equals("") && !cs_bean.getWork_id().equals(""))	target_id = cs_bean.getWork_id();
			
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
			//System.out.println("쿨메신저("+rent_l_cd+" [계약승계] 피보험자/보험계약자/임직원운전한정특약 )-----------------------"+target_bean.getUser_nm());
			//System.out.println(xml_data);	
			
	}
	
	if(vt_size1 > 0 ){
		String firm_nm	= request.getParameter("firm_nm")==null?"":request.getParameter("firm_nm");
		String car_no	= request.getParameter("car_no")==null?"":request.getParameter("car_no");
		String target_id = nm_db.getWorkAuthUser("보험담당자");			
		UsersBean target_bean 	= umd.getUsersBean(target_id);
		UsersBean sender_bean 	= umd.getUsersBean(user_id);
	
		String sub 	 = "고객피보험자 고객변경";
		String cont  = "고객피보험자차량이 계약승계로 고객이 변경되었습니다. 보험 관련사항 확인바랍니다.  &lt;br&gt; &lt;br&gt; "
	                     + car_no + "  &lt;br&gt; &lt;br&gt; "+client_old.getFirm_nm()+"에서 "+firm_nm+"로 변경";
		
		String xml_data = "";
		xml_data =  "<COOLMSG>"+
  				"  <ALERTMSG>"+
				"    <BACKIMG>4</BACKIMG>"+
				"    <MSGTYPE>104</MSGTYPE>"+
				"    <SUB>"+sub+"</SUB>"+
  				"    <CONT>"+cont+"</CONT>"+
				"    <URL></URL>"+
				"	 <TARGET>"+target_bean.getId()+"</TARGET>"+
				"    <SENDER>"+sender_bean.getId()+"</SENDER>"+
				"    <MSGICON>10</MSGICON>"+
				"    <MSGSAVE>1</MSGSAVE>"+
				"    <LEAVEDMSG>1</LEAVEDMSG>"+
  				"    <FLDTYPE>1</FLDTYPE>"+
				"  </ALERTMSG>"+
				"</COOLMSG>";
	
		CdAlertBean msg = new CdAlertBean();
		msg.setFlddata(xml_data);
		msg.setFldtype("1");
		cm_db.insertCoolMsg(msg);
	}		
	
	
	
	//이행보증보험-----------------------------------------------------------------------------------------------
	
	//gua_ins
	ContGiInsBean gins 	= a_db.getContGiInsNew(rent_mng_id, new_rent_l_cd, Integer.toString(fee_size));
	
	
	gins.setGi_no		("[계약승계]"+Integer.toString(fee_size));
	gins.setGi_reason	("");
	gins.setGi_sac_id	("");
	gins.setGi_jijum	(request.getParameter("gi_jijum")==null?"":request.getParameter("gi_jijum"));
	gins.setGi_amt		(request.getParameter("gi_amt")	==null? 0:AddUtil.parseDigit(request.getParameter("gi_amt")));
	gins.setGi_fee		(request.getParameter("gi_fee")	==null? 0:AddUtil.parseDigit(request.getParameter("gi_fee")));
	gins.setGi_month	(request.getParameter("gi_month")==null?"":request.getParameter("gi_month"));	//보증보험 가입개월 추가(2018.03.20)
	
	
	String gi_st = request.getParameter("gi_st")==null?"0":request.getParameter("gi_st");
	
	if(gi_st.equals("1") && gins.getGi_jijum().equals("") && gins.getGi_amt() == 0 && gins.getGi_fee() == 0 && gins.getGi_month().equals("")){
		gi_st = "0";
	}	
	if(gi_st.equals("0") && gins.getGi_amt() > 0 && gins.getGi_fee() > 0){
		gi_st = "1";
	}
	
	gins.setGi_st		(gi_st);
	
	//car_etc
	car 	= a_db.getContCarNew(rent_mng_id, new_rent_l_cd);
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
  						"    <SUB>보증보험가입 계약승계 등록</SUB>"+
		  				"    <CONT>보증보험가입 계약승계 등록 : "+new_rent_l_cd+"</CONT>"+
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
			gins.setRent_l_cd	(new_rent_l_cd);
			gins.setRent_st		(Integer.toString(fee_size));
			flag2 = a_db.insertGiInsNew(gins);
		}else{
			//=====[gua_ins] update=====
			flag2 = a_db.updateGiInsNew(gins);
		}	

		
	//고객별 최종스캔 동기화
	String  d_flag1 =  admin_db.call_sp_lc_rent_scanfile_syn2(cls_st, rent_mng_id, rent_l_cd, new_rent_l_cd, user_id);
	
	
	
	//자동차기본정보
	CarMstBean cm_bean = cmb.getCarNmCase(String.valueOf(car.getCar_id()), String.valueOf(car.getCar_seq()));	
	
	CarRegBean cr_bean = crd.getCarRegBean(base.getCar_mng_id());
	
	//임직원전용보험 대상 보험담당자에게 메시지 발송
	if(1==1){
	//if(client_new.getClient_st().equals("1") && !client_new.getFirm_type().equals("10") && AddUtil.parseInt(cm_bean.getS_st())>101 && AddUtil.parseInt(cm_bean.getS_st()) < 600){
		
			//2. 쿨메신저 메세지 전송------------------------------------------------------------------------------------------
			

			String sub 	= "계약승계 업무용승용차 임직원전용보험 대상 통보";
			String cont 	= "[ "+new_rent_l_cd+" "+client_new.getFirm_nm()+" ] 임직원 ";
			String target_id = nm_db.getWorkAuthUser("부산보험담당");
			
			//20160905 계약승계 등록시 무조건 보험담당자에게 통보한다.
			sub = "계약승계 등록";
			cont 	= "[ "+rent_l_cd+" "+client_old.getFirm_nm()+" -> "+new_rent_l_cd+" "+client_new.getFirm_nm()+" "+cr_bean.getCar_no()+" ] 계약승계 ";
						
			cont = cont + ec_db.getContCngInsCngMsg(rent_mng_id, new_rent_l_cd, String.valueOf(fee_size));
			
			//보험변경요청 프로시저 호출
			String  d_flag2 =  ec_db.call_sp_ins_cng_req(sub, rent_mng_id, new_rent_l_cd, String.valueOf(fee_size));
			
			CarSchDatabase csd = CarSchDatabase.getInstance();
			CarScheBean cs_bean = csd.getCarScheTodayBean(target_id);
			if(!cs_bean.getUser_id().equals("") && !cs_bean.getWork_id().equals(""))	target_id = cs_bean.getWork_id();
			
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
	

	
	
	
	

%>
<form name='form1' method='post'>
  <input type="hidden" name="auth_rw" 			value="<%=auth_rw%>">
  <input type="hidden" name="user_id" 			value="<%=user_id%>">
  <input type="hidden" name="br_id" 			value="<%=br_id%>">    
  <input type="hidden" name="rent_mng_id" 		value="<%=rent_mng_id%>">
  <input type="hidden" name="rent_l_cd" 		value="<%=new_rent_l_cd%>">  
  <input type="hidden" name="c_st" 				value="fee">    
  <input type="hidden" name="now_stat" 			value="계약승계">        
</form>
<script language='javascript'>
	var fm = document.form1;

	
<%		if(!flag1){	%>
		alert('원계약 해지정보 등록 에러입니다.\n\n확인하십시오');
<%		}	%>		

<%		if(!flag2){	%>
		alert('승계계약 기본정보 등록 에러입니다.\n\n확인하십시오');
<%		}	%>		

<%		if(!flag3){	%>
		alert('관련테이블 등록 에러입니다.\n\n확인하십시오');
<%		}	%>		

<%		if(!flag4){	%>
		alert('관계자 등록 에러입니다.\n\n확인하십시오');
<%		}	%>		

<%		if(!flag5){	%>
		alert('대표자보증 등록 에러입니다.\n\n확인하십시오');
<%		}	%>		

<%		if(!flag6){	%>
		alert('연대보증 등록 에러입니다.\n\n확인하십시오');
<%		}	%>		

<%		if(!flag7){	%>
		alert('대여료스케줄 이관 에러입니다.\n\n확인하십시오');
<%		}	%>		

<%		if(!flag8){	%>
		alert('원계약 기본정보 수정 에러입니다.\n\n확인하십시오');
<%		}	%>		


	
	fm.action = '/agent/lc_rent/lc_b_u.jsp';
	fm.target = 'd_content';
	fm.submit();

</script>
</body>
</html>