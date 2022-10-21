<%@ page language="java" contentType="text/html;charset=euc-kr"%>
<%@ page import="java.io.*, java.util.*, acar.util.*, acar.user_mng.*"%>
<%@ page import="acar.pay_mng.*, acar.bill_mng.*"%>
<%@ include file="/acar/cookies.jsp"%>


<%
	String auth_rw 		= request.getParameter("auth_rw")	==null?"":request.getParameter("auth_rw");
	String user_id 		= request.getParameter("user_id")	==null?"":request.getParameter("user_id");
	String br_id 		= request.getParameter("br_id")		==null?"":request.getParameter("br_id");
	
	String from_page	= request.getParameter("from_page")		==null?"":request.getParameter("from_page");
	String search_code 	= request.getParameter("search_code")	==null?"":request.getParameter("search_code");
	
	String payseq[]   = request.getParameterValues("payseq");	//거래일자
	
	int flag1 = 0;
	int flag2 = 0;
	int flag3 = 0;
	int flag6 = 0;
	
	
	UserMngDatabase    	umd 	= UserMngDatabase.getInstance();
	PayMngDatabase 		pm_db 	= PayMngDatabase.getInstance();
	

	//사용자
	UsersBean sender_bean 	= umd.getUsersBean(ck_acar_id);
	
	Vector vt =  pm_db.getPaySearchBundleCaseByCase(search_code);
	int vt_size = vt.size();
	
	out.println("vt_size="+vt_size+"<br><br>");
	
	for(int i = 0 ; i < vt_size ; i++){
		Hashtable ht = (Hashtable)vt.elementAt(i);
		
		//ht : off_st, off_id, p_gubun, p_way, bank_no, a_bank_no, p_est_dt, count(*) cnt, sum(amt) amt, min(reqseq) reqseq
		
		//pay 등록--------------------------------------------
		
		//출금원장
		PayMngBean bean 	= pm_db.getPaySearch(String.valueOf(ht.get("REQSEQ")));
		
		bean.setAmt		(AddUtil.parseDigit4(String.valueOf(ht.get("AMT"))));
		
		if(bean.getP_est_dt().equals("")) bean.setP_est_dt(AddUtil.getDate());
		
		String reqseq = pm_db.insertPay(bean);
		
		if(reqseq.equals("")) flag1++;
		
		String off_st 		= String.valueOf(ht.get("OFF_ST"));
		String off_id 		= String.valueOf(ht.get("OFF_ID"));
		String ven_code		= String.valueOf(ht.get("VEN_CODE"));
		String p_gubun 		= String.valueOf(ht.get("P_GUBUN"));
		String p_way 		= String.valueOf(ht.get("P_WAY"));
		String bank_no 		= String.valueOf(ht.get("BANK_NO"));
		String a_bank_no 	= String.valueOf(ht.get("A_BANK_NO"));
		String p_est_dt 	= String.valueOf(ht.get("P_EST_DT"));
		String card_no 		= String.valueOf(ht.get("CARD_NO"));
		
		//pay_item 등록
			
		//출금원장
		PayMngBean bean2 	= bean;
		
		bean2.setReqseq	(reqseq);
		bean2.setI_seq	(1);
		bean2.setI_amt	(bean2.getAmt());
			
		if(!pm_db.insertPayItem(bean2)) flag1 += 1;
		
	}
	
	
	//에러발생시 초기화
	if(flag1 > 0){
		if(!pm_db.deletePaySearchReg(search_code)) flag2 += 1;
	}
	
	//회계처리 프로시저 호출----------------------------------------------------------------------------
	String  d_flag1 =  pm_db.call_sp_pay_25300_e_autodocu(sender_bean.getUser_nm(), search_code);

%>
<html>
<head>
<title>FMS</title>
<meta http-equiv="Content-Type" content="text/html; charset=euc-kr">
<link rel=stylesheet type="text/css" href="/include/table_t.css">
<script language='javascript'>
<!--
	function go_step(){
		var fm = document.form1;
		
		<%if(from_page.equals("/fms2/forfeit_mng/forfeit_s_frame.jsp")){%>
		fm.action = '/fms2/forfeit_mng/forfeit_s_frame.jsp';
		fm.target = "d_content";
		fm.submit();

		parent.window.close();	
		<%}else if(from_page.equals("/fms2/pay_mng/pay_excel_reg_step2.jsp")){%>
		fm.action = 'pay_excel_reg.jsp';
		fm.target = "d_content";
		fm.submit();

		parent.window.close();	
		<%}else{%>
		fm.action = 'pay_list_reg.jsp';
		fm.target = 'd_content';
		fm.submit();
		<%}%>
	}
//-->
</script>
</head>
<body>
<form name='form1' action='' target='' method='post'>
<input type='hidden' name='auth_rw' value='<%=auth_rw%>'>
<input type='hidden' name='user_id' value='<%=user_id%>'>
<input type='hidden' name='br_id' value='<%=br_id%>'>
</form>
<script language='javascript'>
<!--
<%	if(flag1 > 0){//에러발생%>
		alert("에러가 발생하였습니다.");
<%	}else{//정상%>
		alert("등록하였습니다.");
		go_step();
<%	}%>
//-->
</script>
</body>
</html>
