<%@ page language="java" contentType="text/html; charset=euc-kr" %>
<%@ page import="java.util.*, java.io.*, acar.util.*, acar.common.*, acar.estimate_mng.*, acar.car_mst.*, acar.con_ins.*,acar.cont.*, acar.car_register.*, acar.short_fee_mng.*, acar.res_search.*" %>
<jsp:useBean id="bean" class="acar.estimate_mng.EstimateBean" scope="page"/>
<jsp:useBean id="cm_bean" class="acar.car_mst.CarMstBean" scope="page"/>
<jsp:useBean id="a_db" scope="page" class="acar.cont.AddContDatabase"/>
<jsp:useBean id="cr_bean"   class="acar.car_register.CarRegBean"       scope="page"/>
<jsp:useBean id="sfm_db" scope="page" class="acar.short_fee_mng.ShortFeeMngDatabase"/>
<jsp:useBean id="rs_db" scope="page" class="acar.res_search.ResSearchDatabase"/>
<%@ include file="/acar/cookies.jsp" %>


<%
	//사고 휴대차료 등록시 대여요금 조회
	
	String rent_mng_id	= request.getParameter("rent_mng_id")==null?"":request.getParameter("rent_mng_id");
	String rent_l_cd	= request.getParameter("rent_l_cd")==null?"":request.getParameter("rent_l_cd");
	String user_id 		= request.getParameter("user_id")==null?"":request.getParameter("user_id");	
	
	String ins_req_gu 	= request.getParameter("ins_req_gu")==null?"":request.getParameter("ins_req_gu");//1-휴차료, 2-대차료
	String vat_yn 		= request.getParameter("vat_yn")==null?"":request.getParameter("vat_yn");//부가세포함여부
	String ins_use_st 	= request.getParameter("ins_use_st")==null?"":request.getParameter("ins_use_st");
	String ins_use_et 	= request.getParameter("ins_use_et")==null?"":request.getParameter("ins_use_et");
	String ins_use_day 	= request.getParameter("ins_use_day")==null?"":request.getParameter("ins_use_day");
	String use_hour 	= request.getParameter("use_hour")==null?"":request.getParameter("use_hour");
	String use_st_h 	= request.getParameter("use_st_h")==null?"":request.getParameter("use_st_h");
	String use_st_s 	= request.getParameter("use_st_s")==null?"":request.getParameter("use_st_s");
	String use_et_h 	= request.getParameter("use_et_h")==null?"":request.getParameter("use_et_h");
	String use_et_s 	= request.getParameter("use_et_s")==null?"":request.getParameter("use_et_s");
	String ot_fault_per 	= request.getParameter("ot_fault_per")==null?"":request.getParameter("ot_fault_per");
	String st 		= request.getParameter("st")==null?"":request.getParameter("st");
	String c_id 		= request.getParameter("c_id")==null?"":request.getParameter("c_id");//자동차관리번호
	String accid_id 	= request.getParameter("accid_id")==null?"":request.getParameter("accid_id");//사고관리번호
	
	
	CommonDataBase c_db = CommonDataBase.getInstance();
	EstiDatabase e_db = EstiDatabase.getInstance();
	AddCarMstDatabase a_cmb = AddCarMstDatabase.getInstance();
	CarRegDatabase crd = CarRegDatabase.getInstance();
	
	
	//계약기본정보
	ContBaseBean base = a_db.getCont(rent_mng_id, rent_l_cd);
	
	//차량기본정보
	ContCarBean car 	= a_db.getContCarNew(rent_mng_id, rent_l_cd);
	
	//CAR_NM : 차명정보
	cm_bean = a_cmb.getCarNmCase(car.getCar_id(), car.getCar_seq());
	
	//자동차등록
	cr_bean = crd.getCarRegBean(base.getCar_mng_id());
	
	String jg_b_dt = e_db.getVar_b_dt("jg", ins_use_st);
	
	//차종코드별변수
	EstiJgVarBean ej_bean = e_db.getEstiJgVarCase(cm_bean.getJg_code(), jg_b_dt);
	
	String section 	= cm_bean.getSection();
	
	if(ck_acar_id.equals("000029")){
		out.println("사고차량 cm_bean.section");
		out.println("cars="+ej_bean.getCars());
	}	
	
	if(!ej_bean.getJg_r().equals("") && ej_bean.getJg_g_36().equals("") && ej_bean.getJg_r().length() >= 2){
		section 	= ej_bean.getJg_r();
		if(ck_acar_id.equals("000029")){
			out.println("jg_r");
		}	
	}else if(!ej_bean.getJg_r().equals("") && !ej_bean.getJg_g_36().equals("") && ej_bean.getJg_g_36().length() >= 2){			
		section 	= ej_bean.getJg_g_36();
		if(ck_acar_id.equals("000029")){
			out.println("jg_g_36");
		}	
	}

	ShortFeeMngBean sf_bean = sfm_db.getShortFeeMngCase(section, "2", ins_use_st);		
	
	int req_amt_b = sf_bean.getAmt_01d();
	
	if(ck_acar_id.equals("000029")){		
		out.println(" section="+section);
		out.println(" jg_c="+ej_bean.getJg_c());
		out.println(" req_amt_b="+req_amt_b+"<br>");
	}	
	
	
	//20140306 대차차량이 더 싼차량이면 대차차량을 기준으로 한다.	
	//예약현황
	Vector rc_conts = rs_db.getResCarAccidList(c_id, accid_id);
	int rc_cont_size = rc_conts.size();
	
	for(int i = 0 ; i < rc_cont_size ; i++){
   		Hashtable reservs = (Hashtable)rc_conts.elementAt(i);
    		
   		Hashtable dae_cha = a_db.getContViewMaxCarCase(String.valueOf(reservs.get("CAR_MNG_ID")));
    				
		//CAR_NM : 차명정보
		CarMstBean dc_cm_bean = a_cmb.getCarNmCase(String.valueOf(dae_cha.get("CAR_ID")), String.valueOf(dae_cha.get("CAR_SEQ")));
		
		//자동차등록
		CarRegBean dc_cr_bean = crd.getCarRegBean(String.valueOf(dae_cha.get("CAR_MNG_ID")));

		//차종코드별변수
		EstiJgVarBean dc_ej_bean = e_db.getEstiJgVarCase(dc_cm_bean.getJg_code(), jg_b_dt);
			
		String section2 	= dc_cm_bean.getSection();
		
		if(ck_acar_id.equals("000029")){
			out.println("대차차량 cm_bean.section");
			out.println("cars="+dc_ej_bean.getCars());
		}	
		
		if(!dc_ej_bean.getJg_r().equals("") && dc_ej_bean.getJg_g_36().equals("") && dc_ej_bean.getJg_r().length() >= 2){
			section2 	= dc_ej_bean.getJg_r();
			if(ck_acar_id.equals("000029")){
				out.println("jg_r");
			}	
		}else if(!dc_ej_bean.getJg_r().equals("") && !dc_ej_bean.getJg_g_36().equals("") && dc_ej_bean.getJg_g_36().length() >= 2){			
			section2 	= dc_ej_bean.getJg_g_36();
			if(ck_acar_id.equals("000029")){
				out.println("jg_g_36");
			}	
		}
				
		ShortFeeMngBean sf_bean2 = sfm_db.getShortFeeMngCase(section2, "2", ins_use_st);
		int req_amt_b2 = sf_bean2.getAmt_01d();

		if(ck_acar_id.equals("000029")){
			out.println(" section="+section2);
			out.println(" jg_c="+dc_ej_bean.getJg_c());
			out.println(" req_amt_b="+req_amt_b2+"<br>");			
		}	
		
		//20220613 사고차량이 수입차이고, 대차차량이 수입차인 경우 배기량이 작은 차량으로 (배기량이 있는))
		if(ej_bean.getJg_c() > 0 && ej_bean.getJg_w().equals("1") && dc_ej_bean.getJg_w().equals("1")){
			if(ej_bean.getJg_c() > dc_ej_bean.getJg_c()){
				cm_bean = dc_cm_bean;
				cr_bean = dc_cr_bean;
				ej_bean = dc_ej_bean;
				section = section2;
				req_amt_b = sf_bean2.getAmt_01d();
				if(ck_acar_id.equals("000029")){
					out.println("=====>[대차차량요금]사고차량이 수입차이고, 대차차량이 수입차인 경우 배기량이 작은 차량으로 (배기량이 있는)");
				}	
			}else{
				if(ck_acar_id.equals("000029")){
					out.println("=====>[사고차량요금]사고차량이 수입차이고, 대차차량이 수입차인 경우 사고차량 배기량이 작거나 같다.");
				}
			}
		}else{
			if(req_amt_b > req_amt_b2){
				cm_bean = dc_cm_bean;
				cr_bean = dc_cr_bean;
				ej_bean = dc_ej_bean;
				section = section2;
				req_amt_b = req_amt_b2;		
				if(ck_acar_id.equals("000029")){
					out.println("=====>[대차차량요금]대차차랑 단기요금이 더 적다");
				}
			}else{
				if(ck_acar_id.equals("000029")){
					out.println("=====>[사고차량요금]사고챠랑 단기요금이 더 적거나 같다");
				}
			}
		} 
	}   	
	
	String car_name	= cr_bean.getCar_nm()+" "+cm_bean.getCar_name();
	String jg_code 	= ej_bean.getJg_a();	
	String s_st 	= ej_bean.getJg_a();
	String car_kd 	= cr_bean.getCar_kd();
	int dpm		= AddUtil.parseInt(cr_bean.getDpm());
	
	if(section.equals("")) section 	= cm_bean.getSection();
	if(jg_code.equals("")) jg_code 	= cm_bean.getJg_code();
	
	if(section.equals("")){
		out.println("단기대여분류없음.<br><br>");
		
		if(s_st.equals("100")||s_st.equals("101"))			section = "C1";
		if(s_st.equals("102")){
			if(dpm <= 1600)						section = "C1";
			if(dpm > 1600 && dpm <= 2000)				section = "C3";
		}
		if(s_st.equals("103")||s_st.equals("301")){
			if(dpm <= 1800)						section = "I1";
			if(dpm > 1800 && dpm <= 2000)				section = "I2";
			if(dpm > 2000)						section = "I3";
		}
		if(s_st.equals("104")||s_st.equals("105")||s_st.equals("302")){
			if(dpm <= 2000)						section = "S1";
			if(dpm > 2000 && dpm <= 2500)				section = "S2";
			if(dpm > 2500 && dpm <= 2700)				section = "S3";
			
			if(dpm > 2700 && dpm <= 3000)				section = "P1";
			if(dpm > 3000 && dpm <= 3500)				section = "P2";
			if(dpm > 3500 && dpm <= 4500)				section = "P3";
			if(dpm > 4500 && dpm <= 5000)				section = "P4";
			if(dpm > 5000)						section = "P5";
		}
		if(s_st.equals("401")||s_st.equals("402")||s_st.equals("400")||s_st.equals("409")){
			if(dpm <= 2000)						section = "R1";
			if(dpm > 2000 && dpm <= 2500)				section = "P2";
			if(dpm > 2500 && dpm <= 3000)				section = "P3";
			if(dpm > 3000 && dpm <= 3500)				section = "P4";
			if(dpm > 3500 && dpm <= 4000)				section = "P5";
			if(dpm > 4000)						section = "R6";
		}
		if(s_st.equals("501")||s_st.equals("502"))			section = "B1";
		if(s_st.equals("601")||s_st.equals("602"))			section = "B2";
		if(s_st.equals("700")||s_st.equals("701")||s_st.equals("702"))			section = "B3";
	}
	
	ShortFeeMngBean bean2 = new ShortFeeMngBean();
