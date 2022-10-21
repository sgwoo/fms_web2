<%@ page language="java" contentType="text/html; charset=euc-kr" %>
<%@ page import="java.util.*, acar.util.*, acar.car_mst.*, acar.estimate_mng.*, acar.secondhand.*, acar.user_mng.*, acar.cont.*, acar.car_mst.* " %>
<jsp:useBean id="a_db" scope="page" class="acar.cont.AddContDatabase"/>


<%
	String auth_rw 		= request.getParameter("auth_rw")	==null?"":request.getParameter("auth_rw");
	String br_id 		= request.getParameter("br_id")		==null?"":request.getParameter("br_id");
	String user_id 		= request.getParameter("user_id")	==null?"":request.getParameter("user_id");
	
	String s_kd 		= request.getParameter("s_kd")==null? "":request.getParameter("s_kd");
	String t_wd 		= request.getParameter("t_wd")==null? "" :request.getParameter("t_wd");
	String gubun1 		= request.getParameter("gubun1")==null?"":request.getParameter("gubun1");
	String gubun2 		= request.getParameter("gubun2")==null?"":request.getParameter("gubun2");
	String gubun3 		= request.getParameter("gubun3")==null?"":request.getParameter("gubun3");
	
	String car_mng_id 	= request.getParameter("car_mng_id")==null?"":request.getParameter("car_mng_id");
	
	String esti_nm 		= request.getParameter("esti_nm")	==null?"":request.getParameter("esti_nm");
	String a_a 			= request.getParameter("a_a")		==null?"22":request.getParameter("a_a");
	String a_b 			= request.getParameter("a_b")		==null?"":request.getParameter("a_b");
	String pp_st 		= request.getParameter("pp_st")		==null?"0":request.getParameter("pp_st");
	String g_10 		= request.getParameter("g_10")		==null?"":request.getParameter("g_10");
	String rg_8 		= request.getParameter("rg_8")		==null?"":request.getParameter("rg_8");
	String rg_8_amt		= request.getParameter("rg_8_amt")	==null?"":request.getParameter("rg_8_amt");
	String pp_per 		= request.getParameter("pp_per")	==null?"":request.getParameter("pp_per");
	String pp_amt		= request.getParameter("pp_amt")	==null?"":request.getParameter("pp_amt");
	String rent_st 		= request.getParameter("rent_st")	==null?"":request.getParameter("rent_st");
	String spr_yn 		= request.getParameter("spr_yn")	==null?"":request.getParameter("spr_yn");
	String lpg_yn 		= request.getParameter("lpg_yn")	==null?"":request.getParameter("lpg_yn");
	String lpg_kit 		= request.getParameter("lpg_kit")	==null?"0":request.getParameter("lpg_kit");
	String a_h 			= request.getParameter("a_h")		==null?"":request.getParameter("a_h");
	String udt_st		= request.getParameter("udt_st")	==null?"":request.getParameter("udt_st");
	String ins_dj 		= request.getParameter("ins_dj")	==null?"":request.getParameter("ins_dj");
	String ins_age 		= request.getParameter("ins_age")	==null?"":request.getParameter("ins_age");
	String ins_good 	= request.getParameter("ins_good")	==null?"":request.getParameter("ins_good");
	String gi_yn 		= request.getParameter("gi_yn")		==null?"":request.getParameter("gi_yn");
	String car_ja 		= request.getParameter("car_ja")	==null?"":request.getParameter("car_ja");
	String o_13 		= request.getParameter("o_13")		==null?"":request.getParameter("o_13");
	String ro_13 		= request.getParameter("ro_13")		==null?"":request.getParameter("ro_13");
	String ro_13_amt	= request.getParameter("ro_13_amt")	==null?"":request.getParameter("ro_13_amt");
	String o_1			= request.getParameter("o_1")		==null?"":request.getParameter("o_1");
	String fee_dc_per	= request.getParameter("fee_dc_per")==null?"":request.getParameter("fee_dc_per");
	String rent_dt 		= request.getParameter("rent_dt")	==null?"":request.getParameter("rent_dt");
	String st 			= request.getParameter("st")		==null?"":request.getParameter("st");
	String ins_per		= request.getParameter("ins_per")	==null?"1":request.getParameter("ins_per");
	String one_self		= request.getParameter("one_self")	==null?"":request.getParameter("one_self");
	
	if(ins_per.equals("")) ins_per = "1";
	
	String cust_nm 		= request.getParameter("cust_nm")==null?"":request.getParameter("cust_nm");
	String damdang_id	= request.getParameter("damdang_id")==null?"":request.getParameter("damdang_id");
	String cust_tel		= request.getParameter("cust_tel")==null?"":request.getParameter("cust_tel");
	String cust_fax 	= request.getParameter("cust_fax")==null?"":request.getParameter("cust_fax");
	
	String cmd 			= request.getParameter("cmd")		==null?"u":request.getParameter("cmd");
	String e_page 		= request.getParameter("e_page")	==null?"i":request.getParameter("e_page");
	String from_page 	= request.getParameter("from_page")	==null?"":request.getParameter("from_page");
	String esti_stat	= request.getParameter("esti_stat")	==null?"":request.getParameter("esti_stat");
	String est_st		= request.getParameter("est_st")	==null?"":request.getParameter("est_st");	
	String l_cd 		= request.getParameter("l_cd")		==null?"":request.getParameter("l_cd");
	String m_id 		= request.getParameter("m_id")		==null?"":request.getParameter("m_id");
	String rent_mng_id 	= request.getParameter("rent_mng_id")==null?"":request.getParameter("rent_mng_id");
	String rent_l_cd 	= request.getParameter("rent_l_cd")	==null?"":request.getParameter("rent_l_cd");
	String fee_rent_st 	= request.getParameter("fee_rent_st")==null?"":request.getParameter("fee_rent_st");
	String a_e 			= request.getParameter("a_e")		==null?"":request.getParameter("a_e");
	String est_from 	= request.getParameter("est_from")	==null?"":request.getParameter("est_from");
	String fee_opt_amt 	= request.getParameter("fee_opt_amt")==null?"":request.getParameter("fee_opt_amt");	
	String cng_item	 	= request.getParameter("cng_item")	==null?"":request.getParameter("cng_item");
	
	String est_id = "";
	String reg_code	 	= request.getParameter("reg_code")	==null?"":request.getParameter("reg_code");
	
	int ctr_s_amt	 	= request.getParameter("ctr_s_amt")	==null?0:AddUtil.parseDigit(request.getParameter("ctr_s_amt"));
	int ctr_v_amt	 	= request.getParameter("ctr_v_amt")	==null?0:AddUtil.parseDigit(request.getParameter("ctr_v_amt"));
	
	
	EstiDatabase e_db = EstiDatabase.getInstance();
	AddCarMstDatabase cmb = AddCarMstDatabase.getInstance();
	
	EstimateBean o_bean = new EstimateBean();
	
	//재리스 계산
	String  d_flag1 =  "";
	
	if(!reg_code.equals("")){
		
		//변수기준일자
		String jg_b_dt 	= e_db.getVar_b_dt("jg", rent_dt);
		String em_a_j 	= e_db.getVar_b_dt("em", rent_dt);
		String ea_a_j 	= e_db.getVar_b_dt("ea", rent_dt);
				
		//[1단계]신차 잔가율 계산
		d_flag1 =  e_db.call_sp_esti_janga(reg_code, jg_b_dt, em_a_j, ea_a_j, "");
					
		//[2단계]월대여료 계산
		d_flag1 =  e_db.call_sp_esti_feeamt(reg_code, jg_b_dt, em_a_j, ea_a_j, "");
		
		//[3단계]중도해지위약율 계산하기
		d_flag1 =  e_db.call_sp_esti_clsper(reg_code, jg_b_dt, em_a_j, ea_a_j, "");
		
		//원페이지에 값 넘기기
		o_bean = e_db.getEstimateCase(reg_code, "org");
		
		est_id = o_bean.getEst_id();
		
		//조정견적료
		o_bean.setCtr_s_amt	(o_bean.getFee_s_amt()+ctr_s_amt);
		o_bean.setCtr_v_amt	(o_bean.getFee_v_amt()+ctr_v_amt);		
		int count = e_db.updateEstimate(o_bean);
						
	}
	
	
