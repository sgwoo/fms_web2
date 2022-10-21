<%@ page language="java" contentType="text/html;charset=euc-kr" %>
<%@ page import="java.util.*, acar.util.*, acar.res_search.*, acar.car_mst.*, acar.secondhand.*, acar.estimate_mng.*"%>
<%@ page import="acar.coolmsg.*, acar.user_mng.*, acar.car_sche.*, acar.cont.*,acar.client.*"%>
<jsp:useBean id="rs_db" scope="page" class="acar.res_search.ResSearchDatabase"/>
<jsp:useBean id="cm_db" scope="page" class="acar.coolmsg.CoolMsgDatabase"/>
<jsp:useBean id="shDb" class="acar.secondhand.SecondhandDatabase" 	scope="page"/>
<jsp:useBean id="a_db" scope="page" class="acar.cont.AddContDatabase"/>
<jsp:useBean id="cm_bean" class="acar.car_mst.CarMstBean" scope="page"/>
<jsp:useBean id="al_db" class="acar.client.AddClientDatabase"      scope="page"/>
<jsp:useBean id="IssueDb" scope="page" class="tax.IssueDatabase"/>
<jsp:useBean id="ec_db" scope="page" class="acar.cont.EtcContDatabase"/>
<%@ include file="/agent/cookies.jsp" %>

<html>
<head>
<title>FMS</title>
<link rel=stylesheet type="text/css" href="/include/table.css">
<script language='JavaScript' src='../../include/common.js'></script>
</head>
<body leftmargin="15">

