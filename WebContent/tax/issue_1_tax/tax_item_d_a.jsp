<%@ page language="java" contentType="text/html;charset=euc-kr" %>
<%@ page import="java.util.*, acar.util.*, tax.*"%>
<jsp:useBean id="IssueDb" scope="page" class="tax.IssueDatabase"/>
<%@ include file="/tax/cookies_base.jsp" %>

<%
	out.println("�ŷ����� ����"+"<br><br>");
	
	String item_id	 	= request.getParameter("item_id")==null?"":request.getParameter("item_id");
	String item_size	= request.getParameter("item_size")==null?"":request.getParameter("item_size");
	
	int flag = 0;
	int vid_size = 0;
	
	if(!item_id.equals("")){
		if(!IssueDb.deleteTaxItem(item_id)) flag += 1;
	}
%>

<html>
<head><title></title>
<script language='JavaScript' src='/include/common.js'></script>
<script language='javascript'>
<!--
	function go_step(){	  
		var fm = document.form1;
		fm.action = 'issue_1_frame.jsp';
		fm.target = 'd_content';
		fm.submit();
		
		parent.self.close();
	}
//-->
</script>
<meta http-equiv="content-type" content="text/html; charset=euc-kr">
<link rel=stylesheet type="text/css" href="../../include/table.css">
</head>
<body onLoad="javascript:init()">
<form name='form1' action='' method='post'>
<%@ include file="/include/search_hidden.jsp" %>
</form>
<a href="javascript:go_step()">2�ܰ�� ����</a>
<script language='javascript'>
<!--
<%	if(flag > 0){//�����߻�%>
		alert("�ŷ����� ������ ������ �߻��Ͽ����ϴ�.");
<%	}else{//����%>
		go_step();
<%	}%>
//-->
</script>
</body>
</html>
