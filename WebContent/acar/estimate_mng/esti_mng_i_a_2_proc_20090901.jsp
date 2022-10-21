<%@ page language="java" contentType="text/html; charset=euc-kr" %>
<%@ page import="java.util.*, acar.util.*, acar.estimate_mng.*, acar.secondhand.*, acar.cont.* " %>
<jsp:useBean id="shDb" class="acar.secondhand.SecondhandDatabase" scope="page"/>
<jsp:useBean id="a_db" scope="page" class="acar.cont.AddContDatabase"/>
<%@ include file="/acar/cookies.jsp" %>

<%
	String MEMBER_ID 	= request.getParameter("MEMBER_ID")	==null?"":request.getParameter("MEMBER_ID");
	String SAWON 		= request.getParameter("SAWON")		==null?"":request.getParameter("SAWON");
%>
<%
	String auth_rw 		= request.getParameter("auth_rw")	==null?"":request.getParameter("auth_rw");
	String br_id 		= request.getParameter("br_id")		==null?"":request.getParameter("br_id");
	String user_id 		= request.getParameter("user_id")	==null?"":request.getParameter("user_id");
	String gubun1 		= request.getParameter("gubun1")	==null?"":request.getParameter("gubun1");
	String gubun2 		= request.getParameter("gubun2")	==null?"":request.getParameter("gubun2");
	String gubun3 		= request.getParameter("gubun3")	==null?"1":request.getParameter("gubun3");
	String gubun4 		= request.getParameter("gubun4")	==null?"1":request.getParameter("gubun4");
	String s_dt 		= request.getParameter("s_dt")		==null?"":request.getParameter("s_dt");
	String e_dt 		= request.getParameter("e_dt")		==null?"":request.getParameter("e_dt");
	String s_kd 		= request.getParameter("s_kd")		==null?"":request.getParameter("s_kd");
	String t_wd 		= request.getParameter("t_wd")		==null?"":request.getParameter("t_wd");
	String base_dt 		= request.getParameter("base_dt")	==null?"":request.getParameter("base_dt");	
	String car_comp_id 	= request.getParameter("car_comp_id")	==null?"":request.getParameter("car_comp_id");	
	
	String cmd 		= request.getParameter("cmd")		==null?"":request.getParameter("cmd");
	String e_page 		= request.getParameter("e_page")	==null?"":request.getParameter("e_page");
	String from_page 	= request.getParameter("from_page")	==null?"":request.getParameter("from_page");
	String from_page2 	= request.getParameter("from_page2")		==null?"":request.getParameter("from_page2");
	String est_from 	= request.getParameter("est_from")	==null?"":request.getParameter("est_from");
	String esti_stat	= request.getParameter("esti_stat")	==null?"":request.getParameter("esti_stat");
	String l_cd 		= request.getParameter("l_cd")		==null?"":request.getParameter("l_cd");
	String m_id 		= request.getParameter("m_id")		==null?"":request.getParameter("m_id");
	String fee_rent_st 	= request.getParameter("fee_rent_st")	==null?"":request.getParameter("fee_rent_st");
	String add_rent_st 	= request.getParameter("add_rent_st")==null?"":request.getParameter("add_rent_st");
	String insur_per	= request.getParameter("insur_per")	==null?"":request.getParameter("insur_per");
	String one_self		= request.getParameter("one_self")	==null?"":request.getParameter("one_self");
	String reg_dt		= request.getParameter("reg_dt")	==null?"":request.getParameter("reg_dt");
	String action_st 	= request.getParameter("action_st")	==null?"":request.getParameter("action_st");
	String reg_code		= request.getParameter("reg_code")	==null?"":request.getParameter("reg_code");
	String est_code		= request.getParameter("est_code")	==null?"":request.getParameter("est_code");
	String esti_table	= request.getParameter("esti_table")	==null?"":request.getParameter("esti_table");
	String esti_type	= request.getParameter("esti_type")	==null?"":request.getParameter("esti_type");
	String jg_b_dt		= "";
	String em_a_j		= "";
	String ea_a_j		= "";
	
	if(esti_table.equals("")) 	esti_table 	= "estimate_hp";
	if(!est_code.equals("")) 	reg_code 	= est_code;
	
	EstiDatabase e_db = EstiDatabase.getInstance();
	
	String est_id[]  	= request.getParameterValues("est_id");
	int est_size 		= est_id.length;
	int count 			= 0;
	
	EstimateBean o_bean = new EstimateBean();
	
	Hashtable esti_exam = new Hashtable();
	
	if(est_size>0){
		
		EstimateBean a_bean = new EstimateBean();
		if(from_page.equals("main_car")){
			a_bean = e_db.getEstimateHpCase(est_id[0]);
		}else{
			a_bean = e_db.getEstimateCase(est_id[0]);
		}
		
		//변수기준일자
		jg_b_dt = e_db.getVar_b_dt("jg", a_bean.getRent_dt());
		em_a_j 	= e_db.getVar_b_dt("em", a_bean.getRent_dt());
		ea_a_j 	= e_db.getVar_b_dt("ea", a_bean.getRent_dt());
		
		
		//[1단계]신차 잔가율 계산
		String  d_flag1 =  e_db.call_sp_esti_janga(reg_code, jg_b_dt, em_a_j, ea_a_j, "");
			
		//[2단계]월대여료 계산
		String  d_flag2 =  e_db.call_sp_esti_feeamt(reg_code, jg_b_dt, em_a_j, ea_a_j, "");
			
		if(!est_from.equals("cmpadd")){
			//[3단계]중도해지위약율 계산하기
			String  d_flag3 =  e_db.call_sp_esti_clsper(reg_code, jg_b_dt, em_a_j, ea_a_j, "");
		}
		
		if(from_page.equals("main_car")){
			//20190124 20,000km 전기차/수소차 기본식 반납형 일괄처리
			//String  d_flag4 =  e_db.call_sp_esti_reg_ev(reg_code, jg_b_dt, em_a_j, ea_a_j, "");
		}

		
		//[4단계]계산값 넘기기
		if(from_page.equals("main_car")){
			//201512 기본적용주행거리 20000을 제외한 30000
			String reg_code2  = Long.toString(System.currentTimeMillis());			
			for(int i = 0 ; i < est_size ; i++){			
				EstimateBean a_bean2 = e_db.getEstimateHpCase(est_id[i]);
				a_bean2.setReg_code		(reg_code2);
				a_bean2.setAgree_dist	(30000);
				a_bean2.setEst_type		("J");
				a_bean2.setEst_id		(Long.toString(System.currentTimeMillis())+String.valueOf(i));
				int count2 = e_db.insertEstimateHp(a_bean2);		
				//비용비교 변수
				Hashtable sh_comp = new Hashtable();
				sh_comp.put("EST_ID", 	a_bean2.getEst_id());
				count2 = shDb.insertShCompareHpSimple(sh_comp);							
			}
			String  d_flag1_2 =  e_db.call_sp_esti_janga(reg_code2, jg_b_dt, em_a_j, ea_a_j, "");
			String  d_flag2_2 =  e_db.call_sp_esti_feeamt(reg_code2, jg_b_dt, em_a_j, ea_a_j, "");
			String  d_flag3_2 =  e_db.call_sp_esti_clsper(reg_code2, jg_b_dt, em_a_j, ea_a_j, "");
			//20190124 30,000km 전기차/수소차 기본식 반납형 일괄처리
			//String  d_flag4_2 =  e_db.call_sp_esti_reg_ev(reg_code2, jg_b_dt, em_a_j, ea_a_j, "");
			//--------------------------------------------------------------------------------------------------
			//201512 기본적용주행거리 20000을 제외한 40000
			String reg_code3  = Long.toString(System.currentTimeMillis());			
			for(int i = 0 ; i < est_size ; i++){			
				EstimateBean a_bean2 = e_db.getEstimateHpCase(est_id[i]);
				a_bean2.setReg_code		(reg_code3);
				a_bean2.setAgree_dist	(40000);
				a_bean2.setEst_type		("J");
				a_bean2.setEst_id		(Long.toString(System.currentTimeMillis())+String.valueOf(i));
				int count2 = e_db.insertEstimateHp(a_bean2);		
				//비용비교 변수
				Hashtable sh_comp = new Hashtable();
				sh_comp.put("EST_ID", 	a_bean2.getEst_id());
				count2 = shDb.insertShCompareHpSimple(sh_comp);							
			}
			String  d_flag1_3 =  e_db.call_sp_esti_janga (reg_code3, jg_b_dt, em_a_j, ea_a_j, "");
			String  d_flag2_3 =  e_db.call_sp_esti_feeamt(reg_code3, jg_b_dt, em_a_j, ea_a_j, "");
			String  d_flag3_3 =  e_db.call_sp_esti_clsper(reg_code3, jg_b_dt, em_a_j, ea_a_j, "");
			//20190124 40,000km 전기차/수소차 기본식 반납형 일괄처리
			//String  d_flag4_3 =  e_db.call_sp_esti_reg_ev(reg_code3, jg_b_dt, em_a_j, ea_a_j, "");
			//--------------------------------------------------------------------------------------------------
			//201905 10000 추가
			String reg_code4  = Long.toString(System.currentTimeMillis());			
			for(int i = 0 ; i < est_size ; i++){			
				EstimateBean a_bean2 = e_db.getEstimateHpCase(est_id[i]);
				a_bean2.setReg_code		(reg_code4);
				a_bean2.setAgree_dist	(10000);
				a_bean2.setEst_type		("J");
				a_bean2.setEst_id		(Long.toString(System.currentTimeMillis())+String.valueOf(i));
				int count2 = e_db.insertEstimateHp(a_bean2);		
				//비용비교 변수
				Hashtable sh_comp = new Hashtable();
				sh_comp.put("EST_ID", 	a_bean2.getEst_id());
				count2 = shDb.insertShCompareHpSimple(sh_comp);							
			}
			String  d_flag1_4 =  e_db.call_sp_esti_janga (reg_code4, jg_b_dt, em_a_j, ea_a_j, "");
			String  d_flag2_4 =  e_db.call_sp_esti_feeamt(reg_code4, jg_b_dt, em_a_j, ea_a_j, "");
			String  d_flag3_4 =  e_db.call_sp_esti_clsper(reg_code4, jg_b_dt, em_a_j, ea_a_j, "");
			//String  d_flag4_4 =  e_db.call_sp_esti_reg_ev(reg_code4, jg_b_dt, em_a_j, ea_a_j, "");
			//--------------------------------------------------------------------------------------------------
			//201905 15000 추가
			String reg_code5  = Long.toString(System.currentTimeMillis());			
			for(int i = 0 ; i < est_size ; i++){			
				EstimateBean a_bean2 = e_db.getEstimateHpCase(est_id[i]);
				a_bean2.setReg_code		(reg_code5);
				a_bean2.setAgree_dist	(15000);
				a_bean2.setEst_type		("J");
				a_bean2.setEst_id		(Long.toString(System.currentTimeMillis())+String.valueOf(i));
				int count2 = e_db.insertEstimateHp(a_bean2);		
				//비용비교 변수
				Hashtable sh_comp = new Hashtable();
				sh_comp.put("EST_ID", 	a_bean2.getEst_id());
				count2 = shDb.insertShCompareHpSimple(sh_comp);							
			}
			String  d_flag1_5 =  e_db.call_sp_esti_janga (reg_code5, jg_b_dt, em_a_j, ea_a_j, "");
			String  d_flag2_5 =  e_db.call_sp_esti_feeamt(reg_code5, jg_b_dt, em_a_j, ea_a_j, "");
			String  d_flag3_5 =  e_db.call_sp_esti_clsper(reg_code5, jg_b_dt, em_a_j, ea_a_j, "");
			//String  d_flag4_5 =  e_db.call_sp_esti_reg_ev(reg_code5, jg_b_dt, em_a_j, ea_a_j, "");
			//--------------------------------------------------------------------------------------------------
			//201905 25000 추가
			String reg_code6  = Long.toString(System.currentTimeMillis());			
			for(int i = 0 ; i < est_size ; i++){			
				EstimateBean a_bean2 = e_db.getEstimateHpCase(est_id[i]);
				a_bean2.setReg_code		(reg_code6);
				a_bean2.setAgree_dist	(25000);
				a_bean2.setEst_type		("J");
				a_bean2.setEst_id		(Long.toString(System.currentTimeMillis())+String.valueOf(i));
				int count2 = e_db.insertEstimateHp(a_bean2);		
				//비용비교 변수
				Hashtable sh_comp = new Hashtable();
				sh_comp.put("EST_ID", 	a_bean2.getEst_id());
				count2 = shDb.insertShCompareHpSimple(sh_comp);							
			}
			String  d_flag1_6 =  e_db.call_sp_esti_janga (reg_code6, jg_b_dt, em_a_j, ea_a_j, "");
			String  d_flag2_6 =  e_db.call_sp_esti_feeamt(reg_code6, jg_b_dt, em_a_j, ea_a_j, "");
			String  d_flag3_6 =  e_db.call_sp_esti_clsper(reg_code6, jg_b_dt, em_a_j, ea_a_j, "");
			//String  d_flag4_6 =  e_db.call_sp_esti_reg_ev(reg_code6, jg_b_dt, em_a_j, ea_a_j, "");
			//--------------------------------------------------------------------------------------------------								
			
		}else{
		
			//원페이지에 값 넘기기
			o_bean = e_db.getEstimateCase(reg_code, "org");
			
			//수입차일 경우 차가에서 DC반영제외
			if(AddUtil.parseInt(o_bean.getCar_comp_id()) >5){
				o_bean.setO_1(o_bean.getCar_amt()+o_bean.getOpt_amt()+o_bean.getCol_amt());
			} 
			
			esti_exam = e_db.getEstimateResultVar(o_bean.getEst_id(), "esti_exam");
		}
	}
	
	if(from_page.equals("car_rent")){
		
	}
