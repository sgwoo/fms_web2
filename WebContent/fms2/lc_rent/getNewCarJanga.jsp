<%@ page language="java" contentType="text/html; charset=euc-kr" %>
<%@ page import="java.util.*, java.io.*, acar.util.*, acar.estimate_mng.*, acar.car_mst.*, acar.con_ins.*,acar.cont.*,acar.client.*" %>
<jsp:useBean id="bean" class="acar.estimate_mng.EstimateBean" scope="page"/>
<jsp:useBean id="cm_bean" class="acar.car_mst.CarMstBean" scope="page"/>
<jsp:useBean id="a_db" scope="page" class="acar.cont.AddContDatabase"/>
<jsp:useBean id="al_db" scope="page" class="acar.client.AddClientDatabase"/>
<jsp:useBean id="af_db" scope="page" class="acar.fee.AddFeeDatabase"/>
<%@ include file="/acar/cookies.jsp" %>


<%
	//계약등록시 잔존가치율 - 최대잔가율 조회
	
	int o_1 					= request.getParameter("o_1")==null?0:AddUtil.parseInt(request.getParameter("o_1"));
	int t_dc_amt 			= request.getParameter("t_dc_amt")==null?0:AddUtil.parseInt(request.getParameter("t_dc_amt"));
	int grt_amt 			= request.getParameter("grt_amt")==null?0:AddUtil.parseDigit(request.getParameter("grt_amt"));
	int pp_amt 				= request.getParameter("pp_amt")==null?0:AddUtil.parseDigit(request.getParameter("pp_amt"));
	int t_ifee_s_amt 	= request.getParameter("ifee_s_amt")==null?0:AddUtil.parseDigit(request.getParameter("ifee_s_amt"));
	int t_fee_s_amt 	= request.getParameter("fee_s_amt")==null?0:AddUtil.parseDigit(request.getParameter("fee_s_amt"));
	int opt_c_amt			= request.getParameter("opt_c_amt")==null?0:AddUtil.parseDigit(request.getParameter("opt_c_amt"));
	int add_opt_amt		= request.getParameter("add_opt_amt")==null?0:AddUtil.parseDigit(request.getParameter("add_opt_amt"));
	String lpg_setter = request.getParameter("lpg_setter")==null?"":request.getParameter("lpg_setter");
	String gi_st 			= request.getParameter("gi_st")==null?"":request.getParameter("gi_st");
	String s_st 			= request.getParameter("s_st")==null?"":request.getParameter("s_st");
	String rent_dt 		= request.getParameter("rent_dt")==null?"":AddUtil.replace(request.getParameter("rent_dt"),"-","");
	String esti_stat	= request.getParameter("esti_stat")==null?"":request.getParameter("esti_stat");
	String rent_mng_id= request.getParameter("rent_mng_id")==null?"":request.getParameter("rent_mng_id");
	String rent_l_cd	= request.getParameter("rent_l_cd")==null?"":request.getParameter("rent_l_cd");
	String car_mng_id = request.getParameter("car_mng_id")==null?"":request.getParameter("car_mng_id");
	String from_page 	= request.getParameter("from_page")==null?"":request.getParameter("from_page");
	String rent_st 		= request.getParameter("rent_st")==null?"":request.getParameter("rent_st");
	String car_gu 		= request.getParameter("car_gu")==null?"":request.getParameter("car_gu");
	String mode				= request.getParameter("mode")		==null?"lc_rent":request.getParameter("mode");
	String jg_b_dt 		= request.getParameter("jg_b_dt")==null?"":request.getParameter("jg_b_dt");
	String a_j 				= request.getParameter("a_j")==null?"":request.getParameter("a_j");
	String a_b 				= request.getParameter("a_b")==null?"":request.getParameter("a_b");
	int    agree_dist	= request.getParameter("agree_dist")==null?0:AddUtil.parseDigit(request.getParameter("agree_dist"));
	int    cls_n_mon	= request.getParameter("cls_n_mon")==null?0:AddUtil.parseDigit(request.getParameter("cls_n_mon"));
	int count = 0;
	
	EstiDatabase e_db = EstiDatabase.getInstance();
	
	
	//계약기본정보
	ContBaseBean base = a_db.getCont(rent_mng_id, rent_l_cd);
	
	//계약기타정보
	ContEtcBean cont_etc = a_db.getContEtc(rent_mng_id, rent_l_cd);
	
	//고객정보
	ClientBean client = al_db.getNewClient(base.getClient_id());
	
	//대여료갯수조회(연장여부)
	int fee_size 	= af_db.getMaxRentSt(rent_mng_id, rent_l_cd);
	
	if(fee_size > 1){
		rent_st = Integer.toString(fee_size);
	}else{
		rent_st = "1";
	}
	
	//첫번째대여정보
	ContFeeBean fee = a_db.getContFeeNew(rent_mng_id, rent_l_cd, "1");
	
	
	//해당대여정보
	ContFeeBean fees = a_db.getContFeeNew(rent_mng_id, rent_l_cd, rent_st);
	
	//차량기본정보
	ContCarBean fee_etc = a_db.getContFeeEtc(rent_mng_id, rent_l_cd, rent_st);
	
	//차량기본정보
	ContCarBean car 	= a_db.getContCarNew(rent_mng_id, rent_l_cd);
	
	//CAR_NM : 차명정보
	AddCarMstDatabase a_cmb = AddCarMstDatabase.getInstance();
	cm_bean = a_cmb.getCarNmCase(String.valueOf(car.getCar_id()), String.valueOf(car.getCar_seq()));
	
	if(rent_dt.equals("")) rent_dt = base.getRent_dt();
    
	if(jg_b_dt.equals("")){
		jg_b_dt = e_db.getVar_b_dt(cm_bean.getJg_code(), "jg", rent_dt);
		a_j 	= e_db.getVar_b_dt("em", rent_dt);
	}
	//차종변수 기준일자에 따른 공통변수 일련번호 가져오기
	String em_var_seq = e_db.getVar_seq("em", rent_dt);
	
	//중고차잔가변수
	EstiJgVarBean ej_bean = e_db.getEstiJgVarCase(cm_bean.getJg_code(), jg_b_dt);
	
	//공통변수
	EstiCommVarBean em_bean = new EstiCommVarBean();
	em_bean = e_db.getEstiCommVarCase("1", em_var_seq);
	
	
	String jg_opt_st = car.getJg_opt_st();
	String jg_col_st = car.getJg_col_st();
	
	if(jg_opt_st.equals("") && !jg_col_st.equals(""))	jg_opt_st = jg_col_st;
	else if(!jg_opt_st.equals("") && !jg_col_st.equals(""))	jg_opt_st = jg_opt_st+"/"+jg_col_st;
	
	int s=0; 
	String app_value[] = new String[7];	
	
	if(jg_opt_st.length() > 0){
		StringTokenizer st = new StringTokenizer(jg_opt_st,"/");				
		while(st.hasMoreTokens()){
			app_value[s] = st.nextToken();
			s++;
		}		
	}		

	out.println(" rent_dt="+rent_dt);
	out.println(" jg_code="+cm_bean.getJg_code());
	out.println(" jg_b_dt="+jg_b_dt);
	out.println(" a_j="+a_j);
	out.println(" em_var_seq="+em_var_seq);
	out.println(" jg_opt_st="+jg_opt_st);	
	out.println(" s="+s);	
	
	if(mode.equals("cmp")){//영업효율견적잔가
		
		//해당 계약의 마지막 정상대여료 견적정보
		bean = e_db.getEstimateCaseCmp(rent_l_cd, base.getRent_dt());
		
		if(bean.getEst_id().equals("")){
			bean = e_db.getEstimateCaseCmp(rent_l_cd, fees.getRent_start_dt());
		}
		
		if(a_b.equals("0")){
			a_b = "1";
		}
		
		bean.setA_b			(a_b);
		bean.setDc_amt		(request.getParameter("dc_c_amt")==null?0:AddUtil.parseDigit(request.getParameter("dc_c_amt")));
//		bean.setO_1			(bean.getCar_amt()+bean.getOpt_amt()+bean.getCol_amt()-bean.getDc_amt());
		bean.setO_1			(o_1);
		
		
		if(bean.getEst_id().equals("")){
			/*차량정보*/
			bean.setCar_comp_id	(cm_bean.getCar_comp_id());
			bean.setCar_cd		(cm_bean.getCode());
			bean.setCar_id		(cm_bean.getCar_id());
			bean.setCar_seq		(cm_bean.getCar_seq());
			bean.setJg_opt_st	(car.getJg_opt_st());
			bean.setJg_col_st	(car.getJg_col_st());
			
			if(base.getCar_gu().equals("1")){
				bean.setCar_amt		(car.getCar_cs_amt()+car.getCar_cv_amt());
				bean.setOpt_amt		(car.getOpt_cs_amt()+car.getOpt_cv_amt()+car.getAdd_opt_amt());
				bean.setCol_amt		(car.getClr_cs_amt()+car.getClr_cv_amt());
				bean.setDc_amt		(car.getDc_cs_amt()+car.getDc_cv_amt());
//				bean.setO_1			(bean.getCar_amt()+bean.getOpt_amt()+bean.getCol_amt()-bean.getDc_amt());
				bean.setEst_tel		("1");
			}else{
				bean.setCar_amt		(fee_etc.getSh_amt());
				bean.setO_1			(fee_etc.getSh_amt());
				bean.setEst_tel		("0");
			}
			//대여기간
			bean.setA_b			(request.getParameter("con_mon")==null?"":request.getParameter("con_mon"));
			//LPG 장착여부
			String lpg_yn = "0";
			if(!car.getLpg_setter().equals(""))		lpg_yn = "1";
			bean.setLpg_yn		(lpg_yn);
		}
		
		if(cls_n_mon >0){
			bean.setA_b(String.valueOf(AddUtil.parseInt(bean.getA_b())-cls_n_mon));
		}
		
		
	}else{
	
		/*차량정보*/
		bean.setCar_comp_id	(cm_bean.getCar_comp_id());
		bean.setCar_cd		(cm_bean.getCode());
		bean.setCar_id		(cm_bean.getCar_id());
		bean.setCar_seq		(cm_bean.getCar_seq());
		bean.setJg_opt_st	(car.getJg_opt_st());
		bean.setJg_col_st	(car.getJg_col_st());
		
		if(car_gu.equals("1")){
			bean.setCar_amt		(request.getParameter("car_c_amt")==null?0:AddUtil.parseDigit(request.getParameter("car_c_amt")));
			bean.setOpt			(request.getParameter("opt")==null?"":request.getParameter("opt"));
			bean.setOpt_seq		(request.getParameter("opt_code")==null?"":request.getParameter("opt_code"));
			bean.setOpt_amt		(opt_c_amt+add_opt_amt);
			bean.setCol			(request.getParameter("color")==null?"":request.getParameter("color"));
			bean.setCol_amt		(request.getParameter("col_c_amt")==null?0:AddUtil.parseDigit(request.getParameter("col_c_amt")));
			bean.setDc_amt		(request.getParameter("t_dc_amt")==null?0:AddUtil.parseDigit(request.getParameter("t_dc_amt")));
			bean.setO_1			(o_1);
			bean.setEst_tel		("1");
		}else{
			bean.setCar_amt		(o_1);
			bean.setO_1			(o_1);
			bean.setEst_tel		("0");
		}
		//대여기간
		bean.setA_b			(request.getParameter("con_mon")==null?"":request.getParameter("con_mon"));
		//LPG 장착여부
		String lpg_yn = "0";
		if(!lpg_setter.equals(""))		lpg_yn = "1";
		bean.setLpg_yn		(lpg_yn);
		
		if(cls_n_mon >0){
			bean.setA_b(String.valueOf(AddUtil.parseInt(bean.getA_b())-cls_n_mon));
		}
		
	}
	
	if(ej_bean.getJg_13().equals("")) ej_bean.setJg_13("0");
