<%@ page language="java" contentType="text/html;charset=euc-kr" %>
<%@ page import="java.util.*, acar.util.*, acar.common.*, acar.cont.*, acar.client.*, acar.car_office.*, acar.car_mst.*, acar.estimate_mng.*, acar.car_register.*"%> 
<jsp:useBean id="a_db" scope="page" class="acar.cont.AddContDatabase"/>
<jsp:useBean id="al_db" scope="page" class="acar.client.AddClientDatabase"/>
<jsp:useBean id="rs_db" scope="page" class="acar.res_search.ResSearchDatabase"/>
<jsp:useBean id="ej_bean" class="acar.estimate_mng.EstiJgVarBean" scope="page"/>
<%@ include file="/acar/cookies.jsp" %>

<%
	String auth_rw = request.getParameter("auth_rw")==null?"":request.getParameter("auth_rw");
	String user_id = request.getParameter("user_id")==null?ck_acar_id:request.getParameter("user_id");
	String br_id = request.getParameter("br_id")==null?acar_br:request.getParameter("br_id");
	
	if (auth_rw.equals("")) {
		auth_rw = rs_db.getAuthRw(ck_acar_id, "01", "01", "09");
	}
	
	String s_kd = request.getParameter("s_kd")==null?"":request.getParameter("s_kd");
	String t_wd = request.getParameter("t_wd")==null?"" :request.getParameter("t_wd");
	String andor = request.getParameter("andor")==null?"":request.getParameter("andor");
	String from_page = request.getParameter("from_page")==null?"":request.getParameter("from_page");
	String from_page2 = request.getParameter("from_page2")==null?"":request.getParameter("from_page2");
	String san_st = request.getParameter("san_st")==null?"":request.getParameter("san_st");
	
	String rent_mng_id = request.getParameter("rent_mng_id")==null?"":request.getParameter("rent_mng_id");
	String rent_l_cd = request.getParameter("rent_l_cd")==null?"":request.getParameter("rent_l_cd");
	
	CommonDataBase c_db = CommonDataBase.getInstance();
	AddCarMstDatabase cmb = AddCarMstDatabase.getInstance();
	EstiDatabase edb = EstiDatabase.getInstance();
	CarRegDatabase crd = CarRegDatabase.getInstance();
	CarOfficeDatabase cod = CarOfficeDatabase.getInstance();
	
	//계약기본정보
	ContBaseBean base = a_db.getCont(rent_mng_id, rent_l_cd);
	
	//계약기타정보		2018.02.12
	ContEtcBean cont_etc = a_db.getContEtc(rent_mng_id, rent_l_cd);
	
	//차량기본정보
	ContCarBean car 	= a_db.getContCarNew(rent_mng_id, rent_l_cd);
	
	//자동차기본정보
	CarMstBean cm_bean = cmb.getCarNmCase(String.valueOf(car.getCar_id()), String.valueOf(car.getCar_seq()));
	
	//고객정보
	ClientBean client = al_db.getNewClient(base.getClient_id());
	
	
	//출고정보
	ContPurBean pur = a_db.getContPur(rent_mng_id, rent_l_cd);
	
	//특판계출관리
	Hashtable pur_com = cod.getPurComCont(rent_mng_id, rent_l_cd);		
	
	//잔가변수NEW
	ej_bean = edb.getEstiJgVarCase(cm_bean.getJg_code(), "");
	
	String o_3 = edb.getEstiSikVarCase("1", "", "o_3");
	
	String valus = "?auth_rw="+auth_rw+"&user_id="+user_id+"&br_id="+br_id+
						"&s_kd="+s_kd+"&t_wd="+t_wd+"&andor="+andor+
						"&rent_mng_id="+rent_mng_id+"&rent_l_cd="+rent_l_cd+"&from_page="+from_page;
%>

