<%@ page language="java" contentType="text/html;charset=euc-kr" %>
<%@ page import="java.util.*, acar.bill_mng.*"%> 
<%@ include file="/acar/cookies.jsp" %>

<%	
	NeoErpUDatabase neoe_db = NeoErpUDatabase.getInstance();
	
	String bank_code = request.getParameter("bank_code")==null?"":request.getParameter("bank_code");
	
	Vector banks = neoe_db.getDepositList(bank_code);
	int bank_size = banks.size();
%>
<html>
<head><title>FMS</title>
<script language='javascript'>
<!--
<%	if(bank_size > 0){
		for(int i = 0 ; i < bank_size ; i++){
			Hashtable bank = (Hashtable)banks.elementAt(i);%>
			parent.add_deposit(0, '', '선택');
			parent.form1.deposit_no_d.options[0].selected = true;
			parent.add_deposit(<%=(i+1)%>, '<%= bank.get("DEPOSIT_NO")%>', '<%= bank.get("DEPOSIT_NO")%>:<%= bank.get("DEPOSIT_NAME")%>');
<%		}
	}else{%>
			parent.add_deposit(0, '', '등록된계좌가없습니다');
<%	}%>
//-->
</script>
</head>
<link rel=stylesheet type="text/css" href="/include/table.css">
<body leftmargin="15">
</body>
</html>
