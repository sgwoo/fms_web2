<%@ page language="java" contentType="text/html; charset=euc-kr" %>
<%@ page import="java.util.*, acar.util.*, acar.common.*, acar.secondhand.*, acar.estimate_mng.*, acar.cont.*, acar.res_search.*, acar.user_mng.*" %>
<jsp:useBean id="shDb" class="acar.secondhand.SecondhandDatabase" scope="page"/>
<jsp:useBean id="a_db" scope="page" class="acar.cont.AddContDatabase"/>
<jsp:useBean id="rs_db" scope="page" class="acar.res_search.ResSearchDatabase"/>
<jsp:useBean id="ej_bean" class="acar.estimate_mng.EstiJgVarBean" scope="page"/>
<jsp:useBean id="bc_db" class="acar.bad_cust.BadCustDatabase" scope="page"/>
<%@ include file="/acar/cookies.jsp" %>

<%
	MaMenuDatabase nm_db = MaMenuDatabase.getInstance();

	String auth_rw 		= request.getParameter("auth_rw")	==null?"":request.getParameter("auth_rw");
	String br_id 		= request.getParameter("br_id")		==null?"":request.getParameter("br_id");
	String user_id 		= request.getParameter("user_id")	==null?"":request.getParameter("user_id");
	
	String car_mng_id 	= request.getParameter("car_mng_id")==null?"":request.getParameter("car_mng_id");
	String rent_mng_id 	= request.getParameter("rent_mng_id")==null?"":request.getParameter("rent_mng_id");
	String rent_l_cd 	= request.getParameter("rent_l_cd")==null?"":request.getParameter("rent_l_cd");
	String tae_car_mng_id 	= request.getParameter("tae_car_mng_id")==null?"":request.getParameter("tae_car_mng_id");
	
	String esti_nm 		= request.getParameter("esti_nm")	==null?"":request.getParameter("esti_nm");
	String a_a 		= request.getParameter("a_a")		==null?"":request.getParameter("a_a");
	String a_b 		= request.getParameter("a_b")		==null?"":request.getParameter("a_b");
	String pp_st 		= request.getParameter("pp_st")		==null?"2":request.getParameter("pp_st");
	String rg_8 		= request.getParameter("rg_8")		==null?"":request.getParameter("rg_8");
	String rent_st 		= request.getParameter("rent_st")	==null?"":request.getParameter("rent_st");
	String spr_yn 		= request.getParameter("spr_yn")	==null?"":request.getParameter("spr_yn");
	String lpg_yn 		= request.getParameter("lpg_yn")	==null?"":request.getParameter("lpg_yn");
	String lpg_kit 		= request.getParameter("lpg_kit")	==null?"0":request.getParameter("lpg_kit");
	String a_h 		= request.getParameter("a_h")		==null?"":request.getParameter("a_h");
	String ins_dj 		= request.getParameter("ins_dj")	==null?"":request.getParameter("ins_dj");
	String ins_age 		= request.getParameter("ins_age")	==null?"":request.getParameter("ins_age");
	String ins_good 	= request.getParameter("ins_good")	==null?"":request.getParameter("ins_good");
	String gi_yn 		= request.getParameter("gi_yn")		==null?"":request.getParameter("gi_yn");
	String car_ja 		= request.getParameter("car_ja")	==null?"":request.getParameter("car_ja");
	String jg_code		= request.getParameter("jg_code")	==null?"":request.getParameter("jg_code");
	String st 		= request.getParameter("st")		==null?"":request.getParameter("st");
	String from_page 	= request.getParameter("from_page")	==null?"":request.getParameter("from_page");
	String udt_st 		= "";
	String ins_per 		= "";
	String insurant		= "";
	
	String cust_nm 		= request.getParameter("cust_nm")==null?"":request.getParameter("cust_nm");
	String damdang_id	= request.getParameter("damdang_id2")==null?"":request.getParameter("damdang_id2");
	String cust_tel		= request.getParameter("cust_tel")==null?"":request.getParameter("cust_tel");
	String cust_fax 	= request.getParameter("cust_fax")==null?"":request.getParameter("cust_fax");
	String cust_email 	= request.getParameter("cust_email")==null?"":request.getParameter("cust_email");
	String doc_type 	= request.getParameter("doc_type")==null?"":request.getParameter("doc_type");
	String mgr_nm	 	= request.getParameter("mgr_nm")==null?"":request.getParameter("mgr_nm");
	String cust_ssn 	= request.getParameter("cust_ssn")==null?"":request.getParameter("cust_ssn");
	String com_emp_yn 	= request.getParameter("com_emp_yn")==null?"":request.getParameter("com_emp_yn");
	
	String est_st 		= request.getParameter("est_st")==null?"":request.getParameter("est_st");
	String fee_opt_amt 	= request.getParameter("fee_opt_amt")==null?"":request.getParameter("fee_opt_amt");
	String fee_rent_st 	= request.getParameter("fee_rent_st")==null?"":request.getParameter("fee_rent_st");
	String rent_dt	 	= request.getParameter("rent_dt")==null?"":request.getParameter("rent_dt");
	String cng_item	 	= request.getParameter("cng_item")==null?"":request.getParameter("cng_item");
	String jg_w	 	= request.getParameter("jg_w")==null?"":request.getParameter("jg_w");
	
	String br_to_st	= request.getParameter("br_to_st")==null?"":request.getParameter("br_to_st");
	String br_to 		= request.getParameter("br_to")==null?"":request.getParameter("br_to");
	String br_from 	= request.getParameter("br_from")==null?"":request.getParameter("br_from");
	
	int o_1	 		= request.getParameter("apply_secondhand_price")==null?0:AddUtil.parseDigit(request.getParameter("apply_secondhand_price"));
	
	//불량고객 확인
	Vector vt_chk1 = new Vector();
	if(!cust_nm.equals("")||!cust_tel.equals("")||!cust_email.equals("")||!cust_fax.equals("")){
		vt_chk1 = bc_db.getBadCustRentCheck(cust_nm, cust_nm, "", "", cust_tel, "", "", cust_email, cust_fax, "", "");
	}	
	int vt_chk1_size = vt_chk1.size();
	
	if(cng_item.equals("taecha") && !tae_car_mng_id.equals("") && from_page.equals("/fms2/lc_rent/lc_c_c_fee.jsp")){
		car_mng_id = tae_car_mng_id;
	}
	
	//차량정보
	Hashtable ht = shDb.getShBase(car_mng_id);
	
	//차량정보-여러테이블 조인 조회
	Hashtable ht2 = shDb.getBase(car_mng_id);
	
	if( (est_st.equals("2") || cng_item.equals("taecha")) && !rent_l_cd.equals("") && String.valueOf(ht.get("CAR_MNG_ID")).equals("null")){
		ht2.put("REG_ID", ck_acar_id);
		//sh_base table insert
		int count = shDb.insertShBase(ht2);
	}else{
		int chk = 0;
		if(!String.valueOf(ht2.get("COLO")).equals(String.valueOf(ht.get("COL")))) 							chk++;
		if(!String.valueOf(ht2.get("JG_CODE")).equals(String.valueOf(ht.get("JG_CODE")))) 					chk++;
		if(!String.valueOf(ht2.get("CAR_USE")).equals(String.valueOf(ht.get("CAR_USE")))) 					chk++;
		if(!String.valueOf(ht2.get("CAR_EXT")).equals(String.valueOf(ht.get("CAR_EXT")))) 					chk++;
		if(!String.valueOf(ht2.get("CAR_NO")).equals(String.valueOf(ht.get("CAR_NO")))) 					chk++;
		if(!String.valueOf(ht2.get("SECONDHAND_DT")).equals(String.valueOf(ht.get("SECONDHAND_DT")))) 		chk++;
		if(!String.valueOf(ht2.get("BEFORE_ONE_YEAR")).equals(String.valueOf(ht.get("BEFORE_ONE_YEAR")))) 	chk++;
		if(!String.valueOf(ht2.get("SERV_DT")).equals(String.valueOf(ht.get("SERV_DT")))) 					chk++;
		if(!String.valueOf(ht2.get("TOT_DIST")).equals(String.valueOf(ht.get("TOT_DIST")))) 				chk++;
		if(!String.valueOf(ht2.get("TODAY_DIST")).equals(String.valueOf(ht.get("TODAY_DIST")))) 			chk++;
		if(!String.valueOf(ht2.get("PARK")).equals(String.valueOf(ht.get("PARK")))) 						chk++;
		if(chk >0){
			//sh_base table update
			int count = shDb.updateShBase(ht2);
			
			ht = shDb.getShBase(car_mng_id);
		}
	}
	
	//잔가 차량정보
	Hashtable sh_var = shDb.getShBaseVar(car_mng_id);
	
	String a_e = String.valueOf(ht.get("S_ST"));
	String name = "";
	
	if(a_a.equals(""))				a_a = "12";
	if(a_a.equals("1"))				a_a = "12";
	if(a_a.equals("2"))				a_a = "22";
	
	if(a_a.equals("11"))			name = "리스플러스 일반식";
	else if(a_a.equals("12"))		name = "리스플러스 기본식";
	else if(a_a.equals("21"))		name = "장기렌트 일반식";
	else if(a_a.equals("22"))		name = "장기렌트 기본식";
	else					name = "오류";
	
	
	
	//수입차리스는 20110105 고객피보험자로 변경
	if(jg_w.equals("1")){
		if(a_a.equals("11") || a_a.equals("12")){
			//ins_per = "2";
			ins_per = "1";
		}
	}

	//견적관리번호 생성 및 견적 등록
	EstiDatabase e_db = EstiDatabase.getInstance();
	
	String jg_b_dt = e_db.getVar_b_dt(String.valueOf(ht.get("JG_CODE")), "jg", rent_dt);
	
	//차종변수
	ej_bean = e_db.getEstiJgVarCase(String.valueOf(ht.get("JG_CODE")), jg_b_dt);	
	
	ContBaseBean base = new ContBaseBean();
	ContEtcBean cont_etc = new ContEtcBean();
	ContFeeBean fee = new ContFeeBean();
	ContCarBean car = new ContCarBean();
	ContPurBean pur = new ContPurBean();
	ContTaechaBean taecha = new ContTaechaBean();
	
	//계약관리에서 연장미등록 연장견적 계산하기
	if(est_st.equals("2") && !rent_l_cd.equals("")){
		//계약기본정보
		base = a_db.getCont(rent_mng_id, rent_l_cd);
		//계약기타정보
		cont_etc = a_db.getContEtc(rent_mng_id, rent_l_cd);
		//대여정보
		fee = a_db.getContFeeNew(rent_mng_id, rent_l_cd, fee_rent_st);
		//차량기본정보
		car = a_db.getContCarNew(rent_mng_id, rent_l_cd);
		//출고정보
		pur = a_db.getContPur(rent_mng_id, rent_l_cd);
		
		if(cont_etc.getDec_gr().equals("")) cont_etc.setDec_gr(base.getSpr_kd());
		
		spr_yn 	= cont_etc.getDec_gr();
		a_h 	= car.getCar_ext();
		udt_st 	= pur.getUdt_st();
		ins_dj	= base.getGcp_kd();
		ins_age	= base.getDriving_age();
		if(base.getDriving_age().equals("0")) ins_age = "1";
		if(base.getDriving_age().equals("1")) ins_age = "2";
		ins_per	= cont_etc.getInsur_per();
		insurant= cont_etc.getInsurant();
		gi_yn 	= car.getGi_st();
		car_ja	= String.valueOf(AddUtil.parseDecimal(base.getCar_ja()));
		rent_dt = rs_db.addDay(fee.getRent_end_dt(), 1);
		fee_rent_st = String.valueOf(AddUtil.parseInt(fee_rent_st)+1);
		if(base.getCar_st().equals("1") && fee.getRent_way().equals("1")){
			name = "장기렌트 일반식";
			a_a = "21";
		}else if(base.getCar_st().equals("1") && fee.getRent_way().equals("3")){ 
			name = "장기렌트 기본식";
			a_a = "22";
		}else if(base.getCar_st().equals("3") && fee.getRent_way().equals("1")){ 
			name = "리스플러스 일반식";
			a_a = "11";
		}else if(base.getCar_st().equals("3") && fee.getRent_way().equals("3")){ 
			name = "리스플러스 기본식";
			a_a = "12";
		}
	}
	
	//계약관리에서 출고지연차량 견적 계산하기
	if(cng_item.equals("taecha") && !rent_l_cd.equals("")){
		//계약기본정보
		base = a_db.getCont(rent_mng_id, rent_l_cd);
		//계약기타정보
		cont_etc = a_db.getContEtc(rent_mng_id, rent_l_cd);
		//대여정보
		fee = a_db.getContFeeNew(rent_mng_id, rent_l_cd, "1");
		//차량기본정보
		car = a_db.getContCarNew(rent_mng_id, rent_l_cd);
		//출고정보
		pur = a_db.getContPur(rent_mng_id, rent_l_cd);
		
		String taecha_no  	= request.getParameter("taecha_no")==null?"":request.getParameter("taecha_no");
		
		if(taecha_no.equals("")){
			taecha_no = a_db.getMaxTaechaNo(rent_mng_id, rent_l_cd)+"";
		}
				
		//출고지연대차
		taecha = a_db.getTaecha(rent_mng_id, rent_l_cd, taecha_no);
		
		
		if(cont_etc.getDec_gr().equals("")) cont_etc.setDec_gr(base.getSpr_kd());
		
		spr_yn 	= cont_etc.getDec_gr();
		
		a_h 	= car.getCar_ext();
		udt_st 	= pur.getUdt_st();
		ins_dj	= base.getGcp_kd();
		ins_age	= base.getDriving_age();
		if(base.getDriving_age().equals("0")) ins_age = "1";
		if(base.getDriving_age().equals("1")) ins_age = "2";
		ins_per	= cont_etc.getInsur_per();
		insurant= cont_etc.getInsurant();
		gi_yn 	= car.getGi_st();
		car_ja	= String.valueOf(AddUtil.parseDecimal(base.getCar_ja()));
		rent_dt = taecha.getCar_rent_st();
		fee_rent_st = "1";
		
		if(rent_dt.equals("")) rent_dt = AddUtil.getDate();
		
		// * 기본식 12개월 견적과 동일한 견적입니다.
		
		a_b		= "12";
		
		if(base.getCar_st().equals("1") && fee.getRent_way().equals("1")){
			name = "장기렌트 기본식";
			a_a = "22";
		}else if(base.getCar_st().equals("1") && fee.getRent_way().equals("3")){ 
			name = "장기렌트 기본식";
			a_a = "22";
		}else if(base.getCar_st().equals("3") && fee.getRent_way().equals("1")){ 
			name = "리스플러스 기본식";
			a_a = "12";
		}else if(base.getCar_st().equals("3") && fee.getRent_way().equals("3")){ 
			name = "리스플러스 기본식";
			a_a = "12";
		}
	}
	
	//out.println("ins_per="+ins_per);

