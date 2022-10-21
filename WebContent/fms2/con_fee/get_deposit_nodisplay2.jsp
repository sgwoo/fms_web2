<%@ page language="java" contentType="text/html;charset=euc-kr" %>
<%@ page import="java.util.*, acar.bill_mng.*"%> 
<%@ include file="/acar/cookies.jsp" %>

<%
	
	NeoErpUDatabase neoe_db = NeoErpUDatabase.getInstance();
	
	String bank_code = request.getParameter("bank_code")==null?"":request.getParameter("bank_code");
	String g = request.getParameter("g")==null?"1":request.getParameter("g");
	
	Vector banks = neoe_db.getDepositList(bank_code); /* 계좌번호 */
	int bank_size = banks.size();
%>
<html>
<head><title>FMS</title>
<script language='javascript'>
<!--
<%	if(bank_size > 0){
		for(int i = 0 ; i < bank_size ; i++){
			Hashtable bank = (Hashtable)banks.elementAt(i);%>
			parent.add_deposit(0, '', '선택', '<%=g%>');
<% if (g.equals("1")){ %>			
			parent.form1.deposit_no.options[0].selected = true;
<% } else if (g.equals("2")){ %>				
			parent.form1.opt_deposit_no1.options[0].selected = true;
<% } else if (g.equals("3")){ %>				
			parent.form1.opt_deposit_no2.options[0].selected = true;
<%  } %>
			parent.add_deposit(<%=(i+1)%>, '<%= bank.get("DEPOSIT_NO")%>', '<%= bank.get("DEPOSIT_NO")%>:<%= bank.get("DEPOSIT_NAME")%>','<%=g%>');
<%		}
	}else{%>
			parent.add_deposit(0, '', '등록된계좌가없습니다', '<%=g%>');
<%	}%>
-->
</script>
</head>
<link rel=stylesheet type="text/css" href="/include/table.css">
<body leftmargin="15">
</body>
</html>
