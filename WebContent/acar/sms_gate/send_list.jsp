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
	
	
	//�޽��� ���� ����-------------------------------------
	
	int maxlen 	= 80;
	int i_msglen 	= AddUtil.parseInt(msglen);	
	int arr_size 	= 21;
	String msgs[]	= new String[arr_size];
	
	if(i_msglen==0) i_msglen = AddUtil.lengthb(msg);
	
	
	//[20120420] 80byte�̻��̸� �ڵ����� �幮���� ����
	if(i_msglen > 80){
		msg_type = "5";
	}	
	
	//����-����-���������̸� �幮���� ����
	if(dest_gubun.equals("4") && dest_gubun2.equals("3")){
		msg_type = "5";
	}
	
	
	//�ʱ�ȭ
	for(int j=1; j<arr_size; j++) {
		msgs[j]="";
	}
	
	int len = 0;
	int arr = 1;
	
	
	//MMS
	if(msg_type.equals("5")){
		String rqdate = "";
		if(req_dt.equals("")){	//��ù߼�
			count = umd.sendMail_V5(sendphone, sendname, destphone, destname, msg_type, "(��)�Ƹ���ī", msg, pr, rqdate, ck_acar_id, dest_gubun, dest_gubun2, excel_msg);
		}else{					//����߼�
			String req_time = req_dt;
			
			if(req_dt_h.equals("")) req_dt_h = "09";
			if(req_dt_s.equals("")) req_dt_s = "00";
			
			req_time = req_time+""+req_dt_h+""+req_dt_s+"00";
			
			count = umd.sendMail_V5_req(sendphone, sendname, destphone, destname, msg_type, "(��)�Ƹ���ī", msg, pr, req_time, rqdate, ck_acar_id, dest_gubun, dest_gubun2, excel_msg);
		}
	//SMS
	}else{
		if(maxlen < i_msglen){
			for(int i=0; i<msg.length(); i++) {
				
				String cs = String.valueOf(msg.charAt(i));
				int    ci = (int)msg.charAt(i);
				
				if(ci > 256) 	len+=2;	//1 ����Ʈ�� ǥ���� �� �ִ� ũ���� 256 ���� ũ�ٸ� 2����Ʈ
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
			if(j > 1) rqdate = "+"+String.valueOf(0.00006*(j-1));//5�ʰ���
			if(!msgs[j].equals("")){
				//2. SMS ���-------------------------------
				if(req_dt.equals("")){
					count = umd.sendMail_V5(sendphone, sendname, destphone, destname, msg_type, "(��)�Ƹ���ī", msgs[j], pr, rqdate, ck_acar_id, dest_gubun);
				}else{
					String req_time = req_dt;
					
					if(req_dt_h.equals("")) req_dt_h = "09";
					if(req_dt_s.equals("")) req_dt_s = "00";
					
					req_time = req_time+""+req_dt_h+""+req_dt_s+"00";
					
					count = umd.sendMail_V5_req(sendphone, sendname, destphone, destname, msg_type, "(��)�Ƹ���ī", msgs[j], pr, req_time, rqdate, ck_acar_id, dest_gubun);
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
	alert("<%= count[1] %>�� ���ڰ� ���������� �߼۵Ǿ����ϴ�.");
<%}else{%>
	alert("�����ͺ��̽� �����Դϴ�.\n�����ڴԲ� �����ϼ���!");
<%}%> 
//-->
</script>
</body>
</html>