%>

<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN">
<html>
<head>
<title>FMS</title>
<meta http-equiv="Content-Type" content="text/html; charset=euc-kr">
<link rel="stylesheet" type="text/css" href="/include/table_t.css">
<script language='JavaScript' src='/include/estimate.js'></script>
<script language='JavaScript' src='/include/common.js'></script>
<script language="JavaScript">
<!--
	function replaceFloatRound(per){
		return Math.round(per*1000)/10;	
	}
	
	//일수 구하기
	function getRentTime(gubun, d1, d2) {
		var fm = document.form1;	
		m  = 30*24*60*60*1000;		//달
		l  = 24*60*60*1000;  		// 1일
		lh = 60*60*1000;  			// 1시간
		lm = 60*1000;  	 	 		// 1분
		var rent_time = "";
		var t1;
		var t2;
		var t3;		
		t1 = getDateFromString(replaceString('-','',d1)).getTime();
		t2 = getDateFromString(replaceString('-','',d2)).getTime();
		t3 = t2 - t1;			
		if(gubun=='m') 	return parseInt(t3/m);
		if(gubun=='l') 	return parseInt(t3/l);
		if(gubun=='lh') return parseInt(t3/lh);
		if(gubun=='lm') return parseInt(t3/lm);		
		if(gubun=='jl') return parseInt((t3%m)/l);
	}
	function getDateFromString(s){
		return new Date(s.substr(0, 4)-1700, s.substr(4, 2)-1, s.substr(6, 2), s.substr(8, 2), s.substr(10, 2));
	}	
	
	function getShCarAmt(){	
		var fm = document.form1;
		var i =0;
		
		//선택사항=========================================================================================
				
		fm.cd[i].value = "";				fm.nm[i].value = "---------------------------"; 				fm.value[i].value = '선택사항 ------------------';			i++;				
						

		var car_kd_nm = '<%=c_db.getNameByIdCode("0041", "", car_kd)%>';
		

		fm.cd[i].value = "car_name";		fm.nm[i].value = "차명";										fm.value[i].value = '<%=car_name%>';		i++;		
		fm.cd[i].value = "jg_code";			fm.nm[i].value = "차종코드";									fm.value[i].value = '<%=jg_code%>';			i++;		
		fm.cd[i].value = "car_kd";			fm.nm[i].value = "차종구분:"+car_kd_nm;							fm.value[i].value = '<%=car_kd%>';			i++;
		fm.cd[i].value = "s_st";			fm.nm[i].value = "차종소분류";									fm.value[i].value = '<%=s_st%>';			i++;
		fm.cd[i].value = "dpm";				fm.nm[i].value = "배기량";										fm.value[i].value = '<%=dpm%>';				i++;
	
		var ins_use_day = <%=ins_use_day%>;
		fm.cd[i].value = "ins_use_day";		fm.nm[i].value = "이용일수";									fm.value[i].value = ins_use_day;			i++;		
		var ins_use_hour = <%=use_hour%>;
		fm.cd[i].value = "ins_use_hour";	fm.nm[i].value = "이용시간";									fm.value[i].value = ins_use_hour;			i++;		
	
		var ins_req_gu = <%=ins_req_gu%>;
		fm.cd[i].value = "ins_req_gu";		fm.nm[i].value = "구분(1-휴차료, 2-대차료)";					fm.value[i].value = ins_req_gu;				i++;

		var section = '<%=section%>';
		var section_no = i;
		fm.cd[i].value = "section";			fm.nm[i].value = "단기대여분류";								fm.value[i].value = section;				i++;
		
		var one_day_amt = 0;		
		
		
		<%if(ins_req_gu.equals("1")){//휴차료%>
		
		if(<%=car_kd%>==3 || <%=car_kd%>==9) 			one_day_amt = 27170;//소형승용
		if(<%=car_kd%>==2) 			one_day_amt = 31600;//중형승용
		if(<%=car_kd%>==5) 			one_day_amt = 45260;//소형승합
		if(<%=car_kd%>==4) 			one_day_amt = 45260;//중형승합		
		if(<%=car_kd%>==6) 			one_day_amt = 40090;//중형승합		
		
		
		if(<%=car_kd%>==1){
			if(<%=dpm%> >= 2300){//고급형
									one_day_amt = 73360; 				fm.cd[i].value = "car_kd";	fm.nm[i].value = "차종구분(조정)";			fm.value[i].value = '고급형';		i++;
			}else{
				 					one_day_amt = 37050;//대형승용
			}
		}
		
		
		
		<%}else{//대차료
			//단기대여요금 가져오기
			bean2 = sfm_db.getShortFeeMngCase(section, "2", ins_use_st);
		%>

		var use_day = ins_use_day;
		var use_mon = getRentTime('m','<%=ins_use_st%>','<%=ins_use_et%>');
		
		
		use_mon = getRentTime('m','<%=ins_use_st%><%=use_st_h%><%=use_st_s%>','<%=ins_use_et%><%=use_et_h%><%=use_et_s%>');
		
		
		if(use_day == 0)	 one_day_amt = <%=bean2.getAmt_01d()%>;
		if(use_day == 1)	 one_day_amt = <%=bean2.getAmt_01d()%>;
		if(use_day == 2)	 one_day_amt = <%=bean2.getAmt_02d()%>;
		if(use_day == 3)	 one_day_amt = <%=bean2.getAmt_03d()%>;
		if(use_day == 4)	 one_day_amt = <%=bean2.getAmt_04d()%>;
		if(use_day == 5)	 one_day_amt = <%=bean2.getAmt_05d()%>;
		if(use_day == 6)	 one_day_amt = <%=bean2.getAmt_06d()%>;
		if(use_day == 7)	 one_day_amt = <%=bean2.getAmt_07d()%>;
		if(use_day == 8)	 one_day_amt = <%=bean2.getAmt_08d()%>;
		if(use_day == 9)	 one_day_amt = <%=bean2.getAmt_09d()%>;
		if(use_day == 10)	 one_day_amt = <%=bean2.getAmt_10d()%>;
		if(use_day == 11)	 one_day_amt = <%=bean2.getAmt_11d()%>;
		if(use_day == 12)	 one_day_amt = <%=bean2.getAmt_12d()%>;
		if(use_day == 13)	 one_day_amt = <%=bean2.getAmt_13d()%>;
		if(use_day == 14)	 one_day_amt = <%=bean2.getAmt_14d()%>;
		if(use_day == 15)	 one_day_amt = <%=bean2.getAmt_15d()%>;
		if(use_day == 16)	 one_day_amt = <%=bean2.getAmt_16d()%>;
		if(use_day == 17)	 one_day_amt = <%=bean2.getAmt_17d()%>;
		if(use_day == 18)	 one_day_amt = <%=bean2.getAmt_18d()%>;
		if(use_day == 19)	 one_day_amt = <%=bean2.getAmt_19d()%>;
		if(use_day == 20)	 one_day_amt = <%=bean2.getAmt_20d()%>;
		if(use_day == 21)	 one_day_amt = <%=bean2.getAmt_21d()%>;
		if(use_day == 22)	 one_day_amt = <%=bean2.getAmt_22d()%>;
		if(use_day == 23)	 one_day_amt = <%=bean2.getAmt_23d()%>;
		if(use_day == 24)	 one_day_amt = <%=bean2.getAmt_24d()%>;
		if(use_day == 25)	 one_day_amt = <%=bean2.getAmt_25d()%>;
		if(use_day == 26)	 one_day_amt = <%=bean2.getAmt_26d()%>;
		if(use_day == 27)	 one_day_amt = <%=bean2.getAmt_27d()%>;
		if(use_day == 28)	 one_day_amt = <%=bean2.getAmt_28d()%>;
		if(use_day == 29)	 one_day_amt = <%=bean2.getAmt_29d()%>;
		if(use_day == 30)	 one_day_amt = <%=bean2.getAmt_30d()%>;
		if(use_day > 30){
			if(use_mon <= 1)	 one_day_amt = <%=bean2.getAmt_01m()%>;
			if(use_mon == 2)	 one_day_amt = <%=bean2.getAmt_02m()%>;
			if(use_mon == 3)	 one_day_amt = <%=bean2.getAmt_03m()%>;
			if(use_mon == 4)	 one_day_amt = <%=bean2.getAmt_04m()%>;
			if(use_mon == 5)	 one_day_amt = <%=bean2.getAmt_05m()%>;
			if(use_mon == 6)	 one_day_amt = <%=bean2.getAmt_06m()%>;
			if(use_mon == 7)	 one_day_amt = <%=bean2.getAmt_07m()%>;															
			if(use_mon == 8)	 one_day_amt = <%=bean2.getAmt_08m()%>;
			if(use_mon == 9)	 one_day_amt = <%=bean2.getAmt_09m()%>;
			if(use_mon == 10)	 one_day_amt = <%=bean2.getAmt_10m()%>;
			if(use_mon > 10)	 one_day_amt = <%=bean2.getAmt_11m()%>;				
		}		
		fm.cd[i].value = "use_mon";		fm.nm[i].value = "이용월수";										fm.value[i].value = use_mon;					i++;
		fm.cd[i].value = "use_day";		fm.nm[i].value = "이용일수";										fm.value[i].value = use_day;					i++;					
		
		fm.cd[i].value = "one_day_amt";		fm.nm[i].value = "1일 대여료(공급가)";									fm.value[i].value = one_day_amt;				i++;
		
		//one_day_amt = one_day_amt/1.1; 대차료일때 공급가 포함금액으로 계산한다.
		one_day_amt 		= Math.round(one_day_amt*1.1);
		
		<%}%>
		
		
		fm.cd[i].value = "one_day_amt";		fm.nm[i].value = "1일 대여료";									fm.value[i].value = one_day_amt;				i++;
		
		
		<%if(!st.equals("view")){%>
		parent.document.form1.ins_day_amt.value = parseDecimal(one_day_amt);		
//		parent.document.form1.ins_req_amt.value = parseDecimal( one_day_amt * ins_use_day * (<%=ot_fault_per%>/100));	
		parent.document.form1.ins_req_amt.value = parseDecimal( ((one_day_amt * ins_use_day)+(one_day_amt/24*ins_use_hour)) * (<%=ot_fault_per%>/100));		
		
		<%	if(ins_req_gu.equals("2")){//대차료%>
		parent.document.form1.vat_yn.checked = true;
		parent.document.form1.mc_s_amt.value 	= parseDecimal(sup_amt(toInt(parseDigit(parent.document.form1.ins_req_amt.value)))); 
		parent.document.form1.mc_v_amt.value 	= parseDecimal(toInt(parseDigit(parent.document.form1.ins_req_amt.value)) - toInt(parseDigit(parent.document.form1.mc_s_amt.value)));							
		<%	}else{//휴차료%>
		parent.document.form1.mc_s_amt.value 	= parent.document.form1.ins_req_amt.value;
		parent.document.form1.mc_v_amt.value 	= 0;
		<%	}%>
		<%}%>
		
		fm.cd[i].value = "ShortFeedt";		fm.nm[i].value = "단기요금기준일자";								fm.value[i].value = '<%=bean2.getReg_dt()%>';				i++;
		
	}
	
	//팝업윈도우 열기
	function MM_openBrWindow(theURL,winName,features) { //v2.0
		theURL = "https://fms3.amazoncar.co.kr/data/"+theURL+".pdf";
		window.open(theURL,winName,features);
	}
	
