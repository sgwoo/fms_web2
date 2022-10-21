<%@ page language="java" contentType="text/html;charset=euc-kr" %>
<%@ page import="java.util.*, acar.util.*"%>
<%@ page import="acar.user_mng.*"%>
<jsp:useBean id="IssueDb" scope="page" class="tax.IssueDatabase"/>
<%@ include file="/acar/cookies.jsp" %>

<html>
<head><title>FMS</title>
</head>
<meta http-equiv="Content-Type" content="text/html; charset=euc-kr">
<link rel=stylesheet type="text/css" href="/include/table.css">

<body leftmargin="15">
<%
	String m_id 	= request.getParameter("m_id")==null?"":request.getParameter("m_id");
	String l_cd 	= request.getParameter("l_cd")==null?"":request.getParameter("l_cd");

	String destname 	= request.getParameter("destname")==null?"":request.getParameter("destname");
	String destphone 	= request.getParameter("destphone")==null?"":request.getParameter("destphone");
	String msg 		= request.getParameter("msg")==null?"":request.getParameter("msg");
	
	
	int count = 0;
	
	UserMngDatabase umd = UserMngDatabase.getInstance();
	
	UsersBean user_bean 	= umd.getUsersBean(ck_acar_id);
%>


<%
	String msg_type = "0";
	String msg_subject = "0";
	String sms_yn = "";
		
	int msg_len = AddUtil.lengthb(msg);
		
	if(msg_len>80){
		msg_type = "5";
		msg_subject = "출고대리인 알림";
	}
		
	if(destphone.equals("")){
		sms_yn = "N";
	}else{
		IssueDb.insertsendMail_V5_H(user_bean.getUser_m_tel(), user_bean.getUser_nm(), destphone, destname, "", "", msg_type, msg_subject, msg, l_cd, "", ck_acar_id, "");
	}
		
	count = 1;
	
	

%>
<script language='javascript'>


<%	if(count==0){%>
		alert("처리되지 않았습니다");
		location='about:blank';		
<%	}else{		%>		
		alert("처리되었습니다");
		parent.window.close();
		parent.opener.location.reload();
<%	}			%>
</script>