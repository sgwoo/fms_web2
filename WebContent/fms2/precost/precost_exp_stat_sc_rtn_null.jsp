<%@ page language="java" contentType="text/html;charset=euc-kr" %>
<%@ page import="java.util.*, acar.util.*"%>
<%@ page import="acar.insur.*"%>
<%@ page import="acar.mng_exp.*"%>
<jsp:useBean id="ex_db" scope="page" class="acar.mng_exp.GenExpDatabase"/>
<%@ include file="/acar/cookies.jsp" %>

<html>
<head><title>FMS</title>
<script language='JavaScript' src='/include/common.js'></script>
<meta http-equiv="content-type" content="text/html; charset=euc-kr">
<link rel=stylesheet type="text/css" href="/include/table_t.css">
</head>
<body>
<%
	//환급자동차세
	Vector exps = ex_db.getCarExpList("", "15", "4", "3", "", "", "", "", "", "1", "0");
	int exp_size = exps.size();
	for(int i = 0 ; i < exp_size ; i++){
		Hashtable ht = (Hashtable)exps.elementAt(i);
		
		if(String.valueOf(ht.get("RTN_REQ_DT")).equals("")){
			GenExpBean exp = ex_db.getGenExp(String.valueOf(ht.get("CAR_MNG_ID")), "3", String.valueOf(ht.get("EXP_EST_DT")));
			exp.setRtn_cau		(String.valueOf(ht.get("RTN_ST")));
			exp.setRtn_cau_dt	(String.valueOf(ht.get("RTN_CAU_DT")));
			exp.setRtn_est_amt	(Util.parseDigit(String.valueOf(ht.get("ACCOUNT_RTN_AMT"))));
			if(ex_db.updateGenExp(exp)){}
		}
	}
%>
<script language='javascript'>
<!--
	alert('완료');
	window.close();
	parent.location.reload();
//-->
</script>
</body>
</html>
