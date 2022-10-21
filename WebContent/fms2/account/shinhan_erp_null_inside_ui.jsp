<%@ page language="java" contentType="text/html;charset=euc-kr" %>
<%@ page import="java.util.*, acar.util.*"%>
<%@ include file="/acar/cookies.jsp" %>
<jsp:useBean id="ib_db" scope="page" class="acar.inside_bank.InsideBankDatabase"/>

<%
	String auth_rw = request.getParameter("auth_rw")==null?"":request.getParameter("auth_rw");
	String br_id = request.getParameter("br_id")==null?"":request.getParameter("br_id");
	String user_id = request.getParameter("user_id")==null?ck_acar_id:request.getParameter("user_id");

	String s_kd = request.getParameter("s_kd")==null?"1":request.getParameter("s_kd");
	String t_wd = request.getParameter("t_wd")==null?"":request.getParameter("t_wd");
	
	int flag = 0;
	
	 
	String acct_seq 		= request.getParameter("acct_seq")==null?"":request.getParameter("acct_seq");  //집금 - 계좌일련번호
	String tran_date 		= request.getParameter("tran_date")==null?"":request.getParameter("tran_date");  //집금 - 입금일
	String tran_date_seq		= request.getParameter("tran_date_seq")==null?"":request.getParameter("tran_date_seq");  //집금 - 입금연번
			
	if(!ib_db.updateIbAcctTallTrDdFmsYn(acct_seq, tran_date, tran_date_seq  )) flag += 1;	

%>
<html>
<head><title>FMS</title>
<link rel=stylesheet type="text/css" href="/include/table_t.css">
</head>
<body>

<form name='form1' action='' method="POST">
  <input type='hidden' name='auth_rw' 	value='<%=auth_rw%>'>
  <input type='hidden' name='user_id' 	value='<%=user_id%>'>
  <input type='hidden' name='br_id' 	value='<%=br_id%>'>
  <input type='hidden' name='s_kd' 	value='<%=s_kd%>'>
  <input type='hidden' name='t_wd' 	value='<%=t_wd%>'>
</form>

<script language="JavaScript">
<!--
	var fm = document.form1;
	<%	if(flag==0){%>
			alert("처리되었습니다.");	
			fm.action='./shinhan_erp_demand_inside.jsp';
			fm.target='AncDisp';
			fm.submit();					
			
	<%	}else{%>
		alert('에러가 발생!');
	<%	}%>

//-->
</script>

</body>
</html>
