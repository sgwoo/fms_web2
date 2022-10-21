<%@ page language="java" contentType="text/html;charset=euc-kr" %>
<%@ page import="java.util.*"%>
<%@ page import="acar.cont.*"%>
<%@ page import="acar.util.*"%>
<%@ page import="acar.common.*, acar.car_mst.*, acar.car_register.*"%>
<jsp:useBean id="a_db" scope="page" class="acar.cont.AddContDatabase"/>
<jsp:useBean id="shDb" class="acar.secondhand.SecondhandDatabase" scope="page"/>
<jsp:useBean id="cr_bean" class="acar.car_register.CarRegBean" scope="page"/>
<%@ include file="/acar/cookies.jsp" %>

<html>
<head><title>FMS</title>
</head>
<meta http-equiv="content-type" content="text/html; charset=euc-kr">
<link rel=stylesheet type="text/css" href="/include/table.css">
<body leftmargin="15">
<script language='javascript'>

<%
	//기존차량 선택시 셋팅 처리 페이지
	
	String taecha		= request.getParameter("taecha")==null?"":request.getParameter("taecha");
	String car_st 		= request.getParameter("car_st")==null?"":request.getParameter("car_st");
	String car_cd 		= request.getParameter("car_cd")==null?"":request.getParameter("car_cd");
	String from_page 	= request.getParameter("from_page")==null?"":request.getParameter("from_page");
	String rent_dt	 	= request.getParameter("rent_dt")==null?"":request.getParameter("rent_dt");
	String car_gu	 	= request.getParameter("car_gu")==null?"":request.getParameter("car_gu");
	
	String rent_mng_id 	= request.getParameter("rent_mng_id");
	String rent_l_cd 	= request.getParameter("rent_l_cd");
	String car_comp_id 	= request.getParameter("car_comp_id");
	String car_mng_id 	= request.getParameter("car_mng_id");
	String car_no 		= request.getParameter("car_no");
	String car_nm 		= request.getParameter("car_nm");
	String car_name 	= request.getParameter("car_name");
	
	CommonDataBase c_db = CommonDataBase.getInstance();
	AddCarMstDatabase cmb = AddCarMstDatabase.getInstance();
	CarRegDatabase crd = CarRegDatabase.getInstance();
	
	//자동차기초정보
	ContCarBean car = a_db.getContCar(rent_mng_id, rent_l_cd);
	
	//계약기타정보
	ContEtcBean cont_etc = a_db.getContEtc(rent_mng_id, rent_l_cd);
		
	//자동차회사코드
	CodeBean c_bean = c_db.getCodeBean("0001",car_comp_id,"");
	//자동차기본정보
	CarMstBean cm_bean = cmb.getCarNmCase(String.valueOf(car.getCar_id()), String.valueOf(car.getCar_seq()));
	//자동차등록정보
	cr_bean = crd.getCarRegBean(car_mng_id);
		
