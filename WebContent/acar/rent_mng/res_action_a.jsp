<%@ page language="java" contentType="text/html;charset=euc-kr" %>
<%@ page import="java.util.*, acar.util.*, acar.res_search.*,acar.memo.*, acar.secondhand.*, acar.fee.*"%>
<%@ page import="acar.coolmsg.*, acar.user_mng.*, acar.car_sche.*, acar.common.*, acar.cont.*,acar.client.*, acar.car_mst.*"%>
<jsp:useBean id="rs_db" scope="page" class="acar.res_search.ResSearchDatabase"/>
<jsp:useBean id="cm_db" scope="page" class="acar.coolmsg.CoolMsgDatabase"/>
<jsp:useBean id="shDb" 		class="acar.secondhand.SecondhandDatabase" 	scope="page"/>
<jsp:useBean id="af_db" scope="page" class="acar.fee.AddFeeDatabase"/>
<jsp:useBean id="pk_db" scope="page" class="acar.parking.ParkIODatabase"/>
<jsp:useBean id="ai_db" scope="page" class="acar.con_ins.AddInsurDatabase"/>
<jsp:useBean id="ins" class="acar.con_ins.InsurBean" scope="page"/>
<jsp:useBean id="a_db" scope="page" class="acar.cont.AddContDatabase"/>
<jsp:useBean id="al_db"     class="acar.client.AddClientDatabase"      scope="page"/>
<jsp:useBean id="ec_db" scope="page" class="acar.cont.EtcContDatabase"/>	
<jsp:useBean id="cm_bean" class="acar.car_mst.CarMstBean" scope="page"/>
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
	String auth_rw = request.getParameter("auth_rw")==null?"":request.getParameter("auth_rw");
	String user_id = request.getParameter("user_id")==null?"":request.getParameter("user_id");
	String br_id = request.getParameter("br_id")==null?"":request.getParameter("br_id");
	String gubun1 = request.getParameter("gubun1")==null?"3":request.getParameter("gubun1");
	String gubun2 = request.getParameter("gubun2")==null?"":request.getParameter("gubun2");
	String brch_id = request.getParameter("brch_id")==null?"":request.getParameter("brch_id");
	String start_dt = request.getParameter("start_dt")==null?"":request.getParameter("start_dt");
	String end_dt = request.getParameter("end_dt")==null?"":request.getParameter("end_dt");		
	String car_comp_id = request.getParameter("car_comp_id")==null?"":request.getParameter("car_comp_id");
	String code = request.getParameter("code")==null?"":request.getParameter("code");	
	String s_cc = request.getParameter("s_cc")==null?"":request.getParameter("s_cc");
	String s_year = request.getParameter("s_year")==null?"":request.getParameter("s_year");
	String s_kd = request.getParameter("s_kd")==null?"":request.getParameter("s_kd");
	String t_wd = request.getParameter("t_wd")==null?"":request.getParameter("t_wd");
	String sort_gubun = request.getParameter("sort_gubun")==null?"":request.getParameter("sort_gubun");
	String asc = request.getParameter("asc")==null?"asc":request.getParameter("asc");
	
	String s_cd = request.getParameter("s_cd")==null?"":request.getParameter("s_cd");
	String c_id = request.getParameter("c_id")==null?"":request.getParameter("c_id");
	String mode = request.getParameter("mode")==null?"":request.getParameter("mode");
	String f_page = request.getParameter("f_page")==null?"":request.getParameter("f_page");
	String end_est_yn 	= request.getParameter("end_est_yn")	==null?"":request.getParameter("end_est_yn");
	String ment = request.getParameter("ment")==null?"":request.getParameter("ment");
	String car_no 		= request.getParameter("car_no")==null?"":request.getParameter("car_no");

	boolean flag3 = true;
	boolean flag4 = true;
	int count = 1;
	int count_cust = 0;
	int count2 = 0;
	String cms_reg_msg = "";
	String cms_cls_msg = "";
	
	MaMenuDatabase nm_db = MaMenuDatabase.getInstance();
	UserMngDatabase umd = UserMngDatabase.getInstance();
	CommonDataBase c_db = CommonDataBase.getInstance();
	CarSchDatabase csd = CarSchDatabase.getInstance();
	AddCarMstDatabase 	cmb 	= AddCarMstDatabase.getInstance();
	
	//단기대여관리 수정
	RentContBean rc_bean = rs_db.getRentContCase(s_cd, c_id);
	
	//단기대여 대여정보 등록
	RentFeeBean rf_bean = rs_db.getRentFeeCase(s_cd);
	
	//차량정보
	Hashtable reserv = rs_db.getCarInfo(c_id);


	//반차처리
	if(mode.equals("R")){
		//계약정보
		String ret_dt = request.getParameter("h_ret_dt")==null?"":AddUtil.replace(request.getParameter("h_ret_dt"),"-","");
		String ret_loc = request.getParameter("ret_loc")==null?"":request.getParameter("ret_loc");
		String ret_mng_id = request.getParameter("ret_mng_id")==null?"":request.getParameter("ret_mng_id");
		String serv_id = request.getParameter("serv_id")==null?"":request.getParameter("serv_id");
		String accid_id = request.getParameter("accid_id")==null?"":request.getParameter("accid_id");
		
		//단기대여관리 수정
		if(rc_bean.getRet_plan_dt().equals("")){
			rc_bean.setRet_plan_dt2(ret_dt);
		}
		if(rc_bean.getRent_end_dt().equals("")){
			rc_bean.setRent_end_dt2(ret_dt);
			rc_bean.setRent_hour(request.getParameter("rent_hour")==null?"":request.getParameter("rent_hour"));
			rc_bean.setRent_days(request.getParameter("rent_days")==null?"":request.getParameter("rent_days"));
			rc_bean.setRent_months(request.getParameter("rent_months")==null?"":request.getParameter("rent_months"));
		}
		rc_bean.setRet_dt2(ret_dt);
		rc_bean.setRet_loc(ret_loc);
		rc_bean.setRet_mng_id(ret_mng_id);
		rc_bean.setReg_id(user_id);
		if(rc_bean.getRent_st().equals("1") || rc_bean.getRent_st().equals("9")){
			rc_bean.setUse_st("3");
		}else{
			rc_bean.setUse_st("4");
		}
		//기본식 정비대차는 정차절차를 거친다.
		if(!String.valueOf(reserv.get("CAR_ST")).equals("5") && rc_bean.getRent_st().equals("2") && rf_bean.getFee_s_amt()>0){
			rc_bean.setUse_st("3");
		}
		if(rc_bean.getRent_end_dt().equals("")){
			rc_bean.setRent_end_dt(ret_dt);
		}
		if(!ment.equals("")){
			rc_bean.setServ_id(serv_id);
			rc_bean.setAccid_id(accid_id);
		}		
		if(rc_bean.getRent_st().equals("10") && rc_bean.getSub_l_cd().equals("")){
			rc_bean.setSub_l_cd(request.getParameter("sub_l_cd")==null?"":request.getParameter("sub_l_cd"));
		}
		
		count = rs_db.updateRentCont(rc_bean);
		
		//운행일지 수정
		String rent_st = rc_bean.getRent_st();
		String rent_start_dt = rc_bean.getRent_start_dt_d();
		String rent_end_dt = rc_bean.getRent_end_dt_d();
		String use_max_dt = rs_db.getMaxData(s_cd, c_id, "dt");
		String ret_time = rc_bean.getRet_dt_h();
		int use_days = 0;
		
		if(AddUtil.parseInt(use_max_dt) > AddUtil.parseInt(rc_bean.getRet_dt_d())){//기간미만->일지삭제
			count = rs_db.deleteScdCar(s_cd, c_id, rc_bean.getRet_dt_d());
		}else if(AddUtil.parseInt(use_max_dt) < AddUtil.parseInt(rc_bean.getRet_dt_d())){//기간초과->일지추가생성
			//운행일수
			use_days = AddUtil.parseInt(rs_db.getDay(use_max_dt, rc_bean.getRet_dt_d()));
			//마지막회차
			int max_tm = AddUtil.parseInt(rs_db.getMaxData(s_cd, c_id, "tm"));
			for(int i=0; i<use_days; i++){
				ScdCarBean sc_bean = new ScdCarBean();
				sc_bean.setCar_mng_id(c_id);
				sc_bean.setRent_s_cd(s_cd);
				sc_bean.setTm(max_tm+i+1);
				sc_bean.setDt(rs_db.addDay(use_max_dt, i));
				if(i > 0 && i==use_days-1){//대여종료 예정일
					sc_bean.setTime(ret_time);
					sc_bean.setUse_st("2");
				}else{//대여기간
					sc_bean.setTime("");
					sc_bean.setUse_st("1");
				}
				sc_bean.setReg_id(user_id);
				count = rs_db.insertScdCar(sc_bean);
			}
		}
		
		//단기대여가 아닐경우 정산처리까지
		if(rc_bean.getUse_st().equals("4")){
			if(!rc_bean.getRent_st().equals("1") && !rc_bean.getRent_st().equals("9")){
				//단기대여 정산 등록
				RentSettleBean rs_bean = rs_db.getRentSettleCase(s_cd);				
				rs_bean.setRent_s_cd(s_cd);
				rs_bean.setSett_dt(rc_bean.getRet_dt_d());
				rs_bean.setRun_km(request.getParameter("run_km")==null?"":AddUtil.parseDigit3(request.getParameter("run_km")));
				rs_bean.setAgree_hour(request.getParameter("rent_hour")==null?"":request.getParameter("rent_hour"));
				rs_bean.setAgree_days(request.getParameter("rent_days")==null?"":request.getParameter("rent_days"));
				rs_bean.setAgree_months(request.getParameter("rent_months")==null?"":request.getParameter("rent_months"));
				rs_bean.setAdd_hour(request.getParameter("add_hour")==null?"":request.getParameter("add_hour"));
				rs_bean.setAdd_days(request.getParameter("add_days")==null?"":request.getParameter("add_days"));
				rs_bean.setAdd_months(request.getParameter("add_months")==null?"":request.getParameter("add_months"));
				rs_bean.setTot_hour(request.getParameter("tot_hour")==null?"":request.getParameter("tot_hour"));
				rs_bean.setTot_days(request.getParameter("tot_days")==null?"":request.getParameter("tot_days"));
				rs_bean.setTot_months(request.getParameter("tot_months")==null?"":request.getParameter("tot_months"));
				rs_bean.setEtc(request.getParameter("etc")==null?"":request.getParameter("etc"));
				rs_bean.setRent_sett_amt(0);
				rs_bean.setReg_id(user_id);
				
				if(rs_bean.getRent_s_cd().equals("")){
					rs_bean.setRent_s_cd		(s_cd);
					count = rs_db.insertRentSettle(rs_bean);
				}else{
					count = rs_db.updateRentSettle(rs_bean);
				}
				
				
				//주행거리 입력점검
				String  d_flag3 =  ad_db.call_sp_dist_etc_ck(c_id, "ret", rs_bean.getRun_km(), rs_bean.getSett_dt(), ck_acar_id);
			}
		}
		
		//반차처리시 차량의 현위치를 반차위치로 수정
		String park = request.getParameter("park")==null?"":request.getParameter("park");
		String park_cont = request.getParameter("park_cont")==null?"":request.getParameter("park_cont");
	
		count = rs_db.updateCarPark(c_id, park, park_cont);
		
		//주차장현황 - 입출고 데이터 삭제
		if(park.equals("1") || park.equals("17") || park.equals("7") || park.equals("8")|| park.equals("4") || park.equals("9")  || park.equals("13") || park.equals("12")){
			Hashtable ht2 = pk_db.getRentParkIOSearch2(c_id);
			count2 = pk_db.UpdateParkIO(String.valueOf(ht2.get("CAR_MNG_ID")));	
		}
		
		//반차알림메시지발송
		String  d_flag4 =  rs_db.call_sp_res_ret_msg("반차처리", s_cd);
	
	} //반차처리 끝
	
	
	//자산양수차량 처리
	else if(mode.equals("J")){
		
		//계약정보
		String ret_plan_dt = request.getParameter("ret_plan_dt")==null?"":AddUtil.replace(request.getParameter("ret_plan_dt"),"-","");
		String ret_plan_dt_h = request.getParameter("ret_plan_dt_h")==null?"":AddUtil.replace(request.getParameter("ret_plan_dt_h"),"-","");
		String ret_plan_dt_s = request.getParameter("ret_plan_dt_s")==null?"":AddUtil.replace(request.getParameter("ret_plan_dt_s"),"-","");
		
		rc_bean.setRet_plan_dt(ret_plan_dt+""+ret_plan_dt_h+""+ret_plan_dt_s);
		rc_bean.setReg_id			(user_id);
		rc_bean.setBus_id			(user_id);
		
		count = rs_db.updateRentCont(rc_bean);
		
		//반차처리시 차량의 현위치를 반차위치로 수정
		String park = request.getParameter("park")==null?"":request.getParameter("park");
		String park_cont = request.getParameter("park_cont")==null?"":request.getParameter("park_cont");
	
		count = rs_db.updateCarPark(c_id, park, park_cont);
		
	} //자산양수차량 끝
	
	
	//배차취소  예약으로
	else if(mode.equals("BEFORE")){
		
		rc_bean.setDeli_dt	("");
		rc_bean.setUse_st	("1");
		
		count = rs_db.updateRentCont(rc_bean);
				
	} //배차취소  예약으로 끝


	//기간 연장
	else if(mode.equals("A")){
		//계약정보
		String add_dt = request.getParameter("add_dt")==null?"":AddUtil.replace(request.getParameter("add_dt"),"-","");
		
		//단기대여관리 수정 : 기간연장으로 인한 반차예정일자 수정
		rc_bean.setRet_plan_dt2(add_dt+"0000");
		rc_bean.setReg_id(user_id);
		count = rs_db.updateRentCont(rc_bean);
		
		//운행일지 수정
		String rent_st = rc_bean.getRent_st();
		String rent_start_dt = rc_bean.getRent_start_dt_d();
		String rent_end_dt = rc_bean.getRent_end_dt_d();
		String use_max_dt = rs_db.getMaxData(s_cd, c_id, "dt");
		String ret_time = rc_bean.getRet_dt_h();
		int use_days = 0;
		
		//운행일수
		use_days = AddUtil.parseInt(rs_db.getDay(use_max_dt, add_dt));
		//마지막회차
		int max_tm = AddUtil.parseInt(rs_db.getMaxData(s_cd, c_id, "tm"));
		for(int i=0; i<use_days; i++){
			ScdCarBean sc_bean = new ScdCarBean();
			sc_bean.setCar_mng_id(c_id);
			sc_bean.setRent_s_cd(s_cd);
			sc_bean.setTm(max_tm+i+1);
			sc_bean.setDt(rs_db.addDay(use_max_dt, i));
			if(i > 0 && i==use_days-1){//대여종료 예정일
				sc_bean.setTime(ret_time);
				sc_bean.setUse_st("2");
			}else{//대여기간
				sc_bean.setTime("");
				sc_bean.setUse_st("1");
			}
			sc_bean.setReg_id(user_id);
			count = rs_db.insertScdCar(sc_bean);
		}

	} //기간 연장 끝
	
	//배차후 취소
	else if(mode.equals("N")){
		//단기대여관리 수정 : 배차후취소로 대여상태 수정
		rc_bean.setUse_st("5");
		rc_bean.setDeli_dt2("");
		rc_bean.setReg_id(user_id);
		count = rs_db.updateRentCont(rc_bean);
		
		//운행스케줄 삭제
		count = rs_db.deleteScdCar(s_cd, c_id, "");

		String park = "1"; //본사주차장
		if(rc_bean.getBrch_id().equals("B1"))	park = "3";  //부산지점
		if(rc_bean.getBrch_id().equals("D1"))	park = "4"; //대전지점
		if(rc_bean.getBrch_id().equals("J1"))	park = "12"; //광주지점
		if(rc_bean.getBrch_id().equals("G1"))	park = "13"; //대구지점
		
		Hashtable ht2 = pk_db.getRentParkIOSearch2(c_id);
		count2 = pk_db.UpdateParkIO(String.valueOf(ht2.get("CAR_MNG_ID")));

	} //배차후 취소 끝
	
	
	//메모===========================================================================
	String memo_title 	= "";
	
	String c_firm_nm 	= request.getParameter("c_firm_nm")==null?"":request.getParameter("c_firm_nm");
	String c_cust_nm 	= request.getParameter("c_cust_nm")==null?"":request.getParameter("c_cust_nm");
	String rent_st2		= rc_bean.getRent_st();
	
	if(mode.equals("R"))		memo_title = "[반차]";
	else if(mode.equals("A"))	memo_title = "[연장]";
	else if(mode.equals("N"))	memo_title = "[취소]";
	
	if(rent_st2.equals("1")) 	memo_title += "단기대여-";
	else if(rent_st2.equals("2")) 	memo_title += "정비대차-";
	else if(rent_st2.equals("3")) 	memo_title += "사고대차-";
	else if(rent_st2.equals("9")) 	memo_title += "보험대차-";
	else if(rent_st2.equals("10")) 	memo_title += "지연대차-";
	else if(rent_st2.equals("4")) 	memo_title += "업무대여-";
	else if(rent_st2.equals("5")) 	memo_title += "업무지원-";
	else if(rent_st2.equals("6")) 	memo_title += "차량정비-";
	else if(rent_st2.equals("7")) 	memo_title += "차량점검-";
	else if(rent_st2.equals("8")) 	memo_title += "사고수리-";
	else if(rent_st2.equals("11")) 	memo_title += "장기대기-";
	
	
	memo_title += car_no+" "+c_firm_nm+" "+c_cust_nm;
	
	
	
	
	//2. 쿨메신저 메세지 전송------------------------------------------------------------------------------------------
		
	String sub 		= "보유차 처리 통보";
	String cont 	= memo_title;
	String target_id = nm_db.getWorkAuthUser("보유차관리");
		
	CarScheBean cs_bean = csd.getCarScheTodayBean(target_id);
	if(!cs_bean.getUser_id().equals("") && !cs_bean.getWork_id().equals("")) 	target_id = cs_bean.getWork_id();
	if(!cs_bean.getUser_id().equals("") && cs_bean.getWork_id().equals("")) 	target_id = nm_db.getWorkAuthUser("본사관리팀장");
		
	//사용자 정보 조회
	UsersBean target_bean 	= umd.getUsersBean(target_id);
	UsersBean sender_bean 	= umd.getUsersBean(user_id);
		
	//배차처리일때 재리스 계약확정이 있다면 통보한다.
		
	//예약상태
	ShResBean srBn = shDb.getShRes2(c_id);
		
	if(!mode.equals("BEFORE") && !mode.equals("N_REQ") && !srBn.getSituation().equals("")){
			
		String memo_title2 = "";
		if(mode.equals("R"))			memo_title2 = "반차";
		else if(mode.equals("A"))		memo_title2 = "연장";
		else if(mode.equals("N"))		memo_title2 = "취소";
			
		sub 	= "재리스계약확정차량의 보유차 "+memo_title2+" 통보";
		cont 	= memo_title+" -- 재리스 예약상태에서 변경("+memo_title2+")되었으니 확인하시기 바랍니다.";
			
		UsersBean target_bean2 	= umd.getUsersBean(srBn.getDamdang_id());
			
		String xml_data2 = "";
		xml_data2 =  "<COOLMSG>"+
	  					 "<ALERTMSG>"+
  						 "    <BACKIMG>4</BACKIMG>"+
  						 "    <MSGTYPE>104</MSGTYPE>"+
  						 "    <SUB>"+sub+"</SUB>"+
	  					 "    <CONT>"+cont+"</CONT>"+
 						 "    <URL></URL>";
		xml_data2 += "    <TARGET>"+target_bean2.getId()+"</TARGET>";
		xml_data2 += "    <SENDER>"+sender_bean.getId()+"</SENDER>"+
  						 "    <MSGICON>10</MSGICON>"+
  						 "    <MSGSAVE>1</MSGSAVE>"+
  						 "    <LEAVEDMSG>1</LEAVEDMSG>"+
	  					 "    <FLDTYPE>1</FLDTYPE>"+
  						 "  </ALERTMSG>"+
  						 "</COOLMSG>";
			
		CdAlertBean msg2 = new CdAlertBean();
		msg2.setFlddata(xml_data2);
		msg2.setFldtype("1");
			
		flag3 = cm_db.insertCoolMsg(msg2);
	}
		
	//배차처리한 차량의 보험이 26세이하 연령 보험담당자에게 통보
	if(mode.equals("R")){
		//보험정보
		String ins_st = ai_db.getInsSt(c_id);
		ins = ai_db.getIns(c_id, ins_st);

		if(ins.getAge_scp().equals("1") || ins.getAge_scp().equals("4")){
		
			String sub3 	= "26세이하 연령인 보유차 반차 통보";
			String cont3 	= "26세이하 연령인 보유차("+memo_title+")가 반차되었으니 확인하시기 바랍니다.";
			
			//보험변경요청 프로시저 호출
			String  d_flag2 =  ec_db.call_sp_ins_cng_req(sub3, s_cd, c_id, "");
						
			UsersBean target_bean3 	= umd.getUsersBean(nm_db.getWorkAuthUser("대전보험담당"));
			
			String xml_data3 = "";
			xml_data3 =  "<COOLMSG>"+
	  					 "<ALERTMSG>"+
  						 "    <BACKIMG>4</BACKIMG>"+
  						 "    <MSGTYPE>104</MSGTYPE>"+
  						 "    <SUB>"+sub3+"</SUB>"+
	  					 "    <CONT>"+cont3+"</CONT>"+
 						 "    <URL></URL>";
			xml_data3 += "    <TARGET>"+target_bean3.getId()+"</TARGET>";
			xml_data3 += "    <SENDER>"+sender_bean.getId()+"</SENDER>"+
  						 "    <MSGICON>10</MSGICON>"+
  						 "    <MSGSAVE>1</MSGSAVE>"+
  						 "    <LEAVEDMSG>1</LEAVEDMSG>"+
	  					 "    <FLDTYPE>1</FLDTYPE>"+
  						 "  </ALERTMSG>"+
  						 "</COOLMSG>";
			
			CdAlertBean msg3 = new CdAlertBean();
			msg3.setFlddata(xml_data3);
			msg3.setFldtype("1");
			
			//현재 장기대여 계약이 있다면 안보낸다.	
			Hashtable ht_cont = a_db.getContViewUseYCarCase(c_id);
			
			//계약기본정보
			ContBaseBean base = a_db.getCont(String.valueOf(ht_cont.get("RENT_MNG_ID")), String.valueOf(ht_cont.get("RENT_L_CD")));
		 	
		 	if(String.valueOf(ht_cont.get("CAR_ST")).equals("1") || String.valueOf(ht_cont.get("CAR_ST")).equals("3")){
		 		if(ins.getAge_scp().equals("1") && base.getDriving_age().equals("1")){
					System.out.println("쿨메신저(26세이하 연령 보유차 반차 처리 :: 장기계약 연령과 같아 미통보)-----------------------"+cont3);
	 		
	 			}else if(ins.getAge_scp().equals("4") && base.getDriving_age().equals("3")){
					System.out.println("쿨메신저(26세이하 연령 보유차 반차 처리 :: 장기계약 연령과 같아 미통보)-----------------------"+cont3);		 		
		 		}else{
					flag4 = cm_db.insertCoolMsg(msg3);
					System.out.println("쿨메신저(26세이하 연령 보유차 반차 처리 통보)-----------------------"+cont3);
	 			}
		 		
		 	}else{
				//flag4 = cm_db.insertCoolMsg(msg3);
				System.out.println("쿨메신저(26세이하 연령 보유차 반차 처리 통보-보험변경요청)-----------------------"+cont3);				 	
	 		}
					
		}
		
		//보험변경요청 프로시저 호출
		//출고지연대차 법인 임직원전용대상차량 반차
		if(rc_bean.getRent_st().equals("10")){
		
			//고객정보
			ClientBean client = al_db.getNewClient(rc_bean.getCust_id());
				
			//자동차기본정보
			cm_bean = cmb.getCarNmCase(String.valueOf(reserv.get("CAR_ID")), String.valueOf(reserv.get("CAR_SEQ")));	
						
			//장기계약 연동
			if(!rc_bean.getSub_l_cd().equals("")){
				
				Hashtable cont_ht = a_db.getContViewCase("", rc_bean.getSub_l_cd());
				
				ContEtcBean cont_etc = a_db.getContEtc(String.valueOf(cont_ht.get("RENT_MNG_ID")), String.valueOf(cont_ht.get("RENT_L_CD")));
		
				//출고지연대차 법인/개인사업자 임직원전용대상차량 배차2
				if(rc_bean.getCom_emp_yn().equals("Y") && cont_etc.getCom_emp_yn().equals("Y") && !client.getClient_st().equals("2") && AddUtil.parseInt(cm_bean.getS_st())>101 && AddUtil.parseInt(cm_bean.getS_st()) < 600 && AddUtil.parseInt(cm_bean.getS_st()) != 409){
					String  d_flag2 =  ec_db.call_sp_ins_cng_req("지연대차 반차 통보", s_cd, c_id, "");
				}
			//장기계약 미연동
			}else{
				//출고지연대차 법인 임직원전용대상차량 배차
				if(client.getClient_st().equals("1") && AddUtil.parseInt(cm_bean.getS_st())>101 && AddUtil.parseInt(cm_bean.getS_st()) < 600 && AddUtil.parseInt(cm_bean.getS_st()) != 409){
					String  d_flag2 =  ec_db.call_sp_ins_cng_req("지연대차 반차 통보", s_cd, c_id, "");
				}
			}
		}
				
	}
	
	
	//취소요청
	if(mode.equals("N_REQ")){
		
		String sub4 	= "반차대기차량 취소요청";
		String cont4 	= "반차대기차량 취소요청합니다. "+memo_title+" ";
		String url4	= "/acar/rent_mng/rent_mn_frame_s.jsp";
					
		UsersBean target_bean4 	= umd.getUsersBean(nm_db.getWorkAuthUser("본사관리팀장"));
		
		CarScheBean cs_bean4 = csd.getCarScheTodayBean(target_bean4.getUser_id());
		if(!cs_bean4.getUser_id().equals("") && !cs_bean4.getWork_id().equals("")){
			String target_id4 = cs_bean4.getWork_id();
			target_bean4 	= umd.getUsersBean(target_id4);
		}
		
		String xml_data4 = "";
		xml_data4 =  "<COOLMSG>"+
  					 "<ALERTMSG>"+
						 "    <BACKIMG>4</BACKIMG>"+
						 "    <MSGTYPE>104</MSGTYPE>"+
						 "    <SUB>"+sub4+"</SUB>"+
  					 "    <CONT>"+cont4+"</CONT>"+
						 "    <URL>http://fms1.amazoncar.co.kr/fms2/coolmsg/cool_index.jsp?id=%ID&pass=%PASS&url="+url4+"</URL>"; 						 
		xml_data4 += "    <TARGET>"+target_bean4.getId()+"</TARGET>";
		xml_data4 += "    <SENDER>"+sender_bean.getId()+"</SENDER>"+
						 "    <MSGICON>10</MSGICON>"+
						 "    <MSGSAVE>1</MSGSAVE>"+
						 "    <LEAVEDMSG>1</LEAVEDMSG>"+
  					 "    <FLDTYPE>1</FLDTYPE>"+
						 "  </ALERTMSG>"+
						 "</COOLMSG>";
		
		CdAlertBean msg4 = new CdAlertBean();
		msg4.setFlddata(xml_data4);
		msg4.setFldtype("1");
		
		flag4 = cm_db.insertCoolMsg(msg4);
						
	}		
		