%>
<html>
<head>

<title>FMS</title>
<meta http-equiv="content-type" content="text/html; charset=euc-kr">
<link rel="stylesheet" type="text/css" href="../../include/table_t.css">
<script language='JavaScript' src='/include/estimate.js'></script>
<script language="JavaScript">
<!--
	//견적서보기
	function go_esti_print_fms(){  
		var fm = document.form1;
		//fm.action = "/acar/main_car_hp/estimate_fms.jsp";
		//견적서 아닌 약정운행거리 변경시 월대여료 등 변동사항
		fm.action = "/fms2/lc_rent/rent_start_new_car_re_esti_frame.jsp";
		fm.submit();
	}		
//-->
</script>
</head>
<body>
<form action="" name="form1" method="POST" >
  <input type="hidden" name="auth_rw" 		value="<%=auth_rw%>">
  <input type="hidden" name="br_id" 		value="<%=br_id%>">
  <input type="hidden" name="user_id" 		value="<%=user_id%>">
  <input type="hidden" name="acar_id" 		value="<%=user_id%>">  
  <input type='hidden' name='s_kd'  		value='<%=s_kd%>'>
  <input type='hidden' name='t_wd' 			value='<%=t_wd%>'>			
  <input type='hidden' name='gubun1' 		value='<%=gubun1%>'>  
  <input type='hidden' name='gubun2' 		value='<%=gubun2%>'>  
  <input type='hidden' name='gubun3' 		value='<%=gubun3%>'>    
 
  <input type="hidden" name="car_mng_id" 	value="<%=car_mng_id%>">
  <input type="hidden" name="esti_nm"		value="<%=esti_nm%>">
  <input type="hidden" name="a_a"			value="<%=a_a%>">
  <input type="hidden" name="a_b"			value="<%=a_b%>">
  <input type="hidden" name="spr_yn" 		value="<%=spr_yn%>">
  <input type="hidden" name="lpg_yn" 		value="<%=lpg_yn%>">
  <input type="hidden" name="lpg_kit" 		value="<%=lpg_kit%>">
  <input type="hidden" name="st" 			value="<%=st%>">	
  <input type="hidden" name="est_id" 		value="<%=est_id%>">
  <input type="hidden" name="cmd" 			value="<%=cmd%>">
  <input type="hidden" name="e_page" 		value="<%=e_page%>">
  <input type="hidden" name="from_page" 	value="/acar/estimate_mng/esti_mng_u.jsp">
  <input type="hidden" name="est_from" 		value="<%=est_from%>">  
  <input type="hidden" name="l_cd" 			value='<%=l_cd%>'>		    
  <input type="hidden" name="m_id" 			value='<%=m_id%>'>
  <input type="hidden" name="fee_rent_st"	value='<%=fee_rent_st%>'>    
  <input type="hidden" name="rg_8" 			value="<%=rg_8%>">
  <input type="hidden" name="ins_good"		value="<%=ins_good%>">  
  <input type="hidden" name="reg_code"		value="<%=reg_code%>">   
  <input type="hidden" name="jg_b_dt"		value="<%//=jg_b_dt%>">   
  <input type="hidden" name="em_a_j"		value="<%//=em_a_j%>">   
  <input type="hidden" name="ea_a_j"		value="<%//=ea_a_j%>">         
  <input type="hidden" name="cng_item"		value="<%=cng_item%>">			   
  <input type="hidden" name="o_13" 			value="">
  <input type="hidden" name="ro_13_amt" 	value="">
  <input type="hidden" name="fee_amt" 		value="">
  <input type="hidden" name="fee_s_amt" 	value="">
  <input type="hidden" name="fee_v_amt" 	value="">
  <input type="hidden" name="ifee_s_amt" 	value="">
  <input type="hidden" name="ifee_v_amt" 	value="">
  <input type="hidden" name="pp_s_amt" 		value="">
  <input type="hidden" name="pp_v_amt" 		value="">          
  <input type="hidden" name="gtr_amt" 		value="">            
  <input type="hidden" name="gi_amt" 		value="">            
  <input type="hidden" name="gi_fee" 		value="">            
  <!--영업효율관련변수-->              
  <input type="hidden" name="bc_s_a" value="">
  <input type="hidden" name="bc_s_b" value="">
  <input type="hidden" name="bc_s_c" value="">
  <input type="hidden" name="bc_s_d" value="">
  <input type="hidden" name="bc_s_e" value="">
  <input type="hidden" name="bc_s_f" value="0">
  <input type="hidden" name="bc_s_g" value="">
  <input type="hidden" name="bc_s_i" value="0">  
  <input type="hidden" name="bc_b_a" value="">
  <input type="hidden" name="bc_b_b" value="">
  <input type="hidden" name="bc_b_d" value="">
  <input type="hidden" name="bc_b_e1" value="">
  <input type="hidden" name="bc_b_e2" value="">
  <input type="hidden" name="bc_b_k" value="">
  <input type="hidden" name="bc_b_n" value="0">
  <input type="hidden" name="one_self" value="<%=one_self%>">  

