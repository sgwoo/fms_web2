<%@ page language="java" contentType="text/html;charset=euc-kr" %>
<%@ page import="java.util.*, acar.util.*"%>
<%@ page import="acar.pay_mng.*, acar.doc_settle.*, acar.car_sche.*, acar.user_mng.*, card.*, acar.biz_partner.*, acar.inside_bank.*"%>
<jsp:useBean id="d_db" scope="page" class="acar.doc_settle.DocSettleDatabase"/>
<%@ include file="/acar/cookies.jsp" %> 


<%
	String auth_rw 	= request.getParameter("auth_rw")==null?"":request.getParameter("auth_rw");
	String user_id 	= request.getParameter("user_id")==null?"":request.getParameter("user_id");
	String br_id 	= request.getParameter("br_id")==null?"":request.getParameter("br_id");
	
	String s_kd 	= request.getParameter("s_kd")==null? "3":request.getParameter("s_kd");
	String t_wd 	= request.getParameter("t_wd")==null? "" :request.getParameter("t_wd");
	String andor 	= request.getParameter("andor")==null?"1":request.getParameter("andor");
	String gubun1 	= request.getParameter("gubun1")==null?"":request.getParameter("gubun1");
	String gubun2 	= request.getParameter("gubun2")==null?"":request.getParameter("gubun2");
	String gubun3 	= request.getParameter("gubun3")==null?"":request.getParameter("gubun3");
	String gubun4 	= request.getParameter("gubun4")==null?"":request.getParameter("gubun4");
	String gubun5 	= request.getParameter("gubun5")==null?"":request.getParameter("gubun5");
	String st_dt 	= request.getParameter("st_dt")==null?"":request.getParameter("st_dt");
	String end_dt 	= request.getParameter("end_dt")==null?"":request.getParameter("end_dt");
	String from_page = request.getParameter("from_page")==null?"":request.getParameter("from_page");
	String mode 	= request.getParameter("mode")==null?"":request.getParameter("mode");
	
	
	boolean flag1 = true;
	boolean flag2 = true;
	boolean flag3 = true;
	boolean flag4 = true;
	boolean flag5 = true;
	boolean flag6 = true;
	int flag = 0;
	int result = 0;
	
	
	PayMngDatabase pm_db = PayMngDatabase.getInstance();
	PaySearchDatabase ps_db = PaySearchDatabase.getInstance();
	BizPartnerDatabase 	bp_db 	= BizPartnerDatabase.getInstance();
	InsideBankDatabase 	ib_db 	= InsideBankDatabase.getInstance();
%>


