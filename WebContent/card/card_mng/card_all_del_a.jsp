<%@ page language="java" contentType="text/html;charset=euc-kr" %>
<%@ page import="java.util.*, acar.util.*, card.*, acar.bill_mng.*"%>
<jsp:useBean id="CardDb" scope="page" class="card.CardDatabase"/>
<%@ include file="/tax/cookies_base.jsp" %>

<%
	int flag = 0;
	
	String vid[] 	= request.getParameterValues("cardno");
	
	String cls_dt 	= request.getParameter("cls_dt")==null?"":request.getParameter("cls_dt");
	String cls_cau 	= request.getParameter("cls_cau")==null?"":request.getParameter("cls_cau");
	
	String cardno 	= "";
	
	int vid_size = vid.length;
	
	for(int i=0;i < vid_size;i++){
		cardno = vid[i];
		
		//카드정보
		CardBean c_bean = CardDb.getCard(cardno);
		c_bean.setCls_dt	(cls_dt);
		c_bean.setCls_cau	(cls_cau);
		c_bean.setUse_yn	("N");
		
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
		fm.action = 'card_mng_sc.jsp';
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
</form>
<a href="javascript:go_step()">다음으로</a>
<script language='javascript'>
<!--
<%	if(flag > 0){//에러발생%>
		alert("에러가 발생하였습니다.");
<%	}else{//정상%>
		alert("수정되었습니다.");
		go_step();
<%	}%>
//-->
</script>
</body>
</html>
