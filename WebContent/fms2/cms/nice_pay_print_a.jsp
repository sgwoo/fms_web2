<%@ page language="java" contentType="text/html;charset=euc-kr"%>
<%@ page import="java.util.*, acar.util.*"%>
<jsp:useBean id="ai_db" scope="page" class="acar.incom.IncomDatabase"/>
<%@ include file="/acar/cookies.jsp" %>


<html>
<head><title>FMS</title>

<script language='javascript'>
<!--

//-->
</script>
<meta http-equiv="content-type" content="text/html; charset=euc-kr">
<link rel=stylesheet type="text/css" href="/include/table_t.css">
</head>

<%
	
	String adate 	= request.getParameter("adate")==null?"":request.getParameter("adate");

	int    scd_size 	= request.getParameter("scd_size")		==null?0 :AddUtil.parseInt(request.getParameter("scd_size"));

	String value0[]  = request.getParameterValues("user_no");//계약번호
	String value1[]  = request.getParameterValues("amount"); //예정액
	
   int flag = 0;
			
   	for(int i=0 ; i < scd_size ; i++){
			
				
			if(!value0[i].equals("")){		//제외
			
				int pay_amt = value1[i]	==null?0 :AddUtil.parseDigit(value1[i]);
				
				if(!ai_db.updateCardCmsPayAmount(adate , value0[i], pay_amt))	flag += 1;
	    	}
	}		
	
%>
<html>
<head><title>FMS</title></head>
<body style="font-size:12">

<form name='form1' method="POST">

</form>

<script language='javascript'>
	var fm = document.form1;

<%	if(flag != 0){ 	//테이블에 저장 실패%>
	alert('등록 오류발생!');

<%	}else{ 			//테이블에 저장 성공.. %>
	
    alert('처리되었습니다');				
  
<%	
	} %>
</script>

</body>
</html>