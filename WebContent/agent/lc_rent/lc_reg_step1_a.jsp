<%@ page language="java" contentType="text/html;charset=euc-kr" %>
<%@ page import="java.util.*, acar.util.*, acar.coolmsg.*, acar.user_mng.*"%>
<%@ page import="acar.cont.*, acar.car_mst.*, acar.car_office.*, acar.estimate_mng.*, acar.car_sche.*"%>
<jsp:useBean id="a_db" scope="page" class="acar.cont.AddContDatabase"/>
<jsp:useBean id="cm_bean" class="acar.car_mst.CarMstBean" scope="page"/>
<jsp:useBean id="cm_db" scope="page" class="acar.coolmsg.CoolMsgDatabase"/>
<jsp:useBean id="ej_bean" class="acar.estimate_mng.EstiJgVarBean" scope="page"/>
<%@ include file="/agent/cookies.jsp" %>

<html>
<head>
<title>FMS</title>
</head>
<body leftmargin="15">
<%
	
	UserMngDatabase umd = UserMngDatabase.getInstance();
	MaMenuDatabase nm_db = MaMenuDatabase.getInstance();
	EstiDatabase e_db = EstiDatabase.getInstance();
	AddCarMstDatabase a_cmb = AddCarMstDatabase.getInstance();
	
	
	String auth_rw 			= request.getParameter("auth_rw")==null?""        :request.getParameter("auth_rw");
	String user_id 			= request.getParameter("user_id")==null?ck_acar_id:request.getParameter("user_id");
	String br_id 			= request.getParameter("br_id")  ==null?acar_br   :request.getParameter("br_id");
	
	String car_id 			= request.getParameter("car_id")==null?"":request.getParameter("car_id");
	String car_seq 			= request.getParameter("car_seq")==null?"":request.getParameter("car_seq");
	
	
	
	boolean flag1 = true;
	boolean flag2 = true;
	boolean flag3 = true;
	boolean flag4 = true;
	boolean flag5 = true;


	//차명정보
	cm_bean = a_cmb.getCarNmCase(car_id, car_seq);
	
	//차종변수
	ej_bean = e_db.getEstiJgVarCase(cm_bean.getJg_code(), "");
	

	//1. 계약기본정보-----------------------------------------------------------------------------------------------
	
	//cont
	String con_cd 			= request.getParameter("con_cd")==null?"":request.getParameter("con_cd");
	String brch_id 			= request.getParameter("brch_id")==null?"":request.getParameter("brch_id");
	String car_st 			= request.getParameter("car_st")==null?"":request.getParameter("car_st");
	String rent_dt 			= request.getParameter("rent_dt")==null?"":request.getParameter("rent_dt");
	String bus_id 			= request.getParameter("bus_id")==null?"":request.getParameter("bus_id");
	String rent_st 			= request.getParameter("rent_st")==null?"":request.getParameter("rent_st");
	String bus_st 			= request.getParameter("bus_st")==null?"":request.getParameter("bus_st");
	String car_gu 			= request.getParameter("car_gu")==null?"":request.getParameter("car_gu");
	String bus_agnt_id 		= request.getParameter("bus_agnt_id")==null?"":request.getParameter("bus_agnt_id");
	
	// ContBase insert 
	ContBaseBean base = new ContBaseBean();
	
	base.setRent_l_cd	(con_cd);
	base.setBrch_id		(brch_id);
	base.setCar_st		(car_st);
	base.setRent_dt		(rent_dt);
	base.setBus_id		(bus_id);
	base.setRent_st		(rent_st);
	base.setBus_st		(bus_st);
	base.setReg_id		(user_id);
	base.setCar_gu		(car_gu);
	base.setBus_id3		(bus_id);
	base.setReg_step	("1");	
	base.setClient_id	("000228");//아마존카
	base.setAgent_emp_id	(request.getParameter("agent_emp_id")==null?"":request.getParameter("agent_emp_id"));
	base.setSanction_type("신규등록");
	
		
	//=====[cont] insert=====
	base = a_db.insertContBaseNew(base);
	
	
	
	String rent_mng_id 	= base.getRent_mng_id()	==null?"":base.getRent_mng_id();
	String rent_l_cd 	= base.getRent_l_cd()	==null?"":base.getRent_l_cd();
	
	
	if(!rent_mng_id.equals("")){
		
		//2. 관련테이블 생성 [car_mgr,car_pur,car_etc,fee,allot] insert-------------------------------------------------
		flag1 = a_db.insertContEtcRows(rent_mng_id, rent_l_cd);
		
		
		//3. 계약기타정보-----------------------------------------------------------------------------------------------
		
		//cont_etc
		String mng_br_id = request.getParameter("mng_br_id")==null?"":request.getParameter("mng_br_id");
		
		if(bus_id.equals(bus_agnt_id)) bus_agnt_id = "";
		
		// ContEtc insert 
		ContEtcBean cont_etcBn = new ContEtcBean();
		
		cont_etcBn.setRent_mng_id		(rent_mng_id);
		cont_etcBn.setRent_l_cd			(rent_l_cd);
		cont_etcBn.setMng_br_id			(mng_br_id);
		cont_etcBn.setBus_agnt_id		(bus_agnt_id);
		cont_etcBn.setEst_area			(request.getParameter("est_area")		==null?"":request.getParameter("est_area"));
		cont_etcBn.setCounty			(request.getParameter("county")			==null?"":request.getParameter("county"));
		
		// 첨단안전장치 설정(트림에 포함된 경우와 옵션에 장착된 경우 모두 Y) 2018.01.24 추가 수정	start ###
		String lkas_yn 				= request.getParameter("lkas_yn")==null?"":request.getParameter("lkas_yn");
		String lkas_yn_opt_st	= request.getParameter("lkas_yn_opt_st")==null?"":request.getParameter("lkas_yn_opt_st");
		if(lkas_yn.equals("Y")||lkas_yn_opt_st.equals("Y")){
			cont_etcBn.setLkas_yn("Y");
		}
		String ldws_yn 				= request.getParameter("ldws_yn")==null?"":request.getParameter("ldws_yn");
		String ldws_yn_opt_st	= request.getParameter("ldws_yn_opt_st")==null?"":request.getParameter("ldws_yn_opt_st");
		if(ldws_yn.equals("Y")||ldws_yn_opt_st.equals("Y")){
			cont_etcBn.setLdws_yn("Y");
		}
		String aeb_yn 				= request.getParameter("aeb_yn")==null?"":request.getParameter("aeb_yn");
		String aeb_yn_opt_st	= request.getParameter("aeb_yn_opt_st")==null?"":request.getParameter("aeb_yn_opt_st");
		if(aeb_yn.equals("Y")||aeb_yn_opt_st.equals("Y")){
			cont_etcBn.setAeb_yn("Y");
		}
		String fcw_yn 				= request.getParameter("fcw_yn")==null?"":request.getParameter("fcw_yn");
		String fcw_yn_opt_st	= request.getParameter("fcw_yn_opt_st")==null?"":request.getParameter("fcw_yn_opt_st");
		if(fcw_yn.equals("Y")||fcw_yn_opt_st.equals("Y")){
			cont_etcBn.setFcw_yn("Y");
		}
		String garnish_yn			= request.getParameter("garnish_yn")==null?"":request.getParameter("garnish_yn");
		String garnish_yn_opt_st	= request.getParameter("garnish_yn_opt_st")==null?"":request.getParameter("garnish_yn_opt_st");
		if(garnish_yn.equals("Y")||garnish_yn_opt_st.equals("Y")){
			cont_etcBn.setGarnish_yn("Y");
		}
		String hook_yn			= request.getParameter("hook_yn")==null?"":request.getParameter("hook_yn");
		String hook_yn_opt_st	= request.getParameter("hook_yn_opt_st")==null?"":request.getParameter("hook_yn_opt_st");
		if(hook_yn.equals("Y")||hook_yn_opt_st.equals("Y")){
			cont_etcBn.setHook_yn("Y");
		}
		// 첨단안전장치 end ###
		// 재리스 전기차 여부
		if(ej_bean.getJg_g_7().equals("3")){
			cont_etcBn.setEv_yn("Y");
		}
		// 월렌트 전기차 여부
		if(request.getParameter("ev_yn") != null && request.getParameter("ev_yn").equals("Y")){
			cont_etcBn.setEv_yn("Y");
		}
		cont_etcBn.setOthers_device(request.getParameter("others_device")	==null?"":request.getParameter("others_device"));
		cont_etcBn.setTop_cng_yn(request.getParameter("top_cng_yn")	==null?"":request.getParameter("top_cng_yn"));
				
		//=====[cont_etc] insert=====
		flag2 = a_db.insertContEtc(cont_etcBn);
		
		
		
		//4. 차량기본정보-----------------------------------------------------------------------------------------------
		
		//car_etc
		String car_origin 		= request.getParameter("car_origin")==null?"":request.getParameter("car_origin");
		String car_origin_nm 		= request.getParameter("car_origin_nm")==null?"":request.getParameter("car_origin_nm");
		String car_comp_id 		= request.getParameter("car_comp_id")==null?"":request.getParameter("car_comp_id");
		String car_comp_nm 		= request.getParameter("car_comp_nm")==null?"":request.getParameter("car_comp_nm");
		String code 			= request.getParameter("code")==null?"":request.getParameter("code");
		String car_nm 			= request.getParameter("car_nm")==null?"":request.getParameter("car_nm");
		String car_name 		= request.getParameter("car_name")==null?"":request.getParameter("car_name");
		String car_amt 			= request.getParameter("car_amt")==null?"":request.getParameter("car_amt");
		String car_s_amt 		= request.getParameter("car_s_amt")==null?"":request.getParameter("car_s_amt");
		String car_v_amt 		= request.getParameter("car_v_amt")==null?"":request.getParameter("car_v_amt");
		String opt 			= request.getParameter("opt")==null?"":request.getParameter("opt");
		String opt_seq 			= request.getParameter("opt_seq")==null?"":request.getParameter("opt_seq");
		String opt_amt 			= request.getParameter("opt_amt")==null?"":request.getParameter("opt_amt");
		String opt_amt_m 		= request.getParameter("opt_amt_m")==null?"":request.getParameter("opt_amt_m");
		String opt_s_amt 		= request.getParameter("opt_s_amt")==null?"":request.getParameter("opt_s_amt");
		String opt_v_amt 		= request.getParameter("opt_v_amt")==null?"":request.getParameter("opt_v_amt");
		String col 			= request.getParameter("col")==null?"":request.getParameter("col");
		String col_seq 			= request.getParameter("col_seq")==null?"":request.getParameter("col_seq");
		String col_amt 			= request.getParameter("col_amt")==null?"":request.getParameter("col_amt");
		String col_s_amt 		= request.getParameter("col_s_amt")==null?"":request.getParameter("col_s_amt");
		String col_v_amt 		= request.getParameter("col_v_amt")==null?"":request.getParameter("col_v_amt");
		String o_1 			= request.getParameter("o_1")==null?"":request.getParameter("o_1");
		String o_1_s_amt 		= request.getParameter("o_1_s_amt")==null?"":request.getParameter("o_1_s_amt");
		String o_1_v_amt 		= request.getParameter("o_1_v_amt")==null?"":request.getParameter("o_1_v_amt");
		String in_col			= request.getParameter("in_col")==null?"":request.getParameter("in_col");
		String garnish_col	= request.getParameter("garnish_col")==null?"":request.getParameter("garnish_col");
		String conti_rat		= request.getParameter("conti_rat")==null?"":request.getParameter("conti_rat");
		
		// ContCar update
		
		ContCarBean car = new ContCarBean();
		
			
		car.setRent_mng_id	(rent_mng_id);
		car.setRent_l_cd	(rent_l_cd);
		car.setCar_id		(car_id);
		car.setCar_seq		(car_seq);
			
			
		if(car_st.equals("3")){
			car.setEx_gas("1");
		}else{
			if(cm_bean.getS_st().equals("301") || cm_bean.getS_st().equals("302")){
				car.setEx_gas("5");
			}else{
				if(cm_bean.getDpm() < 800) 				car.setEx_gas("6");
				if(cm_bean.getDpm() > 800 && cm_bean.getDpm() < 1500) 	car.setEx_gas("2");
				if(cm_bean.getDpm() > 1500 && cm_bean.getDpm() < 2000) 	car.setEx_gas("3");
				if(cm_bean.getDpm() > 2000) 				car.setEx_gas("4");
			}
		}
			
		if(cm_bean.getS_st().equals("501") || cm_bean.getS_st().equals("502") || cm_bean.getS_st().equals("601") || cm_bean.getS_st().equals("602")) 	car.setBae4("0");
		if(cm_bean.getS_st().equals("301") || cm_bean.getS_st().equals("302")) 										car.setBae4("1");
		if(cm_bean.getS_st().equals("700") || cm_bean.getS_st().equals("701") || cm_bean.getS_st().equals("801") || cm_bean.getS_st().equals("401") || cm_bean.getS_st().equals("402")) 	car.setBae4("2");
		if(cm_bean.getS_st().equals("811") || cm_bean.getS_st().equals("821")) 										car.setBae4("3");
		if(cm_bean.getS_st().equals("821")) 														car.setBae4("4");		
		if(car.getBae4().equals("")) 															car.setBae4("5");
			
			
		car.setColo		(col);
		car.setOpt		(opt);
		car.setCar_cs_amt	(car_s_amt.equals("")?0:AddUtil.parseDigit(car_s_amt));
		car.setCar_cv_amt	(car_v_amt.equals("")?0:AddUtil.parseDigit(car_v_amt));
		car.setOpt_cs_amt	(opt_s_amt.equals("")?0:AddUtil.parseDigit(opt_s_amt));
		car.setOpt_cv_amt	(opt_v_amt.equals("")?0:AddUtil.parseDigit(opt_v_amt));
		
		if (!car_gu.equals("1")) {
			opt_amt_m = "";
		}
		
		car.setOpt_amt_m	(opt_amt_m.equals("")?0:AddUtil.parseDigit(opt_amt_m));
		car.setClr_cs_amt	(col_s_amt.equals("")?0:AddUtil.parseDigit(col_s_amt));
		car.setClr_cv_amt	(col_v_amt.equals("")?0:AddUtil.parseDigit(col_v_amt));
		car.setOpt_code		(opt_seq);
		car.setCar_origin		(car_origin);
		car.setIn_col			(in_col);
		car.setGarnish_col	(garnish_col);		
		car.setJg_opt_st		(request.getParameter("jg_opt_st")==null?"":request.getParameter("jg_opt_st"));
		car.setJg_col_st		(request.getParameter("jg_col_st")==null?"":request.getParameter("jg_col_st"));
		car.setConti_rat		(conti_rat);
		car.setJg_tuix_st		(request.getParameter("jg_tuix_st")==null?"":request.getParameter("jg_tuix_st"));
		car.setJg_tuix_opt_st	(request.getParameter("jg_tuix_opt_st")==null?"":request.getParameter("jg_tuix_opt_st"));
		
		//에이전트는 모두 신차
		//수입차 비용 차종관리 디폴트처리
		if(car_origin.equals("2")){
			//리스
			if(car_st.equals("3")){
				car.setImport_card_amt		(cm_bean.getL_card_amt());
				car.setImport_cash_back		(cm_bean.getL_cash_back());
				car.setImport_bank_amt		(cm_bean.getL_bank_amt());
			//렌트
			}else{
				car.setImport_card_amt		(cm_bean.getR_card_amt());
				car.setImport_cash_back		(cm_bean.getR_cash_back());
				car.setImport_bank_amt		(cm_bean.getR_bank_amt());				
			}
		}
		
		
		//=====[car_etc] update=====
		flag3 = a_db.updateContCarNew(car);
			
			
			
		//영업사원-영업담당 자동연동
		UsersBean sender_bean 	= umd.getUsersBean(bus_id);
		
		if(sender_bean.getDept_id().equals("1000")){
			
			CommiBean emp1 	= a_db.getCommi(rent_mng_id, rent_l_cd, "1");
			
			if(!sender_bean.getSa_code().equals("")){
				emp1.setEmp_id		(sender_bean.getSa_code());
			}else{
				emp1.setEmp_id		(a_db.getAgentEmpId(sender_bean.getUser_ssn()));
			}
						
			emp1.setAgnt_st		("1");
			emp1.setCommi_st	("1");
			if(emp1.getRent_mng_id().equals("")){
				emp1.setRent_mng_id	(rent_mng_id);
				emp1.setRent_l_cd	(rent_l_cd);
				//=====[commi] insert=====
				flag2 = a_db.insertCommiNew(emp1);
			}else{
				//=====[commi] update=====
				flag2 = a_db.updateCommiNew(emp1);
			}				
		}
			
		//현대자동차 특판처리
		/*
		if(cm_bean.getCar_comp_id().equals("0001")){
				
			CommiBean emp2 	= a_db.getCommi(rent_mng_id, rent_l_cd, "2");
			emp2.setEmp_id		("030849");
			emp2.setAgnt_st		("2");
			emp2.setCommi_st	("1");
			if(emp2.getRent_mng_id().equals("")){
				emp2.setRent_mng_id	(rent_mng_id);
				emp2.setRent_l_cd	(rent_l_cd);
				//=====[commi] insert=====
				flag2 = a_db.insertCommiNew(emp2);
			}else{
				//=====[commi] update=====
				flag2 = a_db.updateCommiNew(emp2);
			}			
		}
		*/
			
		//삼성자동차 특판처리
		/*
		if(cm_bean.getCar_comp_id().equals("0003")){
				
			CommiBean emp2 	= a_db.getCommi(rent_mng_id, rent_l_cd, "2");
			emp2.setEmp_id		("030879");
			emp2.setAgnt_st		("2");
			emp2.setCommi_st	("1");
			if(emp2.getRent_mng_id().equals("")){
				emp2.setRent_mng_id	(rent_mng_id);
				emp2.setRent_l_cd	(rent_l_cd);
				//=====[commi] insert=====
				flag2 = a_db.insertCommiNew(emp2);
			}else{
				//=====[commi] update=====
				flag2 = a_db.updateCommiNew(emp2);
			}			
		}
		*/

		
		
		
		//5. 대여정보---------------------------------------------------------------------------------------------------
		
		//fee
		String rent_way 		= request.getParameter("rent_way")==null?"":request.getParameter("rent_way");
		
		ContFeeBean fee = new ContFeeBean();
		
		fee.setRent_mng_id		(rent_mng_id);
		fee.setRent_l_cd		(rent_l_cd);
		fee.setRent_st			("1");
		fee.setRent_way			(rent_way);
		fee.setRent_dt			(rent_dt);
		
		//=====[fee] update=====
		flag4 = a_db.updateContFeeNew(fee);
		
		//fee_etc
		ContCarBean fee_etc = a_db.getContFeeEtc(rent_mng_id, rent_l_cd, "1");
		
		if(!bus_agnt_id.equals("")){
			fee_etc.setBus_agnt_id	(bus_agnt_id);
			fee_etc.setBus_agnt_per	(25);
		}
		if(fee_etc.getRent_mng_id().equals("")){
			//=====[cont_etc] update=====
			fee_etc.setRent_mng_id	(rent_mng_id);
			fee_etc.setRent_l_cd	(rent_l_cd);
			fee_etc.setRent_st	("1");
			flag4 = a_db.insertFeeEtc(fee_etc);
		}else{
			//=====[cont_etc] update=====
			flag4 = a_db.updateFeeEtc(fee_etc);
		}
		
			//신규 수입차 계약인 경우 영업기획팀 수입차 담당자에게 메시지 발송
			if(car_gu.equals("1") && ej_bean.getJg_w().equals("1")){
			
					UsersBean target_bean 	= umd.getUsersBean(nm_db.getWorkAuthUser("수입차출고담당"));	
					UsersBean target_bean2 	= umd.getUsersBean(nm_db.getWorkAuthUser("수입차출고담당2"));	
					//UsersBean target_bean3 	= umd.getUsersBean(nm_db.getWorkAuthUser("수입차출고담당3"));	
					
					CarSchDatabase csd = CarSchDatabase.getInstance();
					CarScheBean cs_bean = csd.getCarScheTodayBean(target_bean.getUser_id());
					
									
					String xml_data1 = "";
					xml_data1 =  "<COOLMSG>"+
		  						"<ALERTMSG>"+
  								"    <BACKIMG>4</BACKIMG>"+
  								"    <MSGTYPE>104</MSGTYPE>"+
	  							"    <SUB>수입차계약등록</SUB>"+
			  					"    <CONT>수입차 계약이 1단계 등록되었습니다.  &lt;br&gt; &lt;br&gt; "+cm_bean.getCar_comp_nm()+" "+cm_bean.getCar_nm()+" "+cm_bean.getCar_name()+" "+rent_l_cd+" </CONT>"+
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
		
			//신규 전기차 계약인 경우 영업기획팀 견적 담당자에게 메시지 발송
			if(car_gu.equals("1") && ej_bean.getJg_g_7().equals("3")){
			
					UsersBean target_bean 	= umd.getUsersBean(nm_db.getWorkAuthUser("엑셀견적관리자"));
					UsersBean target_bean2 	= umd.getUsersBean(nm_db.getWorkAuthUser("전기차담당"));
					
					String xml_data1 = "";
					xml_data1 =  "<COOLMSG>"+
		  						"<ALERTMSG>"+
  								"    <BACKIMG>4</BACKIMG>"+
  								"    <MSGTYPE>104</MSGTYPE>"+
	  							"    <SUB>전기차계약등록</SUB>"+
			  					"    <CONT>전기차 계약이 1단계 등록되었습니다.  &lt;br&gt; &lt;br&gt; "+cm_bean.getCar_comp_nm()+" "+cm_bean.getCar_nm()+" "+cm_bean.getCar_name()+" "+rent_l_cd+" </CONT>"+
 								"    <URL></URL>";
					
					xml_data1 += "    <TARGET>"+target_bean.getId()+"</TARGET>";
					xml_data1 += "    <TARGET>"+target_bean2.getId()+"</TARGET>";
										
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
			//신규 수소차 계약인 경우 영업기획팀 견적 담당자에게 메시지 발송
			if(car_gu.equals("1") && ej_bean.getJg_g_7().equals("4")){
			
					UsersBean target_bean 	= umd.getUsersBean(nm_db.getWorkAuthUser("엑셀견적관리자"));	
					UsersBean target_bean2 	= umd.getUsersBean(nm_db.getWorkAuthUser("전기차담당"));
					
					String xml_data1 = "";
					xml_data1 =  "<COOLMSG>"+
		  						"<ALERTMSG>"+
  								"    <BACKIMG>4</BACKIMG>"+
  								"    <MSGTYPE>104</MSGTYPE>"+
	  							"    <SUB>수소차계약등록</SUB>"+
			  					"    <CONT>수소차 계약이 1단계 등록되었습니다.  &lt;br&gt; &lt;br&gt; "+cm_bean.getCar_comp_nm()+" "+cm_bean.getCar_nm()+" "+cm_bean.getCar_name()+" "+rent_l_cd+" </CONT>"+
 								"    <URL></URL>";
					
					xml_data1 += "    <TARGET>"+target_bean.getId()+"</TARGET>";
					xml_data1 += "    <TARGET>"+target_bean2.getId()+"</TARGET>";
					
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
%>
<form name='form1' action='' method='post'>
  <input type="hidden" name="auth_rw" 			value="<%=auth_rw%>">
  <input type="hidden" name="user_id" 			value="<%=user_id%>">
  <input type="hidden" name="br_id" 			value="<%=br_id%>">    
  <input type="hidden" name="rent_mng_id" 		value="<%=rent_mng_id%>">
  <input type="hidden" name="rent_l_cd" 		value="<%=rent_l_cd%>">  
</form>
<script language='javascript'>
	var fm = document.form1;
<%	if(rent_mng_id.equals("")){	%>
		alert('기본정보 에러입니다.\n\n등록되지 않았습니다');
<%	}else{	%>
		alert("등록되었습니다");
		fm.action = 'lc_reg_step2.jsp';
		fm.target = 'd_content';
		fm.submit();

<%		if(!flag1){	%>
		alert('관련테이블 등록 에러입니다.\n\n확인하십시오');
<%		}	%>		
<%		if(!flag2){	%>
		alert('계약기타정보 등록 에러입니다.\n\n확인하십시오');
<%		}	%>		
<%		if(!flag3){	%>
		alert('차량기본정보 등록 에러입니다.\n\n확인하십시오');
<%		}	%>		
<%		if(!flag4){	%>
		alert('대여정보 등록 에러입니다.\n\n확인하십시오');
<%		}	%>		
		
<%	}	%>
</script>
</body>
</html>
