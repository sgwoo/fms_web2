<%@ page language="java" contentType="text/html; charset=euc-kr" %>
<%@ page import="java.util.*, acar.util.*, acar.estimate_mng.*, acar.car_mst.*, acar.secondhand.*, acar.user_mng.*" %>
<jsp:useBean id="cm_bean" class="acar.car_mst.CarMstBean" scope="page"/>
<jsp:useBean id="ej_bean" class="acar.estimate_mng.EstiJgVarBean" scope="page"/>
<jsp:useBean id="shDb" class="acar.secondhand.SecondhandDatabase" scope="page"/>
<%@ include file="/acar/cookies.jsp" %>

<%
	String auth_rw 		= request.getParameter("auth_rw")==null?"":request.getParameter("auth_rw");
	String br_id 		= request.getParameter("br_id")==null?"":request.getParameter("br_id");
	String user_id 		= request.getParameter("user_id")==null?"":request.getParameter("user_id");
	String gubun1 		= request.getParameter("gubun1")==null?"":request.getParameter("gubun1");
	String gubun2 		= request.getParameter("gubun2")==null?"":request.getParameter("gubun2");
	String gubun3 		= request.getParameter("gubun3")==null?"1":request.getParameter("gubun3");
	String s_dt 		= request.getParameter("s_dt")==null?"":request.getParameter("s_dt");
	String e_dt 		= request.getParameter("e_dt")==null?"":request.getParameter("e_dt");
	String s_kd 		= request.getParameter("s_kd")==null?"":request.getParameter("s_kd");
	String t_wd 		= request.getParameter("t_wd")==null?"":request.getParameter("t_wd");
	String cmd 		= request.getParameter("cmd")==null?"i":request.getParameter("cmd");
	String base_dt 		= request.getParameter("base_dt")==null?"":request.getParameter("base_dt");	
	String from_page	= request.getParameter("from_page")==null?"":request.getParameter("from_page");	
	
	String car_comp_id 	= request.getParameter("car_comp_id")==null?"":request.getParameter("car_comp_id");	
	String reg_dt 		= request.getParameter("reg_dt")==null?"":request.getParameter("reg_dt");
	String action_st 	= request.getParameter("action_st")==null?"":request.getParameter("action_st");
	String car_id 		= request.getParameter("car_id")==null?"":request.getParameter("car_id");
	String car_seq 		= request.getParameter("car_seq")==null?"":request.getParameter("car_seq");
	int    r_o_l 		= request.getParameter("r_o_l")==null?0:AddUtil.parseDigit(request.getParameter("r_o_l"));
	int    r_dc_amt 	= request.getParameter("r_dc_amt")==null?0:AddUtil.parseDigit(request.getParameter("r_dc_amt"));
	
	float  rg_8 		= request.getParameter("rg_8")==null?0:AddUtil.parseFloat(request.getParameter("rg_8"));
	int    rg_8_amt 	= request.getParameter("rg_8_amt")==null?0:AddUtil.parseDigit(request.getParameter("rg_8_amt"));	
	float  rg_8_2 		= request.getParameter("rg_8_2")==null?0:AddUtil.parseFloat(request.getParameter("rg_8_2"));
	int    rg_8_amt_2 	= request.getParameter("rg_8_amt_2")==null?0:AddUtil.parseDigit(request.getParameter("rg_8_amt_2"));
	
	float  rg_82 		= request.getParameter("rg_82")==null?0:AddUtil.parseFloat(request.getParameter("rg_82"));
	int    rg_8_amt2 	= request.getParameter("rg_8_amt2")==null?0:AddUtil.parseDigit(request.getParameter("rg_8_amt2"));
	float  rg_8_22 		= request.getParameter("rg_8_22")==null?0:AddUtil.parseFloat(request.getParameter("rg_8_22"));
	int    rg_8_amt_22	= request.getParameter("rg_8_amt_22")==null?0:AddUtil.parseDigit(request.getParameter("rg_8_amt_22"));

	int    dc_amt2 		= request.getParameter("dc_amt2")==null?0:AddUtil.parseDigit(request.getParameter("dc_amt2"));
	int    o_12 		= request.getParameter("o_12")==null?0:AddUtil.parseDigit(request.getParameter("o_12"));

	String ls_yn 		= request.getParameter("ls_yn")==null?"":request.getParameter("ls_yn");
	
	String value0[]   	= request.getParameterValues("ro_13");
	String value1[]   	= request.getParameterValues("ro_13_amt");
	String value2[]    	= request.getParameterValues("o_13");
	
	int count = 0;
	
	
	AddCarMstDatabase a_cmb = AddCarMstDatabase.getInstance();
	EstiDatabase e_db = EstiDatabase.getInstance();
	MaMenuDatabase nm_db = MaMenuDatabase.getInstance();
	
	

	
	String reg_code  = Long.toString(System.currentTimeMillis());
	
	EstimateBean bean = new EstimateBean();
	
	
	bean.setEst_ssn		(request.getParameter("est_ssn")==null?"":request.getParameter("est_ssn"));
	bean.setEst_tel		(request.getParameter("est_tel")==null?"":request.getParameter("est_tel"));
	bean.setEst_fax		(request.getParameter("est_fax")==null?"":request.getParameter("est_fax"));
	bean.setReg_code	(reg_code);
	bean.setSet_code	(reg_code);
	bean.setCar_comp_id	(request.getParameter("car_comp_id")==null?"":request.getParameter("car_comp_id"));
	bean.setCar_cd		(request.getParameter("code")==null?"":request.getParameter("code"));
	bean.setCar_id		(request.getParameter("car_id")==null?"":request.getParameter("car_id"));
	bean.setCar_seq		(request.getParameter("car_seq")==null?"":request.getParameter("car_seq"));
	bean.setCar_amt		(request.getParameter("car_amt")==null?0:AddUtil.parseDigit(request.getParameter("car_amt")));
	bean.setOpt		(request.getParameter("opt")==null?"":request.getParameter("opt"));
	bean.setOpt_seq		(request.getParameter("opt_seq")==null?"":request.getParameter("opt_seq"));
	bean.setOpt_amt		(request.getParameter("opt_amt")==null?0:AddUtil.parseDigit(request.getParameter("opt_amt")));
	bean.setCol		(request.getParameter("col")==null?"":request.getParameter("col"));
	bean.setCol_seq		(request.getParameter("col_seq")==null?"":request.getParameter("col_seq"));
	bean.setCol_amt		(request.getParameter("col_amt")==null?0:AddUtil.parseDigit(request.getParameter("col_amt")));
	bean.setDc		(request.getParameter("dc")==null?"":request.getParameter("dc"));
	bean.setDc_seq		(request.getParameter("dc_seq")==null?"":request.getParameter("dc_seq"));
	bean.setDc_amt		(request.getParameter("dc_amt")==null?0:AddUtil.parseDigit(request.getParameter("dc_amt")));
	bean.setEsti_d_etc	(request.getParameter("esti_d_etc")==null?"":request.getParameter("esti_d_etc"));
	bean.setO_1		(request.getParameter("o_1")==null?0:AddUtil.parseDigit(request.getParameter("o_1")));
	bean.setPp_st		(request.getParameter("pp_st")==null?"0":request.getParameter("pp_st"));
	bean.setPp_per		(request.getParameter("pp_per")==null?0:AddUtil.parseFloat(request.getParameter("pp_per")));
	bean.setPp_amt		(request.getParameter("pp_amt")==null?0:AddUtil.parseDigit(request.getParameter("pp_amt")));
	bean.setIns_good	(request.getParameter("ins_good")==null?"":request.getParameter("ins_good"));
	bean.setIns_age		(request.getParameter("ins_age")==null?"":request.getParameter("ins_age"));
	bean.setIns_dj		(request.getParameter("ins_dj")==null?"":request.getParameter("ins_dj"));
	bean.setG_10		(request.getParameter("g_10")==null?0:AddUtil.parseDigit(request.getParameter("g_10")));
	bean.setCar_ja		(request.getParameter("car_ja")==null?0:AddUtil.parseDigit(request.getParameter("car_ja")));
	bean.setLpg_yn		(request.getParameter("lpg_yn")==null?"0":request.getParameter("lpg_yn"));
	bean.setGi_yn		(request.getParameter("gi_yn")==null?"0":request.getParameter("gi_yn"));
	bean.setSpr_yn		(request.getParameter("spr_yn")==null?"0":request.getParameter("spr_yn"));
	bean.setUdt_st		(request.getParameter("udt_st")==null?"":request.getParameter("udt_st"));
	bean.setEst_st		(request.getParameter("est_st")==null?"":request.getParameter("est_st"));
	bean.setEst_from	("main_car");
	bean.setFrom_page	("main_car");
	bean.setReg_id		(user_id);
	bean.setReg_dt		(reg_dt);
	bean.setRent_dt		(AddUtil.getDate(4));
	
	bean.setAgree_dist	(request.getParameter("agree_dist")==null?0 :AddUtil.parseDigit(request.getParameter("agree_dist")));
	bean.setB_agree_dist	(request.getParameter("b_agree_dist")==null?0 :AddUtil.parseDigit(request.getParameter("b_agree_dist")));
	bean.setB_o_13		(request.getParameter("b_o_13")==null?0:AddUtil.parseFloat(request.getParameter("b_o_13")));
	bean.setLoc_st		(request.getParameter("loc_st")==null?"":request.getParameter("loc_st"));
	bean.setTint_b_yn	(request.getParameter("tint_b_yn")==null?"":request.getParameter("tint_b_yn"));
	bean.setTint_s_yn	(request.getParameter("tint_s_yn")==null?"":request.getParameter("tint_s_yn"));
	bean.setTint_n_yn	(request.getParameter("tint_n_yn")==null?"":request.getParameter("tint_n_yn"));
	bean.setTint_bn_yn	(request.getParameter("tint_bn_yn")==null?"":request.getParameter("tint_bn_yn"));
	bean.setNew_license_plate	(request.getParameter("new_license_plate")==null?"":request.getParameter("new_license_plate"));
	bean.setTint_cons_yn	(request.getParameter("tint_cons_yn")==null?"":request.getParameter("tint_cons_yn"));
	bean.setTint_cons_amt	(request.getParameter("tint_cons_amt")==null?0:AddUtil.parseDigit(request.getParameter("tint_cons_amt")));
	bean.setJg_opt_st	(request.getParameter("jg_opt_st")==null?"":request.getParameter("jg_opt_st"));
	bean.setJg_col_st	(request.getParameter("jg_col_st")==null?"":request.getParameter("jg_col_st"));
	bean.setEcar_loc_st(request.getParameter("ecar_loc_st")==null?"":request.getParameter("ecar_loc_st"));
	bean.setTax_dc_amt	(request.getParameter("tax_dc_amt")==null?0:AddUtil.parseDigit(request.getParameter("tax_dc_amt")));
	bean.setConti_rat	(request.getParameter("conti_rat")==null?"":request.getParameter("conti_rat"));
	bean.setJg_tuix_st			(request.getParameter("jg_tuix_st")==null?"":request.getParameter("jg_tuix_st"));
	bean.setJg_tuix_opt_st	(request.getParameter("jg_tuix_opt_st")==null?"":request.getParameter("jg_tuix_opt_st"));	
	bean.setHcar_loc_st(request.getParameter("hcar_loc_st")==null?"":request.getParameter("hcar_loc_st"));
	
	bean.setLkas_yn			(request.getParameter("lkas_yn")==null?"":request.getParameter("lkas_yn"));		// ������Ż ������
	bean.setLdws_yn			(request.getParameter("ldws_yn")==null?"":request.getParameter("ldws_yn"));	// ������Ż �����
	bean.setAeb_yn			(request.getParameter("aeb_yn")==null?"":request.getParameter("aeb_yn"));		// ������� ������
	bean.setFcw_yn			(request.getParameter("fcw_yn")==null?"":request.getParameter("fcw_yn"));		// ������� �����
	bean.setHook_yn			(request.getParameter("hook_yn")==null?"":request.getParameter("hook_yn"));		// ���ΰ�

	// ������Ż ����, �����, ������� ����, ����� �ɼǿ� ���ԵǾ� ���� ��� ESTIMATE ���̺� lkas_yn, ldws_yn, aeb_yn, fcw_yn ���� Y�� ����(2017.11.20) 	start
	if(request.getParameter("lkas_yn_opt_st") != null && request.getParameter("lkas_yn_opt_st").equals("Y")){
		bean.setLkas_yn("Y");
	}
	if(request.getParameter("ldws_yn_opt_st") != null && request.getParameter("ldws_yn_opt_st").equals("Y")){
		bean.setLdws_yn("Y");
	}
	if(request.getParameter("aeb_yn_opt_st") != null && request.getParameter("aeb_yn_opt_st").equals("Y")){
		bean.setAeb_yn("Y");
	}
	if(request.getParameter("fcw_yn_opt_st") != null && request.getParameter("fcw_yn_opt_st").equals("Y")){
		bean.setFcw_yn("Y");
	}
	if(request.getParameter("hook_yn_opt_st") != null && request.getParameter("hook_yn_opt_st").equals("Y")){
		bean.setHook_yn("Y");
	}
	// ÷�ܾ��� ��ġ �ɼ� ���� end	
	
	//����D/C �鼼���� ����
	if(r_o_l >0) 	bean.setO_1	(r_o_l);
	if(r_dc_amt >0) bean.setDc_amt	(r_dc_amt);
	
	if(nm_db.getWorkAuthUser("������",ck_acar_id) && bean.getRent_dt().equals("20190213"))	bean.setRent_dt		("20190214");
	
	String jg_b_dt = e_db.getVar_b_dt("jg", bean.getRent_dt());
	String em_a_j  = e_db.getVar_b_dt("em", bean.getRent_dt());	

	//���� ������ ������ �� �ֱ� ���׷��̵� ���� ��������
	cm_bean = a_cmb.getCarNmCase(car_id, car_seq);
	
	//�ܰ�����NEW
	ej_bean = e_db.getEstiJgVarCase(cm_bean.getJg_code(), jg_b_dt);
	
	
	
	String est_id[]	 		= new String[60];
	String est_nm[]	 		= new String[60];
	String a_a[]	 		= new String[60];
	
	
	int est_size = 60;
	
	//20090915 ���� ��� ��������Ÿ� ���
