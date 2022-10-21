<%@ page language="java" contentType="text/html;charset=euc-kr" %>
<%@ page import="java.util.*, acar.bank_mng.*, acar.util.*"%>
<jsp:useBean id="abl_db" scope="page" class="acar.bank_mng.AddBankLendDatabase"/>
<%@ include file="/acar/cookies.jsp" %>

<%
	String auth_rw 		= request.getParameter("auth_rw")	==null?"":request.getParameter("auth_rw");
	String user_id 		= request.getParameter("user_id")	==null?"":request.getParameter("user_id");
	String br_id 		= request.getParameter("br_id")		==null?"":request.getParameter("br_id");
	
	String s_kd 		= request.getParameter("s_kd")		==null?"":request.getParameter("s_kd");
	String t_wd 		= request.getParameter("t_wd")		==null?"":request.getParameter("t_wd");
	String gubun1 		= request.getParameter("gubun1")	==null?"":request.getParameter("gubun1");
	String gubun2 		= request.getParameter("gubun2")	==null?"":request.getParameter("gubun2");
	String gubun3 		= request.getParameter("gubun3")	==null?"":request.getParameter("gubun3");
	String gubun4 		= request.getParameter("gubun4")	==null?"":request.getParameter("gubun4");
	String gubun5 		= request.getParameter("gubun5")	==null?"":request.getParameter("gubun5");
	String st_dt 		= request.getParameter("st_dt")		==null?"":request.getParameter("st_dt");
	String end_dt 		= request.getParameter("end_dt")	==null?"":request.getParameter("end_dt");
	String bank_id 		= request.getParameter("bank_id")==null?"":request.getParameter("bank_id");
	String from_page 	= request.getParameter("from_page")	==null?"":request.getParameter("from_page");
	
	int sh_height 		= request.getParameter("sh_height")	==null?0:Util.parseInt(request.getParameter("sh_height"));//상단길이
	
	String fund_id 		= request.getParameter("fund_id")	==null?"":request.getParameter("fund_id");	
	String seq 		= request.getParameter("seq")		==null?"":request.getParameter("seq");
	String cng_item 	= request.getParameter("cng_item")	==null?"":request.getParameter("cng_item");
	String int_reg_yn 	= request.getParameter("int_reg_yn")	==null?"N":request.getParameter("int_reg_yn");
	String amt_reg_yn 	= request.getParameter("amt_reg_yn")	==null?"N":request.getParameter("amt_reg_yn");
	String dt_reg_yn 	= request.getParameter("dt_reg_yn")	==null?"N":request.getParameter("dt_reg_yn");
	int    re_seq		= 0;
	
	
	
	int flag = 0;
	boolean flag1 = true;
	
	WorkingFundBean wf = abl_db.getWorkingFundBean(fund_id);	
	
	
	if(cng_item.equals("wf")){		
		wf.setFund_type			(request.getParameter("fund_type")	==null?"":request.getParameter("fund_type"));
		wf.setBn_br			(request.getParameter("bn_br")		==null?"":request.getParameter("bn_br"));
		wf.setBa_title			(request.getParameter("ba_title")	==null?"":request.getParameter("ba_title"));
		wf.setBa_agnt			(request.getParameter("ba_agnt")	==null?"":request.getParameter("ba_agnt"));
		wf.setBn_tel			(request.getParameter("bn_tel")		==null?"":request.getParameter("bn_tel"));
	 	wf.setCont_amt			(request.getParameter("cont_amt")	==null?0:AddUtil.parseDigit4(request.getParameter("cont_amt")));
 		wf.setRest_amt			(request.getParameter("rest_amt")	==null?0:AddUtil.parseDigit4(request.getParameter("rest_amt")));
		wf.setRest_b_dt			(request.getParameter("rest_b_dt")	==null?"":request.getParameter("rest_b_dt"));
 		wf.setCont_dt			(request.getParameter("cont_dt")	==null?"":request.getParameter("cont_dt"));		
		wf.setCls_est_dt		(request.getParameter("cls_est_dt")	==null?"":request.getParameter("cls_est_dt"));		
		wf.setDeposit_no		(request.getParameter("deposit_no_d")	==null?"":request.getParameter("deposit_no_d"));			
		wf.setPay_st			(request.getParameter("pay_st")		==null?"":request.getParameter("pay_st"));
		wf.setSecurity_st1		(request.getParameter("security_st1")	==null?"N":request.getParameter("security_st1"));
		wf.setSecurity_st2		(request.getParameter("security_st2")	==null?"N":request.getParameter("security_st2"));
		wf.setSecurity_st3		(request.getParameter("security_st3")	==null?"N":request.getParameter("security_st3"));	
		wf.setCont_bn_st		(request.getParameter("cont_bn_st")	==null?"":request.getParameter("cont_bn_st"));		
		wf.setNote			(request.getParameter("note")		==null?"":request.getParameter("note"));
		wf.setRevolving			(request.getParameter("revolving")	==null?"":request.getParameter("revolving"));		
	
		if(!abl_db.updateWorkingFund(wf)) flag++;
		
		String renew_dt = request.getParameter("renew_dt")	==null?"":request.getParameter("renew_dt");
		if(!wf.getRenew_dt().equals("") && renew_dt.equals("")){
			wf.setCont_st		("0");
			wf.setRenew_dt		("");		
			if(!abl_db.updateWorkingFundRenew(wf)) flag++;
		}
		String cls_dt = request.getParameter("cls_dt")	==null?"":request.getParameter("cls_dt");
		if(!wf.getCls_dt().equals("") && cls_dt.equals("")){			
			wf.setCls_dt		("");		
			if(!abl_db.updateWorkingFundCls(wf)) flag++;
		}
		
	}else if(cng_item.equals("renew")){

		if(amt_reg_yn.equals("Y")){
			wf.setCont_amt			(request.getParameter("cont_amt")	==null?0:AddUtil.parseDigit4(request.getParameter("cont_amt")));			
			if(!abl_db.updateWorkingFund(wf)) flag++;
		}

		if(dt_reg_yn.equals("Y")){
			wf.setCls_est_dt	(request.getParameter("cls_est_dt")	==null?"":request.getParameter("cls_est_dt"));					
			if(!abl_db.updateWorkingFund(wf)) flag++;
		}


		wf.setCont_st			("1");
		wf.setRenew_dt			(request.getParameter("renew_dt")	==null?"":request.getParameter("renew_dt"));
		
		
		if(!abl_db.updateWorkingFundRenew(wf)) flag++;	
		
				
		WorkingFundIntBean wf_re = new WorkingFundIntBean();	
		
		Vector res = abl_db.getWorkingFundRe(fund_id);
		int re_size = res.size();
				
		wf_re.setFund_id	(wf.getFund_id());
		wf_re.setSeq		(re_size+1);
		wf_re.setReg_id		(user_id);
		wf_re.setRenew_dt	(wf.getRenew_dt());
		if(amt_reg_yn.equals("Y")){
			wf_re.setA_cont_amt	(request.getParameter("o_cont_amt")	==null?0:AddUtil.parseDigit4(request.getParameter("o_cont_amt")));
			wf_re.setB_cont_amt	(request.getParameter("cont_amt")	==null?0:AddUtil.parseDigit4(request.getParameter("cont_amt")));						
		}
		if(dt_reg_yn.equals("Y")){
			wf_re.setA_cls_est_dt	(request.getParameter("o_cls_est_dt")	==null?"":request.getParameter("o_cls_est_dt"));
			wf_re.setB_cls_est_dt	(request.getParameter("cls_est_dt")	==null?"":request.getParameter("cls_est_dt"));
		}
		if(int_reg_yn.equals("Y")){
			wf_re.setA_fund_int	(request.getParameter("o_fund_int")	==null?"":request.getParameter("o_fund_int"));
			wf_re.setB_fund_int	(request.getParameter("fund_int")	==null?"":request.getParameter("fund_int"));
		}
		
		re_seq = re_size+1;
		
		wf_re = abl_db.insertWorkingFundRe(wf_re);	
			
		if(wf_re == null){
			flag++;
		}
				
	}else if(cng_item.equals("cls")){
		wf.setCls_dt			(request.getParameter("cls_dt")		==null?"":request.getParameter("cls_dt"));
		
		if(!abl_db.updateWorkingFundCls(wf)) flag++;
		
	}else if(cng_item.equals("gua")){
		wf.setGua_org		(request.getParameter("gua_org")	==null?"":request.getParameter("gua_org"));
		wf.setGua_s_dt		(request.getParameter("gua_s_dt")	==null?"":request.getParameter("gua_s_dt"));
		wf.setGua_e_dt		(request.getParameter("gua_e_dt")	==null?"":request.getParameter("gua_e_dt"));
		wf.setGua_int		(request.getParameter("gua_int")	==null?"":request.getParameter("gua_int"));
	 	wf.setGua_amt		(request.getParameter("gua_amt")	==null?0:AddUtil.parseDigit4(request.getParameter("gua_amt")));
		wf.setGua_fee		(request.getParameter("gua_fee")	==null?0:AddUtil.parseDigit4(request.getParameter("gua_fee")));
		wf.setGua_agnt		(request.getParameter("gua_agnt")	==null?"":request.getParameter("gua_agnt"));
		wf.setGua_title		(request.getParameter("gua_title")	==null?"":request.getParameter("gua_title"));
		wf.setGua_tel		(request.getParameter("gua_tel")	==null?"":request.getParameter("gua_tel"));
		wf.setGua_est_dt	(request.getParameter("gua_est_dt")	==null?"":request.getParameter("gua_est_dt"));
		wf.setGua_docs		(request.getParameter("gua_docs")	==null?"":request.getParameter("gua_docs"));
		
		if(!abl_db.updateWorkingFundGua(wf)) flag++;
	
	}else if(cng_item.equals("realty")){
		wf.setRealty_nm		(request.getParameter("realty_nm")	==null?"":request.getParameter("realty_nm"));
		wf.setRealty_zip	(request.getParameter("t_zip")		==null?"":request.getParameter("t_zip"));
		wf.setRealty_addr	(request.getParameter("t_addr")		==null?"":request.getParameter("t_addr"));
		wf.setCltr_amt		(request.getParameter("cltr_amt")	==null?0:AddUtil.parseDigit4(request.getParameter("cltr_amt")));
		wf.setCltr_dt		(request.getParameter("cltr_dt")	==null?"":request.getParameter("cltr_dt"));
		wf.setCltr_st		(request.getParameter("cltr_st")	==null?"":request.getParameter("cltr_st"));
		wf.setCltr_user		(request.getParameter("cltr_user")	==null?"":request.getParameter("cltr_user"));
		wf.setCltr_lank		(request.getParameter("cltr_lank")	==null?"":request.getParameter("cltr_lank"));
		
		if(!abl_db.updateWorkingFundRealty(wf)) flag++;
	
	}
	
	
	if(cng_item.equals("renew") && int_reg_yn.equals("Y")){
	
		WorkingFundIntBean wf_int = new WorkingFundIntBean();	
		
		Vector ints = abl_db.getWorkingFundInt(fund_id);
		int int_size = ints.size();
				
		wf_int.setFund_id	(wf.getFund_id());
		wf_int.setSeq		(int_size+1);
		wf_int.setReg_id	(user_id);							
		wf_int.setFund_int	(request.getParameter("fund_int")	==null?"":request.getParameter("fund_int"));
		wf_int.setValidity_s_dt	(request.getParameter("validity_s_dt")	==null?"":request.getParameter("validity_s_dt"));
		wf_int.setValidity_e_dt	(request.getParameter("validity_e_dt")	==null?"":request.getParameter("validity_e_dt"));
		wf_int.setInt_st	(request.getParameter("int_st")		==null?"":request.getParameter("int_st"));
		wf_int.setSpread	(request.getParameter("spread")		==null?"":request.getParameter("spread"));
		wf_int.setSpread_int	(request.getParameter("spread_int")	==null?"":request.getParameter("spread_int"));
		wf_int.setApp_b_st	(request.getParameter("app_b_st")	==null?"":request.getParameter("app_b_st"));
		wf_int.setApp_b_dt	(request.getParameter("app_b_dt")	==null?"":request.getParameter("app_b_dt"));
		wf_int.setNote		(request.getParameter("note")		==null?"":request.getParameter("note"));
		
		wf_int = abl_db.insertWorkingFundInt(wf_int);	
			
		if(wf_int == null){
			flag++;
		}
		
		if(!abl_db.updateWorkingFundReIntSeq(wf_int, re_seq)) flag++;
		
	}
	
	if(cng_item.equals("wf_int") || cng_item.equals("wf_int_add")){
	
		WorkingFundIntBean wf_int = new WorkingFundIntBean();	
		
		if(!seq.equals("")){
			wf_int = abl_db.getWorkingFundIntBean(fund_id, Util.parseDigit(seq));	
		}else{
			Vector ints = abl_db.getWorkingFundInt(fund_id);
			int int_size = ints.size();
				
			wf_int.setFund_id	(wf.getFund_id());
			wf_int.setSeq		(int_size+1);
			wf_int.setReg_id	(user_id);							
		}
				
		wf_int.setFund_int	(request.getParameter("fund_int")	==null?"":request.getParameter("fund_int"));
		wf_int.setValidity_s_dt	(request.getParameter("validity_s_dt")	==null?"":request.getParameter("validity_s_dt"));
		wf_int.setValidity_e_dt	(request.getParameter("validity_e_dt")	==null?"":request.getParameter("validity_e_dt"));
		wf_int.setInt_st	(request.getParameter("int_st")		==null?"":request.getParameter("int_st"));
		wf_int.setSpread	(request.getParameter("spread")		==null?"":request.getParameter("spread"));
		wf_int.setSpread_int	(request.getParameter("spread_int")	==null?"":request.getParameter("spread_int"));
		wf_int.setApp_b_st	(request.getParameter("app_b_st")	==null?"":request.getParameter("app_b_st"));
		wf_int.setApp_b_dt	(request.getParameter("app_b_dt")	==null?"":request.getParameter("app_b_dt"));
		wf_int.setNote		(request.getParameter("note")		==null?"":request.getParameter("note"));
				
		if(cng_item.equals("wf_int")){
			if(!abl_db.updateWorkingFundInt(wf_int)) flag++;
		}else{
			wf_int = abl_db.insertWorkingFundInt(wf_int);	
			
			if(wf_int == null){
				flag++;
			}
		}
	}	
	
	if(cng_item.equals("lend_cancel")){
		String lend_id = request.getParameter("lend_id")==null?"":request.getParameter("lend_id");
		
		//은행대출 정보
		BankLendBean bl = abl_db.getBankLend(lend_id);
		boolean flag2 = abl_db.updateBankLendFundId(bl, "");
	}
	

