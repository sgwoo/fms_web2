<%@ page language="java" contentType="text/html;charset=euc-kr" %>
<%@ page import="java.util.*, acar.util.*, acar.incom.*"%>
<jsp:useBean id="in_db" scope="page" class="acar.incom.IncomDatabase"/>
<jsp:useBean id="ib_db" scope="page" class="acar.inside_bank.InsideBankDatabase"/>
<%@ include file="/acar/cookies.jsp" %>

<html>
<head>
<title>FMS</title>
</head>
<body leftmargin="15">
<%
	//if(1==1)return;
	
	String auth_rw 			= request.getParameter("auth_rw")==null?""        :request.getParameter("auth_rw");
	String user_id 			= request.getParameter("user_id")==null?ck_acar_id:request.getParameter("user_id");
	String br_id 			= request.getParameter("br_id")  ==null?acar_br   :request.getParameter("br_id");
	
	//1. 입금처리전 기본정보 ----------------------------------------------------------------------------------------------
	
	//bankincom
	String incom_dt 		= request.getParameter("incom_dt")==null?"":request.getParameter("incom_dt");
	String brch_id 			= request.getParameter("brch_id")==null?"":request.getParameter("brch_id");
	String incom_gubun 		= request.getParameter("incom_gubun")==null?"":request.getParameter("incom_gubun");  //입력구분
	String ip_method 		= request.getParameter("ip_method")==null?"":request.getParameter("ip_method");  //입금구분

	long  incom_amt 			= request.getParameter("incom_amt")	==null? 0:AddUtil.parseDigit4(request.getParameter("incom_amt"));
	String from_page 	= "incom_reg_step2.jsp";
	
	// Incom insert 
	IncomBean base = new IncomBean();
	
	base.setIncom_dt		(incom_dt);
	base.setIncom_amt		(incom_amt); //입금액
	base.setIncom_gubun		(incom_gubun);
	base.setIp_method		(ip_method);
	base.setJung_type		("0");  //  입금대기
//	base.setP_gubun			(p_gubun);
	base.setPay_gur			("0");  //대위변제여부
		
	//신한erp로 처리한 경우 	
	if ( incom_gubun.equals("2") ) {
		if (ip_method.equals("1")) {  //계좌
			base.setBank_nm		(request.getParameter("bank_code3")==null?"":request.getParameter("bank_code3"));
			base.setBank_no		(request.getParameter("deposit_no3")==null?"":request.getParameter("deposit_no3"));
			base.setRemark		(request.getParameter("remark")==null?"":request.getParameter("remark"));
			base.setBank_office	(request.getParameter("bank_office")==null?"":request.getParameter("bank_office"));
			
			base.setAcct_seq	(request.getParameter("acct_seq")==null?"":request.getParameter("acct_seq"));
			base.setTr_date_seq	(request.getParameter("tran_date_seq")==null?"":request.getParameter("tran_date_seq"));
		  }
	
	} else {  		
		if (ip_method.equals("1")) {  //계좌
			base.setBank_nm		(request.getParameter("bank_code")==null?"":request.getParameter("bank_code"));
			base.setBank_no		(request.getParameter("deposit_no")==null?"":request.getParameter("deposit_no"));
			base.setRemark		(request.getParameter("remark")==null?"":request.getParameter("remark"));
			base.setBank_office	(request.getParameter("bank_office")==null?"":request.getParameter("bank_office"));
			
		} else if (ip_method.equals("2")) { //카드
			base.setCard_cd		(request.getParameter("card_cd")==null?"":request.getParameter("card_cd"));
			base.setCard_no  	(request.getParameter("card_no")==null?"":request.getParameter("card_no"));
		//	base.setCard_get_id (request.getParameter("card_get_id")==null?"":request.getParameter("card_get_id"));
			base.setRemark		(request.getParameter("remark1")==null?"":request.getParameter("remark1"));
			
		} else if (ip_method.equals("3")) { //현금
			base.setCash_area	(request.getParameter("cash_area")==null?"":request.getParameter("cash_area"));
			base.setCash_get_id	(request.getParameter("cash_get_id")==null?"":request.getParameter("cash_get_id"));
			base.setRemark		(request.getParameter("remark2")==null?"":request.getParameter("remark2"));		
					
		} else if (ip_method.equals("5")) { //대체
			base.setRemark	(request.getParameter("remark5")==null?"":request.getParameter("remark5"));						
		}   
	}
		
	base.setReg_id			(user_id);
	
	//=====[incom] insert=====
	base = in_db.insertIncom(base);
	int incom_seq 	= base.getIncom_seq();
	
	int flag = 0;
	
	// 신한 집금 완료처리
	if ( incom_gubun.equals("2") ) {
		if (ip_method.equals("1")) {  //계좌
			String bank_id 			= request.getParameter("bank_id")==null?"":request.getParameter("bank_id"); //집금 - 은행
			String acct_num 		= request.getParameter("acct_num")==null?"":request.getParameter("acct_num");  //집금 - 계좌
			String tran_date 		= request.getParameter("tran_date")==null?"":request.getParameter("tran_date");  //집금 - 입금일
			String tran_date_seq		= request.getParameter("tran_date_seq")==null?"":request.getParameter("tran_date_seq");  //집금 - 입금연번
			String acct_seq 		= request.getParameter("acct_seq")==null?"":request.getParameter("acct_seq");  //집금 - 계좌일련번호
			
			if(!ib_db.updateIbAcctTallTrDdFmsYn(acct_seq, tran_date, tran_date_seq  )) flag += 1;	
			
				
		}
	}					
			
%>
<form name='form1' action='' method='post'>
  <input type="hidden" name="auth_rw" 			value="<%=auth_rw%>">
  <input type="hidden" name="user_id" 			value="<%=user_id%>">
  <input type="hidden" name="br_id" 			value="<%=br_id%>">    
  <input type="hidden" name="incom_dt" 			value="<%=AddUtil.ChangeString(incom_dt)%>">
  <input type="hidden" name="incom_seq" 		value="<%=incom_seq%>">
  <input type="hidden" name="incom_amt" 		value="<%=incom_amt%>">
  <input type='hidden' name='v_gubun' value='Y'> 
 </form>
<script language='javascript'>
	var fm = document.form1;
<%	if( incom_seq  < 1 ){	%>
		alert('기본정보 에러입니다.\n\n등록되지 않았습니다');
<%	}else{	%>
		alert("등록되었습니다");
		fm.action = '<%=from_page%>';
		fm.target = 'd_content';
		fm.submit();
<%	}	%>
</script>
</body>
</html>
