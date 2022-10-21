<%@ page language="java" contentType="text/html;charset=euc-kr" %>
<%@ page import="java.util.*, acar.util.*, acar.user_mng.*, acar.parking.*, acar.cus_reg.*"%>
<jsp:useBean id="pa_bean" scope="page" class="acar.parking.ParkingBean"/>  
<%@ include file="/acar/cookies.jsp" %>
<%
	//park_io 테이블
	int park_seq = request.getParameter("park_seq")==null?1:Util.parseInt(request.getParameter("park_seq"));
	String reg_id = request.getParameter("reg_id")==null?"":request.getParameter("reg_id");
	String io_gubun = request.getParameter("io_gubun")==null?"":request.getParameter("io_gubun");
	String car_st = request.getParameter("car_st")==null?"":request.getParameter("car_st");
	String car_nm = request.getParameter("car_nm")==null?"":request.getParameter("car_nm");
	String io_dt = request.getParameter("io_dt")==null?"":request.getParameter("io_dt");
	String io_sau = request.getParameter("io_sau")==null?"":request.getParameter("io_sau");
	String users_comp = request.getParameter("users_comp")==null?"":request.getParameter("users_comp");
	String start_place = request.getParameter("start_place")==null?"":request.getParameter("start_place");
	String end_place = request.getParameter("end_place")==null?"":request.getParameter("end_place");
	String driver_nm = request.getParameter("driver_nm")==null?"":request.getParameter("driver_nm");
	String br_id = request.getParameter("br_id")==null?"":request.getParameter("br_id");
	String park_mng = request.getParameter("park_mng")==null?"":request.getParameter("park_mng");
	String car_gita = request.getParameter("car_gita")==null?"":request.getParameter("car_gita");
	String car_key = request.getParameter("car_key")==null?"":request.getParameter("car_key");
	String car_key_cau = request.getParameter("car_key_cau")==null?"":request.getParameter("car_key_cau");
	
	//parking 테이블
	String car_mng_id	= request.getParameter("car_mng_id")==null?"":request.getParameter("car_mng_id");  //차량관리번호
	int serv_seq = request.getParameter("serv_seq")==null?0:Util.parseInt(request.getParameter("serv_seq"));  //점검횟수
	String serv_dt	= request.getParameter("serv_dt")==null?"":request.getParameter("serv_dt");  //점검일자
	String park_id	= request.getParameter("park_id")==null?"":request.getParameter("park_id");  //차고지
	int  car_km = request.getParameter("car_km")==null?0:AddUtil.parseDigit(request.getParameter("car_km")); // 주행거리
	String cmd	= request.getParameter("cmd")==null?"":request.getParameter("cmd");
	String car_no	= request.getParameter("car_no")==null?"":request.getParameter("car_no");
	
	
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
	String cool_wt_ny	= request.getParameter("cool_wt_ny")==null?"":request.getParameter("cool_wt_ny");
	String ws_wt_ny	= request.getParameter("ws_wt_ny")==null?"":request.getParameter("ws_wt_ny");
	String e_clean_ny	= request.getParameter("e_clean_ny")==null?"":request.getParameter("e_clean_ny");
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
	String area	= request.getParameter("area")==null?"":request.getParameter("area");
	
	int count = 0;
		
	LoginBean login = LoginBean.getInstance();
	String user_id = login.getCookieValue(request, "acar_id");	

	String ipgo = request.getParameter("ipgo")==null?"":request.getParameter("ipgo"); 	
			
	int cnt = 0;
			
	boolean flag = true;

	boolean flag1 = true;
		
	CusReg_Database cr_db = CusReg_Database.getInstance();
	String serv_id = "";
	String checker = ""; 
	//String serv_dt = ""; 	
	
	String c_id	="";
	String s_cd	="";
	
	int s=0; 

	ParkIODatabase piod = ParkIODatabase.getInstance();	

	if(cmd.equals("md")){ //매각출고차량 삭제

		count = piod.parking_del2(car_mng_id);
		System.out.println("[매각결정차량삭제 처음]");
		System.out.println("삭제한 매각출고차량관리번호: "+car_mng_id);		
		System.out.println("매각출고차량 삭제한 사람: "+user_id);
		System.out.println("[매각결정차량삭제 끝]");
		
		count = piod.DeleteParkConditon(car_mng_id, park_id);  // 실제park 삭제


	}else if(cmd.equals("d")){

		count = piod.parking_del(car_mng_id, serv_seq);
		
	}else if(cmd.equals("i")){  //점검 입력
		
			
		pa_bean.setCar_mng_id(car_mng_id);
		pa_bean.setServ_seq(serv_seq);
		pa_bean.setServ_dt(AddUtil.ChangeString(AddUtil.getDate()));
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
		pa_bean.setReg_id(user_id);
		pa_bean.setGubun("3");	
		pa_bean.setArea(area);	
		
		count = piod.insertParking(pa_bean);

		if ( car_km > 0 ) {
			// 차량정보
			
			CarInfoBean ci_bean = new CarInfoBean();
									
			ci_bean = cr_db.getCarInfo(car_mng_id);
	
			serv_id = cr_db.getServ_id(car_mng_id);
				
			ServInfoBean siBn = new ServInfoBean();
			
			siBn.setCar_mng_id(car_mng_id);
	
			siBn.setServ_id(serv_id);
			siBn.setRent_mng_id(ci_bean.getRent_mng_id());
			siBn.setRent_l_cd(ci_bean.getRent_l_cd());
			siBn.setServ_st("1");  //순회점검
			siBn.setServ_dt(serv_dt);
			siBn.setChecker(user_id);
			siBn.setSpdchk_dt(serv_dt);
			siBn.setTot_dist(String.valueOf(car_km));
			siBn.setReg_id(reg_id);
	
			count = cr_db.updateService(siBn);  //service에 주행거리 등록
			
		}

		cnt= cnt+count;
		s++;

	
	}else if(cmd.equals("mf")){
		

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
		pa_bean.setCar_key(car_key);
		pa_bean.setCar_key_cau(car_key_cau);
		
		count = piod.updateParking(pa_bean);	
			
	}



