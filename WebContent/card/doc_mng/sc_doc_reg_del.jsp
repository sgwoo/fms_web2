<%@ page language="java" contentType="text/html;charset=euc-kr" %>
<%@ page import="java.util.*, acar.util.*, card.*"%>
<jsp:useBean id="CardDb" scope="page" class="card.CardDatabase"/>
<%@ include file="/tax/cookies_base.jsp" %>

<%
	out.println("ī����ǥ ����/���� "+"<br><br>");
	
	String cardno 	= request.getParameter("cardno")==null?"":request.getParameter("cardno");
	String buy_id 	= request.getParameter("buy_id")==null?"":request.getParameter("buy_id");
	String cmd 	= request.getParameter("cmd")==null?"":request.getParameter("cmd");

	int flag = 0;
	
	//��ǥ����
	CardDocBean cd_bean = CardDb.getCardDoc(cardno, buy_id);		

	if ( cmd.equals("oil") ) {  //�Ƹ���Ź���� ����� ����ī���� ������ ������  �������� ���� ������ҵǾ� �Ѿ��
		if(!CardDb.updateCardDocCancel(cardno, buy_id)) flag += 1;
	} else {
		if(!CardDb.deleteCardDoc(cd_bean)) flag += 1;
	}
	
	out.println("flag="+flag+"<br><br>");
	
	
%>

<html>
<head><title></title>
<script language='JavaScript' src='/include/common.js'></script>
<script language='javascript'>
<!--
	function go_step(){
		var fm = document.form1;
		fm.action = 'sc_doc_mng_frame.jsp';
		fm.target = "d_content";
		fm.submit();
		
		parent.window.close();
	}
//-->
</script>
<meta http-equiv="content-type" content="text/html; charset=euc-kr">
<link rel=stylesheet type="text/css" href="../../include/table.css">
</head>
<body>
<form name='form1' action='' method='post'>
<%@ include file="/include/search_hidden.jsp" %>
<a href="javascript:go_step()">�Ϸ�</a>
<script language='javascript'>
<!--
<%	if(flag > 0){//�����߻�%>
		alert("������ �߻��Ͽ����ϴ�.");
<%	}else{//����%>
		alert("���������� ó���Ͽ����ϴ�.");
		go_step();
<%	}%>
//-->
</script>
</form>
</body>
</html>
