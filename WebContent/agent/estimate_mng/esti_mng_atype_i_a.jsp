<%@ page language="java" contentType="text/html; charset=euc-kr" %>
<%@ page import="java.util.*, acar.util.*, acar.estimate_mng.*, acar.car_mst.*, acar.user_mng.*" %>
<jsp:useBean id="bean" class="acar.estimate_mng.EstimateBean" scope="page"/>
<jsp:useBean id="ej_bean" class="acar.estimate_mng.EstiJgVarBean" scope="page"/>
<jsp:useBean id="cm_bean" class="acar.car_mst.CarMstBean" scope="page"/>
<%@ include file="/agent/cookies.jsp" %>

<%
	String auth_rw = request.getParameter("auth_rw")==null?"":request.getParameter("auth_rw");
	String br_id = request.getParameter("br_id")==null?"":request.getParameter("br_id");
	String user_id = request.getParameter("user_id")==null?"":request.getParameter("user_id");
	String gubun1 = request.getParameter("gubun1")==null?"":request.getParameter("gubun1");
	String gubun2 = request.getParameter("gubun2")==null?"":request.getParameter("gubun2");
	String gubun3 = request.getParameter("gubun3")==null?"1":request.getParameter("gubun3");
	String gubun4 = request.getParameter("gubun4")==null?"1":request.getParameter("gubun4");
	String gubun5 = request.getParameter("gubun5")==null?"":request.getParameter("gubun5");
	String gubun6 = request.getParameter("gubun6")==null?"":request.getParameter("gubun6");
	String s_dt = request.getParameter("s_dt")==null?"":request.getParameter("s_dt");
	String e_dt = request.getParameter("e_dt")==null?"":request.getParameter("e_dt");
	String s_kd = request.getParameter("s_kd")==null?"":request.getParameter("s_kd");
	String t_wd = request.getParameter("t_wd")==null?"":request.getParameter("t_wd");
	String cmd = request.getParameter("cmd")==null?"i":request.getParameter("cmd");
	String a_e = request.getParameter("a_e")==null?"":request.getParameter("a_e");
	String damdang_id = request.getParameter("damdang_id")==null?"":request.getParameter("damdang_id");
	String ls_yn 	= request.getParameter("ls_yn")==null?"":request.getParameter("ls_yn");
	
	String est_id = "";
	String est_reg_yn = "Y";
	int count = 0;
	int est_size = 0;
	
	String set_code  = Long.toString(System.currentTimeMillis());
	
	EstiDatabase e_db = EstiDatabase.getInstance();
	AddCarMstDatabase 	a_cmb 	= AddCarMstDatabase.getInstance();
	UserMngDatabase umd = UserMngDatabase.getInstance();
	
	bean.setEst_nm		(request.getParameter("est_nm")==null?"":request.getParameter("est_nm"));
	bean.setEst_ssn		(request.getParameter("est_ssn")==null?"":request.getParameter("est_ssn"));
	bean.setEst_tel		(request.getParameter("est_tel")==null?"":request.getParameter("est_tel"));
	bean.setEst_fax		(request.getParameter("est_fax")==null?"":request.getParameter("est_fax"));
	bean.setSpr_yn		(request.getParameter("spr_yn")==null?"0":request.getParameter("spr_yn"));
	bean.setVali_type	(request.getParameter("vali_type")==null?"":request.getParameter("vali_type"));
	bean.setDoc_type	(request.getParameter("doc_type")==null?"":request.getParameter("doc_type"));
	bean.setDir_pur_commi_yn		(request.getParameter("dir_pur_commi_yn")==null?"N":request.getParameter("dir_pur_commi_yn"));
	bean.setCaroff_emp_yn	(request.getParameter("caroff_emp_yn")==null?"":request.getParameter("caroff_emp_yn"));
	bean.setPp_ment_yn(request.getParameter("pp_ment_yn")==null?"N":request.getParameter("pp_ment_yn"));
	
	bean.setMgr_nm		(request.getParameter("mgr_nm")==null?"":request.getParameter("mgr_nm"));
	
	bean.setCar_comp_id	(request.getParameter("car_comp_id")==null?"":request.getParameter("car_comp_id"));
	bean.setCar_cd		(request.getParameter("code")==null?"":request.getParameter("code"));
	bean.setCar_id		(request.getParameter("car_id")==null?"":request.getParameter("car_id"));
	bean.setCar_seq		(request.getParameter("car_seq")==null?"":request.getParameter("car_seq"));
	bean.setCar_amt		(request.getParameter("car_amt")==null?0:AddUtil.parseDigit(request.getParameter("car_amt")));
	bean.setOpt				(request.getParameter("opt")==null?"":request.getParameter("opt"));
	bean.setOpt_seq		(request.getParameter("opt_seq")==null?"":request.getParameter("opt_seq"));
	bean.setOpt_amt		(request.getParameter("opt_amt")==null?0:AddUtil.parseDigit(request.getParameter("opt_amt")));
	bean.setOpt_amt_m			(request.getParameter("opt_amt_m")==null?0:AddUtil.parseDigit(request.getParameter("opt_amt_m")));
	bean.setCol				(request.getParameter("col")==null?"":request.getParameter("col"));
	bean.setIn_col		(request.getParameter("in_col")==null?"":request.getParameter("in_col"));
	bean.setGarnish_col		(request.getParameter("garnish_col")==null?"":request.getParameter("garnish_col"));
	bean.setCol_seq		(request.getParameter("col_seq")==null?"":request.getParameter("col_seq"));
	bean.setCol_amt		(request.getParameter("col_amt")==null?0:AddUtil.parseDigit(request.getParameter("col_amt")));
	bean.setDc				(request.getParameter("dc")==null?"":request.getParameter("dc"));
	bean.setDc_seq		(request.getParameter("dc_seq")==null?"":request.getParameter("dc_seq"));
	bean.setDc_amt		(request.getParameter("dc_amt")==null?0:AddUtil.parseDigit(request.getParameter("dc_amt")));
	bean.setEsti_d_etc	(request.getParameter("esti_d_etc")==null?"":request.getParameter("esti_d_etc"));
	bean.setO_1			(request.getParameter("o_1")==null?0:AddUtil.parseDigit(request.getParameter("o_1")));
	bean.setEst_email	(request.getParameter("est_email")==null?"":request.getParameter("est_email").trim());
	bean.setSet_code	(set_code);
	bean.setReg_id		(user_id);
	bean.setPrint_type(request.getParameter("print_type")==null?"1":request.getParameter("print_type"));
	bean.setRent_dt		(AddUtil.getDate(4));
	bean.setJg_opt_st	(request.getParameter("jg_opt_st")==null?"":request.getParameter("jg_opt_st"));
	bean.setJg_col_st	(request.getParameter("jg_col_st")==null?"":request.getParameter("jg_col_st"));
	bean.setTax_dc_amt(request.getParameter("tax_dc_amt")==null?0:AddUtil.parseDigit(request.getParameter("tax_dc_amt")));
	bean.setConti_rat	(request.getParameter("conti_rat")==null?"":request.getParameter("conti_rat"));
	bean.setCompare_yn(request.getParameter("compare_yn")==null?"N":request.getParameter("compare_yn"));
	bean.setJg_tuix_st			(request.getParameter("jg_tuix_st")==null?"":request.getParameter("jg_tuix_st"));
	bean.setJg_tuix_opt_st	(request.getParameter("jg_tuix_opt_st")==null?"":request.getParameter("jg_tuix_opt_st"));
	bean.setLkas_yn			(request.getParameter("lkas_yn")==null?"":request.getParameter("lkas_yn"));		// 차선이탈 제어형
	bean.setLdws_yn			(request.getParameter("ldws_yn")==null?"":request.getParameter("ldws_yn"));	// 차선이탈 경고형
	bean.setAeb_yn			(request.getParameter("aeb_yn")==null?"":request.getParameter("aeb_yn"));		// 긴급제동 제어형
	bean.setFcw_yn			(request.getParameter("fcw_yn")==null?"":request.getParameter("fcw_yn"));		// 긴급제동 경고형
	bean.setGarnish_yn		(request.getParameter("garnish_yn")==null?"":request.getParameter("garnish_yn"));		// 가니쉬
	bean.setHook_yn		(request.getParameter("hook_yn")==null?"":request.getParameter("hook_yn"));		// 견인고리
	bean.setEtc				(request.getParameter("car_etc2")==null?"":request.getParameter("car_etc2"));	//차량비고(외제차량 기간제 프로모션등 활용-고연미과장님 요청)(2018.05.04)
	bean.setBigo			(request.getParameter("bigo")==null?"":request.getParameter("bigo"));			//제조사DC비고(2018.05.04)
	bean.setGi_grade		(request.getParameter("gi_grade")==null?"":request.getParameter("gi_grade"));			//보증보험료산출 등급
	bean.setInfo_st			(request.getParameter("info_st")==null?"":request.getParameter("info_st"));			//안내문표기여부
	
	if(bean.getCaroff_emp_yn().equals("4")){
		bean.setDamdang_nm		(request.getParameter("damdang_nm")==null?"":request.getParameter("damdang_nm"));
		bean.setDamdang_m_tel	(request.getParameter("damdang_m_tel")==null?"":request.getParameter("damdang_m_tel"));
	}
	
	// 차선이탈 제어, 경고형, 긴급제동 제어, 경고형 옵션에 포함되어 있을 경우 ESTIMATE 테이블 lkas_yn, ldws_yn, aeb_yn, fcw_yn 값을 Y로 설정(2017.11.20) 	start
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
	// 첨단안전 장치 옵션 설정 end
	if(request.getParameter("garnish_yn_opt_st") != null && request.getParameter("garnish_yn_opt_st").equals("Y")){
		bean.setGarnish_yn("Y");
	}
	if(request.getParameter("hook_yn_opt_st") != null && request.getParameter("hook_yn_opt_st").equals("Y")){
		bean.setHook_yn("Y");
	}
	
	if(!damdang_id.equals(""))	bean.setReg_id		(damdang_id);
	
	//차명정보
	cm_bean = a_cmb.getCarNmCase(bean.getCar_id(), bean.getCar_seq());
	
	String jg_b_dt = e_db.getVar_b_dt("jg", bean.getRent_dt());
	String em_a_j  = e_db.getVar_b_dt("em", bean.getRent_dt());
		
	//차종변수
	ej_bean = e_db.getEstiJgVarCase(cm_bean.getJg_code(), jg_b_dt);
	
	//전기차 여부 등록
	if(ej_bean.getJg_g_7().equals("3")){
		bean.setEv_yn("Y");
	}
	
	String est_check1 = "";
	String est_check2 = "";
	String est_check3 = "";
	String est_check4 = ""; // 자차면책금 10만원 이하일 경우 경고창 띄우기 위한 확인 변수 2017.12.27
	String est_check5 = "";
	
	//아마존카 기존거래처 여부 (본인거 제외)
	Vector vt_chk1 = e_db.getEstimateCustRentCheck(bean.getEst_nm(), bean.getEst_ssn(), bean.getEst_tel(), bean.getEst_fax(), bean.getEst_email());
	int vt_chk1_size = vt_chk1.size(); 
		
	if(vt_chk1_size > 0){
		for (int i = 0 ; i < 1 ; i++){
       		Hashtable ht = (Hashtable)vt_chk1.elementAt(i);
       		if( String.valueOf(ht.get("BUS_ID")).equals(user_id) || String.valueOf(ht.get("BUS_ID2")).equals(user_id) ){
       			est_check1 = "";
       		}else{
       			est_check1 = "##고객상호/이름 or 사업자등록번호 or 연락처 or FAX or 이메일주소로 검색한 결과##\\n\\n["+String.valueOf(ht.get("FIRM_NM"))+" "+String.valueOf(ht.get("CLIENT_NM"))+"]는 현재 아마존카 장기대여를 이용하고 있는 고객입니다.\\n\\n최초영업자 " +String.valueOf(ht.get("BUS_NM"))+ " " +String.valueOf(ht.get("BUS_POS"))+ " " +String.valueOf(ht.get("BUS_M_TEL"))+ "\\n관리담당자 " +String.valueOf(ht.get("BUS_NM2"))+ " " +String.valueOf(ht.get("BUS_POS2"))+ " " +String.valueOf(ht.get("BUS_M_TEL2"))+ "\\n\\n계속 견적하시겠습니까?";               			
       		}                		
       	}			
	}else{
		est_check1 = "";
	}
	
	//최근30일이내 견적여부 (본인거 제외)
	Vector vt_chk2 = e_db.getEstimateCustEstCheck("1", bean.getEst_nm(), bean.getEst_ssn(), bean.getEst_tel(), bean.getEst_fax(), bean.getEst_email());
	int vt_chk2_size = vt_chk2.size();
	long reg_dt_estimate = 999999999999L;	//12자리
	
	if(vt_chk2_size > 0){
		for (int i = 0 ; i < vt_chk2_size ; i++){
       		Hashtable ht = (Hashtable)vt_chk2.elementAt(i);
       		if(est_check2.equals("")){
       			if( String.valueOf(ht.get("REG_ID")).equals(user_id)){
       				if(ht.get("REG_DT")!=null){
	   					if(reg_dt_estimate > Long.parseLong(String.valueOf(ht.get("REG_DT")))){
	   						//30일이내 견적중 가장 먼저 견적한 견적일을 구함(스마트견적 건과 비교위해)
	    					reg_dt_estimate = Long.parseLong(String.valueOf(ht.get("REG_DT")));
	  					}
       				}	
       			}else{
       				UsersBean user_bean 	= umd.getUsersBean(String.valueOf(ht.get("USER_NM")));
       				if(!user_bean.getDept_id().equals("1000")){
       					est_check2 = "##고객상호/이름 or 사업자등록번호 or 연락처 or FAX or 이메일주소로 검색한 결과##\\n\\n["+String.valueOf(ht.get("EST_NM"))+"]는 최근 30일이내 견적한 고객입니다.\\n\\n견적담당자 " +String.valueOf(ht.get("USER_NM"))+ " "+ String.valueOf(ht.get("USER_POS"))+ " " +String.valueOf(ht.get("USER_M_TEL"))+ "\\n\\n계속 견적하시겠습니까?";
       				}
       			}
       		}
       	}
	}	
	
	//최근30일이내 스마트견적여부 (본인거 제외) -> 20160520 안하기로 -> 20180509 agent FMS만 다시 적용
	Vector vt_chk3 = e_db.getEstimateSpeCustEstCheck2("1", bean.getEst_nm(), bean.getEst_ssn(), bean.getEst_tel(), bean.getEst_fax(), bean.getEst_email());
	int vt_chk3_size = vt_chk3.size();
	if(vt_chk3_size > 0){
		for (int i = 0 ; i < vt_chk3_size ; i++){
  			Hashtable ht = (Hashtable)vt_chk3.elementAt(i);
  			//현재 견적기준시점 30일 이내에 에이전트 본인의 견적건이 있으면 중간에 스마트 견적건이 있더라도 멘트없음
  			if(ht.get("REG_DT")!=null && reg_dt_estimate != 999999999999L && (reg_dt_estimate < Long.parseLong(String.valueOf(ht.get("REG_DT"))))){
  			}else{
  				est_check3 = "##고객상호/이름 or 사업자등록번호 or 연락처 or FAX or 이메일주소로 검색한 결과##\\n\\n["+String.valueOf(ht.get("EST_NM"))+"]는 최근 30일이내 아마존카 스마트 견적을 신청한 고객입니다.\\n\\n계속 견적하시겠습니까?";
  			}	
        }                	
	}
	
	//사전계약 등록여부 (본인거 제외)
	Vector vt_chk4 = e_db.getEstimatePurPreEstCheck("1", bean.getEst_nm(), bean.getEst_ssn(), bean.getEst_tel(), bean.getEst_fax(), bean.getEst_email());
	int vt_chk4_size = vt_chk4.size();
	if(vt_chk4_size > 0){
		for (int i = 0 ; i < vt_chk4_size ; i++){
  		Hashtable ht = (Hashtable)vt_chk4.elementAt(i);
  		if(est_check5.equals("")){
  			est_check5 = "##고객상호/이름 or 연락처로 검색한 결과##\\n\\n["+String.valueOf(ht.get("FIRM_NM"))+"]는 사전예약 고객입니다.\\n("+String.valueOf(ht.get("CAR_NM"))+")\\n\\n담당자 " +String.valueOf(ht.get("BUS_NM"))+ " "+ String.valueOf(ht.get("USER_POS"))+ " " +String.valueOf(ht.get("USER_M_TEL"))+ "\\n\\n중복여부를 체크해 주세요.\\n\\n계속 견적하시겠습니까?";               			
  		}	
		}
	}	
	//본인거 있으면 노멘트
	if(!est_check5.equals("")){
		for (int i = 0 ; i < vt_chk4_size ; i++){
  		Hashtable ht = (Hashtable)vt_chk4.elementAt(i);
  		if(!est_check5.equals("")){
  			if(String.valueOf(ht.get("BUS_NM")).equals(session_user_nm) || String.valueOf(ht.get("MEMO")).indexOf(session_user_nm) != -1){
  				est_check5 = "";
  			}
  		}
		}
	}
	
	String est_yn[] 		= request.getParameterValues("est_yn");
	String return_select[] 	= request.getParameterValues("return_select");
	String a_a[] 			= request.getParameterValues("a_a");
	String a_b[] 			= request.getParameterValues("a_b");
	String o_13[] 			= request.getParameterValues("o_13");
	String ro_13[] 			= request.getParameterValues("ro_13");
	String ro_13_amt[] 		= request.getParameterValues("ro_13_amt");
	String opt_chk[] 		= request.getParameterValues("opt_chk");
	String rg_8[] 			= request.getParameterValues("rg_8");
	String rg_8_amt[] 		= request.getParameterValues("rg_8_amt");
	String pp_per[] 		= request.getParameterValues("pp_per");
	String pp_amt[] 		= request.getParameterValues("pp_amt");
	String g_10[] 			= request.getParameterValues("g_10");
	String ins_per[] 		= request.getParameterValues("ins_per");
	//String insurant[] 		= request.getParameterValues("insurant");
	String ins_dj[] 		= request.getParameterValues("ins_dj");
	String ins_age[] 		= request.getParameterValues("ins_age");
	String car_ja[] 		= request.getParameterValues("car_ja");
