<%@ page language="java" contentType="text/html;charset=euc-kr" %>
<%@ page import="java.util.*, acar.util.*, acar.offls_pre.*, acar.user_mng.*"%>
<jsp:useBean id="olyD" class="acar.offls_pre.Offls_preDatabase" scope="page"/>
<%@ include file="/acar/cookies.jsp" %>

<html>
<head>
<title>FMS</title>
</head>
<body leftmargin="15">
<%

	String destphone	= request.getParameter("destphone")==null?"":request.getParameter("destphone");
	String s_destphone_off	= request.getParameter("s_destphone_off")==null?"":request.getParameter("s_destphone_off");

	
	String vid1[] = request.getParameterValues("c_id");
	
	int vid_size = 0;
	vid_size = vid1.length;
	
	String car_mng_id = "";
	
	/*����� ID apprsl�� �ֱ�*/
	String actn_id = "";
	int result = 0;
	
	if(destphone.equals("��ȭ") || s_destphone_off.equals("��ȭ ����� Ź��")){
		actn_id = "000502";
	}else if(destphone.equals("�д�") || s_destphone_off.equals("�д� �۷κ� Ź��")){	
		actn_id = "013011";
	}else if(destphone.equals("���") || s_destphone_off.equals("��� �۷κ� Ź��")){	
		actn_id = "061796";	
	}else if(destphone.equals("010-9026-1853")||destphone.equals("aj") || s_destphone_off.equals("AJ����� Ź��")){
		actn_id = "020385";
	//}else if(destphone.equals("010-5050-3311")||destphone.equals("����ũ")){
	//	actn_id = "013222";
	}else if(destphone.equals("�Ե���Ż") || s_destphone_off.equals("�Ե� ����� Ź��")){
		actn_id = "022846";
	}else if(destphone.equals("����") || destphone.equals("010-5058-1414") || s_destphone_off.equals("Kcar Ź��") ){  //20191014 �߰� 
		actn_id = "048691";	
	}
	
	
	for(int i=0;i < vid_size;i++){		
		car_mng_id = vid1[i];		
		result = olyD.upApprsl2(car_mng_id, actn_id, ck_acar_id);
		int result2 = olyD.upApprsl2(car_mng_id, actn_id, ck_acar_id);
	  }
	
		
%>
<script language='javascript'>
<!--
<%if(result > 0){%>
	alert('����Ǿ����ϴ�.');
<%}else{%>
	alert('ERRRRRRRRRRRROOOOOORRRRRRRR.');
<%}%>
//-->
</script>
</body>
</html>