<%
	String actseq 	= request.getParameter("actseq")==null? "":request.getParameter("actseq");
	
	//송금원장
	PayMngActBean act 	= pm_db.getPayAct(actseq);
	
	String o_bank_nm 	= act.getBank_nm();
	String o_a_bank_nm 	= act.getA_bank_nm();
	
	act.setBank_nm		(request.getParameter("bank_nm")==null? "":request.getParameter("bank_nm"));
	act.setBank_no		(request.getParameter("bank_no")==null? "":request.getParameter("bank_no"));
	act.setBank_acc_nm	(request.getParameter("bank_acc_nm")==null? "":request.getParameter("bank_acc_nm"));
	act.setA_bank_nm	(request.getParameter("a_bank_nm")==null? "":request.getParameter("a_bank_nm"));
	act.setA_bank_no	(request.getParameter("a_bank_no")==null? "":request.getParameter("a_bank_no"));
	act.setAct_dt		(request.getParameter("act_dt")==null? "":request.getParameter("act_dt"));
	act.setCommi		(request.getParameter("commi")==null? 0:AddUtil.parseDigit(request.getParameter("commi")));
	act.setAmt			(request.getParameter("act_amt")==null? 0:AddUtil.parseDigit4(request.getParameter("act_amt")));
	act.setBank_memo	(request.getParameter("bank_memo")==null? "":request.getParameter("bank_memo"));
	act.setCms_code		(request.getParameter("cms_code")==null? "":request.getParameter("cms_code"));
	
	if(!o_bank_nm.equals(act.getBank_nm())){
		//bank_id, bank_cms_bk 새로 가져오기
		Hashtable ht1 = ps_db.getBankCode("", act.getBank_nm());
		if(String.valueOf(ht1.get("CMS_BK")).equals("null")){
		}else{
			act.setBank_cms_bk(String.valueOf(ht1.get("CMS_BK")));
		}
		Hashtable ht2 = ps_db.getCheckd("A03", act.getBank_nm());
		if(String.valueOf(ht2.get("CHECKD_CODE")).equals("null")){
		}else{
			act.setBank_id(String.valueOf(ht2.get("CHECKD_CODE")));
		}
	}
	if(!o_a_bank_nm.equals(act.getA_bank_nm())){
		//bank_id, bank_cms_bk 새로 가져오기
		Hashtable ht1 = ps_db.getBankCode("", act.getA_bank_nm());
		if(String.valueOf(ht1.get("CMS_BK")).equals("null")){
		}else{
			act.setA_bank_cms_bk(String.valueOf(ht1.get("CMS_BK")));
		}
		Hashtable ht2 = ps_db.getCheckd("A03", act.getA_bank_nm());
		if(String.valueOf(ht2.get("CHECKD_CODE")).equals("null")){
		}else{
			act.setA_bank_id(String.valueOf(ht2.get("CHECKD_CODE")));
		}
	}	
	
	//=====[PAY_LEGDER_ACT] update=====
	if(!pm_db.updatePayAntRU1(act)) flag += 1; //pay_act 처리
	
	
	//은행연동에 따라 수정제한을 두어야 함(비즈파트너)
	ErpTransBean et = bp_db.getErpTransCase(actseq);
	if(!et.getTran_dt().equals("")){
		
		et.setOut_bank_id			(request.getParameter("e_a_bank_id")==null? "":request.getParameter("e_a_bank_id"));
		et.setOut_bank_name			(request.getParameter("e_a_bank_nm")==null? "":request.getParameter("e_a_bank_nm"));
		et.setOut_acct_no			(request.getParameter("e_a_bank_no")==null? "":request.getParameter("e_a_bank_no"));
		et.setIn_bank_id			(request.getParameter("e_bank_id")==null? "":request.getParameter("e_bank_id"));
		et.setIn_bank_name			(request.getParameter("e_bank_nm")==null? "":request.getParameter("e_bank_nm"));
		et.setIn_acct_no			(request.getParameter("e_bank_no")==null? "":request.getParameter("e_bank_no"));
		et.setReceip_owner_name		(request.getParameter("e_bank_acc_nm")==null? "":request.getParameter("e_bank_acc_nm"));
		
		
		if(et.getErr_code().equals("000")){
			et.setTran_amt			(request.getParameter("e_act_amt")==null? 0:AddUtil.parseDigit4(request.getParameter("e_act_amt")));	
			et.setIn_acct_memo		(request.getParameter("e_bank_memo")==null? "":request.getParameter("e_bank_memo"));
			et.setCms_code			(request.getParameter("e_cms_code")==null? "":request.getParameter("e_cms_code"));
		}
		
		if(AddUtil.lengthb(et.getReceip_owner_name()) > 20) et.setReceip_owner_name	(AddUtil.substringb(et.getReceip_owner_name(),20));
		
		if(!bp_db.updateErpTransAct(et)) result += 1;
	}
	
	
	//은행연동에 따라 수정제한을 두어야 함--인사이트뱅크
	IbBulkTranBean it = ib_db.getIbBulkTranCase(actseq);
	if(!it.getTran_dt().equals("")){
		
		it.setTran_ji_acct_nb		(request.getParameter("i_a_bank_no")	==null? "":request.getParameter("i_a_bank_no"));
		it.setTran_ip_bank_id		(request.getParameter("i_bank_id")		==null? "":request.getParameter("i_bank_id"));
		it.setTran_ip_acct_nb		(request.getParameter("i_bank_no")		==null? "":request.getParameter("i_bank_no"));
		it.setTran_remittee_nm		(request.getParameter("i_bank_acc_nm")	==null? "":request.getParameter("i_bank_acc_nm"));
		
		if(it.getTran_result_cd().equals("00")){
			it.setTran_amt_req		(request.getParameter("i_act_amt")		==null? "0":String.valueOf(AddUtil.parseDigit4(request.getParameter("i_act_amt"))));
			it.setTran_ip_naeyong	(request.getParameter("i_bank_memo")	==null? "":request.getParameter("i_bank_memo"));
			it.setTran_cms_cd		(request.getParameter("i_cms_code")		==null? "":request.getParameter("i_cms_code"));
		}
		
		if(AddUtil.lengthb(it.getTran_remittee_nm()) > 20) it.setTran_remittee_nm	(AddUtil.substringb(it.getTran_remittee_nm(),20));
		
		if(!ib_db.updateIbBulkTran(it)) result += 1;
	}
	
	
	String p_reqseq[]			= request.getParameterValues("p_reqseq");
	String p_p_pay_dt[]		 	= request.getParameterValues("p_p_pay_dt");
	String p_bank_no[]		 	= request.getParameterValues("p_bank_no");
	String p_bank_nm[]		 	= request.getParameterValues("p_bank_nm");
	String p_bank_acc_nm[]		= request.getParameterValues("p_bank_acc_nm");
	String p_a_bank_no[]		= request.getParameterValues("p_a_bank_no");
	String p_a_bank_nm[]		= request.getParameterValues("p_a_bank_nm");
	String p_commi[]			= request.getParameterValues("p_commi");
	String p_m_amt[]			= request.getParameterValues("p_m_amt");
	String p_amt[]				= request.getParameterValues("p_amt");
	
	String reqseq 	= "";
	
	int vid_size = p_reqseq.length;
	
	
	for(int i=0;i < vid_size;i++){
		
		reqseq = p_reqseq[i];
		
		//출금원장
		PayMngBean pay 	= pm_db.getPay(reqseq);
		
		String p_o_bank_nm 		= pay.getBank_nm();
		String p_o_a_bank_nm 	= pay.getA_bank_nm();
		
		pay.setP_pay_dt		(p_p_pay_dt[i]		==null? "":p_p_pay_dt[i]);
		pay.setBank_nm		(p_bank_nm[i]		==null? "":p_bank_nm[i]);
		pay.setBank_no		(p_bank_no[i]		==null? "":p_bank_no[i]);
		pay.setBank_acc_nm	(p_bank_acc_nm[i]	==null? "":p_bank_acc_nm[i]);
		pay.setA_bank_nm	(p_a_bank_nm[i]		==null? "":p_a_bank_nm[i]);
		pay.setA_bank_no	(p_a_bank_no[i]		==null? "":p_a_bank_no[i]);
		pay.setCommi		(p_commi[i]			==null? 0: AddUtil.parseDigit(p_commi[i]));
		pay.setM_amt		(p_m_amt[i]			==null? 0: AddUtil.parseDigit(p_m_amt[i]));
		pay.setAmt			(p_amt[i]			==null? 0: AddUtil.parseDigit4(p_amt[i]));
		
		if(!p_o_bank_nm.equals(pay.getBank_nm())){
			if(act.getBank_nm().equals(pay.getBank_nm())){
				pay.setBank_cms_bk	(act.getBank_cms_bk());
				pay.setBank_id		(act.getBank_id());
			}else{
				//bank_id, bank_cms_bk 새로 가져오기
				Hashtable ht1 = ps_db.getBankCode("", pay.getBank_nm());
				if(String.valueOf(ht1.get("CMS_BK")).equals("null")){
				}else{
					pay.setBank_cms_bk(String.valueOf(ht1.get("CMS_BK")));
				}
				Hashtable ht2 = ps_db.getCheckd("A03", pay.getBank_nm());
				if(String.valueOf(ht2.get("CHECKD_CODE")).equals("null")){
				}else{
					pay.setBank_id(String.valueOf(ht2.get("CHECKD_CODE")));
				}
			}
		}
		if(!p_o_a_bank_nm.equals(pay.getA_bank_nm())){
			if(act.getA_bank_nm().equals(pay.getA_bank_nm())){
				pay.setA_bank_cms_bk	(act.getA_bank_cms_bk());
				pay.setA_bank_id		(act.getA_bank_id());
			}else{
				//bank_id, bank_cms_bk 새로 가져오기
				Hashtable ht1 = ps_db.getBankCode("", pay.getA_bank_nm());
				if(String.valueOf(ht1.get("CMS_BK")).equals("null")){
				}else{
					pay.setA_bank_cms_bk(String.valueOf(ht1.get("CMS_BK")));
				}
				Hashtable ht2 = ps_db.getCheckd("A03", pay.getA_bank_nm());
				if(String.valueOf(ht2.get("CHECKD_CODE")).equals("null")){
				}else{
					pay.setA_bank_id(String.valueOf(ht2.get("CHECKD_CODE")));
				}
			}
		}		
		
		//=====[PAY_LEGDER_ACT] update=====
		if(!pm_db.updatePayAntRU2(pay)) flag += 1; //pay 처리
	}
	

	
	%>
	
