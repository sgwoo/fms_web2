<%@ page language="java" contentType="text/html; charset=euc-kr" %>
<%@ page import="java.util.*, acar.util.*, acar.estimate_mng.*, acar.car_mst.* " %>
<jsp:useBean id="bean" class="acar.estimate_mng.EstimateBean" scope="page"/>
<jsp:useBean id="ej_bean" class="acar.estimate_mng.EstiJgVarBean" scope="page"/>
<jsp:useBean id="cm_bean" class="acar.car_mst.CarMstBean" scope="page"/>
<%@ include file="/smart/cookies.jsp" %>

<%
	int count = 0;
	
	String reg_code  = Long.toString(System.currentTimeMillis());
	
	EstiDatabase e_db = EstiDatabase.getInstance();
	
	bean.setEst_nm		(request.getParameter("est_nm")==null?"":request.getParameter("est_nm"));
	bean.setEst_ssn		(request.getParameter("est_ssn")==null?"":request.getParameter("est_ssn"));
	bean.setEst_tel		(request.getParameter("est_tel")==null?"":request.getParameter("est_tel"));
	bean.setEst_fax		(request.getParameter("est_fax")==null?"":request.getParameter("est_fax"));
	bean.setEst_email	(request.getParameter("est_email")==null?"":request.getParameter("est_email").trim());
	bean.setDoc_type	(request.getParameter("doc_type")==null?"":request.getParameter("doc_type"));
	bean.setSpr_yn		(request.getParameter("spr_yn")==null?"0":request.getParameter("spr_yn"));
	bean.setVali_type	(request.getParameter("vali_type")==null?"":request.getParameter("vali_type"));
	bean.setGi_grade	(request.getParameter("gi_grade")==null?"":request.getParameter("gi_grade"));
	bean.setCaroff_emp_yn	(request.getParameter("caroff_emp_yn")==null?"":request.getParameter("caroff_emp_yn"));
	
	bean.setCar_comp_id	(request.getParameter("car_comp_id")==null?"":request.getParameter("car_comp_id"));
	bean.setCar_cd		(request.getParameter("code")==null?"":request.getParameter("code"));
	bean.setCar_id		(request.getParameter("car_id")==null?"":request.getParameter("car_id"));
	bean.setCar_seq		(request.getParameter("car_seq")==null?"":request.getParameter("car_seq"));
	bean.setCar_amt		(request.getParameter("car_amt")==null?0:AddUtil.parseDigit(request.getParameter("car_amt")));
	bean.setOpt				(request.getParameter("opt")==null?"":request.getParameter("opt"));
	bean.setOpt_seq		(request.getParameter("opt_seq")==null?"":request.getParameter("opt_seq"));
	bean.setOpt_amt		(request.getParameter("opt_amt")==null?0:AddUtil.parseDigit(request.getParameter("opt_amt")));
	bean.setOpt_amt_m	(request.getParameter("opt_amt_m")==null?0:AddUtil.parseDigit(request.getParameter("opt_amt_m")));
	bean.setCol				(request.getParameter("col")==null?"":request.getParameter("col"));
	bean.setIn_col		(request.getParameter("in_col")==null?"":request.getParameter("in_col"));
	bean.setCol_seq		(request.getParameter("col_seq")==null?"":request.getParameter("col_seq"));
	bean.setCol_amt		(request.getParameter("col_amt")==null?0:AddUtil.parseDigit(request.getParameter("col_amt")));
	bean.setDc				(request.getParameter("dc")==null?"":request.getParameter("dc"));
	bean.setDc_seq		(request.getParameter("dc_seq")==null?"":request.getParameter("dc_seq"));
	bean.setDc_amt		(request.getParameter("dc_amt")==null?0:AddUtil.parseDigit(request.getParameter("dc_amt")));
	bean.setO_1				(request.getParameter("o_1")==null?0:AddUtil.parseDigit(request.getParameter("o_1")));
	
	bean.setA_a				(request.getParameter("a_a")==null?"":request.getParameter("a_a"));
	bean.setA_b				(request.getParameter("a_b")==null?"":request.getParameter("a_b"));
	bean.setRo_13			(request.getParameter("ro_13")==null?0:AddUtil.parseFloat(request.getParameter("ro_13")));
	bean.setRo_13_amt	(request.getParameter("ro_13_amt")==null?0:AddUtil.parseDigit(request.getParameter("ro_13_amt")));
	bean.setOpt_chk		(request.getParameter("opt_chk")==null?"":request.getParameter("opt_chk"));
	bean.setRg_8			(request.getParameter("rg_8")==null?0:AddUtil.parseFloat(request.getParameter("rg_8")));
	bean.setRg_8_amt	(request.getParameter("rg_8_amt")==null?0:AddUtil.parseDigit(request.getParameter("rg_8_amt")));
	bean.setPp_per		(request.getParameter("pp_per")==null?0:AddUtil.parseFloat(request.getParameter("pp_per")));
	bean.setPp_amt		(request.getParameter("pp_amt")==null?0:AddUtil.parseDigit(request.getParameter("pp_amt")));
	bean.setPp_st			(request.getParameter("pp_st")==null?"0":request.getParameter("pp_st"));
	bean.setG_10			(request.getParameter("g_10")==null?0:AddUtil.parseDigit(request.getParameter("g_10")));
	
	bean.setIns_per		(request.getParameter("ins_per")	==null?"1":request.getParameter("ins_per"));
	bean.setInsurant	(request.getParameter("insurant")	==null?"1":request.getParameter("insurant"));
	bean.setIns_age		(request.getParameter("ins_age")==null?"":request.getParameter("ins_age"));
	bean.setIns_dj		(request.getParameter("ins_dj")==null?"":request.getParameter("ins_dj"));
	bean.setCar_ja		(request.getParameter("car_ja")==null?0:AddUtil.parseDigit(request.getParameter("car_ja")));
	
	bean.setGi_per		(request.getParameter("gi_per")==null?0 :AddUtil.parseFloat(request.getParameter("gi_per")));
	bean.setGi_amt		(request.getParameter("gi_amt")==null?0 :AddUtil.parseDigit(request.getParameter("gi_amt")));
	bean.setGi_yn			(request.getParameter("gi_yn")==null?"0":request.getParameter("gi_yn"));
	
	bean.setUdt_st		(request.getParameter("udt_st")==null?"0":request.getParameter("udt_st"));
	bean.setA_h				(request.getParameter("a_h")==null?"":request.getParameter("a_h"));
	bean.setO_11			(request.getParameter("o_11")==null?0:AddUtil.parseFloat(request.getParameter("o_11")));
	bean.setFee_dc_per(request.getParameter("fee_dc_per")==null?0:AddUtil.parseFloat(request.getParameter("fee_dc_per")));	
	bean.setReg_dt		(request.getParameter("reg_dt")==null?"":request.getParameter("reg_dt"));
	bean.setReg_id		(request.getParameter("damdang_id")==null?"":request.getParameter("damdang_id"));
	bean.setReg_code	(reg_code);
	bean.setSet_code	(reg_code);
	bean.setRent_dt		(AddUtil.getDate(4));
	
	bean.setAgree_dist(request.getParameter("agree_dist")==null?0 :AddUtil.parseDigit(request.getParameter("agree_dist")));
	bean.setB_agree_dist(request.getParameter("b_agree_dist")==null?0 :AddUtil.parseDigit(request.getParameter("b_agree_dist")));
	bean.setB_o_13		(request.getParameter("b_o_13")==null?0:AddUtil.parseFloat(request.getParameter("b_o_13")));
	bean.setLoc_st		(request.getParameter("loc_st")==null?"":request.getParameter("loc_st"));
	bean.setTint_ps_yn(request.getParameter("tint_ps_yn")		==null?"":request.getParameter("tint_ps_yn"));	// 고급썬팅 유무	2017.12.26
	bean.setTint_ps_nm(request.getParameter("tint_ps_nm")		==null?"":request.getParameter("tint_ps_nm"));	// 고급썬팅 내용
	bean.setTint_ps_amt(request.getParameter("tint_ps_amt")	==null? 0:AddUtil.parseDigit(request.getParameter("tint_ps_amt")));	// 고급썬팅 금액
	bean.setTint_s_yn	(request.getParameter("tint_s_yn")==null?"":request.getParameter("tint_s_yn"));
	bean.setTint_n_yn	(request.getParameter("tint_n_yn")==null?"":request.getParameter("tint_n_yn"));
	bean.setTint_bn_yn	(request.getParameter("tint_bn_yn")==null?"":request.getParameter("tint_bn_yn"));
	bean.setTint_cons_yn	(request.getParameter("tint_cons_yn")==null?"":request.getParameter("tint_cons_yn"));
	bean.setTint_cons_amt(request.getParameter("tint_cons_amt")	==null? 0:AddUtil.parseDigit(request.getParameter("tint_cons_amt")));
	bean.setNew_license_plate(request.getParameter("new_license_plate")==null?"":request.getParameter("new_license_plate"));
	bean.setTint_eb_yn(request.getParameter("tint_eb_yn")==null?"":request.getParameter("tint_eb_yn"));
	
	bean.setIns_good	("0");//애니카보험 미가입
	bean.setLpg_yn		("0");//LPG키트 미장착
	bean.setJg_opt_st	(request.getParameter("jg_opt_st")==null?"":request.getParameter("jg_opt_st"));
	bean.setJg_col_st	(request.getParameter("jg_col_st")==null?"":request.getParameter("jg_col_st"));
	bean.setEcar_loc_st(request.getParameter("ecar_loc_st")==null?"":request.getParameter("ecar_loc_st"));
	bean.setEco_e_tag(request.getParameter("eco_e_tag")==null?"":request.getParameter("eco_e_tag"));//맑은서울스티커 발급
	bean.setTax_dc_amt(request.getParameter("tax_dc_amt")==null?0:AddUtil.parseDigit(request.getParameter("tax_dc_amt")));
	bean.setConti_rat(request.getParameter("conti_rat")==null?"":request.getParameter("conti_rat"));
	bean.setJg_tuix_st			(request.getParameter("jg_tuix_st")==null?"":request.getParameter("jg_tuix_st"));
	bean.setJg_tuix_opt_st	(request.getParameter("jg_tuix_opt_st")==null?"":request.getParameter("jg_tuix_opt_st"));
	bean.setLkas_yn			(request.getParameter("lkas_yn")==null?"":request.getParameter("lkas_yn"));		// 차선이탈 제어형
	bean.setLdws_yn			(request.getParameter("ldws_yn")==null?"":request.getParameter("ldws_yn"));	// 차선이탈 경고형
	bean.setAeb_yn			(request.getParameter("aeb_yn")==null?"":request.getParameter("aeb_yn"));		// 긴급제동 제어형
	bean.setFcw_yn			(request.getParameter("fcw_yn")==null?"":request.getParameter("fcw_yn"));		// 긴급제동 경고형
	bean.setHook_yn			(request.getParameter("hook_yn")==null?"":request.getParameter("hook_yn"));	// 견인고리
	
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
	if(request.getParameter("hook_yn_opt_st") != null && request.getParameter("hook_yn_opt_st").equals("Y")){
		bean.setHook_yn("Y");
	}
	// 첨단안전 장치 옵션 설정 end

	//보증보험가입여부
	if(bean.getGi_amt()>0)						bean.setGi_yn("1");//가입
	else															bean.setGi_yn("0");//면제
	//초기납입구분
	bean.setPp_st		("0");
	if(bean.getG_10() > 0) 														bean.setPp_st("1");//개시대여료
	if(bean.getPp_amt()+bean.getRg_8_amt() > 0) 			bean.setPp_st("2");//보증금+선납금
	
	//2.5톤이상화물 리스 경기등록----------------------------------------------------------------------------------------------------------
	AddCarMstDatabase a_cmb = AddCarMstDatabase.getInstance();
	cm_bean = a_cmb.getCarNmCase(bean.getCar_id(), bean.getCar_seq());		
	
	
	String jg_b_dt = e_db.getVar_b_dt("jg", bean.getRent_dt());
	String em_a_j  = e_db.getVar_b_dt("em", bean.getRent_dt());
			
	//차종변수
	ej_bean = e_db.getEstiJgVarCase(cm_bean.getJg_code(), jg_b_dt);
	
	//전기차,수소차 주요차종은 견적구분 : 전기차 · 수소차 인수 / 반납 선택형 및 반납형 견적
	if(ej_bean.getJg_g_7().equals("3") || ej_bean.getJg_g_7().equals("4")){//전기차,수소차
		bean.setPrint_type	("6");
	}		
	
	//전기차 여부 등록
	if(ej_bean.getJg_g_7().equals("3")){
		bean.setEv_yn("Y");
	}	
	
	bean.setA_h("7"); //20130130 모두 인천등록
	
	if(ej_bean.getJg_g_7().equals("3")){
		//20200221 전기차 고객주소지에 따른 실등록지역 변경
		//1.서울, 2.파주, 3.부산, 4.김해, 5.대전, 6.포천, 7.인천, 8.제주, 9.광주, 10.대구
		
		// 기존 전기화물차(등록지: 서울) 외 모든 전기차 고객 주소지와 관련 없이 인천으로 등록. 2021.02.18.
		// 전기화물차 외 전기차 고객주소지 따라 실등록지역 등록. 서울/인천/대전/광주/대구/부산 외 나머지 고객주서지는 인천 등록. 20210224
		// 전기화물차 외 전기차 고객주소지 따라 실등록지역 등록. 서울/인천/대전/광주/대구/부산 외 나머지 고객주소지는 부산 등록. 20210520
		// 고객주소지에 관계 없이 전기화물차면 실등록지역 대구, 전기승용차면 실등록지역 인천 등록. 20220519
		if ( Integer.parseInt(cm_bean.getJg_code()) > 8000000 ) {	// 전기화물차
 			bean.setA_h("10");	// 전기화물차 대구 등록
		} else {
			bean.setA_h	("7");
		}
		
	}
	
	//수소차 인천등록
	if(ej_bean.getJg_g_7().equals("4")){
		bean.setA_h	("7");
	}	
	
	//친환경차
	if(ej_bean.getJg_g_7().equals("1") || ej_bean.getJg_g_7().equals("2") || ej_bean.getJg_g_7().equals("3") || ej_bean.getJg_g_7().equals("4")){
		if(bean.getEco_e_tag().equals("1")){
			bean.setA_h	("1");//20171017 맑은서울스티커는 서울
		}
	}
	
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
	
	String est_reg_yn = "Y";
	
	String est_check1 = "";
	String est_check2 = "";
	String est_check3 = "";
	
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
	
	if(vt_chk2_size > 0){
		for (int i = 0 ; i < vt_chk2_size ; i++){
               		Hashtable ht = (Hashtable)vt_chk2.elementAt(i);
               		if(est_check2.equals("")){
               			if( String.valueOf(ht.get("REG_ID")).equals(user_id)){
               			}else{
               				est_check2 = "##고객상호/이름 or 사업자등록번호 or 연락처 or FAX or 이메일주소로 검색한 결과##\\n\\n["+String.valueOf(ht.get("EST_NM"))+"]는 최근 30일이내 견적한 고객입니다.\\n\\n견적담당자 " +String.valueOf(ht.get("USER_NM"))+ " "+ String.valueOf(ht.get("USER_POS"))+ " " +String.valueOf(ht.get("USER_M_TEL"))+ "\\n\\n계속 견적하시겠습니까?";
               				break;
               			}                		
               		}
               	}                	
	}		
		
	//최근7일이내 스마트견적여부 (본인거 제외) -> 20160520 안하기로
	/*
	Vector vt_chk3 = e_db.getEstimateSpeCustEstCheck("1", bean.getEst_nm(), bean.getEst_ssn(), bean.getEst_tel(), bean.getEst_fax(), bean.getEst_email());
	int vt_chk3_size = vt_chk3.size(); 
	
	if(vt_chk3_size > 0){
		for (int i = 0 ; i < 1 ; i++){
               		Hashtable ht = (Hashtable)vt_chk3.elementAt(i);
               		if( String.valueOf(ht.get("REG_ID")).equals("") || String.valueOf(ht.get("REG_ID")).equals(user_id)){
               			est_check3 = "";
               		}else{
               			est_check3 = "##고객상호/이름 or 사업자등록번호 or 연락처 or FAX or 이메일주소로 검색한 결과##\\n\\n["+String.valueOf(ht.get("EST_NM"))+"]는 최근 7일이내 스마트견적 요청한 고객입니다.\\n\\n담당자 " +String.valueOf(ht.get("USER_NM"))+ " "+ String.valueOf(ht.get("USER_POS"))+ " " +String.valueOf(ht.get("USER_M_TEL"))+ "\\n\\n계속 견적하시겠습니까?";               			
               		}                		
               	}                	
	}else{
		est_check3 = "";
	}	
	*/		
	
	float cls_a_b = AddUtil.parseFloat(bean.getA_b())/2;	
	
	
		for(int i = 0 ; i < esti_idx ; i++){
			EstimateBean a_bean = new EstimateBean();
			
			a_bean = bean;
			
			//견적구분&대여개월&약정주행거리
			if(i==0){
				a_bean.setJob		("org");
				a_bean.setA_b		(bean.getA_b());
			}else if(i==1){
				a_bean.setJob		("cls");
				a_bean.setA_b		(AddUtil.parseFloatCipher2(cls_a_b,0));				
			}
			
			
			
			String jg_w 	= request.getParameter("jg_w")==null?"":request.getParameter("jg_w");
			
			//[20121120] 수입차 리스는 아마존카 피보험자를 할수 없다.
			if(jg_w.equals("1")){
				if(a_bean.getA_a().equals("12")){
					if(a_bean.getIns_per().equals("1")){
						est_reg_yn = "N";
					}
				}		
				//일반식불가			
				if(a_bean.getA_a().equals("11") || a_bean.getA_a().equals("21")){
					est_reg_yn = "N";
				}					
			}
				
			if(est_reg_yn.equals("Y")){
			
				out.println("#### a_b="+a_bean.getA_b()+"-------------------------------<br>");
			
				//견적관리번호 생성
				//a_est_id[i] = e_db.getNextEst_id("F");
				a_est_id[i] = Long.toString(System.currentTimeMillis())+""+String.valueOf(i);
				
				//fms3에서 견적함.
				if(AddUtil.lengthb(a_est_id[i]) < 15)	a_est_id[i] = a_est_id[i]+""+"3";
		
				a_bean.setEst_type		("F");
			
				/*고객정보*/
				a_bean.setEst_id		(a_est_id[i]);
			
				a_bean.setEst_from		("m_estimate");
			
			
				count = e_db.insertEstimate(a_bean);
			}
			
		}
		
	String a_e = request.getParameter("a_e")==null?"":request.getParameter("a_e");
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
			confirm_ment = confirm_ment+'\n\n\n<%=est_check1%>'
		}
		<%	}%>
		

		<%	if(!est_check2.equals("")){ //최근30일 이내 견적한 고객일 경우%>		
		if(confirm_ment == ''){
			confirm_ment = '<%=est_check2%>'
		}else{
			confirm_ment = confirm_ment+'\n\n\n<%=est_check2%>'
		}
		<%	}%>
		
		<%	if(!est_check3.equals("")){ //최근7일 이내 스마트견적 요청한 고객일 경우%>		
		if(confirm_ment == ''){
			confirm_ment = '<%=est_check3%>'
		}else{
			confirm_ment = confirm_ment+'\n\n\n<%=est_check3%>'
		}
		<%	}%>
		
		sure = confirm(confirm_ment);					
		
		if(sure){
			document.form1.action = "new_car_esti_i_a_proc.jsp";		
			document.form1.submit();	
		}else{
			document.form1.target = '_parent';						
			document.form1.action = "new_car_esti_u.jsp";
			document.form1.submit();		
		}
	}
