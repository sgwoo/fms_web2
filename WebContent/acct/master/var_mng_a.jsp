<%@ page language="java" contentType="text/html; charset=euc-kr" %>
<%@ page import="java.util.*, acar.util.*, acar.user_mng.*, acct.*, acar.estimate_mng.* "%>
<%@ include file="/acct/cookies.jsp" %>

<%	
	String auth_rw 	= request.getParameter("auth_rw")	==null?"":request.getParameter("auth_rw");
	String user_id 	= request.getParameter("user_id")	==null?"":request.getParameter("user_id");
	String br_id 	= request.getParameter("br_id") 	==null?"":request.getParameter("br_id");


	int size 	= request.getParameter("size")	 	==null?0:AddUtil.parseDigit(request.getParameter("size"));
	

	String value1[]  = request.getParameterValues("var_cd");
	String value2[]  = request.getParameterValues("var_sik");

	
	
	
	
	int count = 0;
	
	EstiDatabase e_db = EstiDatabase.getInstance();
	
	for(int i = 0 ; i < size ; i++){
	
		String var_cd 	= value1[i]==null?"":value1[i];
		String var_sik 	= value2[i]==null?"":value2[i];
		
		if(var_cd.equals("acct_s_dt") || var_cd.equals("acct_e_dt")) 		var_sik = AddUtil.replace(var_sik, "-", "");
		
		
		EstiSikVarBean bean = e_db.getEstiSikVarCaseDly("1", "01", var_cd);
		bean.setVar_sik(var_sik);
		count = e_db.updateEstiSikVar(bean);
		
	}

%>


<html>
<head>
<title>FMS</title>
<meta http-equiv="Content-Type" content="text/html; charset=euc-kr">
<link rel="stylesheet" type="text/css" href="/acct/include/table_t.css"></link>
<script language='JavaScript' src='/include/common.js'></script>
<script language='javascript'>
<!--

//-->
</script>
</head>
<body leftmargin="15">
<script language='javascript'>
<!--
	<%if(count==0){%>
		alert('등록오류!!');
	<%}else{%>
		alert('등록되었습니다.');
		parent.f_init();
	<%}%>
//-->
</script>
</body>
</html>
