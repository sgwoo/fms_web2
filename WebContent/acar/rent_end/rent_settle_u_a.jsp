<%@ page language="java" contentType="text/html;charset=euc-kr" %>
<%@ page import="java.util.*, acar.util.*, acar.res_search.*"%>
<jsp:useBean id="rs_db" scope="page" class="acar.res_search.ResSearchDatabase"/>
<jsp:useBean id="ad_db" scope="page" class="acar.admin.AdminDatabase"/>
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
	String mode = request.getParameter("mode")==null?"i":request.getParameter("mode");
	String rent_st = request.getParameter("rent_st")==null?"":request.getParameter("rent_st");
	String use_st = request.getParameter("use_st")==null?"":request.getParameter("use_st");
	String sub_c_id = request.getParameter("sub_c_id")==null?"":request.getParameter("sub_c_id");
	String section = request.getParameter("section")==null?"":request.getParameter("section");
	String upd_mode = request.getParameter("upd_mode")==null?"":request.getParameter("upd_mode");
	int count = 1;
	int count_cust = 0;

	//단기계약정보
	RentContBean rc_bean = rs_db.getRentContCase(s_cd, c_id);	

	//배차/반차
	if(upd_mode.equals("rent_cont")){
		
		rc_bean.setRet_dt	(request.getParameter("h_ret_dt")==null?"":request.getParameter("h_ret_dt"));
		count = rs_db.updateRentCont(rc_bean);
		
		//단기대여정산정보
		RentSettleBean rs_bean = rs_db.getRentSettleCase(s_cd);
		rs_bean.setAdd_hour	(request.getParameter("add_hour")==null?"":request.getParameter("add_hour"));
		rs_bean.setAdd_days	(request.getParameter("add_days")==null?"":request.getParameter("add_days"));
		rs_bean.setAdd_months	(request.getParameter("add_months")==null?"":request.getParameter("add_months"));
		rs_bean.setTot_hour	(request.getParameter("tot_hour")==null?"":request.getParameter("tot_hour"));
		rs_bean.setTot_days	(request.getParameter("tot_days")==null?"":request.getParameter("tot_days"));
		rs_bean.setTot_months	(request.getParameter("tot_months")==null?"":request.getParameter("tot_months"));
		count = rs_db.updateRentSettle(rs_bean);
	//대여요금
	}else if(upd_mode.equals("rent_fee")){
		//단기대여정보
		/*
		RentFeeBean rf_bean = rs_db.getRentFeeCase(s_cd);
		rf_bean.setDriver_yn	(request.getParameter("driver_yn")==null?"":request.getParameter("driver_yn"));
		rf_bean.setTax_yn	(request.getParameter("tax_yn")==null?"":request.getParameter("tax_yn"));
		rf_bean.setIns_yn	(request.getParameter("ins_yn")==null?"":request.getParameter("ins_yn"));
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
		count = rs_db.updateRentFee(rf_bean);
		*/
	}else if(upd_mode.equals("rent_settle")){
		//단기대여정산정보
		RentSettleBean rs_bean = rs_db.getRentSettleCase(s_cd);
		rs_bean.setSett_dt		(request.getParameter("sett_dt")==null?"":request.getParameter("sett_dt"));
		rs_bean.setRun_km		(request.getParameter("run_km")==null?"":request.getParameter("run_km"));				
		rs_bean.setAgree_hour		(request.getParameter("rent_hour")==null?"":request.getParameter("rent_hour"));
		rs_bean.setAgree_days		(request.getParameter("rent_days")==null?"":request.getParameter("rent_days"));
		rs_bean.setAgree_months		(request.getParameter("rent_months")==null?"":request.getParameter("rent_months"));		
		rs_bean.setEtc			(request.getParameter("etc")==null?"":request.getParameter("etc"));
		rs_bean.setAdd_fee_s_amt	(request.getParameter("add_fee_s_amt")==null?0:Util.parseDigit(request.getParameter("add_fee_s_amt")));
		rs_bean.setAdd_fee_v_amt	(request.getParameter("add_fee_v_amt")==null?0:Util.parseDigit(request.getParameter("add_fee_v_amt")));	
		rs_bean.setAdd_ins_s_amt	(request.getParameter("add_ins_s_amt")==null?0:Util.parseDigit(request.getParameter("add_ins_s_amt")));
		rs_bean.setAdd_ins_v_amt	(request.getParameter("add_ins_v_amt")==null?0:Util.parseDigit(request.getParameter("add_ins_v_amt")));	
		rs_bean.setAdd_etc_s_amt	(request.getParameter("add_etc_s_amt")==null?0:Util.parseDigit(request.getParameter("add_etc_s_amt")));
		rs_bean.setAdd_etc_v_amt	(request.getParameter("add_etc_v_amt")==null?0:Util.parseDigit(request.getParameter("add_etc_v_amt")));	
		rs_bean.setIns_m_s_amt		(request.getParameter("ins_m_s_amt")==null?0:Util.parseDigit(request.getParameter("ins_m_s_amt")));
		rs_bean.setIns_m_v_amt		(request.getParameter("ins_m_v_amt")==null?0:Util.parseDigit(request.getParameter("ins_m_v_amt")));	
		rs_bean.setIns_h_s_amt		(request.getParameter("ins_h_s_amt")==null?0:Util.parseDigit(request.getParameter("ins_h_s_amt")));
		rs_bean.setIns_h_v_amt		(request.getParameter("ins_h_v_amt")==null?0:Util.parseDigit(request.getParameter("ins_h_v_amt")));	
		rs_bean.setOil_s_amt		(request.getParameter("oil_s_amt")==null?0:Util.parseDigit(request.getParameter("oil_s_amt")));
		rs_bean.setOil_v_amt		(request.getParameter("oil_v_amt")==null?0:Util.parseDigit(request.getParameter("oil_v_amt")));	
		rs_bean.setRent_tot_amt		(request.getParameter("rent_tot_amt")==null?0:Util.parseDigit(request.getParameter("rent_tot_amt")));
		rs_bean.setDriv_serv_st		(request.getParameter("driv_serv_st")==null?"":request.getParameter("driv_serv_st"));
		rs_bean.setDriv_serv_etc	(request.getParameter("driv_serv_etc")==null?"":request.getParameter("driv_serv_etc"));
		rs_bean.setRent_sett_amt	(request.getParameter("rent_sett_amt")==null?0:Util.parseDigit(request.getParameter("rent_sett_amt")));
		rs_bean.setReg_id		(user_id);	
		rs_bean.setAdd_navi_s_amt	(request.getParameter("add_navi_s_amt")		==null?0:Util.parseDigit(request.getParameter("add_navi_s_amt")));
		rs_bean.setAdd_navi_v_amt	(request.getParameter("add_navi_v_amt")		==null?0:Util.parseDigit(request.getParameter("add_navi_v_amt")));
		rs_bean.setAdd_cons1_s_amt	(request.getParameter("add_cons1_s_amt")	==null?0:Util.parseDigit(request.getParameter("add_cons1_s_amt")));
		rs_bean.setAdd_cons1_v_amt	(request.getParameter("add_cons1_v_amt")	==null?0:Util.parseDigit(request.getParameter("add_cons1_v_amt")));
		rs_bean.setAdd_cons2_s_amt	(request.getParameter("add_cons2_s_amt")	==null?0:Util.parseDigit(request.getParameter("add_cons2_s_amt")));
		rs_bean.setAdd_cons2_v_amt	(request.getParameter("add_cons2_v_amt")	==null?0:Util.parseDigit(request.getParameter("add_cons2_v_amt")));
		rs_bean.setCls_s_amt		(request.getParameter("cls_s_amt")		==null?0:Util.parseDigit(request.getParameter("cls_s_amt")));
		rs_bean.setCls_v_amt		(request.getParameter("cls_v_amt")		==null?0:Util.parseDigit(request.getParameter("cls_v_amt")));	
		rs_bean.setKm_s_amt		(request.getParameter("km_s_amt")		==null?0:Util.parseDigit(request.getParameter("km_s_amt")));
		rs_bean.setKm_v_amt		(request.getParameter("km_v_amt")		==null?0:Util.parseDigit(request.getParameter("km_v_amt")));	
		rs_bean.setAdd_inv_s_amt	(request.getParameter("add_inv_s_amt")		==null?0:Util.parseDigit(request.getParameter("add_inv_s_amt")));
		rs_bean.setAdd_inv_v_amt	(request.getParameter("add_inv_v_amt")		==null?0:Util.parseDigit(request.getParameter("add_inv_v_amt")));	
		rs_bean.setFine_s_amt		(request.getParameter("fine_s_amt")		==null?0:Util.parseDigit(request.getParameter("fine_s_amt")));
		
		count = rs_db.updateRentSettle(rs_bean);
		
		//주행거리 입력점검
		String  d_flag3 =  ad_db.call_sp_dist_etc_ck(c_id, "settle", rs_bean.getRun_km(), rs_bean.getSett_dt(), ck_acar_id);
	}
%>
<script language='javascript'>
<%	if(count == 1){%>
			alert('정상적으로 처리되었습니다');
			parent.location='/acar/rent_end/rent_settle_u.jsp?s_cd=<%=s_cd%>&c_id=<%=c_id%>&mode=<%=mode%>&auth_rw=<%=auth_rw%>&user_id=<%=user_id%>&br_id=<%=br_id%>&gubun1=<%=gubun1%>&gubun2=<%=gubun2%>&gubun3=<%=gubun3%>&gubun4=<%=gubun4%>&brch_id=<%=brch_id%>&start_dt=<%=start_dt%>&end_dt=<%=end_dt%>&s_kd=<%=s_kd%>&t_wd=<%=t_wd%>&car_comp_id=<%=car_comp_id%>&code=<%=code%>&s_cc=<%=s_cc%>&s_year=<%=s_year%>&asc=<%=asc%>&sort_gubun=<%=sort_gubun%>&list_from_page=<%=list_from_page%>';		
<%	}else{ //에러%>
			alert('처리되지 않았습니다\n\n에러발생!');
<%	}%>
</script>
</body>
</html>
