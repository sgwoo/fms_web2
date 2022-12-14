<%@ page language="java" contentType="text/html;charset=euc-kr" %>
<%@ page import="java.util.*, acar.util.*, card.*, acar.bill_mng.*"%>
<jsp:useBean id="CardDb" scope="page" class="card.CardDatabase"/>
<%@ include file="/tax/cookies_base.jsp" %>

<%
	String o_cardno 	= request.getParameter("o_cardno")==null?"":request.getParameter("o_cardno");
	String o_buy_id 	= request.getParameter("o_buy_id")==null?"":request.getParameter("o_buy_id");
	
	String cardno 		= request.getParameter("cardno")==null?"":request.getParameter("cardno");
	String buy_id = "";
	
	int flag = 0;
	
	out.println("전표변경"+"<br><br>");
	
	//사용할 buy_id 가져오기
	buy_id = CardDb.getCardDocBuyIdNext(cardno);
	out.println("buy_id="+buy_id+"<br><br>");
	
		
	System.out.println("카드번호 수정  old ="+ o_cardno + ":" + o_buy_id + ":new =" + cardno + ":" + buy_id);
	
	//카드변경
	if(!CardDb.updateCardDoc(o_cardno, o_buy_id, cardno, buy_id)) flag += 1;
	if(!CardDb.updateCardDocUser(o_cardno, o_buy_id, cardno, buy_id)) flag += 1;
	if(!CardDb.updateCardDocItem(o_cardno, o_buy_id, cardno, buy_id)) flag += 1;
	
	/*
	//카드전표
	CardDocBean cd_bean = CardDb.getCardDoc(o_cardno, o_buy_id);
	cd_bean.setCardno(cardno);
	cd_bean.setBuy_id(buy_id);
	if(!CardDb.insertCardDoc(cd_bean)) flag += 1;
	
	out.println("flag="+flag+"<br><br>");
	
	//카드전표 사용자들
	Vector vts1 = CardDb.getCardDocUserList(o_cardno, o_buy_id, "1");
	int vt_size1 = vts1.size();
	
	for(int j = 0 ; j < vt_size1 ; j++){
		Hashtable ht = (Hashtable)vts1.elementAt(j);
		
		CardDocUserBean cdu_bean = new CardDocUserBean();
		cdu_bean.setCardno	(cardno);
		cdu_bean.setBuy_id	(buy_id);
		cdu_bean.setSeq		(String.valueOf(ht.get("SEQ")));
		cdu_bean.setUser_st	(String.valueOf(ht.get("USER_ST")));
		cdu_bean.setFirm_nm	(String.valueOf(ht.get("FIRM_NM")));
		cdu_bean.setDoc_user(String.valueOf(ht.get("DOC_USER")));
		cdu_bean.setDoc_amt	(AddUtil.parseDigit(String.valueOf(ht.get("DOC_AMT"))));
		if(!CardDb.insertCardDocUser(cdu_bean)) flag += 1;
	}
	
	if(flag == 0){
		//전전표삭제
		CardDocBean o_cd_bean = CardDb.getCardDoc(o_cardno, o_buy_id);
		if(!CardDb.deleteCardDoc(o_cd_bean)) flag += 1;
	}	
	*/
%>

<html>
<head><title>FMS</title>
<script language='JavaScript' src='/include/common.js'></script>
<script language='javascript'>
<!--
	function go_step(){		
	
		var fm = document.form1;
		fm.action = 'doc_reg_u.jsp';
		fm.target = "CardDocView";
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
<input type='hidden' name='buy_id' value='<%=buy_id%>'>
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