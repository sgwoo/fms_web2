<%@ page language="java" contentType="text/html;charset=euc-kr"%>
<%@ page import="java.util.*, acar.util.*, acar.user_mng.*"%>
<jsp:useBean id="ac_db" scope="page" class="acar.cost.CostDatabase"/>
<%@ include file="/acar/cookies.jsp"%>
<%@ include file="/acar/access_log.jsp" %>

<%
	String auth_rw 	= request.getParameter("auth_rw")==null?"":request.getParameter("auth_rw"); 		//����
	String user_id 	= request.getParameter("user_id")==null?ck_acar_id:request.getParameter("user_id");	//�α���-ID
	String from_page = request.getParameter("from_page")==null?"":request.getParameter("from_page");
			
	String today = AddUtil.getDate(4);
	String save_dt = today;
	
	int flag2 = 0;
		
	 //stord procedure call
	String  d_flag1 =  ac_db.call_sp_prop_magam(today, user_id);
	System.out.println(d_flag1);
		
	if (!d_flag1.equals("0")) flag2 = 1;
	System.out.println("���� ķ���� ���� ���");
	
	String  d_flag2 =  ac_db.call_sp_prop_magam1(today, user_id);
	if (!d_flag2.equals("0")) flag2 = 1;
	    System.out.println("�ܱ� ķ���� ���� ���");
	
%>

<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN">
<html>
<head>
<title>����ķ����</title>
<meta http-equiv="Content-Type" content="text/html; charset=euc-kr">
<link rel="stylesheet" type="text/css" href="../../include/table.css">
<script language='JavaScript' src='/include/common.js'></script>
<script language='javascript'>
<!--
//-->
</script>
</head>
<body>
<form name='form1' action='http://fms1.amazoncar.co.kr/acar/admin/stat_end_sc.jsp' target='d_content' method="POST">
<input type='hidden' name='auth_rw' value='<%=auth_rw%>'>
<input type='hidden' name='user_id' value='<%=user_id%>'>
<input type='hidden' name='save_dt' value='<%=today%>'>
<input type='hidden' name='from_page' value='<%=from_page%>'>
</form>
<script language='javascript'>
	
	
	var fm = document.form1;
<%	if(flag2 != 0){%>
	alert('����ķ���� ������� ���� �߻�!');
<%	}else{%>
	alert('��ϵǾ����ϴ�.');
	if(fm.from_page.value == ''){
		document.domain = "amazoncar.co.kr";
		fm.action = 'http://fms1.amazoncar.co.kr/acar/admin/stat_end_sc.jsp';
	}else{
		fm.action =fm.from_page.value;
	}
	fm.submit();				
<%	}%>
</script>
</body>
</html>