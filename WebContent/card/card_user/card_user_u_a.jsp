<%@ page language="java" contentType="text/html;charset=euc-kr" %>
<%@ page import="java.util.*, acar.util.*, card.*, acar.bill_mng.*"%>
<jsp:useBean id="CardDb" scope="page" class="card.CardDatabase"/>
<%@ include file="/tax/cookies_base.jsp" %>

<%
	String cardno 		= request.getParameter("cardno")==null?"":request.getParameter("cardno");
	String seq 		= request.getParameter("seq")==null?"":request.getParameter("seq");
	String card_user_id 	= request.getParameter("card_user_id")==null?"":request.getParameter("card_user_id");
	
	String use_s_dt[] 	= request.getParameterValues("use_s_dt");
	String use_e_dt[] 	= request.getParameterValues("use_e_dt");
	String use_s_dt_h[] 	= request.getParameterValues("use_s_dt_h");
	String use_e_dt_h[] 	= request.getParameterValues("use_e_dt_h");
	String r_use_e_dt[] 	= request.getParameterValues("r_use_e_dt");
	
	int flag = 0;
	
	out.println("카드사용자변경"+"<br><br>");


	out.println("변경전 사용자 수정"+"<br><br>");
	
	CardUserBean a_cu_bean = CardDb.getCardUser(cardno, seq);
	a_cu_bean.setUse_e_dt	(use_e_dt[0]+use_e_dt_h[0]);
	a_cu_bean.setBack_id	(user_id);
	
	if(!CardDb.updateCardUser(a_cu_bean)) flag += 1;


	out.println("변경후 사용자 등록"+"<br><br>");
	
	//사용할 seq 가져오기
	seq = CardDb.getCardUserSeqNext(cardno);
	
	//카드사용자정보
	CardUserBean cu_bean = new CardUserBean();
	cu_bean.setCardno		(cardno);
	cu_bean.setSeq			(seq);
	cu_bean.setUser_id		(card_user_id);			
	cu_bean.setUse_s_dt		(use_s_dt[1]+use_s_dt_h[1]);			
	cu_bean.setUse_e_dt		(use_e_dt[1]+use_e_dt_h[1]);
	cu_bean.setReg_id		(user_id);			
	cu_bean.setR_use_s_dt		(r_use_e_dt[1]==null?"":r_use_e_dt[1]);
			
	if(!CardDb.insertCardUser(cu_bean)) flag += 1;
	
	
	out.println("카드관리에 사용자 일련번호 수정 "+"<br><br>");
	
	//카드정보
	CardBean c_bean = CardDb.getCard(cardno);
	c_bean.setUser_seq(seq);
	if(!CardDb.updateCard(c_bean)) flag += 1;
	
%>

<html>
<head><title>FMS</title>
<script language='JavaScript' src='/include/common.js'></script>
<script language='javascript'>
<!--
	function go_step(){
		var fm = document.form1;
		fm.action = 'card_user_sc.jsp';
		fm.target = "cd_foot";
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
<a href="javascript:go_step()">다음으로</a>
<script language='javascript'>
<!--
<%	if(flag > 0){//에러발생%>
		alert("에러가 발생하였습니다.");
<%	}else{//정상%>
		alert("변경되었습니다.");
		go_step();
<%	}%>
//-->
</script>
</body>
</html>
