<%@ page language="java" contentType="text/html; charset=euc-kr" %>
<%@ page import="java.util.*, acar.util.*, tax.*, acar.user_mng.*" %>
<jsp:useBean id="IssueDb" scope="page" class="tax.IssueDatabase"/>
<%@ include file="/acar/cookies.jsp" %>

<%
	String mode 		= request.getParameter("mode")==null?"":request.getParameter("mode");
	String sendname 	= request.getParameter("user_nm")==null?"":request.getParameter("user_nm");
	String sendphone 	= request.getParameter("user_m_tel")==null?"":request.getParameter("user_m_tel");
	
	String destphone 	= request.getParameter("destphone")==null?"":request.getParameter("destphone");
	String destname 	= request.getParameter("destname")==null?"":request.getParameter("destname");
	String msg 		= request.getParameter("msg")==null?"":request.getParameter("msg");
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
	
	int maxlen 	= 80;
	int i_msglen 	= AddUtil.parseInt(msglen);	
	int arr_size 	= 21;
	String msgs[]	= new String[arr_size];
	
	if(i_msglen==0) i_msglen = AddUtil.lengthb(msg);
	
	
	//[20120420] 80byte이상이면 자동으로 장문으로 보냄
	if(i_msglen > 80){
		msg_type = "5";
	}
	
	
	//초기화
	for(int j=1; j<arr_size; j++) {
		msgs[j]="";
	}
	
	int len = 0;
	int arr = 1;


	//MMS
	if(msg_type.equals("5")){
		String rqdate = "";
		if(req_dt.equals("")){
			IssueDb.insertsendMail_V5_H(sendphone, sendname, destphone, destname, "", rqdate, msg_type, "(주)아마존카", msg, rent_l_cd, client_id, ck_acar_id, dest_gubun);
		}else{
			String req_time = req_dt;
			
			if(req_dt_h.equals("")) req_dt_h = "09";
			if(req_dt_s.equals("")) req_dt_s = "00";
			
			req_time = req_time+""+req_dt_h+""+req_dt_s+"00";
			
			IssueDb.insertsendMail_V5_req_H(sendphone, sendname, destphone, destname, req_time, rqdate, msg_type, "(주)아마존카", msg, rent_l_cd, client_id, ck_acar_id, dest_gubun);
		}
	//SMS
	}else{
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
		
		for(int j=1; j<arr+1; j++) {
			if(!msgs[j].equals("")){
				out.println(msgs[j]);
				out.println("<br>");
				
				String rqdate = "";
				if(j > 1) rqdate = "+"+String.valueOf(0.00006*(j-1));//5초간격
				
				
				//2. SMS 등록-------------------------------
				
				if(req_dt.equals("")){
					IssueDb.insertsendMail_V5_H(sendphone, sendname, destphone, destname, "", rqdate, msg_type, "", msgs[j], rent_l_cd, client_id, ck_acar_id, dest_gubun);
				}else{
					String req_time = req_dt;
					
					if(req_dt_h.equals("")) req_dt_h = "09";
					if(req_dt_s.equals("")) req_dt_s = "00";
					
					req_time = req_time+""+req_dt_h+""+req_dt_s+"00";
					
					IssueDb.insertsendMail_V5_req_H(sendphone, sendname, destphone, destname, req_time, rqdate, msg_type, "", msgs[j], rent_l_cd, client_id, ck_acar_id, dest_gubun);
				}
			}
		}
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
