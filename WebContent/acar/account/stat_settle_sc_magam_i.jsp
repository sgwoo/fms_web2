<%@ page language="java" contentType="text/html;charset=euc-kr"%>
<%@ page import="java.util.*, acar.util.*, acar.stat_bus.*"%>
<jsp:useBean id="st_db" scope="page" class="acar.settle_acc.SettleDatabase"/>
<%@ include file="/acar/cookies.jsp"%>

<%
	String auth_rw 		= request.getParameter("auth_rw")	==null?"":request.getParameter("auth_rw"); 	//����
	String user_id 		= request.getParameter("user_id")	==null?"":request.getParameter("user_id");	//�α���-ID
	String br_id 		= request.getParameter("br_id")		==null?"":request.getParameter("br_id");	//�α���-������
		
	String from_page 	= request.getParameter("from_page")	==null?"":request.getParameter("from_page");
	
	from_page = "/acar/account/stat_settle_201103_sc2.jsp";
		
	int result = 0;
	
	String today = AddUtil.getDate(4);
	String save_dt = today;
		
	result 	= st_db.insertMagamSettle(save_dt);		
	
%>
<html>
<head><title>FMS</title>
<meta http-equiv="Content-Type" content="text/html; charset=euc-kr">
<link rel=stylesheet type="text/css" href="/include/table.css">
</head>
<body>
<form name='form1' action='' method="POST">
<input type='hidden' name='auth_rw' 	value='<%=auth_rw%>'>
<input type='hidden' name='user_id' 	value='<%=user_id%>'>
<input type='hidden' name='br_id' 	value='<%=br_id%>'>
<input type='hidden' name='from_page' 	value='<%=from_page%>'>

</form>
<script language="JavaScript">
<!--
	var fm = document.form1;
		
<%if(result >= 1){%>
    alert("ķ���� ���� ������Ÿ�� ����Ǿ����ϴ�.");	
<%}else{%>
	alert("�����ͺ��̽��� ������ �߻��Ͽ����ϴ�.\n �����ڴԲ� �����ϼ��� !");
<%}%>
//-->
</script>
</body>
</html>
