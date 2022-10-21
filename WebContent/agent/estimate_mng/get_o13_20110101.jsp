<%@ page language="java" contentType="text/html; charset=euc-kr" %>
<%@ page import="java.util.*, acar.util.*, acar.estimate_mng.*, acar.car_mst.*" %>
<jsp:useBean id="bean" class="acar.estimate_mng.EstimateBean" scope="page"/>
<jsp:useBean id="cm_bean" class="acar.car_mst.CarMstBean" scope="page"/>
<%@ include file="/agent/cookies.jsp" %>

<%
	AddCarMstDatabase 	a_cmb 	= AddCarMstDatabase.getInstance();
	EstiDatabase 		e_db 	= EstiDatabase.getInstance();
	
	String car_id 		= request.getParameter("car_id")	==null?"":request.getParameter("car_id");
	String car_seq 		= request.getParameter("car_seq")	==null?"":request.getParameter("car_seq");
	int car_amt 		= request.getParameter("car_amt")	==null? 0:Util.parseDigit(request.getParameter("car_amt"));
	int opt_amt 		= request.getParameter("opt_amt")	==null? 0:Util.parseDigit(request.getParameter("opt_amt"));
	int col_amt 		= request.getParameter("col_amt")	==null? 0:Util.parseDigit(request.getParameter("col_amt"));
	int dc_amt 		= request.getParameter("dc_amt")	==null? 0:Util.parseDigit(request.getParameter("dc_amt"));
	int o_1 		= request.getParameter("o_1")		==null? 0:Util.parseDigit(request.getParameter("o_1"));
	String a_a 		= request.getParameter("a_a")==null?"":request.getParameter("a_a");	
	String a_b 		= request.getParameter("a_b")==null?"":request.getParameter("a_b");
	String print_type 	= request.getParameter("print_type")==null?"":request.getParameter("print_type");
	
	String rent_dt = AddUtil.getDate(4);
	String rent_st = "0";
	
	String jg_b_dt = e_db.getVar_b_dt("jg", rent_dt);
	String em_a_j  = e_db.getVar_b_dt("em", rent_dt);

	//CAR_NM : 차명정보
	cm_bean = a_cmb.getCarNmCase(car_id, car_seq);
	
	//중고차잔가변수
	EstiJgVarBean ej_bean = e_db.getEstiJgVarCase(cm_bean.getJg_code(), jg_b_dt);
	
	//공통변수
	EstiCommVarBean em_bean = e_db.getEstiCommVarCase("1", "", em_a_j);
	if(a_a.equals("21") || a_a.equals("22")){
		em_bean = e_db.getEstiCommVarCase("2", "", em_a_j);
	}
	
	
	String esti_type = request.getParameter("esti_type")==null?"":request.getParameter("esti_type");
	String idx   	 = request.getParameter("idx")==null?"":request.getParameter("idx");
%>

