<%@ page language="java" contentType="text/html;charset=euc-kr" %>
<%@ page import="java.util.*, acar.util.* "%>
<%@ page import="acar.bank_mng.*, acar.bill_mng.*"%>
<jsp:useBean id="abl_db" scope="page" class="acar.bank_mng.AddBankLendDatabase"/>
<%@ include file="/acar/cookies.jsp" %>

<%

	String fund_id 	= request.getParameter("fund_id")==null?"":request.getParameter("fund_id");
	String lend_id 	= request.getParameter("lend_id")==null?"":request.getParameter("lend_id");
	String from_page = request.getParameter("from_page")==null?"":request.getParameter("from_page");
	String s_lend_id = "";
	
	
	String vid1[] 		= request.getParameterValues("ch_l_cd");
	int vid_size 		= vid1.length;
	
	boolean flag1 = true;
	int flag = 0;
	
	
	if(lend_id.equals("")){
		for(int i=0;i < vid_size;i++){
			s_lend_id = vid1[i];
			
			//은행대출 정보
			BankLendBean bl = abl_db.getBankLend(s_lend_id);
				
			flag1 = abl_db.updateBankLendFundId(bl, fund_id);	
			
			if(!flag1) flag += 1;
		}
	}else{
		//은행대출 정보
		BankLendBean bl = abl_db.getBankLend(lend_id);
				
		flag1 = abl_db.updateBankLendFundId(bl, fund_id);	
		
		if(!flag1) flag += 1;
	
	}
	
		
%>

<html>
<head><title>FMS</title>
</head>
<meta http-equiv="content-type" content="text/html; charset=euc-kr">
<link rel=stylesheet type="text/css" href="/include/table.css">
<body leftmargin="15">
<script language='javascript'>




	var fm = parent.opener.form1;
	
	<%if(flag > 0){//에러발생%>
	alert("에러가 발생하였습니다.");
	<%}else{%>
	alert('정상적으로 연결되었습니다.');
	parent.opener.go_to_self();
	parent.window.close();
	<%}%>			
	
	
	
</script>
</body>
</html>