%>
<html>
<head>
<title>조정견적</title>
<meta http-equiv="Content-Type" content="text/html; charset=euc-kr">
<link rel="stylesheet" type="text/css" href="/include/table_t.css">
<script language='JavaScript' src='/include/common.js'></script>
<script language="JavaScript">
<!--	

	//한도체크
	function compare(obj){
		var fm = document.form1;
		if(obj == fm.rg_8){
											fm.rg_8_amt.value = parseDecimal(Math.round(toInt(parseDigit(fm.o_1.value)) * toInt(fm.rg_8.value) / 100 / 1000) * 1000);	
		}else if(obj == fm.rg_8_amt){
											var rg_8 = parseFloatCipher(toInt(parseDigit(fm.rg_8_amt.value)) / toInt(parseDigit(fm.o_1.value)) * 100,2);
											fm.rg_8.value = rg_8;	
		}else if(obj == fm.pp_per){
											fm.pp_amt.value = parseDecimal(toInt(parseDigit(fm.o_1.value)) * toInt(fm.pp_per.value)/100);						
		}else if(obj == fm.pp_amt){
											fm.pp_per.value = Math.round(toInt(parseDigit(fm.pp_amt.value)) / toInt(parseDigit(fm.o_1.value)) * 100);
		}else if(obj == fm.gi_per){
											fm.gi_amt.value = parseDecimal(toInt(parseDigit(fm.o_1.value)) * toInt(fm.gi_per.value)/100);						
		}else if(obj == fm.gi_amt){
											fm.gi_per.value = Math.round(toInt(parseDigit(fm.gi_amt.value)) / toInt(parseDigit(fm.o_1.value)) * 100);
		}	

	}	
	
	//개시대여료셋팅
	function change_g_10(){
		fm = document.form1;
		if(fm.pp_st.checked==false){
			fm.g_10.value = "0";
		}else{
			fm.g_10.value = "3";
		} 
	}
	
	//견적내기
	function EstiReg(){
		var fm = document.form1;
		
		// 보증금 차가 100% 제한		2018.01.12
		<%-- var car_o_1 = fm.o_1.value.replace(/,/gi,'');
		var car_rg8_amt = fm.rg_8_amt.value.replace(/,/gi,'');
		var st_val = <%=st%>;
		if(st_val != 1){	// 출고전대차 인 경우는 보증금 100% 제한을 해제 한다. 2018.01.17
			if(Number(car_rg8_amt) > Number(car_o_1)){
		    	alert('보증금은 차가의 100% 이내만 납부 가능합니다. \n\n추가로 초기납입금 납부를 원할 경우 선납금으로 납부하시면 됩니다.');
		    	return;
		    }
		} --%>
		
		if(fm.a_h.value == '')	{ alert('등록지역을 선택하십시오'); return; }	
		
		<%if (!(nm_db.getWorkAuthUser("전산팀", user_id) || nm_db.getWorkAuthUser("본사영업팀장", user_id) || nm_db.getWorkAuthUser("본사영업부팀장", user_id) || nm_db.getWorkAuthUser("영업팀내근직", user_id) || user_id.equals("000057"))) {%>
			<%if ((AddUtil.parseInt(jg_code) > 9000000 && AddUtil.parseInt(jg_code) < 9036000)) {%>
			if (Number(fm.agree_dist.value.replace(/,/g,"")) < 5000 || Number(fm.agree_dist.value.replace(/,/g,"")) > 60000) {
	    		alert("연간 약정운행거리 최대값을 초과하여 입력하였습니다.\n\n* 차종별 연간 약정운행거리 최대값\n- 스타렉스 벤 및 트럭 : 5,000 ~ 60,000km/년 이하\n- 그외차종 : 5,000 ~ 50,000km/년 이하");
	    		return;
	    	}
			<%} else {%>
			if (Number(fm.agree_dist.value.replace(/,/g,"")) < 5000 || Number(fm.agree_dist.value.replace(/,/g,"")) > 50000) {
	    		alert("연간 약정운행거리 최대값을 초과하여 입력하였습니다.\n\n* 차종별 연간 약정운행거리 최대값\n- 스타렉스 벤 및 트럭 : 5,000 ~ 60,000km/년 이하\n- 그외차종 : 5,000 ~ 50,000km/년 이하");
	    		return;
	    	}
			<%}%>
		<%}%>
		
		//20150414 대물5억일때 메시지
		if(fm.ins_dj.value == '3'){
			alert('대물 보상한도 5억원은 계약서 작성전에 렌터카공제조합에 미리 승인을 받아야 합니다.');			
		}
		
		//20150626 리스기본식만 보험계약자 고객 선택가능, 보험계약자가 고객이면 피보험자도 고객이여야 한다.			
		/*
		if(fm.a_a.value == '12'){
			if(fm.insurant.value == '2' && fm.ins_per.value != '2'){
				alert('보험계약자 고객이면 피보험자도 고객이여야 합니다.');
				return;					
			}
		}else{
			if(fm.insurant.value == '2'){
				alert('보험계약자 고객은 리스기본식만 가능합니다.');
				return;
			}			
		}	
		*/	
		
		<%if(ej_bean.getJg_w().equals("1")){%>
		if(parseDigit(fm.car_ja.value) != '500000'){
      		alert('면책금 금액이 틀렸습니다.'); return;
      	}
		<%}else{%>
		if(parseDigit(fm.car_ja.value) == '300000' || parseDigit(fm.car_ja.value) == '200000' || parseDigit(fm.car_ja.value) == '100000'){
      	}else{
      		alert('면책금 금액이 틀렸습니다.'); return;
      	}
		<%}%>
		
		<%if((AddUtil.parseInt(jg_code) > 1999999 && AddUtil.parseInt(jg_code) < 7000000) || (AddUtil.parseInt(jg_code) > 1999 && AddUtil.parseInt(jg_code) < 7000)){%>
		if(!(fm.doc_type.value == '1' || fm.doc_type.value == '2') && fm.com_emp_yn.value == 'Y'){
			fm.com_emp_yn.value = 'N';
		}
		<%}%>
		
		if(!confirm('견적하시겠습니까?')){	return; }
		fm.action = 'esti_mng_i_20090901_a.jsp';
		fm.target = "_self";
		fm.submit();
	}		

	//견적내기
	function EstiRegAuto(){
		var fm = document.form1;
		
		<%if (vt_chk1_size > 0) {%>
		alert('[<%=cust_nm%>]은 불량고객으로 등록된 고객과 동일인지 여부를 확인 후 진행하시기 바랍니다. 조정견적에서 확인하고 처리하세요.'); 
		return;
		<%}%>

		<%if (ej_bean.getJg_w().equals("1")) {%>
		if(parseDigit(fm.car_ja.value) != '500000'){
      		alert('면책금 금액이 틀렸습니다.'); return;
      	}
		<%} else {%>
		if(parseDigit(fm.car_ja.value) == '300000' || parseDigit(fm.car_ja.value) == '200000' || parseDigit(fm.car_ja.value) == '100000'){
		}else{
	    	alert('면책금 금액이 틀렸습니다.'); return;
	    }
		<%}%>
		
		<%if((AddUtil.parseInt(jg_code) > 1999999 && AddUtil.parseInt(jg_code) < 7000000) || (AddUtil.parseInt(jg_code) > 1999 && AddUtil.parseInt(jg_code) < 7000)){%>
		if(!(fm.doc_type.value == '1' || fm.doc_type.value == '2') && fm.com_emp_yn.value == 'Y'){
			fm.com_emp_yn.value = 'N';
		}
		<%}%>
		
		fm.action = 'esti_mng_i_20090901_a.jsp';
		fm.target = "_self";
		fm.submit();
	}
	
	//법인임직원전용보험 가입여부
	function SetComEmpYn(){
		var fm = document.form1;
		<%if((AddUtil.parseInt(jg_code) > 1999999 && AddUtil.parseInt(jg_code) < 7000000) || (AddUtil.parseInt(jg_code) > 1999 && AddUtil.parseInt(jg_code) < 7000)){%>
		if(fm.doc_type.value == '1'){
			fm.com_emp_yn.value = 'Y';
		}else{
			fm.com_emp_yn.value = 'N';
		}
		<%}%>
	}

	//불량고객 
	function view_badcust(est_nm, lic_no, est_tel, est_o_tel, est_mail, est_fax, est_comp_tel, est_comp_cel, driver_cell)
	{
		window.open('/acar/bad_cust/stat_badcust_list.jsp?badcust_chk_from=esti_mng_i_20090901.jsp&est_nm='+est_nm+'&lic_no='+lic_no+'&est_tel='+est_tel+'&est_o_tel='+est_o_tel+'&est_mail='+est_mail+'&est_fax='+est_fax+'&est_comp_tel='+est_comp_tel+'&est_comp_cel='+est_comp_cel+'&driver_cell='+driver_cell, "BADCUST", "left=10, top=10, width=1200, height=560, resizable=yes, scrollbars=yes, status=yes");
	}		