//-->
</script>
</head>
<body>
<form action="new_car_esti_i_a_proc.jsp" name="form1" method="POST">
<%@ include file="/include/search_hidden.jsp" %>
  <%for(int i = 0 ; i < esti_idx ; i++){%>   
  <input type="hidden" name="est_id" value="<%=a_est_id[i]%>">          
  <%}%>      
  <input type="hidden" name="reg_code" value="<%=reg_code%>">  
  <input type="hidden" name="a_e" value="<%=a_e%>">            
  <input type="hidden" name="cmd" value="u">
  <input type="hidden" name="e_page" value="i">  
  <input type="hidden" name="from_page" value="estimate_mng">
  <input type="hidden" name="esti_table" value="estimate"> 
  <input type="hidden" name="opt_chk" value="<%=bean.getOpt_chk()%>"> 
</form>
<script>
<%	if(count==1){%>		
		<%if(est_reg_yn.equals("Y")){%>
		
		<%if(!est_check1.equals("") || !est_check2.equals("") || !est_check3.equals("")){ //아마존카 기존거래처인 경우 || 최근30일 이내 견적한 고객일 경우 || 최근7일 이내 스마트견적 요청한 고객일 경우%>              		
		cust_check();
		<%}else{%>
		document.form1.action = "new_car_esti_i_a_proc.jsp";
		document.form1.submit();
		<%}%>
		
		<%}else{%>	
		alert('수입차 리스 일때는 고객피보험자로 해야 하며, 수입차 리스는 일반식은 견적되지 않습니다.');
		<%}%>		
<%	}else{%>
		alert("에러발생!");
<%	}%>
</script>
</body>
</html>

