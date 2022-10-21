<%@ page language="java" contentType="text/html;charset=euc-kr" %>
<%@ page import="java.util.*, acar.common.*, acar.util.*"%>
<%@ page import="acar.cont.*, acar.cus_reg.*, acar.secondhand.*, acar.user_mng.*, acar.insur.*, acar.mng_exp.*, acar.memo.*, acar.bill_mng.*"%>
<jsp:useBean id="af_db" scope="page" class="acar.fee.AddFeeDatabase"/>
<jsp:useBean id="shDb"  scope="page" class="acar.secondhand.SecondhandDatabase"/>
<jsp:useBean id="rs_db" scope="page" class="acar.res_search.ResSearchDatabase"/>
<jsp:useBean id="ad_db" scope="page" class="acar.admin.AdminDatabase"/>
<jsp:useBean id="a_db"  scope="page" class="acar.cont.AddContDatabase"/>
<%@ include file="/acar/cookies.jsp" %>

<html>
<head><title>FMS</title>
</head>
<meta http-equiv="Content-Type" content="text/html; charset=euc-kr">
<link rel=stylesheet type="text/css" href="/include/table.css">

<body leftmargin="15">
<%
	String auth_rw = request.getParameter("auth_rw")==null?"":request.getParameter("auth_rw");
	String br_id = request.getParameter("br_id")==null?"":request.getParameter("br_id");
	String user_id = request.getParameter("user_id")==null?"":request.getParameter("user_id");
	
	String work_st 	= request.getParameter("work_st")==null? "":request.getParameter("work_st");
	
	boolean flag = true;
	int result = 0;
	int vt_size = 0 ;
	
	if(work_st.equals("scd_fee_dly_account")){//-----------------------------------------------------------------------------------------------
		
		//연체료 세팅
		flag = af_db.calDelayDtAll();
		
	}else if(work_st.equals("service_reg_error_delete")){//-------------------------------------------------------------------------------------
		
		//미등록 정비 삭제
		CusReg_Database cr_db = CusReg_Database.getInstance();
		
		result = cr_db.deleteServiceNItem();
		
	}else if(work_st.equals("secondhand_res_cancel")){//----------------------------------------------------------------------------------------
		
		//재리스차량 네고정리 - 10일 경과분
		Vector vts = shDb.getSecondhandResCancel(5);
		vt_size = vts.size();
		
		for(int i = 0 ; i < vt_size ; i++){
			Hashtable ht = (Hashtable)vts.elementAt(i);
			
			ShResBean shBn = new ShResBean();
			shBn.setCar_mng_id(String.valueOf(ht.get("CAR_MNG_ID")));
			shBn.setDamdang_id(String.valueOf(ht.get("DAMDANG_ID")));
			shBn.setReg_dt(AddUtil.getDate(4));
			
//			result = shDb.shRes_i(shBn);
		}
	}else if(work_st.equals("insur_period_costs")){//--------------------------------------------------------------------------------------------
		
		//선급보험료 기간비용 처리
		InsDatabase ai_db = InsDatabase.getInstance();
		CommonDataBase c_db = CommonDataBase.getInstance();
		
		Vector vts = ai_db.getInsurPrecostNoRegList();
		vt_size = vts.size();
		
		for(int i = 0 ; i < vt_size ; i++){
			Hashtable ht = (Hashtable)vts.elementAt(i);
			
			String car_mng_id	= String.valueOf(ht.get("CAR_MNG_ID"));
			String cost_id		= String.valueOf(ht.get("INS_ST"));
			String start_dt 	= String.valueOf(ht.get("INS_START_DT"));
			String end_dt		= String.valueOf(ht.get("INS_EXP_DT"));
			String car_use		= String.valueOf(ht.get("CAR_USE"));
			String car_no		= String.valueOf(ht.get("CAR_NO"));
			float tot_amt		= AddUtil.parseFloat(String.valueOf(ht.get("TOT_AMT")));
			float tot_days		= AddUtil.parseFloat(String.valueOf(ht.get("TOT_DAYS")));
			float use_days		= 0.0f;
			float rest_days		= tot_days;
			float use_amt		= 0.0f;
			float rest_amt		= tot_amt;
			int count3			= 0;
			String cost_dt		= "";
			//1회차 시작일
			String f_use_s_dt 	= start_dt;
			//1회차 실종료일
			String f_use_e_dt 	= start_dt.substring(0,6)+""+AddUtil.getMonthDate(AddUtil.parseInt(start_dt.substring(0,4)), AddUtil.parseInt(start_dt.substring(4,6)));
			if(AddUtil.parseInt(start_dt.substring(0,6)) == AddUtil.parseInt(end_dt.substring(0,6))){//1회차만 있을 경우
				f_use_e_dt = end_dt;
			}
			//2회차 실시작일
			String t_use_s_dt 	= AddUtil.replace(c_db.addDay(f_use_e_dt, 1),"-","");
			/*
			out.println("======대여기간=-======="+"<br>");
			out.println("보험기간  : "+ins_start_dt+"~"+ins_exp_dt+"<br>");
			out.println("1회차기간  : "+f_use_s_dt+"~"+f_use_e_dt+"<br>");
			out.println("2회차시작일 : "+t_use_s_dt+"<br>");
			out.println("약정 종료일 : "+ins_exp_dt+"<br><br><br>");
			*/
			for(int j = 0 ; j < 13 ; j++){
				PrecostBean cost = new PrecostBean();
				cost.setCar_mng_id	(car_mng_id);
				cost.setCost_st		("2");//1:자동차세 2:보험료
				cost.setCost_id		(cost_id);
				cost.setCost_tm		(String.valueOf(j+1));
				if(j == 0){//1회차
					cost_dt = f_use_s_dt;
					use_days = AddUtil.parseFloat(rs_db.getDay(cost_dt, f_use_e_dt));//일할금액계산하기
					cost.setCost_ym	(cost_dt.substring(0,6));
				}else{
					if(AddUtil.parseInt(start_dt.substring(0,6)) == AddUtil.parseInt(end_dt.substring(0,6))){//1회차만 있을 경우
						break;
					}
					cost_dt = AddUtil.replace(c_db.addMonth(t_use_s_dt, count3),"-","");
					if(AddUtil.parseInt(cost_dt.substring(0,6)) == AddUtil.parseInt(end_dt.substring(0,6))){//마지막회차
						use_days = rest_days;
					}else if(AddUtil.parseInt(cost_dt.substring(0,6)) <  AddUtil.parseInt(end_dt.substring(0,6))){
						use_days = AddUtil.getMonthDate(AddUtil.parseInt(cost_dt.substring(0,4)), AddUtil.parseInt(cost_dt.substring(4,6)));
					}else{
						break;
					}
					count3++;
				}
				if(AddUtil.parseInt(cost_dt.substring(0,6)) == AddUtil.parseInt(end_dt.substring(0,6))){//마지막회차
					use_amt = rest_amt;
					use_days = rest_days;
				}else{
					if(j == 0){//1회차	
						use_amt = Math.round(tot_amt/tot_days*use_days);
					}else{//중간회차
						use_amt = Math.round(tot_amt/12);
						use_days = 31;
					}
				}
				rest_days -= use_days;
				rest_amt  -= use_amt;
				cost.setCost_ym		(cost_dt.substring(0,6));
				cost.setCost_day	(use_days);
				cost.setCost_amt	(use_amt);
				cost.setRest_day	(rest_days);
				cost.setRest_amt	(rest_amt);
				cost.setUpdate_id	(user_id);
				cost.setCar_use		(car_use);
				cost.setCar_no		(car_no);
				if(j==0){
					cost.setCost_tm2("1");
				}
				
				flag = ai_db.insertPrecost(cost);
				
				if(!flag) result++;
				
			}
		}
	}else if(work_st.equals("insur_period_costs_settle")){//--------------------------------------------------------------------------------------------
		
	}else if(work_st.equals("exp_period_costs")){//--------------------------------------------------------------------------------------------
		
		//선납자동차 기간비용 처리
		InsDatabase ai_db = InsDatabase.getInstance();
		CommonDataBase c_db = CommonDataBase.getInstance();
		
		Vector vts = ai_db.getExpPrecostNoRegList();
		vt_size = vts.size();
		
		for(int i = 0 ; i < vt_size ; i++){
			Hashtable ht = (Hashtable)vts.elementAt(i);
			
			String car_mng_id	= String.valueOf(ht.get("CAR_MNG_ID"));
			String cost_id		= String.valueOf(ht.get("EXP_EST_DT"));
			String start_dt 	= String.valueOf(ht.get("EXP_START_DT"));
			String end_dt		= String.valueOf(ht.get("EXP_END_DT"));
			String car_use		= String.valueOf(ht.get("CAR_USE"));
			String car_no		= String.valueOf(ht.get("CAR_NO"));
			float tot_amt		= AddUtil.parseFloat(String.valueOf(ht.get("TOT_AMT")));
			float tot_days		= AddUtil.parseFloat(String.valueOf(ht.get("TOT_DAYS")));
			float use_days		= 0.0f;
			float rest_days		= tot_days;
			float use_amt		= 0.0f;
			float rest_amt		= tot_amt;
			int count3			= 0;
			String cost_dt		= "";
			//1회차 시작일
			String f_use_s_dt 	= start_dt;
			//1회차 실종료일
			String f_use_e_dt 	= start_dt.substring(0,6)+""+AddUtil.getMonthDate(AddUtil.parseInt(start_dt.substring(0,4)), AddUtil.parseInt(start_dt.substring(4,6)));
			if(AddUtil.parseInt(start_dt.substring(0,6)) == AddUtil.parseInt(end_dt.substring(0,6))){//1회차만 있을 경우
				f_use_e_dt = end_dt;
			}
			//2회차 실시작일
			String t_use_s_dt 	= AddUtil.replace(c_db.addDay(f_use_e_dt, 1),"-","");
			
			for(int j = 0 ; j < 13 ; j++){
				PrecostBean cost = new PrecostBean();
				cost.setCar_mng_id	(car_mng_id);
				cost.setCost_st		("1");//1:자동차세 2:보험료
				cost.setCost_id		(cost_id);
				cost.setCost_tm		(String.valueOf(j+1));
				if(j == 0){//1회차
					cost_dt = f_use_s_dt;
					use_days = AddUtil.parseFloat(rs_db.getDay(cost_dt, f_use_e_dt));//일할금액계산하기
					cost.setCost_ym	(cost_dt.substring(0,6));
				}else{
					if(AddUtil.parseInt(start_dt.substring(0,6)) == AddUtil.parseInt(end_dt.substring(0,6))){//1회차만 있을 경우
						break;
					}
					cost_dt = AddUtil.replace(c_db.addMonth(t_use_s_dt, count3),"-","");
					if(AddUtil.parseInt(cost_dt.substring(0,6)) == AddUtil.parseInt(end_dt.substring(0,6))){//마지막회차
						use_days = rest_days;
					}else if(AddUtil.parseInt(cost_dt.substring(0,6)) <  AddUtil.parseInt(end_dt.substring(0,6))){
						use_days = AddUtil.getMonthDate(AddUtil.parseInt(cost_dt.substring(0,4)), AddUtil.parseInt(cost_dt.substring(4,6)));
					}else{
						break;
					}
					count3++;
				}
				if(AddUtil.parseInt(cost_dt.substring(0,6)) == AddUtil.parseInt(end_dt.substring(0,6))){//마지막회차
					use_amt = rest_amt;
				}else{
					if(j == 0){//1회차
						use_amt = Math.round(tot_amt/tot_days*use_days);
					}else{//중간회차
						use_amt = Math.round(tot_amt/12);
					}	
				}
				rest_days -= use_days;
				rest_amt  -= use_amt;
				cost.setCost_ym		(cost_dt.substring(0,6));
				cost.setCost_day	(use_days);
				cost.setCost_amt	(use_amt);
				cost.setRest_day	(rest_days);
				cost.setRest_amt	(rest_amt);
				cost.setUpdate_id	(user_id);
				cost.setCar_use		(car_use);
				cost.setCar_no		(car_no);
				
				flag = ai_db.insertPrecost(cost);
				
				if(!flag) result++;
			}
		}
	}else if(work_st.equals("exp_period_costs_settle")){//--------------------------------------------------------------------------------------------
		
		//선납자동차 기간비용 처리
		InsDatabase ai_db = InsDatabase.getInstance();
		GenExpDatabase ex_db = GenExpDatabase.getInstance();
		CommonDataBase c_db = CommonDataBase.getInstance();
		
		Vector vts = ai_db.getExpPrecostNoSettleList();
		vt_size = vts.size();
		
		for(int i = 0 ; i < vt_size ; i++){
			Hashtable ht = (Hashtable)vts.elementAt(i);
			
			String car_mng_id	= String.valueOf(ht.get("CAR_MNG_ID"));
			String est_dt		= String.valueOf(ht.get("EXP_EST_DT"));
			
			GenExpBean exp = ex_db.getGenExp(car_mng_id, "3", est_dt);
			
			//기간비용정산
			flag = ai_db.settleExpPrecost(exp);
		}
		
	}else if(work_st.equals("automemo_15day_delete")){//-------------------------------------------------------------------------------------
		
		//메모삭제
		Memo_Database memo_db = Memo_Database.getInstance();
		
		flag = memo_db.deleteAutoMemos("15");
		
	}else if(work_st.equals("bus_agnt_id_null_insert")){//-------------------------------------------------------------------------------------
		
		Vector vts = ad_db.getBusAgntIdFeeEtcNullList();
		vt_size = vts.size();
		
		for(int i = 0 ; i < vt_size ; i++){
			Hashtable ht = (Hashtable)vts.elementAt(i);
			
			String rent_mng_id	= String.valueOf(ht.get("RENT_MNG_ID"));
			String rent_l_cd	= String.valueOf(ht.get("RENT_L_CD"));
			String rent_st		= "1";
			String bus_agnt_id	= String.valueOf(ht.get("BUS_AGNT_ID"));
			
			ContCarBean fee_etc = a_db.getContFeeEtc(rent_mng_id, rent_l_cd, "1");
			fee_etc.setBus_agnt_id(bus_agnt_id);
			if(fee_etc.getRent_mng_id().equals("")){
				fee_etc.setRent_mng_id	(rent_mng_id);
				fee_etc.setRent_l_cd	(rent_l_cd);
				fee_etc.setRent_st		("1");
				//=====[fee_etc] insert=====
				flag = a_db.insertFeeEtc(fee_etc);
			}else{
				//=====[fee_etc] update=====
				flag = a_db.updateFeeEtc(fee_etc);
			}
		}
	}else if(work_st.equals("bus_agnt_per_null_insert")){//-------------------------------------------------------------------------------------
		
		Vector vts = ad_db.getBusAgntPerFeeEtcNullList();
		vt_size = vts.size();
		
		for(int i = 0 ; i < vt_size ; i++){
			Hashtable ht = (Hashtable)vts.elementAt(i);
			
			String rent_mng_id	= String.valueOf(ht.get("RENT_MNG_ID"));
			String rent_l_cd	= String.valueOf(ht.get("RENT_L_CD"));
			String rent_st		= String.valueOf(ht.get("RENT_ST"));
			
			ContCarBean fee_etc = a_db.getContFeeEtc(rent_mng_id, rent_l_cd, rent_st);
			fee_etc.setBus_agnt_per		(20);
			fee_etc.setBus_agnt_r_per	(20);
			flag = a_db.updateFeeEtc(fee_etc);
		}
	}else if(work_st.equals("user_neom_vencode_reg")){//-------------------------------------------------------------------------------------
		
		NeoErpUDatabase neoe_db = NeoErpUDatabase.getInstance();		
		UserMngDatabase umd = UserMngDatabase.getInstance();
		
		Vector vts = ad_db.getUserVenCodeNonRegList();
		vt_size = vts.size();
		
		for(int i = 0 ; i < vt_size ; i++){
			Hashtable ht = (Hashtable)vts.elementAt(i);
			
			String user_nm		= String.valueOf(ht.get("USER_NM"));
			String user_ssn		= String.valueOf(ht.get("USER_SSN"));
			String zip		= String.valueOf(ht.get("ZIP"));
			String addr		= String.valueOf(ht.get("ADDR"));
			
			String ven_code = "";
			ven_code = neoe_db.getVenCode2(user_ssn, user_ssn);
			
			if(ven_code.equals("")){
				
				//네오엠 거래처 처리-------------------------------
				
				TradeBean t_bean = new TradeBean();
								
				t_bean.setCust_name	(user_nm);
				t_bean.setS_idno	("8888888888");
				t_bean.setId_no		(user_ssn);
				t_bean.setDname		(user_nm);
				t_bean.setMail_no	(zip);
				t_bean.setS_address	(addr);
				
				flag = neoe_db.insertTrade(t_bean);	//-> neoe_db 변환
				
				String cust_code = neoe_db.getVenCode2(user_ssn, user_ssn);
				
				
				//사용자 수정-------------------------------
				
				UsersBean user_bean = umd.getUsersBean(String.valueOf(ht.get("USER_ID")));
				user_bean.setVen_code(cust_code);
				result = umd.updateUser(user_bean);
			}
		}
	}else if(work_st.equals("user_neom_vencode_update")){//-------------------------------------------------------------------------------------
		
		NeoErpUDatabase neoe_db = NeoErpUDatabase.getInstance();		
		UserMngDatabase umd = UserMngDatabase.getInstance();
		
		Vector vts = ad_db.getUserVenCodeRegList();
		vt_size = vts.size();
		
		for(int i = 0 ; i < vt_size ; i++){
			Hashtable ht = (Hashtable)vts.elementAt(i);
			
			String cust_code = String.valueOf(ht.get("VEN_CODE"));
			String user_nm	 = String.valueOf(ht.get("USER_NM"));
			String user_ssn	 = String.valueOf(ht.get("USER_SSN"));
			String zip	 = String.valueOf(ht.get("ZIP"));
			String addr	 = String.valueOf(ht.get("ADDR"));
			
//			String ven_code = "";
			
//			if(ven_code.equals(cust_code)){
				
				//네오엠 거래처 처리-------------------------------
				
				TradeBean t_bean = new TradeBean();
				
				t_bean.setCust_code	(cust_code);
				t_bean.setCust_name	(user_nm);
				t_bean.setId_no		(user_ssn);
				t_bean.setDname		(user_nm);
				t_bean.setMail_no	(zip);
				t_bean.setS_address	(addr);
				t_bean.setDc_rmk	("아마존카사원");
				t_bean.setMd_gubun	("Y");
				
				flag = neoe_db.updateTrade(t_bean);	//-> neoe_db 변환
				
//			}
		}
	}else if(work_st.equals("fee_etc_base_dt_update")){//-------------------------------------------------------------------------------------
		
	//	NeoErpUDatabase neoe_db = NeoErpUDatabase.getInstance();		
		UserMngDatabase umd = UserMngDatabase.getInstance();
		
		Vector vts = af_db.getFeeEtcBaseDtUpdateList();
		vt_size = vts.size();
		
		for(int i = 0 ; i < vt_size ; i++){
			Hashtable ht = (Hashtable)vts.elementAt(i);
			
			String rent_mng_id 		= String.valueOf(ht.get("RENT_MNG_ID"));
			String rent_l_cd	 	= String.valueOf(ht.get("RENT_L_CD"));
			String rent_st	 		= String.valueOf(ht.get("RENT_ST"));
			String rent_start_dt	= String.valueOf(ht.get("RENT_START_DT"));
			
			ContCarBean fee_etc = a_db.getContFeeEtc(rent_mng_id, rent_l_cd, rent_st);
			fee_etc.setSh_day_bas_dt	(rent_start_dt);
			flag = a_db.updateFeeEtc(fee_etc);
		}
	}else if(work_st.equals("tax_item_list_rent_st_update")){//-------------------------------------------------------------------------------------
		
		af_db.getTaxItemListScdFeeRentstUpdate();
	}