<%	
//차량기본정보
ContCarBean car = a_db.getContCarNew(o_bean.getRent_mng_id(), o_bean.getRent_l_cd());
//출고정보
ContPurBean pur = a_db.getContPur(o_bean.getRent_mng_id(), o_bean.getRent_l_cd());
//계약기타정보
ContEtcBean cont_etc = a_db.getContEtc(o_bean.getRent_mng_id(), o_bean.getRent_l_cd());
//자동차기본정보
CarMstBean cm_bean = cmb.getCarNmCase(String.valueOf(car.getCar_id()), String.valueOf(car.getCar_seq()));
//잔가변수NEW
EstiJgVarBean ej_bean = e_db.getEstiJgVarCase(cm_bean.getJg_code(), "");
%>

  <input type='hidden' name="s_dc1_re" 			value="<%=car.getS_dc1_re()%>">
  <input type='hidden' name="s_dc1_amt"			value="<%=car.getS_dc1_amt()%>">
  <input type='hidden' name="s_dc2_re" 			value="<%=car.getS_dc2_re()%>">
  <input type='hidden' name="s_dc2_amt"			value="<%=car.getS_dc2_amt()%>">
  <input type='hidden' name="s_dc3_re" 			value="<%=car.getS_dc3_re()%>">
  <input type='hidden' name="s_dc3_amt"			value="<%=car.getS_dc3_amt()%>">
  <input type='hidden' name="tax_dc_amt" 		value="<%=car.getTax_dc_s_amt()+car.getTax_dc_v_amt()%>">  
  <input type="hidden" name="ja_amt" value="0">