%>

	var fm = parent.opener.form1;
	
	<%if(taecha.equals("Y")){%>
	
		fm.tae_car_mng_id.value			='<%=car_mng_id%>';	
		fm.tae_car_no.value			='<%=car_no%>';
		fm.tae_car_nm.value			='<%=car_nm%>';
		fm.tae_init_reg_dt.value		='<%=cr_bean.getInit_reg_dt()%>';		
		fm.tae_car_id.value			='<%=car.getCar_id()%>';	
		fm.tae_car_seq.value			='<%=car.getCar_seq()%>';			
		
		
		
	<%}else{%>
	
		fm.old_rent_mng_id.value		='<%=rent_mng_id%>';	
		fm.old_rent_l_cd.value			='<%=rent_l_cd%>';
		fm.car_mng_id.value			='<%=car_mng_id%>';	
		fm.car_no.value				='<%=car_no%>';
		
		if(<%=c_bean.getApp_st()%> == '1'){
			fm.car_origin.value 		= '1';
			fm.car_origin_nm.value 		= '국산';
		}else{
			fm.car_origin.value 		= '2';
			fm.car_origin_nm.value 		= '수입';
		}
	
		fm.car_comp_id.value			='<%=car_comp_id%>';
		fm.car_comp_nm.value			='<%=car.getCar_comp_nm()%>';
		fm.con_cd3.value			='<%=c_bean.getNm_cd()%>';
	
		fm.code.value				='<%=cm_bean.getCode()%>';
		fm.car_nm.value				='<%=car_nm%>';
		fm.con_cd4.value			='<%=cm_bean.getCar_cd()%>'; 	
	
		fm.car_id.value				='<%=car.getCar_id()%>';	
		fm.car_seq.value			='<%=car.getCar_seq()%>';	
		fm.car_name.value			='<%=car_name%>';	
		fm.car_amt.value			='<%=AddUtil.parseDecimal(car.getCar_cs_amt()+car.getCar_cv_amt())%>';
		fm.car_s_amt.value			='<%=AddUtil.parseDecimal(car.getCar_cs_amt())%>';
		fm.car_v_amt.value			='<%=AddUtil.parseDecimal(car.getCar_cv_amt())%>';
	
		fm.opt.value				='<%=car.getOpt()%>';
		fm.opt_seq.value			='<%=car.getOpt_code()%>';
		fm.opt_amt.value			='<%=AddUtil.parseDecimal(car.getOpt_cs_amt()+car.getOpt_cv_amt())%>';
		fm.opt_s_amt.value			='<%=AddUtil.parseDecimal(car.getOpt_cs_amt())%>';
		fm.opt_v_amt.value			='<%=AddUtil.parseDecimal(car.getOpt_cv_amt())%>';
	
		fm.col.value				='<%=car.getColo()%>';	
		fm.col_amt.value			='<%=AddUtil.parseDecimal(car.getClr_cs_amt()+car.getClr_cv_amt())%>';
		fm.col_s_amt.value			='<%=AddUtil.parseDecimal(car.getClr_cs_amt())%>';
		fm.col_v_amt.value			='<%=AddUtil.parseDecimal(car.getClr_cv_amt())%>';
		fm.in_col.value				='<%=car.getIn_col()%>';	
		
		// 재리스, 월렌트에서 첨단 장치 정보를 넘겨준다 2017.11.16
		fm.lkas_yn.value			='<%=cont_etc.getLkas_yn()%>';
		fm.ldws_yn.value			='<%=cont_etc.getLdws_yn()%>';
		fm.aeb_yn.value				='<%=cont_etc.getAeb_yn()%>';
		fm.fcw_yn.value				='<%=cont_etc.getFcw_yn()%>';
		// 월렌트에서 전기차 여부 정보를 넘겨준다 2017.11.22
		fm.ev_yn.value				='<%=cont_etc.getEv_yn()%>';
		fm.hook_yn.value			='<%=cont_etc.getHook_yn()%>';
		fm.others_device.value		='<%=cont_etc.getOthers_device()%>';
		fm.top_cng_yn.value			='<%=cont_etc.getTop_cng_yn()%>';
		
		fm.o_1.value				='<%=AddUtil.parseDecimal(car.getCar_cs_amt()+car.getCar_cv_amt()+car.getOpt_cs_amt()+car.getOpt_cv_amt()+car.getClr_cs_amt()+car.getClr_cv_amt())%>';
		fm.o_1_s_amt.value			='<%=AddUtil.parseDecimal(car.getCar_cs_amt()+car.getOpt_cs_amt()+car.getClr_cs_amt())%>';	
		fm.o_1_v_amt.value			='<%=AddUtil.parseDecimal(car.getCar_cv_amt()+car.getOpt_cv_amt()+car.getClr_cv_amt())%>';		
		
		<%	if(from_page.equals("")){%>
		fm.car_use.value			='<%=cr_bean.getCar_use()%>';
		<%	}%>
		
		
		
		//재리스차량 개시전 변경시 변경차량으로 중고차가 계산
		<%	if(from_page.equals("/fms2/lc_rent/lc_cng_car_frame.jsp")){
				
				Hashtable sh_ht = new Hashtable();
				Hashtable sh_ht2 = new Hashtable();
				Hashtable carOld = new Hashtable();
				
				if(rent_dt.equals("")) rent_dt = AddUtil.replace(AddUtil.getDate(),"-","");
				
				//재리스차량기본정보테이블
				Hashtable ht = shDb.getShBase(car_mng_id);
				
				//차량정보-여러테이블 조인 조회
				Hashtable ht2 = ht2 = shDb.getBase(car_mng_id, rent_dt);
				
				if(String.valueOf(ht.get("CAR_MNG_ID")).equals("null")){
					ht2.put("REG_ID", 			ck_acar_id);
					ht2.put("SECONDHAND_DT", 	rent_dt);
					//sh_base table insert
					int count = shDb.insertShBase(ht2);
				}else{
					int chk = 0;
					if(!String.valueOf(ht2.get("SECONDHAND_DT")).equals(rent_dt)) 										chk++;
					if(!String.valueOf(ht2.get("BEFORE_ONE_YEAR")).equals(String.valueOf(ht.get("BEFORE_ONE_YEAR")))) 	chk++;
					if(!String.valueOf(ht2.get("SERV_DT")).equals(String.valueOf(ht.get("SERV_DT")))) 					chk++;
					if(!String.valueOf(ht2.get("TOT_DIST")).equals(String.valueOf(ht.get("TOT_DIST")))) 				chk++;
					if(!String.valueOf(ht2.get("TODAY_DIST")).equals(String.valueOf(ht.get("TODAY_DIST")))) 			chk++;
					if(!String.valueOf(ht2.get("PARK")).equals(String.valueOf(ht.get("PARK")))) 						chk++;
					if(chk >0){
						ht2.put("SECONDHAND_DT", rent_dt);
						//sh_base table update
						int count = shDb.updateShBase(ht2);
					}
				}
				
				//차량정보
				sh_ht = shDb.getShBase(car_mng_id);
				//차량등록 경과기간(차령)
				carOld 	= c_db.getOld(String.valueOf(sh_ht.get("INIT_REG_DT")));
				//차량정보
				sh_ht2 = shDb.getBase(car_mng_id, rent_dt, (String)sh_ht.get("SERV_DT"));
			%>
			
			fm.sh_car_amt.value		= '<%=AddUtil.parseDecimal(AddUtil.parseInt((String)sh_ht.get("CAR_AMT"))+AddUtil.parseInt((String)sh_ht.get("OPT_AMT"))+AddUtil.parseInt((String)sh_ht.get("COL_AMT")))%>';		
			fm.sh_year.value		= '<%if(!String.valueOf(carOld.get("YEAR")).equals("null")){%><%=carOld.get("YEAR")%><%}%>';
			fm.sh_month.value		= '<%if(!String.valueOf(carOld.get("YEAR")).equals("null")){%><%=carOld.get("MONTH")%><%}%>';
			fm.sh_day.value			= '<%if(!String.valueOf(carOld.get("YEAR")).equals("null")){%><%=carOld.get("DAY")%><%}%>';
			fm.sh_init_reg_dt.value	= '<%=AddUtil.ChangeDate2(cr_bean.getInit_reg_dt())%>';
			fm.sh_km.value			= '<%= AddUtil.parseDecimal((String)sh_ht2.get("TODAY_DIST")) %>';
			fm.sh_tot_km.value		= '<%= AddUtil.parseDecimal((String)sh_ht.get("TOT_DIST")) %>';
			fm.sh_km_bas_dt.value	= '<%= AddUtil.ChangeDate2((String)sh_ht.get("SERV_DT")) %>';
			
			var sh_form = parent.opener.sh_form;
			sh_form.car_mng_id.value	='<%=car_mng_id%>';	
			parent.opener.getSecondhandCarAmt_h();
			
		<%	}%>
		
	
	<%}%>
	
	parent.close();
	
</script>
</body>
</html>
