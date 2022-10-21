<%@ page language="java" contentType="text/html;charset=euc-kr" %>
<%@ page import="java.util.*, acar.util.*, card.*"%>
<jsp:useBean id="CardDb" scope="page" class="card.CardDatabase"/>
<%@ include file="/tax/cookies_base.jsp" %>

<%
	String card_kind 	= request.getParameter("card_kind")==null?"":request.getParameter("card_kind");
	String s_card 	= request.getParameter("s_card")==null?"":request.getParameter("s_card");
	
	String cardno 	= request.getParameter("cardno")==null?"":request.getParameter("cardno");
	String seq 	= request.getParameter("seq")==null?"":request.getParameter("seq");
	
	String mode 	= request.getParameter("mode")==null?"":request.getParameter("mode");
	String reg_type 	= request.getParameter("reg_type")==null?"":request.getParameter("reg_type");
	int flag = 0;
	
	//카드약정정보
	CardContBean cont_bean = CardDb.getCardCont(cardno, seq);	
	
	cont_bean.setCont_dt		(request.getParameter("cont_dt")==null?"":request.getParameter("cont_dt"));
	cont_bean.setGive_day		(request.getParameter("give_day")==null?"":request.getParameter("give_day"));
	cont_bean.setCont_amt		(request.getParameter("cont_amt")==null?0:AddUtil.parseDigit4(request.getParameter("cont_amt")));
	cont_bean.setSave_per1		(request.getParameter("save_per1")==null?0:AddUtil.parseFloat(request.getParameter("save_per1")));
	cont_bean.setSave_per2		(request.getParameter("save_per2")==null?0:AddUtil.parseFloat(request.getParameter("save_per2")));
	cont_bean.setSave_in_dt_st1 (request.getParameter("save_in_dt_st1")==null?"N":request.getParameter("save_in_dt_st1"));
	cont_bean.setSave_in_dt_st2 (request.getParameter("save_in_dt_st2")==null?"N":request.getParameter("save_in_dt_st2"));
	cont_bean.setSave_in_dt_st3 (request.getParameter("save_in_dt_st3")==null?"N":request.getParameter("save_in_dt_st3"));
	cont_bean.setSave_in_dt		(request.getParameter("save_in_dt")==null?"":request.getParameter("save_in_dt"));
	cont_bean.setSave_in_st		(request.getParameter("save_in_st")==null?"":request.getParameter("save_in_st"));
	cont_bean.setAgnt_nm		(request.getParameter("agnt_nm")==null?"":request.getParameter("agnt_nm"));
	cont_bean.setAgnt_tel		(request.getParameter("agnt_tel")==null?"":request.getParameter("agnt_tel"));
	cont_bean.setAgnt_m_tel		(request.getParameter("agnt_m_tel")==null?"":request.getParameter("agnt_m_tel"));	
	cont_bean.setEtc			(request.getParameter("etc")==null?"":request.getParameter("etc"));
	cont_bean.setAllot_link_yn(request.getParameter("allot_link_yn")==null?"":request.getParameter("allot_link_yn"));
	cont_bean.setN_ven_code		(request.getParameter("n_ven_code")==null?"":request.getParameter("n_ven_code"));
	cont_bean.setN_ven_name		(request.getParameter("n_ven_name")==null?"":request.getParameter("n_ven_name"));
	cont_bean.setGive_day_st	(request.getParameter("give_day_st")==null?"":request.getParameter("give_day_st"));	
	cont_bean.setMaster_nm		(request.getParameter("master_nm")==null?"":request.getParameter("master_nm"));
	cont_bean.setMaster_tel		(request.getParameter("master_tel")==null?"":request.getParameter("master_tel"));
	cont_bean.setMaster_m_tel	(request.getParameter("master_m_tel")==null?"":request.getParameter("master_m_tel"));	
		
	if(seq.equals("")){
		cont_bean.setCardno(cardno);
		cont_bean.setCard_kind(card_kind);
		cont_bean.setReg_id(ck_acar_id);
		
		if(!CardDb.insertCardCont(cont_bean)) flag += 1;
		
	}else{
		if(reg_type.equals("H")){
			if(!CardDb.insertCardCont(cont_bean)) flag += 1;
		}else{
			if(!CardDb.updateCardCont(cont_bean)) flag += 1;
		}
	}
	
%>

<html>
<head><title>FMS</title>
<script language='JavaScript' src='/include/common.js'></script>
<script language='javascript'>
<!--
	function go_step(){
		var fm = document.form1;
		fm.action = 'card_reg_sc.jsp';
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
<input type='hidden' name='card_kind' 	value='<%=card_kind%>'>
<input type='hidden' name='s_card' value='<%=s_card%>'>
</form>
<a href="javascript:go_step()">다음으로</a>
<script language='javascript'>
<!--
<%	if(flag > 0){//에러발생%>
		alert("에러가 발생하였습니다.");
<%	}else{//정상%>
		alert("처리되었습니다.");
		go_step();
<%	}%>
//-->
</script>
</body>
</html>