%>
<script language='javascript'>
<%if(count == 1){%>            
	<%if(mode.equals("R") && (rc_bean.getRent_st().equals("1") || rc_bean.getRent_st().equals("9") || rc_bean.getUse_st().equals("3"))){
		//if(f_page.equals("")){%>
		alert('정상적으로 처리되었습니다. 정산처리하시기 바랍니다.');
		parent.self.close();
		parent.opener.parent.location	='/acar/rent_settle/rent_se_frame_s.jsp?auth_rw=<%=rs_db.getAuthRw(user_id, "02", "02", "01")%>&user_id=<%=user_id%>&br_id=<%=br_id%>&gubun1=<%=gubun1%>&gubun2=<%=gubun2%>&brch_id=<%=brch_id%>&start_dt=<%=start_dt%>&end_dt=<%=end_dt%>&s_kd=<%=s_kd%>&t_wd=<%=t_wd%>&car_comp_id=<%=car_comp_id%>&code=<%=code%>&s_cc=<%=s_cc%>&s_year=<%=s_year%>&asc=<%=asc%>&sort_gubun=<%=sort_gubun%>';
		<%//}else{%> 
		//parent.opener.location	='/acar/res_plan/res_pl_sc.jsp?auth_rw=<%=rs_db.getAuthRw(user_id, "03", "11")%>&user_id=<%=user_id%>&br_id=<%=br_id%>&gubun1=<%=gubun1%>&gubun2=<%=gubun2%>&brch_id=<%=brch_id%>&start_dt=<%=start_dt%>&end_dt=<%=end_dt%>&s_kd=<%=s_kd%>&t_wd=<%=t_wd%>&car_comp_id=<%=car_comp_id%>&code=<%=code%>&s_cc=<%=s_cc%>&s_year=<%=s_year%>&asc=<%=asc%>&sort_gubun=<%=sort_gubun%>';
		<%//}%>
	<%}else if(mode.equals("J")){	%>
		alert('정상적으로 처리되었습니다');
		parent.self.close();	
	<%}else{%>
		alert('정상적으로 처리되었습니다');
		parent.self.close();
			
		<%if(mode.equals("A") && end_est_yn.equals("Y")){%>
			parent.opener.location  ='/acar/rent_mng/res_rent_u.jsp?s_cd=<%=s_cd%>&c_id=<%=c_id%>&auth_rw=<%=auth_rw%>&user_id=<%=user_id%>&br_id=<%=br_id%>&gubun1=<%=gubun1%>&gubun2=<%=gubun2%>&brch_id=<%=brch_id%>&start_dt=<%=start_dt%>&end_dt=<%=end_dt%>&s_kd=<%=s_kd%>&t_wd=<%=t_wd%>&car_comp_id=<%=car_comp_id%>&code=<%=code%>&s_cc=<%=s_cc%>&s_year=<%=s_year%>&asc=<%=asc%>&sort_gubun=<%=sort_gubun%>';
		<%}else{%>			
			//if(f_page.equals("")){%>
			parent.opener.parent.location	='/acar/rent_mng/rent_mn_frame_s.jsp?auth_rw=<%=auth_rw%>&user_id=<%=user_id%>&br_id=<%=br_id%>&gubun1=<%=gubun1%>&gubun2=<%=gubun2%>&brch_id=<%=brch_id%>&start_dt=<%=start_dt%>&end_dt=<%=end_dt%>&s_kd=<%=s_kd%>&t_wd=<%=t_wd%>&car_comp_id=<%=car_comp_id%>&code=<%=code%>&s_cc=<%=s_cc%>&s_year=<%=s_year%>&asc=<%=asc%>&sort_gubun=<%=sort_gubun%>';
			<%//}else{%> 
			//parent.opener.location	='/acar/res_plan/res_pl_sc.jsp?auth_rw=<%=rs_db.getAuthRw(user_id, "03", "11")%>&user_id=<%=user_id%>&br_id=<%=br_id%>&gubun1=<%=gubun1%>&gubun2=<%=gubun2%>&brch_id=<%=brch_id%>&start_dt=<%=start_dt%>&end_dt=<%=end_dt%>&s_kd=<%=s_kd%>&t_wd=<%=t_wd%>&car_comp_id=<%=car_comp_id%>&code=<%=code%>&s_cc=<%=s_cc%>&s_year=<%=s_year%>&asc=<%=asc%>&sort_gubun=<%=sort_gubun%>';
			<%//}%>			
		<%}%>
	<%}%>				
<%}else{ //에러%>
		alert('처리되지 않았습니다\n\n에러발생!');
<%}%>
</script>
</body>
</html>
