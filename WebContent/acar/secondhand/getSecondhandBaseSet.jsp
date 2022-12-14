<%@ page language="java" contentType="text/html; charset=euc-kr" %>
<%@ page import="java.util.*, acar.util.*, acar.common.*, acar.secondhand.*, acar.estimate_mng.*, acar.cont.*, acar.user_mng.*" %>
<jsp:useBean id="shDb" class="acar.secondhand.SecondhandDatabase" scope="page"/>
<jsp:useBean id="a_db" scope="page" class="acar.cont.AddContDatabase"/>
<jsp:useBean id="rs_db" scope="page" class="acar.res_search.ResSearchDatabase"/>
<%@ include file="/acar/cookies.jsp" %>

<%
	String add_rent_st 	= request.getParameter("add_rent_st")==null?"":request.getParameter("add_rent_st");
	String car_mng_id 	= request.getParameter("car_mng_id")==null?"":request.getParameter("car_mng_id");
	String rent_dt 		= request.getParameter("rent_dt")==null?"":request.getParameter("rent_dt");
	String a_b 		= request.getParameter("a_b")==null?"1":request.getParameter("a_b");
	String rent_st 		= request.getParameter("rent_st")==null?"1":request.getParameter("rent_st");
	String est_st 		= request.getParameter("est_st")==null?"":request.getParameter("est_st");
	String mode 	  	= request.getParameter("mode")==null?"":request.getParameter("mode");
	int    fee_opt_amt 	= request.getParameter("fee_opt_amt")==null?0:AddUtil.parseDigit(request.getParameter("fee_opt_amt"));
	String jg_b_dt 		= request.getParameter("jg_b_dt")==null?"":request.getParameter("jg_b_dt");
	String a_j 		= request.getParameter("a_j")==null?"":request.getParameter("a_j");
	String today_dist	= request.getParameter("today_dist")==null?"":request.getParameter("today_dist");
	
	String rent_mng_id	= request.getParameter("rent_mng_id")==null?"":request.getParameter("rent_mng_id");
	String rent_l_cd	= request.getParameter("rent_l_cd")==null?"":request.getParameter("rent_l_cd");
	String fee_rent_st	= request.getParameter("fee_rent_st")==null?"":request.getParameter("fee_rent_st");
	String from_page	= request.getParameter("from_page")==null?"":request.getParameter("from_page");
	String accid_serv_zero	= request.getParameter("accid_serv_zero")==null?"":request.getParameter("accid_serv_zero");
	
	
	out.println("today_dist="+today_dist+"<br>");
	
	if(add_rent_st.equals("t")){
		a_b = "1";
	}
	
	if(a_b.equals("0")){
		a_b = "1";
	}

	out.println("add_rent_st="+add_rent_st+"<br>");
	out.println("a_b="+a_b+"<br>");
	
	if(est_st.equals("2")){
		rent_st 	= "2";
	}else{
		if(!mode.equals("cmp") && !from_page.equals("/fms2/lc_rent/search_car_esti_s.jsp")) 	fee_opt_amt 	= 0;		//?????????? ???????? ???????? ????????????
	}
	if(a_b.equals("")) 		a_b 		= "36";
	if(rent_dt.equals("")) 		rent_dt 	= AddUtil.getDate(4);
	int cust_sh_car_amt = 0;								//???????????? ???????? ??????????
	
	CommonDataBase c_db = CommonDataBase.getInstance();
	MaMenuDatabase nm_db = MaMenuDatabase.getInstance();
	EstiDatabase e_db = EstiDatabase.getInstance();
	
	if(nm_db.getWorkAuthUser("??????",ck_acar_id) && rent_dt.equals("20190417"))	rent_dt = "20190418";
	
	//20180904  20180601 ???????? ????????
	ContFeeBean fee = new ContFeeBean();
	ContBaseBean base = new ContBaseBean();
	if(!rent_st.equals("") && !rent_mng_id.equals("") && !rent_l_cd.equals("")){
		fee = a_db.getContFeeNew(rent_mng_id, rent_l_cd, rent_st);
		//????????????
		base = a_db.getCont(rent_mng_id, rent_l_cd);
	}	
	
	//????????
	Hashtable ht = shDb.getShBase(car_mng_id);
	

	//???????? ???????? ????????
	jg_b_dt = e_db.getVar_b_dt(String.valueOf(ht.get("JG_CODE")), "jg", rent_dt);
	a_j 	= e_db.getVar_b_dt("em", rent_dt);

	//???????? ?????????? ???? ???????? ???????? ????????
	String em_var_seq = e_db.getVar_seq("em", rent_dt);
	
	//???? ????????
	Hashtable sh_var = shDb.getShBaseVar(car_mng_id);
	
	out.println("jg_code="+String.valueOf(ht.get("JG_CODE"))+"<br>");
	
	//??????????????
	EstiJgVarBean ej_bean = e_db.getEstiJgVarCase(String.valueOf(ht.get("JG_CODE")), jg_b_dt);
	
	//????????
	EstiCommVarBean em_bean = e_db.getEstiCommVarCase("1", em_var_seq);
	
	String init_reg_dt 	= String.valueOf(ht.get("INIT_REG_DT"));
	if(today_dist.equals("") || today_dist.equals("0")) today_dist 	= String.valueOf(ht.get("TODAY_DIST"));
	String lpg_yn 		= String.valueOf(ht.get("LPG_YN"));
	
	
	out.println("today_dist="+today_dist);
	
	
	if(today_dist.equals("") && rent_dt.equals(String.valueOf(ht.get("SERV_DT"))) && !today_dist.equals(String.valueOf(ht.get("TOT_DIST"))) && !String.valueOf(ht.get("TOT_DIST")).equals("0")){
		today_dist = String.valueOf(ht.get("TOT_DIST"));
	}
	
	out.println("String.valueOf(ht.get(SERV_DT)="+String.valueOf(ht.get("SERV_DT"))+"<br>");
	out.println("String.valueOf(ht.get(TOT_DIST)="+String.valueOf(ht.get("TOT_DIST"))+"<br>");
	
	out.println("rent_dt="+rent_dt+"<br>");
	out.println("today_dist="+today_dist+"<br>");
	out.println("fee_opt_amt="+fee_opt_amt+"<br>");
	
	//20110615 ???????????? ???? 10,000km?? ???????? ?????? ?????? ???????????? ?????????? ????
	if(AddUtil.parseInt(ej_bean.getReg_dt()) >= 20110615){
		em_bean.setJg_c_81(ej_bean.getJg_14()*100);
		em_bean.setJg_c_82(ej_bean.getJg_14()*100);
	}
	
	int accid_serv_amt1 = 0;
	int accid_serv_amt2 = 0;
	
		//20150512 ??????/???? ?????? ?????????? ????		
		if(AddUtil.parseInt(rent_dt) >= 20150512){		
			//????????
			Vector vt = shDb.getAccidServAmts(car_mng_id, rent_dt);
			int vt_size = vt.size();
			for(int j = 0 ; j < vt_size ; j++){
				Hashtable am_ht = (Hashtable)vt.elementAt(j);
				if(j==0) accid_serv_amt1 = String.valueOf(am_ht.get("TOT_AMT"))==null?0 :AddUtil.parseDigit(String.valueOf(am_ht.get("TOT_AMT")));
				if(j==1) accid_serv_amt2 = String.valueOf(am_ht.get("TOT_AMT"))==null?0 :AddUtil.parseDigit(String.valueOf(am_ht.get("TOT_AMT")));					
			}								
		}	

	//20151013 ???? ???? ????????		
	String jg_opt_st = String.valueOf(ht.get("JG_OPT_ST"));
	String jg_col_st = String.valueOf(ht.get("JG_COL_ST"));
	
	if(jg_opt_st.equals("") && jg_col_st.equals("") && !rent_mng_id.equals("") && !rent_l_cd.equals("")){
		//????????????
		ContCarBean car 	= a_db.getContCarNew(rent_mng_id, rent_l_cd);
			jg_opt_st = car.getJg_opt_st();
			jg_col_st = car.getJg_col_st();
	}
	
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
	

	
	out.println(" jg_opt_st="+jg_opt_st);	
	out.println(" s="+s);	
	
	String duty_free_opt = String.valueOf(ht.get("DUTY_FREE_OPT"));
	

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
	//??????????
	function getCutNumber(num, place){
		var returnNum;
		var st="1";
		return Math.floor( num * Math.pow(10,parseInt(place,10)) ) / Math.pow(10,parseInt(place,10));
	}
	
	function replaceFloatRound(per){
		return Math.round(per*1000)/10;	
	}
	
	//???? ??????
	function getRentTime(gubun, d1, d2) {
		var fm = document.form1;	
		m  = 30*24*60*60*1000;		//??
		l  = 24*60*60*1000;  		// 1??
		lh = 60*60*1000;  			// 1????
		lm = 60*1000;  	 	 		// 1??
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
		

		
		//????????=========================================================================================
				
		fm.cd[i].value = "";				fm.nm[i].value = "---------------------------"; 				fm.value[i].value = '???????? ------------------';			i++;				
						
		var init_reg_dt = <%=init_reg_dt%>;
		fm.cd[i].value = "init_reg_dt";		fm.nm[i].value = "??????????";									fm.value[i].value = init_reg_dt;			i++;		

		var rent_dt = <%=rent_dt%>;
		fm.cd[i].value = "rent_dt";			fm.nm[i].value = "??????????";									fm.value[i].value = rent_dt;				i++;		

		var today_dist = <%=AddUtil.replace(today_dist,",","")%>;
		fm.cd[i].value = "today_dist";		fm.nm[i].value = "????????????";								fm.value[i].value = today_dist;				i++;		
		
		var jg_code = <%=ej_bean.getSh_code()%>;
		fm.cd[i].value = "jg_code";			fm.nm[i].value = "????????";									fm.value[i].value = jg_code;				i++;		
		
		var car_amt = <%=ht.get("CAR_AMT")%>;
		fm.cd[i].value = "car_amt";			fm.nm[i].value = "????????";									fm.value[i].value = car_amt;				i++;		
		
		var opt_amt = <%=ht.get("OPT_AMT")%>;
		fm.cd[i].value = "opt_amt";			fm.nm[i].value = "????????????";								fm.value[i].value = opt_amt;				i++;		
		
		var col_amt = <%=ht.get("COL_AMT")%>;
		fm.cd[i].value = "col_amt";			fm.nm[i].value = "????????????";								fm.value[i].value = col_amt;				i++;		
		
		//20171016
		var tax_dc_amt = <%=ht.get("TAX_DC_AMT")%>;
		fm.cd[i].value = "tax_dc_amt";			fm.nm[i].value = "????????????";						fm.value[i].value = tax_dc_amt;			i++;		

		var a_b = <%=a_b%>;
		fm.cd[i].value = "a_b";				fm.nm[i].value = "??????????"	;								fm.value[i].value = a_b;				i++;		
		
		var rent_st = <%=rent_st%>;
		fm.cd[i].value = "rent_st";			fm.nm[i].value = "????????"	;									fm.value[i].value = rent_st;				i++;		
		
		
		fm.cd[i].value = "";				fm.nm[i].value = "---------------------------"; fm.value[i].value = '?????????? ?????????? ???????? -------------';			i++;				

		var o_a = <%=ej_bean.getJg_1()%>;
		fm.cd[i].value = "o_a";				fm.nm[i].value = "?????? ???? 24???? ??????";					fm.value[i].value = o_a;					i++;		

		var g_1 = <%=em_bean.getJg_c_1()%>/100;
		if(<%=rent_dt%> >= 20140912){
		    g_1 = g_1*(1-<%=ej_bean.getJg_g_2()%>*0.35);
		}
		if(<%=rent_dt%> >= 20171018){
		    g_1 = g_1*(1-<%=ej_bean.getJg_g_9()%>+<%=ej_bean.getJg_g_10()%>);
		}
		fm.cd[i].value = "g_1";				fm.nm[i].value = "0???? ???? ????";								fm.value[i].value = g_1;					i++;		

		var o_2 = <%=ej_bean.getJg_2()%>;
		fm.cd[i].value = "o_2";				fm.nm[i].value = "???????? LPG ????";							fm.value[i].value = o_2;					i++;		

		var o_3 = <%=ej_bean.getJg_3()%>;
		fm.cd[i].value = "o_3";				fm.nm[i].value = "???? ????????";								fm.value[i].value = o_3;					i++;		

		var o_b = g_1*(1+o_2*o_3)+(o_a-0.6*(1+o_2*o_3))*0.5;
		if(<%=rent_dt%> >= 20171018){
		    o_b = g_1*(1+o_2*o_3)+(o_a-0.6*(1-<%=ej_bean.getJg_g_9()%>+<%=ej_bean.getJg_g_10()%>)*(1+o_2*o_3))*0.5;
		}
		if(<%=rent_dt%> >= 20190419){
		    o_b = g_1+(o_a-0.6*(1-<%=ej_bean.getJg_g_9()%>+<%=ej_bean.getJg_g_10()%>))*0.5;
		}
		o_b = getCutNumber(o_b,9);
		fm.cd[i].value = "o_b";				fm.nm[i].value = "?????? ???? 0???? ??????";					fm.value[i].value = o_b;					i++;		

		var o_4 = <%=ej_bean.getJg_4()%>;
		fm.cd[i].value = "o_4";				fm.nm[i].value = "?????????? ????????(????0.4)";				fm.value[i].value = o_4;					i++;		
		
		var o_d = o_a*o_4;
		o_d = getCutNumber(o_d,9);
		fm.cd[i].value = "o_d";				fm.nm[i].value = "?????? ???? ??????";							fm.value[i].value = o_d;					i++;		

		var fw_917 = getRentTime('l', '<%=init_reg_dt%>', '<%=rent_dt%>')/365*12;
		fm.cd[i].value = "fw_917";			fm.nm[i].value = "????????(????)";								fm.value[i].value = fw_917;					i++;		
				
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
		fm.cd[i].value = "gb_917";			fm.nm[i].value = "??????????????????(????)";					fm.value[i].value = gb_917;					i++;		
		fm.cd[i].value = "a_b";				fm.nm[i].value = "a_b";							fm.value[i].value = a_b;					i++;		
		fm.cd[i].value = "cyber_a_b";			fm.nm[i].value = "cyber_a_b";						fm.value[i].value = cyber_a_b;					i++;		
		
		var o_e = o_d+Math.pow((o_a-o_d)/(o_b-o_d),fw_917/24)*(o_b-o_d);
		o_e = getCutNumber(o_e,9);
		fm.cd[i].value = "o_e";				fm.nm[i].value = "?????? ???? ???? ??????????";					fm.value[i].value = o_e;					i++;		

		var o_e_r = o_d+Math.pow((o_a-o_d)/(o_b-o_d),gb_917/24)*(o_b-o_d);
		o_e_r = getCutNumber(o_e_r,9);
		fm.cd[i].value = "o_e_r";			fm.nm[i].value = "?????? ???? ???? ??????????(r)";				fm.value[i].value = o_e_r;					i++;		

		var g_3 = <%=em_bean.getJg_c_3()%>/100;
		if(<%=rent_dt%> >= 20110101){
			g_3 = <%=em_bean.getJg_c_32()%>/100;
		}
		fm.cd[i].value = "g_3";				fm.nm[i].value = "????????????????1???? ????????????";			fm.value[i].value = g_3;					i++;		

		var fw_920 = getRentTime('l', '<%=init_reg_dt.substring(0,4)%>0101', '<%=init_reg_dt%>')+1;
		fm.cd[i].value = "fw_920";			fm.nm[i].value = "??????????-??????????";						fm.value[i].value = fw_920;					i++;		
		
		var o_p = g_3*(fw_920/365-0.5);
		fm.cd[i].value = "o_p";				fm.nm[i].value = "?????????????????? ?????? ??????";			fm.value[i].value = o_p;					i++;		

		var o_6 = <%=ej_bean.getJg_6()%>;
		fm.cd[i].value = "o_6";				fm.nm[i].value = "???????? ?????? ????";						fm.value[i].value = o_6;					i++;		

		var o_f = o_e*o_6+o_p;
		if(<%=rent_dt%> >= 20150217){
			o_f = o_e*o_6*(1+o_p);
		}
		o_f = getCutNumber(o_f,9);
		fm.cd[i].value = "o_f";				fm.nm[i].value = "?????? ???????? ??????";						fm.value[i].value = o_f;					i++;		

		var o_f_r = o_e_r*o_6+o_p;
		if(<%=rent_dt%> >= 20150217){
			o_f_r = o_e_r*o_6*(1+o_p);
		}
		o_f_r = getCutNumber(o_f_r,9);
		fm.cd[i].value = "o_f_r";			fm.nm[i].value = "?????? ???????? ??????(r)";					fm.value[i].value = o_f_r;					i++;		

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
		//?????????? ????
		if(<%=ej_bean.getReg_dt()%> >= 20120911){
			if(init_reg_dt >= 20120910 && init_reg_dt < 20130101)   g_k1 = <%=ej_bean.getJg_st15()%>;
			if(rent_dt >= 20120910 && rent_dt < 20130101)    				g_k2 = <%=ej_bean.getJg_st15()%>;
		}				
		

		var g_k3 = (1+g_k2)/(1+g_k1);
		if('<%=duty_free_opt%>'=='1'){
			g_k3 = (1+g_k2);
		}
		fm.cd[i].value = "g_k3";				fm.nm[i].value = "???????? ?????? ???????? ???? ????";		fm.value[i].value = g_k3;					i++;		
		
		//20171016
		var o_q1 = <%=ht.get("CAR_AMT")%>*g_k3/10000-(<%=ht.get("TAX_DC_AMT")%>/10000);
		fm.cd[i].value = "o_q1";				fm.nm[i].value = "???? ????????-????(????)";				fm.value[i].value = o_q1;					i++;		

		var o_q2 = <%=ht.get("OPT_AMT")%>*g_k3/10000;
		fm.cd[i].value = "o_q2";				fm.nm[i].value = "???? ????????-????(????)";				fm.value[i].value = o_q2;					i++;		

		var o_q3 = 0;
		if(<%=ht.get("COL_AMT")%>>0)
		o_q3 = <%=ht.get("COL_AMT")%>*g_k3/10000;
		fm.cd[i].value = "o_q3";				fm.nm[i].value = "???? ????????-????(????)";				fm.value[i].value = o_q3;					i++;		

		var o_q4 = o_q1+o_q2+o_q3;
		fm.cd[i].value = "o_q4";				fm.nm[i].value = "???? ????????-????(????)";				fm.value[i].value = o_q4;					i++;		
		
		var o_7 = <%=ej_bean.getJg_7()%>;
		fm.cd[i].value = "o_7";					fm.nm[i].value = "????????????";							fm.value[i].value = o_7;					i++;		

		var fw_930 = o_q1-o_7;
		fm.cd[i].value = "fw_930";				fm.nm[i].value = "????????????";							fm.value[i].value = fw_930;					i++;		

		var o_8 = 1;
		if(fw_930>0) o_8 = <%=ej_bean.getJg_8()%>;		
		fm.cd[i].value = "o_8";					fm.nm[i].value = "???????????? ?????? ????";				fm.value[i].value = o_8;					i++;		

		var fw_932 = o_q2+o_q3;
		fm.cd[i].value = "fw_932";				fm.nm[i].value = "????????????";							fm.value[i].value = fw_932;					i++;		

		var o_9 = 1;
		if(fw_932>0) o_9 = <%=ej_bean.getJg_9()%>;
		fm.cd[i].value = "o_9";					fm.nm[i].value = "???????????? ?????? ????";				fm.value[i].value = o_9;					i++;		

		var o_g1 = o_7*o_f+(fw_930*o_f*o_8)+(fw_932*o_f*o_9);
		o_g1 = getCutNumber(o_g1,9);
		fm.cd[i].value = "o_g1";				fm.nm[i].value = "???????? ???????? g1??";					fm.value[i].value = o_g1;					i++;		
		
		var o_g1_r = o_7*o_f_r+(fw_930*o_f_r*o_8)+(fw_932*o_f_r*o_9);
		o_g1_r = getCutNumber(o_g1_r,9);
		fm.cd[i].value = "o_g1_r";				fm.nm[i].value = "???????? ???????? g1??(r)";				fm.value[i].value = o_g1_r;					i++;		
		
		var fw_935 = o_q4-o_7;
		fm.cd[i].value = "fw_935";				fm.nm[i].value = "???????????? ????????????";				fm.value[i].value = fw_935;					i++;		

		var o_10 = 1;
		if(fw_935>0) o_10 = <%=ej_bean.getJg_10()%>;
		fm.cd[i].value = "o_10";				fm.nm[i].value = "???????????? ???????????? ?????? ????";	fm.value[i].value = o_10;					i++;		

		var o_g2 = o_7*o_f+(fw_935*o_f*o_10);
		o_g2 = getCutNumber(o_g2,9);
		fm.cd[i].value = "o_g2";				fm.nm[i].value = "???????? ???????? g2??";					fm.value[i].value = o_g2;					i++;		
		
		var o_g2_r = o_7*o_f_r+(fw_935*o_f_r*o_10);
		o_g2_r = getCutNumber(o_g2_r,9);
		fm.cd[i].value = "o_g2_r";				fm.nm[i].value = "???????? ???????? g2??(r)";				fm.value[i].value = o_g2_r;					i++;		
		
		var o_11 = <%=ej_bean.getJg_11()%>;
		fm.cd[i].value = "o_11";				fm.nm[i].value = "????????????????";						fm.value[i].value = o_11;					i++;		

		var o_g = 0;
		if(o_11 == 1) 	o_g = o_g1;
		else			o_g = o_g2;
		fm.cd[i].value = "o_g";					fm.nm[i].value = "?????? ????????(???????? ??????)";		fm.value[i].value = o_g;					i++;		
		
		var o_g_r = 0;
		if(o_11 == 1) 	o_g_r = o_g1_r;
		else		o_g_r = o_g2_r;
		fm.cd[i].value = "o_g_r";				fm.nm[i].value = "?????? ????????(???????? ??????)(r)";		fm.value[i].value = o_g_r;					i++;		
		
		var g_7 = 0;
		if(<%=ej_bean.getJg_b()%>==1) 		g_7 = <%=em_bean.getJg_c_72()%>/36*fw_917;	//????
		else if(<%=ej_bean.getJg_b()%>==2) 	g_7 = <%=em_bean.getJg_c_73()%>/36*fw_917;	//LPG
		else					g_7 = <%=em_bean.getJg_c_71()%>/36*fw_917;	//??????
		g_7 = Math.round(g_7);
		fm.cd[i].value = "g_7";					fm.nm[i].value = "???? ???? ????????????(km)";				fm.value[i].value = g_7;					i++;		
		
		var g_7_r = 0;
		if(<%=ej_bean.getJg_b()%>==1) 		g_7_r = <%=em_bean.getJg_c_72()%>/36*gb_917;
		else if(<%=ej_bean.getJg_b()%>==2) 	g_7_r = <%=em_bean.getJg_c_73()%>/36*gb_917;
		else					g_7_r = <%=em_bean.getJg_c_71()%>/36*gb_917;
		fm.cd[i].value = "g_7_r";				fm.nm[i].value = "???? ???? ????????????(km)(r)";			fm.value[i].value = g_7_r;					i++;		
		
		var fw_941 = <%=AddUtil.replace(today_dist,",","")%>;
		if(fw_941 == 0){
			fw_941 = Math.round(g_7);
			fm.value[3].value = fw_941;		
		}
		fm.cd[i].value = "fw_941";				fm.nm[i].value = "??????????(km)";							fm.value[i].value = fw_941;					i++;		
		
		
		var gb_942 = 0;
		if('<%=rent_st%>'=='2'){
			gb_942 = (fw_941/fw_917*cyber_a_b);
		}else{
			if(<%=ej_bean.getJg_b()%>==1)			gb_942 = <%=em_bean.getJg_c_72()%>/36*cyber_a_b;				//????1
			else if(<%=ej_bean.getJg_b()%>==2)		gb_942 = <%=em_bean.getJg_c_73()%>/36*cyber_a_b;				//LPG2
			else									gb_942 = <%=em_bean.getJg_c_71()%>/36*cyber_a_b;				//??????0			
			
			if('<%=lpg_yn%>'=='Y') 				gb_942 = gb_942*(<%=em_bean.getJg_c_73()%>/<%=em_bean.getJg_c_71()%>);
		}		
		gb_942 = Math.round(gb_942);
		fm.cd[i].value = "gb_942";				fm.nm[i].value = "????????????????(km)";					fm.value[i].value = gb_942;					i++;		
				
		var o_r = 0;
		if(<%=ej_bean.getJg_b()%>==1) 		o_r = (fw_941-g_7)/10000*<%=em_bean.getJg_c_82()%>/100;
		else															o_r = (fw_941-g_7)/10000*<%=em_bean.getJg_c_81()%>/100;
		if(<%=rent_dt%> >= 20171018){
			if(<%=ej_bean.getJg_b()%>==1) 	o_r = Math.pow(1+(<%=em_bean.getJg_c_82()%>/100),(fw_941-g_7)/10000);
			else														o_r = Math.pow(1+(<%=em_bean.getJg_c_81()%>/100),(fw_941-g_7)/10000);
		}	
		fm.cd[i].value = "o_r";					fm.nm[i].value = "?????????? ???? ???????? ??????";			fm.value[i].value = o_r;					i++;		
		
		var o_r_r = 0;
		if(<%=ej_bean.getJg_b()%>==1) 		o_r_r = (fw_941+gb_942-g_7_r)/10000*<%=em_bean.getJg_c_82()%>/100;
		else															o_r_r = (fw_941+gb_942-g_7_r)/10000*<%=em_bean.getJg_c_81()%>/100;
		if(<%=rent_dt%> >= 20171018){
			if(<%=ej_bean.getJg_b()%>==1) 	o_r_r = Math.pow(1+(<%=em_bean.getJg_c_82()%>/100),(fw_941+gb_942-g_7_r)/10000);
			else														o_r_r = Math.pow(1+(<%=em_bean.getJg_c_81()%>/100),(fw_941+gb_942-g_7_r)/10000);
		}	
		fm.cd[i].value = "o_r_r";				fm.nm[i].value = "?????????? ???? ???????? ??????";			fm.value[i].value = o_r_r;					i++;		
		
		
		var g_9 = <%=em_bean.getJg_c_9()%>*cyber_a_b/24/100;
		fm.cd[i].value = "g_9";					fm.nm[i].value = "?????????? ???? ???????? ??????";			fm.value[i].value = g_9;					i++;				
		
		var g_10 = o_2*(<%=ej_bean.getJg_5_1()%>*100)*cyber_a_b/24/100;
		fm.cd[i].value = "g_10";				fm.nm[i].value = "LPG???? ?????? ???? ??????";				fm.value[i].value = g_10;					i++;				
				
		var a_m_1 = <%=em_bean.getSh_a_m_1()%>/100;
		if('<%=ej_bean.getJg_g_45()%>' != '' && '<%=ej_bean.getJg_g_45()%>' != '0.0'){
			a_m_1 = a_m_1*<%=ej_bean.getJg_g_45()%>;
		}
		fm.cd[i].value = "a_m_1";				fm.nm[i].value = "???? ?????? ????????";					fm.value[i].value = a_m_1;					i++;						
			
		var a_m_2 = <%=em_bean.getSh_a_m_2()%>/100;
		fm.cd[i].value = "a_m_2";				fm.nm[i].value = "36?????? ???? ?????? ???????? ??????";	fm.value[i].value = a_m_2;					i++;
		
		var a_m_3 = 1-(1-a_m_1)*a_m_2;
		fm.cd[i].value = "a_m_3";				fm.nm[i].value = "36?????? ?????? ????????";				fm.value[i].value = a_m_3;					i++;
		
		var a_m_4 = 0;
		if(a_b>36)	a_m_4 = a_m_1+((a_m_3-a_m_1)/36)*36;
		else		a_m_4 = a_m_1+((a_m_3-a_m_1)/36)*a_b;
		fm.cd[i].value = "a_m_4";				fm.nm[i].value = "???????????? ?????? ????????";			fm.value[i].value = a_m_4;					i++;
		
		var o_s_r = Math.round(o_g_r*(1+o_r_r));
		if(<%=rent_dt%> >= 20171018){
			o_s_r = Math.round(o_g_r*o_r_r);
		}
		fm.cd[i].value = "o_s_r";				fm.nm[i].value = "?????? ????????(????????????,??????)";	fm.value[i].value = o_s_r;					i++;				
		
		var o_s = Math.round(o_g*(1+o_r)*a_m_1);
		if(<%=rent_dt%> >= 20171018){
			o_s = Math.round(o_g*o_r*a_m_1);
		}
		fm.cd[i].value = "o_s";					fm.nm[i].value = "?????? ?????? ??????????(????????????)";	fm.value[i].value = o_s;					i++;	
		
		var o_t = Math.round(o_s_r*(1-g_9-g_10)*a_m_4);
		fm.cd[i].value = "o_t";					fm.nm[i].value = "?????? ???????? ?????? ??????????(????)";	fm.value[i].value = o_t;					i++;		

		//20151013 ???? ?? ???? ???? ????
		if(<%=rent_dt%> >= 20151013){
			var jg_opt_aw = new Array();
			var jg_opt_ax = new Array();
			var jg_opt_ay = new Array();
			var jg_opt_az = new Array();
			var t_jg_opt_az = new Array();
			
			t_jg_opt_az[0] = 0;
			t_jg_opt_az[1] = 0;

			<%for(int j=0 ; j < s ; j++){
				//???????? ???????? ????????
				EstiJgVarBean ejo_bean = e_db.getEstiJgOptVarCase(ej_bean.getSh_code(), ej_bean.getSeq(), app_value[j]);
			%>
			
				jg_opt_aw[0] = 0;
				jg_opt_aw[1] = 0;
			
				jg_opt_ax[0] = 0;
				jg_opt_ax[1] = 0;

				jg_opt_ay[0] = 0;
				jg_opt_ay[1] = 0;
			
				jg_opt_az[0] = 0;
				jg_opt_az[1] = 0;

								
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

				fm.cd[i].value = "jg_opt_aw[0]";	fm.nm[i].value = "???? ?? ???? ???????? - ???????? ??????????";		fm.value[i].value = jg_opt_aw[0];		i++;			
				fm.cd[i].value = "jg_opt_aw[1]";	fm.nm[i].value = "???? ?? ???? ???????? - ???????? ??????????";		fm.value[i].value = jg_opt_aw[1];		i++;			
				
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

				fm.cd[i].value = "jg_opt_ax[0]";	fm.nm[i].value = "???? ?? ???? ???????? - ???????? ????????";		fm.value[i].value = jg_opt_ax[0];		i++;			
				fm.cd[i].value = "jg_opt_ax[1]";	fm.nm[i].value = "???? ?? ???? ???????? - ???????? ????????";		fm.value[i].value = jg_opt_ax[1];		i++;			
								
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

				fm.cd[i].value = "jg_opt_ay[0]";	fm.nm[i].value = "???? ?? ???? ???????? - ???????? ??????????";		fm.value[i].value = jg_opt_ay[0];		i++;			
				fm.cd[i].value = "jg_opt_ay[1]";	fm.nm[i].value = "???? ?? ???? ???????? - ???????? ??????????";		fm.value[i].value = jg_opt_ay[1];		i++;			
					
				jg_opt_az[0] = jg_opt_aw[0]+jg_opt_ay[0];
				jg_opt_az[1] = jg_opt_aw[1]+jg_opt_ay[1];
				
				fm.cd[i].value = "jg_opt_az[0]";	fm.nm[i].value = "???? ?? ???? ???????? - ???????? ??????";		fm.value[i].value = jg_opt_az[0];		i++;			
				fm.cd[i].value = "jg_opt_az[1]";	fm.nm[i].value = "???? ?? ???? ???????? - ???????? ??????";		fm.value[i].value = jg_opt_az[1];		i++;			
				
							
				t_jg_opt_az[0] = t_jg_opt_az[0] + jg_opt_az[0];
				t_jg_opt_az[1] = t_jg_opt_az[1] + jg_opt_az[1];
			
			<%}%>
			
			o_s = o_s + t_jg_opt_az[0];
			o_t = o_t + t_jg_opt_az[1];
			
			
			fm.cd[i].value = "t_jg_opt_az[0]";			fm.nm[i].value = "???? ?? ???? ???????? - ???????? ????????";	fm.value[i].value = t_jg_opt_az[0];					i++;	
			fm.cd[i].value = "t_jg_opt_az[1]";			fm.nm[i].value = "???? ?? ???? ???????? - ???????? ????????";	fm.value[i].value = t_jg_opt_az[1];					i++;		

			fm.cd[i].value = "o_s";					fm.nm[i].value = "?????? ?????? ??????????(????????????)";	fm.value[i].value = o_s;					i++;	
			fm.cd[i].value = "o_t";					fm.nm[i].value = "?????? ???????? ?????? ??????????(????)";	fm.value[i].value = o_t;					i++;		
		}
		
		//20180601 ????????, ????????????????
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
		
		//???????? ???? ????
		if(<%=rent_dt%> >= 20180601 && '<%=ej_bean.getJg_g_18()%>'=='1'){
			//?????? ???????? ???? ???? ????
			ex_n_a = 9;
			if(init_reg_dt >= '<%=ej_bean.getJg_g_26()%>' && <%=accid_serv_amt1%> < (car_amt+opt_amt+col_amt-tax_dc_amt)*<%=ej_bean.getJg_g_31()%>){
				ex_n_a = 1;
			}
			//?????? ???????? ???? ???? ??????
			ex_e_a = <%=rs_db.addDay(String.valueOf(AddUtil.parseInt(init_reg_dt.substring(0,4))+ej_bean.getJg_g_19())+"0101", ej_bean.getJg_g_27())%>;
			//???? ???????????? ?????? ???????? ?????????????????? ?????? ??.	
			if(ex_n_a == 1 && rent_st == 2){
				if(rent_dt <= ex_e_a){
					ex_n_a = 1;
				}else{
					ex_n_a = 9;
				}
			}
			//?????? ???? ??????????
			ex_e_b = <%=rs_db.addMonth(rent_dt, AddUtil.parseInt(a_b))%>;
			//?????? ?????? ???? ??????????
			ex_e_c = ex_e_b;
			if(<%=a_b%> < 12){
				ex_e_c = <%=rs_db.addMonth(rent_dt, 12)%>;
			}
			//???????? ???????? ???? ???? ????
			ex_e_d = 9;
			if(ex_e_b < ex_e_a && <%=accid_serv_amt1%> < (car_amt+opt_amt+col_amt-tax_dc_amt)*<%=ej_bean.getJg_g_31()%>){
				ex_e_d = 1;
			}
			
			//???????? ???????? ?????? ???? 40??0816(038126)
			if('<%=car_mng_id%>' == '038126'){
				ex_n_a = 9;
				ex_e_d = 9;
			}	

			
			//?????? ???????? ????
			if(ex_n_a == 1){
				//?????? ???????? ??????
				ex_n_b = 1-(getRentTime('l', '<%=ej_bean.getJg_g_26()%>', '<%=init_reg_dt%>')/(365*<%=ej_bean.getJg_g_20()%>));
				if(ex_n_b < 0){
					ex_n_b = 0;
				}
				//?????? ????????
				ex_n_c = <%=ej_bean.getJg_g_28()%>*ex_n_b;
				//?????? ????????(???????? ??????)
				ex_n_d = o_g;
				//?????????? ???? ?????? ??????
				ex_n_e = o_r;
				//?????????? ???? ???????? ????????
				ex_n_f = ex_n_d*(ex_n_e-1);
				//???????? ???????? ????????
				ex_n_g = ex_n_f*<%=ej_bean.getJg_g_30()%>*ex_n_b;
				//?????? ????????+???????? ???????? ????
				ex_n_h = ex_n_c+ex_n_g;
				//???????? ?????? ???????? ????
				if(rent_st > 1 && '<%=fee.getOpt_chk()%>'=='1'){
					if('<%=base.getCar_gu()%>'=='1'){
						ex_n_h = ex_n_h+<%=ej_bean.getJg_g_32()%>;
					}else{
						ex_n_h = ex_n_h+<%=ej_bean.getJg_g_33()%>;
					}
				}
				o_s = o_s + ex_n_h;

			}
			//???????? ???????? ????
			if(ex_e_d == 1){
				//?????? ???????? ???????? ??????
				var ex_e_c2 = ex_e_c.toString().substr(0, 4);
				ex_e_c2 = ex_e_c2-<%=ej_bean.getJg_g_19()%>;
				ex_e_c2 = ex_e_c2+'0101';
				ex_e_e = 1-(getRentTime('l', ex_e_c2, '<%=init_reg_dt%>')/(365*<%=ej_bean.getJg_g_20()%>));
				//?????? ???????? ???????? ?????? ??????
				ex_e_f = ex_e_e;
				if(ex_e_f<0){
					ex_e_f = 0;
				}else if (ex_e_f>1){
					ex_e_f = 1;
				}
				//?????? ???????? ????????
				ex_e_g = <%=ej_bean.getJg_g_29()%>*ex_e_f;
				//???????? 12???????? ???????? ??????
				if(ex_n_c > 0){
					if(<%=a_b%> < 12){
						ex_e_h = Math.pow(ex_e_g/ex_n_c,<%=a_b%>/12);
					}else{
						ex_e_h = ex_e_g/ex_n_c;
					}
				}
				//???? ?????? ???????? ????????
				if(<%=a_b%> < 12){
					ex_e_i = ex_n_c*ex_e_h;
				}else{
					ex_e_i = ex_e_g;
				}
				//?????? ???????? ????????(???????? ??????)
				ex_e_j = o_g_r;
				//?????????? ???? ???????? ??????
				ex_e_k = o_r_r;
				//?????????? ???? ???????? ???? ????
				ex_e_l = ex_e_j*(ex_e_k-1);
				//???????? ???????? ????????(????????????)
				ex_e_m = ex_e_l*<%=ej_bean.getJg_g_30()%>*ex_e_f;
				if(<%=rent_dt%> >= 20220617){
					ex_e_m = ex_e_m*0.6;
				}
				//???????? 12???????? ???????? ???????? ??????
				ex_e_n = ex_n_b+(ex_e_f-ex_n_b)/12*<%=a_b%>;
				//???? ???????? ???????? ????????
				if(<%=a_b%> < 12){
					ex_e_o = ex_e_l*<%=ej_bean.getJg_g_30()%>*ex_e_n;
				}else{
					ex_e_o = ex_e_m;
				}
				//???? ?????? ???????? ????????+???????????? ???????? ???????? ????
				if(ex_e_d == 1){
					ex_e_p = ex_e_i+ex_e_o; 
				}
				//???????? ?????? ???????? ????
				if(rent_st > 1 && '<%=fee.getOpt_chk()%>'=='1'){
					if('<%=base.getCar_gu()%>'=='1'){
						ex_e_p = ex_e_p+<%=ej_bean.getJg_g_32()%>;
					}else{
						ex_e_p = ex_e_p+<%=ej_bean.getJg_g_33()%>;
					}
				}
				//???????????? ?????? ???? ?????? ???????? ???????? ??????
				if(ex_e_d == 1){
					ex_e_q = <%=ej_bean.getJg_g_30()%>+ex_e_f; 
					if(<%=rent_dt%> >= 20220617){
						ex_e_q = ex_e_q*0.6;
					}
				}
				//???????? ???????????? ?????? ???? ?????? ???????? ???????? ?????? ????????
				if(rent_st > 1){
					ex_e_q = 0;
				}
				o_t = o_t + ex_e_p;
			}
		}
		
		
		fm.cd[i].value = "ex_n_a";			fm.nm[i].value = "?????? ???????? ???? ???? ????";				fm.value[i].value = ex_n_a;				i++;		
		fm.cd[i].value = "ex_e_a";			fm.nm[i].value = "?????? ???????? ???? ???? ??????";			fm.value[i].value = ex_e_a;				i++;		
		fm.cd[i].value = "ex_e_b";			fm.nm[i].value = "?????? ???? ??????????";						fm.value[i].value = ex_e_b;				i++;		
		fm.cd[i].value = "ex_e_c";			fm.nm[i].value = "?????? ?????? ???? ??????????";				fm.value[i].value = ex_e_c;				i++;		
		fm.cd[i].value = "ex_e_d";			fm.nm[i].value = "???????? ???????? ???? ???? ????";			fm.value[i].value = ex_e_d;				i++;		
		fm.cd[i].value = "ex_n_b";			fm.nm[i].value = "?????? ???????? ??????";						fm.value[i].value = ex_n_b;				i++;		
		fm.cd[i].value = "ex_n_c";			fm.nm[i].value = "?????? ????????";									fm.value[i].value = ex_n_c;				i++;		
		fm.cd[i].value = "ex_n_d";			fm.nm[i].value = "?????? ????????(???????? ??????)";			fm.value[i].value = ex_n_d;				i++;		
		fm.cd[i].value = "ex_n_e";			fm.nm[i].value = "?????????? ???? ?????? ??????";				fm.value[i].value = ex_n_e;				i++;		
		fm.cd[i].value = "ex_n_f";			fm.nm[i].value = "?????????? ???? ???????? ????????";			fm.value[i].value = ex_n_f;				i++;		
		fm.cd[i].value = "ex_n_g";			fm.nm[i].value = "???????? ???????? ????????";					fm.value[i].value = ex_n_g;				i++;		
		fm.cd[i].value = "ex_n_h";			fm.nm[i].value = "?????? ????????+???????? ???????? ????";	fm.value[i].value = ex_n_h;				i++;		
		fm.cd[i].value = "ex_e_e";			fm.nm[i].value = "?????? ???????? ???????? ??????";				fm.value[i].value = ex_e_e;				i++;		
		fm.cd[i].value = "ex_e_f";			fm.nm[i].value = "?????? ???????? ???????? ?????? ??????";	fm.value[i].value = ex_e_f;				i++;		
		fm.cd[i].value = "ex_e_g";			fm.nm[i].value = "?????? ???????? ????????";						fm.value[i].value = ex_e_g;				i++;		
		fm.cd[i].value = "ex_e_h";			fm.nm[i].value = "???????? 12???????? ???????? ??????";		fm.value[i].value = ex_e_h;				i++;		
		fm.cd[i].value = "ex_e_i";			fm.nm[i].value = "???? ?????? ???????? ????????";				fm.value[i].value = ex_e_i;				i++;		
		fm.cd[i].value = "ex_e_j";			fm.nm[i].value = "?????? ???????? ????????(???????? ??????)";	fm.value[i].value = ex_e_j;				i++;		
		fm.cd[i].value = "ex_e_k";			fm.nm[i].value = "?????????? ???? ???????? ??????";				fm.value[i].value = ex_e_k;				i++;		
		fm.cd[i].value = "ex_e_l";			fm.nm[i].value = "?????????? ???? ???????? ???? ????";		fm.value[i].value = ex_e_l;				i++;		
		fm.cd[i].value = "ex_e_m";			fm.nm[i].value = "???????? ???????? ????????(????????????)";	fm.value[i].value = ex_e_m;				i++;		
		fm.cd[i].value = "ex_e_n";			fm.nm[i].value = "???????? 12???????? ???????? ???????? ??????";	fm.value[i].value = ex_e_n;		i++;		
		fm.cd[i].value = "ex_e_o";			fm.nm[i].value = "???? ???????? ???????? ????????";				fm.value[i].value = ex_e_o;				i++;		
		fm.cd[i].value = "ex_e_p";			fm.nm[i].value = "???? ???????? ????????(????????????)";		fm.value[i].value = ex_e_p;				i++;		
		fm.cd[i].value = "ex_e_q";			fm.nm[i].value = "???????????? ?????? ???? ???? ???????? ???????? ??????";	fm.value[i].value = ex_e_q;	i++;		

		fm.cd[i].value = "o_s";					fm.nm[i].value = "?????? ?????? ??????????(????????????)";	fm.value[i].value = o_s;					i++;	
		
		//???????????? ???????? LPG???? 60???????? ?????? ????
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
		fm.cd[i].value = "o_s";					fm.nm[i].value = "?????? ?????? ??????????(????????????)-???????????? ???????? LPG???? 60???????? ?????? ????";	fm.value[i].value = o_s;					i++;	
		
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
		fm.cd[i].value = "o_u";					fm.nm[i].value = "?????? ???????? ???? ??????(????????????????)";fm.value[i].value = o_u;				i++;		
		
		var g_11 = <%=em_bean.getJg_c_11()%>*cyber_a_b/24/100;
		fm.cd[i].value = "g_11";				fm.nm[i].value = "?????? ?????????? ???? ?????? ??????";	fm.value[i].value = g_11;					i++;				
				
		var o_v = o_u*(1-g_11);
		fm.cd[i].value = "o_v";					fm.nm[i].value = "?????? ???????? ???? ??????(????????????????)";fm.value[i].value = o_v;				i++;		
		
		var sh_c_a = <%=em_bean.getSh_c_a()%>;
		fm.cd[i].value = "sh_c_a";				fm.nm[i].value = "?????????? ???? ???????? ???? ????";		fm.value[i].value = sh_c_a;					i++;		
		if(<%=rent_dt%> >= 20150512){
			sh_c_a = <%=ej_bean.getJg_g_5()%>*100;		
			fm.cd[i].value = "sh_c_a";			fm.nm[i].value = "???????????? ???? ????";			fm.value[i].value = sh_c_a;					i++;		
		}			
		
		
		var gb_954 = (sh_c_a/100-1);
		if(a_b>24)	gb_954 = gb_954/24*24;
		else		gb_954 = gb_954/24*a_b;	
		if(<%=rent_dt%> >= 20150610){
			if(a_b>36)	gb_954 = gb_954/36*24;
			else		gb_954 = gb_954/36*cyber_a_b;		
		}				
		gb_954 = 1+gb_954;
		fm.cd[i].value = "gb_954";				fm.nm[i].value = "sh_c_a ????????????????(36????????????)";	fm.value[i].value = gb_954;					i++;		
		
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
		fm.cd[i].value = "o_w";					fm.nm[i].value = "?????? ?? ???????? ???? ???? ??????(????)";fm.value[i].value = o_w;					i++;		
		
		var o_x = o_s*o_v;
		fm.cd[i].value = "o_x";					fm.nm[i].value = "?????? ?????????? ???? ???????? ?????? ????????";fm.value[i].value = o_x;				i++;		
			

		fm.cd[i].value = "";					fm.nm[i].value = "---------------------------"; fm.value[i].value = '???? --------------------------------------';			i++;				
		
		var sh_car_amt = 0;		
		if('<%=rent_st%>'=='1' || '<%=rent_st%>'=='4'){
								sh_car_amt = ten_th_rnd(Math.round(o_s*10000*sh_c_a/100));
		}else if('<%=rent_st%>'=='2'){
			if(<%=fee_opt_amt%>>0)			sh_car_amt = <%=fee_opt_amt%>;
			else                            	sh_car_amt = ten_th_rnd(Math.round(o_s*10000*sh_c_a/100));
		}else if('<%=rent_st%>'=='3'){
								sh_car_amt = <%=cust_sh_car_amt%>;
		}
		<%if(from_page.equals("/fms2/lc_rent/search_car_esti_s.jsp")){%>
		sh_car_amt = ten_th_rnd(Math.round(o_s*10000*sh_c_a/100));
		<%}%>
		
		//20220617 ?????? ???????? ???????????? ???????? ????
		if(<%=rent_dt%> >= 20220617 && ex_n_a == 1){
			
		}else{
			//20220217 ?????????? ???????? ?????? ????. 
			if((car_amt+opt_amt+col_amt) < sh_car_amt){
				sh_car_amt = (car_amt+opt_amt+col_amt);
			}
		}	
					
		fm.cd[i].value = "sh_car_amt";				fm.nm[i].value = "??????????????(??????????)";					fm.value[i].value = sh_car_amt;				i++;
				
		var dlv_car_amt = (car_amt+opt_amt+col_amt)-sh_car_amt;
		fm.cd[i].value = "dlv_car_amt";				fm.nm[i].value = "????????";							fm.value[i].value = dlv_car_amt;			i++;		
					
		var o_y = o_x*10000/sh_car_amt;
		fm.cd[i].value = "o_y";					fm.nm[i].value = "?????? ???? ???? ???? ??????(????)";		fm.value[i].value = o_y;					i++;		
		
		
		var accid_sik_a = 0;
		var accid_sik_b = 0;
		var accid_sik_c = 0; 
		var accid_sik_e = 0; 
		var accid_sik_f = 0; 
		var accid_sik_g = 0; 
		var accid_sik_h = 0; 
		var accid_sik_j = 0; 
		
		//20150512 ?????????? ????
		if(<%=rent_dt%> >= 20150512){
		
			fm.cd[i].value = "";				fm.nm[i].value = "---------------------------"; 		fm.value[i].value = '?????????? ????----------------------';			i++;						
		
		
			accid_sik_a = Math.pow((car_amt+opt_amt+col_amt)/(1+g_k1),<%=em_bean.getAccid_a()%>)*<%=em_bean.getAccid_b()%>;
			if(<%=rent_dt%> >= 20190801 && '<%=duty_free_opt%>'=='1'){
				accid_sik_a = Math.pow((car_amt+opt_amt+col_amt),<%=em_bean.getAccid_a()%>)*<%=em_bean.getAccid_b()%>;
			}
			//??????
                	if('<%=ej_bean.getJg_w()%>' == '1'){
                    		accid_sik_a = Math.round(accid_sik_a*<%=em_bean.getAccid_c()%>,-4);
                	}else{
                    		accid_sik_a = Math.round(accid_sik_a,-4);
                	}
                	fm.cd[i].value = "accid_sik_a";			fm.nm[i].value = "???????? ??????";				fm.value[i].value = accid_sik_a;		i++;		
                	
                	var accid_serv_amt1 = <%=accid_serv_amt1%>;
                	var accid_serv_amt2 = <%=accid_serv_amt2%>;
                	
                	//????????????
                	if('<%=accid_serv_zero%>' == 'Y'){
                		accid_serv_amt1 = 0;
                		accid_serv_amt2 = 0;
                	}
                	                	                	
			accid_sik_b = accid_serv_amt1+(accid_serv_amt2*<%=em_bean.getAccid_d()%>);			
			fm.cd[i].value = "accid_serv_amt1";		fm.nm[i].value = "1???? ??????????";				fm.value[i].value = accid_serv_amt1;		i++;		
			fm.cd[i].value = "accid_serv_amt2";		fm.nm[i].value = "2???? ??????????";				fm.value[i].value = accid_serv_amt2;		i++;					
			fm.cd[i].value = "accid_sik_b";			fm.nm[i].value = "???? ??????????";				fm.value[i].value = accid_sik_b;		i++;		
			
			
			accid_sik_c = 0;			
			if(accid_sik_b<accid_sik_a){
                    		accid_sik_c = Math.pow(accid_sik_b/accid_sik_a,<%=em_bean.getAccid_e()%>);
                	}else{
                    		accid_sik_c = Math.pow(accid_sik_b/accid_sik_a,<%=em_bean.getAccid_f()%>);
                	}
                	accid_sik_c = accid_sik_c*<%=em_bean.getAccid_g()%>;
                	fm.cd[i].value = "accid_sik_c";			fm.nm[i].value = "???????? ???? ??????";			fm.value[i].value = accid_sik_c;		i++;		
                
                
			accid_sik_e = fw_917;
			fm.cd[i].value = "accid_sik_e";			fm.nm[i].value = "????";					fm.value[i].value = accid_sik_e;		i++;		
			
			
			accid_sik_f = (accid_sik_e*<%=em_bean.getAccid_h()%>*<%=em_bean.getAccid_j()%>+fw_941/10000*<%=em_bean.getAccid_k()%>*<%=em_bean.getAccid_m()%>)*<%=em_bean.getAccid_n()%>;
			fm.cd[i].value = "accid_sik_f";			fm.nm[i].value = "????,???????????? ????????";			fm.value[i].value = accid_sik_f;		i++;		
			
			
			accid_sik_g = accid_sik_f*<%=ej_bean.getJg_g_4()%>;
			fm.cd[i].value = "accid_sik_g";			fm.nm[i].value = "???? ???????? ???????? ???? ???? ??????";	fm.value[i].value = accid_sik_g;		i++;		
			
			
			accid_sik_h = o_s/(1-accid_sik_g);
			fm.cd[i].value = "accid_sik_h";			fm.nm[i].value = "???????? ??????????";				fm.value[i].value = accid_sik_h;		i++;		
			
			
			accid_sik_j = Math.round(accid_sik_h*(1-accid_sik_c),0);
			//if('<%=car_mng_id%>' == '040194' && <%=rent_dt%> >= 20190801 && <%=rent_dt%> <= 20190831){
			//	accid_sik_j = accid_sik_j+200;
			//} --> ?????????? ?????????? ?????? ???????????? ????????.
			fm.cd[i].value = "accid_sik_j";			fm.nm[i].value = "?? ??????????";				fm.value[i].value = accid_sik_j;		i++;		
			
			
			sh_car_amt = 0;		
			if('<%=rent_st%>'=='1' || '<%=rent_st%>'=='4'){
									sh_car_amt = ten_th_rnd(Math.round(accid_sik_j*10000*sh_c_a/100));
			}else if('<%=rent_st%>'=='2'){
				if(<%=fee_opt_amt%>>0)			sh_car_amt = <%=fee_opt_amt%>;
				else                            	sh_car_amt = ten_th_rnd(Math.round(accid_sik_j*10000*sh_c_a/100));
			}else if('<%=rent_st%>'=='3'){
									sh_car_amt = <%=cust_sh_car_amt%>;
			}
			
			<%if(from_page.equals("/fms2/lc_rent/search_car_esti_s.jsp")){%>
			sh_car_amt = ten_th_rnd(Math.round(accid_sik_j*10000*sh_c_a/100));
			<%}%>		
			
			if((car_amt+opt_amt+col_amt) < sh_car_amt){
				sh_car_amt = (car_amt+opt_amt+col_amt);
			}
					
			fm.cd[i].value = "sh_car_amt";				fm.nm[i].value = "??????????????(??????????)";			fm.value[i].value = sh_car_amt;				i++;
				
			dlv_car_amt = (car_amt+opt_amt+col_amt)-sh_car_amt;
			fm.cd[i].value = "dlv_car_amt";				fm.nm[i].value = "????????";					fm.value[i].value = dlv_car_amt;			i++;		
					
			o_y = o_w*(1+(accid_sik_c-accid_sik_g)*a_b/12/12);
			fm.cd[i].value = "o_y";					fm.nm[i].value = "?????? ???? ???? ???? ??????(????)";		fm.value[i].value = o_y;				i++;		
		
		
		}
		
		
		
		
		
		if('<%=ck_acar_id%>'=='000029'){
//			return;
		}
		
		if('<%=mode%>'=='cmp'){
			var bc_b_e1 = Math.round((gb_954*100)*100)/100;
			var bc_b_e2 = ten_th_rnd(Math.round(o_s*10000));
			
			if(<%=rent_dt%> >= 20150512){
				bc_b_e2 = ten_th_rnd(Math.round(accid_sik_j*10000));
			}
			
			if('<%=rent_st%>'=='2' && <%=fee_opt_amt%>>0 && '<%=from_page%>' != '/fms2/lc_rent/search_car_esti_s.jsp'){
				bc_b_e1 = 0;
				bc_b_e2 = 0;
				alert('???? ?????????? ???? ??????????.');
			}else{
				parent.document.form1.bc_b_e1.value 	= bc_b_e1;
				parent.document.form1.bc_b_e2.value 	= bc_b_e2;
				parent.document.form1.sh_amt.value 	= parseDecimal(sh_car_amt);
			}
		}
				
		if('<%=mode%>'=='account'){
			parent.document.form1.depreciation.value 		= parseDecimal(dlv_car_amt);
			parent.document.form1.apply_secondhand_price.value 	= parseDecimal(sh_car_amt);

			save();		
		}
		
		if('<%=mode%>'=='lc_rent'){
		
			<%if(!rent_mng_id.equals("") && !rent_l_cd.equals("") && !rent_st.equals("")){%>
				var bc_b_e1 = Math.round((gb_954*100)*100)/100;
				var bc_b_e2 = ten_th_rnd(Math.round(o_s*10000));
			
				if(<%=rent_dt%> >= 20150512){
					bc_b_e2 = ten_th_rnd(Math.round(accid_sik_j*10000));
				}
			
				if(<%=fee_opt_amt%>>0 && '<%=from_page%>' != '/fms2/lc_rent/search_car_esti_s.jsp'){
					bc_b_e1 = 0;
					bc_b_e2 = 0;
					alert('???? ?????????? ???? ??????????.');
				}else{
					parent.document.form1.bc_b_e1.value 	= bc_b_e1;
					parent.document.form1.bc_b_e2.value 	= bc_b_e2;
				}				
			<%}%>
		
			parent.document.form1.sh_car_amt.value			= parseDecimal(car_amt+opt_amt+col_amt-tax_dc_amt);
			parent.document.form1.sh_amt.value 				= parseDecimal(sh_car_amt);
			parent.document.form1.sh_ja.value 				= replaceFloatRound(sh_car_amt/(car_amt+opt_amt+col_amt-tax_dc_amt));
			if(parent.document.form1.sh_km.value=='0'){
				parent.document.form1.sh_tot_km.value			= <%=ht.get("TOT_DIST")%>;
				parent.document.form1.sh_km.value				= fw_941;
				parent.document.form1.sh_km_bas_dt.value		= rent_dt;
			}
			
			<%if(from_page.equals("/fms2/lc_rent/search_car_esti_s.jsp") && fee_opt_amt == 0){%>
			parent.document.form1.o_1.value 					= parent.document.form1.sh_amt.value;
			<%}%>
		}
		
		fm.cd[i].value = "";			fm.nm[i].value = "---------------------------"; fm.value[i].value = '???????? --------------------------------------';			i++;						
		fm.cd[i].value = "tot_dist";		fm.nm[i].value = "????????????";				fm.value[i].value = <%=ht.get("TOT_DIST")%>;				i++;		
		fm.cd[i].value = "today_dist";		fm.nm[i].value = "????????????";				fm.value[i].value = fw_941;						i++;		
		


	}
	
	//?????????? ????????-??????
	function save(){
		var fm = document.form1;
		//fm.action = "getSecondhandBaseSet_a.jsp";
		//fm.submit();
	}
