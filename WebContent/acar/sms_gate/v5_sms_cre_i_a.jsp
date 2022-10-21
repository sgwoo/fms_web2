<%@ page language="java" contentType="text/html; charset=euc-kr" %>
<%@ page import="java.util.*, acar.util.*, tax.*, acar.user_mng.*" %>
<jsp:useBean id="IssueDb" scope="page" class="tax.IssueDatabase"/>
<%@ include file="/acar/cookies.jsp" %>

<%
	UserMngDatabase umd = UserMngDatabase.getInstance();
	
	
	String firm_nm 		= request.getParameter("firm_nm")==null?"":request.getParameter("firm_nm");
	String client_id 	= request.getParameter("client_id")==null?"":request.getParameter("client_id");
	String rent_l_cd 	= request.getParameter("rent_l_cd")==null?"":request.getParameter("rent_l_cd");
	
	String destname 	= request.getParameter("destname")==null?"":request.getParameter("destname");
	String destphone 	= request.getParameter("destphone")==null?"":request.getParameter("destphone");
	
	String msg_subject 	= request.getParameter("msg_subject")==null?"":request.getParameter("msg_subject");
	String msg 			= request.getParameter("msg")==null?"":request.getParameter("msg");
	
	String cmd 			= request.getParameter("cmd")==null?"":request.getParameter("cmd");
	
	String msg_type 	= "5"; //장문자

	
	UsersBean sender_bean = umd.getUsersBean(ck_acar_id);
	
	
	String sendname 	= sender_bean.getUser_nm();
	String sendphone 	= sender_bean.getUser_m_tel();
	
	if(!sender_bean.getHot_tel().equals("")){
		sendphone = sender_bean.getHot_tel();
	}
	

	String cmid 		= request.getParameter("cmid")==null?"":request.getParameter("cmid");
	String check = request.getParameter("check")==null?"":request.getParameter("check");
	String bus_id = request.getParameter("bus_id")==null?"":request.getParameter("bus_id");
	String score = request.getParameter("score")==null?"":request.getParameter("score");
	
	if(cmd.equals("u")){
		IssueDb.updatesendMail_V5_H2(cmid, ck_acar_id, bus_id, score);
	}else{
		IssueDb.insertsendMail_V5_H2(sendphone, sendname, destphone, destname, "", "", msg_type, msg_subject, msg, firm_nm, client_id, ck_acar_id, "cre", check, bus_id, score);
	}
	


	
	
	
	
%>
<html>
<head>

<title>FMS</title>
<meta http-equiv="Content-Type" content="text/html; charset=euc-kr">
<link rel="stylesheet" type="text/css" href="/include/table_t.css"></link>
</head>
<body>
<script language="JavaScript">
<!--
<%if(cmd.equals("u")){%>
	alert("내용이 수정되었습니다.");
<%}else{%>
	alert("문자가 발송되었습니다.");
<%}%>
 	parent.location.reload();
//-->
</script>
</body>
</html>