<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN">
<html>
<head>
<title>FMS</title>
<meta http-equiv="Content-Type" content="text/html; charset=euc-kr">
<link rel="stylesheet" type="text/css" href="../../include/table_t.css">
<script language='JavaScript' src='/include/estimate.js'></script>
<script language="JavaScript">
<!--
	//소숫점절삭
	function getCutNumber(num, place){
		var returnNum;
		var st="1";
		return Math.floor( num * Math.pow(10,parseInt(place,10)) ) / Math.pow(10,parseInt(place,10));
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
		fm.cd[i].value = "rent_dt";			fm.nm[i].value = "견적기준일";									fm.value[i].value = rent_dt;				i++;		
		
		var jg_code = <%=ej_bean.getSh_code()%>;
		fm.cd[i].value = "jg_code";			fm.nm[i].value = "차종코드";									fm.value[i].value = jg_code;				i++;		
		
		var car_amt = <%=car_amt%>;
		fm.cd[i].value = "car_amt";			fm.nm[i].value = "차량가격";									fm.value[i].value = car_amt;				i++;		
		
		var opt_amt = <%=opt_amt%>;
		fm.cd[i].value = "opt_amt";			fm.nm[i].value = "선택사양가격";								fm.value[i].value = opt_amt;				i++;		
		
		var col_amt = <%=col_amt%>;
		fm.cd[i].value = "col_amt";			fm.nm[i].value = "색상사양가격";								fm.value[i].value = col_amt;				i++;		
		
		var dc_amt = <%=dc_amt%>;
		fm.cd[i].value = "dc_amt";			fm.nm[i].value = "DC가격";										fm.value[i].value = dc_amt;					i++;		
		
		a_a_b = new Array();
		a_a_b[0] = <%=a_b%>;
		a_a_b[1] = Math.round(<%=a_b%>/36*cls_mon);
		fm.cd[i].value = "a_a_b[0]";		fm.nm[i].value = "견적개월수";									fm.value[i].value = a_a_b[0];				i++;		
		fm.cd[i].value = "a_a_b[1]";		fm.nm[i].value = "견적개월수-해지율";							fm.value[i].value = a_a_b[1];				i++;		
		
		var rent_st = <%=rent_st%>;
		fm.cd[i].value = "rent_st";			fm.nm[i].value = "대여구분"	;									fm.value[i].value = rent_st;				i++;		
		

		
		fm.cd[i].value = "";				fm.nm[i].value = "---------------------------"; fm.value[i].value = '재리스차량 현재잔가율 산출과정 -------------';			i++;				

		var o_a = <%=ej_bean.getJg_1()%>;
		fm.cd[i].value = "a_a";				fm.nm[i].value = "현시점 차령 24개월 잔가율";					fm.value[i].value = o_a;					i++;		

		var g_1 = <%=em_bean.getJg_c_1()%>/100;
		g_1 = g_1*(1-<%=ej_bean.getJg_g_2()%>*0.35);
		fm.cd[i].value = "g_1";				fm.nm[i].value = "0개월 기준 잔가";								fm.value[i].value = g_1;					i++;		

		var o_2 = <%=ej_bean.getJg_2()%>;
		fm.cd[i].value = "o_2";				fm.nm[i].value = "일반승용 LPG 여부";							fm.value[i].value = o_2;					i++;		

		var o_3 = <%=ej_bean.getJg_3()%>;
		fm.cd[i].value = "o_3";				fm.nm[i].value = "기본 특소세율";								fm.value[i].value = o_3;					i++;		

		var o_b = g_1*(1+o_2*o_3)+(o_a-0.6*(1+o_2*o_3))*0.5;
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
		if(o_5 == -0.12) o_5 = -0.09;
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
		fm.cd[i].value = "cv_924";				fm.nm[i].value = "초과차량가격";							fm.value[i].value = cv_924;					i++;		
		
		var o_8 = 1;
		if(cv_924>0) o_8 = <%=ej_bean.getJg_8()%>;		
		fm.cd[i].value = "o_8";					fm.nm[i].value = "초과차량가격 잔가율 승수";				fm.value[i].value = o_8;					i++;		

		var cv_926 = (opt_amt+col_amt)/10000;
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
				
		var cv_929 = (<%=o_1%>/10000)-o_7;
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
		else			a_o_g[0] = a_o_g2[0];
		if(o_11 == 1) 	a_o_g[1] = a_o_g1[1];
		else			a_o_g[1] = a_o_g2[1];
		a_o_g[0] = getCutNumber(a_o_g[0],9);
		a_o_g[1] = getCutNumber(a_o_g[1],9);
		fm.cd[i].value = "a_o_g[0]";			fm.nm[i].value = "대여종료 시점 중고차가";					fm.value[i].value = a_o_g[0];				i++;				
		fm.cd[i].value = "a_o_g[1]";			fm.nm[i].value = "대여종료 시점 중고차가";					fm.value[i].value = a_o_g[1];				i++;				
		
		a_o_h = new Array();	
		a_o_h[0] = a_o_g[0]/(<%=o_1%>/10000);	
		a_o_h[1] = a_o_g[1]/(<%=o_1%>/10000);	
		a_o_h[0] = getCutNumber(a_o_h[0],9);
		a_o_h[1] = getCutNumber(a_o_h[1],9);
		fm.cd[i].value = "a_o_h[0]";			fm.nm[i].value = "차량가격 적용 잔가율";					fm.value[i].value = a_o_h[0];				i++;		
		fm.cd[i].value = "a_o_h[1]";			fm.nm[i].value = "차량가격 적용 잔가율";					fm.value[i].value = a_o_h[1];				i++;		
		
		var g_3 = <%=em_bean.getJg_c_3()%>/100;
		fm.cd[i].value = "g_3";					fm.nm[i].value = "신차등록월에 따른 1년당 잔가율 변동값";	fm.value[i].value = g_3;					i++;		

		var cv_936 = getRentTime('l', '<%=rent_dt.substring(0,4)%>0101', '<%=rent_dt%>')+1;
		fm.cd[i].value = "cv_936";				fm.nm[i].value = "신차등록일-전년도말일";					fm.value[i].value = cv_936;					i++;		
		
		var cv_937 = g_3*(cv_936/365-0.5);
		cv_937 = getCutNumber(cv_937,9);	
		fm.cd[i].value = "cv_937";				fm.nm[i].value = "신등차등록월에 따른 잔가율 변동값";		fm.value[i].value = cv_937;					i++;		

		a_o_i = new Array();	
		a_o_i[0] = a_o_h[0]+cv_937;
		a_o_i[1] = a_o_h[1]+cv_937;
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
		if(0==0){ //LPG키트장착없음
			a_o_j[0] = 0;
			a_o_j[1] = 0;
		}
		fm.cd[i].value = "a_o_j[0]";			fm.nm[i].value = "LPG키트 장착시 잔가 조정값";				fm.value[i].value = a_o_j[0];				i++;		
		fm.cd[i].value = "a_o_j[1]";			fm.nm[i].value = "LPG키트 장착시 잔가 조정값";				fm.value[i].value = a_o_j[1];				i++;				

		var g_6 = <%=em_bean.getJg_c_6()%>/100;
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
		
		
		parent.document.form1.o_13[<%=idx%>].value 		= a_o_m[0];
		parent.document.form1.ro_13[<%=idx%>].value 		= a_o_m[0];
		parent.document.form1.ro_13_amt[<%=idx%>].value 	= parseDecimal(Math.round(<%=o_1%> * (a_o_m[0] / 100)));	
		
		<%if(print_type.equals("2") || print_type.equals("3") || print_type.equals("4")){%>
			parent.document.form1.o_13[1].value 		= parent.document.form1.o_13[0].value;
			parent.document.form1.ro_13[1].value 		= parent.document.form1.ro_13[0].value;
			parent.document.form1.ro_13_amt[1].value 	= parent.document.form1.ro_13_amt[0].value;							
		<%}%>
		<%if(print_type.equals("4")){%>
			parent.document.form1.o_13[2].value 		= parent.document.form1.o_13[0].value;
			parent.document.form1.ro_13[2].value 		= parent.document.form1.ro_13[0].value;
			parent.document.form1.ro_13_amt[2].value 	= parent.document.form1.ro_13_amt[0].value;							
			parent.document.form1.o_13[3].value 		= parent.document.form1.o_13[0].value;
			parent.document.form1.ro_13[3].value 		= parent.document.form1.ro_13[0].value;
			parent.document.form1.ro_13_amt[3].value 	= parent.document.form1.ro_13_amt[0].value;							
		<%}%>						
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
