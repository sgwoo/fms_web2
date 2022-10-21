<%@ page language="java" contentType="text/html; charset=euc-kr" %>
<%@ page import="java.util.*, acar.util.*, acar.car_register.*, acar.common.*, acar.cont.*, acar.res_search.*, acar.user_mng.*" %>
<jsp:useBean id="cr_bean" class="acar.car_register.CarRegBean" scope="page"/>
<jsp:useBean id="a_db" scope="page" class="acar.cont.AddContDatabase"/>
<jsp:useBean id="rs_db" scope="page" class="acar.res_search.ResSearchDatabase"/>
<jsp:useBean id="af_db" scope="page" class="acar.fee.AddFeeDatabase"/>
<%@ include file="/acar/cookies.jsp" %>

<%
	//자동차 등록/수정 처리 페이지
	
	String auth_rw = request.getParameter("auth_rw")==null?"":request.getParameter("auth_rw"); //권한
	String user_id = request.getParameter("user_id")==null?ck_acar_id:request.getParameter("user_id");
	String br_id = request.getParameter("br_id")==null?"":request.getParameter("br_id");
	
	String st 			= request.getParameter("st")==null?"":request.getParameter("st");
	String gubun 		= request.getParameter("gubun")==null?"":request.getParameter("gubun");
	String gubun_nm 	= request.getParameter("gubun_nm")==null?"":request.getParameter("gubun_nm");
	String q_sort_nm 	= request.getParameter("q_sort_nm")==null?"":request.getParameter("q_sort_nm");
	String q_sort 		= request.getParameter("q_sort")==null?"":request.getParameter("q_sort");
	String ref_dt1 		= request.getParameter("ref_dt1")==null?"":request.getParameter("ref_dt1");
	String ref_dt2 		= request.getParameter("ref_dt2")==null?"":request.getParameter("ref_dt2");

	String rent_mng_id 	= request.getParameter("rent_mng_id")==null?"":request.getParameter("rent_mng_id");
	String rent_l_cd 	= request.getParameter("rent_l_cd")==null?"":request.getParameter("rent_l_cd");
	String car_mng_id 	= request.getParameter("car_mng_id")==null?"":request.getParameter("car_mng_id");
	String cmd 			= request.getParameter("cmd")==null?"":request.getParameter("cmd");
	
	// 차량관리 > 차량등록관리 > 자동차관리에서 오는 경우와 영업관리 > 계출관리 > 납품준비상황에서 오는 경우를 구분짓기 위해 추가		2017. 11. 28
	String from_page = request.getParameter("from_page")==null?"":request.getParameter("from_page");
	
	String car_mng_id2 = "";
	int count=0;
	boolean flag4 = true;
	
	CommonDataBase c_db = CommonDataBase.getInstance();
	AddCarRegDatabase a_crd = AddCarRegDatabase.getInstance();
	MaMenuDatabase nm_db = MaMenuDatabase.getInstance();
	
	CarRegDatabase crd = CarRegDatabase.getInstance();
	cr_bean = crd.getCarRegBean(car_mng_id);
	
	cr_bean.setCar_mng_id		(car_mng_id);
	cr_bean.setInit_reg_dt	(request.getParameter("init_reg_dt")==null?"":AddUtil.ChangeDate2(request.getParameter("init_reg_dt")));//최초등록일
	cr_bean.setCar_no				(request.getParameter("car_no")==null?"":request.getParameter("car_no"));					//차량번호
	cr_bean.setCar_kd				(request.getParameter("car_kd")==null?"":request.getParameter("car_kd"));					//차종
	cr_bean.setCar_use			(request.getParameter("car_use")==null?"":request.getParameter("car_use"));					//용도
	cr_bean.setCar_nm				(request.getParameter("car_nm")==null?"":request.getParameter("car_nm"));					//차명
	cr_bean.setCar_form			(request.getParameter("car_form")==null?"":request.getParameter("car_form"));					//형식
	cr_bean.setCar_y_form		(request.getParameter("car_y_form")==null?"":request.getParameter("car_y_form"));				//연식
	cr_bean.setCar_num			(request.getParameter("car_num")==null?"":request.getParameter("car_num"));					//차대번호
	cr_bean.setMot_form			(request.getParameter("mot_form")==null?"":request.getParameter("mot_form"));					//원동기형식
	cr_bean.setDpm					(request.getParameter("dpm")==null?"":request.getParameter("dpm"));						//재원_배기량
	cr_bean.setTaking_p			(request.getParameter("taking_p")==null?0:AddUtil.parseDigit(request.getParameter("taking_p")));		//재원_승차정원
	cr_bean.setTire					(request.getParameter("tire")==null?"":request.getParameter("tire"));						//재원_타이어
	cr_bean.setFuel_kd			(request.getParameter("fuel_kd")==null?"":request.getParameter("fuel_kd"));					//재원_연료의종류
	cr_bean.setConti_rat		(request.getParameter("conti_rat")==null?"":request.getParameter("conti_rat"));					//재원_연비
	cr_bean.setMaint_st_dt	(request.getParameter("maint_st_dt")==null?"":request.getParameter("maint_st_dt"));				//검사유효기간1
	cr_bean.setMaint_end_dt	(request.getParameter("maint_end_dt")==null?"":request.getParameter("maint_end_dt"));				//검사유효기간2
	cr_bean.setFirst_car_no	(request.getParameter("first_car_no")==null?"":request.getParameter("first_car_no"));				//최초등록번호
	cr_bean.setCar_end_dt		(request.getParameter("car_end_dt")==null?"":request.getParameter("car_end_dt"));				//차량만료일
	cr_bean.setTest_st_dt		(request.getParameter("test_st_dt")==null?"":request.getParameter("test_st_dt"));				//점검유효기간1
	cr_bean.setTest_end_dt	(request.getParameter("test_end_dt")==null?"":request.getParameter("test_end_dt"));				//점검유효기간2
	cr_bean.setLoan_st			(request.getParameter("loan_st")==null?"":request.getParameter("loan_st"));					//등록수수료_공채구분
	cr_bean.setLoan_b_amt		(request.getParameter("loan_b_amt")==null?0:AddUtil.parseDigit(request.getParameter("loan_b_amt")));		//등록수수료_공채매입시
	cr_bean.setLoan_s_amt		(request.getParameter("loan_s_amt")==null?0:AddUtil.parseDigit(request.getParameter("loan_s_amt")));		//등록수수료_공채할인시
	cr_bean.setLoan_s_rat		(request.getParameter("loan_s_rat")==null?"":request.getParameter("loan_s_rat"));				//등록수수료_공채할인율
	cr_bean.setReg_amt			(request.getParameter("reg_amt")==null?0:AddUtil.parseDigit(request.getParameter("reg_amt")));			//등록수수료_등록세
	cr_bean.setAcq_amt			(request.getParameter("acq_amt")==null?0:AddUtil.parseDigit(request.getParameter("acq_amt")));			//등록수수료_취득세
	cr_bean.setNo_m_amt			(request.getParameter("no_m_amt")==null?0:AddUtil.parseDigit(request.getParameter("no_m_amt")));		//등록수수료_번호판제작비
	cr_bean.setStamp_amt		(request.getParameter("stamp_amt")==null?0:AddUtil.parseDigit(request.getParameter("stamp_amt")));		//등록수수료_증인지대
	cr_bean.setEtc					(request.getParameter("etc")==null?0:AddUtil.parseDigit(request.getParameter("etc")));				//등록수수료_기타
	cr_bean.setReg_dt				(request.getParameter("reg_dt")==null?"":request.getParameter("reg_dt"));					//작성일자
	cr_bean.setReg_nm				(request.getParameter("reg_nm")==null?"":request.getParameter("reg_nm"));					//작성자
	cr_bean.setGuar_gen_y		(request.getParameter("guar_gen_y")==null?"":request.getParameter("guar_gen_y"));				//일반성보증(연)
	cr_bean.setGuar_gen_km	(request.getParameter("guar_gen_km")==null?"":request.getParameter("guar_gen_km"));				//일반성보증(km)
	cr_bean.setGuar_endur_y	(request.getParameter("guar_endur_y")==null?"":request.getParameter("guar_endur_y"));				//내구성보증(연)
	cr_bean.setGuar_endur_km(request.getParameter("guar_endur_km")==null?"":request.getParameter("guar_endur_km"));				//내구성보증(km)
	cr_bean.setCar_ext			(request.getParameter("car_ext")==null?"":request.getParameter("car_ext"));					//지역
	cr_bean.setCar_doc_no		(request.getParameter("car_doc_no")==null?"":request.getParameter("car_doc_no"));				//관리번호
	cr_bean.setReg_pay_dt		(request.getParameter("reg_pay_dt")==null?"":request.getParameter("reg_pay_dt"));				//등록비지출일
	cr_bean.setMax_kg				(request.getParameter("max_kg")==null?"":request.getParameter("max_kg"));					//최대적재량
	cr_bean.setReg_amt_card	(request.getParameter("reg_amt_card")==null?"N":request.getParameter("reg_amt_card"));				//등록세카드결재여부
	cr_bean.setNo_amt_card	(request.getParameter("no_amt_card")==null?"N":request.getParameter("no_amt_card"));				//등록세카드결재여부
	cr_bean.setGps					(request.getParameter("gps")==null?"N":request.getParameter("gps"));						//GPS장착여부
	cr_bean.setImport_car_amt(request.getParameter("import_car_amt")==null?0:AddUtil.parseDigit(request.getParameter("import_car_amt")));	//수입차_과세가격
	cr_bean.setImport_tax_amt(request.getParameter("import_tax_amt")==null?0:AddUtil.parseDigit(request.getParameter("import_tax_amt")));	//수입차_관세
	cr_bean.setImport_tax_dt(request.getParameter("import_tax_dt")==null?"":request.getParameter("import_tax_dt"));				//수입차_관세신고일자
	cr_bean.setImport_spe_tax_amt(request.getParameter("import_spe_tax_amt")==null?0:AddUtil.parseDigit(request.getParameter("import_spe_tax_amt")));	//수입차_개별소비세
	cr_bean.setCar_end_yn		(request.getParameter("car_end_yn")==null?"":request.getParameter("car_end_yn"));						//차령2회연장여부
	//cr_bean.setAcq_amt_card		(request.getParameter("acq_amt_card")==null?"":request.getParameter("acq_amt_card"));			//취득세결재 신용카드 사용 여부		2017.12.13
	cr_bean.setAcq_amt_card		(request.getParameter("reg_amt_card")==null?"":request.getParameter("reg_amt_card"));			//취득세결재 신용카드 사용 여부	= 등록세카드결재여부 20210531
	cr_bean.setCar_length(request.getParameter("car_length")==null?0:AddUtil.parseDigit(request.getParameter("car_length")));	//제원-길이
	cr_bean.setCar_width(request.getParameter("car_width")==null?0:AddUtil.parseDigit(request.getParameter("car_width")));	//제원-너비
	
	cr_bean.setUpdate_id	(user_id);	
	
	System.out.println("cmd >>>>" + cmd);
	if(cmd.equals("i")){
	
		cr_bean.setAcq_is_o("["+c_db.getNameByIdCode("0032", "", cr_bean.getCar_ext())+"]");
		cr_bean.setAcq_is_p(cr_bean.getAcq_is_o());
		
		car_mng_id = a_crd.insertCarReg(cr_bean, rent_mng_id, rent_l_cd);
		
		if(!car_mng_id.equals("")) count =1;
		
		car_mng_id2 = a_crd.getCar_mng_id2(rent_mng_id, rent_l_cd);
		
		if(!car_mng_id.equals("") && !car_mng_id2.equals("") && car_mng_id2.substring(0,1).equals("A")){//가번호로 되어 있으면 할부정보 수정		
			count = a_crd.updateAllotCar(car_mng_id, car_mng_id2, rent_mng_id, rent_l_cd);
			
			String car_mng_id3 = a_crd.getCar_mng_id3(car_mng_id2);
			
			if(!car_mng_id3.equals("")){//가번호로 할부스케줄이 있으면 
				count = a_crd.updateAllotCar2(car_mng_id, car_mng_id2, rent_mng_id, rent_l_cd);
			}
		}else{
			count = 1;
		}
		
		//계약기본정보
		ContBaseBean base = a_db.getCont(rent_mng_id, rent_l_cd);
		
		//car_pur
		ContPurBean pur = a_db.getContPur(rent_mng_id, rent_l_cd);
		pur.setCar_num		(cr_bean.getCar_num());
		flag4 = a_db.updateContPur(pur);
		
		//자산양수차 차량정비 예약 등록
		if(base.getCar_gu().equals("2")){
			RentContBean rc_bean = new RentContBean();
			rc_bean.setCar_mng_id			(car_mng_id);
			rc_bean.setRent_st				("6");
			rc_bean.setBus_id					(user_id);
			rc_bean.setRent_start_dt	(AddUtil.getDate()+"0000");
			rc_bean.setEtc						("자산양수차 명의이전 등록 및 재리스 정비중");
			String deli_plan_dt = AddUtil.getDate();
			//1영업일+
			deli_plan_dt = af_db.getValidDt(c_db.addDay(deli_plan_dt, 1));
			//2영업일+
			deli_plan_dt = af_db.getValidDt(c_db.addDay(deli_plan_dt, 1));
			//3영업일+
			deli_plan_dt = af_db.getValidDt(c_db.addDay(deli_plan_dt, 1));
			//4영업일+
			deli_plan_dt = af_db.getValidDt(c_db.addDay(deli_plan_dt, 1));
			//5영업일+
			deli_plan_dt = af_db.getValidDt(c_db.addDay(deli_plan_dt, 1));
			rc_bean.setDeli_plan_dt		(deli_plan_dt+"0000");
			rc_bean.setUse_st					("1");
			rc_bean.setReg_id					(nm_db.getWorkAuthUser("본사관리팀장"));
			rc_bean = rs_db.insertRentCont(rc_bean);
		}
		
	}else if(cmd.equals("u")){
		count = crd.updateCarMain(cr_bean);
	}
