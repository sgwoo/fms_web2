<%@ page language="java" contentType="text/html; charset=euc-kr" %>
<%@ page import="java.util.*, java.io.*, acar.util.*, acar.estimate_mng.*, acar.car_mst.*, acar.con_ins.*,acar.cont.*,acar.client.*" %>
<jsp:useBean id="em_bean" class="acar.estimate_mng.EstiCommVarBean" scope="page"/>
<jsp:useBean id="ej_bean" class="acar.estimate_mng.EstiJgVarBean" scope="page"/>
<jsp:useBean id="cm_bean" class="acar.car_mst.CarMstBean" scope="page"/>
<jsp:useBean id="a_db" scope="page" class="acar.cont.AddContDatabase"/>
<jsp:useBean id="ai_db" scope="page" class="acar.con_ins.AddInsurDatabase"/>
<jsp:useBean id="al_db" scope="page" class="acar.client.AddClientDatabase"/>
<jsp:useBean id="af_db" scope="page" class="acar.fee.AddFeeDatabase"/>
<jsp:useBean id="shDb" class="acar.secondhand.SecondhandDatabase" scope="page"/>
<%@ include file="/acar/cookies.jsp" %>

<%
	int o_1 		= request.getParameter("o_1")			==null?0:AddUtil.parseDigit(request.getParameter("o_1"));
	int grt_amt 		= request.getParameter("grt_s_amt")		==null?0:AddUtil.parseDigit(request.getParameter("grt_s_amt"));
	int pp_amt 		= request.getParameter("pp_amt")		==null?0:AddUtil.parseDigit(request.getParameter("pp_amt"));
	int t_ifee_s_amt 	= request.getParameter("ifee_s_amt")	==null?0:AddUtil.parseDigit(request.getParameter("ifee_s_amt"));
	int t_fee_s_amt 	= request.getParameter("fee_s_amt")		==null?0:AddUtil.parseDigit(request.getParameter("fee_s_amt"));
	int add_opt_amt		= request.getParameter("add_opt_amt")	==null?0:AddUtil.parseDigit(request.getParameter("add_opt_amt"));
	int agree_dist		= request.getParameter("agree_dist")	==null?0:AddUtil.parseDigit(request.getParameter("agree_dist"));
	int cls_n_mon		= request.getParameter("cls_n_mon")		==null?0:AddUtil.parseDigit(request.getParameter("cls_n_mon"));
	int max_agree_dist	= request.getParameter("max_agree_dist")==null?0:AddUtil.parseDigit(request.getParameter("max_agree_dist"));
	int r_max_agree_dist	= request.getParameter("r_max_agree_dist")==null?0:AddUtil.parseDigit(request.getParameter("r_max_agree_dist"));
	int sh_km		= request.getParameter("sh_km")==null?0:AddUtil.parseDigit(request.getParameter("sh_km"));
	int o_sh_km		= request.getParameter("o_sh_km")==null?0:AddUtil.parseDigit(request.getParameter("o_sh_km"));
	
	
	
	String agree_dist_yn	= request.getParameter("agree_dist_yn")	==null?"":request.getParameter("agree_dist_yn");
	String lpg_setter 	= request.getParameter("lpg_setter")	==null?"":request.getParameter("lpg_setter");
	String lpg_kit	 	= request.getParameter("lpg_kit")		==null?"":request.getParameter("lpg_kit");
	String gi_st 		= request.getParameter("gi_st")			==null?"":request.getParameter("gi_st");
	String s_st 		= request.getParameter("s_st")			==null?"":request.getParameter("s_st");
	String rent_dt 		= request.getParameter("rent_dt")		==null?"":AddUtil.replace(request.getParameter("rent_dt"),"-","");
	String fee_rent_dt 	= request.getParameter("fee_rent_dt")	==null?"":AddUtil.replace(request.getParameter("fee_rent_dt"),"-","");
	String rent_start_dt	= request.getParameter("rent_start_dt")	==null?"":AddUtil.replace(request.getParameter("rent_start_dt"),"-","");
	String rent_end_dt	= request.getParameter("rent_end_dt")	==null?"":AddUtil.replace(request.getParameter("rent_end_dt"),"-","");
	String ext_rent_dt	= request.getParameter("ext_rent_dt")	==null?"":AddUtil.replace(request.getParameter("ext_rent_dt"),"-","");
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
	
	String rent_mng_id	= request.getParameter("rent_mng_id")	==null?"":request.getParameter("rent_mng_id");
	String rent_l_cd	= request.getParameter("rent_l_cd")		==null?"":request.getParameter("rent_l_cd");
	String car_mng_id 	= request.getParameter("car_mng_id")	==null?"":request.getParameter("car_mng_id");
	String rent_st 		= request.getParameter("fee_rent_st")	==null?"1":request.getParameter("fee_rent_st");
	String fee_rent_st	= request.getParameter("fee_rent_st")	==null?"1":request.getParameter("fee_rent_st");
	String opt_chk		= request.getParameter("opt_chk")		==null?"0":request.getParameter("opt_chk");
	String fee_opt_amt	= request.getParameter("fee_opt_amt")	==null?"0":request.getParameter("fee_opt_amt");
	String fee_type		= request.getParameter("fee_type")	==null?"":request.getParameter("fee_type");
	String damdang_id 	= request.getParameter("damdang_id")==null?"":request.getParameter("damdang_id");
	
	//20190801 매입옵션이 없는 건이고 중고차가 계산 주행거리와 실 반영주행거리가 다른면 중고차가 다시 계산한다.
	if(fee_opt_amt.equals("0") && (sh_km>o_sh_km || sh_km<o_sh_km)){
		o_1 		= 0;
	}
	
	
	
	int count = 0;
	boolean flag3 = true;
	boolean flag4 = true;
	
	//위약금면제 무시
	cls_n_mon = 0;
	
	
	EstiDatabase 		e_db 	= EstiDatabase.getInstance();
	AddCarMstDatabase 	a_cmb 	= AddCarMstDatabase.getInstance();
	
	
	//보험정보
	String ins_st = ai_db.getInsSt(car_mng_id);
	InsurBean ins = ai_db.getIns(car_mng_id, ins_st);
	
	//계약기본정보
	ContBaseBean base = a_db.getCont(rent_mng_id, rent_l_cd);
	
	if(rent_dt.equals("")) rent_dt = base.getRent_dt();
	
	//계약기타정보
	ContEtcBean cont_etc = a_db.getContEtc(rent_mng_id, rent_l_cd);
	
	//고객정보
	ClientBean client = al_db.getNewClient(base.getClient_id());
	
	//차량기본정보
	ContCarBean car 	= a_db.getContCarNew(rent_mng_id, rent_l_cd);
	
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
	
	//차량기본정보
	ContCarBean fee_etc = a_db.getContFeeEtc(rent_mng_id, rent_l_cd, "1");
	
	
	
	if(fee_rent_st.equals("")){
		rent_st = Integer.toString(fee_size);
	}
	
	if(!fee_rent_st.equals("1") && car_gu.equals("1")){
		car_gu = "0";
	}
	
	if(!fee_rent_dt.equals("")){
		rent_dt = fee_rent_dt;
	}
	
	if(!fee_rent_st.equals("1") && !ext_rent_dt.equals("")){
	 	rent_dt = ext_rent_dt;
	}
	
	
	EstimateBean bean = new EstimateBean();
	
	
	bean.setEst_nm		(client.getFirm_nm());
	bean.setEst_ssn		(client.getEnp_no1()+""+client.getEnp_no1()+""+client.getEnp_no1());
	bean.setEst_tel		(damdang_id); //연장견적일때는 담당자아이디를 여기서 참조
	bean.setEst_fax		(client.getFax());
	
	/*차량정보*/
	bean.setCar_comp_id	(cm_bean.getCar_comp_id());
	bean.setCar_cd		(cm_bean.getCode());
	bean.setCar_id		(cm_bean.getCar_id());
	bean.setCar_seq		(cm_bean.getCar_seq());
	bean.setJg_opt_st	(car.getJg_opt_st());
	bean.setJg_col_st	(car.getJg_col_st());
	bean.setJg_tuix_st	(car.getJg_tuix_st());
	bean.setJg_tuix_opt_st	(car.getJg_tuix_opt_st());	
	bean.setCar_amt		(request.getParameter("car_c_amt")	==null?0:AddUtil.parseDigit(request.getParameter("car_c_amt")));
	bean.setOpt				(request.getParameter("opt")		==null?"":request.getParameter("opt"));
	bean.setOpt_seq		(request.getParameter("opt_code")	==null?"":request.getParameter("opt_code"));
	bean.setOpt_amt		(request.getParameter("opt_c_amt")	==null?0:AddUtil.parseDigit(request.getParameter("opt_c_amt"))+add_opt_amt);
	bean.setCol				(request.getParameter("color")		==null?"":request.getParameter("color"));
	bean.setCol_amt		(request.getParameter("col_c_amt")	==null?0:AddUtil.parseDigit(request.getParameter("col_c_amt")));
	bean.setDc_amt		(request.getParameter("t_dc_amt")	==null?0:AddUtil.parseDigit(request.getParameter("t_dc_amt")));
	bean.setTax_dc_amt		(request.getParameter("tax_dc_amt")	==null?0:AddUtil.parseDigit(request.getParameter("tax_dc_amt")));
	bean.setO_1				(o_1);
	bean.setDriver_add_amt(request.getParameter("driver_add_amt")	==null? 0:AddUtil.parseDigit(request.getParameter("driver_add_amt")));
	
	//대여상품
