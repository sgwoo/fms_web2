<%@ page language="java" contentType="text/html; charset=euc-kr" %>
<%@ page import="java.util.*, acar.util.*, acar.estimate_mng.*" %>
<jsp:useBean id="bean" class="acar.estimate_mng.EstimateBean" scope="page"/>
<%@ include file="/smart/cookies.jsp" %>

<%
	EstiDatabase e_db = EstiDatabase.getInstance();
	
	String rent_mng_id 	= request.getParameter("rent_mng_id")==null?"":request.getParameter("rent_mng_id");
	String rent_l_cd 	= request.getParameter("rent_l_cd")	==null?"":request.getParameter("rent_l_cd");
	String car_mng_id 	= request.getParameter("car_mng_id")==null?"":request.getParameter("car_mng_id");
	String car_no 		= request.getParameter("car_no")	==null?"":request.getParameter("car_no");
	String from_page 	= request.getParameter("from_page")	==null?"":request.getParameter("from_page");
	
	String st 			= request.getParameter("st")		==null?"":request.getParameter("st");
	String page_kind 	= request.getParameter("page_kind")	==null?"":request.getParameter("page_kind");
	String damdang_id	= request.getParameter("damdang_id")==null?"":request.getParameter("damdang_id");
	String est_id 		= request.getParameter("est_id")	==null?"":request.getParameter("est_id");
	String esti_nm 		= request.getParameter("esti_nm")	==null?"":request.getParameter("esti_nm");
	
	
	if(page_kind.equals("homepage")){
		bean = e_db.getEstimateShCase(est_id);
	}else{
		bean = e_db.getEstimateCase(est_id);
	}
	
	
	int count = 0;
	
	String reg_code  = Long.toString(System.currentTimeMillis());
	
	
	bean.setA_a			(request.getParameter("a_a")==null?"":request.getParameter("a_a"));
	bean.setA_b			(request.getParameter("a_b")==null?"":request.getParameter("a_b"));
	
	bean.setEst_nm		(request.getParameter("est_nm")==null?"":request.getParameter("est_nm"));
	bean.setEst_ssn		(request.getParameter("est_ssn")==null?"":request.getParameter("est_ssn"));
	bean.setEst_tel		(request.getParameter("est_tel")==null?"":request.getParameter("est_tel"));
	bean.setEst_fax		(request.getParameter("est_fax")==null?"":request.getParameter("est_fax"));
	bean.setEst_email	(request.getParameter("est_email")==null?"":request.getParameter("est_email").trim());
	bean.setDoc_type	(request.getParameter("doc_type")==null?"":request.getParameter("doc_type"));
	bean.setSpr_yn		(request.getParameter("spr_yn")==null?"0":request.getParameter("spr_yn"));
	bean.setVali_type	(request.getParameter("vali_type")==null?"":request.getParameter("vali_type"));
	
	bean.setO_13		(request.getParameter("ro_13")==null?0:AddUtil.parseFloat(request.getParameter("ro_13")));
	bean.setRo_13		(request.getParameter("ro_13")==null?0:AddUtil.parseFloat(request.getParameter("ro_13")));
	bean.setRo_13_amt	(request.getParameter("ro_13_amt")==null?0:AddUtil.parseDigit(request.getParameter("ro_13_amt")));
	bean.setOpt_chk		(request.getParameter("opt_chk")==null?"":request.getParameter("opt_chk"));
	bean.setRg_8		(request.getParameter("rg_8")==null?0:AddUtil.parseFloat(request.getParameter("rg_8")));
	bean.setRg_8_amt	(request.getParameter("rg_8_amt")==null?0:AddUtil.parseDigit(request.getParameter("rg_8_amt")));
	bean.setPp_per		(request.getParameter("pp_per")==null?0:AddUtil.parseFloat(request.getParameter("pp_per")));
	bean.setPp_amt		(request.getParameter("pp_amt")==null?0:AddUtil.parseDigit(request.getParameter("pp_amt")));
	bean.setPp_st		(request.getParameter("pp_st")==null?"0":request.getParameter("pp_st"));
	bean.setG_10		(request.getParameter("g_10")==null?0:AddUtil.parseDigit(request.getParameter("g_10")));
	
	bean.setIns_per		(request.getParameter("ins_per")==null?"1":request.getParameter("ins_per"));
	bean.setInsurant	(request.getParameter("insurant")	==null?"1":request.getParameter("insurant"));
	bean.setIns_age		(request.getParameter("ins_age")==null?"":request.getParameter("ins_age"));
	bean.setIns_dj		(request.getParameter("ins_dj")==null?"":request.getParameter("ins_dj"));
	bean.setCar_ja		(request.getParameter("car_ja")==null?0:AddUtil.parseDigit(request.getParameter("car_ja")));
	
	bean.setGi_per		(request.getParameter("gi_per")==null?0 :AddUtil.parseFloat(request.getParameter("gi_per")));
	bean.setGi_amt		(request.getParameter("gi_amt")==null?0 :AddUtil.parseDigit(request.getParameter("gi_amt")));
	bean.setGi_yn		(request.getParameter("gi_yn")==null?"0":request.getParameter("gi_yn"));
	bean.setGi_grade	(request.getParameter("gi_grade")==null?"":request.getParameter("gi_grade"));
	
	bean.setUdt_st		(request.getParameter("udt_st")==null?"0":request.getParameter("udt_st"));
	bean.setA_h			(request.getParameter("a_h")==null?"":request.getParameter("a_h"));
	bean.setO_11		(request.getParameter("o_11")==null?0:AddUtil.parseFloat(request.getParameter("o_11")));
	bean.setFee_dc_per	(request.getParameter("fee_dc_per")==null?0:AddUtil.parseFloat(request.getParameter("fee_dc_per")));	
	
	bean.setReg_dt		(request.getParameter("reg_dt")==null?"":request.getParameter("reg_dt"));
	bean.setReg_id		(request.getParameter("damdang_id")==null?"":request.getParameter("damdang_id"));
	bean.setReg_code	(reg_code);
	
	bean.setIns_good	("0");//애니카보험 미가입
	bean.setLpg_yn		("0");//LPG키트 미장착
	
	//보증보험가입여부
	if(bean.getGi_amt()>0)									bean.setGi_yn("1");//가입
	else													bean.setGi_yn("0");//면제
	//초기납입구분
	bean.setPp_st		("0");
	if(bean.getG_10() > 0) 									bean.setPp_st		("1");//개시대여료
	if(bean.getPp_amt()+bean.getRg_8_amt() > 0) 			bean.setPp_st		("2");//보증금+선납금
	
	//견적서담당자
	if(!damdang_id.equals("")){
		bean.setReg_id		(damdang_id);
	}
	
	bean.setRent_dt		("");
	bean.setMgr_nm		(car_mng_id);
	bean.setMgr_ssn		(esti_nm);
	bean.setCls_per		(30);
	
	
	//견적관리번호 생성
	//est_id = e_db.getNextEst_id("S");
	est_id = Long.toString(System.currentTimeMillis());
	
	//fms3에서 견적함.
	if(AddUtil.lengthb(est_id) < 15)	est_id = est_id+""+"3";
	
	bean.setEst_type		("S");
	
	/*고객정보*/
	bean.setEst_id		(est_id);
	
	bean.setEst_from	("secondhand");
	bean.setRent_dt		(AddUtil.getDate());
	
	bean.setAgree_dist	(request.getParameter("agree_dist")==null?0 :AddUtil.parseDigit(request.getParameter("agree_dist")));
	bean.setB_agree_dist	(request.getParameter("b_agree_dist")==null?0 :AddUtil.parseDigit(request.getParameter("b_agree_dist")));
	
	
	if(st.equals("1")){ //출고전대차
		bean.setEst_from("tae_car");
	}
	
	
	count = e_db.insertEstimate(bean);
	
	
	String a_e = request.getParameter("a_e")==null?"":request.getParameter("a_e");
	
	
	
	String est_check1 = "";
	String est_check2 = "";
	String est_check3 = "";
	
	if(!bean.getEst_nm().equals("")){
	
		//아마존카 기존거래처 여부 (본인거 제외)
		Vector vt_chk1 = e_db.getEstimateCustRentCheck(bean.getEst_nm());
		int vt_chk1_size = vt_chk1.size(); 
		
		if(vt_chk1_size > 0){
			for (int i = 0 ; i < 1 ; i++){
               			Hashtable ht = (Hashtable)vt_chk1.elementAt(i);
               			if( String.valueOf(ht.get("BUS_ID")).equals(user_id) || String.valueOf(ht.get("BUS_ID2")).equals(user_id) ){
	               			est_check1 = "";
        	       		}else{
               				est_check1 = "[" +bean.getEst_nm()+ "]는 현재 아마존카 장기대여를 이용하고 있는 고객입니다.\\n\\n최초영업자 " +String.valueOf(ht.get("BUS_NM"))+ " " +String.valueOf(ht.get("BUS_POS"))+ " " +String.valueOf(ht.get("BUS_M_TEL"))+ "\\n관리담당자 " +String.valueOf(ht.get("BUS_NM2"))+ " " +String.valueOf(ht.get("BUS_POS2"))+ " " +String.valueOf(ht.get("BUS_M_TEL2"))+ "\\n\\n계속 견적하시겠습니까?";
               			}                		
	               	}			
		}else{
			est_check1 = "";
		}
	
		//최근30일이내 견적여부 (본인거 제외)
		Vector vt_chk2 = e_db.getEstimateCustEstCheck("7", bean.getEst_nm());
		int vt_chk2_size = vt_chk2.size(); 
	
		if(vt_chk2_size > 0){
			for (int i = 0 ; i < 1 ; i++){
               			Hashtable ht = (Hashtable)vt_chk2.elementAt(i);
               			if( String.valueOf(ht.get("REG_ID")).equals(user_id)){
	               			est_check2 = "";
        	       		}else{
               				est_check2 = "[" +bean.getEst_nm()+ "]는 최근 30일이내 견적한 고객입니다.\\n\\n견적담당자 " +String.valueOf(ht.get("USER_NM"))+ " "+ String.valueOf(ht.get("USER_POS"))+ " " +String.valueOf(ht.get("USER_M_TEL"))+ "\\n\\n계속 견적하시겠습니까?";
               			}                		
	               	}                	
		}else{
			est_check2 = "";
		}
		
		//최근7일이내 견적여부 (본인거 제외)
		Vector vt_chk3 = e_db.getEstimateSpeCustEstCheck("7", bean.getEst_nm());
		int vt_chk3_size = vt_chk3.size(); 
	
		if(vt_chk3_size > 0){
			for (int i = 0 ; i < 1 ; i++){
               			Hashtable ht = (Hashtable)vt_chk3.elementAt(i);
               			if( String.valueOf(ht.get("REG_ID")).equals("") || String.valueOf(ht.get("REG_ID")).equals(user_id)){
	               			est_check3 = "";
        	       		}else{
               				est_check3 = "[" +bean.getEst_nm()+ "]는 최근 7일이내 견적요청한 고객입니다.\\n\\n견적담당자 " +String.valueOf(ht.get("USER_NM"))+ " "+ String.valueOf(ht.get("USER_POS"))+ " " +String.valueOf(ht.get("USER_M_TEL"))+ "\\n\\n계속 견적하시겠습니까?";
               			}                		
	               	}                	
		}else{
			est_check3 = "";
		}						
	}		
