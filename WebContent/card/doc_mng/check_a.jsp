<%@ page language="java" contentType="text/html;charset=euc-kr" %>
<%@ page import="java.util.*, acar.util.*, card.*"%>
<jsp:useBean id="CardDb" scope="page" class="card.CardDatabase"/>
<jsp:useBean id="c_bean" scope="page" class="card.CardDocBean"/>
<%@ include file="/tax/cookies_base.jsp" %>


<%
	String cardno 	= request.getParameter("cardno")==null?"":request.getParameter("cardno");
	String buy_id 	= request.getParameter("buy_id")==null?"":request.getParameter("buy_id");
	String cd_reg_id	= request.getParameter("cd_reg_id")==null?"":request.getParameter("cd_reg_id");	
	
	
	int count = 0;
	
	//로그인ID&영업소ID
	LoginBean login = LoginBean.getInstance();
	
	user_id = login.getCookieValue(request, "acar_id");
	
	c_bean.setCgs_ok("Y"); //확인완료 
	c_bean.setCd_reg_id(user_id);
	c_bean.setCardno(cardno);
	c_bean.setBuy_id(buy_id);
	
	count = CardDb.updatecgs_ok(c_bean);
%>
<html>
<head><title>FMS</title>
<link rel=stylesheet type="text/css" href="/include/table_t.css">
</head>
<body>
<form name='form1' action='' method="POST">
	<input type="hidden" name="cd_reg_id" value="<%=user_id%>">
<input type="hidden" name="cardno" value="<%=cardno%>">
<input type="hidden" name="buy_id" value="<%=buy_id%>">
<input type="hidden" name="cgs_ok" value="<%=cgs_ok%>">

	
</form>
<script language="JavaScript">
<!--
	var fm = document.form1;
<%	if(count==1){%>
	alert("정상적으로 등록되었습니다.");
	parent.window.close();
<%	}else{%>
	alert("등록 오류입니다.");
<%	}%>
//-->
</script>
</body>
</html>
