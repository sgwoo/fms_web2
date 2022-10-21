<%@ page language="java" contentType="text/html; charset=euc-kr" %>
<%@ page import="java.util.*, acar.util.*, acar.car_mst.*, acar.estimate_mng.*" %>
<jsp:useBean id="cm_bean" class="acar.car_mst.CarMstBean" scope="page"/>
<jsp:useBean id="co_bean" class="acar.car_mst.CarOptBean" scope="page"/>
<jsp:useBean id="ej_bean" class="acar.estimate_mng.EstiJgVarBean" scope="page"/>
<%@ include file="/acar/cookies.jsp" %>

<%
	String auth_rw 	= request.getParameter("auth_rw")==null?"":request.getParameter("auth_rw");
	String br_id 		= request.getParameter("br_id")==null?"":request.getParameter("br_id");
	String user_id 	= request.getParameter("user_id")==null?"":request.getParameter("user_id");
	
	String view_dt 		= request.getParameter("view_dt")	==null?"":request.getParameter("view_dt");
	String t_wd 			= request.getParameter("t_wd")		==null?"":request.getParameter("t_wd");
	String t_wd2 			= request.getParameter("t_wd2")		==null?"":request.getParameter("t_wd2");
	String t_wd3 			= request.getParameter("t_wd3")		==null?"":request.getParameter("t_wd3");
	String t_wd4 			= request.getParameter("t_wd4")		==null?"":request.getParameter("t_wd4");
	String t_wd5 			= request.getParameter("t_wd5")		==null?"":request.getParameter("t_wd5");
	String gubun1 		= request.getParameter("gubun1")	==null?"1":request.getParameter("gubun1");
	String s_car_id 	= request.getParameter("s_car_id")	==null?"":request.getParameter("s_car_id");
	String sort_gubun = request.getParameter("sort_gubun")	==null?"":request.getParameter("sort_gubun");
	String asc 				= request.getParameter("asc")		==null?"":request.getParameter("asc");
	
	String car_id 		= request.getParameter("car_id")==null?"":request.getParameter("car_id");
	String car_seq 		= request.getParameter("car_seq")==null?"":request.getParameter("car_seq");
	String cmd 				= request.getParameter("cmd")==null?"":request.getParameter("cmd");
	String car_comp_id= request.getParameter("car_comp_id")==null?"":request.getParameter("car_comp_id");
	String car_cd 		= request.getParameter("code")==null?"":request.getParameter("code");	
	String car_b_inc_name = request.getParameter("car_b_inc_name")==null?"":request.getParameter("car_b_inc_name");
	
	int count = 0;
	
	EstiDatabase e_db = EstiDatabase.getInstance();
	AddCarMstDatabase a_cmb = AddCarMstDatabase.getInstance();
	
	cm_bean.setCar_comp_id		(car_comp_id);
	cm_bean.setCar_cd			(car_cd);
	cm_bean.setCar_id			(car_id);
	cm_bean.setCar_name			(request.getParameter("car_name")==null?"":request.getParameter("car_name"));
	cm_bean.setCar_b			(request.getParameter("car_b")==null?"":AddUtil.getSTRFilter(request.getParameter("car_b")));
	cm_bean.setCar_b_p			(request.getParameter("car_b_p")==null?0:AddUtil.parseDigit(request.getParameter("car_b_p")));
	cm_bean.setCar_b_dt			(request.getParameter("car_b_dt")==null?"":request.getParameter("car_b_dt"));
	cm_bean.setCar_yn			(request.getParameter("use_yn")==null?"Y":request.getParameter("use_yn"));
	if(!car_b_inc_name.equals("")){
		cm_bean.setCar_b_inc_id		(request.getParameter("car_b_inc_id")==null?"":request.getParameter("car_b_inc_id"));
		cm_bean.setCar_b_inc_seq	(request.getParameter("car_b_inc_seq")==null?"":request.getParameter("car_b_inc_seq"));
	}
	cm_bean.setJg_code			(request.getParameter("r_jg_code")==null?"":request.getParameter("r_jg_code"));
	cm_bean.setAuto_yn			(request.getParameter("auto_yn")==null?"":request.getParameter("auto_yn"));
	cm_bean.setAir_ds_yn		(request.getParameter("air_ds_yn")	==null?"":request.getParameter("air_ds_yn"));
	cm_bean.setAir_as_yn		(request.getParameter("air_as_yn")	==null?"":request.getParameter("air_as_yn"));
	cm_bean.setEnd_dt			(request.getParameter("end_dt")==null?"":request.getParameter("end_dt"));
	cm_bean.setDpm				(request.getParameter("dpm")==null?0:AddUtil.parseDigit(request.getParameter("dpm")));
	cm_bean.setEtc				(request.getParameter("etc")==null?"":request.getParameter("etc"));
	cm_bean.setCar_y_form		(request.getParameter("car_y_form")==null?"":request.getParameter("car_y_form"));
	cm_bean.setJg_tuix_st		(request.getParameter("jg_tuix_st")==null?"":request.getParameter("jg_tuix_st"));
	cm_bean.setLkas_yn			(request.getParameter("lkas_yn")==null?"":request.getParameter("lkas_yn"));
	cm_bean.setLdws_yn			(request.getParameter("ldws_yn")==null?"":request.getParameter("ldws_yn"));
	cm_bean.setAeb_yn			(request.getParameter("aeb_yn")==null?"":request.getParameter("aeb_yn"));
	cm_bean.setFcw_yn			(request.getParameter("fcw_yn")==null?"":request.getParameter("fcw_yn"));
	//cm_bean.setHook_yn			(request.getParameter("hook_yn")==null?"":request.getParameter("hook_yn"));
	cm_bean.setEtc2				(request.getParameter("etc2")==null?"":request.getParameter("etc2"));		//기타 추가(2018.02.08)
	cm_bean.setCar_y_form2		(request.getParameter("car_y_form2")==null?"":request.getParameter("car_y_form2"));
	cm_bean.setCar_y_form3		(request.getParameter("car_y_form3")==null?"":request.getParameter("car_y_form3"));
	cm_bean.setDuty_free_opt	(request.getParameter("duty_free_opt")==null?"":request.getParameter("duty_free_opt"));
	cm_bean.setCar_y_form_yn	(request.getParameter("car_y_form_yn")==null?"":request.getParameter("car_y_form_yn"));//신차견적서 연형표기여부(20190610)
	
	
	//잔가변수NEW
	ej_bean = e_db.getEstiJgVarCase(cm_bean.getJg_code(), "");
	
	
	cm_bean.setEst_yn				(cm_bean.getCar_yn());
	cm_bean.setHp_yn				(request.getParameter("hp_yn")==null?"Y":request.getParameter("hp_yn"));
	
	if(cm_bean.getEnd_dt().equals("N") && cm_bean.getHp_yn().equals("Y")){
		cm_bean.setHp_yn		("N");
	}	
	
	
	if(ej_bean.getJg_b().equals("1")) 			cm_bean.setDiesel_yn("Y");
	else if(ej_bean.getJg_b().equals("2")) 		cm_bean.setDiesel_yn("2");
	else if(ej_bean.getJg_b().equals("3")) 		cm_bean.setDiesel_yn("3");//하이브리드
	else if(ej_bean.getJg_b().equals("4")) 		cm_bean.setDiesel_yn("4");//플러그하이브리드
	else if(ej_bean.getJg_b().equals("5")) 		cm_bean.setDiesel_yn("5");//전기차		
	else if(ej_bean.getJg_b().equals("6")) 		cm_bean.setDiesel_yn("6");//수소차
	else if(ej_bean.getJg_b().equals("0")) 		cm_bean.setDiesel_yn("1");//휘발유
	else              							cm_bean.setDiesel_yn("1");
	
	cm_bean.setS_st					(ej_bean.getJg_a());
	cm_bean.setSection			(ej_bean.getJg_r());
	
	if(ej_bean.getJg_w().equals("1")){
		cm_bean.setCar_b_p2		(request.getParameter("car_b_p2")==null?0:AddUtil.parseDigit(request.getParameter("car_b_p2")));
		cm_bean.setR_dc_amt		(request.getParameter("r_dc_amt")==null?0:AddUtil.parseDigit(request.getParameter("r_dc_amt")));
		cm_bean.setL_dc_amt		(request.getParameter("l_dc_amt")==null?0:AddUtil.parseDigit(request.getParameter("l_dc_amt")));
		cm_bean.setR_cash_back(request.getParameter("r_cash_back")==null?0:AddUtil.parseDigit(request.getParameter("r_cash_back")));
		cm_bean.setL_cash_back(request.getParameter("l_cash_back")==null?0:AddUtil.parseDigit(request.getParameter("l_cash_back")));
		cm_bean.setR_card_amt	(request.getParameter("r_card_amt")==null?0:AddUtil.parseDigit(request.getParameter("r_card_amt")));
		cm_bean.setL_card_amt	(request.getParameter("l_card_amt")==null?0:AddUtil.parseDigit(request.getParameter("l_card_amt")));
		cm_bean.setR_bank_amt	(request.getParameter("r_bank_amt")==null?0:AddUtil.parseDigit(request.getParameter("r_bank_amt")));
		cm_bean.setL_bank_amt	(request.getParameter("l_bank_amt")==null?0:AddUtil.parseDigit(request.getParameter("l_bank_amt")));
	}
	
	car_id = a_cmb.insertCarNm(cm_bean);
	
	//차명정보
	cm_bean = a_cmb.getCarNmCase(car_id, "");
	
	//선택사항 업그레이드
	CarOptBean [] co_r = a_cmb.getCarOptList(car_comp_id, car_cd, car_id, car_seq, "");
	
	System.out.print("업그레이드 차량 선택사양 갯수:"+co_r.length + " car_id= "+ car_id );
	
	if(!cm_bean.getCar_seq().equals("")){
		for(int i=0; i<co_r.length; i++){
			co_bean = co_r[i];
			co_bean.setCar_u_seq(cm_bean.getCar_seq());
			co_bean.setCar_s_dt(request.getParameter("car_b_dt")==null?"":request.getParameter("car_b_dt"));
//			System.out.println("<###>");System.out.println(i);
			count = a_cmb.insertCarOpt(co_bean);
		}
		//이전차량 사용여부 변경
		count = a_cmb.updateCarNmYn(car_id, car_seq);
	}
