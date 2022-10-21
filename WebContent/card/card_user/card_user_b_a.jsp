<%@ page language="java" contentType="text/html;charset=euc-kr" %>
<%@ page import="java.util.*, acar.util.*, card.*"%>
<jsp:useBean id="CardDb" scope="page" class="card.CardDatabase"/>
<%@ include file="/tax/cookies_base.jsp" %>

<%
	String cardno 			= request.getParameter("cardno")==null?"":request.getParameter("cardno");
	String seq 				= request.getParameter("seq")==null?"":request.getParameter("seq");
	String card_user_id 	= request.getParameter("card_user_id")==null?"":request.getParameter("card_user_id");
	
	int flag = 0;
	
	
	
	out.println("ī������ȸ��"+"<br><br>");
	CardUserBean cu_bean = CardDb.getCardUser(cardno, seq);
	cu_bean.setUse_s_dt		(request.getParameter("use_s_dt2")==null?"":request.getParameter("use_s_dt2"));
	cu_bean.setUse_e_dt		(request.getParameter("use_e_dt2")==null?"":request.getParameter("use_e_dt2"));
	cu_bean.setR_use_s_dt	(request.getParameter("r_use_s_dt")==null?"":request.getParameter("r_use_s_dt"));
	cu_bean.setBack_id		(user_id);
	
	if(!CardDb.updateCardUser(cu_bean)) flag += 1;

	out.println("ī������� ����� �Ϸù�ȣ ���� "+"<br><br>");
	
	if(!cu_bean.getUse_e_dt().equals("")){
		//ī������
		CardBean c_bean = CardDb.getCard(cardno);
		c_bean.setUser_seq("");
		if(!CardDb.updateCard(c_bean)) flag += 1;
	}
%>

<html>
<head><title>FMS</title>
<script language='JavaScript' src='/include/common.js'></script>
<script language='javascript'>
<!--
	function go_step(){
		var fm = document.form1;
		fm.action = 'card_user_sc.jsp';
		fm.target = "c_foot";
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
<input type='hidden' name='cardno' 			value='<%=cardno%>'>
<input type='hidden' name='card_user_id' 	value='<%=card_user_id%>'>
</form>
<a href="javascript:go_step()">��������</a>
<script language='javascript'>
<!--
<%	if(flag > 0){//�����߻�%>
		alert("������ �߻��Ͽ����ϴ�.");
<%	}else{//����%>
		alert("�����Ǿ����ϴ�.");
		go_step();
<%	}%>
//-->
</script>
</body>
</html>