//-->
</script>
</head>
<body>
<form action="" name="form1" method="POST" >
<input type="hidden" name="rent_mng_id" value="<%=rent_mng_id%>">
<input type="hidden" name="rent_l_cd" value="<%=rent_l_cd%>">      

<table border=0 cellspacing=0 cellpadding=0 width=700>
	<tr>
		<td>
			<table width=100% border=0 cellpadding=0 cellspacing=0>
				<tr>
					<td width=7><img src=/acar/images/center/menu_bar_1.gif width=7 height=33></td>
					<td class=bar>&nbsp;&nbsp;&nbsp;<img src=/acar/images/center/menu_bar_dot.gif width=4 height=5 align=absmiddle>&nbsp;<span class=style1><span class=style5>계산과정</span></span></td>
					<td width=7><img src=/acar/images/center/menu_bar_2.gif width=7 height=33></td>
				</tr>
			</table>
		</td>
	</tr>
	<tr>
		<td class=h></td>
	</tr>  
	<tr>
		<td class=line2></td>
	</tr> 
	<tr>
        <td class=line>
            <table border="0" cellspacing="1" width=100%>
                <tr>
                  <td width="30" class=title>연번</td>
                  <td width="100" class=title>기호</td>
                  <td width="220" class=title>항목</td>
                  <td width="350" class=title>값</td>
                  </tr>
        		  <%for(int i=0; i<16; i++){%>
                  <tr>
        		  	<td align="center"><%=i%></td>
                    <td>&nbsp;<input type="text" name="cd" value="" size="13" class=whitetext></td>
                    <td>&nbsp;<input type="text" name="nm" value="" size="30" class=whitetext></td>
                    <td>&nbsp;<input type="text" name="value" value="" size="50" class=whitetext></td>          
                  </tr>
        		  <%}%>
      </table></td>
    </tr>	
