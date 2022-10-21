<%@ page language="java" contentType="text/html; charset=euc-kr" %>
<%@ page import="java.util.*, acar.util.*, acar.estimate_mng.*, acar.car_mst.*" %>
<jsp:useBean id="bean" class="acar.estimate_mng.EstimateBean" scope="page"/>
<jsp:useBean id="cm_bean" class="acar.car_mst.CarMstBean" scope="page"/>
<jsp:useBean id="rs_db" scope="page" class="acar.res_search.ResSearchDatabase"/>
<%@ include file="/smart/cookies.jsp" %>

<%
	//20090901 중도해지위약율 계산을 위한 15개월 잔가 계산 적용
	
	bean.setCar_comp_id	(request.getParameter("car_comp_id")==null?"":request.getParameter("car_comp_id"));
	bean.setCar_cd		(request.getParameter("code")==null?"":request.getParameter("code"));
	bean.setCar_id		(request.getParameter("car_id")==null?"":request.getParameter("car_id"));
	bean.setCar_seq		(request.getParameter("car_seq")==null?"":request.getParameter("car_seq"));
	bean.setCar_amt		(request.getParameter("car_amt")==null?0:AddUtil.parseDigit(request.getParameter("car_amt")));
	bean.setOpt				(request.getParameter("opt")==null?"":request.getParameter("opt"));
	bean.setOpt_seq		(request.getParameter("opt_seq")==null?"":request.getParameter("opt_seq"));
	bean.setOpt_amt		(request.getParameter("opt_amt")==null?0:AddUtil.parseDigit(request.getParameter("opt_amt")));
	bean.setOpt_amt_m	(request.getParameter("opt_amt_m")==null?0:AddUtil.parseDigit(request.getParameter("opt_amt_m")));
	bean.setCol				(request.getParameter("col")==null?"":request.getParameter("col"));
	bean.setCol_seq		(request.getParameter("col_seq")==null?"":request.getParameter("col_seq"));
	bean.setCol_amt		(request.getParameter("col_amt")==null?0:AddUtil.parseDigit(request.getParameter("col_amt")));
	bean.setDc				(request.getParameter("dc")==null?"":request.getParameter("dc"));
	bean.setDc_seq		(request.getParameter("dc_seq")==null?"":request.getParameter("dc_seq"));
	bean.setDc_amt		(request.getParameter("dc_amt")==null?0:AddUtil.parseDigit(request.getParameter("dc_amt")));
	bean.setTax_dc_amt	(request.getParameter("tax_dc_amt")==null?0:AddUtil.parseDigit(request.getParameter("tax_dc_amt")));
	bean.setO_1				(request.getParameter("o_1")==null?0:AddUtil.parseDigit(request.getParameter("o_1")));
	bean.setA_a				(request.getParameter("a_a")==null?"":request.getParameter("a_a"));
	bean.setA_b				(request.getParameter("a_b")==null?"":request.getParameter("a_b"));
	bean.setA_h				(request.getParameter("a_h")==null?"":request.getParameter("a_h"));
	bean.setPp_st			(request.getParameter("pp_st")==null?"0":request.getParameter("pp_st"));
	bean.setPp_per		(request.getParameter("pp_per")==null?0:AddUtil.parseFloat(request.getParameter("pp_per")));
	bean.setPp_amt		(request.getParameter("pp_amt")==null?0:AddUtil.parseDigit(request.getParameter("pp_amt")));
	bean.setRg_8			(request.getParameter("rg_8")==null?0:AddUtil.parseFloat(request.getParameter("rg_8")));
	bean.setIns_good	(request.getParameter("ins_good")==null?"":request.getParameter("ins_good"));
	bean.setIns_age		(request.getParameter("ins_age")==null?"":request.getParameter("ins_age"));
	bean.setIns_dj		(request.getParameter("ins_dj")==null?"":request.getParameter("ins_dj"));
	bean.setRo_13			(request.getParameter("ro_13")==null?0:AddUtil.parseFloat(request.getParameter("ro_13")));
	bean.setG_10			(request.getParameter("g_10")==null?0:AddUtil.parseDigit(request.getParameter("g_10")));
	bean.setCar_ja		(request.getParameter("car_ja")==null?0:AddUtil.parseDigit(request.getParameter("car_ja")));
	bean.setLpg_yn		(request.getParameter("lpg_yn")==null?"0":request.getParameter("lpg_yn"));
	bean.setGi_yn			(request.getParameter("gi_yn")==null?"0":request.getParameter("gi_yn"));
	bean.setReg_dt		(request.getParameter("reg_dt")==null?"":request.getParameter("reg_dt"));
	bean.setRo_13_amt	(request.getParameter("ro_13_amt")==null?0:AddUtil.parseDigit(request.getParameter("ro_13_amt")));
	bean.setRg_8_amt	(request.getParameter("rg_8_amt")==null?0:AddUtil.parseDigit(request.getParameter("rg_8_amt")));
	bean.setFee_dc_per(request.getParameter("fee_dc_per")==null?0:AddUtil.parseFloat(request.getParameter("fee_dc_per")));	
	bean.setSpr_yn		(request.getParameter("spr_yn")==null?"0":request.getParameter("spr_yn"));
	bean.setEst_tel		("1");
	
	int o_1 			= request.getParameter("o_1")==null? 0:Util.parseDigit(request.getParameter("o_1"));
	int opt_amt2 = bean.getOpt_amt()-bean.getOpt_amt_m();
	
	int r_o_l 		= request.getParameter("r_o_l")==null?0:AddUtil.parseDigit(request.getParameter("r_o_l"));
	int r_dc_amt 		= request.getParameter("r_dc_amt")==null?0:AddUtil.parseDigit(request.getParameter("r_dc_amt"));
	int agree_dist 		= request.getParameter("agree_dist")	==null? 0:Util.parseDigit(request.getParameter("agree_dist"));
	
	if(r_o_l >0) 	bean.setO_1		(r_o_l);
	if(r_dc_amt >0) bean.setDc_amt		(r_dc_amt);
	
	
	AddCarMstDatabase 	a_cmb 	= AddCarMstDatabase.getInstance();
	EstiDatabase 		e_db 	= EstiDatabase.getInstance();
	
	String rent_dt = AddUtil.getDate(4);
	String rent_st = "0";
	
	String jg_b_dt = e_db.getVar_b_dt("jg", rent_dt);
	String em_a_j  = e_db.getVar_b_dt("em", rent_dt);

	
	//CAR_NM : 차명정보
	cm_bean = a_cmb.getCarNmCase(bean.getCar_id(), bean.getCar_seq());
	
	//중고차잔가변수
	EstiJgVarBean ej_bean = e_db.getEstiJgVarCase(cm_bean.getJg_code(), jg_b_dt);
	
	//공통변수
	EstiCommVarBean em_bean = e_db.getEstiCommVarCase("1", "", em_a_j);
	
	if(bean.getA_a().equals("21") || bean.getA_a().equals("22")){
		em_bean = e_db.getEstiCommVarCase("2", "", em_a_j);
	}
	
	
	String est_from = request.getParameter("est_from")==null?"":request.getParameter("est_from");
	String est_st   = request.getParameter("est_st")==null?"":request.getParameter("est_st");
	String jg_opt_st	= request.getParameter("jg_opt_st")	==null?"":request.getParameter("jg_opt_st");
	String jg_col_st	= request.getParameter("jg_col_st")	==null?"":request.getParameter("jg_col_st");
	String ecar_loc_st	= request.getParameter("ecar_loc_st")	==null?"":request.getParameter("ecar_loc_st");
	String eco_e_tag	= request.getParameter("eco_e_tag")	==null?"":request.getParameter("eco_e_tag");
	String hcar_loc_st	= request.getParameter("hcar_loc_st")	==null?"":request.getParameter("hcar_loc_st");
	String rtn_run_amt_yn	= request.getParameter("rtn_run_amt_yn")	==null?"":request.getParameter("rtn_run_amt_yn");
	
	
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
	
	out.println("jg_opt_st="+jg_opt_st);
