<%@ page language="java" contentType="text/html;charset=euc-kr" %>
<%@ page import="java.util.*, acar.util.*, card.*, acar.bill_mng.*"%>
<jsp:useBean id="CardDb" scope="page" class="card.CardDatabase"/>
<%@ include file="/tax/cookies_base.jsp" %>

<%
	String vid1[] = request.getParameterValues("o_cardno");
	String vid2[] = request.getParameterValues("o_buy_id");
	
	int vid_size = 0;
	vid_size = vid1.length;
	
	String cardno 		= request.getParameter("cardno")==null?"":request.getParameter("cardno");
	String buy_id = "";
	
	String o_cardno = "";
	String o_buy_id = "";
	
	int flag = 0;
	
	for(int i=0;i < vid_size;i++){
		
		o_cardno = vid1[i];
		o_buy_id = vid2[i];
		
		
		//����� buy_id ��������
		buy_id = CardDb.getCardDocBuyIdNext(cardno);
		out.println("buy_id="+buy_id+"<br><br>");
		
		
		System.out.println("ī���ȣ ����  old ="+ o_cardno + ":" + o_buy_id + ":new =" + cardno + ":" + buy_id);
		
		//ī�庯��
		if(!CardDb.updateCardDoc(o_cardno, o_buy_id, cardno, buy_id)) flag += 1;
		if(!CardDb.updateCardDocUser(o_cardno, o_buy_id, cardno, buy_id)) flag += 1;
		if(!CardDb.updateCardDocItem(o_cardno, o_buy_id, cardno, buy_id)) flag += 1;
		
		/*
		//ī����ǥ
		CardDocBean cd_bean = CardDb.getCardDoc(o_cardno, o_buy_id);
		cd_bean.setCardno(cardno);
		cd_bean.setBuy_id(buy_id);
		if(!CardDb.insertCardDoc(cd_bean)) flag += 1;
		System.out.println("ī���ȣ ������ ="+ o_cardno + ":" + o_buy_id + ":" + cd_bean.getBuy_dt());
		out.println("flag="+flag+"<br><br>");
		System.out.println("ī���ȣ ������="+ cardno + ":" + buy_id);
		//ī����ǥ ����ڵ�
		Vector vts1 = CardDb.getCardDocUserList(o_cardno, o_buy_id, "1");
		int vt_size1 = vts1.size();
		
		System.out.println("ī�����ο�=" + vt_size1);
				
		for(int j = 0 ; j < vt_size1 ; j++ ){
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
			//����ǥ����
			CardDocBean o_cd_bean = CardDb.getCardDoc(o_cardno, o_buy_id);
			if(!CardDb.deleteCardDoc(o_cd_bean)) flag += 1;
		}
		*/		
		
	}
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
</form>
<script language='javascript'>
<!--
<%		if(flag > 0){//�����߻�%>
		alert("������ �߻��Ͽ����ϴ�.");
<%		}else{//����%>
		alert("��ϵǾ����ϴ�.");
		go_step();
<%		}%>
//-->
</script>
</body>
</html>