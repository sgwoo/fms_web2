<%@ page language="java" contentType="text/html;charset=euc-kr" %>
<%@ page import="java.util.*, acar.util.*, acar.res_search.*,acar.memo.*"%>
<%@ page import="acar.user_mng.*, acar.car_sche.*, acar.cont.*, acar.client.*, acar.car_mst.*"%>
<jsp:useBean id="rs_db" scope="page" class="acar.res_search.ResSearchDatabase"/>
<jsp:useBean id="a_db" scope="page" class="acar.cont.AddContDatabase"/>
<jsp:useBean id="al_db"     class="acar.client.AddClientDatabase"      scope="page"/>
<jsp:useBean id="ec_db" scope="page" class="acar.cont.EtcContDatabase"/>
<jsp:useBean id="cm_bean" class="acar.car_mst.CarMstBean" scope="page"/>
<%@ include file="/agent/cookies.jsp" %>

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
	String gubun1 = request.getParameter("gubun1")==null?"2":request.getParameter("gubun1");
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
	
	
	boolean flag3 = true;
	boolean flag4 = true;
	int count = 1;
	int count1 = 1;
	int count_cust = 0;
	String cms_reg_msg = "";
	
	
	
	
	AddCarMstDatabase 	cmb 	= AddCarMstDatabase.getInstance();
	
	//계약정보
	String deli_dt 		= request.getParameter("h_deli_dt")==null?"":AddUtil.replace(request.getParameter("h_deli_dt"),"-","");
	String deli_loc 	= request.getParameter("deli_loc")==null?"":request.getParameter("deli_loc");
	String deli_mng_id 	= request.getParameter("deli_mng_id")==null?"":request.getParameter("deli_mng_id");
	String ret_plan_dt 	= request.getParameter("h_ret_plan_dt")==null?"":request.getParameter("h_ret_plan_dt");
	String cms_est_dt 	= request.getParameter("cms_est_dt")==null?"":request.getParameter("cms_est_dt");
	String h_ret_dt = "";

	//단기대여관리 수정
	RentContBean rc_bean = rs_db.getRentContCase(s_cd, c_id);
	
	//고객정보
	RentCustBean rc_bean2 = rs_db.getRentCustCase(rc_bean.getCust_st(), rc_bean.getCust_id(), rc_bean.getSite_id());
				
	//단기관리자-연대보증인
	RentMgrBean rm_bean1 = rs_db.getRentMgrCase(s_cd, "1");
	RentMgrBean rm_bean2 = rs_db.getRentMgrCase(s_cd, "2");
	RentMgrBean rm_bean3 = rs_db.getRentMgrCase(s_cd, "3");
	RentMgrBean rm_bean4 = rs_db.getRentMgrCase(s_cd, "4");
	
	//차량정보
	Hashtable reserv = rs_db.getCarInfo(c_id);
	
	if(mode.equals("Y")){
		rc_bean.setDeli_dt2	(deli_dt);
		rc_bean.setDeli_loc	(deli_loc);
		rc_bean.setDeli_mng_id	(deli_mng_id);
		rc_bean.setReg_id	(user_id);
		rc_bean.setUse_st	("2");
		rc_bean.setRet_plan_dt	(ret_plan_dt);
	}else{
		rc_bean.setUse_st("5");
		
		//운행스케줄 삭제
		count = rs_db.deleteScdCar(s_cd, c_id, "");
	
	}
	
	count = rs_db.updateRentCont(rc_bean);
	
	//운행일지 수정
	if(mode.equals("Y")){
		
		
		String rent_st = rc_bean.getRent_st();
		String rent_start_dt = rc_bean.getRent_start_dt_d();
		String rent_end_dt = rc_bean.getRent_end_dt_d();
		String ret_dt = rent_end_dt;
		String ret_time = "00";
		int use_days = 0;
		
		if(rent_end_dt.equals("")){
			if(rent_st.equals("2") || rent_st.equals("3")){			ret_dt = rs_db.addDay(rc_bean.getDeli_dt_d(), 7); //일주일
			}else if(rent_st.equals("4") || rent_st.equals("5")){	ret_dt = rs_db.addMonth(rc_bean.getDeli_dt_d(), 1); //한달
			}else{													ret_dt = rs_db.addDay(rc_bean.getDeli_dt_d(), 3); //3일
			}
			ret_time = rc_bean.getRent_end_dt_h();
		}
		
		h_ret_dt = ret_dt;
		
		//운행일수
		use_days = AddUtil.parseInt(rs_db.getDay(rc_bean.getDeli_dt_d(), ret_dt));
		
		for(int i=0; i<use_days; i++){
			ScdCarBean sc_bean = new ScdCarBean();
			sc_bean.setCar_mng_id(c_id);
			sc_bean.setRent_s_cd(s_cd);
			sc_bean.setTm(i+1);
			sc_bean.setDt(rs_db.addDay(rc_bean.getDeli_dt_d(), i));
			if(i==0){//대여시작
				sc_bean.setTime(rc_bean.getDeli_dt_h());
				sc_bean.setUse_st("0");
			}else if(i > 0 && i==use_days-1){//대여종료 예정일
				sc_bean.setTime(ret_time);
				sc_bean.setUse_st("2");
			}else{//대여기간
				sc_bean.setTime("");
				sc_bean.setUse_st("1");
			}
			sc_bean.setReg_id(user_id);
			count1 = rs_db.insertScdCar(sc_bean);
		}
		
		//배차시 재리스 예약자 메시지 발송
		String  d_flag4 =  rs_db.call_sp_res_deli_msg("배차처리", s_cd);
	}

	if(mode.equals("Y")){
		//보험변경요청 프로시저 호출
	  if(rc_bean.getRent_st().equals("2") || rc_bean.getRent_st().equals("3")){
	  	String  d_flag2 =  ec_db.call_sp_ins_cng_req("대차등록", s_cd, c_id, "");
		}else if(rc_bean.getRent_st().equals("10")){
			
			//고객정보
			ClientBean client = al_db.getNewClient(rc_bean.getCust_id());
				
			//자동차기본정보
			cm_bean = cmb.getCarNmCase(String.valueOf(reserv.get("CAR_ID")), String.valueOf(reserv.get("CAR_SEQ")));	

			//장기계약 연동
			if(!rc_bean.getSub_l_cd().equals("")){
				
				Hashtable cont_ht = a_db.getContViewCase("", rc_bean.getSub_l_cd());
				
				ContEtcBean cont_etc = a_db.getContEtc(String.valueOf(cont_ht.get("RENT_MNG_ID")), String.valueOf(cont_ht.get("RENT_L_CD")));
				
				//출고지연대차 법인 임직원전용대상차량 배차
				if(cont_etc.getCom_emp_yn().equals("Y") && rc_bean.getRent_st().equals("10") && !client.getClient_st().equals("2") && AddUtil.parseInt(cm_bean.getS_st())>101 && AddUtil.parseInt(cm_bean.getS_st()) < 600 && AddUtil.parseInt(cm_bean.getS_st()) != 409){
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
				
				//출고지연대차 법인 임직원전용대상차량 배차2(가입조건을 예약등록에서 한 경우 rent_con에서 직접 저장 )
				if(client.getClient_st().equals("1") && rc_bean.getCom_emp_yn().equals("Y")){
					System.out.println("//출고지연대차 법인 임직원전용대상차량 배차2(가입조건을 예약등록에서 한 경우 rent_con에서 직접 저장 )");
					String  d_flag2 =  ec_db.call_sp_ins_cng_req("지연대차등록 임직원전용보험", s_cd, c_id, "");
				}else{
					String  d_flag2 =  ec_db.call_sp_ins_cng_req("대차등록", s_cd, c_id, "");
				}
			}
			
		}
	}

%>
<script language='javascript'>
<%	if(count == 1){%>
		alert('정상적으로 처리되었습니다');
		parent.self.close();
		parent.opener.parent.location='/agent/res_stat/res_st_frame_s.jsp?auth_rw=<%=auth_rw%>&user_id=<%=user_id%>&br_id=<%=br_id%>&gubun1=<%=gubun1%>&gubun2=<%=gubun2%>&brch_id=<%=brch_id%>&start_dt=<%=start_dt%>&end_dt=<%=end_dt%>&s_kd=<%=s_kd%>&t_wd=<%=t_wd%>&car_comp_id=<%=car_comp_id%>&code=<%=code%>&s_cc=<%=s_cc%>&s_year=<%=s_year%>&asc=<%=asc%>&sort_gubun=<%=sort_gubun%>';
<%	}else{ //에러%>
		alert('처리되지 않았습니다\n\n에러발생!');
<%	}%>
</script>
</body>
</html>
