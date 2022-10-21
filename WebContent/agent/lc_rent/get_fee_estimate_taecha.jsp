<%@ page language="java" contentType="text/html; charset=euc-kr" %>
<%@ page import="java.util.*, java.io.*, acar.util.*, acar.estimate_mng.*" %>
<%@ page import="acar.car_mst.*, acar.con_ins.*, acar.cont.*, acar.client.*, acar.car_register.*" %>
<jsp:useBean id="em_bean" class="acar.estimate_mng.EstiCommVarBean" scope="page"/>
<jsp:useBean id="ej_bean" class="acar.estimate_mng.EstiJgVarBean" scope="page"/>
<jsp:useBean id="cm_bean" scope="page" class="acar.car_mst.CarMstBean"/>
<jsp:useBean id="a_db" scope="page" class="acar.cont.AddContDatabase"/>
<jsp:useBean id="ai_db" scope="page" class="acar.con_ins.AddInsurDatabase"/>
<jsp:useBean id="al_db" scope="page" class="acar.client.AddClientDatabase"/>
<jsp:useBean id="af_db" scope="page" class="acar.fee.AddFeeDatabase"/>
<jsp:useBean id="shDb" scope="page" class="acar.secondhand.SecondhandDatabase"/>
<jsp:useBean id="cr_bean"   class="acar.car_register.CarRegBean"       scope="page"/>
<jsp:useBean id="ins"       class="acar.con_ins.InsurBean" 		scope="page"/>
<%@ include file="/agent/cookies.jsp" %>

