<%@ page language="java" contentType="text/html;charset=euc-kr" %>
<%@ page import="java.util.*, acar.util.*, card.*"%>
<jsp:useBean id="CardDb" scope="page" class="card.CardDatabase"/>
<%@ include file="/tax/cookies_base.jsp" %>

<%
	String scd_dt = request.getParameter("scd_dt")==null?"":request.getParameter("scd_dt");
	String s_dt 	= request.getParameter("s_dt")==null?"":request.getParameter("s_dt");
	String card_kind 	= request.getParameter("card_kind")==null?"":request.getParameter("card_kind");
	String save_cng_yn = request.getParameter("save_cng_yn")==null?"":request.getParameter("save_cng_yn");
	
	String s_scd_dt = request.getParameter("s_scd_dt")==null?"":request.getParameter("s_scd_dt");
	String e_scd_dt = request.getParameter("e_scd_dt")==null?"":request.getParameter("e_scd_dt");
	
	String size = request.getParameter("size")==null?"":request.getParameter("size");
	String size2 = request.getParameter("size2")==null?"":request.getParameter("size2");
	
	int flag = 0;
	String reg_type = "C";
	
	String vid1[] = request.getParameterValues("serial");
	String vid2[] = request.getParameterValues("ven_name");
	String vid3[] = request.getParameterValues("base_amt");
	String vid4[] = request.getParameterValues("save_per");
	String vid5[] = request.getParameterValues("save_amt");
	String vid6[] = request.getParameterValues("s_ven_name");
	String vid7[] = request.getParameterValues("s_save_per");
	
	
	for(int i=0; i < AddUtil.parseInt(size); i++){

		CardStatBean csb_bean = CardDb.getCardStatBase(AddUtil.parseInt(vid1[i]));
	
		csb_bean.setUpdate_id(ck_acar_id);
	
		//카드취소	
		if(AddUtil.parseDigit4(vid3[i]) == 0 && AddUtil.parseDigit4(vid5[i]) == 0){
			if(!CardDb.updateCardStatCancel(csb_bean)) flag += 1;
			reg_type = "N";
		//적립수정	
		}else{
			csb_bean.setVen_name(vid2[i]==null?"":vid2[i]);
			csb_bean.setBase_amt(AddUtil.parseDigit4(vid3[i]));
			csb_bean.setSave_per(AddUtil.parseFloat(vid4[i]));
			csb_bean.setSave_amt(AddUtil.parseDigit4(vid5[i]));
			if(!CardDb.updateCardStatBase(csb_bean)) flag += 1;
		}
	
		//card_stat_scd 수정
		if(!CardDb.updateCardStatScdRe(csb_bean)) flag += 1;
	
		if(reg_type.equals("C")){
	  	if(!CardDb.deleteCardStatScdRe(csb_bean)) flag += 1;
		}
			
	}
	
	if(save_cng_yn.equals("Y")){
		for(int i=0; i < AddUtil.parseInt(size2); i++){
			CardStatBean csb_bean = CardDb.getCardStatSave(card_kind, vid6[i]);
			csb_bean.setSave_per(AddUtil.parseFloat(vid7[i]));
			if(!CardDb.updateCardStatSave(csb_bean)) flag += 1;
		}
	}
	
	
	//재처리
	String  c_flag =  CardDb.call_sp_card_cont_reg();
	
	
%>

<html>
<head><title>FMS</title>
<script language='JavaScript' src='/include/common.js'></script>
<script language='javascript'>
<!--
	function go_step(){
		var fm = document.form1;
		fm.action = 'card_incom_list_allup.jsp';
		fm.target = "CardIncomListAll";
		fm.submit();

		fm.action = 'card_incom_sc.jsp';
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
<input type='hidden' name='scd_dt' value='<%=scd_dt%>'>
<input type='hidden' name='s_dt' value='<%=s_dt%>'>
<input type='hidden' name='card_kind' value='<%=card_kind%>'>
<input type='hidden' name='s_scd_dt' value='<%=s_scd_dt%>'>
<input type='hidden' name='e_scd_dt' value='<%=e_scd_dt%>'>
</form>
<a href="javascript:go_step()">다음으로</a>
<script language='javascript'>
<!--
<%	if(flag > 0){//에러발생%>
		alert("에러가 발생하였습니다.");
<%	}else{//정상%>
		alert("처리되었습니다.");
		
		<%if(!gubun1.equals("4")){%>
		go_step();
		<%}%>
<%	}%>
//-->
</script>
</body>
</html>
