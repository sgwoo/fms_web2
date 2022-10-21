<%@ page language="java" contentType="text/html;charset=euc-kr" %>
<%@ page import="java.util.*, acar.util.*, tax.*, acar.user_mng.*"%>
<%@ page import="acar.kakao.*" %>

<%@ include file="/acar/cookies.jsp" %>

<html>
<head>
<title>FMS</title>
</head>
<body leftmargin="15">
<%
		
	String sendname = request.getParameter("sendname")==null?"":request.getParameter("sendname");
	String sendphone= request.getParameter("sendphone")==null?"":request.getParameter("sendphone");
	String destphone= request.getParameter("destphone")==null?"":request.getParameter("destphone");
	String msg 		= request.getParameter("msg")==null?"":request.getParameter("msg");
	String msglen 	= request.getParameter("msglen")==null?"":request.getParameter("msglen");
	String firm_nm 	= request.getParameter("firm_nm")==null?"":request.getParameter("firm_nm");
	String auto_yn 	= request.getParameter("auto_yn")==null?"":request.getParameter("auto_yn");
		
	AlimTalkDatabase at_db = AlimTalkDatabase.getInstance();
	
	int maxlen = 80;
	int i_msglen = AddUtil.parseInt(msglen);
	int arr_size = 21;
	String msgs[]	= new String[arr_size];
	
	
	//초기화
	for(int j=1; j<arr_size; j++) {
		msgs[j]="";
	}
	
	if(auto_yn.equals("Y")){
		msg = msg + "-아마존카-";
		i_msglen = i_msglen + 10;
	}
	
	if(!destphone.equals("")){		
				
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
					//if(auto_yn.equals("Y"))	msgs[j] = msgs[j] + "-아마존카-";
					out.println(msgs[j]);
					out.println("<br>");
					
					String rqdate = "";
					if(j > 1) rqdate = "+"+String.valueOf(0.00006*(j-1));//5초간격
					
					//2. SMS 등록-------------------------------
					at_db.sendMessage(1009, "0", msgs[j], destphone, sendphone, null, firm_nm, ck_acar_id);
				}
			}
			
	}
%>
<script language='javascript'>
<!--
	alert('전송되었습니다.');
	parent.document.form1.msg.value = '';
	parent.document.form1.msglen.value = '0';
	parent.window.close();
//-->
</script>
</body>
</html>