//-->
</script>
</head>
<body leftmargin="15" onLoad="init();" >
<table border=0 cellspacing=0 cellpadding=0 width=650>
  <form action="" name="form1" method="POST" >
    <input type="hidden" name="auth_rw" 		value="<%=auth_rw%>">
    <input type="hidden" name="br_id" 			value="<%=br_id%>">
    <input type="hidden" name="user_id" 		value="<%=user_id%>">
    <input type="hidden" name="car_mng_id" 		value="<%=car_mng_id%>">
    <input type="hidden" name="esti_nm"			value="<%=esti_nm%>">
    <input type="hidden" name="a_a"			value="<%=a_a%>">    
    <input type="hidden" name="rent_st"			value="<%=rent_st%>">	
    <input type="hidden" name="lpg_kit" 		value="<%=lpg_kit%>">
    <input type="hidden" name="o_1"			value="<%=o_1%>">
    
    <input type="hidden" name="st" 			value="<%=st%>">	
    <input type="hidden" name="from_page" 		value="<%=from_page%>">	
    <input type="hidden" name="cust_nm" 		value="<%=cust_nm%>">		
    <input type="hidden" name="damdang_id" 		value="<%=damdang_id%>">		
    <input type="hidden" name="cust_tel" 		value="<%=cust_tel%>">		
    <input type="hidden" name="cust_fax" 		value="<%=cust_fax%>">		
    <input type="hidden" name="cust_email" 		value="<%=cust_email%>">		
    <input type="hidden" name="mgr_nm" 			value="<%=mgr_nm%>">		
    <input type="hidden" name="cust_ssn" 		value="<%=cust_ssn%>">		
    <input type="hidden" name="udt_st" 			value="<%=udt_st%>">		
    <input type='hidden' name="est_st"				value="<%=est_st%>">      
    <input type='hidden' name="fee_opt_amt"		value="<%=fee_opt_amt%>">        
    <input type="hidden" name="rent_mng_id"	value="<%=rent_mng_id%>">
    <input type="hidden" name="rent_l_cd" 		value="<%=rent_l_cd%>">		
    <input type="hidden" name="fee_rent_st"		value="<%=fee_rent_st%>">		
    <input type="hidden" name="cng_item"		value="<%=cng_item%>">
    <input type="hidden" name="br_to_st"		value="<%=br_to_st%>">
    <input type="hidden" name="br_to"			value="<%=br_to%>">
    <input type="hidden" name="br_from"		value="<%=br_from%>">
			
    <tr> 
        <td colspan=2>
            <table width=100% border=0 cellpadding=0 cellspacing=0>
                <tr>
                    <td width=7><img src=../images/center/menu_bar_1.gif width=7 height=33></td>
                    <td class=bar>&nbsp;&nbsp;&nbsp;<img src=../images/center/menu_bar_dot.gif width=4 height=5 align=absmiddle>&nbsp;<span class=style1>재리스 > 견적내기 > <span class=style5><%=rent_l_cd%> 조정견적</span></span></td>
                    <td width=7><img src=../images/center/menu_bar_2.gif width=7 height=33></td>
                </tr>
            </table>            
        </td>
    </tr>	
    <tr> 
        <td colspan="2" align=right><span class=style3>* 아래 조건을 입력하고, 견적을 내시기 바랍니다.</span>&nbsp;</td>
    </tr>
    <tr>
        <td colspan="2">&nbsp;</td>
    </tr>
    <%if (nm_db.getWorkAuthUser("전산팀", user_id) || nm_db.getWorkAuthUser("엑셀견적관리자", user_id)) {%>
    <tr>
        <td>※ 견적일자 : <input type="text" name="rent_dt" value="<%=AddUtil.getDate()%>" size="10" class=text></td>
    </tr>
    <%}else{ %>
    <input type="hidden" name="rent_dt"			value="<%=rent_dt%>">    
    <%} %>
    <tr> 
        <td colspan="2"><font size="+1">
            <div align="center"><b><%if(st.equals("1")){ //출고전대차%>출고전대차<%}else{%>[ <%= name %> ]<%}%></b></div></font></td>
    </tr>
    <%if(vt_chk1_size>0){%>
    <tr> 
        <td colspan="2">※ [<%=cust_nm%>]은 불량고객으로 등록된 고객과 동일인지 여부를 확인 후 진행하시기 바랍니다.
        	<input type="button" class="button" id="bad_cust" value='내용보기' onclick="javascript:view_badcust('<%=cust_nm%>', '', '<%=cust_tel%>', '', '<%=cust_email%>', '<%=cust_fax%>', '', '', '');">
        	<input name="badcust_chk" type="text" class="text"  readonly value="" size="1">	
        </td>
    </tr>
        
    <%}%>          
    <tr> 
        <td colspan="2"><img src=../images/center/icon_arrow.gif align=absmiddle> <span class=style2>계약조건</span></td>
    </tr>
    <tr>
        <td colspan=2 class=line2></td>
    </tr>
    <tr> 
        <td class=line colspan="2"> 
            <table border="0" cellspacing="1" width=100%>
                <tr> 
                    <td colspan="2" class=title>&nbsp;</td>
                    <td width="40%" class=title>변경전</td>
                    <td width="40%" class=title>변경후</td>
                    <!-- <td class=title>변경전</td>
                    <td width="358" class=title>변경후</td> -->
                </tr>
				<%if(est_st.equals("2") && !st.equals("1")){%>
                <tr> 
                    <td colspan="2" class=title>대여기간</td>
                    <td>&nbsp;-</td>
                    <td>
                      <input type="text" name="a_b" class=num size="4" value="12">
                      개월</td>
                </tr>	
				<%}else{%>			
				<input type="hidden" name="a_b" value="<%=a_b%>">
				<%}%>
                <tr> 
                    <td colspan="2" class=title>LPG키트</td>
                    <td>&nbsp;
                      <%if(lpg_kit.equals("Y")){
      						out.print("LPG장착(겸용)");
        				}else{
        					if(a_e.equals("301")||a_e.equals("302")){
        						out.print("LPG전용");
        					}else{
        						out.print("미장착");
        					}
        				}  %>
                    </td>
                    <td><select name="lpg_yn">
                        <% if(lpg_kit.equals("Y")){ %>
                        <option value="2" selected>기존장착</option>
                        <% }else{
        					if(a_e.equals("301")||a_e.equals("302")){ %>
                        <option value="0" selected>변경불가</option>
                        <%		}else{ %>
                        <option value="0" selected>미장착</option>
                        <option value="1" >추가장착</option>
                        <%		}
        			   } %>
                      </select></td>
                </tr>
                <%
              		int b_agree_dist =0;
              		//int agree_dist   =0;
              		int agree_dist = request.getParameter("agree_dist")==null?0:AddUtil.parseDigit(request.getParameter("agree_dist"));
              	
           				b_agree_dist = 30000;
           				
           				//20220415 약정운행거리 23000
           				if(AddUtil.parseInt(AddUtil.replace(rent_dt,"-","")) >= 20220415){
           					b_agree_dist = 23000;
           				}
           		
									//디젤 +5000
									if(ej_bean.getJg_b().equals("1")){
										b_agree_dist = b_agree_dist+5000;
									}				
									//LPG +10000 -> 20190418 +5000
									if(ej_bean.getJg_b().equals("2")){
										b_agree_dist = b_agree_dist+5000;				
									}
			
									if(agree_dist==0)	agree_dist = b_agree_dist;
		
              %>                         
                <tr> 
                    <td width="22" rowspan="2" class=title>운<br>행<br>거<br>리</td>
                    <td class=title width="75">표준약정<br>운행거리</td>
                    <td width="182">&nbsp;-</td>
                    <td><input type="text" name="b_agree_dist" class=whitenum size="10" value='<%=AddUtil.parseDecimal(b_agree_dist)%>' onBlur='javascript:this.value=parseDecimal(this.value);'>
                        km/년 </td>
                </tr>       
                <tr> 
                    <td class=title width="75">적용약정<br>운행거리</td>
                    <td>&nbsp;-</td>
                    <td><input type="text" name="agree_dist" class=num size="10" value='<%=AddUtil.parseDecimal(agree_dist)%>' onBlur='javascript:this.value=parseDecimal(this.value);'>
                        km/년
                        <%if ((nm_db.getWorkAuthUser("전산팀", user_id) || nm_db.getWorkAuthUser("본사영업부팀장", user_id) || nm_db.getWorkAuthUser("영업팀내근직", user_id) || user_id.equals("000057"))) {%>
	                        <select name='rtn_run_amt_yn' id='rtn_run_amt_yn'>
	                        	<option value='0'>환급대여료 적용</option>
	                        	<option value='1'>미적용</option>
	                        </select>
                        <%} else {%>
                        	<input type='hidden' name='rtn_run_amt_yn' value='0' />
                        <%} %>
                    </td>
                </tr> 
                <tr id="tr_o13" style="display:''"> 
                    <td colspan="2" class=title>적용잔가율 </td>
                    <td>&nbsp;-
					<!--차가의 
                          <input type="text" name="o_13" size="3" class=whitetext  onblur="javascript:compare(this)" value="">
                          %--></td>
                    <td>차가의 
                          <input type="text" name="ro_13" size="3" class=text  onblur="javascript:compare(this)" value="">
                          % (미입력시 계산된 최대잔가율를 적용함)
						  </td>
                </tr>
                <!--
                <tr> 
                    <td colspan="2" class=title>매입옵션 </td>
                    <td>&nbsp;-</td>
                    <td><select name="opt_chk">
                      <option value="0" >미부여</option>
                      <option value="1" <%if(a_a.equals("12") || a_a.equals("22")){%>selected<%}%>>부여</option>
                    </select></td>
                </tr>
                -->                
                <tr> 
                    <td colspan="2" class=title>보증금<br> </td>
                    <td>&nbsp;차가의 
                      <input type="text" name="g_8" class=whitenum size="4" onBlur="javascript:compare(this)" value="<%=rg_8%>">
                      %</td>
                    <td>
					  <%if(st.equals("1")){ //출고전대차%>					   
					   차가의 
                      <input type="text" name="rg_8" class=num size="4" onBlur="javascript:compare(this)" value="">
                      % || 
						적용보증금액 
                      <input type="text" name="rg_8_amt" class=num size="10" onBlur='javascript:this.value=parseDecimal(this.value);compare(this);'>
                      원 <br><!-- (신차 계약시 받은 보증금 금액을 입력해 주세요) -->
                      <!-- 출고지연대차 문구 수정(2018.03.29) -->
                      (출고전대차 전에 실제로 받은 보증금 금액을 입력해주세요)
					  <%}else{
					  		if(est_st.equals("2") || cng_item.equals("taecha")){%>
					      <input type="hidden" name="rg_8" value="">
						적용보증금액 
                      <input type="text" name="rg_8_amt" class=num value="<%=AddUtil.parseDecimal(fee.getGrt_amt_s())%>" size="10" onBlur='javascript:this.value=parseDecimal(this.value);compare(this);'>
                      원 				
					  <%	}else{%>	
					  차가의 
                      <input type="text" name="rg_8" class=num size="4" onBlur="javascript:compare(this)" value="">
                      % || 적용보증금액 
                      <input type="text" name="rg_8_amt" class=num size="10" onBlur='javascript:this.value=parseDecimal(this.value);compare(this);'>
                      원 
					  <%	}%>					  
					  <%}%>
					  </td>
                </tr>
                <tr> 
                    <td colspan="2" class=title>선납금<br> </td>
                    <td>&nbsp;-</td>
                    <td>차가의 
                      <input type="text" name="pp_per" class=num size="4" onBlur="javascript:compare(this)">
                      % || 적용선납금액 
                      <input type="text" name="pp_amt" class=num size="10" onBlur='javascript:this.value=parseDecimal(this.value);compare(this);'>
                      원
					  <%if(st.equals("1")){ //출고전대차%>
					  <br><!-- (신차 계약시 받은 선납금 금액을 입력해 주세요) -->
					  		<!-- 출고지연대차 문구 수정(2018.03.29) -->
					  		(출고전대차 전에 실제로 받은 선납금 금액을 입력, 출고전대차 견적시 본 계약 선납금은 보증금으로 환산하여 계산됨)
					  <%}%></td>
                </tr>
                <tr> 
                    <td colspan="2" class=title>개시대여료 </td>
                    <td>&nbsp;3개월치 대여료 선납</td>
                    <td><font color="#666666"> 
                      <input type="checkbox" name="pp_st" value="1" <% if(pp_st.equals("1") && !st.equals("1")) out.print("checked"); %> <%if(st.equals("1")){ //출고전대차%>onclick="return false;"<%}else{%>onClick="javascript:change_g_10();"<%}%>>					  
                      <input type="text" name="g_10" class=num size="2" value="<% if(pp_st.equals("1") && !st.equals("1")) out.print("3"); %>" <%if(st.equals("1")){ //출고전대차%>readonly<%}%>>
                      개월치 대여료 선납
					  </font>
					  <%if(st.equals("1")){ //출고전대차%>
					  <br>|| 적용개시대여료 <input type="text" name="ifee_amt" class=num size="10" onBlur='javascript:this.value=parseDecimal(this.value);'>
                      원
					  <br><!-- (신차 계약시 받은 개시대여료 금액을 입력해 주세요) -->
					  		<!-- 출고지연대차 문구 수정(2018.03.29) -->
					  		(출고전대차 전에 실제로 받은 개시대여료 금액을 입력, 출고전대차 견적시 본 계약 개시대여료는 보증금으로 환산하여 계산됨)
					  <%}%>
					  </td>
                </tr>
                <tr> 
                    <td colspan="2" class=title>초기납입금<br>안내문구</td>
                    <td>&nbsp;초기납입금은 고객님의 신용도에 따라 심사과정에서 조정될 수 있습니다.</td>
                    <td>
                    	<input type="radio" name="pp_ment_yn" value="Y">
                      표기
                      <input type="radio" name="pp_ment_yn" value="N" checked>
                      미표기
					          </td>
                </tr>    
                <tr <%if (a_a.equals("12") || a_a.equals("11")) {%>style="display: none;"<%}%>> 
                    <td colspan="2" class=title>보증보험 </td>
                    <td>&nbsp;면제</td>
                    <td><select name="gi_yn">
                            <option value="0" <%if(gi_yn.equals("0")||gi_yn.equals(""))%>selected<%%>>면제</option>
                            <option value="1" <%if(gi_yn.equals("1"))%>selected<%%>>가입</option>
                          </select>
                          &nbsp;
                          차가의 
                      <input type="text" name="gi_per" class=num size="4" onBlur="javascript:compare(this)" value="">
                      % || 적용가입금액 
                      <input type="text" name="gi_amt" class=num size="10" onBlur='javascript:this.value=parseDecimal(this.value);compare(this);'>
                      원 
                    </td>
                </tr>                
                <tr> 
                    <td colspan="2" class=title>등록지역 </td>
                    <td>&nbsp;<select name="f_udt_st" onchange="javascript:set_car_ext()">
                        <option value="1" <%if(udt_st.equals("1") || acar_br.equals("S1"))%>selected<%%>>서울본사</option>
                        <option value="2" <%if(udt_st.equals("2") || acar_br.equals("B1"))%>selected<%%>>부산지점</option>
                        <option value="3" <%if(udt_st.equals("3") || acar_br.equals("D1"))%>selected<%%>>대전지점</option>
                        <option value="5" <%if(udt_st.equals("5") || acar_br.equals("G1"))%>selected<%%>>대구지점</option>
                        <option value="6" <%if(udt_st.equals("6") || acar_br.equals("J1"))%>selected<%%>>광주지점</option>
                        <option value="4" <%if(udt_st.equals("4"))%>selected<%%>>고객</option>
                      </select> (차량인수지점)</td>
                    <td><select name="a_h">
                        <option value="1" <%if(a_h.equals("1"))%>selected<%%>>서울</option>
                        <option value="2" <%if(a_h.equals("2"))%>selected<%%>>경기</option>
                        <option value="3" <%if(a_h.equals("3"))%>selected<%%>>부산</option>
                        <option value="4" <%if(a_h.equals("4"))%>selected<%%>>경남</option>
                        <option value="5" <%if(a_h.equals("5"))%>selected<%%>>대전</option>
						            <option value="7" <%if(a_h.equals("7")||a_h.equals(""))%>selected<%%>>인천</option>
						            <option value="9" <%if(a_h.equals("9"))%>selected<%%>>광주</option>
                      </select></td>
                </tr>
                <tr> 
                    <td colspan="2" class=title>신용등급 </td>
                    <td>&nbsp;우량기업</td>
                    <td><select name="spr_yn">
                  			<option value='3' <%if(spr_yn.equals("3"))%>selected<%%>>신설법인</option>
                  			<option value='0' <%if(spr_yn.equals("0"))%>selected<%%>>일반고객</option>
                  			<option value='1' <%if(spr_yn.equals("1")||spr_yn.equals(""))%>selected<%%>>우량기업</option>
                  			<option value='2' <%if(spr_yn.equals("2"))%>selected<%%>>초우량기업</option>
                      </select></td>
                </tr>
                <tr <%if (a_a.equals("12") || a_a.equals("11")) {%>style="display: none;"<%}%>>
                	<td colspan="2" class=title>보증보험료<br>산출등급</td>
                	<td>&nbsp;보험료미표기</td>
                	<td>
                		<select name="gi_grade" id="gi_grade">
               				<option value="" selected>보험료미표기</option>
                			<option value="1">1등급</option>
                			<option value="2">2등급</option>
                			<option value="3">3등급</option>
                			<option value="4">4등급</option>
                			<option value="5">5등급</option>
                			<option value="6">6등급</option>
                			<option value="7">7등급</option>
                		</select>
                	</td>
                </tr>
                <tr> 
                    <td colspan="2" class=title>필요서류표기</td>
                    <td>&nbsp;-</td>
                    <td><select name="doc_type" <%if((AddUtil.parseInt(jg_code) > 1999999 && AddUtil.parseInt(jg_code) < 7000000) || (AddUtil.parseInt(jg_code) > 1999 && AddUtil.parseInt(jg_code) < 7000)){%>onChange="javascript:SetComEmpYn()"<%}%>>
                            <option value=""  <%if(doc_type.equals("") && !st.equals("3")){%>selected<%}%>>선택</option>					                            
                            <option value="1" <%if(doc_type.equals("1") || (doc_type.equals("") && st.equals("3"))){%>selected<%}%>>법인고객</option><!--조정견적시-->
                            <option value="2" <%if(doc_type.equals("2")){%>selected<%}%>>개인사업자</option>
                            <option value="3" <%if(doc_type.equals("3")){%>selected<%}%>>개인</option>
                          </select></td>
                </tr>                  
                <tr> 
                    <td width="22" rowspan="4" class=title>보험</td>
                    <td class=title width="75">대물/자손</td>
                    <td width="182">&nbsp;1억원</td>
                    <td><select name="ins_dj" >
                        <%-- <option value="1" <%if(ins_dj.equals("1"))%>selected<%%>>5천만원/5천만원</option> --%>
                        <option value="2" <%if(ins_dj.equals("2")||ins_dj.equals(""))%>selected<%%>>1억원/1억원</option>
                        <option value="4" <%if(ins_dj.equals("4"))%>selected<%%>>2억원/1억원</option>
						<option value="8" <%if(ins_dj.equals("8"))%>selected<%%>>3억원/1억원</option>
						<option value="3" <%if(ins_dj.equals("3"))%>selected<%%>>5억원/1억원</option>
                      </select> </td>
                </tr>
                <tr> 
                    <td class=title width="75">운전자연령</td>
                    <td>&nbsp;만26세이상</td>
                    <td><select name="ins_age">
                        <option value="1" <%if(ins_age.equals("1")||ins_age.equals(""))%>selected<%%>>만26세이상</option>
                        <%if(a_a.equals("11")||a_a.equals("12")){%>
                        <option value="3" <%if(ins_age.equals("3"))%>selected<%%>>만24세이상</option>
                        <%}%>
                        <option value="2" <%if(ins_age.equals("2"))%>selected<%%>>만21세이상</option>
                      </select></td>
                </tr>
                <tr> 
                    <td class=title>긴급출동</td>
                    <td>&nbsp;미가입</td>
                    <td><select name="ins_good">
                            <option value="0" selected>미가입</option>
                            <option value="1">가입</option>
                          </select></td>
                </tr>
                <!--
                <tr> 
                    <td class=title>보험계약자</td>
                    <td>&nbsp;아마존카</td>
                    <td><select name="insurant">
                            <option value="1" <%if(insurant.equals("1")||insurant.equals(""))%>selected<%%>>아마존카</option>
                            <%if(a_a.equals("12")){%>
                            <option value="2" <%if(insurant.equals("2"))%>selected<%%>>고객</option>
                            <%}%>
                          </select>
                          </td>
                </tr>
                -->
                <tr> 
                    <td class=title>피보험자</td>
                    <td>&nbsp;아마존카</td>
                    <td><select name="ins_per">
                            <option value="1" <%if(ins_per.equals("1")||ins_per.equals(""))%>selected<%%>>아마존카(보험포함)</option>
                            <%-- <option value="2" <%if(ins_per.equals("2"))%>selected<%%> disabled>고객(보험미포함)</option> --%>
                          </select>
                          </td>
                </tr>
                <%if(!st.equals("1") && ((AddUtil.parseInt(jg_code) > 1999999 && AddUtil.parseInt(jg_code) < 7000000) || (AddUtil.parseInt(jg_code) > 1999 && AddUtil.parseInt(jg_code) < 7000))){%>
                <tr> 
                    <td colspan="2" class=title>임직원전용보험</td>
                    <td>&nbsp;-</td>
                    <td><select name="com_emp_yn">
                            <option value="N" <%if(com_emp_yn.equals("N"))%>selected<%%>>미가입</option>
                            <option value="Y" <%if(com_emp_yn.equals("Y") || (doc_type.equals("") && st.equals("3")))%>selected<%%>>가입</option>
                          </select></td>
                </tr>               
                <%}else{%>  
                <input type="hidden" name="com_emp_yn"		value="<%=com_emp_yn%>">
                <%}%>
                <tr> 
                    <td colspan="2" class=title>자차면책금</td>
                    <td>&nbsp;<input type="text" name="car_ja2" class=whitenum size="10" value="300,000" onBlur='javascript:this.value=parseDecimal(this.value);'>원 </td>
                    <td><input type="text" name="car_ja" class=num size="10" value="<%=car_ja%>" onBlur='javascript:this.value=parseDecimal(this.value);'>
                          원 </td>
                </tr>
                <%if(AddUtil.parseInt(AddUtil.replace(AddUtil.getDate(),"-","")) >= 20150217){%>                         
                <tr>                     
                    <td class=title colspan="2" >용품</td>
                    <td width="182">&nbsp;-</td>
                    <td>
                    	<input type="checkbox" name="tint_b_yn"   value="Y" > 2채널 블랙박스<br>
                      	<input type="checkbox" name="tint_s_yn" value="Y" > 전면 썬팅<br>
                      	<input type="checkbox" name="tint_n_yn" value="Y" > 거치형 내비게이션<br>
                      	<input type="checkbox" name="tint_eb_yn" value="Y" > 이동형 충전기(전기차):여유분이 있을때만 가능
                      </td>
                </tr>       
                <%}%>    
                <tr> 
                    <td colspan="2" class=title>대여료D/C </td>
                    <td>&nbsp;-</td>
                    <td>대여료의 
                          <input type="text" name="fee_dc_per" size="4" class=text>
                          %</td>
                </tr>

                <%if(st.equals("4")){//무사고차견적%>           
                <input type="hidden" name="accid_serv_zero" value="Y">
                <input type="hidden" name="accid_serv_amt1" value="0">
                <input type="hidden" name="accid_serv_amt2" value="0">
                <%}else{%>
                <tr> 
                    <td colspan="2" class=title>사고수리비1</td>
                    <td>&nbsp;-</td>
                    <td><%=AddUtil.parseDecimal(String.valueOf(ht.get("ACCID_SERV_AMT1")))%>원<input type="hidden" name="accid_serv_amt1" value="<%=ht.get("ACCID_SERV_AMT1")%>"></td>
                </tr>                
                <tr> 
                    <td colspan="2" class=title>사고수리비2</td>
                    <td>&nbsp;-</td>
                    <td><%=AddUtil.parseDecimal(String.valueOf(ht.get("ACCID_SERV_AMT2")))%>원<input type="hidden" name="accid_serv_amt2" value="<%=ht.get("ACCID_SERV_AMT2")%>"></td>
                </tr>     
                <input type="hidden" name="accid_serv_zero" value="N">
                <%}%>
            </table>
        </td>
    </tr>
    <tr> 
      <td align=center colspan="2">&nbsp;</td>
    </tr>
    <tr> 
      <td align=center colspan="2"><a href="javascript:EstiReg();"><img src=/acar/images/center/button_est.gif border=0 align=absmiddle></a> 
      </td>
    </tr>
  </form>
</table>
<iframe src="about:blank" name="i_no2" width="0" height="0" frameborder="0" noresize></iframe>
<script>
<!--	
	var fm = document.form1;
	
	<%if(!est_st.equals("2") && !cng_item.equals("taecha")){%>
	
	<%	if(!rg_8.equals("0")){%>
	fm.rg_8.value 		= <%=rg_8%>;
	fm.rg_8_amt.value 	= parseDecimal(Math.round(<%=o_1%>*<%=rg_8%> / 100 / 1000) * 1000);
	<%	}%>
		
	if(toInt(<%=String.valueOf(ht.get("CAR_COMP_ID"))%>) > 5){
		fm.car_ja2.value 	= '500,000';
		fm.car_ja.value 	= '500,000';
		//fm.ins_per.value	= '2';
		fm.ins_per.value	= '1';
	}
	
	set_car_ext();
		
	<%}%>
	


	function set_car_ext(){
			
		//실등록지역		
		var udt_st = fm.f_udt_st.value;
		var br_id = '<%=acar_br%>';
		
		
		if(udt_st == ''){
			if(br_id =='S1') udt_st = '1';
			if(br_id =='B1') udt_st = '2';
			if(br_id =='D1') udt_st = '3';
		}
		
		var a_h = 1;
		var a_e = <%=a_e%>;
		var a_a = <%=a_a.substring(0,1)%>;
		var au28 = 0;
		var av28 = 0;
		if(a_e == 402 || a_e == 501 || a_e == 502 || a_e == 601 || a_e == 602) au28 = 1;//7-9인승2000cc초과짚여부
		if(a_e == 104 || a_e == 105 || a_e == 106 || a_e == 107 || a_e == 201) av28 = 1;//대형승용여부
		//[20110108] 경차여부(경승용,경상용)
		//if(a_e == 100 || a_e == 101 || a_e == 702 || a_e == 802) av28 = 1; 				
		if(a_a==1){//리스	
			if(av28==1){
				a_h = 4;	
			}else{
				if(au28==1){
					if(udt_st == '1') 		a_h = 1; //본사인수일때 서울
					else if(udt_st == '2') 	a_h = 4; //부산인수일대 경남
					else if(udt_st == '3') 	a_h = 4; //대전인수일때 경남
					else if(udt_st == '4') 	a_h = 1; //고객인수일대 서울
				}else{
					if(udt_st == '1') 		a_h = 2; //본사인수일때 경기
					else if(udt_st == '2') 	a_h = 4; //부산인수일대 경남
					else if(udt_st == '3') 	a_h = 4; //대전인수일때 경남
					else if(udt_st == '4') 	a_h = 1; //고객인수일대 서울
				}
			}	
		}else{//렌트
			if(udt_st == '1') 				a_h = 2; //본사인수일때 경기
			else if(udt_st == '2') 			a_h = 4; //부산인수일대 경남
			else if(udt_st == '3') 			a_h = 4; //대전인수일때 경남
			else if(udt_st == '4') 			a_h = 2; //고객인수일대 경기
		}
		//인천지점 추가로 변경
		if(udt_st == '1') 					a_h = 7; //본사인수일때 인천
		else if(udt_st == '2') 			a_h = 4; //부산인수일대 경남
		else if(udt_st == '3') 			a_h = 4; //대전인수일때 경남
		else if(udt_st == '4') 			a_h = 7; //고객인수일대 경기
		
		
		fm.a_h.value 	= a_h;
		fm.udt_st.value = udt_st;
	}	
	
	<%if(st.equals("2")){ //기본견적시 바로 계산%>
	EstiRegAuto()
	<%}%>
//-->
</script>	
</body>
</html>
