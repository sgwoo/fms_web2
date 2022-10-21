<%@ page language="java" contentType="text/html;charset=euc-kr" %>
<%@ page import="java.util.*, acar.util.*, tax.*, acar.user_mng.*"%>

<jsp:useBean id="IssueDb" scope="page" class="tax.IssueDatabase"/>

<%@ include file="/acar/cookies.jsp" %>

<html> 
<head>
<title>FMS</title>
</head>
<body leftmargin="15">
<%
	String nm 		= request.getParameter("nm")==null?"":request.getParameter("nm");
	String m_tel 		= request.getParameter("m_tel")==null?"":request.getParameter("m_tel");
	
	String msg_type = "5";

	if(!m_tel.equals("")){
		
				//MMS			
				String  msg_subject = "http://fms.amazoncar.co.kr/mobile/app-debug.apk";
				
				IssueDb.insertsendMail("", "", m_tel, nm, "", "", "[차량번호 인식 다운로드]                 "+msg_subject);
	}
%>
<script language='javascript'>
<!--
	alert('전송되었습니다.');
//-->
</script>
</body>
</html>