</form>
<script>
<!--

var fm = document.form1;


//차량가격 가져가기
function setCarPrice(st){
	var car_price = 0;
	if(st == 'car_c_price')		car_price = <%=car.getCar_cs_amt()+car.getCar_cv_amt()+car.getOpt_cs_amt()+car.getOpt_cv_amt()+car.getClr_cs_amt()+car.getClr_cv_amt()%>;
	if(st == 'car_price2')		car_price	= <%=car.getCar_cs_amt()+car.getCar_cv_amt()+car.getOpt_cs_amt()+car.getOpt_cv_amt()+car.getClr_cs_amt()+car.getClr_cv_amt()+car.getAdd_opt_amt()%>;
	return car_price;
}
//DC금액 가져가기
function setDcAmt2(car_price){
	var s_dc_amt = toInt(parseDigit(fm.s_dc1_amt.value))+toInt(parseDigit(fm.s_dc2_amt.value))+toInt(parseDigit(fm.s_dc3_amt.value));
	if(fm.s_dc1_re.value == '포인트DC')	s_dc_amt = s_dc_amt - toInt(parseDigit(fm.s_dc1_amt.value));
	if(fm.s_dc2_re.value == '포인트DC')	s_dc_amt = s_dc_amt - toInt(parseDigit(fm.s_dc2_amt.value));
	if(fm.s_dc3_re.value == '포인트DC')	s_dc_amt = s_dc_amt - toInt(parseDigit(fm.s_dc3_amt.value));		
	//수입차
	if('<%=ej_bean.getJg_w()%>'=='1'){ s_dc_amt = 0; }
	return s_dc_amt;
}	


	//20190513 차가를 견적 o_1가 아닌 계약관리 소비자가-DC 금액으로 한다.
	var car_price2 = setCarPrice('car_price2');
	
	var s_dc_amt = setDcAmt2(car_price2);
	
	car_price2 = car_price2 - s_dc_amt - toInt(parseDigit(parent.document.form1.tax_dc_amt.value));
	
	//20190816 특판은 견적서 차가
	<%if(o_bean.getRent_st().equals("1") && pur.getDir_pur_yn().equals("Y")){%>
		car_price2 = <%=o_bean.getO_1()%>;
	<%}%>
	
	//(조정)최대잔가	
	var ja_amt = parseDecimal(car_price2*<%=o_bean.getO_13()%>/100);
	
	fm.ja_amt.value	= ja_amt;
		
	go_esti_print_fms();		
//-->
</script>
</body>
</html>