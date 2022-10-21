<%@ page language="java" contentType="text/html;charset=euc-kr" %>
<%@ page import="java.util.*, acar.util.* "%>
<%@ page import="acar.bank_mng.*, acar.bill_mng.*"%>
<jsp:useBean id="abl_db" scope="page" class="acar.bank_mng.AddBankLendDatabase"/>
<%@ include file="/acar/cookies.jsp" %>

<html>
<head><title>FMS</title>
</head>
<meta http-equiv="content-type" content="text/html; charset=euc-kr">
<link rel=stylesheet type="text/css" href="/include/table.css">
<body leftmargin="15">
<script language='javascript'>

<%

	String fund_id 	= request.getParameter("fund_id")==null?"":request.getParameter("fund_id");
	String lend_id 	= request.getParameter("lend_id")==null?"":request.getParameter("lend_id");
	String from_page = request.getParameter("from_page")	==null?"":request.getParameter("from_page");
	
	
	//은행대출 정보
	BankLendBean bl = abl_db.getBankLend(lend_id);
	
	boolean flag1 = abl_db.updateBankLendFundId(bl, fund_id);
		
%>


	var fm = parent.opener.form1;
	

	alert('정상적으로 연결되었습니다.');
	parent.opener.go_to_self();
	parent.window.close();	
	
	
</script>
</body>
</html>
