<%@ page language="java" contentType="text/html;charset=euc-kr" %>
<%@ page import="card.*"%>
<jsp:useBean id="CardDb" scope="page" class="card.CardDatabase"/>
<%@ include file="/tax/cookies_base.jsp" %>


<%
	String cardno 	= request.getParameter("cardno")==null?"":request.getParameter("cardno");
	String buy_id 	= request.getParameter("buy_id")==null?"":request.getParameter("buy_id");
	
	int count = 0;	
		
	if(!CardDb.updateCardDocChiefId(cardno, buy_id, ck_acar_id)) count += 1;
	
	
%>
<html>
<head><title>FMS</title>
<link rel=stylesheet type="text/css" href="/include/table_t.css">
</head>
<body>
<form name='form1' action='' method="POST">
	
<input type="hidden" name="cardno" value="<%=cardno%>">
<input type="hidden" name="buy_id" value="<%=buy_id%>">
	
</form>
<script language="JavaScript">
<!--
	var fm = document.form1;
<%	if(count==0){%>
	alert("정상적으로 등록되었습니다.");
	parent.opener.location.reload();
	parent.window.close();
<%	}else{%>
	alert("등록 오류입니다.");
<%	}%>
//-->

</script>
</body>
</html>