<html>
<head>
<title>FMS</title>
</head>
<body leftmargin="15">	
<script language='javascript'>
<!--
	function go_step(){
		var fm = document.form1;
		if(fm.from_page.value == ''){
			fm.action = 'pay_r_frame.jsp';
		}else{
			fm.action = '<%=from_page%>';		
		}
		fm.target = 'd_content';
		fm.submit();
		
		parent.window.close();
	}
//-->
</script>

<form name='form1' method='post'>
  <input type='hidden' name='auth_rw' 	value='<%=auth_rw%>'>
  <input type='hidden' name='user_id' 	value='<%=user_id%>'>
  <input type='hidden' name='br_id' 	value='<%=br_id%>'>
  <input type='hidden' name='s_kd'  	value='<%=s_kd%>'>
  <input type='hidden' name='t_wd' 		value='<%=t_wd%>'>			
  <input type='hidden' name='gubun1' 	value='<%=gubun1%>'>  
  <input type='hidden' name='gubun2' 	value='<%=gubun2%>'>  
  <input type='hidden' name='gubun3' 	value='<%=gubun3%>'>
  <input type='hidden' name='gubun4' 	value='<%=gubun4%>'>
  <input type='hidden' name='gubun5' 	value='<%=gubun5%>'>
  <input type='hidden' name='st_dt' 	value='<%=st_dt%>'>
  <input type='hidden' name='end_dt' 	value='<%=end_dt%>'>
  <input type='hidden' name="mode" 		value="<%=mode%>">
  <input type='hidden' name="from_page" value="<%=from_page%>"> 
</form>
<script language='javascript'>
<!--
<%	if(flag > 0){//에러발생%>
		alert("에러가 발생하였습니다.");
<%	}else{//정상%>
		alert("처리하였습니다.");
		go_step();
<%	}%>
//-->
</script>
</body>
</html>