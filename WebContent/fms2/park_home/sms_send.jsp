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
	String m_id 		= request.getParameter("m_id")==null?"":request.getParameter("m_id");
	String l_cd 		= request.getParameter("l_cd")==null?"":request.getParameter("l_cd");
	
	String sendname 	= request.getParameter("sendname")==null?"":request.getParameter("sendname");
	String sendphone	= request.getParameter("sendphone")==null?"":request.getParameter("sendphone");
	String destphone	= request.getParameter("destphone")==null?"":request.getParameter("destphone");
	String msg 			= request.getParameter("msg")==null?"":request.getParameter("msg");

	String car_no 		= request.getParameter("car_no")==null?"":request.getParameter("car_no");

	String req_dt	 	= request.getParameter("req_dt")==null?"":AddUtil.replace(request.getParameter("req_dt"),"-","");
	String req_dt_h 	= request.getParameter("req_dt_h")==null?"":request.getParameter("req_dt_h");
	String req_dt_s 	= request.getParameter("req_dt_s")==null?"":request.getParameter("req_dt_s");
	String msg_type 	= request.getParameter("msg_type")==null?"5":request.getParameter("msg_type");
	String msg_subject 	= request.getParameter("msg_subject")==null?"":request.getParameter("msg_subject");
	String from_page 	= request.getParameter("from_page")==null?"":request.getParameter("from_page");
	int msglen = 0;
	msg = car_no+"차량의 상태를 확인하여 배/반차 및 현위치를 확인해 주시기 바랍니다. - 주차관리자";
	msglen = msg.length();
	int maxlen = 80;
	int i_msglen = msglen;
	int arr_size = 21;
	String msgs[]	= new String[arr_size];
	
	//초기화
	for(int j=1; j<arr_size; j++) {
		msgs[j]="";
	}
		
	//destphone = "010-8653-4000";
	//System.out.println(destphone);	
	if(!destphone.equals("")){
				
			//MMS
			if(msg_type.equals("5")){
				String rqdate = "";
				if(msg_subject.equals("")) msg_subject = "(주)아마존카";
				
					IssueDb.insertsendMail_V5_H(sendphone, sendname, destphone, "", "", rqdate, msg_type, msg_subject, msg, "", "", ck_acar_id, "5");
				
				
			//SMS
			}else{
				
				int len = 0;
				int arr = 1;
				
				if(maxlen < i_msglen){
					for(int i=0; i<msg.length(); i++) {
						
						String cs = String.valueOf(msg.charAt(i));
						int    ci = (int)msg.charAt(i);
						
						if(ci > 256) 	len+=2;	//1 바이트로 표현할 수 있는 크기인 256 보다 크다면 2바이트
						else 			len++;
						
						for(int j=1; j<arr_size; j++) {
							if(arr == j && (len == maxlen*j || len == maxlen*j-1)) len++;
							if(arr == j && len >= maxlen*j) arr++;
							if(arr == j && len <= maxlen*j) msgs[arr] = msgs[arr] + cs;
						}
					}
				}else{
					msgs[1]=msg;
				}
				
				
				for(int j=1; j<arr_size; j++) {
					if(!msgs[j].equals("")){
						out.println(msgs[j]);
						out.println("<br>");
						
						String rqdate = "";
						if(j > 1) rqdate = "+"+String.valueOf(0.00006*(j-1));//5초간격
						
						if(req_dt.equals("")){
							IssueDb.insertsendMail_V5_H(sendphone, sendname, destphone, "", "", rqdate, msg_type, "", msgs[j], "", "", ck_acar_id, "5");
						}else{
							String req_time = req_dt;
							
							if(req_dt_h.equals("")) req_dt_h = "09";
							if(req_dt_s.equals("")) req_dt_s = "00";
							
							req_time = req_time+""+req_dt_h+""+req_dt_s+"00";
							
							IssueDb.insertsendMail_V5_req_H(sendphone, sendname, destphone, "", req_time, rqdate, msg_type, "", msgs[j], "", "", ck_acar_id, "5");
						}
					}
				}
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