</table>	
	
	<%if(ins_req_gu.equals("2")){	
		int img_width 	= 680;
		int img_height 	= 1009;
		
		String file_name = "아마존카_단기대여_요금표.jpg";
		
		if(bean2.getReg_dt().equals("20090115"))  file_name = "아마존카_단기대여_요금표_20090115.jpg";
		if(bean2.getReg_dt().equals("20111001"))  file_name = "아마존카_단기대여_요금표_20111001.jpg";
		if(bean2.getReg_dt().equals("20131224"))  file_name = "아마존카_단기대여_요금표_20131224.jpg";
		if(bean2.getReg_dt().equals("20150101"))  file_name = "아마존카_단기대여_요금표_20150101.jpg";
		if(bean2.getReg_dt().equals("20190709"))  file_name = "아마존카_단기대여_요금표_20190709.jpg";
		if(bean2.getReg_dt().equals("20211027"))  file_name = "아마존카_단기대여_요금표_20211027.jpg";
		
	%>
<table width='<%=img_width%>' border="0" cellpadding="0" cellspacing="0">
	<tr>
		<td height=1009>
			<img src="https://fms3.amazoncar.co.kr/data/doc/<%=file_name%>" width=<%=img_width%> height=<%=img_height%>>
		</td>
	</tr>
</table>	
	<%}else{%>
	<a href="javascript:MM_openBrWindow('doc/아마존카_휴차료기준표','popwin_in1','scrollbars=no,status=yes,resizable=yes,width=820,height=600,left=50, top=50')">[아마존카_휴차료기준표.pdf]</a> 
	<%}%>
</form>	
<script>
<!--
	getShCarAmt();	
//-->
</script>	
</body>
</html>
