<%@ page language="java" contentType="text/html;charset=euc-kr"%>
<%@ page import="java.util.*, acar.util.*"%>
<jsp:useBean id="ac_db" scope="page" class="acar.cost.CostDatabase"/>
<%@ include file="/acar/cookies.jsp"%>

<%
	String auth_rw 		= request.getParameter("auth_rw")	==null?"":request.getParameter("auth_rw"); 	//����
	String user_id 		= request.getParameter("user_id")	==null?"":request.getParameter("user_id");	//�α���-ID
	String br_id 		= request.getParameter("br_id")		==null?"":request.getParameter("br_id");	//�α���-������
	
	String gubun 	= request.getParameter("gubun")	==null?"":request.getParameter("gubun");
	String from_page 	= request.getParameter("from_page")	==null?"":request.getParameter("from_page");
	 
	if ( gubun.equals("1")) {
		from_page = "/fms2/mis/man_cost1_settle.jsp";  //1��
	} else {
		from_page = "/fms2/mis/man_cost3_settle.jsp";  //2��
	}
		
	int result = 0;
	
	String today = AddUtil.getDate(4);
	String save_dt = today;
		
	result 	= ac_db.insertMagamCost(save_dt, gubun);		
	
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