%>
<html>
<head>

<title>FMS</title>
<link rel="stylesheet" type="text/css" href="/include/table_t.css"></link>
<script language="JavaScript">
<!--
//-->
</script>
</head>
<body>
<form action="car_mst_u.jsp" name="form1" method="POST">
  <input type="hidden" name="auth_rw" value="<%=auth_rw%>">
  <input type="hidden" name="br_id" value="<%=br_id%>">
  <input type="hidden" name="user_id" value="<%=user_id%>">
  <input type="hidden" name="view_dt" value="<%=view_dt%>">    
  <input type="hidden" name="t_wd" value="<%=t_wd%>">          
  <input type="hidden" name="t_wd2" value="<%= t_wd2 %>">  
  <input type="hidden" name="t_wd3" value="<%= t_wd3 %>">  
  <input type="hidden" name="t_wd4" value="<%= t_wd4 %>">
  <input type="hidden" name="t_wd5" value="<%= t_wd5 %>">
  <input type="hidden" name="gubun1" value="<%= gubun1 %>">  
  <input type="hidden" name="sort_gubun" value="<%= sort_gubun %>">
  <input type="hidden" name="asc" 	value="<%= asc %>">      
  <input type="hidden" name="s_car_id" value="<%=s_car_id%>">
  <input type="hidden" name="car_comp_id" value="<%=car_comp_id%>">
  <input type="hidden" name="code" value="<%=car_cd%>">
  <input type="hidden" name="car_id" value="<%=car_id%>">
  <input type="hidden" name="car_seq" value="<%=cm_bean.getCar_seq()%>">
  <input type="hidden" name="cmd" value="<%=cmd%>">
</form>
<script>
<%	if(!car_id.equals("")){%>
		alert("정상적으로 업그레이드되었습니다.");
		document.form1.target='d_content';
		document.form1.submit();				
<%	}%>
</script>
</body>
</html>
