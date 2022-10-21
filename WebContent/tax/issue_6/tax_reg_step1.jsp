<%@ page language="java" contentType="text/html;charset=euc-kr" %>
<%@ page import="java.util.*, acar.util.*, tax.*, acar.fee.*, acar.forfeit_mng.*, acar.bill_mng.*"%>
<jsp:useBean id="IssueDb" scope="page" class="tax.IssueDatabase"/>
<jsp:useBean id="rs_db" scope="page" class="acar.res_search.ResSearchDatabase"/>
<%@ include file="/tax/cookies_base.jsp" %>

<%
	
	
	out.println("세금계산서 직접 발행하기 1단계"+"<br><br>");
	
	LoginBean login = LoginBean.getInstance();
	if(user_id.equals("")) 	user_id = login.getCookieValue(request, "acar_id");
	if(br_id.equals(""))	br_id = login.getCookieValue(request, "acar_br");
	if(auth_rw.equals(""))	auth_rw = rs_db.getAuthRw(user_id, "05", "06", "19");
	
	String i_site_id 	= request.getParameter("i_site_id")==null?"":request.getParameter("i_site_id");
	String o_br_id 		= request.getParameter("o_br_id")==null?"":request.getParameter("o_br_id");
	String rent_mng_id 	= request.getParameter("rent_mng_id")==null?"":request.getParameter("rent_mng_id");
	String rent_l_cd 	= request.getParameter("rent_l_cd")==null?"":request.getParameter("rent_l_cd");
	String car_mng_id 	= request.getParameter("car_mng_id")==null?"":request.getParameter("car_mng_id");
	String client_id 	= request.getParameter("client_id")==null?"":request.getParameter("client_id");
	String site_id 		= request.getParameter("site_id")==null?"":request.getParameter("site_id");
	String mode 		= request.getParameter("mode")==null?"":request.getParameter("mode");
	
	String count 		= request.getParameter("count")==null?"":request.getParameter("count");
	
	String tax_bigo 	= request.getParameter("tax_bigo")==null?"":request.getParameter("tax_bigo");
	String tax_g 		= request.getParameter("tax_g")==null?"":request.getParameter("tax_g");
	String req_y 		= request.getParameter("req_y")==null?"":request.getParameter("req_y");	
	String req_m 		= request.getParameter("req_m")==null?"":AddUtil.addZero(request.getParameter("req_m"));
	String req_d 		= request.getParameter("req_d")==null?"":AddUtil.addZero(request.getParameter("req_d"));
	String tax_supply	= request.getParameter("tax_supply")==null?"":request.getParameter("tax_supply");
	String tax_value	= request.getParameter("tax_value")==null?"":request.getParameter("tax_value");	
	
	String con_agnt_nm 	= request.getParameter("con_agnt_nm")==null?"":request.getParameter("con_agnt_nm");
	String con_agnt_dept 	= request.getParameter("con_agnt_dept")==null?"":request.getParameter("con_agnt_dept");
	String con_agnt_title 	= request.getParameter("con_agnt_title")==null?"":request.getParameter("con_agnt_title");
	String con_agnt_email 	= request.getParameter("con_agnt_email")==null?"":request.getParameter("con_agnt_email");
	String con_agnt_m_tel 	= request.getParameter("con_agnt_m_tel")==null?"":request.getParameter("con_agnt_m_tel");
	String con_agnt_nm2 		= request.getParameter("con_agnt_nm2")==null?"":request.getParameter("con_agnt_nm2");
	String con_agnt_dept2 	= request.getParameter("con_agnt_dept2")==null?"":request.getParameter("con_agnt_dept2");
	String con_agnt_title2 	= request.getParameter("con_agnt_title2")==null?"":request.getParameter("con_agnt_title2");
	String con_agnt_email2 	= request.getParameter("con_agnt_email2")==null?"":request.getParameter("con_agnt_email2");
	String con_agnt_m_tel2 	= request.getParameter("con_agnt_m_tel2")==null?"":request.getParameter("con_agnt_m_tel2");		
	String car_use		= request.getParameter("car_use")==null?"":request.getParameter("car_use");
	String doc_st		= request.getParameter("doc_st")==null?"":request.getParameter("doc_st");
	String etax_item_st		= request.getParameter("etax_item_st")==null?"":request.getParameter("etax_item_st");
	
	String reg_gu = "6";
	int flag = 0;


	//실행코드 가져오기
	String reg_code  = Long.toString(System.currentTimeMillis());
	out.println("실행코드="+reg_code+"<br>");

	//사용할 item_id 가져오기
	String item_id = IssueDb.getItemIdNext(req_y+req_m+req_d);
	out.println("item_id="+item_id+"<br><br>");


	String seq[] 				= request.getParameterValues("seq");
	String item_g[] 		= request.getParameterValues("item_g");
	String item_car_no[] = request.getParameterValues("item_car_no");
	String item_car_nm[] = request.getParameterValues("item_car_nm");
	String item_dt1[] 	= request.getParameterValues("item_dt1");
	String item_dt2[] 	= request.getParameterValues("item_dt2");
	String item_supply[] = request.getParameterValues("item_supply");
	String item_value[] = request.getParameterValues("item_value");
	String item_amt[] 	= request.getParameterValues("item_amt");
	String l_cd[] 			= request.getParameterValues("l_cd");
	String c_id[] 			=	request.getParameterValues("c_id");
	String tm[] 				= request.getParameterValues("tm");
	String item_etc[] 	= request.getParameterValues("item_etc");
	
	int vid_size = item_supply.length;
	int item_cnt = 0;
	
	//[1단계] 거래명세서 리스트 생성
	for(int i=0;i < vid_size;i++){
		
		TaxItemListBean til_bean = new TaxItemListBean();
		
		til_bean.setItem_id			(item_id);
		til_bean.setItem_seq		(AddUtil.parseInt(seq[i]));
		til_bean.setItem_g			(item_g[i]);
		til_bean.setItem_car_no	(item_car_no[i]);
		til_bean.setItem_car_nm	(item_car_nm[i]);
		til_bean.setItem_dt1		(item_dt1[i]);
		til_bean.setItem_dt2		(item_dt2[i]);
		til_bean.setItem_supply	(AddUtil.parseDigit(item_supply[i]));
		til_bean.setItem_value	(AddUtil.parseDigit(item_value[i]));
		til_bean.setRent_l_cd		(rent_l_cd);
		til_bean.setCar_mng_id	(car_mng_id);
		til_bean.setTm					("");
		til_bean.setGubun				("");
		til_bean.setReg_id			(user_id);
		til_bean.setReg_code		(reg_code);
		til_bean.setItem_dt			(req_y+req_m+req_d);
		til_bean.setCar_use			(car_use);
		til_bean.setEtc					(item_etc[i]);
		
		if(til_bean.getItem_supply() >0 || til_bean.getItem_supply() <0){
			item_cnt++;
			if(!IssueDb.insertTaxItemList(til_bean)) flag += 1;
			//gubun = 1 대여료, 2 보증금, 3 선납금, 4 개시대여료, 5 위약금, 6 차량매각대금, 7 정비비, 8 과태료, 9 self, 10 보험대차, 11 대차료, 12 휴차료, 13 업무대여, null=직접발행
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
		fm.action = '../issue_3/tax_reg_step2.jsp';
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
<input type='hidden' name='client_id' 		value='<%=client_id%>'>
<input type='hidden' name='site_id' 		value='<%=i_site_id%>'>
<input type='hidden' name='brch_id' 		value='<%=o_br_id%>'>
<input type='hidden' name='tax_g' 		value='<%=tax_g%>'>
<input type='hidden' name='tax_bigo' 		value='<%=tax_bigo%>'>
<input type='hidden' name='req_dt' 		value='<%=req_y+req_m+req_d%>'>
<input type='hidden' name='tax_dt' 		value='<%=req_y+req_m+req_d%>'>

<input type='hidden' name='reg_gu' 		value='<%=reg_gu%>'>
<input type='hidden' name='reg_code' 		value='<%=reg_code%>'>
<input type='hidden' name='item_list_cnt' 	value='<%=item_cnt%>'>
<input type='hidden' name='con_agnt_nm' 	value='<%=con_agnt_nm%>'>
<input type='hidden' name='con_agnt_dept' 	value='<%=con_agnt_dept%>'>
<input type='hidden' name='con_agnt_title' 	value='<%=con_agnt_title%>'>
<input type='hidden' name='con_agnt_email' 	value='<%=con_agnt_email%>'>
<input type='hidden' name='con_agnt_m_tel' 	value='<%=con_agnt_m_tel%>'>
<input type='hidden' name='con_agnt_nm2' 		value='<%=con_agnt_nm2%>'>
<input type='hidden' name='con_agnt_dept2' 	value='<%=con_agnt_dept2%>'>
<input type='hidden' name='con_agnt_title2' value='<%=con_agnt_title2%>'>
<input type='hidden' name='con_agnt_email2' value='<%=con_agnt_email2%>'>
<input type='hidden' name='con_agnt_m_tel2' value='<%=con_agnt_m_tel2%>'>
<input type='hidden' name='doc_st' 		value='<%=doc_st%>'>
<input type='hidden' name='etax_item_st' 		value='<%=etax_item_st%>'>
</form>
<a href="javascript:go_step()">2단계로 가기</a>
<script language='javascript'>
<!--
<%	if(flag > 0){//에러발생%>
		alert("세금계산서 직접발행 작성중 에러가 발생하였습니다.");
<%	}else{//정상%>
		go_step();
<%	}%>
//-->
</script>
</body>
</html>