%>
<html>
<head>

<title>FMS</title>
<meta http-equiv="content-type" content="text/html; charset=euc-kr">
<link rel="stylesheet" type="text/css" href="/include/table_t.css">
<script language='JavaScript' src='/include/estimate.js'></script>
<script language="JavaScript">
<!--
	function go_esti(){
		var fm = document.form1;
		fm.from_page.value = '/acar/estimate_mng/esti_mng_u.jsp';
		fm.action = "/acar/main_car_hp/estimate.jsp";
		fm.target = '_blank';
		fm.submit();
	}
	
	function go_esti_fms(){
		var fm = document.form1;
		fm.from_page.value = '/acar/estimate_mng/esti_mng_u.jsp';
		fm.action = "/acar/main_car_hp/estimate_fms.jsp";
		fm.target = '_blank';
		fm.submit();
	}	
//-->
</script>
</head>
<body>
<form action="" name="form1" method="POST" >     
  <input type="hidden" name="auth_rw" value="<%=auth_rw%>">
  <input type="hidden" name="br_id" value="<%=br_id%>">
  <input type="hidden" name="user_id" value="<%=user_id%>">
  <input type="hidden" name="acar_id" value="<%=o_bean.getReg_id()%>">
  <input type="hidden" name="gubun1" value="<%=gubun1%>">
  <input type="hidden" name="gubun2" value="<%=gubun2%>">
  <input type="hidden" name="gubun3" value="<%=gubun3%>">
  <input type="hidden" name="gubun4" value="<%=gubun4%>">
  <input type="hidden" name="s_dt" value="<%=s_dt%>">
  <input type="hidden" name="e_dt" value="<%=e_dt%>">
  <input type="hidden" name="s_kd" value="<%=s_kd%>">
  <input type="hidden" name="t_wd" value="<%=t_wd%>">
  <input type="hidden" name="base_dt" value="<%=base_dt%>">
  <input type="hidden" name="car_comp_id" value="<%=car_comp_id%>">  
  
  <input type="hidden" name="est_size" value="<%=est_size%>">
  <input type="hidden" name="cmd" value="<%=cmd%>">  
  <input type="hidden" name="e_page" value="<%=e_page%>">
  <input type="hidden" name="from_page" value="<%=from_page%>">
  <input type="hidden" name="est_from" value="<%=est_from%>">  
  <input type="hidden" name="MEMBER_ID" value='<%=MEMBER_ID%>'>
  <input type="hidden" name="SAWON" value='<%=SAWON%>'>		    
  <input type="hidden" name="m_id" value='<%=m_id%>'>
  <input type="hidden" name="l_cd" value='<%=l_cd%>'>		    
  <input type="hidden" name="rent_mng_id" value='<%=m_id%>'>
  <input type="hidden" name="rent_l_cd" value='<%=l_cd%>'>		    
  <input type="hidden" name="rent_st" value='<%=fee_rent_st%>'>    
  <input type="hidden" name="add_rent_st" value='<%=add_rent_st%>'>    
  <input type="hidden" name="one_self" value="<%=one_self%>">   
  <input type="hidden" name="reg_dt" value='<%=reg_dt%>'>    
  <input type="hidden" name="reg_code" value='<%=reg_code%>'>          
  <input type="hidden" name="est_id" value='<%=est_id[0]%>'>   
  <input type="hidden" name="jg_b_dt" value="<%=jg_b_dt%>">
  <input type="hidden" name="em_a_j" value="<%=em_a_j%>">
  <input type="hidden" name="ea_a_j" value="<%=ea_a_j%>">         
