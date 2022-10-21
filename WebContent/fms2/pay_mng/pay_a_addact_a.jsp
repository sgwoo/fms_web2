<%@ page language="java" contentType="text/html;charset=euc-kr" %>
<%@ page import="java.util.*, acar.util.*"%>
<%@ page import="acar.pay_mng.*, acar.doc_settle.*, acar.car_sche.*, acar.user_mng.*, card.*"%>
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
	String st_dt 	= request.getParameter("st_dt")==null?"":request.getParameter("st_dt");
	String end_dt 	= request.getParameter("end_dt")==null?"":request.getParameter("end_dt");
	String from_page = request.getParameter("from_page")==null?"":request.getParameter("from_page");
	String mode 	= request.getParameter("mode")==null?"":request.getParameter("mode");
	
	String bank_code 	= request.getParameter("bank_code")==null?"":request.getParameter("bank_code");
	
	
	boolean flag1 = true;
	boolean flag2 = true;
	boolean flag3 = true;
	boolean flag4 = true;
	boolean flag5 = true;
	boolean flag6 = true;
	int flag = 0;
	int result = 0;
	
	
	MaMenuDatabase nm_db = MaMenuDatabase.getInstance();
	PayMngDatabase pm_db = PayMngDatabase.getInstance();
	UserMngDatabase umd = UserMngDatabase.getInstance();
	
	
%>


<%
	//은행송금요청-계좌이체일 경우
	Vector vt =  pm_db.getPayABankCodeList2(bank_code);
	int vt_size = vt.size();
	
	for(int i = 0 ; i < vt_size ; i++){
		Hashtable ht = (Hashtable)vt.elementAt(i);
		
		if(String.valueOf(ht.get("P_WAY")).equals("5")||String.valueOf(ht.get("P_WAY")).equals("2")){
			PayMngActBean act = new PayMngActBean();
			
			act.setActseq		("");
			act.setAct_st		("1");
			act.setAct_dt		(String.valueOf(ht.get("PAY_DT")));
			act.setAmt			(AddUtil.parseDigit4(String.valueOf(ht.get("AMT"))));
			act.setOff_nm		(String.valueOf(ht.get("OFF_NM")));
			act.setBank_id		(String.valueOf(ht.get("BANK_ID")));
			act.setBank_no		(String.valueOf(ht.get("BANK_NO")));
			act.setBank_nm		(String.valueOf(ht.get("BANK_NM")));
			act.setBank_acc_nm	(String.valueOf(ht.get("BANK_ACC_NM")));
			act.setA_bank_id	(String.valueOf(ht.get("A_BANK_ID")));
			act.setA_bank_nm	(String.valueOf(ht.get("A_BANK_NM")));
			act.setA_bank_no	(String.valueOf(ht.get("A_BANK_NO")));
			act.setBank_cms_bk	(String.valueOf(ht.get("BANK_CMS_BK")));
			act.setA_bank_cms_bk(String.valueOf(ht.get("A_BANK_CMS_BK")));
			act.setAct_bit		("");
			act.setReg_id		(nm_db.getWorkAuthUser("출금담당"));
			act.setBank_code	(bank_code);
			act.setApp_id		("000004");
			
			if(!pm_db.insertPayAct(act)) flag += 1;
		}
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
			fm.action = 'pay_a_frame.jsp';
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