<%
	String auth_rw 	= request.getParameter("auth_rw")	==null?"":request.getParameter("auth_rw");
	String user_id 	= request.getParameter("user_id")	==null?"":request.getParameter("user_id");
	String br_id 	= request.getParameter("br_id")		==null?"":request.getParameter("br_id");
	String gubun1 	= request.getParameter("gubun1")	==null?"":request.getParameter("gubun1");
	String gubun2 	= request.getParameter("gubun2")	==null?"":request.getParameter("gubun2");
	String brch_id 	= request.getParameter("brch_id")	==null?"":request.getParameter("brch_id");
	String start_dt = request.getParameter("start_dt")	==null?"":request.getParameter("start_dt");
	String end_dt 	= request.getParameter("end_dt")	==null?"":request.getParameter("end_dt");
	String car_comp_id = request.getParameter("car_comp_id")==null?"":request.getParameter("car_comp_id");
	String code 	= request.getParameter("code")		==null?"":request.getParameter("code");
	String s_cc 	= request.getParameter("s_cc")		==null?"":request.getParameter("s_cc");
	String s_year 	= request.getParameter("s_year")	==null?"":request.getParameter("s_year");
	String s_kd 	= request.getParameter("s_kd")		==null?"":request.getParameter("s_kd");
	String t_wd 	= request.getParameter("t_wd")		==null?"":request.getParameter("t_wd");
	String sort_gubun = request.getParameter("sort_gubun")	==null?"":request.getParameter("sort_gubun");
	String asc 	= request.getParameter("asc")		==null?"":request.getParameter("asc");
	
	String c_id 	= request.getParameter("c_id")		==null?"":request.getParameter("c_id");
	String rent_st 	= request.getParameter("rent_st")	==null?"":request.getParameter("rent_st");
	String use_st 	= request.getParameter("use_st")	==null?"":request.getParameter("use_st");
	String sub_c_id = request.getParameter("sub_c_id")	==null?"":request.getParameter("sub_c_id");
	String section 	= request.getParameter("section")	==null?"":request.getParameter("section");
	String com_emp_yn= request.getParameter("com_emp_yn")	==null?"":request.getParameter("com_emp_yn"); //임직원운전한정특약
	
	
	String s_cd 	= "";
	String mode 	= "";
	boolean flag3 	= true;
	boolean flag4 = true;
	int count 	= 1;
	int count_cust 	= 0;
	int cms_scd_cnt = 0;
	
	
	String cust_st 	= request.getParameter("cust_st")	==null?"":request.getParameter("cust_st");
	String c_cust_id = request.getParameter("c_cust_id")	==null?"":request.getParameter("c_cust_id");
	String serv_id 	= request.getParameter("serv_id")	==null?"":request.getParameter("serv_id");
	String accid_id = request.getParameter("accid_id")	==null?"":request.getParameter("accid_id");
	String maint_id = request.getParameter("seq_no")	==null?"":request.getParameter("seq_no");
	String site_id 	= request.getParameter("site_id")	==null?"":request.getParameter("site_id");
	

	//예약현황
	Vector conts = rs_db.getResCarList(c_id);
	int cont_size = conts.size();

	
	int use_cnt = 0;
	int rent_cnt = 0;
	
	if(cont_size > 0){
  		for(int i = 0 ; i < cont_size ; i++){
    			Hashtable reservs = (Hashtable)conts.elementAt(i);
    			if(String.valueOf(reservs.get("USE_ST")).equals("예약") || String.valueOf(reservs.get("USE_ST")).equals("배차")){
				use_cnt ++;
				if(String.valueOf(reservs.get("USE_ST")).equals("예약") && String.valueOf(reservs.get("RENT_ST")).equals("장기대기")){
					rent_cnt ++;
				}
			}
		}
	}	
	
	
	//계약정보
	String rent_s_cd 	= request.getParameter("rent_s_cd")	==null?"":request.getParameter("rent_s_cd");
	String rent_dt 		= request.getParameter("rent_dt")	==null?"":request.getParameter("rent_dt");
	String s_brch_id 	= request.getParameter("s_brch_id")	==null?"":request.getParameter("s_brch_id");
	String bus_id 		= request.getParameter("bus_id")	==null?"":request.getParameter("bus_id");
	String rent_start_dt 	= request.getParameter("h_rent_start_dt")==null?"":request.getParameter("h_rent_start_dt");
	String rent_end_dt 	= request.getParameter("h_rent_end_dt")	==null?"":request.getParameter("h_rent_end_dt");
	String rent_hour 	= request.getParameter("rent_hour")	==null?"":request.getParameter("rent_hour");
	String rent_days 	= request.getParameter("rent_days")	==null?"":request.getParameter("rent_days");
	String rent_months 	= request.getParameter("rent_months")	==null?"":request.getParameter("rent_months");
	String rent_mon 	= request.getParameter("rent_mon")	==null?"":request.getParameter("rent_mon");
	String etc 		= request.getParameter("etc")		==null?"":request.getParameter("etc");
	String deli_plan_dt 	= request.getParameter("h_deli_plan_dt")==null?"":request.getParameter("h_deli_plan_dt");
	String deli_loc 	= request.getParameter("deli_loc")	==null?"":request.getParameter("deli_loc");
	String ret_plan_dt 	= request.getParameter("h_ret_plan_dt")	==null?"":request.getParameter("h_ret_plan_dt");
	String ret_loc 		= request.getParameter("ret_loc")	==null?"":request.getParameter("ret_loc");
	String deli_dt 		= request.getParameter("h_deli_dt")	==null?"":request.getParameter("h_deli_dt");
	String deli_mng_id 	= request.getParameter("deli_mng_id")	==null?"":request.getParameter("deli_mng_id");
	String sub_l_cd 	= request.getParameter("sub_l_cd")	==null?"":request.getParameter("sub_l_cd");
	String mng_id 		= request.getParameter("mng_id")	==null?"":request.getParameter("mng_id");
	String ins_change_std_dt 		= request.getParameter("ins_change_std_dt")	==null?"":request.getParameter("ins_change_std_dt");
	String ins_change_flag 		= request.getParameter("ins_change_flag_input")	==null?"":request.getParameter("ins_change_flag_input");
	//네비게이션관련
	String navi_yn 		= request.getParameter("navi_yn")		==null?"N":request.getParameter("navi_yn");
	String serial_no	= request.getParameter("serial_no")	==null?"":request.getParameter("serial_no");
	
	
	MaMenuDatabase 		nm_db 	= MaMenuDatabase.getInstance();
	UserMngDatabase 	umd 	= UserMngDatabase.getInstance();
	AddCarMstDatabase 	cmb 	= AddCarMstDatabase.getInstance();
	
	
	//단기대여관리 등록
	RentContBean rc_bean = new RentContBean();
	
	rc_bean.setRent_s_cd		("");
	rc_bean.setCar_mng_id		(c_id);
	rc_bean.setRent_st		(rent_st);
	rc_bean.setCust_st		(cust_st);
	rc_bean.setCust_id		(c_cust_id);
	rc_bean.setSub_c_id		(sub_c_id);
	rc_bean.setAccid_id		(accid_id);
	rc_bean.setServ_id		(serv_id);
	rc_bean.setMaint_id		(maint_id);
	rc_bean.setRent_dt		(rent_dt);
	rc_bean.setBrch_id		(s_brch_id);
	rc_bean.setBus_id		(bus_id);
	rc_bean.setRent_start_dt	(rent_start_dt);
	rc_bean.setRent_end_dt		(rent_end_dt);
	
	String mng_msg_send_yn = "";
	
	//차량정보
	Hashtable reserv = rs_db.getCarInfo(c_id);
	
	
	rc_bean.setMng_id	(bus_id);			
	
	
	rc_bean.setRent_hour		(rent_hour);
	rc_bean.setRent_days		(rent_days);
	rc_bean.setRent_months		(rent_months);	
	rc_bean.setEtc			(etc);
	rc_bean.setDeli_plan_dt		(deli_plan_dt);
	rc_bean.setRet_plan_dt		(ret_plan_dt);
	rc_bean.setRet_dt		("");
	rc_bean.setDeli_loc		(deli_loc);
	rc_bean.setRet_loc		(ret_loc);
	rc_bean.setRet_mng_id		("");
	
	if(deli_dt.equals("")){
		rc_bean.setDeli_dt	("");
		rc_bean.setDeli_mng_id	(deli_mng_id);
		rc_bean.setUse_st	("1");
	}else{
		rc_bean.setDeli_dt	(deli_dt);
		rc_bean.setDeli_mng_id	(deli_mng_id);
		rc_bean.setUse_st	("2");
	}
	
	rc_bean.setReg_id		(user_id);
	rc_bean.setSub_l_cd		(sub_l_cd);
	rc_bean.setSite_id		(site_id);
	rc_bean.setCom_emp_yn	(com_emp_yn);
	rc_bean.setIns_change_std_dt	(ins_change_std_dt);
	rc_bean.setIns_change_flag	(ins_change_flag);
	rc_bean = rs_db.insertRentCont(rc_bean);
	
	
	s_cd = rc_bean.getRent_s_cd();
	
	if(s_cd.equals(""))	count = 0;


	rent_start_dt 		= request.getParameter("rent_start_dt")	==null?"":AddUtil.replace(request.getParameter("rent_start_dt"),"-","");
	rent_end_dt 		= request.getParameter("rent_end_dt")	==null?"":AddUtil.replace(request.getParameter("rent_end_dt"),"-","");
	deli_dt 		= request.getParameter("deli_dt")	==null?"":AddUtil.replace(request.getParameter("deli_dt"),"-","");
	deli_plan_dt 		= request.getParameter("deli_plan_dt")	==null?"":AddUtil.replace(request.getParameter("deli_plan_dt"),"-","");
	
	String deli_dt_h 	= request.getParameter("deli_dt_h")	==null?"":request.getParameter("deli_dt_h");
	String deli_plan_dt_h 	= request.getParameter("deli_plan_dt_h")==null?"":request.getParameter("deli_plan_dt_h");
	String ret_dt 		= rent_end_dt;
	String ret_time 	= rc_bean.getRent_end_dt_h();
	int use_days 		= 0;
		
	if(rent_end_dt.equals("")){
		if(deli_dt.equals("")){
			if(rent_st.equals("2") || rent_st.equals("3")){			ret_dt = rs_db.addDay(deli_plan_dt, 15); 	//보름(<-일주일)
			}else if(rent_st.equals("4") || rent_st.equals("5")){		ret_dt = rs_db.addMonth(deli_plan_dt, 36); 	//3년(한달에서벼경->1년)
			}else{								ret_dt = rs_db.addDay(deli_plan_dt, 7); 	//7일(<-3일)
			}
			ret_time = deli_plan_dt_h;
		}else{
			if(rent_st.equals("2") || rent_st.equals("3")){			ret_dt = rs_db.addDay(deli_dt, 15); 		//보름(<-일주일)
			}else if(rent_st.equals("4") || rent_st.equals("5")){		ret_dt = rs_db.addMonth(deli_dt, 36); 		//3년(한달에서벼경->1년)
			}else{								ret_dt = rs_db.addDay(deli_dt, 7); 		//7일(<-3일)
			}
			ret_time = deli_dt_h;
		}
		if(ret_time.equals("")) ret_time = "00";
	}
		
	String scd_dt 	= "";
	String scd_h 	= "";
		
	//운행일수
	if(deli_dt.equals("")){
		scd_dt 	= deli_plan_dt;
		scd_h 	= deli_plan_dt_h;
	}else{
		scd_dt 	= deli_dt;
		scd_h 	= deli_dt_h;
	}
		
	use_days = AddUtil.parseInt(rs_db.getDay(scd_dt, ret_dt));
		
		
	for(int i=0; i<use_days; i++){
		ScdCarBean sc_bean = new ScdCarBean();
			
		sc_bean.setCar_mng_id	(c_id);
		sc_bean.setRent_s_cd	(s_cd);
		sc_bean.setTm		(i+1);
		sc_bean.setDt		(rs_db.addDay(scd_dt, i));
		
		if(i==0){//대여시작
			sc_bean.setTime(scd_h);
			sc_bean.setUse_st("0");
		}else if(i > 0 && i==use_days-1){//대여종료 예정일
			sc_bean.setTime(ret_time);
			sc_bean.setUse_st("2");
		}else{//대여기간
			sc_bean.setTime("");
			sc_bean.setUse_st("1");
		}
		
		sc_bean.setReg_id(user_id);
		count = rs_db.insertScdCar(sc_bean);
	}


	if(rent_st.equals("1") || rent_st.equals("2") || rent_st.equals("3") || rent_st.equals("9") || rent_st.equals("10") || rent_st.equals("12")){
	
		//고객기타정보		
		RentMgrBean rm_bean0 = new RentMgrBean();
		
		rm_bean0.setRent_s_cd	(s_cd);
		rm_bean0.setMgr_st	("4");
		rm_bean0.setMgr_nm	(request.getParameter("c_cust_nm")==null?"":request.getParameter("c_cust_nm"));
		rm_bean0.setSsn		(request.getParameter("c_ssn")==null?"":request.getParameter("c_ssn"));
		rm_bean0.setZip		("");
		rm_bean0.setAddr	("");
		rm_bean0.setLic_no	(request.getParameter("c_lic_no")==null?"":request.getParameter("c_lic_no"));
		rm_bean0.setLic_st	(request.getParameter("c_lic_st")==null?"":request.getParameter("c_lic_st"));
		rm_bean0.setTel		(request.getParameter("c_tel")==null?"":request.getParameter("c_tel"));
		rm_bean0.setEtc		(request.getParameter("c_m_tel")==null?"":request.getParameter("c_m_tel"));
		
		if(!rm_bean0.getLic_no().equals("") || !rm_bean0.getTel().equals("") || !rm_bean0.getEtc().equals("")){
			count = rs_db.insertRentMgr(rm_bean0);
		}
	
		//비상연락처 등록
		RentMgrBean rm_bean1 = new RentMgrBean();
		
		rm_bean1.setRent_s_cd	(s_cd);
		rm_bean1.setMgr_st	(request.getParameter("mgr_st2")==null?"":request.getParameter("mgr_st2"));
		rm_bean1.setMgr_nm	(request.getParameter("mgr_nm2")==null?"":request.getParameter("mgr_nm2"));
		rm_bean1.setSsn		("");
		rm_bean1.setZip		("");
		rm_bean1.setAddr	("");
		rm_bean1.setLic_no	("");
		rm_bean1.setLic_st	("");
		rm_bean1.setTel		(request.getParameter("m_tel2")==null?"":request.getParameter("m_tel2"));
		rm_bean1.setEtc		(request.getParameter("m_etc2")==null?"":request.getParameter("m_etc2"));
		
		if(!rm_bean1.getMgr_st().equals("")){
			count = rs_db.insertRentMgr(rm_bean1);
		}
						
	}
	
	//배차시 메시지
	if(rc_bean.getUse_st().equals("2")){
		String  d_flag4 =  rs_db.call_sp_res_deli_msg("배차처리", s_cd);
	}
	
	
	//메모===========================================================================
	
	String memo_title 	= "";
	String car_no 		= request.getParameter("car_no")==null?"":request.getParameter("car_no");
	
	String c_firm_nm 	= request.getParameter("c_firm_nm")==null?"":request.getParameter("c_firm_nm");
	String c_cust_nm 	= request.getParameter("c_cust_nm")==null?"":request.getParameter("c_cust_nm");
	
	if(deli_dt.equals("")) 		memo_title = "[예약]";
	else				memo_title = "[배차]";
	
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
	else if(rent_st.equals("12")) 	memo_title += "월렌트-";
	
	memo_title += String.valueOf(reserv.get("CAR_NO")) +" "+c_firm_nm;
	


	//2. 쿨메신저 메세지 전송------------------------------------------------------------------------------------------
		
	String sub 		= "보유차 처리 통보";
	String cont 		= memo_title;
	String target_id 	= nm_db.getWorkAuthUser("보유차관리");
		
	//사용자 정보 조회
	UsersBean target_bean 	= umd.getUsersBean(target_id);
	UsersBean sender_bean 	= umd.getUsersBean(user_id);


	//배차처리일때 재리스 계약확정이 있다면 통보한다.
	//if(rc_bean.getUse_st().equals("2")){
		
		
		//예약상태		
		ShResBean srBn = shDb.getShRes3(c_id);	//상담중 조회
		
		if(srBn.getSituation().equals("0")){
			
			
			sub 	= "상담중인 차량의 보유차 처리 통보";
			cont 	= memo_title+" -- 상담중인 상태에서 배차(예약)되었으니 확인하시기 바랍니다.";
			
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
			
			//상담종료일보다 반차예정일이 더 큰 경우
			//if(AddUtil.parseInt(AddUtil.replace(ret_dt,"-","")) > AddUtil.parseInt(srBn.getRes_end_dt())){
			
				//에이젼트이면 문자발송
				//if(target_bean2.getDept_id().equals("1000")){
					String sendphone 	= sender_bean.getUser_m_tel();
					String sendname 	= sender_bean.getUser_nm();
					String destphone 	= target_bean2.getUser_m_tel();
					String destname 	= target_bean2.getUser_nm();
					String msg_cont		= cont+"-아마존카-";
					IssueDb.insertsendMail(sendphone, sendname, destphone, destname, "", "", msg_cont);	
				//}else{
				//	flag3 = cm_db.insertCoolMsg(msg2);
				//}
				
			//}
		}
						
		
	//}
	
	//에이전트에서 출고전대차 입력시 에이전트 담당자에게 메시지를 보낸다.
	if(rent_st.equals("10")){
	
			sub 	= "에이전트 출고전대차 등록";
			cont 	= memo_title+"  &lt;br&gt; &lt;br&gt;  에이전트가 출고전대차("+sub_l_cd+")를 등록하였습니다. 확인하시기 바랍니다.";
			
			String target_id2 	= nm_db.getWorkAuthUser("에이전트관리");
			String target_id3 	= nm_db.getWorkAuthUser("에이전트관리2");
			//String target_id4 	= nm_db.getWorkAuthUser("에이전트관리3");
			
			UsersBean target_bean2 	= umd.getUsersBean(target_id2);
			UsersBean target_bean3 	= umd.getUsersBean(target_id3);
			//UsersBean target_bean4 	= umd.getUsersBean(target_id4);
			
			String xml_data2 = "";
			xml_data2 =  "<COOLMSG>"+
	  					 "<ALERTMSG>"+
  						 "    <BACKIMG>4</BACKIMG>"+
  						 "    <MSGTYPE>104</MSGTYPE>"+
  						 "    <SUB>"+sub+"</SUB>"+
	  					 "    <CONT>"+cont+"</CONT>"+
 						 "    <URL></URL>";
			xml_data2 += "    <TARGET>"+target_bean2.getId()+"</TARGET>";
			xml_data2 += "    <TARGET>"+target_bean3.getId()+"</TARGET>";
			//xml_data2 += "    <TARGET>"+target_bean4.getId()+"</TARGET>";
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
	
	if(!deli_dt.equals("")){
		//보험변경요청 프로시저 호출
	  if(rent_st.equals("2") || rent_st.equals("3")){
	  	String  d_flag2 =  ec_db.call_sp_ins_cng_req("대차등록", s_cd, c_id, "");
		}else if(rent_st.equals("10")){

			//고객정보
			ClientBean client = al_db.getNewClient(c_cust_id);
				
			//자동차기본정보
			cm_bean = cmb.getCarNmCase(String.valueOf(reserv.get("CAR_ID")), String.valueOf(reserv.get("CAR_SEQ")));
			
			//장기계약 연동
			if(!rc_bean.getSub_l_cd().equals("")){
			
				Hashtable cont_ht = a_db.getContViewCase("", rc_bean.getSub_l_cd());
				
				ContEtcBean cont_etc = a_db.getContEtc(String.valueOf(cont_ht.get("RENT_MNG_ID")), String.valueOf(cont_ht.get("RENT_L_CD")));
				
				//출고지연대차 법인 임직원전용대상차량 배차
				if(cont_etc.getCom_emp_yn().equals("Y") && !client.getClient_st().equals("2") && AddUtil.parseInt(cm_bean.getS_st())>101 && AddUtil.parseInt(cm_bean.getS_st()) < 600 && AddUtil.parseInt(cm_bean.getS_st()) != 409){
					String  d_flag2 =  ec_db.call_sp_ins_cng_req("지연대차등록 임직원전용보험", s_cd, c_id, "");
				}else{
					String  d_flag2 =  ec_db.call_sp_ins_cng_req("대차등록", s_cd, c_id, "");
				}
			//장기계약 미연동
			}else{
				//출고지연대차 법인 임직원전용대상차량 배차
				if(client.getClient_st().equals("1") && AddUtil.parseInt(cm_bean.getS_st())>101 && AddUtil.parseInt(cm_bean.getS_st()) < 600 && AddUtil.parseInt(cm_bean.getS_st()) != 409){
					String  d_flag2 =  ec_db.call_sp_ins_cng_req("지연대차등록 임직원전용보험", s_cd, c_id, "");
				}else{
					String  d_flag2 =  ec_db.call_sp_ins_cng_req("대차등록", s_cd, c_id, "");
				}
			}
		}
	}
	
%>
<script language='javascript'>
<%	if(rc_bean != null){%>
<%		if(count == 1){%>
			alert('정상적으로 처리되었습니다. 계약관리에서 출고지연대차 연동 등록하십시오.');
			
			if(<%=rent_cnt%> > 0){
				alert('재리스 계약확정되어 장기대기로 예약되어 있는 차량입니다.\n\n확인바랍니다.');				
			}else{
				if(<%=use_cnt%> > 0){
					alert('현재 예약 혹은 배차중인 차량입니다.\n\n확인바랍니다.');
				}
			}
						
			parent.location='/agent/res_stat/res_st_frame_s.jsp';

<%		}else{ //에러%>
			alert('처리되지 않았습니다\n\n에러발생!');
<%		}%>
<%	}else{%>
		alert('고객등록 오류!!');
<%	}%>
</script>
</body>
</html>
