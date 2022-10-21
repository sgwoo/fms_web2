<%@ page language="java" contentType="text/html; charset=euc-kr" %>
<%@ page import="java.util.*, acar.util.*, acar.common.*, acar.secondhand.*, acar.estimate_mng.*, acar.cont.*, acar.user_mng.*" %>
<jsp:useBean id="shDb" class="acar.secondhand.SecondhandDatabase" scope="page"/>
<jsp:useBean id="rs_db" scope="page" class="acar.res_search.ResSearchDatabase"/>
<jsp:useBean id="a_db" scope="page" class="acar.cont.AddContDatabase"/>
<%@ include file="/acar/cookies.jsp" %>

<%
	String add_rent_st 	= request.getParameter("add_rent_st")	==null?"":request.getParameter("add_rent_st");
	String car_mng_id 	= request.getParameter("car_mng_id")	==null?"":request.getParameter("car_mng_id");
	String rent_dt 		= request.getParameter("rent_dt")	==null?"":AddUtil.replace(request.getParameter("rent_dt"),"-","");
	String rent_st 		= request.getParameter("rent_st")	==null?"1":request.getParameter("rent_st");
	String est_st 		= request.getParameter("est_st")	==null?"":request.getParameter("est_st");
	String a_b 		= request.getParameter("a_b")		==null?"1":request.getParameter("a_b");
	int    fee_opt_amt 	= request.getParameter("fee_opt_amt")	==null?0:AddUtil.parseDigit(request.getParameter("fee_opt_amt"));	//연장계약시 매입옵션 있는경우 매입옵션금액 
	int    cust_sh_car_amt 	= request.getParameter("cust_sh_car_amt")==null?0:AddUtil.parseDigit(request.getParameter("cust_sh_car_amt"));	//중고차리스시 구입예정 중고차가격
	int    sh_amt 		= request.getParameter("sh_amt")	==null?0:AddUtil.parseDigit(request.getParameter("sh_amt"));		//중고차가격
	String jg_b_dt 		= request.getParameter("jg_b_dt")	==null?"":request.getParameter("jg_b_dt");
	String a_j 		= request.getParameter("a_j")		==null?"":request.getParameter("a_j");
	String st 		= request.getParameter("st")		==null?"":request.getParameter("st");
	String mode		= request.getParameter("mode")		==null?"":request.getParameter("mode");
	String today_dist	= request.getParameter("today_dist")	==null?"":request.getParameter("today_dist");
	int    cls_n_mon	= request.getParameter("cls_n_mon")	==null?0:AddUtil.parseDigit(request.getParameter("cls_n_mon"));
	String accid_serv_zero	= request.getParameter("accid_serv_zero")==null?"":request.getParameter("accid_serv_zero");
	

	out.println("today_dist ="+today_dist);
	
	if(add_rent_st.equals("t")){
		a_b = "1";
	}
	
	if(a_b.equals("0")){
		a_b = "1";
	}
	
	String rent_mng_id	= request.getParameter("rent_mng_id")==null?"":request.getParameter("rent_mng_id");
	String rent_l_cd	= request.getParameter("rent_l_cd")==null?"":request.getParameter("rent_l_cd");
	
	if(mode.equals("lc_reg")) mode = "lc_rent";
	
	if(rent_dt.equals("")) rent_dt 		= AddUtil.getDate(4);
	
	if(est_st.equals("2")){
		rent_st 	= "2";
	}
	
	CommonDataBase c_db = CommonDataBase.getInstance();
	EstiDatabase e_db = EstiDatabase.getInstance();
	MaMenuDatabase nm_db = MaMenuDatabase.getInstance();
	
	if(nm_db.getWorkAuthUser("전산팀",ck_acar_id) && rent_dt.equals("20190417"))	rent_dt = "20190418";	
	
	
	//차량정보
	Hashtable ht = shDb.getShBase(car_mng_id);


	
	
	//견적변수 기준일자 가져요기
	jg_b_dt = e_db.getVar_b_dt(String.valueOf(ht.get("JG_CODE")), "jg", rent_dt);
	a_j 	= e_db.getVar_b_dt("em", rent_dt);

	//차종변수 기준일자에 따른 공통변수 일련번호 가져오기
	String em_var_seq = e_db.getVar_seq("em", rent_dt);
	
	out.println("jg_b_dt="+jg_b_dt);
	out.println("a_j="+a_j);
	
	
	
	//차량기본데이타 없으면 만들어 줌.
	if(String.valueOf(ht.get("CAR_MNG_ID")).equals("null")){
		//차량정보-여러테이블 조인 조회
		Hashtable ht2 = shDb.getBase(car_mng_id, rent_dt);
		ht2.put("REG_ID", ck_acar_id);
		ht2.put("SECONDHAND_DT", rent_dt);
		//sh_base table insert
		int sh_count = shDb.insertShBase(ht2);
		
		ht = shDb.getShBase(car_mng_id);
	}
	
	//잔가 차량정보
	Hashtable sh_var = shDb.getShBaseVar(car_mng_id);
	
	//중고차잔가변수
	EstiJgVarBean ej_bean = e_db.getEstiJgVarCase(String.valueOf(ht.get("JG_CODE")), jg_b_dt);
	
	//공통변수
	EstiCommVarBean em_bean = e_db.getEstiCommVarCase("1", em_var_seq);
	
	String init_reg_dt 	= String.valueOf(ht.get("INIT_REG_DT"));
	
	if(today_dist.equals("") || today_dist.equals("0")) today_dist 	= String.valueOf(ht.get("TODAY_DIST"));
	String lpg_yn 		= String.valueOf(ht.get("LPG_YN"));
	
	
	if(today_dist.equals("") && rent_dt.equals(String.valueOf(ht.get("SERV_DT"))) && !today_dist.equals(String.valueOf(ht.get("TOT_DIST"))) && !String.valueOf(ht.get("TOT_DIST")).equals("0")){
		today_dist = String.valueOf(ht.get("TOT_DIST"));
	}
	
	
	
	//20110615 표준주행거리 초과 10,000km당 중고차가 조정율 변수를 공통변수에서 차종변수로 변경
	if(AddUtil.parseInt(ej_bean.getReg_dt()) >= 20110615){
		em_bean.setJg_c_81(ej_bean.getJg_14()*100);
		em_bean.setJg_c_82(ej_bean.getJg_14()*100);
	}
	
	
	
	int accid_serv_amt1 = 0;
	int accid_serv_amt2 = 0;
	
		//20150512 재리스/연장 견적은 사고수리비 반영		
		if(AddUtil.parseInt(rent_dt) >= 20150512){		
			//차량정보
			Vector vt = shDb.getAccidServAmts(car_mng_id, rent_dt);
			int vt_size = vt.size();
			for(int j = 0 ; j < vt_size ; j++){
				Hashtable am_ht = (Hashtable)vt.elementAt(j);
				if(j==0) accid_serv_amt1 = String.valueOf(am_ht.get("TOT_AMT"))==null?0 :AddUtil.parseDigit(String.valueOf(am_ht.get("TOT_AMT")));
				if(j==1) accid_serv_amt2 = String.valueOf(am_ht.get("TOT_AMT"))==null?0 :AddUtil.parseDigit(String.valueOf(am_ht.get("TOT_AMT")));					
			}								
		}	
		
	//20151013 색상 사양 조정잔가		
	String jg_opt_st = String.valueOf(ht.get("JG_OPT_ST"));
	String jg_col_st = String.valueOf(ht.get("JG_COL_ST"));
	
	if(jg_opt_st.equals("") && !jg_col_st.equals(""))	jg_opt_st = jg_col_st;
	else if(!jg_opt_st.equals("") && !jg_col_st.equals(""))	jg_opt_st = jg_opt_st+"/"+jg_col_st;
	
	
	int s=0; 
	String app_value[] = new String[7];	
	
	if(jg_opt_st.length() > 0){
		StringTokenizer st2 = new StringTokenizer(jg_opt_st,"/");				
		while(st2.hasMoreTokens()){
			app_value[s] = st2.nextToken();
			s++;
		}		
	}	
	
	//20180904  20180601 수출효과 소급반영
	ContFeeBean fee = new ContFeeBean();
	ContBaseBean base = new ContBaseBean();
	if(!rent_st.equals("") && !rent_mng_id.equals("") && !rent_l_cd.equals("")){
		fee = a_db.getContFeeNew(rent_mng_id, rent_l_cd, rent_st);
		//계약기본정보
		base = a_db.getCont(rent_mng_id, rent_l_cd);
	}	
	
	String duty_free_opt = String.valueOf(ht.get("DUTY_FREE_OPT"));
			
%>

