<%@ page language="java" contentType="text/html; charset=euc-kr" %>
<%@ page import="java.util.*, acar.util.*" %>
<%@ page import="acar.res_search.*, acar.cont.*, acar.user_mng.* "%>
<jsp:useBean id="rs_db" 	class="acar.res_search.ResSearchDatabase" 		scope="page"/>
<jsp:useBean id="pk_db" 	class="acar.parking.ParkIODatabase" scope="page" />
<jsp:useBean id="ad_db" scope="page" class="acar.admin.AdminDatabase"/>

<%@ include file="/smart/cookies.jsp" %> 

<%
	String car_mng_id 	= request.getParameter("car_mng_id")==null?"":request.getParameter("car_mng_id");
	String rent_s_cd	= request.getParameter("rent_s_cd")==null?"":request.getParameter("rent_s_cd");
	
	String from_page 	= request.getParameter("from_page")==null?"":request.getParameter("from_page");	
	String cmd 			= request.getParameter("cmd")==null?"i":request.getParameter("cmd");
	
	//계약정보
	String ret_dt 		= request.getParameter("h_ret_dt")==null?"":AddUtil.replace(request.getParameter("h_ret_dt"),"-","");
	String ret_loc 		= request.getParameter("ret_loc")==null?"":request.getParameter("ret_loc");
	String ret_mng_id 	= request.getParameter("ret_mng_id")==null?"":request.getParameter("ret_mng_id");
	String serv_id 		= request.getParameter("serv_id")==null?"":request.getParameter("serv_id");
	String accid_id 	= request.getParameter("accid_id")==null?"":request.getParameter("accid_id");
	String sub_c_id 	= request.getParameter("sub_c_id")==null?"":request.getParameter("sub_c_id");
	String sub_l_cd 	= request.getParameter("sub_l_cd")==null?"":request.getParameter("sub_l_cd");
	String ment 		= request.getParameter("ment")==null?"":request.getParameter("ment");
	
	
	
	
	boolean flag3 = true;
	int count = 1;
	int count_cust = 0;
	int count2 = 0;
	
	
	//단기대여관리 수정
	RentContBean rc_bean = rs_db.getRentContCase(rent_s_cd, car_mng_id);
	
	if(rc_bean.getRet_plan_dt().equals("")) rc_bean.setRet_plan_dt2(ret_dt);
	if(rc_bean.getRent_end_dt().equals("")){
		rc_bean.setRent_end_dt2	(ret_dt);
		rc_bean.setRent_hour	(request.getParameter("rent_hour")==null?"":request.getParameter("rent_hour"));
		rc_bean.setRent_days	(request.getParameter("rent_days")==null?"":request.getParameter("rent_days"));
		rc_bean.setRent_months	(request.getParameter("rent_months")==null?"":request.getParameter("rent_months"));
	}
	rc_bean.setRet_dt2		(ret_dt);
	rc_bean.setRet_loc		(ret_loc);
	rc_bean.setRet_mng_id	(ret_mng_id);
	rc_bean.setReg_id		(user_id);
	if(rc_bean.getRent_st().equals("1") || rc_bean.getRent_st().equals("9"))	rc_bean.setUse_st("3");//반차
	else 																		rc_bean.setUse_st("4");//반차+정산
	if(rc_bean.getRent_end_dt().equals("")) rc_bean.setRent_end_dt(ret_dt);
	if(!ment.equals("")){
		rc_bean.setServ_id	(serv_id);
		rc_bean.setAccid_id	(accid_id);
		rc_bean.setSub_c_id	(sub_c_id);
		rc_bean.setSub_l_cd	(sub_l_cd);
	}
	count = rs_db.updateRentContRet(rc_bean);
	
	
	rc_bean = rs_db.getRentContCase(rent_s_cd, car_mng_id);
	
	
	
	//운행일지 수정
	String rent_st 		= rc_bean.getRent_st();
	String rent_start_dt = rc_bean.getRent_start_dt_d();
	String rent_end_dt 	= rc_bean.getRent_end_dt_d();
	String use_max_dt 	= rs_db.getMaxData(rent_s_cd, car_mng_id, "dt");
	String ret_time 	= rc_bean.getRet_dt_h();
	int use_days 		= 0;
	
	if(AddUtil.parseInt(use_max_dt) > AddUtil.parseInt(rc_bean.getRet_dt_d())){//기간미만->일지삭제
		count = rs_db.deleteScdCar(rent_s_cd, car_mng_id, rc_bean.getRet_dt_d());
	}else if(AddUtil.parseInt(use_max_dt) < AddUtil.parseInt(rc_bean.getRet_dt_d())){//기간초과->일지추가생성
		//운행일수
		use_days = AddUtil.parseInt(rs_db.getDay(use_max_dt, rc_bean.getRet_dt_d()));
		//마지막회차
		int max_tm = AddUtil.parseInt(rs_db.getMaxData(rent_s_cd, car_mng_id, "tm"));
		for(int i=0; i<use_days; i++){
			ScdCarBean sc_bean = new ScdCarBean();
			sc_bean.setCar_mng_id	(car_mng_id);
			sc_bean.setRent_s_cd	(rent_s_cd);
			sc_bean.setTm			(max_tm+i+1);
			sc_bean.setDt			(rs_db.addDay(use_max_dt, i));
			if(i > 0 && i==use_days-1){//대여종료 예정일
				sc_bean.setTime		(ret_time);
				sc_bean.setUse_st	("2");
			}else{//대여기간
				sc_bean.setTime		("");
				sc_bean.setUse_st	("1");
			}
			sc_bean.setReg_id		(user_id);
			count = rs_db.insertScdCar(sc_bean);
		}
	}else{}
	
	
	//단기대여가 아닐경우 정산처리까지
	if(!rc_bean.getRent_st().equals("1")){
		//단기대여 정산 등록
		RentSettleBean rs_bean = rs_db.getRentSettleCase(rent_s_cd);
		rs_bean.setRent_s_cd	(rent_s_cd);
		rs_bean.setSett_dt		(rc_bean.getRet_dt_d());
		rs_bean.setRun_km		(request.getParameter("run_km")==null?"":AddUtil.parseDigit3(request.getParameter("run_km")));
		rs_bean.setAgree_hour	(request.getParameter("rent_hour")==null?"":request.getParameter("rent_hour"));
		rs_bean.setAgree_days	(request.getParameter("rent_days")==null?"":request.getParameter("rent_days"));
		rs_bean.setAgree_months	(request.getParameter("rent_months")==null?"":request.getParameter("rent_months"));
		rs_bean.setAdd_hour		(request.getParameter("add_hour")==null?"":request.getParameter("add_hour"));
		rs_bean.setAdd_days		(request.getParameter("add_days")==null?"":request.getParameter("add_days"));
		rs_bean.setAdd_months	(request.getParameter("add_months")==null?"":request.getParameter("add_months"));
		rs_bean.setTot_hour		(request.getParameter("tot_hour")==null?"":request.getParameter("tot_hour"));
		rs_bean.setTot_days		(request.getParameter("tot_days")==null?"":request.getParameter("tot_days"));
		rs_bean.setTot_months	(request.getParameter("tot_months")==null?"":request.getParameter("tot_months"));
		rs_bean.setEtc			(request.getParameter("etc")==null?"":request.getParameter("etc"));
		rs_bean.setRent_sett_amt(0);
		rs_bean.setReg_id		(user_id);
		
		if(rs_bean.getRent_s_cd().equals("")){
			rs_bean.setRent_s_cd		(rent_s_cd);
			count = rs_db.insertRentSettle(rs_bean);
		}else{
			count = rs_db.updateRentSettle(rs_bean);
		}
		
		
		//주행거리 입력점검
		String  d_flag3 =  ad_db.call_sp_dist_etc_ck(c_id, "ret", rs_bean.getRun_km(), rs_bean.getSett_dt(), ck_acar_id);
	}
	
	
	//반차처리시 차량의 현위치를 당산주차장 수정
	String park 		= request.getParameter("park")==null?"":request.getParameter("park");
	String park_cont 	= request.getParameter("park_cont")==null?"":request.getParameter("park_cont");
	count = rs_db.updateCarPark(car_mng_id, park, park_cont);
	
	Hashtable ht2 = pk_db.getRentParkIOSearch2(car_mng_id);
	count2 = pk_db.UpdateParkIO(String.valueOf(ht2.get("CAR_MNG_ID")));
%>
<html>
<head>

<title>FMS</title>
<meta http-equiv="content-type" content="text/html; charset=euc-kr">
<link rel="stylesheet" type="text/css" href="/include/table_t.css"></link>
</head>
<body>
<form action="car_ret_view.jsp" name="form1" method="POST">
<%@ include file="/include/search_hidden.jsp" %>
	<input type='hidden' name='car_mng_id' 	value='<%=car_mng_id%>'>	
	<input type='hidden' name='rent_s_cd'	value='<%=rent_s_cd%>'>		
</form>
<script>
<%	if(!rc_bean.getRet_dt_d().equals("")){%>		
		document.form1.action = "car_ret_view.jsp";
		document.form1.target = '_parent';		
		document.form1.submit();		
<%	}else{%>
		alert("에러발생!");
<%	}%>
</script>
</body>
</html>