<html>
<head><title>FMS</title>
<meta http-equiv="Content-Type" content="text/html; charset=euc-kr">
<script language='javascript' src='/include/common.js'></script>
<script language='javascript'>
<!--
	//세부리스트
	function sub_list(idx) {
		var fm = document.form1;
		var garnish_yn_opt_st = fm.garnish_yn_opt_st.value;
		var hook_yn_opt_st = fm.hook_yn_opt_st.value;
		var SUBWIN="search_esti_sub_list.jsp?from_page=/fms2/lc_rent/reset_car.jsp&idx="+idx+"&car_comp_id="+fm.car_comp_id.value+"&car_cd="+fm.car_cd.value+"&car_id="+fm.car_id.value+"&car_seq="+fm.car_seq.value+"&car_nm="+fm.car_nm.value+"&garnish_yn_opt_st="+garnish_yn_opt_st+"&hook_yn_opt_st="+hook_yn_opt_st;	
		window.open(SUBWIN, "SubList", "left=100, top=100, width=1100, height=600, scrollbars=yes, status=yes");
	}
	
	function update() {	
		var fm = document.form1;
		
		fm.car_cs_amt.value = fm.car_s_amt.value;
		fm.car_cv_amt.value = fm.car_v_amt.value;
		fm.car_c_amt.value 	= fm.car_amt.value;		
		
		fm.opt_cs_amt.value = fm.opt_s_amt.value;
		fm.opt_cv_amt.value = fm.opt_v_amt.value;
		fm.opt_c_amt.value 	= fm.opt_amt.value;		
		
		fm.col_cs_amt.value = fm.col_s_amt.value;
		fm.col_cv_amt.value = fm.col_v_amt.value;
		fm.col_c_amt.value 	= fm.col_amt.value;	
		
		fm.conti_rat_c.value = fm.conti_rat.value;
		
		if (fm.garnish_yn_opt_st.value == "Y") {
			if(fm.garnish_col.value == "") {
				alert("가니쉬 옵션이 포함되어 있습니다. 가니쉬 색상을 선택해주세요.");
				return;
			}
		}
		
		sum_dc_amt();
		sum_tax_amt();
		sum_car_c_amt();
		sum_car_f_amt();
		
		//20151116 신차인 경우 수동변속기 확인
		if (<%=base.getCar_gu()%> == '1') {
			var auto = 'M/T';
			
			if (fm.auto_yn.value == 'Y') {
				auto = 'A/T';
			}
						
			if (auto == 'M/T' && fm.car_b.value.indexOf('자동변속기') != -1) {
				auto = 'A/T';
			}
			if (auto == 'M/T' && fm.opt.value.indexOf('변속기') != -1) {
				auto = 'A/T';
			}
			if (auto == 'M/T' && fm.opt.value.indexOf('DCT') != -1) {
				auto = 'A/T';
			}
			if (auto == 'M/T' && fm.opt.value.indexOf('C-TECH') != -1) {
				auto = 'A/T';
			}	
			if (auto == 'M/T' && fm.opt.value.indexOf('A/T') != -1) {
				auto = 'A/T';
			}	
			if (auto == 'M/T' && fm.car_b.value.indexOf('무단 변속기') != -1) {
				auto = 'A/T';
			}
			
			if (auto == 'M/T') {
				if (!confirm('수동변속기 차량입니다. 수정하시겠습니까?')) {
					return;
				}
			}
			
			if(fm.pur_color.value != ''){
				alert('특판배정관리 등록분입니다. 차종,옵션,색상을 변경할 경우 협력업체관리-자체출고관리에서 계약변경 처리하십시오.');
				/*
				var old_car_name = replaceString('&nbsp;','',fm.old_car_nm.value);
				var new_car_name = fm.car_nm.value+' '+fm.car_name.value;			
				alert(old_car_name+'----->'+new_car_name);
				if(old_car_name != new_car_name || fm.old_opt.value != fm.opt.value || fm.old_color.value != fm.color.value || fm.old_in_col.value != fm.in_col.value || fm.old_garnish_col.value != fm.garnish_col.value){
					alert('특판배정에 있는 차종,옵션,색상중에 대여차량과 다른 항목이 있습니다. 변경분이면 수정후 협력업체관리-자체출고관리에서 배정(예정)도 변경하십시오.');
				}
				*/
			}
		}
				
		if (confirm('수정하시겠습니까?')) {					
			fm.action='lc_b_u_a.jsp';		
//			fm.target='i_no';
			fm.target='d_content';
			fm.submit();
		}		
		
		self.close();
	}
	
	function sum_dc_amt() {
		var fm = document.form1;
		fm.dc_c_amt.value = parseDecimal(toInt(parseDigit(fm.s_dc1_amt.value)) + toInt(parseDigit(fm.s_dc2_amt.value)) + toInt(parseDigit(fm.s_dc3_amt.value)) );		
		fm.dc_cs_amt.value = parseDecimal(sup_amt(toInt(parseDigit(fm.dc_c_amt.value))));
		fm.dc_cv_amt.value = parseDecimal(toInt(parseDigit(fm.dc_c_amt.value)) - toInt(parseDigit(fm.dc_cs_amt.value)));
	}
	
	//특소세전차량가 가져가기
	function setVar_o_123(car_price) {
		var fm = document.form1;
				
		var o_1 = car_price;
		
		//차종별 특소세율
		var o_2 = <%=ej_bean.getJg_3()%>;	
	
		<%if(base.getDlv_dt().equals("")){%>
		<%	if(!pur.getDlv_est_dt().equals("")){%>
				if(<%=pur.getDlv_est_dt()%> >= 20120911 && <%=pur.getDlv_est_dt()%> <= 20121231 && <%=cm_bean.getDpm()%> >= 2000)  o_2 = 0.0845;
				if(<%=pur.getDlv_est_dt()%> >= 20120911 && <%=pur.getDlv_est_dt()%> <= 20121231 && <%=cm_bean.getDpm()%> <  2000)  o_2 = 0.0455;
		<%	}%>				
		<%}else{%>
				if(<%=base.getDlv_dt()%> >= 20120911 && <%=base.getDlv_dt()%> <= 20121231 && <%=cm_bean.getDpm()%> >= 2000) o_2 = 0.0845;
				if(<%=base.getDlv_dt()%> >= 20120911 && <%=base.getDlv_dt()%> <= 20121231 && <%=cm_bean.getDpm()%> <  2000) o_2 = 0.0455;
		<%}%>
								
		//특소세전차량가 o_3 = o_1/(1+o_2), 차량가격/(1+특소세율);
		var o_3 = Math.round(<%=o_3%>);	
		
		fm.v_o_1.value = o_1;
		fm.v_o_2.value = o_2;
		fm.v_o_3.value = o_3;
				
	}
		
	//차량 특소세 합계
	function sum_tax_amt() {
		var fm = document.form1;
		
		if (toInt(parseDigit(fm.spe_tax.value)) >  0) {
			return; 
		}
		
		if (toInt(parseDigit(fm.car_f_amt.value)) == 0) {
			sum_car_f_amt(); 
		}
		
		var purc_gu = '<%=car.getPurc_gu()%>';		
		var car_st = '<%=base.getCar_st()%>';
		var s_st = fm.s_st.value;
		var dpm = fm.dpm.value;
		var car_c_price = toInt(parseDigit(fm.car_c_amt.value)) + toInt(parseDigit(fm.opt_c_amt.value)) + toInt(parseDigit(fm.col_c_amt.value));		
		var car_f_price = toInt(parseDigit(fm.car_f_amt.value)) - toInt(parseDigit(fm.dc_c_amt.value));
		
		var a_e = toInt(s_st);
		
		setVar_o_123(car_f_price);
		
		//차가
		var o_1 = toInt(fm.v_o_1.value);
		
		//차종별 특소세율
		var o_2 = toFloat(fm.v_o_2.value);
		
		//특소세전차량가
		var o_3 = toInt(fm.v_o_3.value);
					
		
		if (purc_gu == '1') {//과세1
			fm.spe_tax.value = parseDecimal(car_c_price-o_3);
			fm.pay_st.value = '1';
		} else {//과세2(면세)		
			if ('<%=cm_bean.getDuty_free_opt()%>' == '1' || (<%=base.getRent_dt()%> < 20190419 && ('<%=cm_bean.getS_st()%><%=cm_bean.getDiesel_yn()%>' == '1012' || '<%=cm_bean.getS_st()%><%=cm_bean.getDiesel_yn()%>' == '1022' || s_st == '301' || s_st =='302' || s_st == '300'))) {
				fm.spe_tax.value = parseDecimal(Math.round(o_1*o_2));
			} else {
				fm.spe_tax.value = parseDecimal(car_c_price-toInt(parseDigit(fm.car_f_amt.value)));
			}				
			fm.pay_st.value = '2'; 
		}
		fm.edu_tax.value = parseDecimal(toInt(parseDigit(fm.spe_tax.value))*(30/100));		
		fm.tot_tax.value 	= parseDecimal(toInt(parseDigit(fm.spe_tax.value)) + toInt(parseDigit(fm.edu_tax.value)) );			
	}
	
	//차량 소비자가 합계
	function sum_car_c_amt() {
		var fm = document.form1;		
		fm.tot_cs_amt.value = parseDecimal(toInt(parseDigit(fm.car_cs_amt.value)) + toInt(parseDigit(fm.opt_cs_amt.value)) + toInt(parseDigit(fm.col_cs_amt.value)) - toInt(parseDigit(fm.tax_dc_s_amt.value)));
		fm.tot_cv_amt.value = parseDecimal(toInt(parseDigit(fm.car_cv_amt.value)) + toInt(parseDigit(fm.opt_cv_amt.value)) + toInt(parseDigit(fm.col_cv_amt.value)) - toInt(parseDigit(fm.tax_dc_v_amt.value)));
		fm.tot_c_amt.value 	= parseDecimal(toInt(parseDigit(fm.tot_cs_amt.value)) + toInt(parseDigit(fm.tot_cv_amt.value)) );		
	}
	
	//차가 구입가 합계
	function sum_car_f_amt() {
		var fm = document.form1;
		
		var purc_gu = '<%=car.getPurc_gu()%>';		
		var car_st = '<%=base.getCar_st()%>';
		var s_st = fm.s_st.value;
		var dpm = fm.dpm.value;
		var car_price = toInt(parseDigit(fm.car_c_amt.value)) + toInt(parseDigit(fm.opt_c_amt.value)) + toInt(parseDigit(fm.col_c_amt.value));
		

		if (fm.dc_cs_amt.value == '' && fm.dc_c_amt.value != '0') {
			fm.dc_cs_amt.value = parseDecimal(sup_amt(toInt(parseDigit(fm.dc_c_amt.value))));
			fm.dc_cv_amt.value = parseDecimal(toInt(parseDigit(fm.dc_c_amt.value)) - toInt(parseDigit(fm.dc_cs_amt.value)));			
		}
		

		if (purc_gu == '') {
			alert("과세구분을 선택하십시오."); return; 
		}

		if (purc_gu == '1') {//과세1
			fm.car_fs_amt.value = fm.tot_cs_amt.value;
			fm.car_fv_amt.value = fm.tot_cv_amt.value;
			fm.car_f_amt.value = fm.tot_c_amt.value;
		} else {//과세2(면세)
			if ('<%=cm_bean.getDuty_free_opt()%>' == '1' || (<%=base.getRent_dt()%> < 20190419 && ('<%=cm_bean.getS_st()%><%=cm_bean.getDiesel_yn()%>' == '1012' || '<%=cm_bean.getS_st()%><%=cm_bean.getDiesel_yn()%>' == '1022' || s_st == '301' || s_st =='302' || s_st == '300'))) {
				fm.car_fs_amt.value = fm.tot_cs_amt.value;
				fm.car_fv_amt.value = fm.tot_cv_amt.value;
				fm.car_f_amt.value 	= fm.tot_c_amt.value;
			} else {
				var a_e = toInt(s_st);
				
				setVar_o_123(car_price);
	
				//차가
				var o_1 = toInt(fm.v_o_1.value);
	
				//차종별 특소세율
				var o_2 = toFloat(fm.v_o_2.value);
	
				//특소세전차량가
				var o_3 = toInt(fm.v_o_3.value);								

				fm.car_f_amt.value = parseDecimal(o_3);
				fm.car_fs_amt.value = parseDecimal(sup_amt(toInt(parseDigit(fm.car_f_amt.value))));
				fm.car_fv_amt.value = parseDecimal(toInt(parseDigit(fm.car_f_amt.value)) - toInt(parseDigit(fm.car_fs_amt.value)));			
			}				
		}
		
		fm.tot_fs_amt.value = parseDecimal(toInt(parseDigit(fm.car_fs_amt.value)) + toInt(parseDigit(fm.sd_cs_amt.value)) - toInt(parseDigit(fm.dc_cs_amt.value)) );
		fm.tot_fv_amt.value = parseDecimal(toInt(parseDigit(fm.car_fv_amt.value)) + toInt(parseDigit(fm.sd_cv_amt.value)) - toInt(parseDigit(fm.dc_cv_amt.value)) );
		fm.tot_f_amt.value 	= parseDecimal(toInt(parseDigit(fm.tot_fs_amt.value)) + toInt(parseDigit(fm.tot_fv_amt.value)) );							
	}	
	
