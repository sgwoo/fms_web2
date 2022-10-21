<%@ page language="java" contentType="text/html;charset=euc-kr" %>
<%@ page import="java.util.*, acar.util.*"%>
<%@ include file="/acar/cookies.jsp" %>

<html>
<head>
<title>FMS</title>
</head>
<meta http-equiv="content-type" content="text/html; charset=euc-kr">
<link rel=stylesheet type="text/css" href="/include/table.css">
<body leftmargin="15">
<%
	int idx = Integer.parseInt(request.getParameter("idx"));
	
	String rtn_cont_amt = request.getParameter("loan_start_dt"+rtn_no);
	String loan_end_dt = request.getParameter("loan_end_dt"+rtn_no);
	String today = AddUtil.dateFormat("yyyyMMdd");
%>
<form name="form1" method="POST">
<input type='hidden' name='loan_start_dt' value='<%=loan_start_dt%>'>
<input type='hidden' name='loan_end_dt' value='<%=loan_end_dt%>'>
</form>
<script language="JavaScript" src='/include/common.js'></script>
<script language='javascript'>
	var fm = document.form1;	
	var p_fm = parent.document.form1;
	if(fm.loan_start_dt.value == '' || fm.loan_end_dt.value == ''){ 		
		alert("<%=rtn_no+1%>차 상환의 대출기간을 입력하십시오.\n\n수정후 대출별 등록를 하십시오.");
		p_fm.docs.focus();
	}else{	
		var today = getToday();
		var s_dt = replaceString("-","",fm.loan_start_dt.value);
		var e_dt = replaceString("-","",fm.loan_end_dt.value);
		if(parseInt(s_dt) > parseInt(today) || parseInt(today) > parseInt(e_dt)){
			alert('<%=rtn_no+1%>차 상환의 대출기간이 경과하였습니다.\n\n확인하십시오.');
			p_fm.docs.focus();
		}else{
			parent.reg_cont2();
		}
	}
</script>
</body>
</html>