%>
<html>
<head>
<title>FMS</title>
</head>
<body leftmargin="15" >

<form name='form1' method='post'>
<input type="hidden" name="car_mng_id" 	value="<%=car_mng_id%>">
<input type="hidden" name="io_gubun" 	value="<%=io_gubun%>">
</form>
<script language='javascript'>
<!--
	var fm = document.form1;
<%if(cmd.equals("md")){%>
<%	if(count==1){
%>
		
	alert("삭제 되었습니다.");
	
<%}%>
<%}else if(cmd.equals("d")){%>
<%	if(count==1){
%>
		
	alert("삭제 되었습니다.");
	parent.parent.location='/fms2/park_home/parking_check_frame.jsp?car_mng_id=<%=car_mng_id%>&io_gubun=<%=io_gubun%>';
	
//	parent.opener.location.reload();
	
<%}%>
<%}else if(cmd.equals("i")){%>
<%	if(count==1){
%>
		alert("정상적으로 등록되었습니다.");
		parent.parent.location='/fms2/park_home/parking_check_frame.jsp?car_mng_id=<%=car_mng_id%>&io_gubun=<%=io_gubun%>';
<%}%>
<%}else if(cmd.equals("mf")){%>
<%	if(count==1){
%>
		alert("정상적으로 수정되었습니다.");
		parent.parent.location='/fms2/park_home/parking_check_frame.jsp?car_mng_id=<%=car_mng_id%>&io_gubun=<%=io_gubun%>';
<%}%>
<%}else{%>
	alert('에러가 발생!');
<%}%>

//-->

</script>
</body>
</html>