// 	String gi_per[] 		= request.getParameterValues("gi_per");
// 	String gi_amt[] 		= request.getParameterValues("gi_amt");
	String udt_st[] 		= request.getParameterValues("udt_st");
	String o_11[] 			= request.getParameterValues("o_11");
	String fee_dc_per[] 	= request.getParameterValues("fee_dc_per");
	
	String b_agree_dist[] = request.getParameterValues("b_agree_dist");
	String agree_dist[] 	= request.getParameterValues("agree_dist");
	String b_o_13[] 			= request.getParameterValues("b_o_13");
	String rtn_run_amt_yn[] 			= request.getParameterValues("rtn_run_amt_yn");	// 환급대여료 적용 여부. 0 적용 / 1 미적용
	String loc_st[] 			= request.getParameterValues("loc_st");
	String tint_s_yn[] 		= request.getParameterValues("r_tint_s_yn");		// 전면썬팅(기본형)
	String tint_sn_yn[] 		= request.getParameterValues("r_tint_sn_yn");		// 전면썬팅 미시공 할인
	String tint_ps_yn[] 	= request.getParameterValues("r_tint_ps_yn");		// 고급썬팅 
	String tint_ps_nm[] 	= request.getParameterValues("r_tint_ps_nm");		// 고급썬팅 내용
	String tint_ps_amt[] 	= request.getParameterValues("r_tint_ps_amt");		//	고급썬팅 추가금액(공급가)
	String tint_ps_st[] 	= request.getParameterValues("r_tint_ps_st");		// 고급썬팅 선택값
	String tint_n_yn[] 		= request.getParameterValues("r_tint_n_yn");		// 거치형 내비게이션
	String tint_bn_yn[] 		= request.getParameterValues("r_tint_bn_yn");		// 블랙박스 미제공 할인 (빌트인캠,고객장착..)
	String new_license_plate[] 	= request.getParameterValues("r_new_license_plate");	//신형번호판신청 
	String tint_cons_yn[] 		= request.getParameterValues("r_tint_cons_yn");		// 추가탁송료 체크
	String tint_cons_amt[] 	= request.getParameterValues("r_tint_cons_amt");		// 추가탁송료 금액
	String tint_eb_yn[] 	= request.getParameterValues("r_tint_eb_yn");		// 이동형충전기
	String ecar_loc_st[]	= request.getParameterValues("ecar_loc_st");
	String hcar_loc_st[]	= request.getParameterValues("hcar_loc_st");
	//String eco_e_tag[]		= request.getParameterValues("eco_e_tag");
	String com_emp_yn[]		= request.getParameterValues("com_emp_yn");
	
	String reg_code[] 		= new String[est_yn.length];
	
	String r_a_a[] 			= request.getParameterValues("r_a_a");
	String r_ins_per[] 			= request.getParameterValues("r_ins_per");
	String r_ins_dj[] 			= request.getParameterValues("r_ins_dj");
	String r_ins_age[] 			= request.getParameterValues("r_ins_age");
	String r_loc_st[] 			= request.getParameterValues("r_loc_st");
	String r_ecar_loc_st[]	= request.getParameterValues("r_ecar_loc_st");
	String r_hcar_loc_st[]	= request.getParameterValues("r_hcar_loc_st");
	// String r_eco_e_tag[]	= request.getParameterValues("r_eco_e_tag");
	String r_com_emp_yn[]		= request.getParameterValues("r_com_emp_yn");
		
	out.println("est_yn.length="+est_yn.length);
	
	out.println("<br>");
	
	bean.setInsurant		("1"); //20161005 보험계약자 미사용 - 모두 아마존카가 계약자
	
	//4가지 조건 : 최대 8건
	for(int j=0; j < est_yn.length; j++){
		
		if(est_yn[j].equals("Y")){
			
			String r_reg_code  = Long.toString(System.currentTimeMillis());
			
			if(AddUtil.lengthb(r_reg_code) < 18)	r_reg_code = r_reg_code+"4"+j;
			
			reg_code[j]	= r_reg_code;
			
			bean.setReg_code			(reg_code[j]);			
			bean.setA_b						(a_b[j]					==null?"":a_b[j]);
			bean.setO_13					(o_13[j]				==null?0 :AddUtil.parseFloat(o_13[j]));
			/* bean.setRo_13					(ro_13[j]				==null?0 :AddUtil.parseFloat(ro_13[j]));
			bean.setRo_13_amt			(ro_13_amt[j]		==null?0 :AddUtil.parseDigit(ro_13_amt[j])); */
			
			//전기차 수소차일때 반납형일경우
			if(bean.getPrint_type().equals("6")){
				if (return_select[j].equals("1")) {
					bean.setRo_13				(bean.getO_13());
					bean.setRo_13_amt			(0);
				} else {
					bean.setRo_13				(ro_13[j]			==null?0 :AddUtil.parseFloat(ro_13[j]));
					bean.setRo_13_amt			(ro_13_amt[j]		==null?0 :AddUtil.parseDigit(ro_13_amt[j]));
				}
			} else {
				bean.setRo_13				(ro_13[j]			==null?0 :AddUtil.parseFloat(ro_13[j]));
				bean.setRo_13_amt			(ro_13_amt[j]		==null?0 :AddUtil.parseDigit(ro_13_amt[j]));				
			}
			
			bean.setOpt_chk				(opt_chk[j]			==null?"":opt_chk[j]);
			bean.setRg_8					(rg_8[j]				==null?0 :AddUtil.parseFloat(rg_8[j]));
			bean.setRg_8_amt			(rg_8_amt[j]		==null?0 :AddUtil.parseDigit(rg_8_amt[j]));
			bean.setPp_per				(pp_per[j]			==null?0 :AddUtil.parseFloat(pp_per[j]));
			bean.setPp_amt				(pp_amt[j]			==null?0 :AddUtil.parseDigit(pp_amt[j]));
			bean.setG_10					(g_10[j]				==null?0 :AddUtil.parseDigit(g_10[j]));
			bean.setFee_dc_per		(fee_dc_per[j]	==null?0:AddUtil.parseFloat(fee_dc_per[j]));
			bean.setAgree_dist		(agree_dist[j]	==null?0 :AddUtil.parseDigit(agree_dist[j]));
			bean.setB_agree_dist	(b_agree_dist[j]==null?0 :AddUtil.parseDigit(b_agree_dist[j]));
			bean.setB_o_13				(b_o_13[j]			==null?0 :AddUtil.parseFloat(b_o_13[j]));
			bean.setRtn_run_amt_yn(rtn_run_amt_yn[j] == null ? "" : rtn_run_amt_yn[j]);
			
			//렌트,리스,종합견적일때는 첫번째 조건과 동일하도록 한다.
			if(bean.getPrint_type().equals("2") || bean.getPrint_type().equals("3") || bean.getPrint_type().equals("4")){
				bean.setA_a					(r_a_a[j]			==null?"":r_a_a[j]);
				bean.setIns_per			(ins_per[0]		==null?"1":ins_per[0]);
				bean.setIns_dj			(ins_dj[0]		==null?"":ins_dj[0]);
				bean.setIns_age			(ins_age[0]		==null?"":ins_age[0]);
				bean.setCar_ja			(car_ja[0]		==null?0 :AddUtil.parseDigit(car_ja[0]));
				if(AddUtil.parseDigit(car_ja[0]) == 100000){	// 자차면책금이 10만원 이하인 경우 경고창 출력 2017.12.27
					est_check4 = "면책금 10만원으로 진행할 경우 영업팀장님 사전승인을 맡아야 합니다.\\n\\n사전승인을 맡으셨습니까?"; 
				}
// 				bean.setGi_per			(gi_per[0]		==null?0 :AddUtil.parseFloat(gi_per[0]));
// 				bean.setGi_amt			(gi_amt[0]		==null?0 :AddUtil.parseDigit(gi_amt[0]));
				bean.setUdt_st			(udt_st[0]		==null?"0":udt_st[0]);
				bean.setO_11				(o_11[0]			==null?0:AddUtil.parseFloat(o_11[0]));
				bean.setLoc_st			(loc_st[0]			==null?"":loc_st[0]);
				bean.setEcar_loc_st	(ecar_loc_st[0]==null?"0":ecar_loc_st[0]);
				bean.setHcar_loc_st	(hcar_loc_st[0]==null?"0":hcar_loc_st[0]);
				// bean.setEco_e_tag		(eco_e_tag[0]==null?"0":eco_e_tag[0]);	// 맑은서울스티커 발급
				bean.setCom_emp_yn	(com_emp_yn[0]	==null?"N":com_emp_yn[0]);
				bean.setTint_s_yn		(tint_s_yn[0]		==null?"N":tint_s_yn[0]);	// 전면썬팅(기본형)
				bean.setTint_sn_yn		(tint_sn_yn[0]		==null?"N":tint_sn_yn[0]);	// 전면썬팅 미시공 할인
				bean.setTint_ps_yn	(tint_ps_yn[0]		==null?"N":tint_ps_yn[0]);	// 고급썬팅
				bean.setTint_ps_nm	(tint_ps_nm[0]		==null?""  :tint_ps_nm[0]);	// 고급썬팅 내용
				bean.setTint_ps_amt	(tint_ps_amt[0]	==null?0	 :AddUtil.parseDigit(tint_ps_amt[0]));// 고급썬팅 추가금액(공급가)
				bean.setTint_ps_st	(tint_ps_st[0]		==null?""  :tint_ps_st[0]);	// 고급썬팅 선택값
				bean.setTint_n_yn		(tint_n_yn[0]		==null?"N":tint_n_yn[0]);	// 거치형 내비게이션
				bean.setTint_bn_yn		(tint_bn_yn[0]		==null?"N":tint_bn_yn[0]);	// 블랙박스 미제공 할인 (빌트인캠,고객장착..)
				bean.setNew_license_plate		(new_license_plate[0]		==null?"":new_license_plate[0]);	// 신형번호판신청
				bean.setTint_cons_yn	(tint_cons_yn[0]		==null?"N"  :tint_cons_yn[0]);	// 추가탁송료 선택
				bean.setTint_cons_amt	(tint_cons_amt[0]	==null?0	 :AddUtil.parseDigit(tint_cons_amt[0]));// 추가탁송료 금액
				bean.setTint_eb_yn	(tint_eb_yn[0]	==null?"N":tint_eb_yn[0]);	//이동형충전기
			//견적별종합일때 첫번째 조건과 동일하도록 한다.
			}else if(bean.getPrint_type().equals("5")){
				bean.setA_a					(a_a[j]				==null?"":a_a[j]);
				bean.setIns_per			(r_ins_per[0]		==null?"1":r_ins_per[0]);
				bean.setIns_dj			(r_ins_dj[0]		==null?"":r_ins_dj[0]);
				bean.setIns_age			(r_ins_age[0]		==null?"":r_ins_age[0]);
				bean.setCar_ja			(car_ja[0]		==null?0 :AddUtil.parseDigit(car_ja[0]));
				if(AddUtil.parseDigit(car_ja[0]) == 100000){	// 자차면책금이 10만원 이하인 경우 경고창 출력 2017.12.27
					est_check4 = "면책금 10만원으로 진행할 경우 영업팀장님 사전승인을 맡아야 합니다.\\n\\n사전승인을 맡으셨습니까?"; 
				}
// 				bean.setGi_per		(gi_per[j]		==null?0 :AddUtil.parseFloat(gi_per[j]));
// 				bean.setGi_amt		(gi_amt[j]		==null?0 :AddUtil.parseDigit(gi_amt[j]));
				bean.setUdt_st		(udt_st[0]		==null?"0":udt_st[0]);
				bean.setO_11		(o_11[j]		==null?0:AddUtil.parseFloat(o_11[j]));
				bean.setLoc_st		(r_loc_st[0]	==null?"":r_loc_st[0]);
				bean.setEcar_loc_st	(r_ecar_loc_st[0]==null?"":r_ecar_loc_st[0]);
				bean.setHcar_loc_st	(r_hcar_loc_st[0]	==null?"":r_hcar_loc_st[0]);
				//bean.setEco_e_tag	(r_eco_e_tag[0]	==null?"":r_eco_e_tag[0]);	// 맑은서울스티커 발급
				bean.setCom_emp_yn	(r_com_emp_yn[0]==null?"N":r_com_emp_yn[0]);
				bean.setTint_s_yn	(tint_s_yn[0]	==null?"N":tint_s_yn[0]);		// 전면썬팅(기본형)
				bean.setTint_sn_yn	(tint_sn_yn[0]	==null?"N":tint_sn_yn[0]);		// 전면썬팅 미시공 할인
				bean.setTint_ps_yn	(tint_ps_yn[0]	==null?"N":tint_ps_yn[0]);		// 고급썬팅
				bean.setTint_ps_nm	(tint_ps_nm[0]	==null?""  :tint_ps_nm[0]);		// 고급썬팅 내용
				bean.setTint_ps_amt	(tint_ps_amt[0]==null?0	 :AddUtil.parseDigit(tint_ps_amt[0]));	// 고급썬팅 추가금액(공급가)
				bean.setTint_ps_st	(tint_ps_st[0]	==null?""  :tint_ps_st[0]);		// 고급썬팅 선택값
				bean.setTint_n_yn	(tint_n_yn[0]	==null?"N":tint_n_yn[0]);		// 거치형 내비게이션
				bean.setTint_bn_yn	(tint_bn_yn[0]	==null?"N":tint_bn_yn[0]);		// 블랙박스 미제공 할인 (빌트인캠,고객장착..)
				bean.setNew_license_plate		(new_license_plate[0]		==null?"":new_license_plate[0]);	// 신형번호판신청
				bean.setTint_cons_yn	(tint_cons_yn[0]		==null?"N"  :tint_cons_yn[0]);	// 추가탁송료 선택
				bean.setTint_cons_amt	(tint_cons_amt[0]	==null?0	 :AddUtil.parseDigit(tint_cons_amt[0]));// 추가탁송료 금액
				bean.setTint_eb_yn	(tint_eb_yn[0]	==null?"N":tint_eb_yn[0]);		//이동형충전기
			//전기차 수소차 인수반납 선택형 및 반납형 견적
			}else if(bean.getPrint_type().equals("6")){
				bean.setEh_code			(reg_code[j]);		
				bean.setReturn_select		(return_select[j]		==null?"":return_select[j]);
				bean.setA_a					(a_a[j]				==null?"":a_a[j]);
				bean.setIns_per			(r_ins_per[0]		==null?"1":r_ins_per[0]);
				bean.setIns_dj			(r_ins_dj[0]		==null?"":r_ins_dj[0]);
				bean.setIns_age			(r_ins_age[0]		==null?"":r_ins_age[0]);
				bean.setCar_ja			(car_ja[0]		==null?0 :AddUtil.parseDigit(car_ja[0]));
				if(AddUtil.parseDigit(car_ja[0]) == 100000){	// 자차면책금이 10만원 이하인 경우 경고창 출력 2017.12.27
					est_check4 = "면책금 10만원으로 진행할 경우 영업팀장님 사전승인을 맡아야 합니다.\\n\\n사전승인을 맡으셨습니까?"; 
				}
// 				bean.setGi_per			(gi_per[j]		==null?0 :AddUtil.parseFloat(gi_per[j]));
// 				bean.setGi_amt			(gi_amt[j]		==null?0 :AddUtil.parseDigit(gi_amt[j]));
				bean.setUdt_st			(udt_st[0]		==null?"0":udt_st[0]);
				bean.setO_11				(o_11[j]			==null?0:AddUtil.parseFloat(o_11[j]));
				bean.setLoc_st			(r_loc_st[0]		==null?"":r_loc_st[0]);
				bean.setEcar_loc_st	(r_ecar_loc_st[0]==null?"":r_ecar_loc_st[0]);
				bean.setHcar_loc_st	(r_hcar_loc_st[0]==null?"":r_hcar_loc_st[0]);
				//bean.setEco_e_tag		(r_eco_e_tag[0]==null?"":r_eco_e_tag[0]);// 맑은서울스티커 발급
				bean.setCom_emp_yn	(r_com_emp_yn[0]==null?"N":r_com_emp_yn[0]);
				bean.setTint_s_yn		(tint_s_yn[0]	==null?"N":tint_s_yn[0]);		// 전면썬팅(기본형)
				bean.setTint_sn_yn		(tint_sn_yn[0]	==null?"N":tint_sn_yn[0]);		// 전면썬팅미시공할인
				bean.setTint_ps_yn	(tint_ps_yn[0]	==null?"N":tint_ps_yn[0]);		// 고급썬팅
				bean.setTint_ps_nm	(tint_ps_nm[0]	==null?""  :tint_ps_nm[0]);		// 고급썬팅 내용
				bean.setTint_ps_amt	(tint_ps_amt[0]==null?0	 :AddUtil.parseDigit(tint_ps_amt[0]));	// 고급썬팅 추가금액(공급가)
				bean.setTint_ps_st	(tint_ps_st[0]	==null?""  :tint_ps_st[0]);		// 고급썬팅 선택값
				bean.setTint_n_yn		(tint_n_yn[0]	==null?"N":tint_n_yn[0]);		// 거치형 내비게이션
				bean.setTint_bn_yn		(tint_bn_yn[0]	==null?"N":tint_bn_yn[0]);		// 블랙박스 미제공 할인 (빌트인캠,고객장착..)
				bean.setNew_license_plate		(new_license_plate[0]		==null?"":new_license_plate[0]);	// 신형번호판신청
				bean.setTint_cons_yn	(tint_cons_yn[0]		==null?"N"  :tint_cons_yn[0]);	// 추가탁송료 선택
				bean.setTint_cons_amt	(tint_cons_amt[0]	==null?0	 :AddUtil.parseDigit(tint_cons_amt[0]));// 추가탁송료 금액
				bean.setTint_eb_yn	(tint_eb_yn[0]	==null?"N":tint_eb_yn[0]);		// 이동형 충전기
			//상품별		
			}else{
				bean.setA_a					(a_a[j]				==null?"":a_a[j]);
				bean.setIns_per			(ins_per[j]		==null?"1":ins_per[j]);
				bean.setIns_dj			(ins_dj[j]		==null?"":ins_dj[j]);
				bean.setIns_age			(ins_age[j]		==null?"":ins_age[j]);
				bean.setCar_ja			(car_ja[j]		==null?0 :AddUtil.parseDigit(car_ja[j]));
				if(AddUtil.parseDigit(car_ja[j]) == 100000){		// 자차면책금이 10만원 이하인 경우 경고창 출력 2017.12.27
					est_check4 = "면책금 10만원으로 진행할 경우 영업팀장님 사전승인을 맡아야 합니다.\\n\\n사전승인을 맡으셨습니까?";
				}
// 				bean.setGi_per			(gi_per[j]		==null?0 :AddUtil.parseFloat(gi_per[j]));
// 				bean.setGi_amt			(gi_amt[j]		==null?0 :AddUtil.parseDigit(gi_amt[j]));
				bean.setUdt_st			(udt_st[j]		==null?"0":udt_st[j]);
				bean.setO_11				(o_11[j]			==null?0:AddUtil.parseFloat(o_11[j]));
				bean.setLoc_st			(loc_st[j]			==null?"":loc_st[j]);
				bean.setEcar_loc_st	(ecar_loc_st[j]	==null?"":ecar_loc_st[j]);
				bean.setHcar_loc_st	(hcar_loc_st[j]	==null?"":hcar_loc_st[j]);
				//bean.setEco_e_tag	(eco_e_tag[j]	==null?"":eco_e_tag[j]);// 맑은서울스티커 발급
				bean.setCom_emp_yn	(com_emp_yn[j]	==null?"N":com_emp_yn[j]);
				bean.setTint_s_yn		(tint_s_yn[j]		==null?"N":tint_s_yn[j]);			// 전면썬팅(기본식)
				bean.setTint_sn_yn		(tint_sn_yn[j]		==null?"N":tint_sn_yn[j]);			// 전면썬팅 미시공 할인
				bean.setTint_ps_yn	(tint_ps_yn[j]	==null?"N":tint_ps_yn[j]);		// 고급썬팅
				bean.setTint_ps_nm	(tint_ps_nm[j]	==null?""  :tint_ps_nm[j]);		// 고급썬팅 내용
				bean.setTint_ps_amt	(tint_ps_amt[j]	==null?0	 :AddUtil.parseDigit(tint_ps_amt[j]));		// 고급썬팅 추가금액(공급가)
				bean.setTint_ps_st	(tint_ps_st[j]	==null?""  :tint_ps_st[j]);		// 고급썬팅 선택값
				bean.setTint_n_yn		(tint_n_yn[j]		==null?"N":tint_n_yn[j]);			// 거치형 내비게이션
				bean.setTint_bn_yn		(tint_bn_yn[j]		==null?"N":tint_bn_yn[j]);			// 블랙박스 미제공 할인 (빌트인캠,고객장착..)
				bean.setNew_license_plate		(new_license_plate[j]	==null?"":new_license_plate[j]);	// 신형번호판신청
				bean.setTint_cons_yn	(tint_cons_yn[j]		==null?"N"  :tint_cons_yn[j]);	// 추가탁송료 선택
				bean.setTint_cons_amt	(tint_cons_amt[j]	==null?0	 :AddUtil.parseDigit(tint_cons_amt[j]));// 추가탁송료 금액
				bean.setTint_eb_yn	(tint_eb_yn[j]	==null?"N":tint_eb_yn[j]);		//이동형충전기				
			}
			
			bean.setIns_good	("0");//애니카보험 미가입
			bean.setLpg_yn		("0");//LPG키트 미장착
			
			//렌트,리스,종합견적일때는 첫번째 조건과 동일하도록 한다.
			if(bean.getPrint_type().equals("2") || bean.getPrint_type().equals("3") || bean.getPrint_type().equals("4")){
			}else{
				//리스DC 상이할때
				if(bean.getA_a().equals("11") || bean.getA_a().equals("12")){
					if(ls_yn.equals("Y")){
						bean.setDc_amt		(request.getParameter("dc_amt2")==null?0:AddUtil.parseDigit(request.getParameter("dc_amt2")));
						bean.setO_1				(request.getParameter("o_12")==null?0:AddUtil.parseDigit(request.getParameter("o_12")));
					}else{
						bean.setDc_amt		(request.getParameter("dc_amt")==null?0:AddUtil.parseDigit(request.getParameter("dc_amt")));
						bean.setO_1				(request.getParameter("o_1")==null?0:AddUtil.parseDigit(request.getParameter("o_1")));
					}
				}else{
						bean.setDc_amt		(request.getParameter("dc_amt")==null?0:AddUtil.parseDigit(request.getParameter("dc_amt")));
						bean.setO_1				(request.getParameter("o_1")==null?0:AddUtil.parseDigit(request.getParameter("o_1")));
				}
			}
			
			//보증보험가입여부
			if(bean.getGi_amt()>0)		bean.setGi_yn("1");//가입
			else											bean.setGi_yn("0");//면제
			
			//초기납입구분
			bean.setPp_st		("0");
			if(bean.getG_10() > 0) 		bean.setPp_st		("1");//개시대여료
			if(bean.getPp_amt()+bean.getRg_8_amt() > 0) 				bean.setPp_st		("2");//보증금+선납금
			if(bean.getPp_per()+bean.getRg_8() > 0) 						bean.setPp_st		("2");//보증금+선납금			
			
			bean.setA_h		("7");//20130130 모두 인천등록
			
			//전기차
			if(ej_bean.getJg_b().equals("5")){
				//20200221 전기차 고객주소지에 따른 실등록지역 변경
				//1.서울, 2.파주, 3.부산, 4.김해, 5.대전, 6.포천, 7.인천, 8.제주, 9.광주, 10.대구
				
				bean.setA_h	("1");
				
				// 기존 전기화물차(등록지: 서울) 외 모든 전기차 고객 주소지와 관련 없이 인천으로 등록. 2021.02.18.
				// 전기화물차 외 전기차 고객주소지 따라 실등록지역 등록. 서울/인천/대전/광주/대구/부산 외 나머지 고객주소지는 인천 등록. 20210224
				// 전기화물차 외 전기차 고객주소지 따라 실등록지역 등록. 서울/인천/대전/광주/대구/부산 외 나머지 고객주소지는 부산 등록. 20210520
				// 전기화물차 외 전기차 고객주소지 따라 실등록지역 등록. 서울/인천/대전/광주/대구/부산 외 나머지 고객주소지는 인천 등록. 20210729
				// 고객주소지에 관계 없이 전기화물차면 실등록지역 대구, 전기승용차면 실등록지역 인천 등록. 20220519
				if ( ej_bean.getJg_g_7().equals("3") && Integer.parseInt(cm_bean.getJg_code()) > 8000000 ) { // 친환경차 구분상 전기차 + 차종코드 8000000보다 큰 경우. 전기화물차.
					bean.setA_h	("10");	// 대구
				} else {		// 전기화물차 외 전기차. 전기승용차.
					bean.setA_h	("7");
				}
				
			}
			
			//수소차
			if(ej_bean.getJg_b().equals("6")){
				bean.setA_h	("7"); //20191206 수소차 서울 -> 인천로 등록
				//bean.setA_h	("1"); //20200324  수소차 실등록지역 인천 -> 서울
			}
			
			//친환경차(전기차와 수소차를 제외한 친환경차는 맑음서울스티커 발급선택시 서울로 등록)
			// 2021.02.08. 맑은서울스티커 불필요로 주석처리.
			/* if(ej_bean.getJg_b().equals("3") || ej_bean.getJg_b().equals("4")){
				if(bean.getEco_e_tag().equals("1")){
					bean.setA_h	("1");//20171017 맑은서울스티커는 서울
				}
			} */			
			
			// out.println("j="+j);
			// out.println("a_h="+bean.getA_h());
			
			//20141223 차량등록지역으로 차량인수지점 지정약정운행거리 이미 계산
			if((bean.getUdt_st().equals("") && !bean.getLoc_st().equals("")) || AddUtil.parseInt(AddUtil.replace(bean.getRent_dt(),"-","")) >= 20141223){
				if(bean.getLoc_st().equals("1") || bean.getLoc_st().equals("2") || bean.getLoc_st().equals("3"))	bean.setUdt_st("1");
				if(bean.getLoc_st().equals("7"))	bean.setUdt_st("2");
				if(bean.getLoc_st().equals("4"))	bean.setUdt_st("3");
				if(bean.getLoc_st().equals("6"))	bean.setUdt_st("5");
				if(bean.getLoc_st().equals("5"))	bean.setUdt_st("6");
			}				
			
			int esti_idx = 2;			
			
			String a_est_id[]	 		= new String[esti_idx];
			
			float cls_a_b = AddUtil.parseFloat(bean.getA_b())/2;
			cls_a_b = Math.round(cls_a_b);	// 위약금율 기준이 되는 대여기간은 본 견적에서 /2 후 반올림 처리. 2021.02.18.
			
			for(int i = 0 ; i < esti_idx ; i++){
				EstimateBean a_bean = new EstimateBean();
				
				a_bean = bean;
				
				//중도해지위액율 계산위해 org, cls 견적필요
				//초과운행부담금 계산위해 org, base 견적필요->20101207 현재 초과운행부담금은 계산하지 않음.
				if(i==0){
					a_bean.setJob("org");
					a_bean.setA_b(bean.getA_b());
				}else if(i==1){
					a_bean.setJob("cls");
					a_bean.setA_b(AddUtil.parseFloatCipher2(cls_a_b,0));
				}
				
				//리스견적여부
				if(a_bean.getA_a().equals("11") || a_bean.getA_a().equals("12")){
					if(ej_bean.getJg_i().equals("1")){
						a_bean.setFee_s_amt(0);
						a_bean.setFee_v_amt(0);
					}else{
						a_bean.setFee_s_amt(-1);
						a_bean.setFee_v_amt(-1);
					}
				}
				
				//렌트견적여부
				if(a_bean.getA_a().equals("21") || a_bean.getA_a().equals("22")){
					if(ej_bean.getJg_h().equals("1")){
						a_bean.setFee_s_amt(0);
						a_bean.setFee_v_amt(0);
					}else{
						a_bean.setFee_s_amt(-1);
						a_bean.setFee_v_amt(-1);
					}
				}
				
				out.println("#### a_b="+a_bean.getA_b()+"-------------------------------<br>");
				
				
				//[20130226] 트럭일반식 불가
				if(AddUtil.parseInt(cm_bean.getJg_code()) > 9120 && AddUtil.parseInt(cm_bean.getJg_code()) < 9410){	
					//일반식불가			
					if(a_bean.getA_a().equals("11") || a_bean.getA_a().equals("21")){
						est_reg_yn = "N";
					}					
				}
				if(AddUtil.parseInt(cm_bean.getJg_code()) > 9015410 && AddUtil.parseInt(cm_bean.getJg_code()) < 9045010){	
					//일반식불가			
					if(a_bean.getA_a().equals("11") || a_bean.getA_a().equals("21")){
						est_reg_yn = "N";
					}					
				}
				
				//[20121120] 수입차 리스는 아마존카 피보험자를 할수 없다.
				if(ej_bean.getJg_w().equals("1")){
					//20200207 수입차 리스는 피보험자를 아마존카 만 선택하게 변경되어 아래 내용 주석처리
					if(a_bean.getA_a().equals("12")){
						if(a_bean.getIns_per().equals("1")){
							//est_reg_yn = "N";
						}
					}
					//일반식불가			
					if(a_bean.getA_a().equals("11") || a_bean.getA_a().equals("21")){
						est_reg_yn = "N";
					}					
				}
				
				
				if(est_reg_yn.equals("Y")){
				
					//견적관리번호 생성
					a_est_id[i] = Long.toString(System.currentTimeMillis())+""+String.valueOf(i);
					
					//fms4에서 견적함.
					if(AddUtil.lengthb(a_est_id[i]) < 15)	a_est_id[i] = a_est_id[i]+""+"4";
					
					a_bean.setEst_type		("F");
					a_bean.setEst_id		(a_est_id[i]);
				
				
					count = e_db.insertEstimate(a_bean);
				
								
					if(est_size==0) est_id = a_est_id[i];
				
					est_size++;
				}
			}
		}
	}
