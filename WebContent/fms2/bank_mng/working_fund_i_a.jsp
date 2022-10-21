<%@ page language="java" contentType="text/html;charset=euc-kr" %>
<%@ page import="java.util.*, acar.bank_mng.*, acar.util.*"%>
<jsp:useBean id="abl_db" scope="page" class="acar.bank_mng.AddBankLendDatabase"/>
<%@ include file="/acar/cookies.jsp" %>

<%
	String auth_rw 	= request.getParameter("auth_rw")	==null?"":request.getParameter("auth_rw");
	String user_id 	= request.getParameter("user_id")	==null?"":request.getParameter("user_id");
	String br_id 	= request.getParameter("br_id")		==null?"":request.getParameter("br_id");
	
	String s_kd 	= request.getParameter("s_kd")		==null? "":request.getParameter("s_kd");
	String t_wd 	= request.getParameter("t_wd")		==null? "" :request.getParameter("t_wd");
	String gubun1 	= request.getParameter("gubun1")	==null?"":request.getParameter("gubun1");
	String gubun2 	= request.getParameter("gubun2")	==null?"":request.getParameter("gubun2");
	String gubun3 	= request.getParameter("gubun3")	==null?"":request.getParameter("gubun3");
	String gubun4 	= request.getParameter("gubun4")	==null?"":request.getParameter("gubun4");
	String gubun5 	= request.getParameter("gubun5")	==null?"":request.getParameter("gubun5");
	String st_dt 	= request.getParameter("st_dt")		==null?"":request.getParameter("st_dt");
	String end_dt 	= request.getParameter("end_dt")	==null?"":request.getParameter("end_dt");
	String bank_id 	= request.getParameter("bank_id")==null?"":request.getParameter("bank_id");
	String from_page = request.getParameter("from_page")	==null?"":request.getParameter("from_page");
	
	int sh_height = request.getParameter("sh_height")	==null?0:Util.parseInt(request.getParameter("sh_height"));//상단길이
	
	
	int flag = 0;
	
	
	WorkingFundBean wf = new WorkingFundBean();
	
	
	
	wf.setReg_id			(user_id);
	wf.setCont_st			("0");
	wf.setCont_bn			(request.getParameter("cont_bn")	==null?"":request.getParameter("cont_bn"));
	wf.setBn_br			(request.getParameter("bn_br")		==null?"":request.getParameter("bn_br"));
	wf.setBa_title			(request.getParameter("ba_title")	==null?"":request.getParameter("ba_title"));
	wf.setBa_agnt			(request.getParameter("ba_agnt")	==null?"":request.getParameter("ba_agnt"));
	wf.setBn_tel			(request.getParameter("bn_tel")		==null?"":request.getParameter("bn_tel"));
	wf.setFund_no			(request.getParameter("fund_no")	==null?"":request.getParameter("fund_no"));
	wf.setFund_type			(request.getParameter("fund_type")	==null?"":request.getParameter("fund_type"));
 	wf.setCont_amt			(request.getParameter("cont_amt")	==null?0:AddUtil.parseDigit4(request.getParameter("cont_amt")));
 	wf.setRest_amt			(request.getParameter("rest_amt")	==null?0:AddUtil.parseDigit4(request.getParameter("rest_amt")));
	wf.setRest_b_dt			(request.getParameter("rest_b_dt")	==null?"":request.getParameter("rest_b_dt"));
 	wf.setCont_dt			(request.getParameter("cont_dt")	==null?"":request.getParameter("cont_dt"));
	//wf.setRenew_dt		(request.getParameter("renew_dt")	==null?"":request.getParameter("renew_dt"));
	wf.setCls_est_dt		(request.getParameter("cls_est_dt")	==null?"":request.getParameter("cls_est_dt"));
	//wf.setCls_dt			(request.getParameter("cls_dt")		==null?"":request.getParameter("cls_dt"));
	wf.setBank_code			(request.getParameter("bank_code2")	==null?"":request.getParameter("bank_code2"));
	wf.setDeposit_no		(request.getParameter("deposit_no_d")	==null?"":request.getParameter("deposit_no_d"));			
	wf.setPay_st			(request.getParameter("pay_st")		==null?"":request.getParameter("pay_st"));
	wf.setSecurity_st1		(request.getParameter("security_st1")	==null?"N":request.getParameter("security_st1"));
	wf.setSecurity_st2		(request.getParameter("security_st2")	==null?"N":request.getParameter("security_st2"));
	wf.setSecurity_st3		(request.getParameter("security_st3")	==null?"N":request.getParameter("security_st3"));
	//wf.setLend_id			(request.getParameter("lend_id")	==null?"":request.getParameter("lend_id"));
	wf.setCont_bn_st		(request.getParameter("cont_bn_st")	==null?"":request.getParameter("cont_bn_st"));		
	wf.setRevolving			(request.getParameter("revolving")	==null?"":request.getParameter("revolving"));		
	
	
	
	
	//사용할 fund_no 가져오기
	String fund_no = abl_db.getFundNoNext(wf.getCont_dt());
	
	wf.setFund_no			(fund_no);
	
	
	//보증서담보
	if(wf.getSecurity_st2().equals("Y")){
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
	}
	
	//부동산담보
	if(wf.getSecurity_st3().equals("Y")){
		wf.setRealty_nm		(request.getParameter("realty_nm")	==null?"":request.getParameter("realty_nm"));
		wf.setRealty_zip	(request.getParameter("t_zip")		==null?"":request.getParameter("t_zip"));
		wf.setRealty_addr	(request.getParameter("t_addr")		==null?"":request.getParameter("t_addr"));
		wf.setCltr_amt		(request.getParameter("cltr_amt")	==null?0:AddUtil.parseDigit4(request.getParameter("cltr_amt")));
		wf.setCltr_dt		(request.getParameter("cltr_dt")	==null?"":request.getParameter("cltr_dt"));
		wf.setCltr_st		(request.getParameter("cltr_st")	==null?"":request.getParameter("cltr_st"));
		wf.setCltr_user		(request.getParameter("cltr_user")	==null?"":request.getParameter("cltr_user"));
		wf.setCltr_lank		(request.getParameter("cltr_lank")	==null?"":request.getParameter("cltr_lank"));
	}
	
	wf = abl_db.insertWorkingFund(wf);
	
	if(wf == null){
		flag++; 
	}else{
		
		WorkingFundIntBean wf_int = new WorkingFundIntBean();
		
		wf_int.setFund_id	(wf.getFund_id());
		wf_int.setSeq		(1);
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
		
		if(wf_int.getInt_st().equals("1") && wf_int.getSpread().equals("")){ //확정금리일때는 무조건 Spread 무
			wf_int.setSpread	("N");
			wf_int.setSpread_int	("0");
		}
		
		wf_int = abl_db.insertWorkingFundInt(wf_int);
		
		if(wf_int == null){
			flag++;
		}
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
			fm.action = 'working_fund_u.jsp';
		}else{
			fm.action = '<%=from_page%>';		
		}
		fm.target = 'd_content';
		fm.submit();
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