%>

<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN">
<html>
<head>
<title>FMS</title>
<meta http-equiv="Content-Type" content="text/html; charset=euc-kr">
<link rel="stylesheet" type="text/css" href="/include/table_t.css">
<script language='JavaScript' src='/include/estimate.js'></script>
<script language="JavaScript">
<!--
	//소숫점절삭
	function getCutNumber(num, place){
		var returnNum;
		var st="1";
		return Math.floor( num * Math.pow(10,parseInt(place,10)) ) / Math.pow(10,parseInt(place,10));
	}
	
	//반올림
	function getCutRoundNumber(num, place){
		var returnNum;
		var st="1";
		return Math.round( num * Math.pow(10,parseInt(place,10)) ) / Math.pow(10,parseInt(place,10));
	}
	
	
	function replaceFloatRound(per){
		return Math.round(per*1000)/10;	
	}
	
	function replaceFloatRound2(per){
		return Math.round(per*10)/10;	
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
		
		var cls_mon = 15; //중도해지위약율계산 - 개월수
		
		//선택사항=========================================================================================
				
		fm.cd[i].value = "";				fm.nm[i].value = "---------------------------"; 				fm.value[i].value = '선택사항 -----';		i++;				
						
		var rent_dt = <%=rent_dt%>;
		fm.cd[i].value = "rent_dt";			fm.nm[i].value = "견적기준일";								fm.value[i].value = rent_dt;				i++;		
		
		var jg_code = <%=ej_bean.getSh_code()%>;
		fm.cd[i].value = "jg_code";			fm.nm[i].value = "차종코드";									fm.value[i].value = jg_code;				i++;		
		
		var car_amt = <%=bean.getCar_amt()%>;
		fm.cd[i].value = "car_amt";			fm.nm[i].value = "차량가격";									fm.value[i].value = car_amt;				i++;		
		
		var opt_amt = <%=bean.getOpt_amt()%>;
		fm.cd[i].value = "opt_amt";			fm.nm[i].value = "선택사양가격";								fm.value[i].value = opt_amt;				i++;		
		
		var opt_amt2 = <%=opt_amt2%>;
		fm.cd[i].value = "opt_amt2";		fm.nm[i].value = "선택사양가격2";									fm.value[i].value = opt_amt2;				i++;
		
		var opt_amt_m = <%=bean.getOpt_amt_m()%>;
		fm.cd[i].value = "opt_amt_m";		fm.nm[i].value = "잔가미반영가격";								fm.value[i].value = opt_amt_m;			i++;		
		
		var col_amt = <%=bean.getCol_amt()%>;
		fm.cd[i].value = "col_amt";			fm.nm[i].value = "색상사양가격";								fm.value[i].value = col_amt;				i++;		
		
		var dc_amt = <%=bean.getDc_amt()%>;
		fm.cd[i].value = "dc_amt";			fm.nm[i].value = "DC가격";									fm.value[i].value = dc_amt;					i++;		
		
		var tax_dc_amt = <%=bean.getTax_dc_amt()%>;
		fm.cd[i].value = "tax_dc_amt";			fm.nm[i].value = "개소세감면금액";							fm.value[i].value = tax_dc_amt;			i++;
		
		var o_1 = <%=bean.getO_1()%>;
		var o_1_2 = <%=o_1%>-opt_amt+opt_amt2;
		fm.cd[i].value = "o_1";			fm.nm[i].value = "차량가격";									fm.value[i].value = o_1;						i++;
		fm.cd[i].value = "o_1_2";			fm.nm[i].value = "차량가격2";							fm.value[i].value = o_1_2;						i++;
		
		a_a_b = new Array();
		a_a_b[0] = <%=bean.getA_b()%>;
		a_a_b[1] = Math.round(<%=bean.getA_b()%>/2);
		
		fm.cd[i].value = "a_a_b[0]";		fm.nm[i].value = "견적개월수";								fm.value[i].value = a_a_b[0];				i++;		
		fm.cd[i].value = "a_a_b[1]";		fm.nm[i].value = "견적개월수-해지율";						fm.value[i].value = a_a_b[1];				i++;		
		
		var rent_st = <%=rent_st%>;
		fm.cd[i].value = "rent_st";			fm.nm[i].value = "대여구분"	;									fm.value[i].value = rent_st;				i++;		
		

		
		fm.cd[i].value = "";				fm.nm[i].value = "---------------------------"; fm.value[i].value = '재리스차량 현재잔가율 산출과정 -------------';			i++;				

		var o_a = <%=ej_bean.getJg_1()%>;
		fm.cd[i].value = "a_a";				fm.nm[i].value = "현시점 차령 24개월 잔가율";				fm.value[i].value = o_a;					i++;		

		var g_1 = <%=em_bean.getJg_c_1()%>/100;		
		fm.cd[i].value = "g_1";				fm.nm[i].value = "0개월 기준 잔가";							fm.value[i].value = g_1;				i++;
		g_1 = g_1*(1-<%=ej_bean.getJg_g_2()%>*0.35);
		g_1 = g_1*(1-<%=ej_bean.getJg_g_9()%>+<%=ej_bean.getJg_g_10()%>); //20160822
		g_1 = getCutNumber(g_1,9);
		fm.cd[i].value = "g_1";				fm.nm[i].value = "0개월 기준 잔가";							fm.value[i].value = g_1;				i++;

		var o_2 = <%=ej_bean.getJg_2()%>;
		fm.cd[i].value = "o_2";				fm.nm[i].value = "일반승용 LPG 여부";							fm.value[i].value = o_2;					i++;		

		var o_3 = <%=ej_bean.getJg_3()%>;
		fm.cd[i].value = "o_3";				fm.nm[i].value = "기본 특소세율";								fm.value[i].value = o_3;					i++;
		
		if('<%=cm_bean.getDuty_free_opt()%>' =='1'){ //20190502 면세가표기차량
			car_amt = car_amt*(1+o_3);
			opt_amt = opt_amt*(1+o_3);
			opt_amt2 = opt_amt2*(1+o_3);
			col_amt = col_amt*(1+o_3);
			o_1 = o_1*(1+o_3)-(-dc_amt*o_3);
			o_1_2 = o_1_2*(1+o_3)-(-dc_amt*o_3);
			fm.cd[i].value = "car_amt";				fm.nm[i].value = "car_amt";					fm.value[i].value = car_amt;				i++;
			fm.cd[i].value = "opt_amt";				fm.nm[i].value = "opt_amt";					fm.value[i].value = opt_amt;				i++;
			fm.cd[i].value = "opt_amt2";			fm.nm[i].value = "opt_amt2";				fm.value[i].value = opt_amt;				i++;
			fm.cd[i].value = "col_amt";				fm.nm[i].value = "col_amt";					fm.value[i].value = col_amt;				i++;
			fm.cd[i].value = "o_1";					fm.nm[i].value = "o_1";						fm.value[i].value = o_1;					i++;
			fm.cd[i].value = "o_1_2";				fm.nm[i].value = "o_1_2";					fm.value[i].value = o_1_2;					i++;
		}

		var o_b = g_1+(o_a-0.6*(1-<%=ej_bean.getJg_g_9()%>+<%=ej_bean.getJg_g_10()%>))*0.5; //20190419 LPG차량 과세
		o_b = getCutNumber(o_b,9);
		fm.cd[i].value = "a_a";				fm.nm[i].value = "현시점 차령 0개월 잔가율";					fm.value[i].value = o_b;					i++;		

		var g_2 = <%=em_bean.getJg_c_2()%>/100;
		fm.cd[i].value = "g_2";				fm.nm[i].value = "차령24개월 잔가율 2년간 변동율";				fm.value[i].value = g_2;					i++;		

		var o_c = o_a*(1+g_2);
		o_c = getCutNumber(o_c,9);
		fm.cd[i].value = "o_c";				fm.nm[i].value = "2년후 차령 24개월 잔가율";					fm.value[i].value = o_c;					i++;		

		var o_4 = <%=ej_bean.getJg_4()%>*0;
		fm.cd[i].value = "o_4";				fm.nm[i].value = "최저잔가율 조정승수(최대0.4)";				fm.value[i].value = o_4;					i++;		
		
		var o_d = o_c*o_4;
		o_d = getCutNumber(o_d,9);
		fm.cd[i].value = "o_d";				fm.nm[i].value = "최저 잔가율";									fm.value[i].value = o_d;					i++;		

		var o_5 = <%=ej_bean.getJg_5()%>;
		fm.cd[i].value = "o_5";				fm.nm[i].value = "환경변수(36개월효과기준)";					fm.value[i].value = o_5;					i++;		
		
		a_o_e = new Array();
		a_o_e[0] = o_d+Math.pow((o_c-o_d)/(o_b-o_d),a_a_b[0]/24)*(o_b-o_d)*(1+o_5/36*a_a_b[0]);
		a_o_e[1] = o_d+Math.pow((o_c-o_d)/(o_b-o_d),a_a_b[1]/24)*(o_b-o_d)*(1+o_5/36*a_a_b[1]);
		a_o_e[0] = getCutNumber(a_o_e[0],9);
		a_o_e[1] = getCutNumber(a_o_e[1],9);		
		fm.cd[i].value = "a_o_e[0]";		fm.nm[i].value = "차령 적용 평균잔가율(대여종료 시점 기준)";	fm.value[i].value = a_o_e[0];				i++;		
		fm.cd[i].value = "a_o_e[1]";		fm.nm[i].value = "차령 적용 평균잔가율(대여종료 시점 기준)";	fm.value[i].value = a_o_e[1];				i++;						
		
		var o_6 = <%=ej_bean.getJg_6()%>;
		fm.cd[i].value = "o_6";				fm.nm[i].value = "기본차량 잔가율 승수";						fm.value[i].value = o_6;					i++;		

		//개소세감면액		 //20160822
		var ch_327 = 0;		
		var bk_122 = 0;
		var ch_315 = car_amt+opt_amt+col_amt-dc_amt;
		var ch_326 = ch_315/(1+o_3);
		<%if(!ej_bean.getJg_w().equals("1")){%>
		<%	if(ej_bean.getJg_g_7().equals("1")||ej_bean.getJg_g_7().equals("2")||ej_bean.getJg_g_7().equals("3")||ej_bean.getJg_g_7().equals("4")){%>
		if('<%=ej_bean.getJg_g_7()%>'=='1') bk_122 = 1300000;
		if('<%=ej_bean.getJg_g_7()%>'=='2') bk_122 = 1300000;
		if('<%=ej_bean.getJg_g_7()%>'=='3') bk_122 = 3900000;
		if('<%=ej_bean.getJg_g_7()%>'=='4') bk_122 = 5200000;		
		if(ch_315-ch_326<bk_122*1.1) 		ch_327 = ch_315-ch_326;
		else                         		ch_327 = bk_122*1.1;		
		ch_327 = getCutRoundNumber(ch_327,0);	
		if('<%=cm_bean.getJg_code()%>' == '2361' || '<%=cm_bean.getJg_code()%>' == '2362' || '<%=cm_bean.getJg_code()%>'=='2031111' || '<%=cm_bean.getJg_code()%>'=='2031112' || '<%=cm_bean.getJg_code()%>'=='5033111')		ch_327 = 0;//볼트EV
		if('<%=cm_bean.getJg_code()%>'=='9133' || '<%=cm_bean.getJg_code()%>'=='9015435' || '<%=cm_bean.getJg_code()%>'=='9015436' || '<%=cm_bean.getJg_code()%>'=='9015437')		ch_327 = 0;//포터일렉
		fm.cd[i].value = "ch_315";				fm.nm[i].value = "차량가격(소비자차가)";							fm.value[i].value = ch_315;				i++;		
		fm.cd[i].value = "ch_326";				fm.nm[i].value = "개소세전차량가(vat포함)";						fm.value[i].value = ch_326;				i++;		
		fm.cd[i].value = "bk_122";				fm.nm[i].value = "개소세 감면 한도(교육세포함,부가세전)"; 	fm.value[i].value = bk_122;				i++;		
		fm.cd[i].value = "ch_327";				fm.nm[i].value = "국산차 친환경차 개소세/교육세감면액"; 		fm.value[i].value = ch_327;				i++;		
	  	<%	}%>
	  	<%}%>
	  
		//개소세 한시적 감면 20200301~20200630****************************
	  	var bk_175 = 0.7;     //감면율
	  	var bk_176 = 1430000; //개소세 감면 한도(교육세포함,부가세포함)
	  	var bk_177 = 0;
	  	<%if(!ej_bean.getJg_w().equals("1")){ //수입차제외%>
	  	<%		if(cm_bean.getDuty_free_opt().equals("1")){//면세가표기차량 제오%>
	  	<%		}else{%>
					if(ch_315<33471429){
						bk_177 = ch_326*o_3*bk_175;	
					}else{
						bk_177 = bk_176;
					}	              	
					bk_177 = getCutRoundNumber(bk_177,-4);	
					if('<%=cm_bean.getJg_code()%>' == '2361' || '<%=cm_bean.getJg_code()%>'=='2031111' || '<%=cm_bean.getJg_code()%>'=='5033111')	bk_177 = 0;//볼트EV
					fm.cd[i].value = "bk_177";				fm.nm[i].value = "개소세 한시적 감면액";							fm.value[i].value = bk_177;				i++;
	  	<%		}%>
	  	<%}%>
	  	//20200701 감면종료
		bk_177 = 0;
	  	
		//감면 미적용 개별소비세(인하한도 초과금액) 20210101~20210630**********************
	  	var bk_216 = 0;
	  	if(<%=rent_dt%> >= 20210101){
	  	<%if(!ej_bean.getJg_w().equals("1")){ //수입차제외%>
	  	<%		if(cm_bean.getDuty_free_opt().equals("1")){//면세가표기차량 제오%>
	  	<%		}else{%>
					if(ch_315-ch_326>0 && (ch_326/1.1)>66666666){
						bk_216 = ((ch_326/1.1)-66666666) * 0.0195 * 1.1;	
					}	    					
					bk_216 = getCutRoundNumber(bk_216,-4);						
	  	<%		}%>
	  	<%}%>
	  	}
	  	fm.cd[i].value = "bk_216";				fm.nm[i].value = "감면 미적용 개별소비세(인하한도 초과금액)";			fm.value[i].value = bk_216;				i++;
	  	
		var ch327Nbk177 = ch_327;
	  	
	  	if(bk_177>0){
	  		if(ch_315-ch_326<bk_177+(bk_122*1.1)) 	ch327Nbk177 = ch_315-ch_326;
			else                         			ch327Nbk177 = bk_177+(bk_122*1.1);
	  	}
	  	if(bk_216>0){
	  		if(ch_315-ch_326<-bk_216+(bk_122*1.1)) 	ch327Nbk177 = ch_315-ch_326;
			else                         			ch327Nbk177 = -bk_216+(bk_122*1.1);
	  	}
	  	
	  	fm.cd[i].value = "ch327Nbk177";						fm.nm[i].value = "국산차 친환경차 개소세/교육세 감면액(일반차 한시감면)";	fm.value[i].value = ch327Nbk177;		i++;
	  	
	  	if(ch327Nbk177>0 || ch327Nbk177<0){
	  		o_1 = car_amt+opt_amt+col_amt-dc_amt-ch327Nbk177;
	  	
	  		if('<%=cm_bean.getDuty_free_opt()%>' =='1'){ //20190502 면세가표기차량
	  		
	  		}else{
	  			o_1_2 = car_amt+opt_amt+col_amt-dc_amt-opt_amt+opt_amt2-ch327Nbk177;	
	  		}
	  	}
		
		a_o_f = new Array();
		a_o_f[0] = a_o_e[0]*o_6;
		a_o_f[1] = a_o_e[1]*o_6;
		a_o_f[0] = getCutNumber(a_o_f[0],9);
		a_o_f[1] = getCutNumber(a_o_f[1],9);
		fm.cd[i].value = "a_o_f[0]";		fm.nm[i].value = "대여종료시점 기본차량 잔가율";				fm.value[i].value = a_o_f[0];				i++;		
		fm.cd[i].value = "a_o_f[1]";		fm.nm[i].value = "대여종료시점 기본차량 잔가율";				fm.value[i].value = a_o_f[1];				i++;		
		
		var o_7 = <%=ej_bean.getJg_7()%>;
		fm.cd[i].value = "o_7";				fm.nm[i].value = "기본차량가격";								fm.value[i].value = o_7;					i++;		
		
		var cv_924 = ((car_amt+(-dc_amt))/10000)-o_7;
		if(<%=rent_dt%> >= 20160601){
			cv_924 = cv_924-((-dc_amt)/10000*<%=em_bean.getJg_c_12()%>/100);
		}
		if(<%=rent_dt%> >= 20171018){
			if(<%=rent_dt%> >= 20200301){
				cv_924 = cv_924-(ch327Nbk177/10000);
			}else{
				cv_924 = cv_924-(tax_dc_amt/10000);
			}				
		}
		fm.cd[i].value = "cv_924";				fm.nm[i].value = "초과차량가격";							fm.value[i].value = cv_924;					i++;		
		
		var o_8 = 1;
		if(cv_924>0) o_8 = <%=ej_bean.getJg_8()%>;		
		fm.cd[i].value = "o_8";					fm.nm[i].value = "초과차량가격 잔가율 승수";				fm.value[i].value = o_8;					i++;		


	  

	  //정부+지자체 보조금  20180109
	  var bk_128 = 0;
	  var bk_129 = 0;
	  var ecar_amt = 0;
	  <%if(ej_bean.getJg_g_7().equals("1")){%>
	  	bk_128 = 0; //20190101 소멸
	  <%}else if(ej_bean.getJg_g_7().equals("2")){%>
	  	bk_128 = 5000000;
	  <%}else if(ej_bean.getJg_g_7().equals("3")){%>
	  	bk_128 = <%=ej_bean.getJg_g_15()%>;	// 2018.02.01 적용 예정
	  	<%-- <%if(eco_e_tag.equals("1")) ecar_loc_st = "0"; //맑은서울스티커 발급은 서울지원금%> --%>
	  	<%      if(ecar_loc_st.equals("0")){%>	ecar_amt = <%=em_bean.getEcar_0_amt()%>;
	  	<%}else if(ecar_loc_st.equals("1")){%>	ecar_amt = <%=em_bean.getEcar_1_amt()%>;
	  	<%}else if(ecar_loc_st.equals("2")){%>	ecar_amt = <%=em_bean.getEcar_2_amt()%>;
	  	<%}else if(ecar_loc_st.equals("3")){%>	ecar_amt = <%=em_bean.getEcar_3_amt()%>; 
	  	<%}else if(ecar_loc_st.equals("4")){%>	ecar_amt = <%=em_bean.getEcar_4_amt()%>;
	  	<%}else if(ecar_loc_st.equals("5")){%>	ecar_amt = <%=em_bean.getEcar_5_amt()%>;
	  	<%}else if(ecar_loc_st.equals("6")){%>	ecar_amt = <%=em_bean.getEcar_6_amt()%>;
	  	<%}else if(ecar_loc_st.equals("7")){%>	ecar_amt = <%=em_bean.getEcar_7_amt()%>;
	  	<%}else if(ecar_loc_st.equals("8")){%>	ecar_amt = <%=em_bean.getEcar_8_amt()%>;
  		<%}else if(ecar_loc_st.equals("9")){%>	ecar_amt = <%=em_bean.getEcar_9_amt()%>;
  		<%}else if(ecar_loc_st.equals("10")){%>	ecar_amt = <%=em_bean.getEcar_10_amt()%>;
	  	<%}%>
	  	//20210302 차종코드별변수로 처리
	  	ecar_amt = 0;
	  	<%      if(ecar_loc_st.equals("0")){%>	ecar_amt = <%=ej_bean.getJg_g_38()%>;
	  	<%}else if(ecar_loc_st.equals("1")){%>	ecar_amt = <%=ej_bean.getJg_g_39()%>;
	  	<%}else if(ecar_loc_st.equals("3")){%>	ecar_amt = <%=ej_bean.getJg_g_40()%>; 
	  	<%}else if(ecar_loc_st.equals("4")){%>	ecar_amt = <%=ej_bean.getJg_g_43()%>;
	  	<%}else if(ecar_loc_st.equals("5")){%>	ecar_amt = <%=ej_bean.getJg_g_41()%>;	
	  	<%}else if(ecar_loc_st.equals("6")){%>	ecar_amt = <%=ej_bean.getJg_g_42()%>;
	  	<%}%>
	  	bk_129 = ecar_amt*10000;
	  <%}else if(ej_bean.getJg_g_7().equals("4")){%>
	  	bk_128 = <%=ej_bean.getJg_g_15()%>;	//정부보조금
	  	<%-- <%if(eco_e_tag.equals("1")) hcar_loc_st = "0"; //맑은서울스티커 발급은 서울지원금%> --%>
	  	<%      if(hcar_loc_st.equals("0")){%>	ecar_amt = <%=em_bean.getHcar_0_amt()%>;
	  	<%}else if(hcar_loc_st.equals("1")){%>	ecar_amt = <%=em_bean.getHcar_1_amt()%>;
	  	<%}else if(hcar_loc_st.equals("2")){%>	ecar_amt = <%=em_bean.getHcar_2_amt()%>;
	  	<%}else if(hcar_loc_st.equals("3")){%>	ecar_amt = <%=em_bean.getHcar_3_amt()%>; 
	  	<%}else if(hcar_loc_st.equals("4")){%>	ecar_amt = <%=em_bean.getHcar_4_amt()%>;
	  	<%}else if(hcar_loc_st.equals("5")){%>	ecar_amt = <%=em_bean.getHcar_5_amt()%>;
	  	<%}else if(hcar_loc_st.equals("6")){%>	ecar_amt = <%=em_bean.getHcar_6_amt()%>;
	  	<%}else if(hcar_loc_st.equals("7")){%>	ecar_amt = <%=em_bean.getHcar_7_amt()%>;
	  	<%}else if(hcar_loc_st.equals("8")){%>	ecar_amt = <%=em_bean.getHcar_8_amt()%>;
	  	<%}%>
	  	//20210302 차종코드별변수로 처리
	  	ecar_amt = 0;
	  	<%      if(ecar_loc_st.equals("0")){%>	ecar_amt = <%=ej_bean.getJg_g_38()%>;
	  	<%}else if(ecar_loc_st.equals("1")){%>	ecar_amt = <%=ej_bean.getJg_g_39()%>;
	  	<%}else if(ecar_loc_st.equals("3")){%>	ecar_amt = <%=ej_bean.getJg_g_40()%>; 
	  	<%}else if(ecar_loc_st.equals("4")){%>	ecar_amt = <%=ej_bean.getJg_g_43()%>;
	  	<%}else if(ecar_loc_st.equals("5")){%>	ecar_amt = <%=ej_bean.getJg_g_41()%>;	
	  	<%}else if(ecar_loc_st.equals("6")){%>	ecar_amt = <%=ej_bean.getJg_g_42()%>;
	  	<%}%>
	  	bk_129 = ecar_amt*10000;
	  <%}%>	
	  //정부+지자체 구매보조금 20180109
	  var k_cb_5 = 0;
	  var k_cb_6 = 0;
	  var ecar_pur_sub_amt = 0;
	  k_cb_5 = <%=ej_bean.getJg_g_8()%>*bk_128;
	  ecar_pur_sub_amt = k_cb_5;
	  k_cb_6 = bk_129;
	  ecar_pur_sub_amt = ecar_pur_sub_amt+k_cb_6;
	  	  
		var cv_926 = (opt_amt2+col_amt)/10000;
		fm.cd[i].value = "cv_926";				fm.nm[i].value = "선택사양가격";							fm.value[i].value = cv_926;					i++;		
		
		var o_9 = 1;
		if(cv_926>0) o_9 = <%=ej_bean.getJg_9()%>;
		fm.cd[i].value = "o_9";					fm.nm[i].value = "선택사양가격 잔가율 승수";				fm.value[i].value = o_9;					i++;		
		
		a_o_g1 = new Array();
		a_o_g1[0] = o_7*a_o_f[0]+(cv_924*a_o_f[0]*o_8)+(cv_926*a_o_f[0]*o_9);
		a_o_g1[1] = o_7*a_o_f[1]+(cv_924*a_o_f[1]*o_8)+(cv_926*a_o_f[1]*o_9);
		a_o_g1[0] = getCutNumber(a_o_g1[0],9);
		a_o_g1[1] = getCutNumber(a_o_g1[1],9);
		fm.cd[i].value = "a_o_g1[0]";			fm.nm[i].value = "매각시점 중고차가 g1형";					fm.value[i].value = a_o_g1[0];				i++;				
		fm.cd[i].value = "a_o_g1[1]";			fm.nm[i].value = "매각시점 중고차가 g1형";					fm.value[i].value = a_o_g1[1];				i++;				
				
		var cv_929 = (o_1_2/10000)-o_7;	 //20160822
		cv_929 = cv_929-((-dc_amt)/10000*<%=em_bean.getJg_c_12()%>/100);
		fm.cd[i].value = "cv_929";				fm.nm[i].value = "선택사양포함 초과차량가격";				fm.value[i].value = cv_929;					i++;		

		var o_10 = 1;
		if(cv_929>0) o_10 = <%=ej_bean.getJg_10()%>;
		fm.cd[i].value = "o_10";				fm.nm[i].value = "선택사양포함 초과차량가격 잔가율 승수";	fm.value[i].value = o_10;					i++;		

		a_o_g2 = new Array();
		a_o_g2[0] = o_7*a_o_f[0]+(cv_929*a_o_f[0]*o_10);
		a_o_g2[1] = o_7*a_o_f[1]+(cv_929*a_o_f[1]*o_10);
		a_o_g2[0] = getCutNumber(a_o_g2[0],9);
		a_o_g2[1] = getCutNumber(a_o_g2[1],9);
		fm.cd[i].value = "a_o_g2[0]";			fm.nm[i].value = "매각시점 중고차가 g2형";					fm.value[i].value = a_o_g2[0];				i++;		
		fm.cd[i].value = "a_o_g2[1]";			fm.nm[i].value = "매각시점 중고차가 g2형";					fm.value[i].value = a_o_g2[1];				i++;		
		
		var o_11 = <%=ej_bean.getJg_11()%>;
		fm.cd[i].value = "o_11";				fm.nm[i].value = "중고차가결정변수";						fm.value[i].value = o_11;					i++;		

		a_o_g = new Array();
		if(o_11 == 1) 	a_o_g[0] = a_o_g1[0];
		else						a_o_g[0] = a_o_g2[0];
		if(o_11 == 1) 	a_o_g[1] = a_o_g1[1];
		else						a_o_g[1] = a_o_g2[1];
		a_o_g[0] = getCutNumber(a_o_g[0],9);
		a_o_g[1] = getCutNumber(a_o_g[1],9);
		fm.cd[i].value = "a_o_g[0]";			fm.nm[i].value = "대여종료 시점 중고차가";					fm.value[i].value = a_o_g[0];				i++;				
		fm.cd[i].value = "a_o_g[1]";			fm.nm[i].value = "대여종료 시점 중고차가";					fm.value[i].value = a_o_g[1];				i++;				
		
		a_o_h = new Array();	
		a_o_h[0] = a_o_g[0]/(o_1/10000);		 //20160822
		a_o_h[1] = a_o_g[1]/(o_1/10000);		 //20160822
		a_o_h[0] = getCutNumber(a_o_h[0],9);
		a_o_h[1] = getCutNumber(a_o_h[1],9);
		fm.cd[i].value = "a_o_h[0]";			fm.nm[i].value = "차량가격 적용 잔가율";					fm.value[i].value = a_o_h[0];				i++;		
		fm.cd[i].value = "a_o_h[1]";			fm.nm[i].value = "차량가격 적용 잔가율";					fm.value[i].value = a_o_h[1];				i++;		
		
		var g_3 = <%=em_bean.getJg_c_3()%>/100;
		fm.cd[i].value = "g_3";					fm.nm[i].value = "신차등록월에 따른 1년당 잔가율 변동값";	fm.value[i].value = g_3;					i++;		

		var cv_936 = getRentTime('l', '<%=rent_dt.substring(0,4)%>0101', '<%=rent_dt%>')+1;
		fm.cd[i].value = "cv_936";				fm.nm[i].value = "신차등록일-전년도말일";					fm.value[i].value = cv_936;					i++;		
		
		var cv_937 = 1+(g_3*(cv_936/365-0.5));			
		cv_937 = getCutNumber(cv_937,9);	
		fm.cd[i].value = "cv_937";				fm.nm[i].value = "신등차등록월에 따른 잔가율 변동값";		fm.value[i].value = cv_937;					i++;		

		a_o_i = new Array();	
		a_o_i[0] = a_o_h[0]*cv_937;
		a_o_i[1] = a_o_h[1]*cv_937;
		a_o_i[0] = getCutNumber(a_o_i[0],9);
		a_o_i[1] = getCutNumber(a_o_i[1],9);		
		fm.cd[i].value = "a_o_i[0]";			fm.nm[i].value = "신차등록월 반영 잔가율";					fm.value[i].value = a_o_i[0];				i++;		
		fm.cd[i].value = "a_o_i[1]";			fm.nm[i].value = "신차등록월 반영 잔가율";					fm.value[i].value = a_o_i[1];				i++;		

		var g_4 = <%=em_bean.getJg_c_4()%>/100;
		fm.cd[i].value = "g_4";					fm.nm[i].value = "LPG겸용차 잔가율 기초 조정값";			fm.value[i].value = g_4;					i++;		

		var g_5 = <%=em_bean.getJg_c_5()%>/100;
		fm.cd[i].value = "g_5";					fm.nm[i].value = "LPG겸용차 잔가율 1년당 조정값";			fm.value[i].value = g_5;					i++;		

		a_o_j = new Array();	
		a_o_j[0] = g_4+(a_a_b[0]/12)*g_5;
		a_o_j[1] = g_4+(a_a_b[1]/12)*g_5;		
		if(<%=bean.getLpg_yn()%>==0){
			a_o_j[0] = 0;
			a_o_j[1] = 0;
		}
		fm.cd[i].value = "a_o_j[0]";			fm.nm[i].value = "LPG키트 장착시 잔가 조정값";				fm.value[i].value = a_o_j[0];				i++;		
		fm.cd[i].value = "a_o_j[1]";			fm.nm[i].value = "LPG키트 장착시 잔가 조정값";				fm.value[i].value = a_o_j[1];				i++;				

		var g_6 = <%=em_bean.getJg_c_6()%>/100;
		if(<%=bean.getA_b()%> > 36){
			//테슬라
			if(<%=rent_dt%> >= 20190801 && <%=rent_dt%> < 20210216){
<%-- 				if('<%=cm_bean.getJg_code()%>'=='4854' || '<%=cm_bean.getJg_code()%>'=='5866' || '<%=cm_bean.getJg_code()%>'=='3871' || '<%=cm_bean.getJg_code()%>' == '3313111' || '<%=cm_bean.getJg_code()%>' == '3313112' || '<%=cm_bean.getJg_code()%>' == '3313113' || '<%=cm_bean.getJg_code()%>' == '3313114' || '<%=cm_bean.getJg_code()%>' == '4314111' || '<%=cm_bean.getJg_code()%>' == '6316111'){ --%>
				if('<%=cm_bean.getCar_comp_id()%>'=='0056'){
					g_6 = (<%=em_bean.getJg_c_6()%>-2.9)/100;
				}			
			}
		}
		fm.cd[i].value = "g_6";					fm.nm[i].value = "36개월 초과견적시 잔가율 1년당 조정값";	fm.value[i].value = g_6;					i++;		

		a_o_k = new Array();	
		a_o_k[0] = (a_a_b[0]-36)/12*g_6;
		a_o_k[1] = (a_a_b[1]-36)/12*g_6;
		if(a_a_b[0]<=36) a_o_k[0] = 0;
		if(a_a_b[1]<=36) a_o_k[1] = 0;
		fm.cd[i].value = "a_o_k[0]";			fm.nm[i].value = "36개월 초과견적시 잔가 조정값";			fm.value[i].value = a_o_k[0];				i++;		
		fm.cd[i].value = "a_o_k[1]";			fm.nm[i].value = "36개월 초과견적시 잔가 조정값";			fm.value[i].value = a_o_k[1];				i++;				
		
		var o_12 = <%=ej_bean.getJg_12()%>;
		fm.cd[i].value = "o_12";				fm.nm[i].value = "리스크 조절 변수 (36개월 기준)";			fm.value[i].value = o_12;					i++;		

		var o_13 = 0;
		<%if(!ej_bean.getJg_13().equals("")){%>
		o_13 = <%=ej_bean.getJg_13()%>;		
		<%}%>
		o_13 = 1; //신차여부에 상관없이
		fm.cd[i].value = "o_13";				fm.nm[i].value = "신차판매여부";							fm.value[i].value = o_13;					i++;		
		

		var a_m_1 = <%=em_bean.getA_m_1()%>/100;
		fm.cd[i].value = "a_m_1";				fm.nm[i].value = "현재 중고차 경기지수";					fm.value[i].value = a_m_1;					i++;						
			
		var a_m_2 = <%=em_bean.getA_m_2()%>/100;
		fm.cd[i].value = "a_m_2";				fm.nm[i].value = "36개월후 현재 중고차 경기지수 반영율";	fm.value[i].value = a_m_2;					i++;
		
		var a_m_3 = 1-(1-a_m_1)*a_m_2;
		fm.cd[i].value = "a_m_3";				fm.nm[i].value = "36개월후 중고차 경기지수";				fm.value[i].value = a_m_3;					i++;
		
		a_o_m = new Array();	
		a_o_m[0] = replaceFloatRound((a_o_i[0]*(1+o_12/36*a_a_b[0])+a_o_j[0]+a_o_k[0])*a_m_3)/o_13;
		a_o_m[1] = replaceFloatRound((a_o_i[1]*(1+o_12/36*a_a_b[1])+a_o_j[1]+a_o_k[1])*a_m_3)/o_13;
		
		fm.cd[i].value = "a_o_m[0]";			fm.nm[i].value = "신차견적시 최대잔가율";					fm.value[i].value = a_o_m[0];				i++;		
		fm.cd[i].value = "a_o_m[1]";			fm.nm[i].value = "신차견적시 최대잔가율";					fm.value[i].value = a_o_m[1];				i++;		

		//20180601 수출효과, 주행거리상쇄효과
		var ex_e_e = 0;
		var ex_e_h = 0;
		
		if(<%=rent_dt%> >= 20180601 && '<%=ej_bean.getJg_g_18()%>'=='1'){
			//신차 수출가능 견적 대여 만료일
			var ex_e_a = <%=rs_db.addDay(String.valueOf(AddUtil.parseInt(rent_dt.substring(0,4))+ej_bean.getJg_g_19())+"0101", ej_bean.getJg_g_22())%>;
			//신차 견적 대여만료일
			var ex_e_b = <%=rs_db.addDay(rs_db.addMonth(rent_dt, AddUtil.parseInt(bean.getA_b())),ej_bean.getJg_g_23())%>;
			//종료시점 수출효과 대상 차량 여부
			var ex_e_c = 9;
			if(ex_e_a>ex_e_b){
				ex_e_c = 1;
			}

			fm.cd[i].value = "ex_e_a";			fm.nm[i].value = "신차 수출가능 견적 대여 만료일";					fm.value[i].value = ex_e_a;				i++;		
			fm.cd[i].value = "ex_e_b";			fm.nm[i].value = "신차 견적 대여만료일";								fm.value[i].value = ex_e_b;				i++;		
			fm.cd[i].value = "ex_e_c";			fm.nm[i].value = "종료시점 수출효과 대상 차량 여부";				fm.value[i].value = ex_e_c;				i++;		
			
			if(ex_e_c==1){
				var ex_e_c2 = <%=bean.getA_b()%>;	
				if(<%=bean.getA_b()%>>=<%=ej_bean.getJg_g_19()%>*12){
					ex_e_c2 = <%=ej_bean.getJg_g_19()%>*12;	
				}
				//대여 만료시점 수출효과 적용율
				var ex_e_d = 1-((<%=ej_bean.getJg_g_19()%>*12)-ex_e_c2)/(<%=ej_bean.getJg_g_20()%>*12);
				//대여 만료시점 수출효과(수출가능차량)
				var ex_e_e = <%=ej_bean.getJg_g_24()%>*ex_e_d;
				//약정운행거리 조정에 따른 신차 주행거리 상쇄효과 반영율
				var ex_e_h = <%=ej_bean.getJg_g_25()%>*ex_e_d;
				fm.cd[i].value = "ex_e_d";			fm.nm[i].value = "대여 만료시점 수출효과 적용율";					fm.value[i].value = ex_e_d;				i++;		
			}
		}

		fm.cd[i].value = "ex_e_e";			fm.nm[i].value = "대여 만료시점 수출효과(수출가능차량)";				fm.value[i].value = ex_e_e;				i++;		
		fm.cd[i].value = "ex_e_h";			fm.nm[i].value = "약정운행거리 조정에 따른 신차 주행거리 상쇄효과 반영율";	fm.value[i].value = ex_e_h;				i++;		

		//20151013 색상 및 사양 잔가 반영
		if(<%=rent_dt%> >= 20151013){
					
			var ax14 = new Array();	
			var ax14_s = new Array();	
			
			ax14[0] = 0;
			ax14[1] = 0;
			ax14_s[0] = 0;
			ax14_s[1] = 0;
						
			<%for(int j=0 ; j < s ; j++){
				//차종변수 색상사양 잔가변수
				EstiJgVarBean ejo_bean = e_db.getEstiJgOptVarCase(ej_bean.getSh_code(), ej_bean.getSeq(), app_value[j]);
			%>
								
				if(a_a_b[0] < <%=ejo_bean.getJg_opt_6()%>){
					ax14_s[0] = <%=ejo_bean.getJg_opt_7()%>;
				}else{
					ax14_s[0] = <%=ejo_bean.getJg_opt_7()%>*(1-(a_a_b[0]-<%=ejo_bean.getJg_opt_6()%>)*0.0125);
				}				
				
				if(a_a_b[1] < <%=ejo_bean.getJg_opt_6()%>){
					ax14_s[1] = <%=ejo_bean.getJg_opt_7()%>;
				}else{
					ax14_s[1] = <%=ejo_bean.getJg_opt_7()%>*(1-(a_a_b[1]-<%=ejo_bean.getJg_opt_6()%>)*0.0125);
				}				

				fm.cd[i].value = "ax14_s[0]";	fm.nm[i].value = "색상 및 사양 잔가반영 적용값";				fm.value[i].value = ax14_s[0];				i++;			
				fm.cd[i].value = "ax14_s[1]";	fm.nm[i].value = "색상 및 사양 잔가반영 적용값";				fm.value[i].value = ax14_s[1];				i++;			
								
				ax14[0] = ax14[0] + ax14_s[0];
				ax14[1] = ax14[1] + ax14_s[1];
			
			<%}%>
			
			fm.cd[i].value = "ax14[0]";		fm.nm[i].value = "색상 및 사양 잔가반영 적용합계";				fm.value[i].value = ax14[0];				i++;			
			fm.cd[i].value = "ax14[1]";		fm.nm[i].value = "색상 및 사양 잔가반영 적용합계";				fm.value[i].value = ax14[1];				i++;			
			
			a_o_m[0] = replaceFloatRound((a_o_i[0]*(1+o_12/36*a_a_b[0])+a_o_j[0]+a_o_k[0])*a_m_3+(ax14[0]+ex_e_e)/(o_1/10000))/o_13; //20160822
			a_o_m[1] = replaceFloatRound((a_o_i[1]*(1+o_12/36*a_a_b[1])+a_o_j[1]+a_o_k[1])*a_m_3+(ax14[1]+ex_e_e)/(o_1/10000))/o_13; //20160822
																	
		}
		
		fm.cd[i].value = "a_o_m[0]";			fm.nm[i].value = "신차견적시 최대잔가율";					fm.value[i].value = a_o_m[0];				i++;		
		fm.cd[i].value = "a_o_m[1]";			fm.nm[i].value = "신차견적시 최대잔가율";					fm.value[i].value = a_o_m[1];				i++;		


		//20190502 면세가표기차량   	
		if('<%=cm_bean.getDuty_free_opt()%>' =='1'){ 
			a_o_m[0] = replaceFloatRound(o_1/<%=o_1%>*a_o_m[0]/100);
			a_o_m[1] = replaceFloatRound(o_1/<%=o_1%>*a_o_m[1]/100);
			fm.cd[i].value = "a_o_m[0]";		fm.nm[i].value = "면세가표기차량 신차견적시 최대잔가율(면세가표기차량)";		fm.value[i].value = a_o_m[0];				i++;		
			fm.cd[i].value = "a_o_m[1]";		fm.nm[i].value = "면세가표기차량 신차견적시 최대잔가율(면세가표기차량)";		fm.value[i].value = a_o_m[1];				i++;			
		}
		
		//20200301 0.98 적용
		//20200701 개소세 감면종료로 미적용
		//if('<%=cm_bean.getDuty_free_opt()%>' =='1'){
		//	a_o_m[0] = replaceFloatRound(a_o_m[0]*0.98/100);
		//	a_o_m[1] = replaceFloatRound(a_o_m[1]*0.98/100);		
		//	fm.cd[i].value = "a_o_m[0]";		fm.nm[i].value = "면세가표기차량 신차견적시 최대잔가율(면세가표기차량)";		fm.value[i].value = a_o_m[0];				i++;		
		//	fm.cd[i].value = "a_o_m[1]";		fm.nm[i].value = "면세가표기차량 신차견적시 최대잔가율(면세가표기차량)";		fm.value[i].value = a_o_m[1];				i++;						
		//}else{
			//개별소비세있고 친환경차개소세감면없으면 102%  20200301
		//	if(o_3 >0){
		//		<%	if(ej_bean.getJg_g_7().equals("1")||ej_bean.getJg_g_7().equals("2")||ej_bean.getJg_g_7().equals("3")||ej_bean.getJg_g_7().equals("4")){//친환경차%>
		//			<%	if(ej_bean.getJg_g_7().equals("1")||ej_bean.getJg_g_7().equals("2")){//하이브리드%>
		//				a_o_m[0] = replaceFloatRound(a_o_m[0]*1.01/100);
		//				a_o_m[1] = replaceFloatRound(a_o_m[1]*1.01/100);
		//			<%	}%>
		//		<%}else{%>	
		//			<%if(ej_bean.getJg_w().equals("1")){//수입차%>
		//				a_o_m[0] = replaceFloatRound(a_o_m[0]*1.01/100);
		//				a_o_m[1] = replaceFloatRound(a_o_m[1]*1.01/100);
		//			<%}else{%>
		//				a_o_m[0] = replaceFloatRound(a_o_m[0]*1.02/100);
		//				a_o_m[1] = replaceFloatRound(a_o_m[1]*1.02/100);
		//			<%}%>
		//		<%	}%>		
		//		fm.cd[i].value = "a_o_m[0]";		fm.nm[i].value = "개별소비세있고 친환경차개소세감면없으면 102% 신차견적시 최대잔가율";		fm.value[i].value = a_o_m[0];				i++;		
		//		fm.cd[i].value = "a_o_m[1]";		fm.nm[i].value = "개별소비세있고 친환경차개소세감면없으면 102% 신차견적시 최대잔가율";		fm.value[i].value = a_o_m[1];				i++;			
		//	}
		//}
		
		//20150217 48개월이상인일 경우 일부 낮춰줌
		if(<%=rent_dt%> >= 20150217){
			if(a_a_b[0]>48){
				//20180830 신차 48개월이상 견적시 1개월마다 0.1%씩 잔가를 빼주던 것을 LPG전용차는 안빼주기
				//if(<%=rent_dt%> >= 20180830 && '<%=ej_bean.getJg_2()%>' == '1' ){ //20190418
					
				//}else{
					a_o_m[0] = a_o_m[0] - replaceFloatRound2((a_a_b[0]-48)*0.1/100);
		    		a_o_m[1] = a_o_m[1] - replaceFloatRound2((a_a_b[1]-48)*0.1/100);
		    	//}
					fm.cd[i].value = "a_o_m[0]";			fm.nm[i].value = "48개월이상 신차견적시 최대잔가율";					fm.value[i].value = a_o_m[0];				i++;		
					fm.cd[i].value = "a_o_m[1]";			fm.nm[i].value = "48개월이상 신차견적시 최대잔가율";					fm.value[i].value = a_o_m[1];				i++;				

			}
		}

		
		//표준약정운행거리
		var b_agree_dist = 30000;
		
		if(<%=rent_dt%> >= 20220415){
			b_agree_dist = 23000;
		}
		
		//디젤 +5000
		<%if(ej_bean.getJg_b().equals("1")){%>
		b_agree_dist = b_agree_dist + 5000;
		<%}%>		
		
		//LPG엔진 +10000 -> 20190418 +5000
		<%if(ej_bean.getJg_b().equals("2")){%>
		b_agree_dist = b_agree_dist + 5000;
		<%}%>
		
		fm.cd[i].value = "b_agree_dist";		fm.nm[i].value = "표준약정운행거리";						fm.value[i].value = b_agree_dist;			i++;		
		
		//적용약정운행거리
		var agree_dist = <%=agree_dist%>;				
		fm.cd[i].value = "agree_dist";			fm.nm[i].value = "적용약정운행거리";						fm.value[i].value = agree_dist;				i++;	
			
		//실제 계산 적용하는 적용약정운행거리 - 테슬라(2만 고정) 때문에 추가함
		var r_agree_dist = agree_dist;
		
		
		//조정최대잔가율
		var add_o_13 = (r_agree_dist-b_agree_dist)*a_a_b[0]/12/10000*<%=ej_bean.getJg_15()%>*a_o_m[0]/100*0.5;
		if(r_agree_dist>b_agree_dist+10000){
			add_o_13 = add_o_13 + ( (r_agree_dist-(b_agree_dist+10000))*a_a_b[0]/12/10000*<%=ej_bean.getJg_15()%>*a_o_m[0]/100 );
		}
		if(<%=rent_dt%> >= 20170529){
			add_o_13 = (r_agree_dist-b_agree_dist)*a_a_b[0]/12/10000*<%=ej_bean.getJg_14()%>*a_o_m[0]/100*<%=ej_bean.getJg_g_13()%>;
			if(r_agree_dist>b_agree_dist+10000){
				add_o_13 = add_o_13 + ( (r_agree_dist-(b_agree_dist+10000))*a_a_b[0]/12/10000*<%=ej_bean.getJg_14()%>*(1-<%=ej_bean.getJg_g_13()%>)*2*a_o_m[0]/100 );
			}
		}
		if(<%=rent_dt%> >= 20220415){
			add_o_13 = (r_agree_dist-b_agree_dist)*a_a_b[0]/12/10000*<%=ej_bean.getJg_14()%>*a_o_m[0]/100;
			if(r_agree_dist<b_agree_dist){
				add_o_13 = add_o_13 * <%=ej_bean.getJg_g_13()%>;
			}else{
				add_o_13 = add_o_13 * (2-<%=ej_bean.getJg_g_13()%>) ;
			}
		}
		add_o_13 = replaceFloatRound(add_o_13*(1+ex_e_h));
		
		//--환급대여료 미적용시 잔가 상승분
		if(<%=rent_dt%> >= 20220415 && '<%=rtn_run_amt_yn%>' == '1'){
			if(a_a_b[0]<24){
				add_o_13 = add_o_13+0.8;
			}else{
				add_o_13 = add_o_13+1.5;
			}
		}
		
		var b_o_13 		= a_o_m[0];		
		var o_13   		= replaceFloatRound(b_o_13+add_o_13)/100;
		var ro_13  		= o_13;
		var ro_13_amt = Math.round(o_1 * (o_13/100));
		
		if('<%=cm_bean.getDuty_free_opt()%>' =='1'){ //20190502 면세가표기차량
			ro_13_amt = Math.round(<%=bean.getO_1()%> * (o_13/100));
		}
		
		//천원단위 반올림
		ro_13_amt = parseInt(ro_13_amt/1000)*1000;
		
										
		fm.cd[i].value = "add_o_13";				fm.nm[i].value = "조정최대잔가율 증감분";				fm.value[i].value = add_o_13;				i++;		
		fm.cd[i].value = "a_o_m[0]+add_o_13";		fm.nm[i].value = "조정최대잔가율";					fm.value[i].value = a_o_m[0]+add_o_13;		i++;		
		
		fm.cd[i].value = "ecar_pur_sub_amt";		fm.nm[i].value = "친환경차 정부/지자체 구매보조금";		fm.value[i].value = ecar_pur_sub_amt;		i++;		
		
		parent.document.form1.ecar_pur_sub_amt.value	= ecar_pur_sub_amt; 
		parent.document.form1.tax_dc_amt.value			= parseDecimal(ch_327);
		//20200301
		if(bk_177>0 || bk_216>0){
			parent.document.form1.tax_dc_amt.value		= parseDecimal(ch_327+bk_177-bk_216);
		}		
		parent.document.form1.b_agree_dist.value 		= parseDecimal(b_agree_dist);
		parent.document.form1.agree_dist.value 			= parseDecimal(agree_dist);
		parent.document.form1.b_o_13.value 				= b_o_13;
		parent.document.form1.o_13.value 				= o_13;
		parent.document.form1.ro_13.value 				= o_13;
		parent.document.form1.ro_13_amt.value 			= parseDecimal(ro_13_amt);	
		
		if(ch_327 >0 || bk_177>0 || bk_216>0 ){
			parent.document.form1.o_1.value 			= parseDecimal(toInt(parseDigit(parent.document.form1.car_amt.value)) + toInt(parseDigit(parent.document.form1.opt_amt.value)) + toInt(parseDigit(parent.document.form1.col_amt.value)) - toInt(parseDigit(parent.document.form1.dc_amt.value)) - toInt(parseDigit(parent.document.form1.tax_dc_amt.value)));
			
			if (toInt(<%=cm_bean.getCar_comp_id()%>) < 5) {
				parent.document.form1.rg_8.value = 20;
				if(<%=ej_bean.getJg_b()%> > 4){
					parent.document.form1.rg_8.value = 10;
				}
			} else {
				parent.document.form1.rg_8.value = 25;
				if(<%=ej_bean.getJg_b()%> > 4){
					parent.document.form1.rg_8.value = 15;
				}
			}
						
			parent.document.form1.rg_8_amt.value 	= parseDecimal( getCutRoundNumber( Math.round(o_1 * (toInt(parent.document.form1.rg_8.value) / 100)) ,-3) );					
		}

	}
//-->
</script>
</head>
<body>
<form action="" name="form1" method="POST" >
<table border=0 cellspacing=0 cellpadding=0 width=100%>
	<tr>
        <td><img src=/acar/images/center/icon_arrow.gif align=absmiddle> <span class=style2>계산과정</span></td>
    </tr>
    <tr>
        <td class=line2></td>
    </tr>
    <tr>
        <td class=line>
            <table border="0" cellspacing="1" width=100%>
                <tr>
                    <td width="8%" class=title>연번</td>
                    <td width="25%" class=title>기호</td>
                    <td width="37%" class=title>항목</td>
                    <td width="30%" class=title>값</td>
                </tr>
        		  <%for(int i=0; i<150; i++){%>
                <tr>
        		  	<td align="center"><%=i%></td>
                    <td>&nbsp;<input type="text" name="cd" value="" size="15" class=whitetext></td>
                    <td>&nbsp;<input type="text" name="nm" value="" size="45" class=whitetext></td>
                    <td>&nbsp;<input type="text" name="value" value="" size="40" class=whitetext></td>          
                </tr>
        	    <%}%>
            </table>
        </td>
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
