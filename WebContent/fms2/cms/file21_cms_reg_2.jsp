<%@ page language="java" contentType="text/html;charset=euc-kr"%>
<%@ page import="java.util.*, acar.util.*, acar.cont.*, acar.fee.*"%>
<jsp:useBean id="ai_db" scope="page" class="acar.incom.IncomDatabase"/>
<jsp:useBean id="at_db" scope="page" class="acar.attend.AttendDatabase"/>
<%@ include file="/acar/cookies.jsp" %>

<%

	String auth_rw 	= request.getParameter("auth_rw")==null?"":request.getParameter("auth_rw");
	String user_id 	= request.getParameter("user_id")==null?"":request.getParameter("user_id");//로그인-ID	
	String from_page = request.getParameter("from_page")==null?"":request.getParameter("from_page");
	String adate = request.getParameter("adate")==null?"":request.getParameter("adate");	
		
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
<input type='hidden' name='from_page' value='<%=from_page%>'>
<input type="hidden" name="adate" value="<%=adate%>"> 

작업중입니다. 기다려 주십시오.

</form>

<script language="JavaScript">

    modalPop();
    
	function modalPop(){ 
		var fm = document.form1;
		var site = "http://cms.amazoncar.co.kr:8080/acar/admin/file21_cms_reg_a.jsp?adate="+fm.adate.value;    
 		
		var popOptions = "dialogWidth: 15px; dialogHeight: 5px; center: yes; resizable: yes; status: no; scroll: no;"; 		
	//	var vReturn = window.showModalDialog(site, window,  popOptions ); 	
		var vReturn = window.open(site, "_parent",  popOptions ); 	
				
		return vReturn;
	} 

</script>
<iframe src="about:blank" name="i_no" width="0" height="0" frameborder="0" noresize></iframe>
</body>
</html>


