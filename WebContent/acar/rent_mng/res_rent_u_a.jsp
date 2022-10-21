<%@ page language="java" contentType="text/html;charset=euc-kr" %>
<%@ page import="java.util.*, acar.util.*,  acar.common.*, acar.res_search.*, acar.coolmsg.*, acar.user_mng.*, acar.fee.*"%>
<jsp:useBean id="rs_db" scope="page" class="acar.res_search.ResSearchDatabase"/>
<jsp:useBean id="cm_db" scope="page" class="acar.coolmsg.CoolMsgDatabase"/>
<jsp:useBean id="af_db" scope="page" class="acar.fee.AddFeeDatabase"/>
<%@ include file="/acar/cookies.jsp" %>

<html>
<head>
<title>FMS</title>
<link rel=stylesheet type="text/css" href="/include/table_t.css">
<script language='JavaScript' src='../../include/common.js'></script>
</head>
<body leftmargin="15">
<%
	String auth_rw 		= request.getParameter("auth_rw")	==null?"":request.getParameter("auth_rw");
	String user_id 		= request.getParameter("user_id")	==null?"":request.getParameter("user_id");
	String br_id 		= request.getParameter("br_id")		==null?"":request.getParameter("br_id");
	String gubun1 		= request.getParameter("gubun1")	==null?"":request.getParameter("gubun1");
	String gubun2 		= request.getParameter("gubun2")	==null?"":request.getParameter("gubun2");
	String gubun3 		= request.getParameter("gubun3")	==null?"":request.getParameter("gubun3");
	String gubun4 		= request.getParameter("gubun4")	==null?"":request.getParameter("gubun4");	
	String brch_id 		= request.getParameter("brch_id")	==null?"":request.getParameter("brch_id");
	String start_dt 	= request.getParameter("start_dt")	==null?"":request.getParameter("start_dt");
	String end_dt 		= request.getParameter("end_dt")	==null?"":request.getParameter("end_dt");		
	String car_comp_id 	= request.getParameter("car_comp_id")	==null?"":request.getParameter("car_comp_id");
	String code 		= request.getParameter("code")		==null?"":request.getParameter("code");	
	String s_cc 		= request.getParameter("s_cc")		==null?"":request.getParameter("s_cc");
	String s_year 		= request.getParameter("s_year")	==null?"":request.getParameter("s_year");
	String s_kd 		= request.getParameter("s_kd")		==null?"":request.getParameter("s_kd");
	String t_wd 		= request.getParameter("t_wd")		==null?"":request.getParameter("t_wd");
	String sort_gubun 	= request.getParameter("sort_gubun")	==null?"":request.getParameter("sort_gubun");
	String asc 		= request.getParameter("asc")		==null?"":request.getParameter("asc");
	String list_from_page 	= request.getParameter("list_from_page")==null?"":request.getParameter("list_from_page");

	
	String s_cd = request.getParameter("s_cd")==null?"":request.getParameter("s_cd");
	String c_id = request.getParameter("c_id")==null?"":request.getParameter("c_id");
	String mode = request.getParameter("mode")==null?"":request.getParameter("mode");
	String rent_st = request.getParameter("rent_st")==null?"":request.getParameter("rent_st");
	String use_st = request.getParameter("use_st")==null?"":request.getParameter("use_st");
	String sub_c_id = request.getParameter("sub_c_id")==null?"":request.getParameter("sub_c_id");
	String section = request.getParameter("section")==null?"":request.getParameter("section");
	int count = 1;
	int count_cust = 0;
	
	String cust_st = request.getParameter("cust_st")==null?"":request.getParameter("cust_st");
	String c_cust_id = request.getParameter("c_cust_id")==null?"":request.getParameter("c_cust_id");
	String c_cust_nm = request.getParameter("c_cust_nm")==null?"":request.getParameter("c_cust_nm");
	String serv_id = request.getParameter("serv_id")==null?"":request.getParameter("serv_id");
	String accid_id = request.getParameter("accid_id")==null?"":request.getParameter("accid_id");
	String maint_id = request.getParameter("seq_no")==null?"":request.getParameter("seq_no");
	
	//계약정보
	String rent_s_cd = request.getParameter("rent_s_cd")==null?"":request.getParameter("rent_s_cd");
	String rent_dt = request.getParameter("rent_dt")==null?"":request.getParameter("rent_dt");
	String s_brch_id = request.getParameter("s_brch_id")==null?"":request.getParameter("s_brch_id");
	String bus_id = request.getParameter("bus_id")==null?"":request.getParameter("bus_id");
	String rent_start_dt = request.getParameter("h_rent_start_dt")==null?"":request.getParameter("h_rent_start_dt");
	String rent_end_dt = request.getParameter("h_rent_end_dt")==null?"":request.getParameter("h_rent_end_dt");
	String rent_hour = request.getParameter("rent_hour")==null?"":request.getParameter("rent_hour");
	String rent_days = request.getParameter("rent_days")==null?"":request.getParameter("rent_days");
	String rent_months = request.getParameter("rent_months")==null?"":request.getParameter("rent_months");
	String etc = request.getParameter("etc")==null?"":request.getParameter("etc");
	String deli_plan_dt = request.getParameter("h_deli_plan_dt")==null?"":request.getParameter("h_deli_plan_dt");
	String deli_dt = request.getParameter("h_deli_dt")==null?"":request.getParameter("h_deli_dt");
	String deli_loc = request.getParameter("deli_loc")==null?"":request.getParameter("deli_loc");
	String ret_plan_dt = request.getParameter("h_ret_plan_dt")==null?"":request.getParameter("h_ret_plan_dt");
	String ret_dt = request.getParameter("h_ret_dt")==null?"":request.getParameter("h_ret_dt");
	String ret_loc = request.getParameter("ret_loc")==null?"":request.getParameter("ret_loc");
	String sub_l_cd = request.getParameter("sub_l_cd")==null?"":request.getParameter("sub_l_cd");
	
	//네비게이션관련
	String navi_yn 		= request.getParameter("navi_yn")		==null?"N":request.getParameter("navi_yn");
	String serial_no	= request.getParameter("serial_no")	==null?"":request.getParameter("serial_no");
	
	CommonDataBase c_db = CommonDataBase.getInstance();
	UserMngDatabase 	umd 	= UserMngDatabase.getInstance();
	MaMenuDatabase nm_db = MaMenuDatabase.getInstance();
	
	//단기대여관리 등록
	RentContBean rc_bean = rs_db.getRentContCase(s_cd, c_id);
	rc_bean.setRent_st	(rent_st);
	rc_bean.setCust_st	(cust_st);
	rc_bean.setCust_id	(c_cust_id);
	if(rent_st.equals("4") || rent_st.equals("5")){
		rc_bean.setCust_id(c_cust_nm);
	}
	rc_bean.setSub_c_id	(sub_c_id);
	rc_bean.setAccid_id	(accid_id);
	rc_bean.setServ_id	(serv_id);
	rc_bean.setMaint_id	(maint_id);
	rc_bean.setRent_dt	(rent_dt);
	rc_bean.setBrch_id	(s_brch_id);
	rc_bean.setBus_id	(bus_id);
	rc_bean.setRent_start_dt(rent_start_dt);
	rc_bean.setRent_end_dt	(rent_end_dt);
	rc_bean.setRent_hour	(rent_hour);
	rc_bean.setRent_days	(rent_days);
	rc_bean.setRent_months	(rent_months);
	rc_bean.setEtc		(etc);
	rc_bean.setDeli_plan_dt	(deli_plan_dt);
	//rc_bean.setDeli_dt	(deli_dt);
	rc_bean.setRet_plan_dt	(ret_plan_dt);
	//rc_bean.setRet_dt	(ret_dt);
	rc_bean.setDeli_loc	(deli_loc);
	rc_bean.setRet_loc	(ret_loc);
	rc_bean.setReg_id	(user_id);
	rc_bean.setSub_l_cd	(sub_l_cd);
	
	count = rs_db.updateRentCont(rc_bean);


	if(rent_st.equals("1") || rent_st.equals("2") || rent_st.equals("3") || rent_st.equals("9") || rent_st.equals("10")){
	
		//고객기타정보		
		RentMgrBean rm_bean0 = rs_db.getRentMgrCase(s_cd, "4");
		rm_bean0.setMgr_nm	(request.getParameter("c_cust_nm")==null?"":request.getParameter("c_cust_nm"));
		rm_bean0.setSsn		(request.getParameter("c_ssn")==null?"":request.getParameter("c_ssn"));
		rm_bean0.setLic_no	(request.getParameter("c_lic_no")==null?"":request.getParameter("c_lic_no"));
		rm_bean0.setLic_st	(request.getParameter("c_lic_st")==null?"":request.getParameter("c_lic_st"));
		rm_bean0.setTel		(request.getParameter("c_tel")==null?"":request.getParameter("c_tel"));
		rm_bean0.setEtc		(request.getParameter("c_m_tel")==null?"":request.getParameter("c_m_tel"));
		
		if(rm_bean0.getRent_s_cd().equals("")){
			rm_bean0.setRent_s_cd	(s_cd);
			rm_bean0.setMgr_st	("4");
			rm_bean0.setZip		("");
			rm_bean0.setAddr	("");
			if(!rm_bean0.getLic_no().equals("") || !rm_bean0.getTel().equals("") || !rm_bean0.getEtc().equals("")){
				count = rs_db.insertRentMgr(rm_bean0);
			}			
		}else{
			count = rs_db.updateRentMgr(rm_bean0);
		}
			
		//비상연락처 등록
		RentMgrBean rm_bean1 = rs_db.getRentMgrCase(s_cd, "2");
		rm_bean1.setMgr_nm	(request.getParameter("mgr_nm2")==null?"":request.getParameter("mgr_nm2"));
		rm_bean1.setTel		(request.getParameter("m_tel2")==null?"":request.getParameter("m_tel2"));
		rm_bean1.setEtc		(request.getParameter("m_etc2")==null?"":request.getParameter("m_etc2"));
		
		if(rm_bean1.getRent_s_cd().equals("")){
			rm_bean1.setRent_s_cd	(s_cd);
			rm_bean1.setMgr_st	(request.getParameter("mgr_st2")==null?"":request.getParameter("mgr_st2"));
			rm_bean1.setSsn		("");
			rm_bean1.setZip		("");
			rm_bean1.setAddr	("");
			rm_bean1.setLic_no	("");
			if(!rm_bean1.getMgr_st().equals("")){
				count = rs_db.insertRentMgr(rm_bean1);
			}
		}else{
			count = rs_db.updateRentMgr(rm_bean1);
		}
		
		if(rent_st.equals("1") || rent_st.equals("9") ){
			//실운전자-단기대여시
			RentMgrBean rm_bean2 = rs_db.getRentMgrCase(s_cd, "1");
			rm_bean2.setMgr_nm	(request.getParameter("mgr_nm1")==null?"":request.getParameter("mgr_nm1"));
			rm_bean2.setSsn		(request.getParameter("m_ssn1")==null?"":request.getParameter("m_ssn1"));
			rm_bean2.setZip		(request.getParameter("m_zip1")==null?"":request.getParameter("m_zip1"));
			rm_bean2.setAddr	(request.getParameter("m_addr1")==null?"":request.getParameter("m_addr1"));
			rm_bean2.setLic_no	(request.getParameter("m_lic_no1")==null?"":request.getParameter("m_lic_no1"));
			rm_bean2.setLic_st	(request.getParameter("m_lic_st1")==null?"":request.getParameter("m_lic_st1"));
			rm_bean2.setTel		(request.getParameter("m_tel1")==null?"":request.getParameter("m_tel1"));
			rm_bean2.setEtc		(request.getParameter("m_etc1")==null?"":request.getParameter("m_etc1"));
			
			if(rm_bean2.getRent_s_cd().equals("")){			
				rm_bean2.setRent_s_cd	(s_cd);
				rm_bean2.setMgr_st	(request.getParameter("mgr_st1")==null?"":request.getParameter("mgr_st1"));
				if(!rm_bean2.getMgr_st().equals("")){
					count = rs_db.insertRentMgr(rm_bean2);
				}
			}else{
				count = rs_db.updateRentMgr(rm_bean2);
			}
			
			String gua_st = request.getParameter("gua_st")==null?"":request.getParameter("gua_st");
			if(gua_st.equals("1")){
				//연대보증인-단기대여시
				RentMgrBean rm_bean3 = rs_db.getRentMgrCase(s_cd, "3");
				rm_bean3.setMgr_nm	(request.getParameter("mgr_nm3")==null?"":request.getParameter("mgr_nm3"));
				rm_bean3.setSsn		(request.getParameter("m_ssn3")==null?"":request.getParameter("m_ssn3"));
				rm_bean3.setZip		(request.getParameter("m_zip3")==null?"":request.getParameter("m_zip3"));
				rm_bean3.setAddr	(request.getParameter("m_addr3")==null?"":request.getParameter("m_addr3"));
				rm_bean3.setLic_no	(request.getParameter("m_lic_no3")==null?"":request.getParameter("m_lic_no3"));
				rm_bean3.setTel		(request.getParameter("m_tel3")==null?"":request.getParameter("m_tel3"));
				rm_bean3.setEtc		(request.getParameter("m_etc3")==null?"":request.getParameter("m_etc3"));
				
				if(rm_bean3.getRent_s_cd().equals("")){
					rm_bean3.setRent_s_cd	(s_cd);
					rm_bean3.setMgr_st	(request.getParameter("mgr_st3")==null?"":request.getParameter("mgr_st3"));
					if(!rm_bean3.getMgr_st().equals("")){
						count = rs_db.insertRentMgr(rm_bean3);
					}
				}else{
					count = rs_db.updateRentMgr(rm_bean3);
				}
			}
			
			//단기대여 대여정보 등록
			RentFeeBean rf_bean = rs_db.getRentFeeCase(s_cd);
			rf_bean.setDriver_yn	(request.getParameter("driver_yn")==null?"":request.getParameter("driver_yn"));
			rf_bean.setTax_yn	(request.getParameter("tax_yn")==null?"":request.getParameter("tax_yn"));
			rf_bean.setIns_yn	(request.getParameter("ins_yn")==null?"":request.getParameter("ins_yn"));
			rf_bean.setGua_st	(gua_st);
			rf_bean.setGua_cau	(request.getParameter("gua_cau")==null?"":request.getParameter("gua_cau"));
			rf_bean.setPaid_way	(request.getParameter("paid_way")==null?"":request.getParameter("paid_way"));
			rf_bean.setPaid_st	(request.getParameter("paid_st")==null?"":request.getParameter("paid_st"));
			rf_bean.setCard_no	(request.getParameter("card_no")==null?"":request.getParameter("card_no"));
			rf_bean.setFee_s_amt	(request.getParameter("fee_s_amt")==null?0:Util.parseDigit(request.getParameter("fee_s_amt")));
			rf_bean.setFee_v_amt	(request.getParameter("fee_v_amt")==null?0:Util.parseDigit(request.getParameter("fee_v_amt")));
			rf_bean.setDc_s_amt	(request.getParameter("dc_s_amt")==null?0:Util.parseDigit(request.getParameter("dc_s_amt")));
			rf_bean.setDc_v_amt	(request.getParameter("dc_v_amt")==null?0:Util.parseDigit(request.getParameter("dc_v_amt")));
			rf_bean.setIns_s_amt	(request.getParameter("ins_amt")==null?0:Util.parseDigit(request.getParameter("ins_amt")));
			rf_bean.setEtc_s_amt	(request.getParameter("etc_s_amt")==null?0:Util.parseDigit(request.getParameter("etc_s_amt")));
			rf_bean.setEtc_v_amt	(request.getParameter("etc_v_amt")==null?0:Util.parseDigit(request.getParameter("etc_v_amt")));
			rf_bean.setRent_tot_amt	(request.getParameter("rent_tot_amt")==null?0:Util.parseDigit(request.getParameter("rent_tot_amt")));
			rf_bean.setReg_id	(user_id);
			//20120420 월렌트 관련항목 추가
			rf_bean.setInv_s_amt	(request.getParameter("inv_s_amt")==null?0:Util.parseDigit(request.getParameter("inv_s_amt")));
			rf_bean.setInv_v_amt	(request.getParameter("inv_v_amt")==null?0:Util.parseDigit(request.getParameter("inv_v_amt")));			
			rf_bean.setCons_yn	(request.getParameter("cons_yn")==null?"":request.getParameter("cons_yn"));
			rf_bean.setNavi_yn	(request.getParameter("navi_yn")==null?"":request.getParameter("navi_yn"));
			
			rf_bean.setGps_yn	(request.getParameter("gps_yn")==null?"":request.getParameter("gps_yn"));
			rf_bean.setOil_st	(request.getParameter("oil_st")==null?"":request.getParameter("oil_st"));			
			rf_bean.setDist_km	(request.getParameter("dist_km")==null?0:Util.parseDigit(request.getParameter("dist_km")));
			rf_bean.setNavi_s_amt	(request.getParameter("navi_s_amt")==null?0:Util.parseDigit(request.getParameter("navi_s_amt")));
			rf_bean.setNavi_v_amt	(request.getParameter("navi_v_amt")==null?0:Util.parseDigit(request.getParameter("navi_v_amt")));
			rf_bean.setCons1_s_amt	(request.getParameter("cons1_s_amt")==null?0:Util.parseDigit(request.getParameter("cons1_s_amt")));
			rf_bean.setCons1_v_amt	(request.getParameter("cons1_v_amt")==null?0:Util.parseDigit(request.getParameter("cons1_v_amt")));
			rf_bean.setCons2_s_amt	(request.getParameter("cons2_s_amt")==null?0:Util.parseDigit(request.getParameter("cons2_s_amt")));
			rf_bean.setCons2_v_amt	(request.getParameter("cons2_v_amt")==null?0:Util.parseDigit(request.getParameter("cons2_v_amt")));	
			rf_bean.setFee_etc	(request.getParameter("fee_etc")==null?"":request.getParameter("fee_etc"));		
			rf_bean.setCms_acc_no	(request.getParameter("cms_acc_no")	==null?"":request.getParameter("cms_acc_no"));
			rf_bean.setCms_bank	(request.getParameter("cms_bank")	==null?"":request.getParameter("cms_bank"));
			rf_bean.setCms_dep_nm	(request.getParameter("cms_dep_nm")	==null?"":request.getParameter("cms_dep_nm"));
			rf_bean.setMy_accid_yn	(request.getParameter("my_accid_yn")	==null?"":request.getParameter("my_accid_yn"));
			rf_bean.setCar_ja	(request.getParameter("car_ja")==null?0:Util.parseDigit(request.getParameter("car_ja")));
			rf_bean.setF_rent_tot_amt(request.getParameter("f_rent_tot_amt")==null?0:Util.parseDigit(request.getParameter("f_rent_tot_amt")));
			rf_bean.setF_paid_way	(request.getParameter("f_paid_way")==null?"":request.getParameter("f_paid_way"));
			rf_bean.setF_paid_way2	(request.getParameter("f_paid_way2")==null?"":request.getParameter("f_paid_way2"));
			rf_bean.setM2_dc_amt	(request.getParameter("m2_dc_amt")==null?0:Util.parseDigit(request.getParameter("m2_dc_amt")));
			rf_bean.setM3_dc_amt	(request.getParameter("m3_dc_amt")==null?0:Util.parseDigit(request.getParameter("m3_dc_amt")));
			rf_bean.setAmt_per	(request.getParameter("amt_per")==null?"":request.getParameter("amt_per"));
			rf_bean.setCar_use	(request.getParameter("car_use")==null?"":request.getParameter("car_use"));
			
			if ( navi_yn.equals("Y") ) {
				rf_bean.setSerial_no(serial_no);  //네비serial  no 
			} 
			
			if(rf_bean.getRent_s_cd().equals("")){
				rf_bean.setRent_s_cd(s_cd);
				count = rs_db.insertRentFee(rf_bean);
			}else{
				count = rs_db.updateRentFee(rf_bean);
			}
			
			//선불-보증금,배차대여료
			if(rf_bean.getPaid_way().equals("1")){
				for(int i=0; i<3; i++){
				
					String scd_rent_st = request.getParameter("rent_st"+i)==null?"":request.getParameter("rent_st"+i);
					String scd_tm = request.getParameter("tm"+i)==null?"":request.getParameter("tm"+i);
					
					if(scd_tm.equals(""))  scd_tm = "1";
					
					ScdRentBean sr_bean = rs_db.getScdRentCase(s_cd, scd_rent_st, scd_tm);
					
					String old_pay_dt = sr_bean.getPay_dt();
					
					//미입금만 수정가능
					if(!sr_bean.getRent_s_cd().equals("") && old_pay_dt.equals("")){
					
						sr_bean.setPaid_st	(request.getParameter("paid_st"+i)==null?"1":request.getParameter("paid_st"+i));
						sr_bean.setRent_s_amt	(request.getParameter("rent_s_amt"+i)==null?0:Util.parseDigit(request.getParameter("rent_s_amt"+i)));
						sr_bean.setRent_v_amt	(request.getParameter("rent_v_amt"+i)==null?0:Util.parseDigit(request.getParameter("rent_v_amt"+i)));
						//sr_bean.setPay_amt	(request.getParameter("pay_amt"+i)==null?0:Util.parseDigit(request.getParameter("pay_amt"+i)));
						sr_bean.setRest_amt	(request.getParameter("rest_amt"+i)==null?0:Util.parseDigit(request.getParameter("rest_amt"+i)));
						sr_bean.setReg_id	(user_id);
					
						if(sr_bean.getEst_dt().equals("")){
							sr_bean.setEst_dt	(request.getParameter("est_dt"+i)==null?"":request.getParameter("est_dt"+i));
						}else{
							//배차예정일과 같을때는 수정					
							if(request.getParameter("deli_plan_dt").equals(request.getParameter("est_dt"+i))){
								sr_bean.setEst_dt	(request.getParameter("est_dt"+i)==null?"":request.getParameter("est_dt"+i));
							}						
						}
					
						//if(sr_bean.getRent_s_cd().equals("")){
						//	sr_bean.setRent_s_cd	(s_cd);
						//	sr_bean.setRent_st	(scd_rent_st);
						//	sr_bean.setTm		(scd_tm);
						//	sr_bean.setDly_days	("");
						//	sr_bean.setDly_amt	(0);
						//	sr_bean.setBill_yn	("Y");
						//	count = rs_db.insertScdRent(sr_bean);
						//}else{
							count = rs_db.updateScdRent(sr_bean);
						//}
					}
				}
			}
			
			//보험대차 관련정보
			if(rent_st.equals("9")){
				RentInsBean ri_bean = rs_db.getRentInsCase(s_cd);
				ri_bean.setIns_com_id	(request.getParameter("ins_com_id")==null?"":request.getParameter("ins_com_id"));
				ri_bean.setIns_num	(request.getParameter("ins_num")==null?"":request.getParameter("ins_num"));
				ri_bean.setIns_nm	(request.getParameter("ins_nm")==null?"":request.getParameter("ins_nm"));
				ri_bean.setIns_tel	(request.getParameter("ins_tel")==null?"":request.getParameter("ins_tel"));
				ri_bean.setIns_tel2	(request.getParameter("ins_tel2")==null?"":request.getParameter("ins_tel2"));
				ri_bean.setIns_fax	(request.getParameter("ins_fax")==null?"":request.getParameter("ins_fax"));
				ri_bean.setReg_id	(user_id);
				
				if(ri_bean.getRent_s_cd().equals("")){
					ri_bean.setRent_s_cd(s_cd);
					count = rs_db.insertRentIns(ri_bean);
				}else{
					count = rs_db.updateRentIns(ri_bean);
				}
			}
		}
		
		//기본식 정비대차 청구정보
		if(rent_st.equals("2")){
		
			//단기대여 대여정보 등록
			RentFeeBean rf_bean = rs_db.getRentFeeCase(s_cd);
			rf_bean.setFee_s_amt	(request.getParameter("fee_s_amt")==null?0:Util.parseDigit(request.getParameter("fee_s_amt")));
			rf_bean.setFee_v_amt	(request.getParameter("fee_v_amt")==null?0:Util.parseDigit(request.getParameter("fee_v_amt")));
			rf_bean.setRent_tot_amt	(request.getParameter("rent_tot_amt")==null?0:Util.parseDigit(request.getParameter("rent_tot_amt")));
			rf_bean.setReg_id	(user_id);
			rf_bean.setCons_yn	(request.getParameter("cons_yn")==null?"":request.getParameter("cons_yn"));
			rf_bean.setPaid_st	(request.getParameter("paid_st")==null?"":request.getParameter("paid_st"));
			rf_bean.setCons1_s_amt	(request.getParameter("cons1_s_amt")==null?0:Util.parseDigit(request.getParameter("cons1_s_amt")));
			rf_bean.setCons1_v_amt	(request.getParameter("cons1_v_amt")==null?0:Util.parseDigit(request.getParameter("cons1_v_amt")));
			rf_bean.setCons2_s_amt	(request.getParameter("cons2_s_amt")==null?0:Util.parseDigit(request.getParameter("cons2_s_amt")));
			rf_bean.setCons2_v_amt	(request.getParameter("cons2_v_amt")==null?0:Util.parseDigit(request.getParameter("cons2_v_amt")));
			rf_bean.setFee_etc	(request.getParameter("fee_etc")==null?"":request.getParameter("fee_etc"));
		
			
			if(rf_bean.getRent_tot_amt() > 0){
				if(rf_bean.getRent_s_cd().equals("")){
					rf_bean.setRent_s_cd(s_cd);
					count = rs_db.insertRentFee(rf_bean);
				}else{
					count = rs_db.updateRentFee(rf_bean);
				}
			}
			
			/* 차량반차처리후 청구하는것으로 함.
			String scd_reg_yn 		= request.getParameter("scd_reg_yn")	==null?"":request.getParameter("scd_reg_yn");
			
			ScdRentBean sr_bean = rs_db.getScdRentCase(s_cd, "3", "1");
			
			
			//반차일시로 스케줄 생성
			if(rf_bean.getRent_tot_amt() > 0 && (scd_reg_yn.equals("Y") || !sr_bean.getRent_s_cd().equals("")) ){
								
				
					
				sr_bean.setRent_s_amt	(request.getParameter("rent_tot_s_amt")==null?0:Util.parseDigit(request.getParameter("rent_tot_s_amt")));
				sr_bean.setRent_v_amt	(request.getParameter("rent_tot_v_amt")==null?0:Util.parseDigit(request.getParameter("rent_tot_v_amt")));					
				sr_bean.setEst_dt	(request.getParameter("ret_plan_dt")==null?"":request.getParameter("ret_plan_dt"));
				sr_bean.setDly_days	("");
				sr_bean.setDly_amt	(0);
				sr_bean.setBill_yn	("Y");
				sr_bean.setReg_id	(user_id);					
				sr_bean.setEst_dt	(af_db.getValidDt(sr_bean.getEst_dt()));
					
					
				if(sr_bean.getRent_s_amt()>0){
				
					if(sr_bean.getRent_s_cd().equals("")){
						sr_bean.setRent_s_cd	(s_cd);
						sr_bean.setRent_st	("3");			
						sr_bean.setTm		("1");
						sr_bean.setPaid_st	("4");
						sr_bean.setRest_amt	(0);
						sr_bean.setPay_dt	("");
							
						count = rs_db.insertScdRent(sr_bean);
					}else{
						if(sr_bean.getPay_dt().equals("")){						
							count = rs_db.updateScdRent(sr_bean);	
						}
					}
				}
			}					
			*/
		}		
				
		
	}
	
		
	//메모===========================================================================
	
	String memo_title 	= "";
		
	//차량정보
	Hashtable reserv = rs_db.getCarInfo(c_id);
	
	if(rent_st.equals("1")) 	memo_title += "단기대여-";
	else if(rent_st.equals("2")) 	memo_title += "정비대차-";
	else if(rent_st.equals("3")) 	memo_title += "사고대차-";
	else if(rent_st.equals("9")) 	memo_title += "보험대차-";
	else if(rent_st.equals("10")) 	memo_title += "지연대차-";
	else if(rent_st.equals("4")) 	memo_title += "업무대여-";
	else if(rent_st.equals("5")) 	memo_title += "업무지원-";
	else if(rent_st.equals("6")) 	memo_title += "차량정비-";
	else if(rent_st.equals("7")) 	memo_title += "차량점검-";
	else if(rent_st.equals("8")) 	memo_title += "사고수리-";
	else if(rent_st.equals("11")) 	memo_title += "장기대기-";
	
		
	String c_firm_nm 	= request.getParameter("c_firm_nm")==null?"":request.getParameter("c_firm_nm");
	
	if(deli_dt.equals("")) 	memo_title = "[예약]";
	else				        memo_title = "[배차]";
	
	memo_title += String.valueOf(reserv.get("CAR_NO")) +" "+c_firm_nm+" "+c_cust_nm+" "+AddUtil.getTimeHMS();
						
	boolean flag3 	= true;
			
	
	
%>
<script language='javascript'>
<%	if(count == 1){%>
			alert('정상적으로 처리되었습니다');
			parent.location='/acar/rent_mng/res_rent_u.jsp?s_cd=<%=s_cd%>&c_id=<%=c_id%>&mode=<%=mode%>&auth_rw=<%=auth_rw%>&user_id=<%=user_id%>&br_id=<%=br_id%>&gubun1=<%=gubun1%>&gubun2=<%=gubun2%>&gubun3=<%=gubun3%>&gubun4=<%=gubun4%>&brch_id=<%=brch_id%>&start_dt=<%=start_dt%>&end_dt=<%=end_dt%>&s_kd=<%=s_kd%>&t_wd=<%=t_wd%>&car_comp_id=<%=car_comp_id%>&code=<%=code%>&s_cc=<%=s_cc%>&s_year=<%=s_year%>&asc=<%=asc%>&sort_gubun=<%=sort_gubun%>&list_from_page=<%=list_from_page%>';		
<%	}else{ //에러%>
			alert('처리되지 않았습니다\n\n에러발생!');
<%	}%>
</script>
</body>
</html>
