<%@ page language="java" contentType="text/html;charset=euc-kr" %>
<%@ page import="java.util.*, acar.util.*, acar.cont.*, tax.*, acar.user_mng.*"%>
<jsp:useBean id="IssueDb" scope="page" class="tax.IssueDatabase"/>
<%@ include file="/acar/cookies.jsp" %>

<html>
<head>
<title>FMS</title>
</head>
<body leftmargin="15">
<%
	
	String sendname 	= "아마존카";
	String sendphone	= "02-6263-6373";
	String destname		= request.getParameter("cust_nm")==null?"":request.getParameter("cust_nm");
	String destphone	= request.getParameter("cust_tel")==null?"":request.getParameter("cust_tel");
	
	String car_mng_id	= request.getParameter("car_mng_id")==null?"":request.getParameter("car_mng_id");
	
	String msg 			= request.getParameter("sms_msg")==null?"":request.getParameter("sms_msg");
	String msglen 		= request.getParameter("msglen")==null?"":request.getParameter("msglen");

	String req_dt	 	= request.getParameter("req_dt")==null?"":AddUtil.replace(request.getParameter("req_dt"),"-","");
	String req_dt_h 	= request.getParameter("req_dt_h")==null?"":request.getParameter("req_dt_h");
	String req_dt_s 	= request.getParameter("req_dt_s")==null?"":request.getParameter("req_dt_s");
	String msg_type 	= request.getParameter("msg_type")==null?"0":request.getParameter("msg_type");
	String msg_subject 	= request.getParameter("msg_subject")==null?"":request.getParameter("msg_subject");


	int maxlen = 80;
	int i_msglen = AddUtil.parseInt(msglen);
	int arr_size = 21;
	String msgs[]	= new String[arr_size];
	
	
	//초기화
	for(int j=1; j<arr_size; j++) {
		msgs[j]="";
	}
	
	msg = msg + "- 아마존카-";


	if(!destphone.equals("")){
				
			//MMS
			if(msg_type.equals("5")){
				String rqdate = "";
				if(msg_subject.equals("")) msg_subject = "(주)아마존카";
				
					IssueDb.insertsendMail_V5_H(sendphone, sendname, destphone, "월렌트", "", rqdate, msg_type, msg_subject, msg, car_mng_id, "", ck_acar_id, "5");
				

			}
			

	}
		
%>
<script language='javascript'>
<!--
	alert('전송되었습니다.');
	parent.document.form1.msgs.value = '';
	parent.document.form1.msglen.value = '0';
//-->
</script>
</body>
</html>