//-->
</script>
</head>
<meta http-equiv="Content-Type" content="text/html; charset=euc-kr">
<link rel=stylesheet type="text/css" href="/include/table_t.css">
<body leftmargin="15">
<form name='form1' action='' method='post'>
<input type="hidden" name="auth_rw" value="<%=auth_rw%>">
<input type="hidden" name="user_id" value="<%=user_id%>">
<input type="hidden" name="br_id" value="<%=br_id%>">
<input type="hidden" name='s_kd' value='<%=s_kd%>'>
<input type="hidden" name='t_wd' value='<%=t_wd%>'>			
<input type="hidden" name='andor' value='<%=andor%>'>
<input type="hidden" name='from_page' value='<%=from_page%>'>   
<input type="hidden" name='from_page2' value='<%=from_page2%>'>   
<input type="hidden" name="rent_mng_id" value="<%=rent_mng_id%>">
<input type="hidden" name="rent_l_cd" value="<%=rent_l_cd%>">
<input type="hidden" name="car_comp_id" value="<%=cm_bean.getCar_comp_id()%>">
<input type="hidden" name="car_cd" value="<%=cm_bean.getCode()%>">
<input type="hidden" name="car_nm" value="<%=c_db.getNameById(cm_bean.getCar_comp_id()+cm_bean.getCode(),"CAR_MNG")%>">
<input type="hidden" name="idx" value="reset_car">
<input type="hidden" name="o_1" value="">  
<input type="hidden" name="o_1_s_amt" value="">  
<input type="hidden" name="o_1_v_amt" value="">  
<input type="hidden" name='s_st' value='<%=cm_bean.getS_st()%>'>
<input type="hidden" name='dpm' value='<%=cm_bean.getDpm()%>'>
  
