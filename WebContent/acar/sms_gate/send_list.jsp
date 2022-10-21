<%@ page language="java" contentType="text/html; charset=euc-kr" %>
<%@ page import="java.util.*, acar.util.*, acar.car_office.*" %>
<%@ include file="/acar/cookies.jsp" %>

<%
	String auth_rw 		= request.getParameter("auth_rw")==null?"":request.getParameter("auth_rw");
	String sendphone 	= request.getParameter("sendphone")==null?"":request.getParameter("sendphone");
	String sendname 	= request.getParameter("sendname")==null?"":request.getParameter("sendname");
	String msg 		= request.getParameter("msg")==null?"":request.getParameter("msg");
	String req_dt	 	= request.getParameter("req_dt")==null?"":AddUtil.replace(request.getParameter("req_dt"),"-","");
	String req_dt_h 	= request.getParameter("req_dt_h")==null?"":request.getParameter("req_dt_h");
	String req_dt_s 	= request.getParameter("req_dt_s")==null?"":request.getParameter("req_dt_s");
	String msg_type 	= request.getParameter("msg_type")==null?"0":request.getParameter("msg_type");
	String msg_subject 	= request.getParameter("msg_subject")==null?"":request.getParameter("msg_subject");
	String dest_gubun	= request.getParameter("gubun1")==null?"":request.getParameter("gubun1");
	String dest_gubun2	= request.getParameter("gubun2")==null?"":request.getParameter("gubun2");
	
	
	String msglen		= request.getParameter("msglen")==null?"":request.getParameter("msglen");
	String auto_yn 		= request.getParameter("auto_yn")==null?"":request.getParameter("auto_yn");
	String user_pos 	= request.getParameter("user_pos")==null?"":request.getParameter("user_pos");
	String[] destphone 	= request.getParameterValues("destphone");
	String[] destname 	= request.getParameterValues("destname");
	String[] excel_msg 	= request.getParameterValues("excel_msg");
	String[] pr 		= request.getParameterValues("pr");
	
	int[] count = new int[2];

	CarOfficeDatabase umd = CarOfficeDatabase.getInstance();
	
	
	//메시지 분할 전송-------------------------------------
	
	int maxlen 	= 80;
	int i_msglen 	= AddUtil.parseInt(msglen);	
	int arr_size 	= 21;
	String msgs[]	= new String[arr_size];
	
	if(i_msglen==0) i_msglen = AddUtil.lengthb(msg);
	
	
	//[20120420] 80byte이상이면 자동으로 장문으로 보냄
	if(i_msglen > 80){
		msg_type = "5";
	}	
	
	//직접-엑셀-개별문자이면 장문으로 보냄
	if(dest_gubun.equals("4") && dest_gubun2.equals("3")){
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
		if(req_dt.equals("")){	//즉시발송
			count = umd.sendMail_V5(sendphone, sendname, destphone, destname, msg_type, "(주)아마존카", msg, pr, rqdate, ck_acar_id, dest_gubun, dest_gubun2, excel_msg);
		}else{					//예약발송
			String req_time = req_dt;
			
			if(req_dt_h.equals("")) req_dt_h = "09";
			if(req_dt_s.equals("")) req_dt_s = "00";
			
			req_time = req_time+""+req_dt_h+""+req_dt_s+"00";
			
			count = umd.sendMail_V5_req(sendphone, sendname, destphone, destname, msg_type, "(주)아마존카", msg, pr, req_time, rqdate, ck_acar_id, dest_gubun, dest_gubun2, excel_msg);
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
			String rqdate = "";
			if(j > 1) rqdate = "+"+String.valueOf(0.00006*(j-1));//5초간격
			if(!msgs[j].equals("")){
				//2. SMS 등록-------------------------------
				if(req_dt.equals("")){
					count = umd.sendMail_V5(sendphone, sendname, destphone, destname, msg_type, "(주)아마존카", msgs[j], pr, rqdate, ck_acar_id, dest_gubun);
				}else{
					String req_time = req_dt;
					
					if(req_dt_h.equals("")) req_dt_h = "09";
					if(req_dt_s.equals("")) req_dt_s = "00";
					
					req_time = req_time+""+req_dt_h+""+req_dt_s+"00";
					
					count = umd.sendMail_V5_req(sendphone, sendname, destphone, destname, msg_type, "(주)아마존카", msgs[j], pr, req_time, rqdate, ck_acar_id, dest_gubun);
				}
			}
		}
	}

//	count = umd.sendMail(sendphone, sendname, destphone, destname, msg, pr);

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
<%if(count[0]>0){%>
	alert("<%= count[1] %>건 문자가 정상적으로 발송되었습니다.");
<%}else{%>
	alert("데이터베이스 에러입니다.\n관리자님께 문의하세요!");
<%}%> 
//-->
</script>
</body>
</html>
