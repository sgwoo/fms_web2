<%@ page language="java" contentType="text/html;charset=euc-kr" %>
<%@ page import="java.util.*, acar.util.*, acar.common.*, card.*, acar.bill_mng.*, acar.user_mng.*"%>
<jsp:useBean id="CardDb" scope="page" class="card.CardDatabase"/>
<%@ include file="/tax/cookies_base.jsp" %>

<%
	String cardno 		= request.getParameter("cardno")==null?"":request.getParameter("cardno");
	int flag = 0;
	
	CommonDataBase c_db = CommonDataBase.getInstance();
	NeoErpUDatabase neoe_db = NeoErpUDatabase.getInstance();
	UserMngDatabase umd = UserMngDatabase.getInstance();
	
	//카드정보
	CardBean c_bean = CardDb.getCard(cardno);
	
	UsersBean user_bean = umd.getUsersBean(c_bean.getCard_mng_id());
	Hashtable per = neoe_db.getPerinfoDept(user_bean.getUser_nm());	//-> neoe_db 변환
	Hashtable br = c_db.getBranch(user_bean.getBr_id());
	
	
	flag = neoe_db.insertCardmana(c_bean, per, br);			//-> neoe_db 변환
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
<input type='hidden' name='cardno' 	value='<%=cardno%>'>
</form>
<a href="javascript:go_step()">다음으로</a>
<script language='javascript'>
<!--
<%		if(flag > 0){//에러발생%>
		alert("에러가 발생하였습니다.");
<%		}else{//정상%>
		alert("등록되었습니다.");
		go_step();
<%		}%>
//-->
</script>
</body>
</html>
