<%@ page language="java" contentType="text/html; charset=euc-kr" %>
<%@ page import="java.util.*, acar.util.*, tax.*, acar.user_mng.*" %>
<jsp:useBean id="IssueDb" scope="page" class="tax.IssueDatabase"/>
<%@ include file="/acar/cookies.jsp" %>

<%
	String mode = request.getParameter("mode")==null?"":request.getParameter("mode");
	String sendname 	= request.getParameter("sendname")==null?"":request.getParameter("sendname");
	String sendphone 	= request.getParameter("sendphone")==null?"":request.getParameter("sendphone");
	String user_id 	= request.getParameter("user_id")==null?"":request.getParameter("user_id");
	String destphone 	= request.getParameter("destphone")==null?"":request.getParameter("destphone");
	String destname 	= request.getParameter("destname")==null?"":request.getParameter("destname");
	String msg 			= request.getParameter("msg")==null?"":request.getParameter("msg");
	String msglen		= request.getParameter("msglen")==null?"":request.getParameter("msglen");
	String auto_yn 		= request.getParameter("auto_yn")==null?"":request.getParameter("auto_yn");
	String user_pos 	= request.getParameter("user_pos")==null?"":request.getParameter("user_pos");
	String req_dt	 	= request.getParameter("req_dt")==null?"":AddUtil.replace(request.getParameter("req_dt"),"-","");
	String req_dt_h 	= request.getParameter("req_dt_h")==null?"":request.getParameter("req_dt_h");
	String req_dt_s 	= request.getParameter("req_dt_s")==null?"":request.getParameter("req_dt_s");
	String msg_type 	= request.getParameter("msg_type")==null?"0":request.getParameter("msg_type");
	String msg_subject 	= request.getParameter("msg_subject")==null?"":request.getParameter("msg_subject");
	String dest_gubun	= request.getParameter("gubun1")==null?"":request.getParameter("gubun1");
	
	String rent_l_cd 	= request.getParameter("rent_l_cd")==null?"":request.getParameter("rent_l_cd");
	String client_id 	= request.getParameter("client_id")==null?"":request.getParameter("client_id");
	String firm_nm 		= request.getParameter("firm_nm")==null?"":request.getParameter("firm_nm");
	String rqdate = "";

	
	int maxlen = 80;
	int i_msglen = AddUtil.parseInt(msglen);
	if(i_msglen==0) i_msglen = AddUtil.lengthb(msg);
	int arr_size = 21;
	String msgs[]	= new String[arr_size];
	
	if(user_pos.equals("사원")){
		msg = "아마존카 상담관련 전화드렸습니다. 문자보시면 연락 부탁드립니다"+"-아마존카 "+sendname+"-";
	//	msg_type = "0";
	}else{
		msg = "아마존카 상담관련 전화드렸습니다. 문자보시면 연락 부탁드립니다"+"-아마존카 "+user_pos+" "+sendname+"-";
	}
	
	
	int len = 0;
	int arr = 1;
/*
System.out.println("sendphone: "+sendphone);
System.out.println("sendname: "+sendname);
System.out.println("destphone: "+destphone);
System.out.println("user_pos:"+user_pos);
System.out.println("destname:"+destname);
System.out.println("msg: "+msg);	
*/
	//MMS
	if(msg_type.equals("5")){
		
			IssueDb.insertsendMail_V5_H(sendphone, sendname, destphone, destname, "", rqdate, msg_type, "(주)아마존카", msg, rent_l_cd, client_id, ck_acar_id, dest_gubun);
	}else{
			
			IssueDb.insertsendMail_V5_H(sendphone, sendname, destphone, destname, "", rqdate, msg_type, "", msg, rent_l_cd, client_id, ck_acar_id, dest_gubun);
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
	alert("문자가 발송되었습니다.");
//-->
</script>
</body>
</html>
