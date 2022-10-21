<%@ page language="java" contentType="text/html;charset=euc-kr" %>
<%@ page import="java.util.*, acar.util.*, card.*, acar.bill_mng.*"%>
<jsp:useBean id="CardDb" scope="page" class="card.CardDatabase"/>
<%@ include file="/tax/cookies_base.jsp" %>

<%
	String cardno 	= request.getParameter("cardno")==null?"":request.getParameter("cardno");
	String buy_id 	= request.getParameter("buy_id")==null?"":request.getParameter("buy_id");
	int flag = 0;
	
	//전표정보
	CardDocBean cd_bean = CardDb.getCardDoc(cardno, buy_id);
	
	if(!CardDb.deleteCardDoc(cd_bean)) flag += 1;
	out.println("flag="+flag+"<br><br>");
%>

<html>
<head><title></title>
<script language='JavaScript' src='/include/common.js'></script>
<script language='javascript'>
<!--
	function go_step(){
		var fm = document.form1;
		fm.action = 'doc_app_frame.jsp';
		fm.target = "d_content";
		fm.submit();
		
		parent.window.close();
	}
//-->
</script>
<meta http-equiv="content-type" content="text/html; charset=euc-kr">
<link rel=stylesheet type="text/css" href="/include/table_t.css">
</head>
<body>
<form name='form1' action='' method='post'>
<%@ include file="/include/search_hidden.jsp" %>
<a href="javascript:go_step()">완료</a>
<script language='javascript'>
<!--
<%	if(flag > 0){//에러발생%>
		alert("자동전표 작성중 에러가 발생하였습니다.");
<%	}else{//정상%>
		alert("정상적으로 발행하였습니다.");
		go_step();
<%	}%>
//-->
</script>
</form>
</body>
</html>
