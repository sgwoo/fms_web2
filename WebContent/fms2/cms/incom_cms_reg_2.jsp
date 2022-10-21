<%@ page language="java" contentType="text/html;charset=euc-kr"%>
<%@ page import="java.util.*, acar.util.*, acar.cont.*, acar.fee.*"%>
<jsp:useBean id="ai_db" scope="page" class="acar.incom.IncomDatabase"/>
<jsp:useBean id="at_db" scope="page" class="acar.attend.AttendDatabase"/>
<%@ include file="/acar/cookies.jsp" %>

<%

	String auth_rw 	= request.getParameter("auth_rw")==null?"":request.getParameter("auth_rw");

	String user_id 	= request.getParameter("user_id")==null?"":request.getParameter("user_id");//로그인-ID	

	//cms incom 데이타 생성
	String adate 	= request.getParameter("adate")==null?"":request.getParameter("adate");//출금의뢰일자	
	
	String incom_dt 	= request.getParameter("incom_dt")==null?"": request.getParameter("incom_dt") ;
	incom_dt = AddUtil.replace(incom_dt, "-", "");

	long  incom_amt 		= request.getParameter("incom_amt")	==null? 0:AddUtil.parseDigit4(request.getParameter("incom_amt"));
	String org_code 	= request.getParameter("org_code")==null?"":request.getParameter("org_code"); //기관코드 	
	String v_gubun 	= request.getParameter("v_gubun")==null?"N":request.getParameter("v_gubun");
			
%>

<html>
<head><title>FMS</title>
<meta http-equiv="Content-Type" content="text/html; charset=euc-kr">
<link rel=stylesheet type="text/css" href="/include/table.css">
</head>
<body>
<form name='form1' action='' method="POST">
<input type='hidden' name='auth_rw' value='<%=auth_rw%>'>
<input type='hidden' name='user_id' value='<%=ck_acar_id%>'>
<input type="hidden" name="adate" value="<%=adate%>"> 
<input type="hidden" name="incom_dt" value="<%=incom_dt%>"> 
<input type="hidden" name="incom_amt" value="<%=incom_amt%>"> 
<input type="hidden" name="org_code" value="<%=org_code%>"> 
<input type="hidden" name="v_gubun" value="<%=v_gubun%>"> 

작업중입니다. 기다려 주십시오.

</form>

<script language="JavaScript">

    modalPop();
    
	function modalPop(){ 
		
		var fm = document.form1;   	      
	      
		var site = "http://cms.amazoncar.co.kr:8080/acar/admin/incom_file22_cms_reg_a.jsp?user_id="+fm.user_id.value+"&adate="+fm.adate.value+"&incom_dt="+fm.incom_dt.value+"&incom_amt="+fm.incom_amt.value+"&org_code="+fm.org_code.value+"&v_gubun="+fm.v_gubun.value; 
		var popOptions = "dialogWidth: 15px; dialogHeight: 5px; center: yes; resizable: yes; status: no; scroll: no;"; 		
	 	
		var vReturn = window.open(site, "_parent",  popOptions ); 	
				
		return vReturn;
	   
	      
	} 

</script>
<iframe src="about:blank" name="i_no" width="0" height="0" frameborder="0" noresize></iframe>
</body>
</html>