%>
<html>
<head>

<title>FMS</title>
<meta http-equiv="content-type" content="text/html; charset=euc-kr">
<link rel="stylesheet" type="text/css" href="/include/table_t.css"></link>
<script language="JavaScript">
<!--
	//고객확인
	function cust_check(){
	
		var confirm_ment = '';
		
		<%	if(!est_check1.equals("")){ //아마존카 기존거래처인 경우%>                		
		if(confirm_ment == ''){
			confirm_ment = '<%=est_check1%>'
		}else{
			confirm_ment = confirm_ment+'\n\n\n--------------------------------\n\n\n<%=est_check1%>'
		}
		<%	}%>
		

		<%	if(!est_check2.equals("")){ //최근30일 이내 견적한 고객일 경우%>		
		if(confirm_ment == ''){
			confirm_ment = '<%=est_check2%>'
		}else{
			confirm_ment = confirm_ment+'\n\n\n--------------------------------\n\n\n<%=est_check2%>'
		}
		<%	}%>
		
		<%	if(!est_check3.equals("")){ //최근7일 이내 스마트견적 요청한 고객일 경우%>		
		if(confirm_ment == ''){
			confirm_ment = '<%=est_check3%>'
		}else{
			confirm_ment = confirm_ment+'\n\n\n--------------------------------\n\n\n<%=est_check3%>'
		}
		<%	}%>
		
		<%	if(!est_check5.equals("")){ //사전계약한 고객일 경우%>		
		if(confirm_ment == ''){
			confirm_ment = '<%=est_check5%>'
		}else{
			confirm_ment = confirm_ment+'\n\n\n--------------------------------\n\n\n<%=est_check5%>'
		}
		<%	}%>		

		<%	if(!est_check4.equals("")){ //자차면책금이 10만원 이하인 경우 2017.12.27%>		
		if(confirm_ment == ''){
			confirm_ment = '<%=est_check4%>'
		}else{
			confirm_ment = confirm_ment+'\n\n\n--------------------------------\n\n\n<%=est_check4%>'
		}
		<%	}%>
		
		sure = confirm(confirm_ment);
		
		if(sure){
			document.form1.action = "/agent/estimate_mng/esti_mng_abtype_proc.jsp";					
			document.form1.submit();	
		}else{
			document.form1.gubun1.value = '1';
			document.form1.gubun2.value = '';
			document.form1.gubun3.value = '';
			document.form1.gubun4.value = '2';
			document.form1.s_dt.value = '';
			document.form1.e_dt.value = '';		
			document.form1.target = 'd_content';								
			document.form1.action = "esti_mng_atype_u.jsp";						
			document.form1.submit();				
		}
	}