<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN">
<html>
<head>
<title>FMS</title>
<meta http-equiv="Content-Type" content="text/html; charset=euc-kr">
<link rel="stylesheet" type="text/css" href="/include/table.css">
<script language='JavaScript' src='/include/estimate.js'></script>
<script language="JavaScript">
<!--
	//소숫점절삭
	function getCutNumber(num, place){
		var returnNum;
		var st="1";
		return Math.floor( num * Math.pow(10,parseInt(place,10)) ) / Math.pow(10,parseInt(place,10));
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
						
		var init_reg_dt = <%=init_reg_dt%>;
		fm.cd[i].value = "init_reg_dt";		fm.nm[i].value = "신차등록일";									fm.value[i].value = init_reg_dt;			i++;		

		var rent_dt = <%=rent_dt%>;
		fm.cd[i].value = "rent_dt";			fm.nm[i].value = "견적기준일";									fm.value[i].value = rent_dt;				i++;		

		var today_dist = <%=Util.parseDigit(today_dist)%>;
		
		<%if(mode.equals("off_ls")){//경매출품현황에서 %>
		today_dist = today_dist + <%=AddUtil.parseDigit(String.valueOf(ht.get("B_DIST")))%>;
		<%}%>
		fm.cd[i].value = "today_dist";		fm.nm[i].value = "예상주행거리";								fm.value[i].value = today_dist;				i++;		
		
		var jg_code = <%=ej_bean.getSh_code()%>;
		fm.cd[i].value = "jg_code";			fm.nm[i].value = "차종코드";									fm.value[i].value = jg_code;				i++;		
		
		var car_amt = <%=ht.get("CAR_AMT")%>;
		fm.cd[i].value = "car_amt";			fm.nm[i].value = "차량가격";									fm.value[i].value = car_amt;				i++;		
		
						
		var opt_amt = <%=ht.get("OPT_AMT")%>;
		fm.cd[i].value = "opt_amt";			fm.nm[i].value = "선택사양가격";								fm.value[i].value = opt_amt;				i++;		
		
		var col_amt = <%=ht.get("COL_AMT")%>;
		fm.cd[i].value = "col_amt";			fm.nm[i].value = "색상사양가격";								fm.value[i].value = col_amt;				i++;		
		
		//20171016
		var tax_dc_amt = <%=ht.get("TAX_DC_AMT")%>;
		fm.cd[i].value = "tax_dc_amt";			fm.nm[i].value = "개소세감면액";						fm.value[i].value = tax_dc_amt;			i++;		
		
		var a_b = <%=a_b%>;
		fm.cd[i].value = "a_b";				fm.nm[i].value = "견적개월수"	;								fm.value[i].value = a_b;				i++;		
		
		var rent_st = <%=rent_st%>;
		fm.cd[i].value = "rent_st";			fm.nm[i].value = "대여구분"	;									fm.value[i].value = rent_st;				i++;		
		

		
		fm.cd[i].value = "";				fm.nm[i].value = "---------------------------"; fm.value[i].value = '재리스차량 현재잔가율 산출과정 -------------';			i++;				

		var o_a = <%=ej_bean.getJg_1()%>;
		fm.cd[i].value = "o_a";				fm.nm[i].value = "현시점 차령 24개월 잔가율";					fm.value[i].value = o_a;					i++;		

		var g_1 = <%=em_bean.getJg_c_1()%>/100;
		if(<%=rent_dt%> >= 20140912){
		    g_1 = g_1*(1-<%=ej_bean.getJg_g_2()%>*0.35);
		}
		if(<%=rent_dt%> >= 20171018){
		    g_1 = g_1*(1-<%=ej_bean.getJg_g_9()%>+<%=ej_bean.getJg_g_10()%>);
		}
		fm.cd[i].value = "g_1";				fm.nm[i].value = "0개월 기준 잔가";								fm.value[i].value = g_1;					i++;		

		var o_2 = <%=ej_bean.getJg_2()%>;
		fm.cd[i].value = "o_2";				fm.nm[i].value = "일반승용 LPG 여부";							fm.value[i].value = o_2;					i++;		

		var o_3 = <%=ej_bean.getJg_3()%>;
		fm.cd[i].value = "o_3";				fm.nm[i].value = "기본 특소세율";								fm.value[i].value = o_3;					i++;		

		var o_b = g_1*(1+o_2*o_3)+(o_a-0.6*(1+o_2*o_3))*0.5;
		if(<%=rent_dt%> >= 20171018){
		    o_b = g_1*(1+o_2*o_3)+(o_a-0.6*(1-<%=ej_bean.getJg_g_9()%>+<%=ej_bean.getJg_g_10()%>)*(1+o_2*o_3))*0.5;
		}
		if(<%=rent_dt%> >= 20190419){
		    o_b = g_1+(o_a-0.6*(1-<%=ej_bean.getJg_g_9()%>+<%=ej_bean.getJg_g_10()%>))*0.5;
		}
		o_b = getCutNumber(o_b,9);
		fm.cd[i].value = "o_b";				fm.nm[i].value = "현시점 차령 0개월 잔가율";					fm.value[i].value = o_b;					i++;		

		var o_4 = <%=ej_bean.getJg_4()%>;
		fm.cd[i].value = "o_4";				fm.nm[i].value = "최저잔가율 조정승수(최대0.4)";				fm.value[i].value = o_4;					i++;		
		
		var o_d = o_a*o_4;
		fm.cd[i].value = "o_d";				fm.nm[i].value = "현시점 최저 잔가율";							fm.value[i].value = o_d;					i++;		
		
		var fw_917 = getRentTime('l', '<%=init_reg_dt%>', '<%=rent_dt%>')/365*12;
		fm.cd[i].value = "fw_917";			fm.nm[i].value = "현재차령(개월)";								fm.value[i].value = fw_917;					i++;		
		
		var cyber24 = 0;
		var cyber_a_b = a_b;
		if(<%=rent_dt%> >= 20160314){
			if(<%=ej_bean.getJg_2()%>==1 && a_b<24){ //20190418
				cyber24 = 24-a_b;
				cyber_a_b = cyber_a_b+cyber24;
			}
		}
		if(<%=rent_dt%> >= 20170101){
			if(<%=ej_bean.getJg_2()%>==1 && a_b<18){ //20190418
				cyber_a_b = a_b;
				cyber24 = 18-a_b;
				cyber_a_b = cyber_a_b+cyber24;
			}
		}
				
		var gb_917 = fw_917+cyber_a_b;
		fm.cd[i].value = "gb_917";			fm.nm[i].value = "재리스종료시점차령(개월)";					fm.value[i].value = gb_917;					i++;		
		fm.cd[i].value = "a_b";				fm.nm[i].value = "a_b";							fm.value[i].value = a_b;					i++;		
		fm.cd[i].value = "cyber_a_b";			fm.nm[i].value = "cyber_a_b";						fm.value[i].value = cyber_a_b;					i++;		
		
		var o_e = o_d+Math.pow((o_a-o_d)/(o_b-o_d),fw_917/24)*(o_b-o_d);
		o_e = getCutNumber(o_e,9);
		fm.cd[i].value = "o_e";				fm.nm[i].value = "현시점 차령 적용 평균잔가율";					fm.value[i].value = o_e;					i++;		

		var o_e_r = o_d+Math.pow((o_a-o_d)/(o_b-o_d),gb_917/24)*(o_b-o_d);
		o_e_r = getCutNumber(o_e_r,9);
		fm.cd[i].value = "o_e_r";			fm.nm[i].value = "현시점 차령 적용 평균잔가율(r)";				fm.value[i].value = o_e_r;					i++;		

		var g_3 = <%=em_bean.getJg_c_3()%>/100;
		if(<%=rent_dt%> >= 20110101){
			g_3 = <%=em_bean.getJg_c_32()%>/100;
		}
		fm.cd[i].value = "g_3";				fm.nm[i].value = "신차등록월에따른1년당 잔가율변동값";			fm.value[i].value = g_3;					i++;		

		var fw_920 = getRentTime('l', '<%=init_reg_dt.substring(0,4)%>0101', '<%=init_reg_dt%>')+1;
		fm.cd[i].value = "fw_920";			fm.nm[i].value = "신차등록일-전년도말일";						fm.value[i].value = fw_920;					i++;		
		
		var o_p = g_3*(fw_920/365-0.5);
		fm.cd[i].value = "o_p";				fm.nm[i].value = "신등차등록월에따른 잔가율 변동값";			fm.value[i].value = o_p;					i++;		

		var o_6 = <%=ej_bean.getJg_6()%>;
		fm.cd[i].value = "o_6";				fm.nm[i].value = "기본차량 잔가율 승수";						fm.value[i].value = o_6;					i++;		

		var o_f = o_e*o_6+o_p;
		if(<%=rent_dt%> >= 20150217){
			o_f = o_e*o_6*(1+o_p);
		}
		o_f = getCutNumber(o_f,9);
		fm.cd[i].value = "o_f";				fm.nm[i].value = "현시점 기본차량 잔가율";						fm.value[i].value = o_f;					i++;		

		var o_f_r = o_e_r*o_6+o_p;
		if(<%=rent_dt%> >= 20150217){
			o_f_r = o_e_r*o_6*(1+o_p);
		}
		o_f_r = getCutNumber(o_f_r,9);
		fm.cd[i].value = "o_f_r";			fm.nm[i].value = "현시점 기본차량 잔가율(r)";					fm.value[i].value = o_f_r;					i++;		

		
		var g_k1 = 0;		
		if(init_reg_dt >= 19900000 && init_reg_dt < 19980701) 		g_k1 = <%=ej_bean.getJg_st1()%>;
		if(init_reg_dt >= 19980701 && init_reg_dt < 20011119) 		g_k1 = <%=ej_bean.getJg_st2()%>;
		if(init_reg_dt >= 20011119 && init_reg_dt < 20020901) 		g_k1 = <%=ej_bean.getJg_st3()%>;
		if(init_reg_dt >= 20020901 && init_reg_dt < 20030712) 		g_k1 = <%=ej_bean.getJg_st4()%>;
		if(init_reg_dt >= 20030712 && init_reg_dt < 20040324) 		g_k1 = <%=ej_bean.getJg_st5()%>;
		if(init_reg_dt >= 20040324 && init_reg_dt < 20060101) 		g_k1 = <%=ej_bean.getJg_st6()%>;
		if(init_reg_dt >= 20060101 && init_reg_dt < 20080101) 		g_k1 = <%=ej_bean.getJg_st7()%>;
		if(init_reg_dt >= 20080101 && init_reg_dt < 20081219) 		g_k1 = <%=ej_bean.getJg_st8()%>;		
		if(init_reg_dt >= 20081219 && init_reg_dt < 20090631) 		g_k1 = <%=ej_bean.getJg_st9()%>;				
		if(init_reg_dt >= 20090631)                            		g_k1 = <%=ej_bean.getJg_st10()%>;
		
		var g_k2 = 0;		
		if(rent_dt >= 19900000 && rent_dt < 19980701) 			g_k2 = <%=ej_bean.getJg_st1()%>;
		if(rent_dt >= 19980701 && rent_dt < 20011119) 			g_k2 = <%=ej_bean.getJg_st2()%>;
		if(rent_dt >= 20011119 && rent_dt < 20020901) 			g_k2 = <%=ej_bean.getJg_st3()%>;
		if(rent_dt >= 20020901 && rent_dt < 20030712) 			g_k2 = <%=ej_bean.getJg_st4()%>;
		if(rent_dt >= 20030712 && rent_dt < 20040324) 			g_k2 = <%=ej_bean.getJg_st5()%>;
		if(rent_dt >= 20040324 && rent_dt < 20060101) 			g_k2 = <%=ej_bean.getJg_st6()%>;
		if(rent_dt >= 20060101 && rent_dt < 20080101) 			g_k2 = <%=ej_bean.getJg_st7()%>;
		if(rent_dt >= 20080101 && rent_dt < 20081219) 			g_k2 = <%=ej_bean.getJg_st8()%>;		
		if(rent_dt >= 20081219 && rent_dt < 20090631) 			g_k2 = <%=ej_bean.getJg_st9()%>;				
		if(rent_dt >= 20090631)                          		g_k2 = <%=ej_bean.getJg_st10()%>;
		
		if(<%=ej_bean.getReg_dt()%> >= 20120315){
			if(init_reg_dt >= 20090631 && init_reg_dt < 20120315) 	g_k1 = <%=ej_bean.getJg_st10()%>;				
			if(init_reg_dt >= 20120315 && init_reg_dt < 20130101)   g_k1 = <%=ej_bean.getJg_st11()%>;
			if(init_reg_dt >= 20130101 && init_reg_dt < 20140101)   g_k1 = <%=ej_bean.getJg_st12()%>;
			if(init_reg_dt >= 20140101 && init_reg_dt < 20150101)   g_k1 = <%=ej_bean.getJg_st13()%>;
			if(init_reg_dt >= 20150101 && init_reg_dt < 20150827)   g_k1 = <%=ej_bean.getJg_st14()%>;
			if(init_reg_dt >= 20150827 && init_reg_dt < 20160101)   g_k1 = <%=ej_bean.getJg_st16()%>;
			if(init_reg_dt >= 20160101 && init_reg_dt < 20160203)   g_k1 = <%=ej_bean.getJg_st17()%>;
			if(init_reg_dt >= 20160203 && init_reg_dt < 20160701)   g_k1 = <%=ej_bean.getJg_st18()%>;
			if(init_reg_dt >= 20160701 && init_reg_dt < 20180719)   g_k1 = <%=ej_bean.getJg_st19()%>;
			if(init_reg_dt >= 20180719 && init_reg_dt < 20190419)   g_k1 = <%=ej_bean.getJg_st20()%>;
			if(init_reg_dt >= 20190419 && init_reg_dt < 20200101)   g_k1 = <%=ej_bean.getJg_st21()%>;
			if(init_reg_dt >= 20200101 && init_reg_dt < 20200701)   g_k1 = <%=ej_bean.getJg_st22()%>;
			if(init_reg_dt >= 20200701)                            	g_k1 = <%=ej_bean.getJg_st23()%>;
			if(rent_dt >= 20090631 && rent_dt < 20120315) 			g_k2 = <%=ej_bean.getJg_st10()%>;				
			if(rent_dt >= 20120315 && rent_dt < 20130101)   		g_k2 = <%=ej_bean.getJg_st11()%>;
			if(rent_dt >= 20130101 && rent_dt < 20140101)    		g_k2 = <%=ej_bean.getJg_st12()%>;
			if(rent_dt >= 20140101 && rent_dt < 20150101)    		g_k2 = <%=ej_bean.getJg_st13()%>;
			if(rent_dt >= 20150101 && rent_dt < 20150827)    		g_k2 = <%=ej_bean.getJg_st14()%>;
			if(rent_dt >= 20150827 && rent_dt < 20160101)     		g_k2 = <%=ej_bean.getJg_st16()%>;
			if(rent_dt >= 20160101 && rent_dt < 20160203)   		g_k2 = <%=ej_bean.getJg_st17()%>;
			if(rent_dt >= 20160203 && rent_dt < 20160701)    		g_k2 = <%=ej_bean.getJg_st18()%>;
			if(rent_dt >= 20160701 && rent_dt < 20180719)     		g_k2 = <%=ej_bean.getJg_st19()%>;
			if(rent_dt >= 20180719 && rent_dt < 20190419)           g_k2 = <%=ej_bean.getJg_st20()%>;
			if(rent_dt >= 20190419 && rent_dt < 20200101)           g_k2 = <%=ej_bean.getJg_st21()%>;
			if(rent_dt >= 20200101 && rent_dt < 20200701)           g_k2 = <%=ej_bean.getJg_st22()%>;
			if(rent_dt >= 20200701)                           		g_k2 = <%=ej_bean.getJg_st23()%>;
		}	
		//중간변경분 처리
		if(<%=ej_bean.getReg_dt()%> >= 20120911){
			if(init_reg_dt >= 20120910 && init_reg_dt < 20130101)   g_k1 = <%=ej_bean.getJg_st15()%>;
			if(rent_dt >= 20120910 && rent_dt < 20130101)    	g_k2 = <%=ej_bean.getJg_st15()%>;
		}				


		var g_k3 = (1+g_k2)/(1+g_k1);
		if('<%=duty_free_opt%>'=='1'){
			g_k3 = (1+g_k2);
		}
		fm.cd[i].value = "g_k3";				fm.nm[i].value = "중고차가 산정시 신차가격 환산 승수";		fm.value[i].value = g_k3;					i++;		
		
		//20171016
		var o_q1 = <%=ht.get("CAR_AMT")%>*g_k3/10000-(<%=ht.get("TAX_DC_AMT")%>/10000);
		fm.cd[i].value = "o_q1";				fm.nm[i].value = "환산 신차가격-차종(만원)";				fm.value[i].value = o_q1;					i++;		

		var o_q2 = <%=ht.get("OPT_AMT")%>*g_k3/10000;
		fm.cd[i].value = "o_q2";				fm.nm[i].value = "환산 신차가격-옵션(만원)";				fm.value[i].value = o_q2;					i++;		

		var o_q3 = <%=ht.get("COL_AMT")%>*g_k3/10000;
		fm.cd[i].value = "o_q3";				fm.nm[i].value = "환산 신차가격-색상(만원)";				fm.value[i].value = o_q3;					i++;		

		var o_q4 = o_q1+o_q2+o_q3;
		fm.cd[i].value = "o_q4";				fm.nm[i].value = "환산 신차가격-합계(만원)";				fm.value[i].value = o_q4;					i++;		
		
		var o_7 = <%=ej_bean.getJg_7()%>;
		fm.cd[i].value = "o_7";					fm.nm[i].value = "기본차량가격";							fm.value[i].value = o_7;					i++;		

		var fw_930 = o_q1-o_7;
		fm.cd[i].value = "fw_930";				fm.nm[i].value = "초과차량가격";							fm.value[i].value = fw_930;					i++;		

		var o_8 = 1;
		if(fw_930>0) o_8 = <%=ej_bean.getJg_8()%>;		
		fm.cd[i].value = "o_8";					fm.nm[i].value = "초과차량가격 잔가율 승수";				fm.value[i].value = o_8;					i++;		

		var fw_932 = o_q2+o_q3;
		fm.cd[i].value = "fw_932";				fm.nm[i].value = "선택사양가격";							fm.value[i].value = fw_932;					i++;		

		var o_9 = 1;
		if(fw_932>0) o_9 = <%=ej_bean.getJg_9()%>;
		fm.cd[i].value = "o_9";					fm.nm[i].value = "선택사양가격 잔가율 승수";				fm.value[i].value = o_9;					i++;		

		var o_g1 = o_7*o_f+(fw_930*o_f*o_8)+(fw_932*o_f*o_9);
		o_g1 = getCutNumber(o_g1,9);
		fm.cd[i].value = "o_g1";				fm.nm[i].value = "매각시점 중고차가 g1형";					fm.value[i].value = o_g1;					i++;		
		
		var o_g1_r = o_7*o_f_r+(fw_930*o_f_r*o_8)+(fw_932*o_f_r*o_9);
		o_g1_r = getCutNumber(o_g1_r,9);
		fm.cd[i].value = "o_g1_r";				fm.nm[i].value = "매각시점 중고차가 g1형(r)";				fm.value[i].value = o_g1_r;					i++;		
		
		var fw_935 = o_q4-o_7;
		fm.cd[i].value = "fw_935";				fm.nm[i].value = "선택사양포함 초과차량가격";				fm.value[i].value = fw_935;					i++;		

		var o_10 = 1;
		if(fw_935>0) o_10 = <%=ej_bean.getJg_10()%>;
		fm.cd[i].value = "o_10";				fm.nm[i].value = "선택사양포함 초과차량가격 잔가율 승수";	fm.value[i].value = o_10;					i++;		

		var o_g2 = o_7*o_f+(fw_935*o_f*o_10);
		o_g2 = getCutNumber(o_g2,9);
		fm.cd[i].value = "o_g2";				fm.nm[i].value = "매각시점 중고차가 g2형";					fm.value[i].value = o_g2;					i++;		
		
		var o_g2_r = o_7*o_f_r+(fw_935*o_f_r*o_10);
		o_g2_r = getCutNumber(o_g2_r,9);
		fm.cd[i].value = "o_g2_r";				fm.nm[i].value = "매각시점 중고차가 g2형(r)";				fm.value[i].value = o_g2_r;					i++;		
		
		var o_11 = <%=ej_bean.getJg_11()%>;
		fm.cd[i].value = "o_11";				fm.nm[i].value = "중고차가결정변수";						fm.value[i].value = o_11;					i++;		

		var o_g = 0;
		if(o_11 == 1) 	o_g = o_g1;
		else			o_g = o_g2;
		fm.cd[i].value = "o_g";					fm.nm[i].value = "현시점 중고차가(주행거리 미반영)";		fm.value[i].value = o_g;					i++;		
		
		var o_g_r = 0;
		if(o_11 == 1) 	o_g_r = o_g1_r;
		else			o_g_r = o_g2_r;
		fm.cd[i].value = "o_g_r";				fm.nm[i].value = "현시점 중고차가(주행거리 미반영)(r)";		fm.value[i].value = o_g_r;					i++;		
		
		
		
		var g_7 = 0;
		if(<%=ej_bean.getJg_b()%>==1) 		g_7 = <%=em_bean.getJg_c_72()%>/36*fw_917;	//디젤
		else if(<%=ej_bean.getJg_b()%>==2) 	g_7 = <%=em_bean.getJg_c_73()%>/36*fw_917;	//LPG
		else								g_7 = <%=em_bean.getJg_c_71()%>/36*fw_917;	//가솔린
		g_7 = Math.round(g_7);
		fm.cd[i].value = "g_7";					fm.nm[i].value = "해당 차령 표준주행거리(km)";				fm.value[i].value = g_7;					i++;		
		
		var g_7_r = 0;
		if(<%=ej_bean.getJg_b()%>==1) 		g_7_r = <%=em_bean.getJg_c_72()%>/36*gb_917;
		else if(<%=ej_bean.getJg_b()%>==2) 	g_7_r = <%=em_bean.getJg_c_73()%>/36*gb_917;
		else								g_7_r = <%=em_bean.getJg_c_71()%>/36*gb_917;
		g_7_r = Math.round(g_7_r);
		fm.cd[i].value = "g_7_r";				fm.nm[i].value = "해당 차령 표준주행거리(km)(r)";			fm.value[i].value = g_7_r;					i++;		
		
		var fw_941 = today_dist;
		if(fw_941 == 0){
			fw_941 = Math.round(g_7);
			fm.value[3].value = fw_941;		
		}
		fm.cd[i].value = "fw_941";				fm.nm[i].value = "실주행거리(km)";							fm.value[i].value = fw_941;					i++;		
		
		
		var gb_942 = 0;
		if('<%=rent_st%>'=='2'){
			gb_942 = (fw_941/fw_917*cyber_a_b);
		}else{
			if(<%=ej_bean.getJg_b()%>==1)			gb_942 = <%=em_bean.getJg_c_72()%>/36*cyber_a_b;				//디젤1
			else if(<%=ej_bean.getJg_b()%>==2)		gb_942 = <%=em_bean.getJg_c_73()%>/36*cyber_a_b;				//LPG2
			else						gb_942 = <%=em_bean.getJg_c_71()%>/36*cyber_a_b;				//가솔린0			
			
			if('<%=lpg_yn%>'=='Y') 				gb_942 = gb_942*(<%=em_bean.getJg_c_73()%>/<%=em_bean.getJg_c_71()%>);
		}		
		gb_942 = Math.round(gb_942);
		fm.cd[i].value = "gb_942";				fm.nm[i].value = "예상추가주행거리(km)";					fm.value[i].value = gb_942;					i++;		
				
		var o_r = 0;
		if(<%=ej_bean.getJg_b()%>==1) 		o_r = (fw_941-g_7)/10000*<%=em_bean.getJg_c_82()%>/100;
		else								o_r = (fw_941-g_7)/10000*<%=em_bean.getJg_c_81()%>/100;
		if(<%=rent_dt%> >= 20171018){
			if(<%=ej_bean.getJg_b()%>==1) 	o_r = Math.pow(1+(<%=em_bean.getJg_c_82()%>/100),(fw_941-g_7)/10000);
			else														o_r = Math.pow(1+(<%=em_bean.getJg_c_81()%>/100),(fw_941-g_7)/10000);
		}
		fm.cd[i].value = "o_r";					fm.nm[i].value = "주행거리에 따른 중고차가 조정율";			fm.value[i].value = o_r;					i++;		
		
		var o_r_r = 0;
		if(<%=ej_bean.getJg_b()%>==1) 		o_r_r = (fw_941+gb_942-g_7_r)/10000*<%=em_bean.getJg_c_82()%>/100;
		else															o_r_r = (fw_941+gb_942-g_7_r)/10000*<%=em_bean.getJg_c_81()%>/100;
		if(<%=rent_dt%> >= 20171018){
			if(<%=ej_bean.getJg_b()%>==1) 	o_r_r = Math.pow(1+(<%=em_bean.getJg_c_82()%>/100),(fw_941+gb_942-g_7_r)/10000);
			else														o_r_r = Math.pow(1+(<%=em_bean.getJg_c_81()%>/100),(fw_941+gb_942-g_7_r)/10000);
		}	
		fm.cd[i].value = "o_r_r";				fm.nm[i].value = "주행거리에 따른 중고차가 조정율";			fm.value[i].value = o_r_r;					i++;		
		
		
		var g_9 = <%=em_bean.getJg_c_9()%>*cyber_a_b/24/100;
		fm.cd[i].value = "g_9";					fm.nm[i].value = "시간경과에 따른 중고차가 하락율";			fm.value[i].value = g_9;					i++;				
		
		var g_10 = o_2*<%=em_bean.getJg_c_10()%>*cyber_a_b/24/100;
		fm.cd[i].value = "g_10";				fm.nm[i].value = "LPG차량 전용차 추가 하락율";				fm.value[i].value = g_10;					i++;				
				
		var a_m_1 = <%=em_bean.getSh_a_m_1()%>/100;
		if('<%=ej_bean.getJg_g_45()%>' != '' && '<%=ej_bean.getJg_g_45()%>' != '0.0'){
			a_m_1 = a_m_1*<%=ej_bean.getJg_g_45()%>;
		}
		fm.cd[i].value = "a_m_1";				fm.nm[i].value = "현재 중고차 경기지수";					fm.value[i].value = a_m_1;					i++;						
			
		var a_m_2 = <%=em_bean.getSh_a_m_2()%>/100;
		fm.cd[i].value = "a_m_2";				fm.nm[i].value = "36개월후 현재 중고차 경기지수 반영율";	fm.value[i].value = a_m_2;					i++;
		
		var a_m_3 = 1-(1-a_m_1)*a_m_2;
		fm.cd[i].value = "a_m_3";				fm.nm[i].value = "36개월후 중고차 경기지수";				fm.value[i].value = a_m_3;					i++;
		
		var a_m_4 = 0;
		if(a_b>36)	a_m_4 = a_m_1+((a_m_3-a_m_1)/36)*36;
		else		a_m_4 = a_m_1+((a_m_3-a_m_1)/36)*a_b;
		fm.cd[i].value = "a_m_4";				fm.nm[i].value = "대여종료시점 중고차 경기지수";			fm.value[i].value = a_m_4;					i++;

		var o_s_r = Math.round(o_g_r*(1+o_r_r));
		if(<%=rent_dt%> >= 20171018){
			o_s_r = Math.round(o_g_r*o_r_r);
		}
		fm.cd[i].value = "o_s_r";				fm.nm[i].value = "현시점 중고차가(주행거리반영,낙찰가)";	fm.value[i].value = o_s_r;					i++;				
		
		var o_s = Math.round(o_g*(1+o_r)*a_m_1);
		if(<%=rent_dt%> >= 20171018){
			o_s = Math.round(o_g*o_r*a_m_1);
		}
		fm.cd[i].value = "o_s";					fm.nm[i].value = "현시점 경매장 예상낙찰가(주행거리반영)";	fm.value[i].value = o_s;					i++;	

		var o_t = Math.round(o_s_r*(1-g_9-g_10)*a_m_4);
		fm.cd[i].value = "o_t";					fm.nm[i].value = "재리스 종료시점 경매장 예상낙찰가(최종)";	fm.value[i].value = o_t;					i++;		
		
		//20151013 색상 및 사양 잔가 반영
		if(<%=rent_dt%> >= 20151013){
			var jg_opt_aw = new Array();
			var jg_opt_ax = new Array();
			var jg_opt_ay = new Array();
			var jg_opt_az = new Array();
			var t_jg_opt_az = new Array();
			
			jg_opt_aw[0] = 0;
			jg_opt_aw[1] = 0;
			
			jg_opt_ax[0] = 0;
			jg_opt_ax[1] = 0;

			jg_opt_ay[0] = 0;
			jg_opt_ay[1] = 0;
			
			jg_opt_az[0] = 0;
			jg_opt_az[1] = 0;

			t_jg_opt_az[0] = 0;
			t_jg_opt_az[1] = 0;

			<%for(int j=0 ; j < s ; j++){
				//차종변수 색상사양 잔가변수
				EstiJgVarBean ejo_bean = e_db.getEstiJgOptVarCase(ej_bean.getSh_code(), ej_bean.getSeq(), app_value[j]);
			%>
								
				if(fw_917 < 36){
					jg_opt_aw[0] = <%=ejo_bean.getJg_opt_2()%>;
				}else{
					jg_opt_aw[0] = <%=ejo_bean.getJg_opt_2()%>*(1-(fw_917-36)*0.0125);
				}				
				
				if(gb_917 < 36){
					jg_opt_aw[1] = <%=ejo_bean.getJg_opt_2()%>;
				}else{
					jg_opt_aw[1] = <%=ejo_bean.getJg_opt_2()%>*(1-(gb_917-36)*0.0125);
				}				

				fm.cd[i].value = "jg_opt_aw[0]";	fm.nm[i].value = "색상 및 사양 잔가반영 - 현재차령 내수적용값";		fm.value[i].value = jg_opt_aw[0];		i++;			
				fm.cd[i].value = "jg_opt_aw[1]";	fm.nm[i].value = "색상 및 사양 잔가반영 - 종료시점 내수적용값";		fm.value[i].value = jg_opt_aw[1];		i++;			
				
				if(<%=ejo_bean.getJg_opt_5()%> > 0){
					if(fw_917 < <%=ejo_bean.getJg_opt_3()%>-3){
						jg_opt_ax[0] = 1 - ((<%=ejo_bean.getJg_opt_3()%>-3)-fw_917)*0.5/<%=ejo_bean.getJg_opt_5()%>;	
					}else if(fw_917 > <%=ejo_bean.getJg_opt_3()%>+3){
						jg_opt_ax[0] = 1 - (fw_917-(<%=ejo_bean.getJg_opt_3()%>+3))*0.5/<%=ejo_bean.getJg_opt_5()%>;	
					}else{
						jg_opt_ax[0] = 1;
					}					
					if(gb_917 < <%=ejo_bean.getJg_opt_3()%>-3){
						jg_opt_ax[1] = 1 - ((<%=ejo_bean.getJg_opt_3()%>-3)-gb_917)*0.5/<%=ejo_bean.getJg_opt_5()%>;	
					}else if(gb_917 > <%=ejo_bean.getJg_opt_3()%>+3){
						jg_opt_ax[1] = 1 - (gb_917-(<%=ejo_bean.getJg_opt_3()%>+3))*0.5/<%=ejo_bean.getJg_opt_5()%>;	
					}else{
						jg_opt_ax[1] = 1;
					}										
				}

				fm.cd[i].value = "jg_opt_ax[0]";	fm.nm[i].value = "색상 및 사양 잔가반영 - 현재차령 수출승수";		fm.value[i].value = jg_opt_ax[0];		i++;			
				fm.cd[i].value = "jg_opt_ax[1]";	fm.nm[i].value = "색상 및 사양 잔가반영 - 종료시점 수출승수";		fm.value[i].value = jg_opt_ax[1];		i++;			
				
				
				if(jg_opt_ax[0]<0){
					jg_opt_ay[0] = 0;
				}else{
					jg_opt_ay[0] = <%=ejo_bean.getJg_opt_4()%>*jg_opt_ax[0];
				}

				if(jg_opt_ax[1]<0){
					jg_opt_ay[1] = 0;
				}else{
					jg_opt_ay[1] = <%=ejo_bean.getJg_opt_4()%>*jg_opt_ax[1];
				}

				fm.cd[i].value = "jg_opt_ay[0]";	fm.nm[i].value = "색상 및 사양 잔가반영 - 현재차령 수출적용값";		fm.value[i].value = jg_opt_ay[0];		i++;			
				fm.cd[i].value = "jg_opt_ay[1]";	fm.nm[i].value = "색상 및 사양 잔가반영 - 종료시점 수출적용값";		fm.value[i].value = jg_opt_ay[1];		i++;			
					
				jg_opt_az[0] = jg_opt_aw[0]+jg_opt_ay[0];
				jg_opt_az[1] = jg_opt_aw[1]+jg_opt_ay[1];
							
				t_jg_opt_az[0] = t_jg_opt_az[0] + jg_opt_az[0];
				t_jg_opt_az[1] = t_jg_opt_az[1] + jg_opt_az[1];
			
			<%}%>
			
			o_s = o_s + t_jg_opt_az[0];
			o_t = o_t + t_jg_opt_az[1];
			
		}
		
		//20180601 수출효과, 주행거리상쇄효과
		var ex_n_a = 0;
		var ex_n_b = 0;
		var ex_n_c = 0;
		var ex_n_d = 0;
		var ex_n_e = 0;
		var ex_n_f = 0;
		var ex_n_g = 0;
		var ex_n_h = 0;
		var ex_e_a = 0;
		var ex_e_b = 0;
		var ex_e_c = 0;
		var ex_e_d = 0;
		var ex_e_e = 0;
		var ex_e_f = 0;
		var ex_e_g = 0;
		var ex_e_h = 0;
		var ex_e_i = 0;
		var ex_e_j = 0;
		var ex_e_k = 0;
		var ex_e_l = 0;
		var ex_e_m = 0;
		var ex_e_n = 0;
		var ex_e_o = 0;
		var ex_e_p = 0;
		var ex_e_q = 0;
		
		//수출효과 대상 차량
		if(<%=rent_dt%> >= 20180601 && '<%=ej_bean.getJg_g_18()%>'=='1'){
			//현시점 수출효과 대상 차량 여부
			ex_n_a = 9;
			if(init_reg_dt >= '<%=ej_bean.getJg_g_26()%>' && <%=accid_serv_amt1%> < (car_amt+opt_amt+col_amt-tax_dc_amt)*<%=ej_bean.getJg_g_31()%>){
				ex_n_a = 1;
			}
			//재리스 수출가능 견적 대여 만료일
			ex_e_a = <%=rs_db.addDay(String.valueOf(AddUtil.parseInt(init_reg_dt.substring(0,4))+ej_bean.getJg_g_19())+"0101", ej_bean.getJg_g_27())%>;
			//연장 대여개시일이 재리스 수출가능 견적대여만료일보다 빨라야 함.	
			if(ex_n_a == 1 && rent_st == 2){
				if(rent_dt <= ex_e_a){
					ex_n_a = 1;
				}else{
					ex_n_a = 9;
				}
			}
			//재리스 견적 대여만료일
			ex_e_b = <%=rs_db.addMonth(rent_dt, AddUtil.parseInt(a_b))%>;
			//가상의 재리스 견적 대여만료일
			ex_e_c = ex_e_b;
			if(<%=a_b%> < 12){
				ex_e_c = <%=rs_db.addMonth(rent_dt, 12)%>;
			}
			//종료시점 수출효과 대상 차량 여부
			ex_e_d = 9;
			if(ex_e_b < ex_e_a && <%=accid_serv_amt1%> < (car_amt+opt_amt+col_amt-tax_dc_amt)*<%=ej_bean.getJg_g_31()%>){
				ex_e_d = 1;
			}
			
			//특정차량 수출효과 미대상 처리 40호0816(038126)
			if('<%=car_mng_id%>' == '038126'){
				ex_n_a = 9;
				ex_e_d = 9;
			}	
			
			//현시점 수출효과 계산
			if(ex_n_a == 1){
				//현시점 수출효과 적용율
				ex_n_b = 1-(getRentTime('l', '<%=ej_bean.getJg_g_26()%>', '<%=init_reg_dt%>')/(365*<%=ej_bean.getJg_g_20()%>));
				if(ex_n_b < 0){
					ex_n_b = 0;
				}
				//현시점 수출효과
				ex_n_c = <%=ej_bean.getJg_g_28()%>*ex_n_b;
				//현시점 중고차가(주행거리 미반영)
				ex_n_d = o_g;
				//주행거리에 따른 중고차 조정율
				ex_n_e = o_r;
				//주행거리에 따른 중고차가 조정효과
				ex_n_f = ex_n_d*(ex_n_e-1);
				//수출차량 주행거리 상쇄효과
				ex_n_g = ex_n_f*<%=ej_bean.getJg_g_30()%>*ex_n_b;
				//현시점 수출효과+주행거리 상쇄효과 합계
				ex_n_h = ex_n_c+ex_n_g;
				//수출효과 연장은 가중치를 준다
				if(rent_st > 1 && '<%=fee.getOpt_chk()%>'=='1'){
					if('<%=base.getCar_gu()%>'=='1'){
						ex_n_h = ex_n_h+<%=ej_bean.getJg_g_32()%>;
					}else{
						ex_n_h = ex_n_h+<%=ej_bean.getJg_g_33()%>;
					}
				}
				o_s = o_s + ex_n_h;
			}
			//종료시점 수출효과 계산
			if(ex_e_d == 1){
				//재리스 종료시점 수출효과 적용율
				var ex_e_c2 = ex_e_c.toString().substr(0, 4);
				ex_e_c2 = ex_e_c2-<%=ej_bean.getJg_g_19()%>;
				ex_e_c2 = ex_e_c2+'0101';
				ex_e_e = 1-(getRentTime('l', ex_e_c2, '<%=init_reg_dt%>')/(365*<%=ej_bean.getJg_g_20()%>));
				//재리스 종료시점 수출효과 적용율 적용값
				ex_e_f = ex_e_e;
				if(ex_e_f<0){
					ex_e_f = 0;
				}else if (ex_e_f>1){
					ex_e_f = 1;
				}
				//재리스 종료시점 수출효과
				ex_e_g = <%=ej_bean.getJg_g_29()%>*ex_e_f;
				//이용기간 12개월미만 수출효과 적용율
				if(ex_n_c > 0){
					if(<%=a_b%> < 12){
						ex_e_h = Math.pow(ex_e_g/ex_n_c,<%=a_b%>/12);
					}else{
						ex_e_h = ex_e_g/ex_n_c;
					}
				}
				//적용 재리스 종료시점 수출효과
				if(<%=a_b%> < 12){
					ex_e_i = ex_n_c*ex_e_h;
				}else{
					ex_e_i = ex_e_g;
				}
				//재리스 종료시점 중고차가(주행거리 미반영)
				ex_e_j = o_g_r;
				//주행거리에 따른 중고차가 조정율
				ex_e_k = o_r_r;
				//주행거리에 따른 중고차가 조정 효과
				ex_e_l = ex_e_j*(ex_e_k-1);
				//수출차량 주행거리 상쇄효과(수출가능차량)
				ex_e_m = ex_e_l*<%=ej_bean.getJg_g_30()%>*ex_e_f;
				if(<%=rent_dt%> >= 20220617){
					ex_e_m = ex_e_m*0.6;
				}
				//이용기간 12개월미만 주행거리 상쇄효과 적용율
				ex_e_n = ex_n_b+(ex_e_f-ex_n_b)/12*<%=a_b%>;
				//작용 수출차량 주행거리 상쇄효과
				if(<%=a_b%> < 12){
					ex_e_o = ex_e_l*<%=ej_bean.getJg_g_30()%>*ex_e_n;
				}else{
					ex_e_o = ex_e_m;
				}
				//적용 재리스 종료시점 수출효과+적용수출차량 주행거리 상쇄효과 합계
				if(ex_e_d == 1){
					ex_e_p = ex_e_i+ex_e_o; 
				}
				//수출효과 연장은 가중치를 준다
				if(rent_st > 1 && '<%=fee.getOpt_chk()%>'=='1'){
					if('<%=base.getCar_gu()%>'=='1'){
						ex_e_p = ex_e_p+<%=ej_bean.getJg_g_32()%>;
					}else{
						ex_e_p = ex_e_p+<%=ej_bean.getJg_g_33()%>;
					}
				}
				//약정운행거리 조정에 따른 재리스 주행거리 상쇄효과 반영율
				if(ex_e_d == 1){
					ex_e_q = <%=ej_bean.getJg_g_30()%>+ex_e_f; 
					if(<%=rent_dt%> >= 20220617){
						ex_e_q = ex_e_q*0.6;
					}
				}
				//연장에서 약정운행거리 조정에 따른 재리스 주행거리 상쇄효과 반영율 적용불가
				if(rent_st > 1){
					ex_e_q = 0;
				}
				o_t = o_t + ex_e_p;
			}
		}
		
		fm.cd[i].value = "ex_n_a";			fm.nm[i].value = "현시점 수출효과 대상 차량 여부";				fm.value[i].value = ex_n_a;				i++;		
		fm.cd[i].value = "ex_e_a";			fm.nm[i].value = "재리스 수출가능 견적 대여 만료일";			fm.value[i].value = ex_e_a;				i++;		
		fm.cd[i].value = "ex_e_b";			fm.nm[i].value = "재리스 견적 대여만료일";						fm.value[i].value = ex_e_b;				i++;		
		fm.cd[i].value = "ex_e_c";			fm.nm[i].value = "가상의 재리스 견적 대여만료일";				fm.value[i].value = ex_e_c;				i++;		
		fm.cd[i].value = "ex_e_d";			fm.nm[i].value = "종료시점 수출효과 대상 차량 여부";			fm.value[i].value = ex_e_d;				i++;		
		fm.cd[i].value = "ex_n_b";			fm.nm[i].value = "현시점 수출효과 적용율";						fm.value[i].value = ex_n_b;				i++;		
		fm.cd[i].value = "ex_n_c";			fm.nm[i].value = "현시점 수출효과";									fm.value[i].value = ex_n_c;				i++;		
		fm.cd[i].value = "ex_n_d";			fm.nm[i].value = "현시점 중고차가(주행거리 미반영)";			fm.value[i].value = ex_n_d;				i++;		
		fm.cd[i].value = "ex_n_e";			fm.nm[i].value = "주행거리에 따른 중고차 조정율";				fm.value[i].value = ex_n_e;				i++;		
		fm.cd[i].value = "ex_n_f";			fm.nm[i].value = "주행거리에 따른 중고차가 조정효과";			fm.value[i].value = ex_n_f;				i++;		
		fm.cd[i].value = "ex_n_g";			fm.nm[i].value = "수출차량 주행거리 상쇄효과";					fm.value[i].value = ex_n_g;				i++;		
		fm.cd[i].value = "ex_e_e";			fm.nm[i].value = "재리스 종료시점 수출효과 적용율";				fm.value[i].value = ex_e_e;				i++;		
		fm.cd[i].value = "ex_e_f";			fm.nm[i].value = "재리스 종료시점 수출효과 적용율 적용값";	fm.value[i].value = ex_e_f;				i++;		
		fm.cd[i].value = "ex_e_g";			fm.nm[i].value = "재리스 종료시점 수출효과";						fm.value[i].value = ex_e_g;				i++;		
		fm.cd[i].value = "ex_e_h";			fm.nm[i].value = "이용기간 12개월미만 수출효과 적용율";		fm.value[i].value = ex_e_h;				i++;		
		fm.cd[i].value = "ex_e_i";			fm.nm[i].value = "적용 재리스 종료시점 수출효과";				fm.value[i].value = ex_e_i;				i++;		
		fm.cd[i].value = "ex_e_j";			fm.nm[i].value = "재리스 종료시점 중고차가(주행거리 미반영)";	fm.value[i].value = ex_e_j;				i++;		
		fm.cd[i].value = "ex_e_k";			fm.nm[i].value = "주행거리에 따른 중고차가 조정율";				fm.value[i].value = ex_e_k;				i++;		
		fm.cd[i].value = "ex_e_l";			fm.nm[i].value = "주행거리에 따른 중고차가 조정 효과";		fm.value[i].value = ex_e_l;				i++;		
		fm.cd[i].value = "ex_e_m";			fm.nm[i].value = "수출차량 주행거리 상쇄효과(수출가능차량)";	fm.value[i].value = ex_e_m;				i++;		
		fm.cd[i].value = "ex_e_n";			fm.nm[i].value = "이용기간 12개월미만 주행거리 상쇄효과 적용율";	fm.value[i].value = ex_e_n;		i++;		
		fm.cd[i].value = "ex_e_o";			fm.nm[i].value = "작용 수출차량 주행거리 상쇄효과";				fm.value[i].value = ex_e_o;				i++;		
		fm.cd[i].value = "ex_e_p";			fm.nm[i].value = "대여 만료시점 수출효과(수출가능차량)";		fm.value[i].value = ex_e_p;				i++;		
		fm.cd[i].value = "ex_e_q";			fm.nm[i].value = "약정운행거리 조정에 따른 신차 주행거리 상쇄효과 반영율";	fm.value[i].value = ex_e_q;	i++;		

		
		//재리스시작시 일반승용 LPG차령 60개월이상 잔가율 조정
		if(<%=rent_dt%> >= 20170401){
				if(<%=ej_bean.getJg_2()%>==1 && fw_917 >= 59.7 ){ //20190418
					o_s = Math.round(o_s * (1+<%=ej_bean.getJg_g_11()%>));
				}
		}else{		
			if(<%=rent_dt%> >= 20170101){
				if(<%=ej_bean.getJg_2()%>==1 && fw_917 >= 59.7 ){ //20190418
					o_s = Math.round(o_s * (1+(<%=em_bean.getSh_c_k()%>/100)));
				}
			}
		}
		o_s = Math.round(o_s);
		fm.cd[i].value = "o_s";					fm.nm[i].value = "현시점 경매장 예상낙찰가(주행거리반영)";	fm.value[i].value = o_s;					i++;	
		
		var o_u = o_t/o_s;
		if(<%=rent_dt%> >= 20170401){
				if(<%=ej_bean.getJg_2()%>==1){ //20190418
					if(gb_917 >= 60){
						o_u = o_u + (o_t/o_s*<%=ej_bean.getJg_g_12()%>);
					}else if(gb_917 >= 54 && gb_917 < 60){
						o_u = o_u + (o_t/o_s*<%=ej_bean.getJg_g_12()%>*(gb_917-54)/6);
					}
				}
		}else{
			if(<%=rent_dt%> >= 20160314){
				if(<%=ej_bean.getJg_2()%>==1){ //20190418
					if(gb_917 >= 60){
						o_u = o_u + (o_t/o_s*<%=em_bean.getSh_c_m()%>/100);
					}else if(gb_917 >= 54 && gb_917 < 60){
						o_u = o_u + (o_t/o_s*<%=em_bean.getSh_c_m()%>/100*(gb_917-54)/6);
					}			
				}		
			}
		}
		fm.cd[i].value = "o_u";					fm.nm[i].value = "재리스 종료시점 예상 잔가율(현시점경매장예상)";fm.value[i].value = o_u;				i++;		
		
		var g_11 = <%=em_bean.getJg_c_11()%>*cyber_a_b/24/100;
		fm.cd[i].value = "g_11";				fm.nm[i].value = "중고차 시장변화에 따른 리스크 완충율";	fm.value[i].value = g_11;					i++;				
				
		var o_v = o_u*(1-g_11);
		fm.cd[i].value = "o_v";					fm.nm[i].value = "재리스 종료시점 적용 잔가율(현시점경매장예상)";fm.value[i].value = o_v;				i++;		
		
		var sh_c_a = <%=em_bean.getSh_c_a()%>;
		fm.cd[i].value = "sh_c_a";				fm.nm[i].value = "낙찰예상가 대비 현대가치 산출 승수";		fm.value[i].value = sh_c_a;					i++;		
		if(<%=rent_dt%> >= 20150512){
			sh_c_a = <%=ej_bean.getJg_g_5()%>*100;		
			fm.cd[i].value = "sh_c_a";			fm.nm[i].value = "재리스잔존가 산출 승수";			fm.value[i].value = sh_c_a;					i++;		
		}			
		
		
		var gb_954 = (sh_c_a/100-1);
		if(a_b>24)	gb_954 = gb_954/24*24;
		else		gb_954 = gb_954/24*a_b;	
		if(<%=rent_dt%> >= 20150610){
			if(a_b>36)	gb_954 = gb_954/36*24;
			else		gb_954 = gb_954/36*cyber_a_b;		
		}	
		gb_954 = 1+gb_954;
		fm.cd[i].value = "gb_954";				fm.nm[i].value = "sh_c_a 계약기간별반영율(36개월이상동일)";	fm.value[i].value = gb_954;					i++;		
		
		var o_w = o_v/gb_954;
		if(<%=rent_dt%> >= 20160314){
			if(<%=rent_dt%> >= 20170101){
				if(<%=ej_bean.getJg_2()%>==1 && a_b<18){ //20190418
					o_w = o_w + Math.pow(Math.round(o_v/gb_954,3),a_b/18)-Math.round(o_v/gb_954,3);
				}
			}else{
				if(<%=ej_bean.getJg_2()%>==1 && a_b<24){ //20190418
					o_w = o_w + Math.pow(Math.round(o_v/gb_954,3),a_b/24)-Math.round(o_v/gb_954,3);
				}
			}
		}		
		fm.cd[i].value = "o_w";					fm.nm[i].value = "재리스 및 연장계약 견적 적용 잔가율(최종)";fm.value[i].value = o_w;					i++;		
		
		var o_x = o_s*o_v;
		fm.cd[i].value = "o_x";					fm.nm[i].value = "중고차 시장변환에 따른 리스크를 감안한 적용잔가";fm.value[i].value = o_x;				i++;			
				

		fm.cd[i].value = "";					fm.nm[i].value = "---------------------------"; fm.value[i].value = '결과 --------------------------------------';			i++;				
		

		var sh_car_amt = 0;
		if('<%=rent_st%>'=='1' || '<%=rent_st%>'=='4'){
			if(<%=sh_amt%>>0)				sh_car_amt = <%=sh_amt%>;
			else						sh_car_amt = ten_th_rnd(Math.round(o_s*10000*sh_c_a/100));
		}else if('<%=rent_st%>'=='2'){
			if(<%=fee_opt_amt%>>0)				sh_car_amt = <%=fee_opt_amt%>;
			else{
				if(<%=sh_amt%>>0)			sh_car_amt = <%=sh_amt%>;
			    else	                    		sh_car_amt = ten_th_rnd(Math.round(o_s*10000*sh_c_a/100));
			}
		}else if('<%=rent_st%>'=='3'){
									sh_car_amt = <%=cust_sh_car_amt%>;
		}
		if((car_amt+opt_amt+col_amt) < sh_car_amt){
			sh_car_amt = (car_amt+opt_amt+col_amt);
		}
		fm.cd[i].value = "sh_car_amt";		fm.nm[i].value = "재리스차량가격(만원반올림)";					fm.value[i].value = sh_car_amt;				i++;
				
		var dlv_car_amt = (car_amt+opt_amt+col_amt)-sh_car_amt;
		fm.cd[i].value = "dlv_car_amt";		fm.nm[i].value = "감가상각";									fm.value[i].value = dlv_car_amt;			i++;		
					
		var o_y = o_x*10000/sh_car_amt;
		fm.cd[i].value = "o_y";					fm.nm[i].value = "중고차 리스 견적 적용 잔가율(최종)";		fm.value[i].value = o_y;					i++;		
		
		

						
		var o_13 =o_w;
		
		if(rent_st == 3){
			o_13 = o_y;
			var a14 = <%=cust_sh_car_amt%>/(o_s*10000);
			if(a14 < 1.05) o_13 = o_13 * (a14/1.05);
			if(<%=cust_sh_car_amt%> > 0 ){
				sh_car_amt = <%=cust_sh_car_amt%>;
			}		
		}
		
		
		var accid_sik_a = 0;
		var accid_sik_b = 0;
		var accid_sik_c = 0; 
		var accid_sik_e = 0; 
		var accid_sik_f = 0; 
		var accid_sik_g = 0; 
		var accid_sik_h = 0; 
		var accid_sik_j = 0; 
		
		//사고수리비 반영 예상낙찰가 및 잔가율
		if(<%=rent_dt%> >= 20150512){
		

			o_13 =o_w;
		
			fm.cd[i].value = "";				fm.nm[i].value = "---------------------------"; 		fm.value[i].value = '사고수리비 반영----------------------';			i++;						
		

			accid_sik_a = Math.pow((car_amt+opt_amt+col_amt)/(1+g_k1),<%=em_bean.getAccid_a()%>)*<%=em_bean.getAccid_b()%>;
			if(<%=rent_dt%> >= 20190801 && '<%=duty_free_opt%>'=='1'){
				accid_sik_a = Math.pow((car_amt+opt_amt+col_amt),<%=em_bean.getAccid_a()%>)*<%=em_bean.getAccid_b()%>;
			}
			
			
			

			//수입차
                	if(<%=ej_bean.getJg_w()%> == 1){
                    		accid_sik_a = Math.round(accid_sik_a*<%=em_bean.getAccid_c()%>,-4);
                	}else{
                    		accid_sik_a = Math.round(accid_sik_a,-4);
                	}

                	fm.cd[i].value = "accid_sik_a";			fm.nm[i].value = "대파기준 수리비";				fm.value[i].value = accid_sik_a;		i++;		

			


                	var accid_serv_amt1 = <%=accid_serv_amt1%>;
                	var accid_serv_amt2 = <%=accid_serv_amt2%>;
                	                	
                	//무사고견적시
                	if('<%=accid_serv_zero%>' == 'Y'){
                		accid_serv_amt1 = 0;
                		accid_serv_amt2 = 0;
                	}
			
			accid_sik_b = accid_serv_amt1+(accid_serv_amt2*<%=em_bean.getAccid_d()%>);			
			fm.cd[i].value = "accid_serv_amt1";		fm.nm[i].value = "1순위 사고수리비";				fm.value[i].value = accid_serv_amt1;		i++;		
			fm.cd[i].value = "accid_serv_amt2";		fm.nm[i].value = "2순위 사고수리비";				fm.value[i].value = accid_serv_amt2;		i++;		
			fm.cd[i].value = "accid_sik_b";			fm.nm[i].value = "적용 사고수리비";				fm.value[i].value = accid_sik_b;		i++;		
			
			


			accid_sik_c = 0;			
			if(accid_sik_b<accid_sik_a){
                    		accid_sik_c = Math.pow(accid_sik_b/accid_sik_a,<%=em_bean.getAccid_e()%>);
                	}else{
                    		accid_sik_c = Math.pow(accid_sik_b/accid_sik_a,<%=em_bean.getAccid_f()%>);
                	}
                	accid_sik_c = accid_sik_c*<%=em_bean.getAccid_g()%>;
                	fm.cd[i].value = "accid_sik_c";			fm.nm[i].value = "무사고차 대비 감가율";			fm.value[i].value = accid_sik_c;		i++;		
                

			accid_sik_e = fw_917;
			fm.cd[i].value = "accid_sik_e";			fm.nm[i].value = "차령";					fm.value[i].value = accid_sik_e;		i++;		
			

			accid_sik_f = (accid_sik_e*<%=em_bean.getAccid_h()%>*<%=em_bean.getAccid_j()%>+fw_941/10000*<%=em_bean.getAccid_k()%>*<%=em_bean.getAccid_m()%>)*<%=em_bean.getAccid_n()%>;
			fm.cd[i].value = "accid_sik_f";			fm.nm[i].value = "차령,주행거리반영 무사고차";			fm.value[i].value = accid_sik_f;		i++;		
			

			accid_sik_g = accid_sik_f*<%=ej_bean.getJg_g_4()%>;
			fm.cd[i].value = "accid_sik_g";			fm.nm[i].value = "차종 추가반영 무사고차 대비 평균 감가율";	fm.value[i].value = accid_sik_g;		i++;		
			

			accid_sik_h = o_s/(1-accid_sik_g);
			fm.cd[i].value = "accid_sik_h";			fm.nm[i].value = "무사고차 예상낙찰가";				fm.value[i].value = accid_sik_h;		i++;		
			

			accid_sik_j = Math.round(accid_sik_h*(1-accid_sik_c),0);
			//if('<%=car_mng_id%>' == '040194' && <%=rent_dt%> >= 20190801 && <%=rent_dt%> <= 20190831){
			//	accid_sik_j = accid_sik_j+200;
			//} --> 재리스계약 정상요금시 반영은 영업효율에서 처리한다.
			fm.cd[i].value = "accid_sik_j";			fm.nm[i].value = "실 예상낙찰가";				fm.value[i].value = accid_sik_j;		i++;		
			

			sh_car_amt = 0;		
			if('<%=rent_st%>'=='1' || '<%=rent_st%>'=='4'){
									sh_car_amt = ten_th_rnd(Math.round(accid_sik_j*10000*sh_c_a/100));
			}else if('<%=rent_st%>'=='2'){
				if(<%=fee_opt_amt%>>0)			sh_car_amt = <%=fee_opt_amt%>;
				else                            	sh_car_amt = ten_th_rnd(Math.round(accid_sik_j*10000*sh_c_a/100));
			}else if('<%=rent_st%>'=='3'){
									sh_car_amt = <%=cust_sh_car_amt%>;
			}
			
			//20220617 현시점 수출효과 대상차량이면 넘을수도 있다
			if(<%=rent_dt%> >= 20220617 && ex_n_a == 1){
				
			}else{
				//20220217 중고차자가 신차보다 클수는 없다. 
				if((car_amt+opt_amt+col_amt) < sh_car_amt){
					sh_car_amt = (car_amt+opt_amt+col_amt);
				}
			}	
					
			fm.cd[i].value = "sh_car_amt";				fm.nm[i].value = "재리스차량가격(만원반올림)";			fm.value[i].value = sh_car_amt;				i++;
				
			dlv_car_amt = (car_amt+opt_amt+col_amt)-sh_car_amt;
			fm.cd[i].value = "dlv_car_amt";				fm.nm[i].value = "감가상각";					fm.value[i].value = dlv_car_amt;			i++;		
								
			
			
			o_y = o_w*(1+(accid_sik_c-accid_sik_g)*a_b/12/12);
			fm.cd[i].value = "o_y";					fm.nm[i].value = "중고차 리스 견적 적용 잔가율(최종)";		fm.value[i].value = o_y;				i++;				
			
			fm.cd[i].value = "o_w";					fm.nm[i].value = "o_w";			fm.value[i].value = o_w;				i++;				
			fm.cd[i].value = "accid_sik_c";				fm.nm[i].value = "accid_sik_c";		fm.value[i].value = accid_sik_c;			i++;				
			fm.cd[i].value = "accid_sik_g";				fm.nm[i].value = "accid_sik_g";		fm.value[i].value = accid_sik_g;			i++;				
			fm.cd[i].value = "a_b";					fm.nm[i].value = "a_b";			fm.value[i].value = a_b;				i++;				
		
			o_13 =o_y;


		}
		
		
		
		//연장-매입옵션
		if(rent_st == 2 && <%=fee_opt_amt%> > 0 ){
			sh_car_amt = <%=fee_opt_amt%>;
		}		

		o_13 = Math.round((o_13*100)*10)/10;
		fm.cd[i].value = "o_13";				fm.nm[i].value = "최종잔가";								fm.value[i].value = o_13;					i++;
		
		
		<%if(mode.equals("lc_rent")){%>		
		
			var bc_b_e1 = Math.round((gb_954*100)*100)/100;
			var bc_b_e2 = ten_th_rnd(Math.round(o_s*10000));
			
			if(<%=rent_dt%> >= 20150512){
				bc_b_e2 = ten_th_rnd(Math.round(accid_sik_j*10000));
			}
						
			if(<%=fee_opt_amt%>>0){
				bc_b_e1 = 0;
				bc_b_e2 = 0;
				//alert('기존 매입옵션이 있는 연장입니다.');
			}else{
				parent.document.form1.bc_b_e1.value 	= bc_b_e1;
				parent.document.form1.bc_b_e2.value 	= bc_b_e2;
			}				
						
			parent.document.form1.max_ja.value 		= o_13;
			parent.document.form1.ja_amt.value 		= parseDecimal(sh_car_amt*o_13/100);
			parent.document.form1.ja_s_amt.value 		= parseDecimal(sh_car_amt*o_13/100/1.1);
			parent.document.form1.ja_v_amt.value 		= parseDecimal(toInt(parseDigit(parent.document.form1.ja_amt.value)) - toInt(parseDigit(parent.document.form1.ja_s_amt.value)));
			if(toInt(parseDigit(parent.document.form1.opt_amt.value)) == 0){
				parent.document.form1.app_ja.value 	= parent.document.form1.max_ja.value;
				parent.document.form1.ja_r_s_amt.value 	= parent.document.form1.ja_s_amt.value;
				parent.document.form1.ja_r_v_amt.value 	= parent.document.form1.ja_v_amt.value;
				parent.document.form1.ja_r_amt.value 	= parent.document.form1.ja_amt.value;		
			}	
		<%}else if(mode.equals("cmp")){%>
		
			parent.document.form1.o_13.value 		= o_13;
			parent.document.form1.ro_13.value 		= o_13;
			parent.document.form1.ro_13_amt.value 		= parseDecimal(sh_car_amt*o_13/100);		
			parent.opt_display();						
			
		<%}else if(mode.equals("cmpadd")){%>
		
			parent.document.form1.o_13.value 		= o_13;
			parent.document.form1.ro_13.value 		= o_13;
			parent.document.form1.ro_13_amt.value 		= parseDecimal(sh_car_amt*o_13/100);		
			
			
			fm.cd[i].value = "-";			fm.nm[i].value = "추가이용견적";	fm.value[i].value = '';		i++;
			fm.cd[i].value = "o_13";		fm.nm[i].value = "적용잔가";		fm.value[i].value = o_13;	i++;
			fm.cd[i].value = "ro_13_amt";		fm.nm[i].value = "적용잔가금액";	fm.value[i].value = parseDecimal(sh_car_amt*o_13/100);	i++;

			var bc_b_e1 = Math.round((gb_954*100)*100)/100;
			var bc_b_e2 = ten_th_rnd(Math.round(o_s*10000));
			
			fm.cd[i].value = "bc_b_e1";		fm.nm[i].value = "낙찰예상가대비현재가치산출승수의기간반영율";		fm.value[i].value = bc_b_e1;	i++;
			fm.cd[i].value = "bc_b_e2";		fm.nm[i].value = "경매장예상낙찰가격";					fm.value[i].value = bc_b_e2;	i++;
			
			if(<%=rent_dt%> >= 20150512){
				bc_b_e2 = ten_th_rnd(Math.round(accid_sik_j*10000));
			}
			
			fm.cd[i].value = "bc_b_e2";		fm.nm[i].value = "경매장예상낙찰가격";					fm.value[i].value = bc_b_e2;	i++;
						
			if(<%=fee_opt_amt%>>0){
				bc_b_e1 = 0;
				bc_b_e2 = 0;				
			}else{
				parent.document.form1.bc_b_e1.value 	= bc_b_e1;
				parent.document.form1.bc_b_e2.value 	= bc_b_e2;
			}
			
			alert("계산완료");
			
		<%}else if(mode.equals("asset")){//자산 폐기등록시 %>
		    
			parent.document.form1.sh_car_amt.value 		= parseDecimal(sh_car_amt);	
		//	parent.document.form1.sh_car_amt.value 		= parseDecimal(sh_car_amt*o_13/100);			
			
		 <%}else if(mode.equals("asset1")){//자산 폐기등록시 %>					
		 		    
			parent.parent.document.form1.sh_car_amt.value 		= parseDecimal(sh_car_amt);	
		//	parent.parent.document.form1.sh_car_amt.value 		= parseDecimal(sh_car_amt*o_13/100);	
			 
		<%}else if(mode.equals("off_ls")){//경매출품현황에서 %>
								
			parent.document.form1.o_s_amt.value 		= parseDecimal(sh_car_amt);	
			
			if(<%=rent_dt%> >= 20150512){ //실예상낙찰가
				parent.document.form1.o_s_amt.value 	= parseDecimal(accid_sik_j*10000);
			}							

		<%}else{%>
			parent.document.form1.o_13.value 			= o_13;
			parent.document.form1.ro_13.value 			= o_13;
			parent.document.form1.ro_13_amt.value 		= parseDecimal(sh_car_amt*o_13/100);		
		<%}%>
		



		<%if(st.equals("all") || st.equals("2")){//st.equals("1") || %>
		parent.EstiRegAuto();
		<%}%>
		
	
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
