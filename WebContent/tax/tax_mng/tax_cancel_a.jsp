<%@ page language="java" contentType="text/html;charset=euc-kr" %>
<%@ page import="java.util.*, acar.util.*, tax.*, acar.fee.*, acar.forfeit_mng.*, acar.bill_mng.*"%>
<jsp:useBean id="IssueDb" scope="page" class="tax.IssueDatabase"/>
<jsp:useBean id="rs_db" scope="page" class="acar.res_search.ResSearchDatabase"/>
<%@ include file="/tax/cookies_base.jsp" %>

<%
	
	
	out.println("세금계산서 발행취소"+"<br><br>");
	
	LoginBean login = LoginBean.getInstance();
	if(user_id.equals("")) 	user_id = login.getCookieValue(request, "acar_id");
	if(br_id.equals(""))	br_id = login.getCookieValue(request, "acar_br");
	if(auth_rw.equals(""))	auth_rw = rs_db.getAuthRw(user_id, "05", "07", "01");
	
	String rent_mng_id 	= request.getParameter("rent_mng_id")==null?"":request.getParameter("rent_mng_id");
	String rent_l_cd 	= request.getParameter("rent_l_cd")==null?"":request.getParameter("rent_l_cd");
	String car_mng_id 	= request.getParameter("car_mng_id")==null?"":request.getParameter("car_mng_id");
	String client_id 	= request.getParameter("client_id")==null?"":request.getParameter("client_id");
	String site_id 		= request.getParameter("site_id")==null?"":request.getParameter("site_id");
	String mode 		= request.getParameter("mode")==null?"":request.getParameter("mode");
	
	String count 		= request.getParameter("count")==null?"":request.getParameter("count");
	String tax_no	 	= request.getParameter("tax_no")==null?"":request.getParameter("tax_no");
	String cng_cau		= request.getParameter("cng_cau")==null?"":request.getParameter("cng_cau");	
	String cng_st		= request.getParameter("cng_st")==null?"N":request.getParameter("cng_st");	
	
	int flag = 0;
	//세금계산서 조회
	tax.TaxBean t_bean 			= IssueDb.getTax(tax_no);
	
	//[1단계] 원본 계산서에 매출취소 계산서번호 수정
	if(!IssueDb.updateTaxRegCancel2(tax_no, t_bean.getItem_id())) flag += 1;

	//[2단계] 매출취소 사유 생성
	TaxCngBean tc_bean = new TaxCngBean();
	tc_bean.setTax_no(tax_no);
	tc_bean.setSeq(IssueDb.getTaxCngSeqNext(tax_no));
	tc_bean.setCng_cau(cng_cau);
	tc_bean.setCng_id(user_id);
	if(!IssueDb.insertTaxCng(tc_bean)) flag += 1;
	
	if(cng_st.equals("Y")){
		//[3단계] 트러스빌 발급취소 처리준비
		if(!IssueDb.updateEBillTaxCancel(tax_no)) flag += 1;
	}
%>

<html>
<head><title>FMS</title>
<script language='JavaScript' src='/include/common.js'></script>
<script language='javascript'>
<!--
	function go_step(){
	
	  parent.window.close();
	  
		var fm = document.form1;
		fm.action = 'tax_mng_c.jsp';
		fm.target = 'd_content';
		fm.submit();
	}
//-->
</script>
<meta http-equiv="content-type" content="text/html; charset=euc-kr">
<link rel=stylesheet type="text/css" href="../../include/table.css">
</head>
<body onLoad="javascript:init()">
<form name='form1' action='' method='post'>
<%@ include file="/include/search_hidden.jsp" %>
<input type='hidden' name='client_id' 	value='<%=client_id%>'>
<input type='hidden' name='site_id' 	value='<%=site_id%>'>
<input type='hidden' name='tax_no' 		value='<%=tax_no%>'>
</form>
<a href="javascript:go_step()">2단계로 가기</a>
<script language='javascript'>
<!--
<%	if(flag > 0){//에러발생%>
		alert("세금계산서 발행취소중 에러가 발생하였습니다.");
<%	}else{//정상%>
		go_step();
<%	}%>
//-->
</script>
</body>
</html>