%>

<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN">
<html>
<head>
<title>FMS</title>
<meta http-equiv="Content-Type" content="text/html; charset=euc-kr">
<link rel="stylesheet" type="text/css" href="../../include/table.css">
<script language='JavaScript' src='/include/estimate.js'></script>
<script language="JavaScript">
<!--
	function replaceFloatRound(per){
		return Math.round(per*1000)/10;	
	}
	
	function replaceFloatRound2(per){
		return Math.round(per*10)/10;	
	}
	
	function replaceFloatRound3(per){
		return Math.round(per*1000)/1000;	
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
		if(gubun=='m') return parseInt(t3/m);
		if(gubun=='l') return parseInt(t3/l);
		if(gubun=='lh') return parseInt(t3/lh);
		if(gubun=='lm') return parseInt(t3/lm);		
	}
	function getDateFromString(s){
		return new Date(s.substr(0, 4)-1700, s.substr(4, 2)-1, s.substr(6, 2), s.substr(8, 2), s.substr(10, 2));
	}	
	
	function getShCarAmt(){	
		var fm = document.form1;
		var i =0;
		
		//선택사항=========================================================================================
				
		fm.cd[i].value = "";				fm.nm[i].value = "---------------------------"; 				fm.value[i].value = '선택사항 ------------------';			i++;				
						
		var rent_dt = <%=rent_dt%>;
		fm.cd[i].value = "rent_dt";			fm.nm[i].value = "견적기준일";									fm.value[i].value = rent_dt;				i++;		
		
		var jg_code = <%=ej_bean.getSh_code()%>;
		fm.cd[i].value = "jg_code";			fm.nm[i].value = "차종코드";									fm.value[i].value = jg_code;				i++;		
		
		var car_amt = <%=bean.getCar_amt()%>;
		fm.cd[i].value = "car_amt";			fm.nm[i].value = "차량가격";									fm.value[i].value = car_amt;				i++;		
		
		var opt_amt = <%=bean.getOpt_amt()%>;
		fm.cd[i].value = "opt_amt";			fm.nm[i].value = "선택사양가격";								fm.value[i].value = opt_amt;				i++;		
		
		var col_amt = <%=bean.getCol_amt()%>;
		fm.cd[i].value = "col_amt";			fm.nm[i].value = "색상사양가격";								fm.value[i].value = col_amt;				i++;		
		
		var dc_amt = <%=bean.getDc_amt()%>;
		fm.cd[i].value = "dc_amt";			fm.nm[i].value = "DC가격";										fm.value[i].value = dc_amt;				i++;		
		
		var o_1 = <%=o_1%>;
		fm.cd[i].value = "o_1";				fm.nm[i].value = "적용차량가격";								fm.value[i].value = o_1;				i++;		
		
		var t_dc_amt = <%=t_dc_amt%>;
		fm.cd[i].value = "t_dc_amt";		fm.nm[i].value = "적용DC가격";									fm.value[i].value = t_dc_amt;				i++;		
		
		var a_b = <%=bean.getA_b()%>;
		fm.cd[i].value = "a_b";				fm.nm[i].value = "견적개월수"	;								fm.value[i].value = a_b;				i++;		
		
		var rent_st = <%=rent_st%>;
		fm.cd[i].value = "rent_st";			fm.nm[i].value = "대여구분"	;									fm.value[i].value = rent_st;				i++;		
		

		fm.cd[i].value = "";				fm.nm[i].value = "---------------------------"; fm.value[i].value = '재리스차량 현재잔가율 산출과정 -------------';			i++;				

		var o_a = <%=ej_bean.getJg_1()%>;
		fm.cd[i].value = "a_a";				fm.nm[i].value = "현시점 차령 24개월 잔가율";					fm.value[i].value = o_a;					i++;		

		var g_1 = <%=em_bean.getJg_c_1()%>/100;
		if(<%=rent_dt%> >= 20140912){
		    g_1 = g_1*(1-<%=ej_bean.getJg_g_2()%>*0.35);
		}
		fm.cd[i].value = "g_1";				fm.nm[i].value = "0개월 기준 잔가";								fm.value[i].value = g_1;					i++;		

		var o_2 = <%=ej_bean.getJg_2()%>;
		fm.cd[i].value = "o_2";				fm.nm[i].value = "일반승용 LPG 여부";							fm.value[i].value = o_2;					i++;		

		var o_3 = <%=ej_bean.getJg_3()%>;
		fm.cd[i].value = "o_3";				fm.nm[i].value = "기본 특소세율";								fm.value[i].value = o_3;					i++;		

		var o_b = g_1*(1+o_2*o_3)+(o_a-0.6*(1+o_2*o_3))*0.5;
		fm.cd[i].value = "a_a";				fm.nm[i].value = "현시점 차령 0개월 잔가율";					fm.value[i].value = o_b;					i++;		

		var g_2 = <%=em_bean.getJg_c_2()%>/100;
		fm.cd[i].value = "g_2";				fm.nm[i].value = "차령24개월 잔가율 2년간 변동율";				fm.value[i].value = g_2;					i++;		

		var o_c = replaceFloatRound3(o_a*(1+g_2));
		fm.cd[i].value = "o_c";				fm.nm[i].value = "2년후 차령 24개월 잔가율";					fm.value[i].value = o_c;					i++;		

		var o_4 = <%=ej_bean.getJg_4()%>*0;
		fm.cd[i].value = "o_4";				fm.nm[i].value = "최저잔가율 조정승수(최대0.4)";				fm.value[i].value = o_4;					i++;		
		
		var o_d = o_c*o_4;
		fm.cd[i].value = "o_d";				fm.nm[i].value = "최저 잔가율";									fm.value[i].value = o_d;					i++;		

		var o_5 = <%=ej_bean.getJg_5()%>;
		fm.cd[i].value = "o_5";				fm.nm[i].value = "환경변수(36개월효과기준)";					fm.value[i].value = o_5;					i++;		
		
		var o_e = replaceFloatRound3(o_d+Math.pow((o_c-o_d)/(o_b-o_d),a_b/24)*(o_b-o_d)*(1+o_5/36*a_b));
		fm.cd[i].value = "o_e";				fm.nm[i].value = "차령 적용 평균잔가율(대여종료 시점 기준)";	fm.value[i].value = o_e;					i++;		
		
		var o_6 = <%=ej_bean.getJg_6()%>;
		fm.cd[i].value = "o_6";				fm.nm[i].value = "기본차량 잔가율 승수";						fm.value[i].value = o_6;					i++;		

		var o_f = replaceFloatRound3(o_e*o_6);
		fm.cd[i].value = "o_f";				fm.nm[i].value = "대여종료시점 기본차량 잔가율";				fm.value[i].value = o_f;					i++;		
		
		var o_7 = <%=ej_bean.getJg_7()%>;
		fm.cd[i].value = "o_7";				fm.nm[i].value = "기본차량가격";								fm.value[i].value = o_7;					i++;		
		
		if(t_dc_amt >0) dc_amt = t_dc_amt;
		
		var cv_924 = ((car_amt+(-dc_amt))/10000)-o_7;
		fm.cd[i].value = "cv_924";				fm.nm[i].value = "초과차량가격";							fm.value[i].value = cv_924;					i++;		
		
		var o_8 = 1;
		if(cv_924>0) o_8 = <%=ej_bean.getJg_8()%>;		
		fm.cd[i].value = "o_8";					fm.nm[i].value = "초과차량가격 잔가율 승수";				fm.value[i].value = o_8;					i++;		

		var cv_926 = (opt_amt+col_amt)/10000;
		fm.cd[i].value = "cv_926";				fm.nm[i].value = "선택사양가격";							fm.value[i].value = cv_926;					i++;		
		
		var o_9 = 1;
		if(cv_926>0) o_9 = <%=ej_bean.getJg_9()%>;
		fm.cd[i].value = "o_9";					fm.nm[i].value = "선택사양가격 잔가율 승수";				fm.value[i].value = o_9;					i++;		
		
		var o_g1 = o_7*o_f+(cv_924*o_f*o_8)+(cv_926*o_f*o_9);
		fm.cd[i].value = "o_g1";				fm.nm[i].value = "매각시점 중고차가 g1형";					fm.value[i].value = o_g1;					i++;		
				
		var cv_929 = (o_1/10000)-o_7;
		fm.cd[i].value = "cv_929";				fm.nm[i].value = "선택사양포함 초과차량가격";				fm.value[i].value = cv_929;					i++;		

		var o_10 = 1;
		if(cv_929>0) o_10 = <%=ej_bean.getJg_10()%>;
		fm.cd[i].value = "o_10";				fm.nm[i].value = "선택사양포함 초과차량가격 잔가율 승수";	fm.value[i].value = o_10;					i++;		

		var o_g2 = o_7*o_f+(cv_929*o_f*o_10);
		fm.cd[i].value = "o_g2";				fm.nm[i].value = "매각시점 중고차가 g2형";					fm.value[i].value = o_g2;					i++;		
		
		var o_11 = <%=ej_bean.getJg_11()%>;
		fm.cd[i].value = "o_11";				fm.nm[i].value = "중고차가결정변수";						fm.value[i].value = o_11;					i++;		
		
		var o_g = 0;
		if(o_11 == 1) 	o_g = o_g1;
		else			o_g = o_g2;
		fm.cd[i].value = "o_g";					fm.nm[i].value = "대여종료 시점 중고차가";					fm.value[i].value = o_g;					i++;		
		
		var o_h = replaceFloatRound3(o_g/(<%=bean.getO_1()%>/10000));
		fm.cd[i].value = "o_h";					fm.nm[i].value = "차량가격 적용 잔가율";					fm.value[i].value = o_h;					i++;		
		
		var g_3 = <%=em_bean.getJg_c_3()%>/100;
		fm.cd[i].value = "g_3";					fm.nm[i].value = "신차등록월에 따른 1년당 잔가율 변동값";	fm.value[i].value = g_3;					i++;		

		var cv_936 = getRentTime('l', '<%=rent_dt.substring(0,4)%>0101', '<%=rent_dt%>')+1;
		fm.cd[i].value = "cv_936";				fm.nm[i].value = "신차등록일-전년도말일";					fm.value[i].value = cv_936;					i++;		
		
		var cv_937 = 1+(g_3*(cv_936/365-0.5));
		fm.cd[i].value = "cv_937";				fm.nm[i].value = "신등차등록월에 따른 잔가율 변동값";		fm.value[i].value = cv_937;					i++;		

		var o_i = replaceFloatRound3(o_h*cv_937);
		fm.cd[i].value = "o_i";					fm.nm[i].value = "신차등록월 반영 잔가율";					fm.value[i].value = o_i;					i++;		
		
		var g_4 = <%=em_bean.getJg_c_4()%>/100;
		fm.cd[i].value = "g_4";					fm.nm[i].value = "LPG겸용차 잔가율 기초 조정값";			fm.value[i].value = g_4;					i++;		

		var g_5 = <%=em_bean.getJg_c_5()%>/100;
		fm.cd[i].value = "g_5";					fm.nm[i].value = "LPG겸용차 잔가율 1년당 조정값";			fm.value[i].value = g_5;					i++;		

		var o_j = g_4+(a_b/12)*g_5;
		if(<%=bean.getLpg_yn()%>==0) o_j = 0;
		fm.cd[i].value = "o_j";					fm.nm[i].value = "LPG키트 장착시 잔가 조정값";				fm.value[i].value = o_j;					i++;		
		
		var g_6 = <%=em_bean.getJg_c_6()%>/100;
		//테슬라
		if(<%=rent_dt%> >= 20190801 && <%=rent_dt%> < 20210216){
<%-- 			if('<%=cm_bean.getJg_code()%>'=='4854' || '<%=cm_bean.getJg_code()%>'=='5866' || '<%=cm_bean.getJg_code()%>'=='3871' || '<%=cm_bean.getJg_code()%>' == '3313111' || '<%=cm_bean.getJg_code()%>' == '3313112' || '<%=cm_bean.getJg_code()%>' == '3313113' || '<%=cm_bean.getJg_code()%>' == '3313114' || '<%=cm_bean.getJg_code()%>' == '4314111' || '<%=cm_bean.getJg_code()%>' == '6316111'){ --%>
			if('<%=cm_bean.getCar_comp_id()%>'=='0056'){
				g_6 = (<%=em_bean.getJg_c_6()%>-2.9)/100;
			}			
		}
		fm.cd[i].value = "g_6";					fm.nm[i].value = "36개월 초과견적시 잔가율 1년당 조정값";	fm.value[i].value = g_6;					i++;		

		var o_k = (a_b-36)/12*g_6;
		if(a_b<=36) o_k = 0;
		fm.cd[i].value = "o_k";					fm.nm[i].value = "36개월 초과견적시 잔가 조정값";			fm.value[i].value = o_k;					i++;		
		
		var o_12 = <%=ej_bean.getJg_12()%>;
		fm.cd[i].value = "o_12";				fm.nm[i].value = "리스크 조절 변수 (36개월 기준)";			fm.value[i].value = o_12;					i++;		

		var o_13 = <%=ej_bean.getJg_13()%>;
		fm.cd[i].value = "o_13";				fm.nm[i].value = "신차판매여부";							fm.value[i].value = o_13;					i++;		

		var a_m_1 = <%=em_bean.getA_m_1()%>/100;
		fm.cd[i].value = "a_m_1";				fm.nm[i].value = "현재 중고차 경기지수";					fm.value[i].value = a_m_1;					i++;						
			
		var a_m_2 = <%=em_bean.getA_m_2()%>/100;
		fm.cd[i].value = "a_m_2";				fm.nm[i].value = "36개월후 현재 중고차 경기지수 반영율";	fm.value[i].value = a_m_2;					i++;
		
		var a_m_3 = 1-(1-a_m_1)*a_m_2;
		fm.cd[i].value = "a_m_3";				fm.nm[i].value = "36개월후 중고차 경기지수";				fm.value[i].value = a_m_3;					i++;
		
		var o_m = replaceFloatRound((o_i*(1+o_12/36*a_b)+o_j+o_k)*a_m_3);		
		
		fm.cd[i].value = "o_m";					fm.nm[i].value = "신차견적시 최대잔가율";					fm.value[i].value = o_m;					i++;		
				
		
		//20151013 색상 및 사양 잔가 반영
		if(<%=rent_dt%> >= 20151013){
					
			var ax14 = new Array();	
			var ax14_s = new Array();	
			
			ax14[0] = 0;
			ax14_s[0] = 0;
						
			<%for(int j=0 ; j < s ; j++){
				//차종변수 색상사양 잔가변수
				EstiJgVarBean ejo_bean = e_db.getEstiJgOptVarCase(ej_bean.getSh_code(), ej_bean.getSeq(), app_value[j]);
			%>
								
				if(a_b < <%=ejo_bean.getJg_opt_6()%>){
					ax14_s[0] = <%=ejo_bean.getJg_opt_7()%>;
				}else{
					ax14_s[0] = <%=ejo_bean.getJg_opt_7()%>*(1-(a_b-<%=ejo_bean.getJg_opt_6()%>)*0.0125);
				}				
				

				fm.cd[i].value = "ax14_s[0]";	fm.nm[i].value = "색상 및 사양 잔가반영 적용값";				fm.value[i].value = ax14_s[0];				i++;			
								
				ax14[0] = ax14[0] + ax14_s[0];
			
			<%}%>
			
			fm.cd[i].value = "ax14[0]";		fm.nm[i].value = "색상 및 사양 잔가반영 적용합계";				fm.value[i].value = ax14[0];				i++;			
			
			o_m = replaceFloatRound((o_i*(1+o_12/36*a_b)+o_j+o_k)*a_m_3+ax14[0]/(<%=o_1%>/10000));					
																	
		}
		
		fm.cd[i].value = "o_m";					fm.nm[i].value = "신차견적시 최대잔가율";					fm.value[i].value = o_m;					i++;		

		
				
/*				
		if(<%=rent_dt%> >= 20081127 && '<%=ej_bean.getJg_2()%>' == '1'){//LPG견적프로그램적용
			var ro_13_4 = o_m = replaceFloatRound2(o_m/(1-a_b/12*0.02*0.65));
			var ro_13_5 = o_m = replaceFloatRound2(ro_13_4*(1-a_b/12*0.02*1.3));
			var ro_13_6 = o_m = replaceFloatRound2(ro_13_5*(1-a_b/12*0.02*1.3));
			var ro_13_f = o_m = replaceFloatRound2(ro_13_6*(1-a_b/12*0.02*1.3));
			if(<%=agree_dist%>==1)			o_m = ro_13_4;
			if(<%=agree_dist%>==2)			o_m = ro_13_5;
			if(<%=agree_dist%>==3)			o_m = ro_13_6;
			if(<%=agree_dist%>==9)			o_m = ro_13_f;									
		}
*/		
		<%if(mode.equals("lc_rent")){%>			
			parent.document.form1.max_ja.value 			= o_m;
			parent.document.form1.ja_amt.value 			= parseDecimal(getCutRoundNumber(<%=bean.getO_1()%>*o_m/100,-3));
			parent.document.form1.ja_s_amt.value 		= parseDecimal(sup_amt(toInt(parseDigit(parent.document.form1.ja_amt.value))));
			parent.document.form1.ja_v_amt.value 		= parseDecimal(toInt(parseDigit(parent.document.form1.ja_amt.value)) - toInt(parseDigit(parent.document.form1.ja_s_amt.value)));
			if(toInt(parseDigit(parent.document.form1.opt_amt.value)) == 0){
				parent.document.form1.app_ja.value 		= parent.document.form1.max_ja.value;
				parent.document.form1.ja_r_s_amt.value 	= parent.document.form1.ja_s_amt.value;
				parent.document.form1.ja_r_v_amt.value 	= parent.document.form1.ja_v_amt.value;
				parent.document.form1.ja_r_amt.value 	= parent.document.form1.ja_amt.value;		
			}				
		<%}else if(mode.equals("cmp")){%>
			parent.document.form1.o_13.value 			= o_m;
			parent.document.form1.ro_13.value 			= o_m;			
			parent.document.form1.ro_13_amt.value 		= parseDecimal(getCutRoundNumber(<%=bean.getO_1()%>*o_m/100,-3));
			parent.opt_display();
		<%}else{%>
			parent.document.form1.o_13.value 			= o_m;
			parent.document.form1.ro_13.value 			= o_m;
			parent.document.form1.ro_13_amt.value 		= parseDecimal(getCutRoundNumber(<%=bean.getO_1()%>*o_m/100,-3));		
		<%}%>
	}
	
	//반올림
	function getCutRoundNumber(num, place){
		var returnNum;
		var st="1";
		return Math.round( num * Math.pow(10,parseInt(place,10)) ) / Math.pow(10,parseInt(place,10));
	}		
//-->
</script>
</head>
<body>
<form action="" name="form1" method="POST" >
  <table border=0 cellspacing=0 cellpadding=0 width=800>
	<tr>
      <td>계산과정</td>
    </tr>
      <td class=line><table border="0" cellspacing="1" width=100%>
        <tr>
          <td width="30" class=title>연번</td>
          <td width="100" class=title>기호</td>
          <td width="370" class=title>항목</td>
          <td width="300" class=title>값</td>
          </tr>
		  <%for(int i=0; i<150; i++){%>
          <tr>
		  	<td align="center"><%=i%></td>
            <td>&nbsp;<input type="text" name="cd" value="" size="15" class=whitetext></td>
            <td>&nbsp;<input type="text" name="nm" value="" size="45" class=whitetext></td>
            <td>&nbsp;<input type="text" name="value" value="" size="40" class=whitetext></td>          
          </tr>
		  <%}%>
      </table></td>
    </tr>	
</table>	
</form>	
<script>
<!--
	getShCarAmt();	
//-->
</script>	
</body>
</html>
