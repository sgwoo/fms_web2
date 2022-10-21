<%@ page language="java" contentType="text/html;charset=euc-kr" %>
<%@ page import="java.util.*, acar.util.*, tax.*, acar.fee.*, acar.user_mng.*"%>
<jsp:useBean id="IssueDb" scope="page" class="tax.IssueDatabase"/>
<%@ include file="/tax/cookies_base.jsp" %>

<%
	
	UserMngDatabase 	umd 	= UserMngDatabase.getInstance();
	
	out.println("세금계산서 발행하기 2단계"+"<br><br>");
	
	String reg_st 		= request.getParameter("reg_st")==null?"":request.getParameter("reg_st");//all-전체발행,select선택발행
	String reg_gu 		= request.getParameter("reg_gu")==null?"":request.getParameter("reg_gu");//1-일괄발행,2-통합발행,3-개별발행
	String tax_out_dt 	= request.getParameter("tax_out_dt")==null?"":AddUtil.replace(request.getParameter("tax_out_dt"),"-","");//세금일자
	String reg_code 	= request.getParameter("reg_code")==null?"":request.getParameter("reg_code");
	String mail_auto_yn 	= request.getParameter("mail_auto_yn")==null?"":request.getParameter("mail_auto_yn");//메일발행방식

	out.println("reg_st  ="+reg_st+"<br>");
	out.println("reg_gu  ="+reg_gu+"<br>");
	out.println("tax_out_dt="+tax_out_dt+"<br>");
	out.println("reg_code="+reg_code+"<br><br>");
	
	//사용자
	UsersBean sender_bean 	= umd.getUsersBean(user_id);
	
	int flag = 0;


	//[2단계] 거래명세서 생성

	Vector vt = IssueDb.getTaxItemList(reg_code);
	int vt_size = vt.size();
	out.println("vt_size="+vt_size+"<br>");
	
	for(int i=0;i < vt_size;i++){
		Hashtable ht = (Hashtable)vt.elementAt(i);
		TaxItemBean ti_bean = new TaxItemBean();
		ti_bean.setItem_id			(String.valueOf(ht.get("ITEM_ID")));
		ti_bean.setClient_id		(String.valueOf(ht.get("CLIENT_ID")));
		ti_bean.setSeq					(String.valueOf(ht.get("SITE_ID")));
		ti_bean.setItem_dt			(String.valueOf(ht.get("ITEM_DT")));
		ti_bean.setTax_id				("");
		ti_bean.setItem_hap_str	(AddUtil.parseDecimalHan(String.valueOf(ht.get("ITEM_HAP_NUM")))+"원");
		ti_bean.setItem_hap_num	(AddUtil.parseInt(String.valueOf(ht.get("ITEM_HAP_NUM"))));
		ti_bean.setItem_man			(String.valueOf(ht.get("ITEM_MAN")));
		ti_bean.setTax_est_dt		(String.valueOf(ht.get("TAX_EST_DT")));
		ti_bean.setUse_yn				("Y");
		//대여료개별정기청구에서 통합발행하는 경우
		if(reg_gu.equals("2") && !tax_out_dt.equals("")){
			ti_bean.setItem_dt		(tax_out_dt);
			ti_bean.setTax_est_dt	(tax_out_dt);
			ti_bean.setTax_code		(reg_code);
		}
		
		//대여료개별정기청구에서 지정 세금일자가 있는 선택발행인 경우 - 월렌트
		if(reg_gu.equals("1") && !tax_out_dt.equals("") && ti_bean.getItem_dt().equals(tax_out_dt)){
			ti_bean.setItem_dt		(tax_out_dt);
			ti_bean.setTax_est_dt	(tax_out_dt);
			ti_bean.setTax_code		(reg_code);
		}
				
		if(!IssueDb.insertTaxItem(ti_bean)) flag += 1;
		
		out.println("item_id="+String.valueOf(ht.get("ITEM_ID"))+"<br>");
	}
%>

<html>
<head><title>FMS</title>
<script language='JavaScript' src='/include/common.js'></script>
<script language='javascript'>
<!--
	function go_step(){
		var fm = document.form1;
		if(fm.reg_gu.value == '2' && fm.tax_out_dt.value != ''){
			fm.action = 'https://fms3.amazoncar.co.kr/acar/admin/call_sp_tax_ebill_itemmail.jsp';
		}else if(fm.reg_gu.value == '2' && fm.tax_out_dt.value == ''){
			fm.action = 'sp_tax_ebill_itemmail.jsp';								
		}else{
			fm.action = 'sp_tax_ebill_itemmail.jsp';										
		}
		fm.submit();
	}	
//-->
</script>
<meta http-equiv="content-type" content="text/html; charset=euc-kr">
<link rel=stylesheet type="text/css" href="../../include/table.css">
</head>
<body>
<form name='form1' action='' method='post'>
<%@ include file="/include/search_hidden.jsp" %>
<input type='hidden' name='reg_st' 		value='<%=reg_st%>'>
<input type='hidden' name='reg_gu' 		value='<%=reg_gu%>'>
<input type='hidden' name='tax_out_dt' 	value='<%=tax_out_dt%>'>
<input type='hidden' name='reg_code' 	value='<%=reg_code%>'>
<input type='hidden' name='tax_code' 	value='<%=reg_code%>'>
<input type='hidden' name='sender_nm' 	value='<%=sender_bean.getUser_nm()%>'>
<input type='hidden' name='mail_auto_yn' value='<%=mail_auto_yn%>'>
<a href="javascript:go_step()">3단계로 가기</a>
<script language='javascript'>
<!--
<%	if(flag > 0){//에러발생
		//이미 작성한 거래명서세 삭제
		if(!IssueDb.deleteTaxAll(reg_code)) flag += 1;%>
		alert("거래명세서 작성중 에러가 발생하였습니다.");
<%	}else{//정상%>		
		go_step();
<%	}%>
//-->
</script>
</form>
</body>
</html>
