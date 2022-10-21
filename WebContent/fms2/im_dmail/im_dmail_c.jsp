<%@ page language="java" contentType="text/html;charset=euc-kr" %>
<%@ page import="java.util.*, acar.util.*"%>
<%@ page import="acar.im_email.*, acar.user_mng.*"%>
<%@ include file="/acar/cookies.jsp" %>

<%
	String dm_st 	= request.getParameter("dm_st")==null?"":request.getParameter("dm_st");	
	String dmidx 	= request.getParameter("dmidx")==null?"":request.getParameter("dmidx");	
	
	ImEmailDatabase ie_db = ImEmailDatabase.getInstance();
	
	
	String content  =  ie_db.getIm_dmail_content(dmidx, dm_st);
	
	content = AddUtil.replace(content,"fms2","fms1");
%>


<html>
<head>
<title>FMS</title>
<meta http-equiv="content-type" content="text/html; charset=euc-kr">
<link rel="stylesheet" type="text/css" href="/include/table_t.css">
<script language="JavaScript" src="/include/common.js"></script>
<script language="JavaScript">
<!--
	function move_email(){
		var fm = document.form1;	
	   	fm.action = '<%=content%>';		
		fm.submit();
	}
//-->
</script>
</head>
<body>
<form action="./issue_3_sc_a.jsp" name="form1" method="POST">
  <input type='hidden' name='dmidx' 	value='<%=dmidx%>'>    
  <input type='hidden' name='dm_st' 	value='<%=dm_st%>'>        
<script language="JavaScript">
<!--
	<%if(!content.equals("")){%>
	move_email();
	<%}%>
//-->
</script>  
</form>	
</body>
</html>