<%
	int o_1 		= request.getParameter("o_1")			==null?0:AddUtil.parseDigit(request.getParameter("o_1"));
	int grt_amt 		= request.getParameter("grt_s_amt")		==null?0:AddUtil.parseDigit(request.getParameter("grt_s_amt"));
	int pp_amt 		= request.getParameter("pp_amt")		==null?0:AddUtil.parseDigit(request.getParameter("pp_amt"));
	int t_ifee_s_amt 	= request.getParameter("ifee_s_amt")		==null?0:AddUtil.parseDigit(request.getParameter("ifee_s_amt"));
	int ifee_amt 		= request.getParameter("ifee_amt")		==null?0:AddUtil.parseDigit(request.getParameter("ifee_amt"));	
	int t_fee_s_amt 	= request.getParameter("fee_s_amt")		==null?0:AddUtil.parseDigit(request.getParameter("fee_s_amt"));
	int add_opt_amt		= request.getParameter("add_opt_amt")		==null?0:AddUtil.parseDigit(request.getParameter("add_opt_amt"));
	int agree_dist		= request.getParameter("agree_dist")		==null?0:AddUtil.parseDigit(request.getParameter("agree_dist"));
	int cls_n_mon		= request.getParameter("cls_n_mon")		==null?0:AddUtil.parseDigit(request.getParameter("cls_n_mon"));
	int max_agree_dist	= request.getParameter("max_agree_dist")	==null?0:AddUtil.parseDigit(request.getParameter("max_agree_dist"));
	int r_max_agree_dist	= request.getParameter("r_max_agree_dist")	==null?0:AddUtil.parseDigit(request.getParameter("r_max_agree_dist"));
	int sh_km		= request.getParameter("sh_km")			==null?0:AddUtil.parseDigit(request.getParameter("sh_km"));
	
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
	String rent_st 		= "1";
	String fee_rent_st	= "1";
	
	String tae_car_mng_id	= request.getParameter("tae_car_mng_id")	==null?"":request.getParameter("tae_car_mng_id");
	String tae_car_id 	= request.getParameter("tae_car_id")		==null?"":request.getParameter("tae_car_id");
	String tae_car_seq 	= request.getParameter("tae_car_seq")		==null?"":request.getParameter("tae_car_seq");
	String tae_car_rent_st	= request.getParameter("tae_car_rent_st")	==null?"":AddUtil.replace(request.getParameter("tae_car_rent_st"),"-","");
	String tae_car_rent_et	= request.getParameter("tae_car_rent_et")	==null?"":AddUtil.replace(request.getParameter("tae_car_rent_et"),"-","");
	
	
	int count = 0;
	boolean flag3 = true;
	boolean flag4 = true;
	
	//����ݸ��� ����
	cls_n_mon = 0;
	
	
	EstiDatabase 		e_db 	= EstiDatabase.getInstance();
	AddCarMstDatabase 	a_cmb 	= AddCarMstDatabase.getInstance();
	CarRegDatabase crd 	= CarRegDatabase.getInstance();
	
	
	//��������
	String ins_st = ai_db.getInsSt(tae_car_mng_id);
	ins = ai_db.getIns(tae_car_mng_id, ins_st);
	
	cr_bean = crd.getCarRegBean(tae_car_mng_id);
	
	//���⺻����
	ContBaseBean base = a_db.getCont(rent_mng_id, rent_l_cd);
	
	if(rent_dt.equals("")) rent_dt = base.getRent_dt();
	
	if(AddUtil.parseInt(base.getReg_dt()) >= 20220622){
		rent_dt = base.getReg_dt();
	}
	
	//����Ÿ����
	ContEtcBean cont_etc = a_db.getContEtc(rent_mng_id, rent_l_cd);
	
	//������
	ClientBean client = al_db.getNewClient(base.getClient_id());
	
	//�����⺻����
	ContCarBean car = a_db.getContCarMaxNew(tae_car_mng_id);

	//����Ÿ����
	ContEtcBean ext_cont_etc = a_db.getContEtc(car.getRent_mng_id(), car.getRent_l_cd());
	
	//CAR_NM : ��������
	cm_bean = a_cmb.getCarNmCase(tae_car_id, tae_car_seq);
	
	//�ܰ�����NEW
	ej_bean = e_db.getEstiJgVarCase(cm_bean.getJg_code(), "");
	
	//���뺯��
	em_bean = e_db.getEstiCommVarCase("1", "");
	
	//ù��°�뿩����
	ContFeeBean fee = a_db.getContFeeNew(rent_mng_id, rent_l_cd, "1");
	
	t_ifee_s_amt 	= fee.getIfee_s_amt();
	pp_amt 				= fee.getPp_s_amt()+fee.getPp_v_amt();
	grt_amt 			= fee.getGrt_amt_s();
	
	//�뿩�᰹����ȸ(���忩��)
	int fee_size 	= af_db.getMaxRentSt(rent_mng_id, rent_l_cd);
	
	//�ش�뿩����
	ContFeeBean fees = a_db.getContFeeNew(rent_mng_id, rent_l_cd, Integer.toString(fee_size));
	
	//�����⺻����
	ContCarBean f_fee_etc = a_db.getContFeeEtc(rent_mng_id, rent_l_cd, "1");
	
	//�������
	ContPurBean pur = a_db.getContPur(rent_mng_id, rent_l_cd);
	
	//�߰�����뿩����
	Hashtable fee_add = a_db.getContFeeAdd(rent_mng_id, rent_l_cd, "t");
	
	if(String.valueOf(fee_add.get("RENT_L_CD")).equals("null")){
		//�߰�����뿩���� ����ġ
		Hashtable fee_add2 = a_db.getContBcTaeCase(rent_mng_id, rent_l_cd);
		
		fee_add.put("RENT_MNG_ID", 		rent_mng_id);
		fee_add.put("RENT_L_CD",   		rent_l_cd);
		fee_add.put("RENT_ST",     		"t");
		fee_add.put("RENT_DT",  		String.valueOf(fee_add2.get("RENT_DT")));
		fee_add.put("RENT_START_DT",  		String.valueOf(fee_add2.get("RENT_START_DT"))==null?"":String.valueOf(fee_add2.get("RENT_START_DT")));
		fee_add.put("RENT_END_DT",  		String.valueOf(fee_add2.get("RENT_END_DT"))==null?"":String.valueOf(fee_add2.get("RENT_END_DT")));
		fee_add.put("CON_MON",		  	"1");
		fee_add.put("PP_S_AMT",		  	String.valueOf(fee_add2.get("PP_S_AMT")));
		fee_add.put("PP_V_AMT",		  	String.valueOf(fee_add2.get("PP_V_AMT")));
		fee_add.put("FEE_S_AMT",		String.valueOf(fee_add2.get("RENT_S_FEE")));
		fee_add.put("FEE_V_AMT",		String.valueOf(fee_add2.get("RENT_V_FEE")));
		
		boolean flag33 = a_db.insertFeeAdd(fee_add);
		
		ContFeeBean fee2 = a_db.getContFeeNew(rent_mng_id, rent_l_cd, "1");
		fee2.setCar_st			("1");
		fee2.setRent_st			("t");
		fee2.setCon_mon			("1");
		fee2.setRent_dt			(String.valueOf(fee_add2.get("RENT_DT")));
		fee2.setRent_start_dt	(String.valueOf(fee_add2.get("RENT_START_DT"))==null?"":String.valueOf(fee_add2.get("RENT_START_DT")));
		fee2.setRent_end_dt		(String.valueOf(fee_add2.get("RENT_END_DT"))==null?"":String.valueOf(fee_add2.get("RENT_END_DT")));
		flag33 = a_db.updateContFeeAdd(fee2);
		
		//�����⺻����
		ContCarBean fee_etc2 = a_db.getContFeeEtc(rent_mng_id, rent_l_cd, rent_st);
		fee_etc2.setRent_st		("t");
		flag33 = a_db.updateFeeEtcAdd(fee_etc2);
		
		fee_add = a_db.getContFeeAdd(rent_mng_id, rent_l_cd, "t");
	}else{
		//�߰�����뿩���� ����ġ
		Hashtable fee_add2 = a_db.getContBcTaeCase(rent_mng_id, rent_l_cd);
		
		ContFeeBean fee_add_b = a_db.getContFeeNewAdd(rent_mng_id, rent_l_cd, "t");
		
		int add_up_cnt = 0;
		if(!tae_car_rent_st.equals("") && !tae_car_rent_st.equals(fee_add_b.getRent_start_dt())){
			fee_add_b.setRent_start_dt(tae_car_rent_st);
			add_up_cnt++;
		}
		if((!tae_car_rent_et.equals("")||fee_add_b.getRent_end_dt().equals("null")) && !tae_car_rent_et.equals(fee_add_b.getRent_end_dt())){
			fee_add_b.setRent_end_dt(tae_car_rent_et);
			add_up_cnt++;
		}
		if(AddUtil.parseInt(String.valueOf(fee_add2.get("CON_MON"))) >1 && !String.valueOf(fee_add2.get("CON_MON")).equals(fee_add_b.getCon_mon())){
			fee_add_b.setCon_mon(String.valueOf(fee_add2.get("CON_MON")));
			add_up_cnt++;
		}
		if(add_up_cnt>0){
			boolean flag33 = a_db.updateContFeeAdd(fee_add_b);
		}
	}
	
	car_gu = "0";
	
	
	EstimateBean bean = new EstimateBean();
	
	
	bean.setEst_nm		(client.getFirm_nm());
	bean.setEst_ssn		(client.getEnp_no1()+""+client.getEnp_no1()+""+client.getEnp_no1());
	bean.setEst_tel		(client.getO_tel());
	bean.setEst_fax		(client.getFax());
	
	/*��������*/
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
	
	bean.setLkas_yn		(ext_cont_etc.getLkas_yn());	// ������Ż ������
	bean.setLdws_yn		(ext_cont_etc.getLdws_yn());	// ������Ż �����
	bean.setAeb_yn		(ext_cont_etc.getAeb_yn());		// ������� ������
	bean.setFcw_yn		(ext_cont_etc.getFcw_yn());		// ������� �����
	bean.setHook_yn		(ext_cont_etc.getHook_yn());	// ���ΰ�
	bean.setLegal_yn	(ext_cont_etc.getLegal_yn());	// �������������(�����)
	bean.setTop_cng_yn	(ext_cont_etc.getTop_cng_yn());		// ž��(��������)
	
	bean.setRtn_run_amt_yn(request.getParameter("rtn_run_amt_yn")==null?"":request.getParameter("rtn_run_amt_yn"));
	
	//�뿩��ǰ
	String a_a = base.getCar_st();
	if(a_a.equals("3"))						a_a = "1";
	else if(a_a.equals("1"))			a_a = "2";
		
	//���������� �뵵�� ó���Ѵ�.
	if(cr_bean.getCar_use().equals("1"))				a_a = "2";
	else if(cr_bean.getCar_use().equals("2"))		a_a = "1";
		
	String rent_way = fee.getRent_way();
	if(rent_way.equals("3"))			rent_way = "2";
	rent_way = "2"; //������� �Ϲݽ��̶� �⺻�� ���� ����
	if(AddUtil.parseInt(tae_car_rent_st) >= 20171221){
		rent_way = "1"; //������ ������� �Ϲݽ� ���� ���� 20171221����
	}
	bean.setA_a		(a_a+""+rent_way);
	
	//�뿩�Ⱓ
	bean.setA_b		("1");
	
	
	//�������
	String a_h = car.getCar_ext();
	bean.setA_h		(a_h);
	
	//�ʱⳳ�Ա���
	String pp_st = "";
	if(t_ifee_s_amt > 0) 			pp_st = "1";
	if(pp_amt+grt_amt > 0) 		pp_st = "2";
	if(pp_st.equals(""))			pp_st = "0";
	bean.setPp_st		(pp_st);
	//���뼱���ݾ�
	bean.setPp_amt		(pp_amt);
	//���뺸���ݾ�
	bean.setRg_8_amt	(grt_amt);
	//���ô뿩�����밳����
	int g_10 = 0;
	if(t_ifee_s_amt>0 && t_fee_s_amt>0){
		g_10 = Math.round(t_ifee_s_amt/t_fee_s_amt);
		
		float g_10_f = Math.round(AddUtil.parseFloat(String.valueOf(t_ifee_s_amt))/AddUtil.parseFloat(String.valueOf(t_fee_s_amt)));
		g_10 = AddUtil.parseInt(String.valueOf(Math.round(g_10_f)));
	}
	bean.setG_10		(g_10);
	bean.setIfee_s_amt	(ifee_amt);
	
	if(ins.getCon_f_nm().indexOf("�Ƹ���ī") == -1){
	 	bean.setIns_per		("2");
	}else{
	 	bean.setIns_per		("1");
	} 
	if(ins.getConr_nm().indexOf("�Ƹ���ī") == -1){
	 	bean.setInsurant		("2");
	}else{
	 	bean.setInsurant		("1");
	} 	
	
	//�ִ�ī���谡�Կ���
	bean.setIns_good	("0");
	
	//��������ڿ���
	String driving_age = base.getDriving_age();
	int ins_age = 0;
	if(driving_age.equals(""))			ins_age = 1;//"":���þ���	->26�� 1
	if(driving_age.equals("0"))			ins_age = 1;//0 :26��		->26�� 1
	if(driving_age.equals("1"))			ins_age = 2;//1 :21��		->21�� 2
	if(driving_age.equals("2"))			ins_age = 2;//2 :��������	->21�� 2
	if(driving_age.equals("3"))			ins_age = 3;//3 :24��		->24�� 3
	if(driving_age.equals("5"))			ins_age = 5;//5 :30��		->30��
	if(driving_age.equals("6"))			ins_age = 6;//6 :35��		->35��
	if(driving_age.equals("7"))			ins_age = 7;//7 :43��		->43��
	if(driving_age.equals("8"))			ins_age = 8;//8 :48��		->48��
	if(driving_age.equals("9"))			ins_age = 9;//9 :22��		->22��
	if(driving_age.equals("10"))		ins_age = 10;//10 :28��		->28��
	if(driving_age.equals("11"))		ins_age = 11;//11 :35��~49��	->35��~49��
	bean.setIns_age		(Integer.toString(ins_age));
	//����빰�ڼհ��Աݾ�
	bean.setIns_dj(base.getGcp_kd());
	if(bean.getIns_dj().equals("")) bean.setIns_dj("1");
	
	//������å��
	bean.setCar_ja(base.getCar_ja());
	
	//LPG ��������
	String lpg_yn = "0";
	bean.setLpg_yn		(lpg_yn);
	bean.setLpg_kit		("");
	
	//�������谡�Կ���
	bean.setGi_yn		(gi_st);
	
	//���ſ뵵����
	bean.setSpr_yn(cont_etc.getDec_gr());
	
	bean.setReg_id		(ck_acar_id);	
	bean.setRent_dt		(tae_car_rent_st);
	rent_dt = tae_car_rent_st;
	
	bean.setEst_st		("1");
	bean.setEst_from	("tae_car");
	bean.setUdt_st		(pur.getUdt_st());
	
	String reg_code  = Long.toString(System.currentTimeMillis());
	
	bean.setReg_code	(reg_code);
	bean.setRent_mng_id	(rent_mng_id);
	bean.setRent_l_cd	(rent_l_cd);
	bean.setRent_st		("t");
	//bean.setIns_per		(cont_etc.getInsur_per());
	//bean.setInsurant	(cont_etc.getInsurant());
	bean.setMgr_ssn		("1");
	bean.setMgr_nm		(tae_car_mng_id);
	bean.setJob				("t");
	
	
	int esti_idx = 1;
	
	bean.setMgr_ssn		("0");
	//����ĿDC����.
	bean.setDc_amt		(0);
	
	Hashtable ht2 = shDb.getBase(tae_car_mng_id, rent_dt, "");
	
	
	bean.setToday_dist	(AddUtil.parseDigit(String.valueOf(ht2.get("TOT_DIST"))));
	bean.setTot_dt			(String.valueOf(ht2.get("SERV_DT")));
	
	if(AddUtil.parseInt(tae_car_rent_st) >= 20171221){
		bean.setAgree_dist(f_fee_etc.getAgree_dist());
		
		int b_agree_dist =30000;
		
		if(AddUtil.parseInt(tae_car_rent_st) >= 20220415){
			b_agree_dist =23000;
		}
		
		//���� +5000
		if(ej_bean.getJg_b().equals("1")){
			b_agree_dist = b_agree_dist+5000;
		}
		//LPG +10000 -> 20190418 +5000
		if(ej_bean.getJg_b().equals("2")){
			b_agree_dist = b_agree_dist+5000;
		}
		bean.setB_agree_dist(b_agree_dist);
	}
	
	
	String est_id[]	 		= new String[esti_idx];
	
	float cls_a_b = AddUtil.parseFloat(bean.getA_b())/36*em_bean.getAx_p();
	
	for(int i = 0 ; i < esti_idx ; i++){
		EstimateBean a_bean = new EstimateBean();
		
		a_bean = bean;
		
		
		out.println("#### a_b="+a_bean.getA_b()+"-------------------------------<br>");
		
		//����������ȣ ����
		est_id[i] = Long.toString(System.currentTimeMillis())+""+String.valueOf(i);
		
		//fms4���� ������.
		if(AddUtil.lengthb(est_id[i]) < 15)	est_id[i] = est_id[i]+""+"4";
		
		a_bean.setEst_type		("L");
		
		/*������*/
		a_bean.setEst_id		(est_id[i]);
		
		//�����
		a_bean.setTalk_tel		(ck_acar_id);
		
		
		//20150512 �縮��/���� ������ �������� �ݿ�		
		if(AddUtil.parseInt(a_bean.getRent_dt()) >= 20150512){
			//��������
			Vector vt = shDb.getAccidServAmts(tae_car_mng_id, a_bean.getRent_dt());
			int vt_size = vt.size();
			for(int j = 0 ; j < vt_size ; j++){
				Hashtable ht = (Hashtable)vt.elementAt(j);
				if(j==0) a_bean.setAccid_serv_amt1(String.valueOf(ht.get("TOT_AMT"))==null?0 :AddUtil.parseDigit(String.valueOf(ht.get("TOT_AMT"))));
				if(j==1) a_bean.setAccid_serv_amt2(String.valueOf(ht.get("TOT_AMT"))==null?0 :AddUtil.parseDigit(String.valueOf(ht.get("TOT_AMT"))));
			}						
		}			
		
		//20150701 �縮��/���� ������ �谳�Ǳ�ȯ �� ����Ÿ� �ݿ�		
		if(AddUtil.parseInt(a_bean.getRent_dt()) >= 20150701){			
			//��������				
			a_bean.setCha_st_dt	(String.valueOf(ht2.get("CHA_ST_DT"))==null?"":String.valueOf(ht2.get("CHA_ST_DT")));
			a_bean.setB_dist	(String.valueOf(ht2.get("B_DIST"))==null?0 :AddUtil.parseDigit(String.valueOf(ht2.get("B_DIST"))));
		}			
		
		count = e_db.insertEstimate(a_bean);
		
		
		//���� ����
		//Hashtable sh_comp = new Hashtable();
		//sh_comp.put("EST_ID", 	est_id[i]);
		//count = shDb.insertShCompareSimple(sh_comp);
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
  <input type="hidden" name="cmd" value="u">
  <input type="hidden" name="e_page" value="i">  
  <input type="hidden" name="rent_dt" value="<%=rent_dt%>">    
  <input type="hidden" name="esti_stat" value="<%=esti_stat%>">      
  <input type="hidden" name="l_cd" value="<%=rent_l_cd%>">      
  <input type="hidden" name="m_id" value="<%=rent_mng_id%>">      
  <input type="hidden" name="car_mng_id" value="<%=tae_car_mng_id%>">
  <input type="hidden" name="rent_st" value="">  
  <input type="hidden" name="fee_rent_st" value="<%=rent_st%>">    
  <input type="hidden" name="est_from" value="tae_car">  
  <input type="hidden" name="insur_per" value="<%=insur_per%>">  
  <input type="hidden" name="insurant" value="<%=insurant%>">  
  <input type="hidden" name="one_self" value="<%=one_self%>">   
  <input type="hidden" name="action_st" value="<%=action_st%>">	 
  <input type="hidden" name="esti_table" value="estimate">       
  <input type="hidden" name="reg_code" value="<%=reg_code%>">    
  <%for(int i = 0 ; i < esti_idx ; i++){%>   
  <input type="hidden" name="est_id" value="<%=est_id[i]%>">          
  <%}%>       
</form>
<script>

<%	if(count==1){%>

			//�縮�� �������α׷� �̵�
			document.form1.action = "/agent/secondhand/esti_mng_i_a_2_proc_20090901.jsp";			
							
			document.form1.submit();		
			
<%	}else{
		if(cm_bean.getJg_code().equals("")){%>
		alert("�ܰ��ڵ尡 �����ϴ�. ������������ �Է��Ͻʽÿ�.");
		<%}else{%>
		alert("�����߻�!");		
<%		}
	}%>

</script>
</body>
</html>