%>
<html>
<head>

<title>FMS</title>
<meta http-equiv="content-type" content="text/html; charset=euc-kr">
<link rel="stylesheet" type="text/css" href="/include/table_t.css"></link>
<script language="JavaScript">
<!--
	//고객확인
	function cust_check(){
			
		var confirm_ment = '';
		
		<%	if(!est_check1.equals("")){ //아마존카 기존거래처인 경우%>                		
		if(confirm_ment == ''){
			confirm_ment = '<%=est_check1%>'
		}else{
			confirm_ment = confirm_ment+'\n\n\n<%=est_check1%>'
		}
		<%	}%>
		

		<%	if(!est_check2.equals("")){ //최근30일 이내 견적한 고객일 경우%>		
		if(confirm_ment == ''){
			confirm_ment = '<%=est_check2%>'
		}else{
			confirm_ment = confirm_ment+'\n\n\n<%=est_check2%>'
		}
		<%	}%>
		
		<%	if(!est_check3.equals("")){ //최근7일 이내 스마트견적 요청한 고객일 경우%>		
		if(confirm_ment == ''){
			confirm_ment = '<%=est_check3%>'
		}else{
			confirm_ment = confirm_ment+'\n\n\n<%=est_check3%>'
		}
		<%	}%>

		
		sure = confirm(confirm_ment);
		
		if(sure){
			document.form1.action = "sh_car_esti_i_a_proc.jsp";		
			document.form1.submit();	
		}else{
			document.form1.target = '_parent';						
			document.form1.action = "sh_car_esti_u.jsp";
			document.form1.submit();		
		}
	}
