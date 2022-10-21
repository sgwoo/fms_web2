<%@ page language="java" contentType="text/html;charset=euc-kr" %>
<%@ page import="java.util.*, acar.util.*, card.*, acar.bill_mng.*"%>
<jsp:useBean id="CardDb" scope="page" class="card.CardDatabase"/>
<%@ include file="/tax/cookies_base.jsp" %>

<%
	String cardno 	= request.getParameter("cardno")==null?"":request.getParameter("cardno");
	String buy_id 	= request.getParameter("buy_id")==null?"":request.getParameter("buy_id");
	
	String acct_code 	= request.getParameter("acct_code")==null?"":request.getParameter("acct_code");
	String acct_code_g 	= request.getParameter("acct_code_g")==null?"":request.getParameter("acct_code_g");
	int flag = 0;
	
	out.println("전표승인취소"+"<br><br>");
	
	//카드정보
	CardDocBean cd_bean = CardDb.getCardDoc(cardno, buy_id);
	
	cd_bean.setApp_id("");
	cd_bean.setApp_dt("");
	cd_bean.setAutodocu_write_date("");
	cd_bean.setAutodocu_data_no("");
	
	if(!CardDb.updateCardDoc(cd_bean)) flag += 1;
	
	out.println("flag="+flag+"<br><br>");
%>

<html>
<head><title>FMS</title>
<script language='JavaScript' src='/include/common.js'></script>
<script language='javascript'>
<!--
	function go_step(){
		var fm = document.form1;
		fm.action = 'doc_mng_frame.jsp';
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
<input type='hidden' name='cardno' 	value='<%=cardno%>'>
</form>
<a href="javascript:go_step()">다음으로</a>
<script language='javascript'>
<!--
<%		if(flag > 0){//에러발생%>
		alert("에러가 발생하였습니다.");
<%		}else{//정상%>
		alert("수정되었습니다.");
		go_step();
<%		}%>
//-->
</script>
</body>
</html>