/*	String a_a = request.getParameter("car_st")==null?"":request.getParameter("car_st");
	if(a_a.equals(""))				a_a = base.getCar_st();
	if(a_a.equals("3"))				a_a = "1";
	else if(a_a.equals("1"))		a_a = "2";
	String rent_way = request.getParameter("rent_way")==null?"":request.getParameter("rent_way");
	if(rent_way.equals(""))			rent_way = fees.getRent_way();
	if(rent_way.equals("3"))		rent_way = "2";
	bean.setA_a			(a_a+""+rent_way);
*/
	bean.setA_a			(request.getParameter("a_a")==null?"":request.getParameter("a_a"));
	
	//대여기간
	bean.setA_b			(request.getParameter("con_mon")==null?"":request.getParameter("con_mon"));
	
	//등록지역
	String t_car_ext = request.getParameter("car_ext")==null?"":request.getParameter("car_ext");
	String a_h = t_car_ext;
	if(a_h.equals("")) a_h = car.getCar_ext();
	bean.setA_h			(a_h);
	
	//초기납입구분
	String pp_st = "";
	int g_10 = request.getParameter("pere_r_mth")==null?0:AddUtil.parseDigit(request.getParameter("pere_r_mth"));
	
	if(g_10 > 0) 					pp_st = "1";
	if(pp_amt+grt_amt > 0) 			pp_st = "2";
	if(pp_st.equals(""))			pp_st = "0";
	bean.setPp_st		(pp_st);
	//적용선납율
	bean.setPp_per		(request.getParameter("pere_r_per")==null?0:AddUtil.parseFloat(request.getParameter("pere_r_per")));
	//적용선납금액
	bean.setPp_amt		(pp_amt);
	//적용보증금율
	bean.setRg_8		(request.getParameter("gur_p_per")==null?0:AddUtil.parseFloat(request.getParameter("gur_p_per")));
	//개시대여료적용개월수
	bean.setG_10		(g_10);
	
	//잔존가치율
	String ro_13 = request.getParameter("ro_13")==null?"0":request.getParameter("ro_13");
	bean.setRo_13		(AddUtil.parseFloat(ro_13));
	bean.setO_13		(AddUtil.parseFloat(request.getParameter("o_13")==null?"0":request.getParameter("o_13")));
	
	//적용잔가금액
	int opt_amt = request.getParameter("o_13_amt")==null?0:AddUtil.parseDigit(request.getParameter("o_13_amt"));
	bean.setRo_13_amt	(opt_amt);
	//적용보증금액
	bean.setRg_8_amt	(grt_amt);
	//대여료DC율
	bean.setFee_dc_per	(request.getParameter("fee_dc_per")==null?0:AddUtil.parseFloat(request.getParameter("fee_dc_per")));
	
	
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
	if(driving_age.equals(""))			ins_age = 1;//"":선택없슴	->26세 1
	if(driving_age.equals("0"))			ins_age = 1;//0 :26세		->26세 1
	if(driving_age.equals("1"))			ins_age = 2;//1 :21세		->21세 2
	if(driving_age.equals("2"))			ins_age = 2;//2 :모든운전자	->21세 2
	if(driving_age.equals("3"))			ins_age = 3;//3 :24세		->24세 3
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
	bean.setGi_yn		(gi_st);
	
	//고객신용도구분
	bean.setSpr_yn		(request.getParameter("spr_yn")==null?"":request.getParameter("spr_yn"));
	
	//등록자-장기계약번호
	bean.setReg_id		(ck_acar_id);
	//bean.setReg_dt		(request.getParameter("reg_dt")==null?"":request.getParameter("reg_dt")+"0000");
	//if(bean.getReg_dt().equals(""))	bean.setReg_dt(base.getReg_dt()+"0000");
	//bean.setReg_dt		(AddUtil.replace(AddUtil.getDate(),"-","")+"0000");
	bean.setRent_dt		(rent_start_dt);
	rent_dt = rent_start_dt;
	
	bean.setMgr_nm		(car_mng_id);
	bean.setMgr_ssn		("연장견적");
	bean.setEst_st		("2");//연장견적
	
	bean.setEst_from	(est_from);
	bean.setUdt_st		(udt_st);
	bean.setAgree_dist	(agree_dist);
	bean.setOne_self	(one_self);
	
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
	
	//20141114 원계약따라간다 20140725 결정
	bean.setAgree_dist		(fee_etc.getAgree_dist());
	bean.setOver_run_amt	(fee_etc.getOver_run_amt());
	bean.setRtn_run_amt		(fee_etc.getRtn_run_amt());
	bean.setRtn_run_amt_yn	(fee_etc.getRtn_run_amt_yn());
	
	String reg_code  = Long.toString(System.currentTimeMillis());
	
	bean.setReg_code	(reg_code);
	bean.setRent_mng_id	(rent_mng_id);
	bean.setRent_l_cd	(rent_l_cd);
	bean.setRent_st		(fee_rent_st);
	bean.setIns_per		(insur_per);
	bean.setInsurant	(insurant);
	bean.setOpt_chk		(opt_chk);
	bean.setFee_opt_amt	(AddUtil.parseDigit(fee_opt_amt));
	
	
	int esti_idx = 1;
	
	
	//메이커DC없다.
	bean.setDc_amt		(0);
	bean.setToday_dist	(sh_km);
	
	bean.setCom_emp_yn		(request.getParameter("com_emp_yn")==null?"":request.getParameter("com_emp_yn"));
	
	bean.setLkas_yn		(cont_etc.getLkas_yn());		// 차선이탈 제어형
	bean.setLdws_yn		(cont_etc.getLdws_yn());		// 차선이탈 경고형
	bean.setAeb_yn		(cont_etc.getAeb_yn());		// 긴급제동 제어형
	bean.setFcw_yn		(cont_etc.getFcw_yn());		// 긴급제동 경고형
	bean.setHook_yn		(cont_etc.getHook_yn());		// 견인고리
	bean.setLegal_yn	(cont_etc.getLegal_yn());		// 법률비용지원금(고급형)
	bean.setTop_cng_yn	(cont_etc.getTop_cng_yn());		// 탑차(구조변경)
	
	
	String est_id[]	 		= new String[esti_idx];
	
	float cls_a_b = AddUtil.parseFloat(bean.getA_b())/36*em_bean.getAx_p();
	
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
		//est_id[i] = e_db.getNextEst_id("L");
		est_id[i] = Long.toString(System.currentTimeMillis());
		
		//fms2에서 견적함.
		if(AddUtil.lengthb(est_id[i]) < 15)	est_id[i] = est_id[i]+""+"2";
		
		
		a_bean.setEst_type		("L");
		
		/*고객정보*/
		a_bean.setEst_id		(est_id[i]);
		
		//등록자
		a_bean.setTalk_tel		(damdang_id);
		a_bean.setUpdate_id		(ck_acar_id);
		
		//연장구분
		a_bean.setDoc_type		(fee_type);
		
		//20150512 재리스/연장 견적은 사고수리비 반영		
		if(AddUtil.parseInt(a_bean.getRent_dt()) >= 20150512){
			//차량정보
			Vector vt = shDb.getAccidServAmts(base.getCar_mng_id(), a_bean.getRent_dt());
			int vt_size = vt.size();
			for(int j = 0 ; j < vt_size ; j++){
				Hashtable ht = (Hashtable)vt.elementAt(j);
				if(j==0) a_bean.setAccid_serv_amt1(String.valueOf(ht.get("TOT_AMT"))==null?0 :AddUtil.parseDigit(String.valueOf(ht.get("TOT_AMT"))));
				if(j==1) a_bean.setAccid_serv_amt2(String.valueOf(ht.get("TOT_AMT"))==null?0 :AddUtil.parseDigit(String.valueOf(ht.get("TOT_AMT"))));
			}							
		}	
		
				
		
		count = e_db.insertEstimate(a_bean);
		
		
		//비용비교 변수
		//Hashtable sh_comp = new Hashtable();
		//sh_comp.put("EST_ID", 	est_id[i]);
		//count = shDb.insertShCompareSimple(sh_comp);
		
		//System.out.println("[선납방식]"+pp_st);
		//System.out.println("[선납개월수]"+g_10);
	}
	
	//System.out.println("[연장견적]"+rent_l_cd+", "+ck_acar_id);
	
	
	//견적이력 체크
	String est_check2 = "";
	//최근30일이내 견적여부 (본인거 제외)
	Vector vt_chk2 = e_db.getEstimateContEstCheck(bean.getRent_mng_id(), bean.getRent_l_cd(), bean.getRent_st());
	int vt_chk2_size = vt_chk2.size(); 
	
	if(vt_chk2_size > 0){
		for (int i = 0 ; i < vt_chk2_size ; i++){
               		Hashtable ht = (Hashtable)vt_chk2.elementAt(i);
               		if(est_check2.equals("")){
               			if( String.valueOf(ht.get("REG_ID")).equals(ck_acar_id)){
               			}else{
               				est_check2 = "※ 먼저 견적한 이력이 있습니다. 앞서 견적한 대여요금과 다르지 않게 보내주세요. \\n\\n견적이력 : 견적담당자 " +String.valueOf(ht.get("USER_NM"))+ " "+ String.valueOf(ht.get("USER_POS"))+ " " +String.valueOf(ht.get("USER_M_TEL"))+ " 견적등록일" +AddUtil.ChangeDate2(String.valueOf(ht.get("REG_DT")));
               				if(acar_de.equals("1000")){
               					est_check2 += "\\n\\n※ 고객지원팀 직원이 먼저 견적한 이력이 있으면 새롭게 연장견적을 산출하지 말고, 연장 견적 이력 버튼을 클릭 후 견적번호를 클릭하여 보이는 견적서를 고객에게 보내주시기 바랍니다.";
               				}
               				est_check2 += "\\n\\n계속 견적하시겠습니까?";
               				break;
               			}
               		}
               	}
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
	//고객확인
	function cust_check(){
	
		var confirm_ment = '';
		
		<%	if(!est_check2.equals("")){ //최근30일 이내 견적한 고객일 경우%>		
			confirm_ment = '<%=est_check2%>'
		<%	}%>
		
		sure = confirm(confirm_ment);
		
		if(sure){
			document.form1.action = "/acar/secondhand/esti_mng_i_a_2_proc_20090901.jsp";			
			document.form1.submit();
		}else{
			return;
		}
	}
//-->
</script>
</head>
<body>
<form action="" name="form1" method="POST">
  <input type="hidden" name="a_e" value="<%=s_st%>">
  <input type="hidden" name="from_page" value="car_esti_s">
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
  <input type="hidden" name="reg_code" value="<%=reg_code%>">    
  <input type="hidden" name="opt_chk" value="<%=opt_chk%>"> 
  <input type="hidden" name="fee_opt_amt" value="<%=fee_opt_amt%>">
  <%for(int i = 0 ; i < esti_idx ; i++){%>
  <input type="hidden" name="est_id" value="<%=est_id[i]%>">
  <%}%>       
</form>
<script>

<%	if(count==1){%>

		
			<%if(!est_check2.equals("")){ //최근30일 이내 견적한 고객일 경우%>              		
			cust_check();
			<%}else{%>
			//재리스 견적프로그램 이동
			document.form1.action = "/acar/secondhand/esti_mng_i_a_2_proc_20090901.jsp";			
			document.form1.submit();
			<%}%>
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