%>
<html>
<head><title>FMS</title>
</head>
<script language='javascript'>
<!--
	function go_step(){
		var fm = document.form1;
		if(fm.from_page.value == ''){
			fm.action = 'working_fund_c.jsp';
		}else{
			fm.action = '<%=from_page%>';		
		}
		fm.target = 'd_content';
		fm.submit();
		
		parent.window.close();
	}
//-->
</script>
<body>
<form name='form1' action='' target='' method='post'>
  <input type='hidden' name='auth_rw' 	value='<%=auth_rw%>'>
  <input type='hidden' name='user_id' 	value='<%=user_id%>'>
  <input type='hidden' name='br_id' 	value='<%=br_id%>'>
  <input type='hidden' name='s_kd'  	value='<%=s_kd%>'>
  <input type='hidden' name='t_wd' 	value='<%=t_wd%>'>			
  <input type='hidden' name='gubun1' 	value='<%=gubun1%>'>  
  <input type='hidden' name='gubun2' 	value='<%=gubun2%>'>  
  <input type='hidden' name='gubun3' 	value='<%=gubun3%>'>
  <input type='hidden' name='gubun4' 	value='<%=gubun4%>'>
  <input type='hidden' name='gubun5' 	value='<%=gubun5%>'>  
  <input type='hidden' name='st_dt' 	value='<%=st_dt%>'>
  <input type='hidden' name='end_dt' 	value='<%=end_dt%>'>
  <input type='hidden' name='bank_id' value='<%=bank_id%>'>
  <input type='hidden' name='sh_height' value='<%=sh_height%>'>    
  <input type='hidden' name='from_page' value='<%=from_page%>'>  
  <input type='hidden' name='fund_id' 	value='<%=wf.getFund_id()%>'>
</form>
<script language='javascript'>
<!--
<%	if(flag > 0){//에러발생%>
		alert("에러가 발생하였습니다.");
<%	}else{//정상%>
		alert("등록하였습니다.");
		go_step();
<%	}%>
//-->
</script>
</body>
</html>