//-->
</script>
</head>
<body>
<form action="" name="form1" method="POST" >
<input type="hidden" name="car_mng_id" 		value="<%=car_mng_id%>">
  <table border=0 cellspacing=0 cellpadding=0 width=800>
	<tr>
      <td>????????</td>
    </tr>
    <tr>
        <td class=line2></td>
    </tr>
    <tr>
      <td class=line><table border="0" cellspacing="1" width=100%>
        <tr>
          <td width="30" class=title>????</td>
          <td width="100" class=title>????</td>
          <td width="370" class=title>????</td>
          <td width="300" class=title>??</td>
          </tr>
		  <%//if(chk >0){%>
		  <%for(int i=0; i<200; i++){%>
          <tr>
		  	<td align="center"><%=i%></td>
            <td>&nbsp;<input type="text" name="cd" value="" size="15" class=whitetext></td>
            <td>&nbsp;<input type="text" name="nm" value="" size="45" class=whitetext></td>
            <td>&nbsp;<input type="text" name="value" value="" size="40" class=whitetext></td>          
          </tr>
		  <%}//}%>
      </table></td>
    </tr>	
	<%//if(chk >0){%>
	<!--
	<tr>
      <td><a href="javascript:save()"><img src=/acar/images/center/button_save.gif align=absmiddle border=0></a></td>
    </tr>	
  -->  
	<%//}%>	
</table>	
</form>	
<script>
<!--
	getShCarAmt();	
//-->
</script>	
</body>
</html>