//-->
</script>
</head>
<body>
<form action="esti_mng_abtype_proc.jsp" name="form1" method="POST">
  <input type="hidden" name="auth_rw" value="<%=auth_rw%>">
  <input type="hidden" name="br_id" value="<%=br_id%>">  
  <input type="hidden" name="user_id" value="<%=user_id%>">
  <input type="hidden" name="gubun1" value="<%=gubun1%>">
  <input type="hidden" name="gubun2" value="<%=gubun2%>">
  <input type="hidden" name="gubun3" value="<%=gubun3%>">
  <input type="hidden" name="gubun4" value="<%=gubun4%>">
  <input type="hidden" name="gubun5" value="<%=gubun5%>">
  <input type="hidden" name="gubun6" value="<%=gubun6%>">  
  <input type="hidden" name="s_dt" value="<%=s_dt%>">
  <input type="hidden" name="e_dt" value="<%=e_dt%>">
  <input type="hidden" name="s_kd" value="<%=s_kd%>">          
  <input type="hidden" name="t_wd" value="<%=t_wd%>"> 
        
  <input type='hidden' name="esti_type"		value="a">    
  <input type="hidden" name="est_id" 		value="<%=est_id%>">  
  <input type="hidden" name="est_size"		value="<%=est_size%>">  
  <input type="hidden" name="set_code" 		value="<%=set_code%>">
  <input type='hidden' name="reg_id"		value="<%=bean.getReg_id()%>">    
  <%for(int j=0; j < est_yn.length; j++){%>   
  <input type="hidden" name="reg_code" value="<%=reg_code[j]%>">          
  <%}%>    
  <input type="hidden" name="est_check1" 	value="<%=est_check1%>">
  <input type="hidden" name="est_check2" 	value="<%=est_check2%>">  
  <input type="hidden" name="est_check3" 	value="<%=est_check3%>">
  <input type="hidden" name="est_check4" 	value="<%=est_check4%>"><!-- 자차면책금이 10만원인 경우 2017.12.27 -->
  <input type="hidden" name="est_check5" 	value="<%=est_check5%>">