%>
<script language='javascript'>
<%	if(work_st.equals("scd_fee_dly_account") && !flag){  %>
		alert("처리되지 않았습니다");
<%	}else if(work_st.equals("service_reg_error_delete") && result > 0){  %>
		alert("처리되지 않았습니다");
<%	}else if(work_st.equals("secondhand_res_cancel") && vt_size>0 && result == 0){  %>
		alert("처리되지 않았습니다");
<%	}else if(work_st.equals("insur_period_costs") && result > 0){  %>
		alert("<%=result%>건이 처리되지 않았습니다");
<%	}else if(work_st.equals("exp_period_costs") && result > 0){  %>
		alert("<%=result%>건이 처리되지 않았습니다");
<%	}else if(work_st.equals("insur_period_costs_settle") && !flag){  %>
		alert("처리되지 않았습니다");
<%	}else if(work_st.equals("exp_period_costs_settle") && !flag){  %>
		alert("처리되지 않았습니다");
<%	}else if(work_st.equals("automemo_15day_delete") && !flag){  %>
		alert("처리되지 않았습니다");
<%	}else if(work_st.equals("bus_agnt_id_null_insert") && !flag){  %>
		alert("처리되지 않았습니다");
<%	}else if(work_st.equals("user_neom_vencode_reg") && !flag){  %>
		alert("처리되지 않았습니다");
<%	}else if(work_st.equals("fee_etc_base_dt_update") && !flag){  %>
		alert("처리되지 않았습니다");
<%	}else{		%>
		alert("처리되었습니다");
		parent.location.reload();
<%	}			%>
</script>