<%@ page language="java" contentType="text/html;charset=euc-kr"%>
<%@ page import="java.util.*, acar.util.*, acar.user_mng.*"%>
<jsp:useBean id="ic_db" scope="page" class="acar.incom.IncomDatabase" />
<%@ include file="/acar/cookies.jsp" %>

<html>
<head><title>FMS</title></head>
<body style="font-size:12">

<%

	String auth_rw 	= request.getParameter("auth_rw")==null?"":request.getParameter("auth_rw");
	String user_id 	= request.getParameter("user_id")==null?"":request.getParameter("user_id");//�α���-ID
	
	String gubun0 	= request.getParameter("gubun0")==null?"":request.getParameter("gubun0"); //�⵵  
	String gubun2 	= request.getParameter("gubun2")==null?"":request.getParameter("gubun2"); // �б�
	String st_mon 	= request.getParameter("st_mon")==null?"":request.getParameter("st_mon"); // ��
					
	String  flag =  ic_db.call_sp_car_jip_tax(gubun0, st_mon);
	
	System.out.println("�ſ�ī�� �������� ="+flag);
	
%>

<form name='form1' method="POST">
<input type='hidden' name='auth_rw' value='<%=auth_rw%>'>
<input type='hidden' name='user_id' value='<%=user_id%>'>
<input type='hidden' name='gubun0' value='<%=gubun0%>'>
<input type='hidden' name='gubun2' value='<%=gubun2%>'>

</form>
<script language='javascript'>
<%	if(flag.equals("1")){%>
		alert('�����߻�!');

<%	}else{%>
		alert('ó���Ǿ����ϴ�');
<%	}%>
</script>
</body>
</html>

