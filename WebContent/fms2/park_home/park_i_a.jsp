<%@ page language="java" contentType="text/html;charset=euc-kr" %>
<%@ page import="java.util.*, acar.util.*, acar.user_mng.*, acar.parking.*, acar.cus_reg.*, acar.car_service.*, acar.car_register.*"%>
<jsp:useBean id="pa_bean" scope="page" class="acar.parking.ParkingBean"/>  
<jsp:useBean id="pio_bean" scope="page" class="acar.parking.ParkIOBean"/> 
<jsp:useBean id="pbean" scope="page" class="acar.parking.ParkBean"/> 
<jsp:useBean id="cr_bean"   class="acar.car_register.CarRegBean"       scope="page"/>
<%@ include file="/acar/cookies.jsp" %>
<%
	CarRegDatabase crd 	= CarRegDatabase.getInstance();
	
	//park_io 테이블 운전자 정보등이 입력됨
	int park_seq = request.getParameter("park_seq")==null?1:Util.parseInt(request.getParameter("park_seq"));
	String reg_id = request.getParameter("reg_id")==null?"":request.getParameter("reg_id");
	String io_gubun = request.getParameter("io_gubun")==null?"1":request.getParameter("io_gubun");
	String car_st = request.getParameter("car_st")==null?"":request.getParameter("car_st");
	String car_nm = request.getParameter("car_nm")==null?"":request.getParameter("car_nm");
	String io_dt = request.getParameter("io_dt")==null?"":request.getParameter("io_dt"); //입출고일시
	String io_sau = request.getParameter("io_sau")==null?"":request.getParameter("io_sau"); //입출고일시
	String users_comp = request.getParameter("users_comp")==null?"":request.getParameter("users_comp");
	String driver_nm = request.getParameter("driver_nm")==null?"":request.getParameter("driver_nm");
	String br_id = request.getParameter("br_id")==null?"":request.getParameter("br_id");
	String park_mng = request.getParameter("park_mng")==null?"":request.getParameter("park_mng");
	String new_car = request.getParameter("new_car")==null?"":request.getParameter("new_car");
	String mng_id = request.getParameter("mng_id")==null?"":request.getParameter("mng_id");
	String firm_nm = request.getParameter("firm_nm")==null?"":request.getParameter("firm_nm");
		
	if(new_car.equals("YC")){  //신차 입고등록시 
		car_st = "9";			// 9= 신차
	}
	
	//parking 테이블 - 점검사항이 입력됨
	String car_mng_id	= request.getParameter("car_mng_id")==null?"":request.getParameter("car_mng_id");  //차량관리번호
	int serv_seq = request.getParameter("serv_seq")==null?1:Util.parseInt(request.getParameter("serv_seq"));  //점검횟수
	String serv_dt	= request.getParameter("serv_dt")==null?"":request.getParameter("serv_dt");  //점검일자
	String park_id	= request.getParameter("park_id")==null?"":request.getParameter("park_id");  //차고지
	int  car_km = request.getParameter("car_km")==null?0:AddUtil.parseDigit(request.getParameter("car_km")); // 주행거리
	String cmd	= request.getParameter("cmd")==null?"":request.getParameter("cmd");
	String car_no	= request.getParameter("car_no")==null?"":request.getParameter("car_no");
	String area = request.getParameter("area")==null?"":request.getParameter("area");	
	String car_key = request.getParameter("car_key")==null?"":request.getParameter("car_key");
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
	String use_yn = "";
	
	String rent_mng_id = request.getParameter("rent_mng_id")==null?"":request.getParameter("rent_mng_id");
	String rent_l_cd = request.getParameter("rent_l_cd")==null?"":request.getParameter("rent_l_cd");

	int count = 0;
	int count2 = 0;
	
	LoginBean login = LoginBean.getInstance();
	String user_id = login.getCookieValue(request, "acar_id");	

	String ipgo = request.getParameter("ipgo")==null?"":request.getParameter("ipgo"); 		
	
	int cnt = 0;
	int seq = 0;
				
	boolean flag = true;

	boolean flag1 = true;
		
	CusReg_Database cr_db = CusReg_Database.getInstance();
	CarServDatabase    	csD 	= CarServDatabase.getInstance();
	
	String serv_id = "";
	String checker = ""; 
		
	int s=0; 

	int d_cnt = 0;
    
	ParkIODatabase piod = ParkIODatabase.getInstance();		
		
	//기존 입출고 데이터 정리
	Hashtable ht2 = piod.getRentParkIOSearch2(car_mng_id);
	count2 = piod.UpdateParkIO(String.valueOf(ht2.get("CAR_MNG_ID")));	

  //차량중복이 되는지 확인한다. - 전체로 놓고보면 중복될 소지 있음 
  d_cnt = piod.getRentReseach(car_mng_id);
  
	//기존 보유차에 없다면 (주차장에 차가 없다면 : 보유차이면서 대차등이 나간 경우) 
  if ( car_mng_id.equals("") ) {
    //새로운 임시 car_mng_id 
	  car_mng_id = piod.getNewCarMngId();  //출고는 되어있으나, 차량등록이 안되어 있는 경우 처리
	  car_st = "9";			// 9= 신차	
	}  
	  
  pio_bean.setCar_mng_id(car_mng_id);
  pio_bean.setPark_seq(park_seq);
	pio_bean.setPark_id(park_id);
	pio_bean.setEnd_place(park_id);
	pio_bean.setReg_id(reg_id);
	pio_bean.setIo_gubun("1");
	pio_bean.setCar_st(car_st);
	pio_bean.setCar_no(car_no);
	pio_bean.setCar_nm(car_nm);
	pio_bean.setCar_km(car_km);
	pio_bean.setIo_dt(io_dt);
	pio_bean.setUsers_comp(users_comp);
	pio_bean.setDriver_nm(driver_nm);
	pio_bean.setPark_mng(park_mng);
	pio_bean.setBr_id(br_id);
	pio_bean.setRent_l_cd(rent_l_cd);
	pio_bean.setCar_key_cau(car_key_cau);	
	if( d_cnt <  1 ){
		pio_bean.setUse_yn("Y");
	} else  {
		pio_bean.setUse_yn("N");
	}
	seq = piod.insertParkIO(pio_bean);
		
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
	pa_bean.setReg_id(user_id);
	pa_bean.setGubun(io_gubun);
	pa_bean.setPark_seq(seq);
	pa_bean.setArea(area);	
	pa_bean.setCar_key(car_key);
	pa_bean.setCar_key_cau(car_key_cau);
	
	count = piod.insertParking(pa_bean);  //점검리스트
	
	if ( car_mng_id.equals("") ||  car_mng_id.substring(0,1).equals("X") ) {
	} else {
		if ( car_km > 20  ) {  
			// 차량정보
			CarInfoBean ci_bean = cr_db.getCarInfo(car_mng_id);
			ServiceBean siBn = new ServiceBean();
			if ( !ci_bean.getRent_mng_id().equals("") ) {
				siBn.setCar_mng_id	(car_mng_id);
				siBn.setRent_mng_id	(ci_bean.getRent_mng_id());
				siBn.setRent_l_cd		(ci_bean.getRent_l_cd());
				siBn.setServ_st			("1");  //순회점검
				siBn.setServ_dt			(io_dt);
				siBn.setChecker			(reg_id);
				siBn.setSpdchk_dt		(io_dt);
				siBn.setTot_dist		(Integer.toString(car_km));
				siBn.setReg_id			(reg_id);
				serv_id = csD.insertService(siBn);
			}	
		}
		cnt= cnt+count;
		s++;
  }
  
  //차량현위치를 입고주차장으로 변경한다.
  cr_bean = crd.getCarRegBean(car_mng_id);
  if (!park_id.equals(cr_bean.getPark())){ 
		count2 = piod.UpdateCarRegPark(car_mng_id, park_id);
	}
  
  // 주자장 보유차 데이터 정리 - 입고된건 중복 확인 등 한번더 - 반차가 주차장입고전에 처리되어 해당차의 소재지가 주차장인경우 입고시 데이타는 'N'로 처리, 기타사유인 경우 입고가능토록
	if (car_st.equals("2")) {  //예비차중에
		Hashtable ht3 = piod.getRentReseach2(car_mng_id);
		if(!String.valueOf(ht3.get("CAR_MNG_ID")).equals("")&&!String.valueOf(ht3.get("CAR_MNG_ID")).equals("null")){//반차처리가 안된 차량일경우 패스
			if ( park_id.equals(String.valueOf(ht3.get("PARK")) ) )  { 
				count2 = piod.UpdateParkIO(String.valueOf(ht3.get("CAR_MNG_ID")));	
			}	
		}
	}	
		  
	//중복인 경우 삭제 후 등록
	int dup_cnt = piod.chkParkCondition(car_mng_id, park_id);
	if (dup_cnt  > 0 ) { 
		count = piod.DeleteParkConditon(car_mng_id, park_id);  // 실제park 삭제  
  }
	  
 	// park condition에 insert		
	pbean.setRent_l_cd(rent_l_cd);
	pbean.setCar_mng_id(car_mng_id);
  pbean.setCar_no(car_no);
	pbean.setCar_nm(car_nm);		
	pbean.setPark_id(park_id);
	pbean.setCar_st(car_st);  //신차표시 포함
	pbean.setCar_km(car_km);
	pbean.setIo_gubun("1");
	pbean.setReg_id(reg_id);
	pbean.setIo_dt(io_dt);
	pbean.setIo_sau(io_sau);
	pbean.setMng_id(mng_id);
	pbean.setDriver_nm(driver_nm);
	pbean.setUse_yn("Y");
	pbean.setArea(area);				
	pbean.setFirm_nm(firm_nm);
	pbean.setUser_nm(users_comp);			
	pbean.setCar_key(car_key);
	count = piod.insertParkCondition(pbean);
  

%>
<html>
<head>
<title>FMS</title>
</head>
<body leftmargin="15" >

<form name='form1' method='post'>
<input type="hidden" name="car_mng_id" 	value="<%=car_mng_id%>">

<input type="hidden" name="car_no" 	value="<%=car_no%>">
</form>
<script language='javascript'>
<!--
	var fm = document.form1;
	
<%	if(count==1 ){ %>
		
		alert("정상적으로 등록되었습니다.");
		
		parent.window.close();
		parent.opener.location.reload();

<%}else{%>

		alert('에러가 발생=차량이 있습니다.!!!');
		parent.window.document.getElementById("loader").style.visibility="hidden";
<%}%>
//-->

</script>
</body>
</html>