//-->
</script>
</head>
<body>
<form action="sh_car_esti_i_a_proc.jsp" name="form1" method="POST">
<%@ include file="/include/search_hidden.jsp" %>
	<input type='hidden' name='rent_mng_id' value='<%=rent_mng_id%>'>
	<input type='hidden' name='rent_l_cd'	value='<%=rent_l_cd%>'>
	<input type='hidden' name='car_mng_id' 	value='<%=car_mng_id%>'>
	<input type='hidden' name='car_no' 		value='<%=car_no%>'>
	<input type='hidden' name='from_page'	value='<%=from_page%>'>

  	<input type="hidden" name="est_id" value="<%=est_id%>">          
  	<input type="hidden" name="acar_id" value="<%=bean.getReg_id()%>">                 
  	<input type="hidden" name="est_code" value="<%=reg_code%>">  
  	<input type="hidden" name="mobile_yn" value="Y">             
  	<input type="hidden" name="opt_chk" value="<%=bean.getOpt_chk()%>"> 
</form>
<script>
<%	if(count==1){%>		

		<%if(!est_check1.equals("") || !est_check2.equals("") || !est_check3.equals("")){ //아마존카 기존거래처인 경우 || 최근30일 이내 견적한 고객일 경우%>              		
		cust_check();
		<%}else{%>
		document.form1.action = "sh_car_esti_i_a_proc.jsp";
		document.form1.submit();		
		<%}%>
<%	}else{%>
		alert("에러발생!");
<%	}%>
</script>
</body>
</html>

