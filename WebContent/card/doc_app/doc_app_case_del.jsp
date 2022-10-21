<%@ page language="java" contentType="text/html;charset=euc-kr" %>
<%@ page import="java.util.*, acar.util.*, card.*"%>
<jsp:useBean id="CardDb" scope="page" class="card.CardDatabase"/>
<%@ include file="/tax/cookies_base.jsp" %>

<%
	String cardno 	= request.getParameter("cardno")==null?"":request.getParameter("cardno");
	String buy_id 	= request.getParameter("buy_id")==null?"":request.getParameter("buy_id");
	String acct_code 	= request.getParameter("acct_code")==null?"":request.getParameter("acct_code");
	String acct_code_g 	= request.getParameter("acct_code_g")==null?"":request.getParameter("acct_code_g");
	int flag = 0;
	
	//전표정보
	CardDocBean cd_bean = CardDb.getCardDoc(cardno, buy_id);		
	
	
	//정비내역 delete	
	if( ( acct_code.equals("00005")  &&  acct_code_g.equals("6")  ) || acct_code.equals("00006")){	
	
	   //정비데이타 결재 무효 처리
		Vector vt = CardDb.getCardDocItemList(cardno, buy_id);
		int vt_size = vt.size();
		
		for(int i=0; i < vt_size; i++){
       		Hashtable ht = (Hashtable)vt.elementAt(i);      
       		System.out.println("card service delete car_mng_id = " + String.valueOf(ht.get("ITEM_CODE")) + ": serv_id =" +  	String.valueOf(ht.get("SERV_ID")) );	
       		if(!CardDb.updateCardDocItem(String.valueOf(ht.get("ITEM_CODE")), String.valueOf(ht.get("SERV_ID")))  ) flag += 1;       	       				
		}	
			
		if(!CardDb.deleteCardDocItem(cardno, buy_id)) flag += 1;
	}	
		
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
<link rel=stylesheet type="text/css" href="../../include/table.css">
</head>
<body>
<form name='form1' action='' method='post'>
<%@ include file="/include/search_hidden.jsp" %>
<a href="javascript:go_step()">완료</a>
<script language='javascript'>
<!--
<%	if(flag > 0){//에러발생%>
		alert("에러가 발생하였습니다.");
<%	}else{//정상%>
		alert("정상적으로 삭제하였습니다.");
		go_step();
<%	}%>
//-->
</script>
</form>
</body>
</html>
