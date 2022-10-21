<%@ page language="java" contentType="text/html;charset=euc-kr" %>
<%@ page import="java.util.*, acar.util.*, acar.res_search.*, acar.parking.*, acar.cus_reg.*, acar.car_service.*"%>
<jsp:useBean id="pa_bean" scope="page" class="acar.parking.ParkingBean"/>  
<jsp:useBean id="rs_db" scope="page" class="acar.res_search.ResSearchDatabase"/>
<jsp:useBean id="p_db" scope="page" class="acar.parking.ParkIODatabase"/>
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
		
	String park_id = request.getParameter("park_id")==null?"1":request.getParameter("park_id");
	
	String park_cont = request.getParameter("park_cont")==null?"":request.getParameter("park_cont");
	String ipgo = request.getParameter("ipgo")==null?"":request.getParameter("ipgo"); //입고일시
	int  car_km = request.getParameter("car_km")==null?0:AddUtil.parseDigit(request.getParameter("car_km")); // 주행거리
	String park_mng = request.getParameter("park_mng")==null?"":request.getParameter("park_mng"); // 담당자
	String car_no = request.getParameter("car_no")==null?"":request.getParameter("car_no");
	String car_nm = request.getParameter("car_nm")==null?"":request.getParameter("car_nm");
	String driver_nm	= request.getParameter("driver_nm")==null?"":request.getParameter("driver_nm");
	String users_comp	= request.getParameter("users_comp")==null?"":request.getParameter("users_comp");
	String car_st	= request.getParameter("car_st")==null?"":request.getParameter("car_st");
	
	//parking 테이블
	String car_mng_id	= request.getParameter("car_mng_id")==null?"":request.getParameter("car_mng_id");  //차량관리번호
	int serv_seq = request.getParameter("serv_seq")==null?1:Util.parseInt(request.getParameter("serv_seq"));  //점검횟수
	String serv_dt	= request.getParameter("serv_dt")==null?"":request.getParameter("serv_dt");  //점검일자

	String cmd	= request.getParameter("cmd")==null?"":request.getParameter("cmd");
	String use_yn = "";
	String car_key_cau = request.getParameter("car_key_cau")==null?"":request.getParameter("car_key_cau");
	
	//점검항목
	String e_oil	= request.getParameter("e_oil")==null?"":request.getParameter("e_oil");
	String cool_wt	= request.getParameter("cool_wt")==null?"":request.getParameter("cool_wt");
	String ws_wt	= request.getParameter("ws_wt")==null?"":request.getParameter("ws_wt");
	String e_clean	= request.getParameter("e_clean")==null?"":request.getParameter("e_clean");
	String out_clean	= request.getParameter("out_clean")==null?"":request.getParameter("out_clean");
	String tire_air		= request.getParameter("tire_air")==null?"":request.getParameter("tire_air");
	String tire_mamo	= request.getParameter("tire_mamo")==null?"":request.getParameter("tire_mamo");
	String lamp		= request.getParameter("lamp")==null?"":request.getParameter("lamp");
	String in_clean	= request.getParameter("in_clean")==null?"":request.getParameter("in_clean");
	String wiper	= request.getParameter("wiper")==null?"":request.getParameter("wiper");
	String car_sound	= request.getParameter("car_sound")==null?"":request.getParameter("car_sound");
	String panel	= request.getParameter("panel")==null?"":request.getParameter("panel");
	String front_bp	= request.getParameter("front_bp")==null?"":request.getParameter("front_bp");
	String back_bp	= request.getParameter("back_bp")==null?"":request.getParameter("back_bp");
	String lh_fhd	= request.getParameter("lh_fhd")==null?"":request.getParameter("lh_fhd");
	String lh_bhd	= request.getParameter("lh_bhd")==null?"":request.getParameter("lh_bhd");
	String lh_fdoor	= request.getParameter("lh_fdoor")==null?"":request.getParameter("lh_fdoor");
	String lh_bdoor	= request.getParameter("lh_bdoor")==null?"":request.getParameter("lh_bdoor");
	String rh_fhd	= request.getParameter("rh_fhd")==null?"":request.getParameter("rh_fhd");
	String rh_bhd	= request.getParameter("rh_bhd")==null?"":request.getParameter("rh_bhd");
	String rh_fdoor	= request.getParameter("rh_fdoor")==null?"":request.getParameter("rh_fdoor");
	String rh_bdoor	= request.getParameter("rh_bdoor")==null?"":request.getParameter("rh_bdoor");
	String energy	= request.getParameter("energy")==null?"":request.getParameter("energy");
	String goods1	= request.getParameter("goods1")==null?"":request.getParameter("goods1");
	String goods2	= request.getParameter("goods2")==null?"":request.getParameter("goods2");
	String goods3	= request.getParameter("goods3")==null?"":request.getParameter("goods3");
	String goods4	= request.getParameter("goods4")==null?"":request.getParameter("goods4");
	String goods5	= request.getParameter("goods5")==null?"":request.getParameter("goods5");
	String goods6	= request.getParameter("goods6")==null?"":request.getParameter("goods6");
	String goods7	= request.getParameter("goods7")==null?"":request.getParameter("goods7");
	String goods8	= request.getParameter("goods8")==null?"":request.getParameter("goods8");
	String goods9	= request.getParameter("goods9")==null?"":request.getParameter("goods9");
	String goods10	= request.getParameter("goods10")==null?"":request.getParameter("goods10");
	String goods11	= request.getParameter("goods11")==null?"":request.getParameter("goods11");
	String goods12	= request.getParameter("goods12")==null?"":request.getParameter("goods12");
	String goods13	= request.getParameter("goods13")==null?"":request.getParameter("goods13");
	String e_oil_ny	= request.getParameter("e_oil_ny")==null?"":request.getParameter("e_oil_ny");
	String cool_wt_ny	= request.getParameter("cool_wt_ny")==null?"":request.getParameter("cool_wt_ny_ny");
	String ws_wt_ny	= request.getParameter("ws_wt_ny")==null?"":request.getParameter("ws_wt_ny_ny");
	String e_clean_ny	= request.getParameter("e_clean_ny")==null?"":request.getParameter("e_clean_ny_ny");
	String out_clean_ny	= request.getParameter("out_clean_ny")==null?"":request.getParameter("out_clean_ny");
	String tire_air_ny		= request.getParameter("tire_air_ny")==null?"":request.getParameter("tire_air_ny");
	String tire_mamo_ny	= request.getParameter("tire_mamo_ny")==null?"":request.getParameter("tire_mamo_ny");
	String lamp_ny		= request.getParameter("lamp_ny")==null?"":request.getParameter("lamp_ny");
	String in_clean_ny	= request.getParameter("in_clean_ny")==null?"":request.getParameter("in_clean_ny");
	String wiper_ny	= request.getParameter("wiper_ny")==null?"":request.getParameter("wiper_ny");
	String car_sound_ny	= request.getParameter("car_sound_ny")==null?"":request.getParameter("car_sound_ny");
	String panel_ny	= request.getParameter("panel_ny")==null?"":request.getParameter("panel_ny");
	String front_bp_ny	= request.getParameter("front_bp_ny")==null?"":request.getParameter("front_bp_ny");
	String back_bp_ny	= request.getParameter("back_bp_ny")==null?"":request.getParameter("back_bp_ny");
	String lh_fhd_ny	= request.getParameter("lh_fhd_ny")==null?"":request.getParameter("lh_fhd_ny");
	String lh_bhd_ny	= request.getParameter("lh_bhd_ny")==null?"":request.getParameter("lh_bhd_ny");
	String lh_fdoor_ny	= request.getParameter("lh_fdoor_ny")==null?"":request.getParameter("lh_fdoor_ny");
	String lh_bdoor_ny	= request.getParameter("lh_bdoor_ny")==null?"":request.getParameter("lh_bdoor_ny");
	String rh_fhd_ny	= request.getParameter("rh_fhd_ny")==null?"":request.getParameter("rh_fhd_ny");
	String rh_bhd_ny	= request.getParameter("rh_bhd_ny")==null?"":request.getParameter("rh_bhd_ny");
	String rh_fdoor_ny	= request.getParameter("rh_fdoor_ny")==null?"":request.getParameter("rh_fdoor_ny");
	String rh_bdoor_ny	= request.getParameter("rh_bdoor_ny")==null?"":request.getParameter("rh_bdoor_ny");
	String energy_ny	= request.getParameter("energy_ny")==null?"":request.getParameter("energy_ny");
	String gita	= request.getParameter("gita")==null?"":request.getParameter("gita");
	String area = request.getParameter("area")==null?"":request.getParameter("area");
	String park = request.getParameter("park")==null?"":request.getParameter("park");
		
	int count = 0;
	int	count2 = 0;
	int cnt = 0;
	int seq = 0;
			
	boolean flag = true;

	boolean flag1 = true;
	
	
	
	String serv_id = "";
	String checker = ""; //점검자
	
	//realpark 정리 
	//if(park_id.equals("1") || park_id.equals("3") || park_id.equals("7") || park_id.equals("8")|| park_id.equals("4") || park_id.equals("9") || park_id.equals("11") || park_id.equals("12") || park_id.equals("13") || park_id.equals("14")){
		count2 = p_db.DeleteParkConditon(car_mng_id, park_id);	
	//}
	
	//기존 입/출고 데이터 정리 
	//if(park_id.equals("1") || park_id.equals("3") || park_id.equals("7") || park_id.equals("8")|| park_id.equals("4") || park_id.equals("9") || park_id.equals("11")|| park_id.equals("12") || park_id.equals("13") || park_id.equals("14")){
		Hashtable ht2 = p_db.getRentParkIOSearch2(car_mng_id);
		count2 = p_db.UpdateParkIO(String.valueOf(ht2.get("CAR_MNG_ID")));	
	//}
	
	ParkIOBean io_bean 	= new ParkIOBean();
						
	//차량입출고 table에 insert
	io_bean.setCar_mng_id(car_mng_id);
	io_bean.setPark_id(park_id);
	io_bean.setIo_gubun("2");  // 1:입고 2:출고
	io_bean.setReg_id(user_id);  //????
	io_bean.setCar_no(car_no);
	io_bean.setCar_nm(car_nm);
	io_bean.setIo_dt(serv_dt);    //입/출고일
	io_bean.setCar_km(car_km);
	io_bean.setPark_mng(park_mng);  //담당자
	io_bean.setCar_st(car_st);
	io_bean.setBr_id(br_id);
	io_bean.setDriver_nm(driver_nm);
	io_bean.setUsers_comp(users_comp);
	io_bean.setUse_yn("Y");
	io_bean.setStart_place(park_id);
	io_bean.setEnd_place(park);
	io_bean.setCar_key_cau(car_key_cau);	
	
	seq = p_db.insertParkIO(io_bean);  // 입출고 table 추가
	
	//parking table 에 insert
	pa_bean.setCar_mng_id(car_mng_id);
	pa_bean.setServ_seq(serv_seq);
	pa_bean.setServ_dt(serv_dt);
	pa_bean.setPark_id(park_id);
	
	pa_bean.setE_oil(e_oil);
	pa_bean.setCool_wt(cool_wt);
	pa_bean.setWs_wt(ws_wt);
	pa_bean.setE_clean(e_clean);
	pa_bean.setOut_clean(out_clean);
	pa_bean.setTire_air(tire_air);
	pa_bean.setTire_mamo(tire_mamo);
	pa_bean.setLamp(lamp);
	pa_bean.setIn_clean(in_clean);
	pa_bean.setWiper(wiper);
	pa_bean.setPanel(panel);
	pa_bean.setFront_bp(front_bp);
	pa_bean.setBack_bp(back_bp);
	pa_bean.setLh_fhd(lh_fhd);
	pa_bean.setLh_bhd(lh_bhd);
	pa_bean.setLh_fdoor(lh_fdoor);
	pa_bean.setLh_bdoor(lh_bdoor);
	pa_bean.setRh_fhd(rh_fhd);
	pa_bean.setRh_bhd(rh_bhd);
	pa_bean.setRh_fdoor(rh_fdoor);
	pa_bean.setRh_bdoor(rh_bdoor);
	pa_bean.setEnergy(energy);
	pa_bean.setCar_sound(car_sound);
	pa_bean.setGoods1(goods1);
	pa_bean.setGoods2(goods2);
	pa_bean.setGoods3(goods3);
	pa_bean.setGoods4(goods4);
	pa_bean.setGoods5(goods5);
	pa_bean.setGoods6(goods6);
	pa_bean.setGoods7(goods7);
	pa_bean.setGoods8(goods8);
	pa_bean.setGoods9(goods9);
	pa_bean.setGoods10(goods10);
	pa_bean.setGoods11(goods11);
	pa_bean.setGoods12(goods12);
	pa_bean.setGoods13(goods13);
	pa_bean.setE_oil_ny(e_oil_ny);
	pa_bean.setCool_wt_ny(cool_wt_ny);
	pa_bean.setWs_wt_ny(ws_wt_ny);
	pa_bean.setE_clean_ny(e_clean_ny);
	pa_bean.setOut_clean_ny(out_clean_ny);
	pa_bean.setTire_air_ny(tire_air_ny);
	pa_bean.setTire_mamo_ny(tire_mamo_ny);
	pa_bean.setLamp_ny(lamp_ny);
	pa_bean.setIn_clean_ny(in_clean_ny);
	pa_bean.setWiper_ny(wiper_ny);
	pa_bean.setPanel_ny(panel_ny);
	pa_bean.setFront_bp_ny(front_bp_ny);
	pa_bean.setBack_bp_ny(back_bp_ny);
	pa_bean.setLh_fhd_ny(lh_fhd_ny);
	pa_bean.setLh_bhd_ny(lh_bhd_ny);
	pa_bean.setLh_fdoor_ny(lh_fdoor_ny);
	pa_bean.setLh_bdoor_ny(lh_bdoor_ny);
	pa_bean.setRh_fhd_ny(rh_fhd_ny);
	pa_bean.setRh_bhd_ny(rh_bhd_ny);
	pa_bean.setRh_fdoor_ny(rh_fdoor_ny);
	pa_bean.setRh_bdoor_ny(rh_bdoor_ny);
	pa_bean.setEnergy_ny(energy_ny);
	pa_bean.setCar_sound_ny(car_sound_ny);
	pa_bean.setCar_km(car_km);
	pa_bean.setGita(gita);
	pa_bean.setArea(area);
	
	pa_bean.setReg_id(user_id);
	pa_bean.setGubun("2");
	pa_bean.setPark_seq(seq);
		
	count = p_db.insertParking(pa_bean); 
	
	//영남주차장에서 정비업체로 차가 나갈때 출고처리시 car_reg에 자량위치 변경.20140414
	if(park_id.equals("1")&&!park.equals("")){
		if (park.equals("0")) {
			park = "1";
		}
		count = rs_db.updateCarPark2(car_mng_id, park, "정비업체로 출고", user_id);
	}

%>
<script language='javascript'>
<% if(cmd.equals("d")){ 
	if(count > 0){ %>
alert('매각출고 삭제 처리되었습니다');
<%}%>
<%}else{%>
<%	if(count > 0){%>
		alert('정상적으로 처리되었습니다');
		parent.window.close();
		parent.opener.location.reload();
<%	}else{ //에러%>
		alert('처리되지 않았습니다\n\n에러발생!');
<%	}%>
<%}%>
</script>
</body>
</html>