</form>
<script>
<!--
	<%if(from_page.equals("main_car")){%>
	
		<%if(action_st.equals("")||action_st.equals("h_a")){%>		
		
		alert('견적완료');	
		document.form1.target = 'd_content';						
		document.form1.action = "/acar/main_car/main_car_upd_20090901.jsp";
		document.form1.submit();		
				
		
		<%}else if(action_st.equals("h")||action_st.equals("r")){%>
		parent.window.close();
		<%}else if(action_st.equals("r_a")){%>
		alert('견적완료');			
		parent.location.href = '/acar/main_car/main_car_frame.jsp';
		parent.window.close();
		<%}%>
		
	<%}else if(from_page.equals("estimate_mng")){%>
	
		<%if(esti_type.equals("a")){%>
		document.form1.gubun1.value = '1';
		document.form1.gubun2.value = '';
		document.form1.gubun3.value = '';
		document.form1.gubun4.value = '2';
		document.form1.s_dt.value = '';
		document.form1.e_dt.value = '';		
		document.form1.target = 'd_content';						
		document.form1.action = "esti_mng_atype_u.jsp";
		document.form1.submit();		
		<%}else if(esti_type.equals("b")){%>
		document.form1.gubun1.value = '1';
		document.form1.gubun2.value = '';
		document.form1.gubun3.value = '';
		document.form1.gubun4.value = '2';
		document.form1.s_dt.value = '';
		document.form1.e_dt.value = '';		
		document.form1.target = 'd_content';						
		document.form1.action = "esti_mng_btype_u.jsp";
		document.form1.submit();		
		<%}else{%>
		document.form1.gubun1.value = '1';
		document.form1.gubun2.value = '';
		document.form1.gubun3.value = '';
		document.form1.gubun4.value = '2';
		document.form1.s_dt.value = '';
		document.form1.e_dt.value = '';		
		document.form1.target = 'd_content';						
		document.form1.action = "esti_mng_u.jsp";
		document.form1.submit();		
		go_esti_fms();		
		<%}%>
		
	<%}else{%>
	
		<%if(!o_bean.getEst_id().equals("")){%>
		
			alert('견적완료');
			
			
				
		//결과값 처리하기---------------------------------------------------------------


		<%	if(est_from.equals("cmpadd")){%>
		
		
			document.form1.target = 'd_content';
			
			if(document.form1.add_rent_st.value == 'a'){
				document.form1.action = "/fms2/lc_rent/lc_bc_add_u.jsp";
			}else if(document.form1.add_rent_st.value == 's'){
				document.form1.action = "/fms2/lc_rent/lc_bc_cls_u.jsp";
			}
						
			
			document.form1.submit();		
			

		
		<%	}else if(est_from.equals("cmp")){//영업효율결과값등록%>
		
				parent.document.form1.o_13.value 		= <%=o_bean.getO_13()%>;
				parent.document.form1.ro_13.value 		= <%=o_bean.getRo_13()%>;			
				parent.document.form1.ro_13_amt.value 		= parseDecimal(<%=o_bean.getRo_13_amt()%>);
				parent.opt_display();		
			
		<%	}else{%>
		
		<%		if(from_page.equals("car_rent")){//계약관리에서 호출%>
		
		<%			if(esti_stat.equals("account")){//견적하기
		
						//출고정보
						ContPurBean pur = a_db.getContPur(o_bean.getRent_mng_id(), o_bean.getRent_l_cd());
						//계약기타정보
						ContEtcBean cont_etc = a_db.getContEtc(o_bean.getRent_mng_id(), o_bean.getRent_l_cd());
		%>
		
						if(<%=o_bean.getRent_dt()%> >= 20141223){
							//표준 최대잔가
							parent.document.form1.b_max_ja.value 		= <%=o_bean.getB_o_13()%>;
						}
						
						//20190513 차가를 견적 o_1가 아닌 계약관리 소비자가-DC 금액으로 한다.
						var car_price2 = parent.setCarPrice('car_price2');
						var s_dc_amt = parent.setDcAmt2(car_price2);
						car_price2 = car_price2 - s_dc_amt - toInt(parseDigit(parent.document.form1.tax_dc_amt.value));
						//20190816 특판은 견적서 차가
						<%if(o_bean.getRent_st().equals("1") && pur.getDir_pur_yn().equals("Y")){%>
							car_price2 = <%=o_bean.getO_1()%>;							
						<%}%>
						
						//재리스
						if(parent.document.form1.car_gu.value != '1'){
							car_price2 	= toInt(parseDigit(parent.document.form1.sh_amt.value));
						}						
						//연장
						if(<%=o_bean.getRent_st()%> > 1){
							car_price2 = toInt(parseDigit(parent.document.form1.sh_amt.value));
							if(toInt(parseDigit(parent.document.form1.fee_opt_amt.value)) > 0) car_price2	= toInt(parseDigit(parent.document.form1.fee_opt_amt.value));
						}		
						
						//(조정)최대잔가
						parent.document.form1.max_ja.value 		= <%=o_bean.getO_13()%>;
						parent.document.form1.ja_amt.value 	= parseDecimal(car_price2*<%=o_bean.getO_13()%>/100);
		
						parent.document.form1.ja_s_amt.value 		= parseDecimal(sup_amt(toInt(parseDigit(parent.document.form1.ja_amt.value))));
						parent.document.form1.ja_v_amt.value 		= parseDecimal(toInt(parseDigit(parent.document.form1.ja_amt.value)) - toInt(parseDigit(parent.document.form1.ja_s_amt.value)));
			
						//적용잔가
						parent.document.form1.app_ja.value 		= <%=o_bean.getRo_13()%>;
			
						if(parent.document.form1.app_ja.value == parent.document.form1.opt_per.value){
							parent.document.form1.ja_r_amt.value 	= parent.document.form1.opt_amt.value;
							parent.document.form1.ja_r_s_amt.value 	= parent.document.form1.opt_s_amt.value;
							parent.document.form1.ja_r_v_amt.value 	= parent.document.form1.opt_v_amt.value;
						}else{
							parent.document.form1.ja_r_amt.value 	= parseDecimal(<%=o_bean.getRo_13_amt()%>);
							parent.document.form1.ja_r_s_amt.value 	= parseDecimal(sup_amt(toInt(parseDigit(parent.document.form1.ja_r_amt.value))));
							parent.document.form1.ja_r_v_amt.value 	= parseDecimal(toInt(parseDigit(parent.document.form1.ja_r_amt.value)) - toInt(parseDigit(parent.document.form1.ja_r_s_amt.value)));
						}
						
						parent.document.form1.inv_s_amt.value 		= parseDecimal(<%=o_bean.getFee_s_amt()%>);
						parent.document.form1.inv_v_amt.value 		= parseDecimal(<%=o_bean.getFee_v_amt()%>);
						parent.document.form1.inv_amt.value 		= parseDecimal(<%=o_bean.getFee_s_amt()+o_bean.getFee_v_amt()%>);
			
						parent.document.form1.cls_per.value 		= <%=o_bean.getCls_per()%>;
						parent.document.form1.cls_n_per.value 		= <%=o_bean.getCls_n_per()%>;
						
						if(<%=o_bean.getCls_per()%>>100 && <%=o_bean.getFee_s_amt()%> == -1){
							alert('위약금율이 100%를 초과하였습니다. 위약금율이 100% 이내가 되도록 보증금을 줄여주세요.');
						}
			
					
						
						if(<%=o_bean.getRent_dt()%> > 20130604){
							parent.document.form1.e_agree_dist.value 	= parseDecimal(<%=o_bean.getAgree_dist()%>);
							parent.document.form1.e_over_run_amt.value 	= parseDecimal(<%=o_bean.getOver_run_amt()%>);
							if(<%=o_bean.getRent_dt()%> > 20220414){
								parent.document.form1.e_rtn_run_amt.value 	= parseDecimal(<%=o_bean.getRtn_run_amt()%>);
							}	
							<%
								String e_agree_dist_yn = "매입옵션 없음(기본식,일반식)";
                  						if(o_bean.getOpt_chk().equals("1")){
                  							if(o_bean.getA_a().equals("12") || o_bean.getA_a().equals("22")){
                  								e_agree_dist_yn = "전액면제(기본식)";
                  							}else{
                  								if(AddUtil.parseInt(o_bean.getRent_dt()) > 20220414){
                  									e_agree_dist_yn = "40%만납부(일반식)";
                  								}else{
                  									e_agree_dist_yn = "50%만납부(일반식)";
                  								}
                  							}
                  						}
							%>
							parent.document.form1.e_agree_dist_yn.value 	= '<%=e_agree_dist_yn%>';
							
							if(<%=o_bean.getRent_dt()%> >= 20141223){
								parent.document.form1.e_agree_dist.value 	= parseDecimal(<%=o_bean.getB_agree_dist()%>);
								parent.document.form1.r_agree_dist.value 	= parseDecimal(<%=o_bean.getAgree_dist()%>);
							}
						}
						
						//20150512 DC율 계산해서 넘기기
						if(<%=o_bean.getRent_dt()%> >= 20150512){
							var dc_ra 	= 0;
							var fee_s_amt 	= toInt(parseDigit(parent.document.form1.fee_s_amt.value));
							var inv_s_amt 	= toInt(parseDigit(parent.document.form1.inv_s_amt.value));
							var ins_s_amt 	= toInt(parseDigit(parent.document.form1.ins_s_amt.value));
							var driver_add_s_amt 	= toInt(parseDigit(parent.document.form1.driver_add_amt.value));
							inv_s_amt = inv_s_amt+ins_s_amt+driver_add_s_amt;
							var k_so 	= <%=esti_exam.get("K_SO")%>;
							var ax117 	= <%=esti_exam.get("AX117")%>;
							if(fee_s_amt  > 0 && inv_s_amt> 0){
								dc_ra = (inv_s_amt-fee_s_amt) / (inv_s_amt-k_so-ax117) *100;
								parent.document.form1.dc_ra.value = parseFloatCipher3(dc_ra,1);
								parent.document.form1.dc_ra_amt.value = parseDecimal((inv_s_amt-fee_s_amt)*1.1);
							}							
						}else{
							parent.dc_fee_amt();
						}
						
					
						//20160822 친환경차 개소세 감면액   20190221 구매보조금을 재계산하지 않는다 선택시 처리 안함.
						if(<%=o_bean.getRent_dt()%> >= 20160822 && '<%=fee_rent_st%>'=='1' && '<%=o_bean.getEcar_pur_sub_yn()%>' != 'N'){
							if(<%=o_bean.getEcar_pur_sub_amt()%> > 0){
								parent.document.form1.ecar_pur_sub_amt.value 		= parseDecimal(<%=o_bean.getEcar_pur_sub_amt()%>);
								parent.document.form1.ecar_pur_sub_st.value 		= '<%=o_bean.getEcar_pur_sub_st()%>';
								parent.document.form1.h_ecar_pur_sub_amt.value 	= parseDecimal(<%=o_bean.getEcar_pur_sub_amt()%>);
								parent.document.form1.h_ecar_pur_sub_st.value 	= '<%=o_bean.getEcar_pur_sub_st()%>';
							}
							//계약승계는 제외
							if('<%=cont_etc.getRent_suc_dt()%>' == '' && <%=o_bean.getEcar_pur_sub_amt()%> > 0){
								parent.document.form1.tax_dc_amt.value 	= parseDecimal(<%=o_bean.getTax_dc_amt()%>);
								<%if(!from_page2.equals("/fms2/lc_rent/lc_b_s_12.jsp")){%>
								parent.set_car_amt(parent.document.form1.tax_dc_amt);
								<%}%>
								if(toInt(parseDigit(parent.document.form1.grt_s_amt.value)) >0){
									if(parent.document.form1.from_page.value == 'car_rent'){
										parent.set_fee_amt(parent.document.form1.grt_s_amt);
									}else{
										parent.set_fee_amt(parent.document.form1.grt_s_amt,'<%=o_bean.getRent_dt()%>');
									}
								}
							}
						}
						
					parent.setTinv_amt();
			
		<%			}else if(esti_stat.equals("view")){//보기%>
		
		<%			}%>
		
		<%		}%>		
		
		<%	}%>
		
		<%}else{%>		
		alert('견적오류발행!!');
		<%}%>
		
	<%}%>
//-->
</script>
</body>
</html>
