<%@ page language="java" contentType="text/html;charset=euc-kr" %>
<%@ page import="java.util.*, acar.util.*, card.*, acar.bill_mng.*"%>
<jsp:useBean id="CardDb" scope="page" class="card.CardDatabase"/>
<%@ include file="/tax/cookies_base.jsp" %>

<%
	String cardno 	= request.getParameter("cardno")==null?"":request.getParameter("cardno");
	String mode 	= request.getParameter("mode")==null?"u":request.getParameter("mode");
	int flag = 0;
	
	NeoErpUDatabase neoe_db = NeoErpUDatabase.getInstance();
	
	out.println("카드수정"+"<br><br>");
	
	//카드정보
	CardBean c_bean = CardDb.getCard(cardno);
	if(mode.equals("u")){
		c_bean.setCard_st(request.getParameter("card_st")==null?"":request.getParameter("card_st"));
		c_bean.setCom_code(request.getParameter("ven_code")==null?"":request.getParameter("ven_code"));
		c_bean.setCom_name(request.getParameter("ven_name")==null?"":request.getParameter("ven_name"));
		c_bean.setCard_name(request.getParameter("card_name")==null?"":request.getParameter("card_name"));
		c_bean.setCard_sdate(request.getParameter("card_sdate")==null?"":request.getParameter("card_sdate"));
		c_bean.setCard_edate(request.getParameter("card_edate")==null?"":request.getParameter("card_edate"));
		c_bean.setPay_day(request.getParameter("pay_day")==null?"":request.getParameter("pay_day"));
		c_bean.setUse_s_m(request.getParameter("use_s_m")==null?"":request.getParameter("use_s_m"));
		c_bean.setUse_s_day(request.getParameter("use_s_day")==null?"":request.getParameter("use_s_day"));
		c_bean.setUse_e_m(request.getParameter("use_e_m")==null?"":request.getParameter("use_e_m"));
		c_bean.setUse_e_day(request.getParameter("use_e_day")==null?"":request.getParameter("use_e_day"));
		c_bean.setLimit_st(request.getParameter("limit_st")==null?"":request.getParameter("limit_st"));
		c_bean.setLimit_amt(request.getParameter("limit_amt")==null?0:AddUtil.parseDigit4(request.getParameter("limit_amt")));
		c_bean.setEtc(request.getParameter("etc")==null?"":request.getParameter("etc"));
		c_bean.setCls_dt(request.getParameter("cls_dt")==null?"":request.getParameter("cls_dt"));
		c_bean.setCls_cau(request.getParameter("cls_cau")==null?"":request.getParameter("cls_cau"));
		c_bean.setReceive_dt(request.getParameter("receive_dt")==null?"":request.getParameter("receive_dt"));
		c_bean.setCard_mng_id(request.getParameter("card_mng_id")==null?"":request.getParameter("card_mng_id"));
		c_bean.setDoc_mng_id(request.getParameter("doc_mng_id")==null?"":request.getParameter("doc_mng_id"));
		c_bean.setMile_st(request.getParameter("mile_st")==null?"":request.getParameter("mile_st"));
		c_bean.setMile_per(request.getParameter("mile_per")==null?"":request.getParameter("mile_per"));
		c_bean.setMile_amt(request.getParameter("mile_amt")==null?0:AddUtil.parseDigit(request.getParameter("mile_amt")));
		c_bean.setCard_chk(request.getParameter("card_chk")==null?"":request.getParameter("card_chk"));
		c_bean.setAcc_no(request.getParameter("acc_no")==null?"":request.getParameter("acc_no"));
		c_bean.setCard_paid(request.getParameter("card_paid")==null?"":request.getParameter("card_paid"));
		
		flag = neoe_db.updateCardmana(c_bean);
		
	}else if(mode.equals("d")){
		c_bean.setCls_dt(request.getParameter("cls_dt")==null?"":request.getParameter("cls_dt"));
		c_bean.setCls_cau(request.getParameter("cls_cau")==null?"":request.getParameter("cls_cau"));
		c_bean.setUse_yn("N");
	}
	
	if(!CardDb.updateCard(c_bean)) flag += 1;
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
<%	if(flag > 0){//에러발생%>
		alert("에러가 발생하였습니다.");
<%	}else{//정상%>
		alert("수정되었습니다.");
		go_step();
<%	}%>
//-->
</script>
</body>
</html>