</form>
<script>
<%	if(count==1){%>
		<%if(est_reg_yn.equals("Y")){%>
		
		<%if(!est_check1.equals("") || !est_check2.equals("") || !est_check3.equals("") || !est_check4.equals("") || !est_check5.equals("")){ //아마존카 기존거래처인 경우 || 최근30일 이내 견적한 고객일 경우 || 최근7일 이내 스마트견적 요청한 고객일 경우 || 자차면책금이 10만원 이하인 경우 2017.12.27%>              		
		cust_check();
		<%}else{%>
		document.form1.action = "/agent/estimate_mng/esti_mng_abtype_proc.jsp";				
		document.form1.submit();	
		<%}%>
		
		<%}else{%>	
		//alert('수입차 리스 일때는 고객피보험자로 해야 하며, 수입차 리스는 일반식은 견적되지 않습니다.');
		alert('수입차 리스는 고객피보험자로 견적해야 합니다. 수입차 및 트럭은 일반식 견적이 되지 않습니다. ');
		<%}%>
<%	}else{%>
		<%if(est_reg_yn.equals("N")){%>
		//alert('수입차 리스 일때는 고객피보험자로 해야 하며, 수입차 리스와 트럭의 일반식은 견적되지 않습니다.');
		alert('수입차 리스는 고객피보험자로 견적해야 합니다. 수입차 및 트럭은 일반식 견적이 되지 않습니다. ');
		<%}else{%>	
		alert("에러발생!");
		<%}%>
<%	}%>
</script>
</body>
</html>