<!--차가계산-->
<input type="hidden" name="car_cs_amt" value="<%=car.getCar_cs_amt()%>">  
<input type="hidden" name="car_cv_amt" value="<%=car.getCar_cv_amt()%>">
<input type="hidden" name="car_c_amt" value="<%=car.getCar_cs_amt()+car.getCar_cv_amt()%>">  
<input type="hidden" name="car_fs_amt" value="<%=car.getCar_fs_amt()%>">  
<input type="hidden" name="car_fv_amt" value="<%=car.getCar_fv_amt()%>">    
<input type="hidden" name="car_f_amt" value="<%=car.getCar_fs_amt()+car.getCar_fv_amt()%>">      
<input type="hidden" name="opt_cs_amt" value="<%=car.getOpt_cs_amt()%>">  
<input type="hidden" name="opt_cv_amt" value="<%=car.getOpt_cv_amt()%>">    
<input type="hidden" name="opt_c_amt" value="<%=car.getOpt_cs_amt()+car.getOpt_cv_amt()%>">    
<input type="hidden" name="sd_cs_amt" value="<%=car.getSd_cs_amt()%>">  
<input type="hidden" name="sd_cv_amt" value="<%=car.getSd_cv_amt()%>">    
<input type="hidden" name="sd_c_amt" value="<%=car.getSd_cs_amt()+car.getSd_cv_amt()%>">      
<input type="hidden" name="col_cs_amt" value="<%=car.getClr_cs_amt()%>">  
<input type="hidden" name="col_cv_amt" value="<%=car.getClr_cv_amt()%>">    
<input type="hidden" name="col_c_amt" value="<%=car.getClr_cs_amt()+car.getClr_cv_amt()%>">      
<input type="hidden" name="dc_cs_amt" value="<%=car.getDc_cs_amt()%>">  
<input type="hidden" name="dc_cv_amt" value="<%=car.getDc_cv_amt()%>">    
<input type="hidden" name="dc_c_amt" value="<%=car.getDc_cs_amt()+car.getDc_cv_amt()%>">        
<input type="hidden" name="tax_dc_s_amt" value="<%=car.getTax_dc_s_amt()%>">  
<input type="hidden" name="tax_dc_v_amt" value="<%=car.getTax_dc_v_amt()%>">    
<input type="hidden" name="tax_dc_amt" value="<%=car.getTax_dc_s_amt()+car.getTax_dc_v_amt()%>">          
<input type="hidden" name="spe_tax" value="<%=car.getSpe_tax()%>">  
<input type="hidden" name="edu_tax" value="<%=car.getEdu_tax()%>">
<input type="hidden" name="tot_tax" value="<%=car.getSpe_tax()+car.getEdu_tax()%>">  
<input type="hidden" name="pay_st" value="<%=car.getPay_st()%>">
<input type="hidden" name="tot_cs_amt" value="">
<input type="hidden" name="tot_cv_amt" value="">
<input type="hidden" name="tot_c_amt" value="">
<input type="hidden" name="tot_fs_amt" value="">
<input type="hidden" name="tot_fv_amt" value="">
<input type="hidden" name="tot_f_amt" value="">
<input type="hidden" name="v_o_1" value="">
<input type="hidden" name="v_o_2" value="">
<input type="hidden" name="v_o_3" value="">
<input type="hidden" name="jg_opt_st" value="<%=car.getJg_opt_st()%>">
<input type="hidden" name="jg_col_st" value="<%=car.getJg_col_st()%>">
<input type="hidden" name="jg_tuix_st" value="<%=car.getJg_tuix_st()%>">
<input type="hidden" name="jg_tuix_opt_st" value="<%=car.getJg_tuix_opt_st()%>">
<input type="hidden" name="lkas_yn" value="">				<!-- 차선이탈 제어형 (차종포함) 2017.12.27 추가-->
<input type="hidden" name="lkas_yn_opt_st" value="">	<!-- 차선이탈 제어형 (옵션) -->
<input type="hidden" name="ldws_yn" value="">				<!-- 차선이탈 경고형 (차종포함) -->
<input type="hidden" name="ldws_yn_opt_st" value="">	<!-- 차선이탈 경고형 (옵션) -->
<input type="hidden" name="aeb_yn" value="">				<!-- 긴급제동 제어형 (차종포함) -->
<input type="hidden" name="aeb_yn_opt_st" value="">	<!-- 긴급제동 제어형 (옵션) -->
<input type="hidden" name="fcw_yn" value="">				<!-- 긴급제동 경고형 (차종포함) -->
<input type="hidden" name="fcw_yn_opt_st" value="">	<!-- 긴급제동 경고형 (옵션) -->
<input type="hidden" name="garnish_yn" value="">				<!-- 가니쉬 여부 -->
<input type="hidden" name="garnish_yn_opt_st" value="">		<!-- 가니쉬 여부(옵션) -->
<input type="hidden" name="hook_yn" value="">				<!-- 견인고리 여부 -->
<input type="hidden" name="hook_yn_opt_st" value="">		<!-- 견인고리 여부(옵션) -->
<input type="hidden" name="lkas_yn_org" id="lkas_yn_org" value="<%=cont_etc.getLkas_yn()%>">		<!-- 차선이탈 제어형 기존 설정 값 2018.02.12 -->
<input type="hidden" name="ldws_yn_org" id="ldws_yn_org" value="<%=cont_etc.getLdws_yn()%>">	<!-- 차선이탈 경고형 기존 설정 값 -->
<input type="hidden" name="aeb_yn_org" id="aeb_yn_org" value="<%=cont_etc.getAeb_yn()%>">		<!-- 긴급제동 제어형 기존 설정 값 -->
<input type="hidden" name="fcw_yn_org" id="fcw_yn_org" value="<%=cont_etc.getFcw_yn()%>">		<!-- 긴급제동 경고형 기존 설정 값 -->
<input type="hidden" name="garnish_yn_org" id="garnish_yn_org" value="<%=cont_etc.getGarnish_yn()%>">		<!-- 가니쉬 기존 설정 값 -->
<input type="hidden" name="hook_yn_org" id="hook_yn_org" value="<%=cont_etc.getHook_yn()%>">		<!-- 견인고리 기존 설정 값 -->
<input type="hidden" name="legal_yn_org" id="legal_yn_org" value="<%=cont_etc.getLegal_yn()%>">		<!-- 법률관련비용보험 기존 설정 값 -->
<input type="hidden" name="conti_rat_c" value="<%=car.getConti_rat()%>"/>
<input type='hidden' name="san_st"			value="<%=san_st%>">

	<table border="0" cellspacing="0" cellpadding="0" width=100%>
		<tr>
			<td>
	            <table width=100% border=0 cellpadding=0 cellspacing=0>
	                <tr>
	                    <td width=7><img src=/acar/images/center/menu_bar_1.gif width=7 height=33></td>
	                    <td class=bar>&nbsp;&nbsp;&nbsp;<img src=/acar/images/center/menu_bar_dot.gif width=4 height=5 align=absmiddle>&nbsp;<span class=style1>영업지원 > 계약관리 > <span class=style5>미결계약</span></span></td>
	                    <td width=7><img src=/acar/images/center/menu_bar_2.gif width=7 height=33></td>
	                </tr>
	            </table>
	        </td>
	    </tr>
	    <tr>
	        <td class=h></td>
	    </tr>  	
		<tr>
	        <td class="line">
	        	<table border="0" cellspacing="1" cellpadding="0" width=100%>
		            <tr>
		            	<td class="title" width='13%'>계약번호</td>
		              	<td width='22%' align="center"><%=rent_l_cd%></td>
					  	<td class="title" width='13%'>상호</td>
		              	<td width='52%'>&nbsp;<%=client.getFirm_nm()%></td>
		            </tr>
	          	</table>
			</td>
	    </tr>    
		<tr>
			<td align="left"><img src=/acar/images/center/icon_arrow.gif align=absmiddle> <span class=style2>대여차량</span></td>
		</tr>
		<tr>
			<td class="line">
				<table border="0" cellspacing="1" cellpadding="0" width=100%>
					<tr> 
			            <td width="13%" class="title">항목</td>
			            <td width="70%" class="title">선택</td>
			            <td width="17%" class="title">금액</td>
		          	</tr>
		          	<tr>
			            <td class="title">제작회사</td>
			            <td>&nbsp;<%=c_db.getNameById(cm_bean.getCar_comp_id(),"CAR_COM")%></td>
			            <td>&nbsp;</td>
		          	</tr>
		          	<tr> 
			            <td class="title">차명</td>
			            <td>&nbsp;<%=c_db.getNameById(cm_bean.getCar_comp_id()+cm_bean.getCode(),"CAR_MNG")%></td>
			            <td>&nbsp;</td>
		          	</tr>
		          	<tr> 
			            <td class="title">차종</td>
			            <td>
			            	<table width="100%" border="0" cellpadding="0">
				                <tr>
				                	<td id=td_31 style="display:''">&nbsp;                    
										<a href="javascript:sub_list('1');"><img src=/acar/images/center/button_in_choice.gif align=absmiddle border=0></a>					
								  	</td>
				                  	<td id=td_32 style="display:''">&nbsp;
									  	<input type="text" name="car_name" size='60' class='fix' value="<%=cm_bean.getCar_name()%>" readonly>
								  		<input type="hidden" name='car_id' value='<%=cm_bean.getCar_id()%>'>
								  		<input type="hidden" name='car_seq' value='<%=cm_bean.getCar_seq()%>'>
										<input type="hidden" name='car_s_amt' value='<%=AddUtil.parseDecimal(car.getCar_cs_amt())%>'>
										<input type="hidden" name='car_v_amt' value='<%=AddUtil.parseDecimal(car.getCar_cv_amt())%>'>
										<input type="hidden" name='auto_yn' value='<%=cm_bean.getAuto_yn()%>'>
										<input type="hidden" name='car_b' value='<%=cm_bean.getCar_b()%>'>
										<input type="hidden" name="old_car_nm" value="<%=c_db.getNameById(cm_bean.getCar_comp_id()+cm_bean.getCode(),"CAR_MNG")%> <%=cm_bean.getCar_name()%>">
										<input type="hidden" name="old_opt" value="<%=car.getOpt()%>">					
					                    <input type="hidden" name="old_color" value="<%=car.getColo()%>">
				                        <input type="hidden" name="old_in_col" value="<%=car.getIn_col()%>">
					                    <input type="hidden" name="old_garnish_col" value="<%=car.getGarnish_col()%>">  
									</td>
				                </tr>
							</table>
			            </td>
			            <td align="center">
			            	<input type="text" name='car_amt' size='10' value='<%=AddUtil.parseDecimal(car.getCar_cs_amt()+car.getCar_cv_amt())%>' maxlength='15' class='fixnum' readonly> 원
					  	</td>
					</tr>
		          	<tr> 
		            	<td class="title">옵션</td>
		            	<td>
						  	<table width="100%" border="0" cellpadding="0">
				                <tr>
					                <td id=td_41 style="display:''">&nbsp;
									<a href="javascript:sub_list('2');"><img src=/acar/images/center/button_in_choice.gif align=absmiddle border=0></a>
					                </td>
					                <td id=td_42 style="display:''">&nbsp;
									<input type="text" name="opt" size='60' class='fix' value="<%=car.getOpt()%>" readonly>
									<input type="hidden" name='opt_seq' value='<%=car.getOpt_code()%>'>
									<input type="hidden" name='opt_s_amt' value='<%=AddUtil.parseDecimal(car.getOpt_cs_amt())%>'>
									<input type="hidden" name='opt_v_amt' value='<%=AddUtil.parseDecimal(car.getOpt_cv_amt())%>'>
									</td>
				                </tr>
			              	</table>
		            	</td>
		            	<td align="center">
		            		<input type="text" name='opt_amt' size='10' value='<%=AddUtil.parseDecimal(car.getOpt_cs_amt()+car.getOpt_cv_amt())%>' maxlength='13' class='fixnum' readonly> 원
		            		<input type="hidden" name='opt_amt_m' value='<%=AddUtil.parseDecimal(car.getOpt_amt_m())%>' readonly>
		            	</td>
		          	</tr>
		          	<tr>
		            	<td class="title">색상</td>
		            	<td>
			            	<table width="100%" border="0" cellpadding="0">
				                <tr>
									<td id=td_51 style="display:''">&nbsp;
										<a href="javascript:sub_list('3');"><img src=/acar/images/center/button_in_choice.gif align=absmiddle border=0></a>
									</td>
				                  	<td id=td_52 style="display:''">&nbsp;
				                  		외장 <input type="text" name="col" size='40' class='text' value="<%=car.getColo()%>">
									  	내장 <input type="text" name="in_col" size='20' class='text' value="<%=car.getIn_col()%>">				  
									  	가니쉬 <input type="text" name="garnish_col" size='20' class='text' value="<%=car.getGarnish_col()%>">				  
									  	<input type="hidden" name='col_seq' value=''>
									  	<input type="hidden" name='col_s_amt' value='<%=AddUtil.parseDecimal(car.getClr_cs_amt())%>'>
									  	<input type="hidden" name='col_v_amt' value='<%=AddUtil.parseDecimal(car.getClr_cv_amt())%>'>
									</td>
				                </tr>
			              	</table>
		            	</td>
		            	<td align="center">
		            		<input type="text" name='col_amt' size='10' value='<%=AddUtil.parseDecimal(car.getClr_cs_amt()+car.getClr_cv_amt())%>' maxlength='13' class='fixnum' readonly> 원
					  	</td>
		          	</tr>
		          	<tr>
		          		<td class="title">연비</td>
			          	<td>			          		
			          		<table width="100%" border="0" cellpadding="0">
			          			<tr>
			          				<td id=td_41 style="display:''">&nbsp;
								    	<a href="javascript:sub_list('5');"><img src=/acar/images/center/button_in_choice.gif align=absmiddle border=0></a>
				                  	</td>
				                  	<td>
					                  	<input type="text" name="conti_rat" size='60' class='fix'  value="<%=car.getConti_rat()%>">				  
									  	<input type="hidden" name='conti_rat_seq' value=''>
								  	</td>
				                </tr>
			              	</table>
			          	</td>
		          		<td></td>
		          	</tr>
		        </table>
			</td>
	    </tr>
		<tr>
			<td align="left"><img src=/acar/images/center/icon_arrow.gif align=absmiddle> <span class=style2>매출D/C</span></td>
		</tr>
		<tr>
			<td class="line">
				<table border="0" cellspacing="1" cellpadding="0" width=100%>
					<tr>
						<td class="title" width='13%'> 연번 </td>
						<td class="title">내용</td>
						<td width="17%" class="title">대여료반영여부</td>
					    <td width="17%" class="title">금액</td>
				    </tr>
					<tr>
						<td align="center">1</td>
						<td align="center">
							<input type="text" name='s_dc1_re' size='75' class="text" value='<%=car.getS_dc1_re()%>'>
						</td>
						<td align="center">
							<select name='s_dc1_yn'>
								<option value="">선택</option>
	                            <option value="Y" <%if(car.getS_dc1_yn().equals("Y")) out.println("selected");%>>반영</option>
	                            <option value="N" <%if(car.getS_dc1_yn().equals("N")) out.println("selected");%>>미반영</option>
	                        </select>
	                    </td>					
					    <td align="center">
					    	<input type="text" name='s_dc1_amt' size='10' value='<%=AddUtil.parseDecimal(car.getS_dc1_amt())%>' maxlength='13' class='num' onBlur='javascript:this.value=parseDecimal(this.value);'> 원
	     				</td>
				    </tr>
					<tr>
						<td align="center">2</td>
						<td align="center">
							<input type="text" name='s_dc2_re' size='75' class="text" value='<%=car.getS_dc2_re()%>'>
						</td>
						<td align="center">
							<select name='s_dc2_yn'>
								<option value="">선택</option>
                           		<option value="Y" <%if(car.getS_dc2_yn().equals("Y")) out.println("selected");%>>반영</option>
	                            <option value="N" <%if(car.getS_dc2_yn().equals("N")) out.println("selected");%>>미반영</option>
	                        </select>
	                    </td>					
					    <td align="center">
					    	<input type="text" name='s_dc2_amt' size='10' value='<%=AddUtil.parseDecimal(car.getS_dc2_amt())%>' maxlength='13' class='num' onBlur='javascript:this.value=parseDecimal(this.value);'> 원
   					 	</td>
				    </tr>
					<tr>
						<td align="center">3</td>
						<td align="center">
							<input type="text" name='s_dc3_re' size='75' class="text" value='<%=car.getS_dc3_re()%>'>
						</td>
						<td align="center">
							<select name='s_dc3_yn'>
								<option value="">선택</option>
	                            <option value="Y" <%if(car.getS_dc3_yn().equals("Y")) out.println("selected");%>>반영</option>
	                            <option value="N" <%if(car.getS_dc3_yn().equals("N")) out.println("selected");%>>미반영</option>
	                        </select>
	                    </td>					
					    <td align="center">
					    	<input type="text" name='s_dc3_amt' size='10' value='<%=AddUtil.parseDecimal(car.getS_dc3_amt())%>' maxlength='13' class='num' onBlur='javascript:this.value=parseDecimal(this.value);'> 원
	     				</td>
				    </tr>
			  	</table>
			</td>
		</tr>	
    <%if(!String.valueOf(pur_com.get("RENT_L_CD")).equals("") && !String.valueOf(pur_com.get("RENT_L_CD")).equals("null") && !String.valueOf(pur_com.get("USE_YN_ST")).equals("해지")){%>
	<tr>
        <td><font color='red'>※ 특판배정관리 등록분입니다. 차종,옵션,색상을 변경할 경우 협력업체관리-자체출고관리에서 계약변경 처리하십시오.</font></td>
    </tr> 
    <input type="hidden" name="pur_color" value="<%=pur_com.get("R_COLO")%>">   
    <%}else{ %>
    <input type="hidden" name="pur_color" value="">
	<%} %>				
		<tr>
			<td>※ 수정후 차량가격-구입가격 [계산]을 클릭하여 다시하고 수정하십시오. 대여요금 변동분이 있으면 수정하십시오.</td>
		</tr>
	    <tr>
		  	<td align="right">
		  		<%if(!san_st.equals("요청") ||   auth_rw.equals("2") || auth_rw.equals("4") || auth_rw.equals("6")) {%>
		     	<a href="javascript:update()"><img src=/acar/images/center/button_modify.gif align=absmiddle border=0></a>&nbsp;&nbsp;
		     	<%}%>
		     	<a href="javascript:self.close();"><img src=/acar/images/center/button_close.gif align=absmiddle border=0></a>
		  </td>
		</tr>
	</table>
</form>
<iframe src="about:blank" name="i_no" width="0" height="0" frameborder="0" noresize></iframe>
</body>
</html>