//	est_size = 12;
	
	//20100325 ���� ��� 24���� ������ �߰�
//	est_size = 24;
	
	//20110331 ���� ��� 12���� ������ �߰�
//	est_size = 36;
	
	//20140822 ���� ��� 48���� ������ �߰�
//	est_size = 48;

	//20150326 ���� ��� 60���� ������ �߰�  -> 20150512 ���� 60����, ��Ʈ 54���� --> 20151211 ��� 60����
//	est_size = 60;
	

	for(int i = 0 ; i < est_size ; i++){
		
		EstimateBean a_bean = new EstimateBean();
		
		a_bean = bean;
		
		a_bean.setEtc(cm_bean.getEtc2());
		
		
			
			
			//20140912 ���Ⱓ �������� (36:15->18, 48:20->24, 24:10->12, 12:5->6)
						
			
			//36����
			
			//------------------------------------------------------
			if(i==0){
				a_bean.setEst_nm	("rb36_f");
				a_bean.setMgr_ssn	("");
				a_bean.setEst_st	("1");
				a_bean.setA_b		("36");
				a_bean.setIns_per	("1");
				a_bean.setJob		("org");				
			}
			if(i==1){
				a_bean.setEst_nm	("rb18_f");
				a_bean.setMgr_ssn	("rb36_f");//�����
				a_bean.setEst_st	("2");
				a_bean.setA_b		("18");
				a_bean.setIns_per	("1");
				a_bean.setJob		("cls");				
			}						
			//------------------------------------------------------
			if(i==2){
				a_bean.setEst_nm	("rs36_f");
				a_bean.setMgr_ssn	("");
				a_bean.setEst_st	("1");
				a_bean.setA_b		("36");
				a_bean.setIns_per	("1");
				a_bean.setJob		("org");				
			}
			if(i==3){
				a_bean.setEst_nm	("rs18_f");
				a_bean.setMgr_ssn	("rs36_f");//�����
				a_bean.setEst_st	("2");
				a_bean.setA_b		("18");
				a_bean.setIns_per	("1");
				a_bean.setJob		("cls");				
			}
			//------------------------------------------------------
			if(i==4){
				a_bean.setEst_nm	("lb36_f");
				a_bean.setMgr_ssn	("");
				a_bean.setEst_st	("1");
				a_bean.setA_b		("36");
				a_bean.setIns_per	("1");
				a_bean.setJob		("org");				
			}
			if(i==5){
				a_bean.setEst_nm	("lb18_f");
				a_bean.setMgr_ssn	("lb36_f");//�����
				a_bean.setEst_st	("2");
				a_bean.setA_b		("18");
				a_bean.setIns_per	("1");
				a_bean.setJob		("cls");				
			}
			//------------------------------------------------------
			if(i==6){
				a_bean.setEst_nm	("ls36_f");
				a_bean.setMgr_ssn	("");
				a_bean.setEst_st	("1");
				a_bean.setA_b		("36");
				a_bean.setIns_per	("1");
				a_bean.setJob		("org");
			}
			if(i==7){
				a_bean.setEst_nm	("ls18_f");
				a_bean.setMgr_ssn	("ls36_f");//�����
				a_bean.setEst_st	("2");
				a_bean.setA_b		("18");
				a_bean.setIns_per	("1");
				a_bean.setJob		("cls");
			}
			//------------------------------------------------------
			if(i==8){
				a_bean.setEst_nm	("lb362_f");
				a_bean.setMgr_ssn	("");
				a_bean.setEst_st	("1");
				a_bean.setA_b		("36");
				a_bean.setIns_per	("2");
				a_bean.setJob		("org");				
			}
			if(i==9){
				a_bean.setEst_nm	("lb182_f");
				a_bean.setMgr_ssn	("lb362_f");//�����
				a_bean.setEst_st	("2");
				a_bean.setA_b		("18");
				a_bean.setIns_per	("2");
				a_bean.setJob		("cls");
			}
			//------------------------------------------------------
			if(i==10){
				a_bean.setEst_nm	("ls362_f");
				a_bean.setMgr_ssn	("");
				a_bean.setEst_st	("1");
				a_bean.setA_b		("36");
				a_bean.setIns_per	("2");
				a_bean.setJob		("org");
			}
			if(i==11){
				a_bean.setEst_nm	("ls182_f");
				a_bean.setMgr_ssn	("ls362_f");//�����
				a_bean.setEst_st	("2");
				a_bean.setA_b		("18");
				a_bean.setIns_per	("2");
				a_bean.setJob		("cls");
			}
			//------------------------------------------------------
			//24����
			if(i==12){
				a_bean.setEst_nm	("rb24_f");	
				a_bean.setMgr_ssn	("");
				a_bean.setEst_st	("1");
				a_bean.setA_b		("24");
				a_bean.setIns_per	("1");
				a_bean.setJob		("org");
			}
			if(i==13){
				a_bean.setEst_nm	("rb12_f");	
				a_bean.setMgr_ssn	("rb24_f");//�����	
				a_bean.setEst_st	("2");
				a_bean.setA_b		("12");
				a_bean.setIns_per	("1");
				a_bean.setJob		("cls");
			}
			//------------------------------------------------------
			if(i==14){
				a_bean.setEst_nm	("rs24_f");	
				a_bean.setMgr_ssn	("");
				a_bean.setEst_st	("1");
				a_bean.setA_b		("24");
				a_bean.setIns_per	("1");
				a_bean.setJob		("org");
			}
			if(i==15){
				a_bean.setEst_nm	("rs12_f");	
				a_bean.setMgr_ssn	("rs24_f");//�����	
				a_bean.setEst_st	("2");
				a_bean.setA_b		("12");
				a_bean.setIns_per	("1");
				a_bean.setJob		("cls");
			}
			//------------------------------------------------------
			if(i==16){
				a_bean.setEst_nm	("lb24_f");	
				a_bean.setMgr_ssn	("");
				a_bean.setEst_st	("1");
				a_bean.setA_b		("24");
				a_bean.setIns_per	("1");
				a_bean.setJob		("org");
			}
			if(i==17){
				a_bean.setEst_nm	("lb12_f");	
				a_bean.setMgr_ssn	("lb24_f");//�����	
				a_bean.setEst_st	("2");
				a_bean.setA_b		("12");
				a_bean.setIns_per	("1");
				a_bean.setJob		("cls");
			}
			//------------------------------------------------------
			if(i==18){
				a_bean.setEst_nm	("ls24_f");	
				a_bean.setMgr_ssn	("");
				a_bean.setEst_st	("1");
				a_bean.setA_b		("24");
				a_bean.setIns_per	("1");
				a_bean.setJob		("org");
			}
			if(i==19){
				a_bean.setEst_nm	("ls12_f");	
				a_bean.setMgr_ssn	("ls24_f");//�����	
				a_bean.setEst_st	("2");
				a_bean.setA_b		("12");
				a_bean.setIns_per	("1");
				a_bean.setJob		("cls");
			}
			//------------------------------------------------------
			if(i==20){
				a_bean.setEst_nm	("lb242_f");
				a_bean.setMgr_ssn	("");//�����
				a_bean.setEst_st	("1");
				a_bean.setA_b		("24");
				a_bean.setIns_per	("2");
				a_bean.setJob		("org");
			}
			if(i==21){
				a_bean.setEst_nm	("lb122_f");
				a_bean.setMgr_ssn	("lb242_f");//�����
				a_bean.setEst_st	("2");
				a_bean.setA_b		("12");
				a_bean.setIns_per	("2");
				a_bean.setJob		("cls");
			}
			//------------------------------------------------------
			if(i==22){
				a_bean.setEst_nm	("ls242_f");
				a_bean.setMgr_ssn	("");//�����
				a_bean.setEst_st	("1");
				a_bean.setA_b		("24");
				a_bean.setIns_per	("2");
				a_bean.setJob		("org");
			}
			if(i==23){
				a_bean.setEst_nm	("ls122_f");
				a_bean.setMgr_ssn	("ls242_f");//�����
				a_bean.setEst_st	("2");
				a_bean.setA_b		("12");
				a_bean.setIns_per	("2");
				a_bean.setJob		("cls");
			}
			//------------------------------------------------------
			//12����
			if(i==24){
				a_bean.setEst_nm	("rb12_f");
				a_bean.setMgr_ssn	("");//�����
				a_bean.setEst_st	("1");
				a_bean.setA_b		("12");
				a_bean.setIns_per	("1");
				a_bean.setJob		("org");
			}
			if(i==25){
				a_bean.setEst_nm	("rb6_f");
				a_bean.setMgr_ssn	("rb12_f");//�����
				a_bean.setEst_st	("2");
				a_bean.setA_b		("6");
				a_bean.setIns_per	("1");
				a_bean.setJob		("cls");
			}
			//------------------------------------------------------
			if(i==26){
				a_bean.setEst_nm	("rs12_f");
				a_bean.setMgr_ssn	("");//�����
				a_bean.setEst_st	("1");
				a_bean.setA_b		("12");
				a_bean.setIns_per	("1");
				a_bean.setJob		("org");
			}
			if(i==27){
				a_bean.setEst_nm	("rs6_f");
				a_bean.setMgr_ssn	("rs12_f");//�����
				a_bean.setEst_st	("2");
				a_bean.setA_b		("6");
				a_bean.setIns_per	("1");
				a_bean.setJob		("cls");
			}
			//------------------------------------------------------
			if(i==28){
				a_bean.setEst_nm	("lb12_f");
				a_bean.setMgr_ssn	("");//�����
				a_bean.setEst_st	("1");
				a_bean.setA_b		("12");
				a_bean.setIns_per	("1");
				a_bean.setJob		("org");
			}
			if(i==29){
				a_bean.setEst_nm	("lb6_f");
				a_bean.setMgr_ssn	("lb12_f");//�����
				a_bean.setEst_st	("2");
				a_bean.setA_b		("6");
				a_bean.setIns_per	("1");
				a_bean.setJob		("cls");
			}
			//------------------------------------------------------
			if(i==30){
				a_bean.setEst_nm	("ls12_f");	
				a_bean.setMgr_ssn	("");//�����
				a_bean.setEst_st	("1");
				a_bean.setA_b		("12");
				a_bean.setIns_per	("1");
				a_bean.setJob		("org");
			}
			if(i==31){
				a_bean.setEst_nm	("ls6_f");	
				a_bean.setMgr_ssn	("ls12_f");//�����	
				a_bean.setEst_st	("2");
				a_bean.setA_b		("6");
				a_bean.setIns_per	("1");
				a_bean.setJob		("cls");
			}
			//------------------------------------------------------
			if(i==32){
				a_bean.setEst_nm	("lb122_f");
				a_bean.setMgr_ssn	("");//�����
				a_bean.setEst_st	("1");
				a_bean.setA_b		("12");
				a_bean.setIns_per	("2");
				a_bean.setJob		("org");
			}
			if(i==33){
				a_bean.setEst_nm	("lb62_f");	
				a_bean.setMgr_ssn	("lb122_f");//�����
				a_bean.setEst_st	("2");
				a_bean.setA_b		("6");
				a_bean.setIns_per	("2");
				a_bean.setJob		("cls");
			}
			//------------------------------------------------------
			if(i==34){
				a_bean.setEst_nm	("ls122_f");
				a_bean.setMgr_ssn	("");//�����
				a_bean.setEst_st	("1");
				a_bean.setA_b		("12");
				a_bean.setIns_per	("2");
				a_bean.setJob		("org");
			}
			if(i==35){
				a_bean.setEst_nm	("ls62_f");	
				a_bean.setMgr_ssn	("ls122_f");//�����
				a_bean.setEst_st	("2");
				a_bean.setA_b		("6");
				a_bean.setIns_per	("2");
				a_bean.setJob		("cls");
			}
			//------------------------------------------------------
			//48����
			if(i==36){
				a_bean.setEst_nm	("rb48_f");
				a_bean.setMgr_ssn	("");//�����
				a_bean.setEst_st	("1");
				a_bean.setA_b		("48");
				a_bean.setIns_per	("1");
				a_bean.setJob		("org");
			}
			if(i==37){
				a_bean.setEst_nm	("rb24_f");
				a_bean.setMgr_ssn	("rb48_f");//�����
				a_bean.setEst_st	("2");
				a_bean.setA_b		("24");
				a_bean.setIns_per	("1");
				a_bean.setJob		("cls");
			}
			//------------------------------------------------------
			if(i==38){
				a_bean.setEst_nm	("rs48_f");
				a_bean.setMgr_ssn	("");//�����
				a_bean.setEst_st	("1");
				a_bean.setA_b		("48");
				a_bean.setIns_per	("1");
				a_bean.setJob		("org");
			}
			if(i==39){
				a_bean.setEst_nm	("rs24_f");
				a_bean.setMgr_ssn	("rs48_f");//�����
				a_bean.setEst_st	("2");
				a_bean.setA_b		("24");
				a_bean.setIns_per	("1");
				a_bean.setJob		("cls");
			}
			//------------------------------------------------------
			if(i==40){
				a_bean.setEst_nm	("lb48_f");
				a_bean.setMgr_ssn	("");//�����
				a_bean.setEst_st	("1");
				a_bean.setA_b		("48");
				a_bean.setIns_per	("1");
				a_bean.setJob		("org");
			}
			if(i==41){
				a_bean.setEst_nm	("lb24_f");
				a_bean.setMgr_ssn	("lb48_f");//�����
				a_bean.setEst_st	("2");
				a_bean.setA_b		("24");
				a_bean.setIns_per	("1");
				a_bean.setJob		("cls");
			}
			//------------------------------------------------------
			if(i==42){
				a_bean.setEst_nm	("ls48_f");	
				a_bean.setMgr_ssn	("");//�����
				a_bean.setEst_st	("1");
				a_bean.setA_b		("48");
				a_bean.setIns_per	("1");
				a_bean.setJob		("org");
			}
			if(i==43){
				a_bean.setEst_nm	("ls24_f");	
				a_bean.setMgr_ssn	("ls48_f");//�����	
				a_bean.setEst_st	("2");
				a_bean.setA_b		("24");
				a_bean.setIns_per	("1");
				a_bean.setJob		("cls");
			}
			//------------------------------------------------------
			if(i==44){
				a_bean.setEst_nm	("lb482_f");
				a_bean.setMgr_ssn	("");//�����
				a_bean.setEst_st	("1");
				a_bean.setA_b		("48");
				a_bean.setIns_per	("2");
				a_bean.setJob		("org");
			}
			if(i==45){
				a_bean.setEst_nm	("lb242_f");	
				a_bean.setMgr_ssn	("lb482_f");//�����
				a_bean.setEst_st	("2");
				a_bean.setA_b		("24");
				a_bean.setIns_per	("2");
				a_bean.setJob		("cls");
			}
			//------------------------------------------------------
			if(i==46){
				a_bean.setEst_nm	("ls482_f");
				a_bean.setMgr_ssn	("");//�����
				a_bean.setEst_st	("1");
				a_bean.setA_b		("48");
				a_bean.setIns_per	("2");
				a_bean.setJob		("org");
			}
			if(i==47){
				a_bean.setEst_nm	("ls242_f");	
				a_bean.setMgr_ssn	("ls482_f");//�����
				a_bean.setEst_st	("2");
				a_bean.setA_b		("24");
				a_bean.setIns_per	("2");
				a_bean.setJob		("cls");
			}
			//------------------------------------------------------
			//60���� -> 20150512 ���� 60����, ��Ʈ 54���� --> 20151211 ��� 60����
			if(i==48){
				a_bean.setEst_nm	("rb60_f");
				a_bean.setMgr_ssn	("");//�����
				a_bean.setEst_st	("1");
				a_bean.setA_b		("60");
				a_bean.setIns_per	("1");
				a_bean.setJob		("org");
			}
			if(i==49){
				a_bean.setEst_nm	("rb30_f");
				a_bean.setMgr_ssn	("rb60_f");//�����
				a_bean.setEst_st	("2");
				a_bean.setA_b		("30");
				a_bean.setIns_per	("1");
				a_bean.setJob		("cls");
			}
			//------------------------------------------------------
			if(i==50){
				a_bean.setEst_nm	("rs60_f");
				a_bean.setMgr_ssn	("");//�����
				a_bean.setEst_st	("1");
				a_bean.setA_b		("60");
				a_bean.setIns_per	("1");
				a_bean.setJob		("org");
			}
			if(i==51){
				a_bean.setEst_nm	("rs30_f");
				a_bean.setMgr_ssn	("rs60_f");//�����
				a_bean.setEst_st	("2");
				a_bean.setA_b		("30");
				a_bean.setIns_per	("1");
				a_bean.setJob		("cls");
			}
			//------------------------------------------------------
			if(i==52){
				a_bean.setEst_nm	("lb60_f");
				a_bean.setMgr_ssn	("");//�����
				a_bean.setEst_st	("1");
				a_bean.setA_b		("60");
				a_bean.setIns_per	("1");
				a_bean.setJob		("org");
			}
			if(i==53){
				a_bean.setEst_nm	("lb30_f");
				a_bean.setMgr_ssn	("lb60_f");//�����
				a_bean.setEst_st	("2");
				a_bean.setA_b		("30");
				a_bean.setIns_per	("1");
				a_bean.setJob		("cls");
			}
			//------------------------------------------------------
			if(i==54){
				a_bean.setEst_nm	("ls60_f");	
				a_bean.setMgr_ssn	("");//�����
				a_bean.setEst_st	("1");
				a_bean.setA_b		("60");
				a_bean.setIns_per	("1");
				a_bean.setJob		("org");
			}
			if(i==55){
				a_bean.setEst_nm	("ls30_f");	
				a_bean.setMgr_ssn	("ls60_f");//�����	
				a_bean.setEst_st	("2");
				a_bean.setA_b		("30");
				a_bean.setIns_per	("1");
				a_bean.setJob		("cls");
			}
			//------------------------------------------------------
			if(i==56){
				a_bean.setEst_nm	("lb602_f");
				a_bean.setMgr_ssn	("");//�����
				a_bean.setEst_st	("1");
				a_bean.setA_b		("60");
				a_bean.setIns_per	("2");
				a_bean.setJob		("org");
			}
			if(i==57){
				a_bean.setEst_nm	("lb302_f");	
				a_bean.setMgr_ssn	("lb602_f");//�����
				a_bean.setEst_st	("2");
				a_bean.setA_b		("30");
				a_bean.setIns_per	("2");
				a_bean.setJob		("cls");
			}
			//------------------------------------------------------
			if(i==58){
				a_bean.setEst_nm	("ls602_f");
				a_bean.setMgr_ssn	("");//�����
				a_bean.setEst_st	("1");
				a_bean.setA_b		("60");
				a_bean.setIns_per	("2");
				a_bean.setJob		("org");
			}
			if(i==59){
				a_bean.setEst_nm	("ls302_f");	
				a_bean.setMgr_ssn	("ls602_f");//�����
				a_bean.setEst_st	("2");
				a_bean.setA_b		("30");
				a_bean.setIns_per	("2");
				a_bean.setJob		("cls");
			}
			//------------------------------------------------------
		
		//�뿩��ǰ
		if(a_bean.getEst_nm().indexOf("rb") != -1)	a_bean.setA_a("22");
		if(a_bean.getEst_nm().indexOf("rs") != -1)	a_bean.setA_a("21");
		if(a_bean.getEst_nm().indexOf("lb") != -1)	a_bean.setA_a("12");
		if(a_bean.getEst_nm().indexOf("ls") != -1)	a_bean.setA_a("11");
		
		
		//����-��Ʈ-����2500�������� �������� 20%
		if(a_bean.getA_a().equals("22") || a_bean.getA_a().equals("21")){
			if(rg_8_2 >0){
				a_bean.setRg_8		(rg_8_2);
				a_bean.setRg_8_amt	(rg_8_amt_2);
			}else{
				a_bean.setRg_8		(rg_8);
				a_bean.setRg_8_amt	(rg_8_amt);
			}
		}else{
				a_bean.setRg_8		(rg_8);
				a_bean.setRg_8_amt	(rg_8_amt);
		}
		
		
		
		if(!from_page.equals("/acar/main_car/main_car_add_20090901.jsp")){
			//���������� ��� DC ����-->��Ʈ/�������ǻ���
			if(ls_yn.equals("Y") && (a_bean.getA_a().equals("12") || a_bean.getA_a().equals("11"))){
				a_bean.setDc			(request.getParameter("dc2")==null?"":request.getParameter("dc2"));
				a_bean.setDc_amt	(request.getParameter("dc_amt2")==null?0:AddUtil.parseDigit(request.getParameter("dc_amt2")));
				a_bean.setO_1			(request.getParameter("o_12")==null?0:AddUtil.parseDigit(request.getParameter("o_12")));			
				a_bean.setRg_8		(rg_82);
				a_bean.setRg_8_amt(rg_8_amt2);				
			}else{
				a_bean.setDc_amt	(request.getParameter("dc_amt")==null?0:AddUtil.parseDigit(request.getParameter("dc_amt")));
				a_bean.setO_1			(request.getParameter("o_1")==null?0:AddUtil.parseDigit(request.getParameter("o_1")));
			}
		}
		
		//�������
		a_bean.setA_h("7");
		
		
		
		//������
		if(ej_bean.getJg_g_7().equals("3")){
			//20200221 ������ ���ּ����� ���� �ǵ������ ����
			//1.����, 2.����, 3.�λ�, 4.����, 5.����, 6.��õ, 7.��õ, 8.����, 9.����, 10.�뱸
			
			a_bean.setA_h	("1");
			
			// ���� ����ȭ����(�����: ����) �� ��� ������ �� �ּ����� ���� ���� ��õ���� ���. 2021.02.18.
			// ���ּ����� ���� ���� ����ȭ������ �ǵ������ �뱸, ����¿����� �ǵ������ ��õ ���. 20220519
			if ( Integer.parseInt(cm_bean.getJg_code()) > 8000000 ) { // ����ȭ���� 
				a_bean.setA_h("10");		// �뱸
			} else {		// ����¿���
				a_bean.setA_h	("7");	// ��õ
			}
			
		}
		
		if(ej_bean.getJg_g_7().equals("4")){
			a_bean.setA_h	("7");//20191206 �������� ��õ���
			//a_bean.setA_h	("1");//20200324 �������� ������
		}

		//�����ε����� - ����Ʈ ����
		a_bean.setLoc_st("1");
		
		
		
		//��������
		if(a_bean.getA_a().equals("12")||a_bean.getA_a().equals("11")){//����
			a_bean.setO_11(0);
		}else{
			a_bean.setO_11(0);
		}
				
		//�뿩��D/C
		if(a_bean.getA_a().equals("12")||a_bean.getA_a().equals("11")){//����
			a_bean.setFee_dc_per(0.f);
		}else{
			a_bean.setFee_dc_per(0.f);
			//20121120 �������� ��� �������1(�뿩��D/C) -4% �ڵ�����
			if(ej_bean.getJg_w().equals("1")){
				//a_bean.setFee_dc_per(-4);
			}			
		}
		
		//������ ��å�� 500,000��
		if(ej_bean.getJg_w().equals("1")){
			bean.setCar_ja(500000);
		}
		
		//�ʱⳳ�Ա���
		a_bean.setPp_st		("0");
		if(a_bean.getG_10() > 0) 						a_bean.setPp_st		("1");//���ô뿩��
		if(a_bean.getPp_amt()+a_bean.getRg_8_amt() > 0) 			a_bean.setPp_st		("2");//������+������
		if(a_bean.getPp_per()+a_bean.getRg_8() > 0) 				a_bean.setPp_st		("2");//������+������
				
		a_bean.setFee_s_amt(0);
		a_bean.setFee_v_amt(0);
				
		if(ej_bean.getJg_2().equals("1")){//[jg_2=�Ϲݽ¿�LPG����]LPG������ ���������϶��� ������.
			if(a_bean.getA_a().equals("12")||a_bean.getA_a().equals("11")){//����
				a_bean.setFee_s_amt(-1);
				a_bean.setFee_v_amt(-1);
				if(ej_bean.getJg_a().equals("501") || ej_bean.getJg_a().equals("502")){//RV����
					a_bean.setFee_s_amt(0);
					a_bean.setFee_v_amt(0);
				}
			}
		}
		
		if(ej_bean.getJg_b().equals("2")){//[jg_b=�������� 2-LPG]LPG������ ���������϶��� ������.
			if(a_bean.getA_a().equals("12")||a_bean.getA_a().equals("11")){//����
				a_bean.setFee_s_amt(-1);
				a_bean.setFee_v_amt(-1);
				if(ej_bean.getJg_a().equals("501") || ej_bean.getJg_a().equals("502")){//RV����
					a_bean.setFee_s_amt(0);
					a_bean.setFee_v_amt(0);
				}
			}
		}
		
		//�ֿ����� �Ϲݽ� �����
		if(a_bean.getCar_comp_id().equals("0005")){
			if(a_bean.getA_a().equals("21")||a_bean.getA_a().equals("11")){//�Ϲݽ�
				a_bean.setFee_s_amt(-1);
				a_bean.setFee_v_amt(-1);
			}
		}
		
		int agree_dist = 0;
	
		a_bean.setAgree_dist(45000);
	
		//20140603 ��������Ÿ� 45000
		if(AddUtil.parseInt(a_bean.getRent_dt()) > 20140602 && AddUtil.parseInt(a_bean.getRent_dt()) < 20140725){
		
			//�Ϲݽ� +5000
			if(a_bean.getA_a().equals("11") || a_bean.getA_a().equals("21")){
				a_bean.setAgree_dist(a_bean.getAgree_dist()+5000);
			}
			//���� ���ָ� -5000
			if(ej_bean.getJg_b().equals("0")){
				a_bean.setAgree_dist(a_bean.getAgree_dist()-5000);
			}
			//���� ���� -5000
			if(ej_bean.getJg_w().equals("1") && ej_bean.getJg_b().equals("1")){
				a_bean.setAgree_dist(a_bean.getAgree_dist()-5000);
			}
		}
		
		//20140725 ��������Ÿ� 40000
		if(AddUtil.parseInt(a_bean.getRent_dt()) > 20140724){
		
			a_bean.setAgree_dist(40000);

			//���� ���� +5000
			if(!ej_bean.getJg_w().equals("1") && ej_bean.getJg_b().equals("1")){
				a_bean.setAgree_dist(a_bean.getAgree_dist()+5000);
			}
		
			//LPG +5000
			if(ej_bean.getJg_b().equals("2")){
				a_bean.setAgree_dist(a_bean.getAgree_dist()+5000);
			}
		
			//20141223 �⺻�İ� �Ϲݽ� ����
			if(AddUtil.parseInt(a_bean.getRent_dt()) < 20141223){
		
				//�Ϲݽ� +5000
				if(a_bean.getA_a().equals("11") || a_bean.getA_a().equals("21")){
					a_bean.setAgree_dist(a_bean.getAgree_dist()+5000);
				}
			}
			
			a_bean.setB_agree_dist(a_bean.getAgree_dist());
			
			//�������� -10000
			if(AddUtil.parseInt(a_bean.getRent_dt()) >= 20141223){
				if(ej_bean.getJg_w().equals("1")){
					a_bean.setAgree_dist(a_bean.getAgree_dist()-10000);
				}				
			}
			
		}		
		
		//20151211 ��������Ÿ� 30000
		if(AddUtil.parseInt(a_bean.getRent_dt()) >= 20151211){
		
			a_bean.setB_agree_dist(30000);

			//���� +5000
			if(ej_bean.getJg_b().equals("1")){
				a_bean.setB_agree_dist(a_bean.getB_agree_dist()+5000);
			}
		
			//LPG +10000 -> 20190418 +5000
			if(ej_bean.getJg_b().equals("2")){
				a_bean.setB_agree_dist(a_bean.getB_agree_dist()+5000);
			}
		
			
			a_bean.setAgree_dist(a_bean.getB_agree_dist());
			
			//20151223 �⺻ ��������Ÿ� 20,000				
			a_bean.setAgree_dist(20000);
			
		}
		
		//20220415 ��������Ÿ� 23000
		if(AddUtil.parseInt(a_bean.getRent_dt()) >= 20220415){
				
			a_bean.setB_agree_dist(23000);

			//���� +5000
			if(ej_bean.getJg_b().equals("1")){
				a_bean.setB_agree_dist(a_bean.getB_agree_dist()+5000);
			}
				
			//LPG +10000 -> 20190418 +5000
			if(ej_bean.getJg_b().equals("2")){
				a_bean.setB_agree_dist(a_bean.getB_agree_dist()+5000);
			}
				
					
			a_bean.setAgree_dist(a_bean.getB_agree_dist());
					
			//20151223 �⺻ ��������Ÿ� 20,000				
			a_bean.setAgree_dist(20000);
			
			//20220415 �ֿ����� ȯ�޴뿩�� ����
			a_bean.setRtn_run_amt_yn("0");
					
		}
		
		out.println("est_nm="+a_bean.getEst_nm());
		out.println("a_a="+a_bean.getA_a());
		out.println("fee_s_amt="+a_bean.getFee_v_amt());
		
		est_nm[i] 	= a_bean.getEst_nm();
		a_a[i] 		= a_bean.getA_a();
		
		est_id[i]   = Long.toString(System.currentTimeMillis())+String.valueOf(i);
		a_bean.setEst_type		("J");
		a_bean.setEst_id		(est_id[i]);
		
		//������ �ֿ������� �ݳ��� ��������
		if (ej_bean.getJg_g_7().equals("3")) {//20190701 ��������			
			a_bean.setReturn_select	(""); //20191218 ������ �μ��ݳ�������/�ݳ��� ������ ������� ������ ���� ��
			a_bean.setPrint_type	("1"); //20191218 ������ �μ��ݳ�������/�ݳ��� ������ ������� ������ ���� 6 > 1�� ����
			if (a_bean.getEcar_loc_st().equals("")) {//������
				a_bean.setEcar_loc_st("0");
			}
		}
		if (a_bean.getHcar_loc_st().equals("") && ej_bean.getJg_g_7().equals("4")) {//������
			a_bean.setHcar_loc_st("0");
		}
		
		// 20210318 ����/ȭ��, ����, ����, �Ϻ� ������(������, ����Ÿ, ȥ��, �ֻ��ڵ���, ���Ǵ�Ƽ)�� ������ȣ�� ��û x.
		if( Integer.parseInt(cm_bean.getJg_code())>8000000 || ej_bean.getJg_b().equals("5") || ej_bean.getJg_b().equals("6")
			|| a_bean.getCar_comp_id().equals("0044") || a_bean.getCar_comp_id().equals("0007") || a_bean.getCar_comp_id().equals("0025") || a_bean.getCar_comp_id().equals("0033") || a_bean.getCar_comp_id().equals("0048") ){
			a_bean.setNew_license_plate("0");
		} else {
			a_bean.setNew_license_plate("1");
		}
		
		count = e_db.insertEstimateHp(a_bean);
		
		//���� ����
		Hashtable sh_comp = new Hashtable();
		sh_comp.put("EST_ID", a_bean.getEst_id());
		count = shDb.insertShCompareHpSimple(sh_comp);
				
		out.println("<br><br>");
	}	
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
<form action="" name="form1" method="POST">
  <input type="hidden" name="auth_rw" value="<%=auth_rw%>">
  <input type="hidden" name="br_id" value="<%=br_id%>">  
  <input type="hidden" name="user_id" value="<%=user_id%>">
  <input type="hidden" name="gubun1" value="<%=gubun1%>">
  <input type="hidden" name="gubun2" value="<%=gubun2%>">
  <input type="hidden" name="gubun3" value="<%=gubun3%>">
  <input type="hidden" name="s_dt" value="<%=s_dt%>">
  <input type="hidden" name="e_dt" value="<%=e_dt%>">
  <input type="hidden" name="s_kd" value="<%=s_kd%>">          
  <input type="hidden" name="t_wd" value="<%=t_wd%>">  
  <input type="hidden" name="base_dt" value="<%=base_dt%>">
  <input type="hidden" name="car_comp_id" value="<%=car_comp_id%>">  
  <input type="hidden" name="reg_dt" value="<%=reg_dt%>">
  <input type="hidden" name="action_st" value="<%=action_st%>">	
  <input type="hidden" name="reg_code" value="<%=reg_code%>">  
  <%for (int i = 0; i < est_size; i++) {%>   
  <input type="hidden" name="est_id" value="<%=est_id[i]%>">          
  <%}%>  
  <input type="hidden" name="cmd" value="u">
  <input type="hidden" name="est_size" value="<%=est_size%>">
  <input type="hidden" name="e_page" value="i">  
  <input type="hidden" name="from_page" value="main_car">
</form>
<script>
	function replaceFloatRound2(per){
		return Math.round(per*10)/10;	
	}

<%if (count==1) {%>
		
	document.form1.action = "/acar/estimate_mng/esti_mng_i_a_2_proc_20090901.jsp";						
	document.form1.submit();		
				
<%} else {%>

	alert("�����߻�!");
	
<%}%>
</script>
</body>
</html>