%>
<html>
<head>
<title>FMS</title>
<meta http-equiv="Content-Type" content="text/html; charset=euc-kr">
<link rel="stylesheet" type="text/css" href="/include/table_t.css"></link>
<script language="JavaScript">
<!--
	function NullAction(){	
	<%	if(cmd.equals("u")){
  			if(count!=0){%>
 	  			alert("정상적으로 수정되었습니다.");
	 	  		var theForm = document.form2;
  				//theForm.target="c_body";
  				theForm.target="d_content";
  				theForm.action="./register_frame.jsp";
	  			theForm.submit();
	<%		}else{%>
 	  			alert("수정 오류!");
	<%		}
		}else{
			if(count!=0){%>
  				alert("정상적으로 등록되었습니다.");
	  			var theForm = document.form2;
		  		//theForm.target="c_body";
		  		theForm.target="d_content";
		  		theForm.action="./register_frame.jsp";
			  	theForm.submit();
	<%		}else{%>
   					alert("등록 오류!");
	<%		}
		}%>
	}
//-->
</script>
</head>
<body onLoad="javascript:NullAction()">
<form name="form1" method="post"><!-- action="./register_s_frame.jsp" -->
<input type="hidden" name="cmd" valaue="nd">
</form>
<form action="./register_main_u.jsp" name="form2" method="post">
<input type="hidden" name="auth_rw" value="<%=auth_rw%>">
<input type="hidden" name="user_id" value="<%=user_id%>">
<input type="hidden" name="br_id" value="<%=br_id%>">
<input type="hidden" name="st" value="<%=st%>">
<input type="hidden" name="gubun" value="<%=gubun%>">
<input type="hidden" name="gubun_nm" value="<%=gubun_nm%>">
<input type="hidden" name="q_sort_nm" value="<%=q_sort_nm%>">
<input type="hidden" name="q_sort" value="<%=q_sort%>">
<input type="hidden" name="ref_dt1" value="<%=ref_dt1%>">
<input type="hidden" name="ref_dt2" value="<%=ref_dt2%>">
<input type="hidden" name="rent_mng_id" value="<%=rent_mng_id%>">
<input type="hidden" name="rent_l_cd" value="<%=rent_l_cd%>">
<input type="hidden" name="car_mng_id" value="<%=car_mng_id%>">
<input type="hidden" name="cmd" value="ud">

<input type="hidden" name="from_page" value="<%=from_page%>">
</form>
</body>
</html>
