<%@ page language="java" contentType="text/html;charset=euc-kr" %>
<%@ page import="java.util.*, acar.util.*, card.*"%>
<jsp:useBean id="CardDb" scope="page" class="card.CardDatabase"/>
<%@ include file="/tax/cookies_base.jsp" %>

<%
	String s_yy 	= request.getParameter("s_yy")==null?"":request.getParameter("s_yy");
	String s_mm 	= request.getParameter("s_mm")==null?"":request.getParameter("s_mm");
	String card_kind 	= request.getParameter("card_kind")==null?"":request.getParameter("card_kind");
	String scd_dt = request.getParameter("scd_dt")==null?"":request.getParameter("scd_dt");
	int serial 		= request.getParameter("serial")==null?0:AddUtil.parseInt(request.getParameter("serial"));
	int tm 				= request.getParameter("tm")==null?1:AddUtil.parseInt(request.getParameter("tm"));
	String reg_type = request.getParameter("reg_type")==null?"":request.getParameter("reg_type");
	
	int flag = 0;
	
	CardStatBean csb_bean = CardDb.getCardStatBase(serial);
	
	csb_bean.setUpdate_id(ck_acar_id);
	
	//카드취소	
	if(reg_type.equals("C")){
		if(!CardDb.updateCardStatCancel(csb_bean)) flag += 1;
	//적립수정	
	}else{
		csb_bean.setSave_amt(request.getParameter("save_amt")==null?0:AddUtil.parseDigit4(request.getParameter("save_amt")));
		csb_bean.setSave_per(request.getParameter("save_per")==null?0:AddUtil.parseFloat(request.getParameter("save_per")));
		if(!CardDb.updateCardStatBase(csb_bean)) flag += 1;
	}
	
	//card_stat_scd 수정
	if(!CardDb.updateCardStatScdRe(csb_bean)) flag += 1;
	
	if(reg_type.equals("C")){
	  if(!CardDb.deleteCardStatScdRe(csb_bean)) flag += 1;
	}
	
	String  c_flag =  CardDb.call_sp_card_cont_reg();
	
	
%>

<html>
<head><title>FMS</title>
<script language='JavaScript' src='/include/common.js'></script>
<script language='javascript'>
<!--
	function go_step(){
		var fm = document.form1;
		fm.action = 'card_day_list.jsp';
		fm.target = "CardDayList";
		fm.submit();

		fm.action = 'card_day_sc.jsp';
		fm.target = "c_foot";
		fm.submit();

	}
//-->
</script>
<meta http-equiv="content-type" content="text/html; charset=euc-kr">
<link rel=stylesheet type="text/css" href="../../include/table.css">
</head>
<body>
<form name='form1' action='' method='post'>
<input type='hidden' name='s_yy' value='<%=s_yy%>'>
<input type='hidden' name='s_mm' value='<%=s_mm%>'>
<input type='hidden' name='scd_dt' value='<%=scd_dt%>'>
<input type='hidden' name='card_kind' value='<%=card_kind%>'>
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
