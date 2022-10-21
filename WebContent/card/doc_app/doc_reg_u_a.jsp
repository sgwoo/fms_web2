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
	
	out.println("전표수정"+"<br><br>");
	
	//카드정보
	CardDocBean cd_bean = CardDb.getCardDoc(cardno, buy_id);
	
	cd_bean.setBuy_dt(request.getParameter("buy_dt")==null?"":request.getParameter("buy_dt"));
	cd_bean.setBuy_s_amt(request.getParameter("buy_s_amt")==null?0:AddUtil.parseDigit(request.getParameter("buy_s_amt")));
	cd_bean.setBuy_v_amt(request.getParameter("buy_v_amt")==null?0:AddUtil.parseDigit(request.getParameter("buy_v_amt")));
	cd_bean.setBuy_amt(request.getParameter("buy_amt")==null?0:AddUtil.parseDigit(request.getParameter("buy_amt")));
	cd_bean.setVen_code(request.getParameter("ven_code")==null?"":request.getParameter("ven_code"));
	cd_bean.setVen_name(request.getParameter("ven_name")==null?"":request.getParameter("ven_name"));
	cd_bean.setAcct_code(request.getParameter("acct_code")==null?"":request.getParameter("acct_code"));
	cd_bean.setTax_yn(request.getParameter("tax_yn")==null?"N":request.getParameter("tax_yn"));
	
	//복리후생비,접대비,여비교통비,차량유류대,차량정비비
	if(acct_code.equals("00001") || acct_code.equals("00002") || acct_code.equals("00003") || acct_code.equals("00004") || acct_code.equals("00005") || acct_code.equals("00009") || acct_code.equals("00016") || acct_code.equals("00017")  ){
		cd_bean.setAcct_code_g(request.getParameter("acct_code_g")==null?"":request.getParameter("acct_code_g"));
	}
	//복리후생비
	if(acct_code.equals("00001") || acct_code.equals("00004")  || acct_code.equals("00005") ){
		cd_bean.setAcct_code_g2(request.getParameter("acct_code_g2")==null?"":request.getParameter("acct_code_g2"));
	}
	//차량유류비,차량정비비,사고수리비
	if(acct_code.equals("00004") || acct_code.equals("00005") || acct_code.equals("00006")){
		cd_bean.setItem_code(request.getParameter("item_code")==null?"":request.getParameter("item_code"));
		cd_bean.setItem_name(request.getParameter("item_name")==null?"":request.getParameter("item_name"));
	}
	
	cd_bean.setAcct_cont(request.getParameter("acct_cont")==null?"":request.getParameter("acct_cont"));
	cd_bean.setUser_su(request.getParameter("user_su")==null?"":request.getParameter("user_su"));
	cd_bean.setUser_cont(request.getParameter("user_cont")==null?"":request.getParameter("user_cont"));
	cd_bean.setBuy_user_id(request.getParameter("buy_user_id")==null?"":request.getParameter("buy_user_id"));
	cd_bean.setRent_l_cd(request.getParameter("rent_l_cd")==null?"":request.getParameter("rent_l_cd"));
	
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
