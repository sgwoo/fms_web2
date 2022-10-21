<%@ page language="java" contentType="text/html;charset=euc-kr" %>
<%@ page import="java.util.*, acar.util.*, tax.* "%>
<jsp:useBean id="IssueDb" scope="page" class="tax.IssueDatabase"/>
<%@ include file="/tax/cookies_base.jsp" %>

<%
	out.println("거래명세서 수정"+"<br><br>");
	
	String item_id	 	= request.getParameter("item_id")==null?"":request.getParameter("item_id");
	String item_size	= request.getParameter("item_size")==null?"":request.getParameter("item_size");
	
	int flag = 0;
	int vid_size = 0;
	
	String item_seq[] 		= request.getParameterValues("item_seq");
	String item_g[] 			= request.getParameterValues("item_g");
	String item_car_no[]	= request.getParameterValues("item_car_no");
	String item_car_nm[]	= request.getParameterValues("item_car_nm");
	String item_dt1[] 		= request.getParameterValues("item_dt1");
	String item_dt2[] 		= request.getParameterValues("item_dt2");
	String item_supply[]	= request.getParameterValues("item_supply");
	String item_value[] 	= request.getParameterValues("item_value");
	String del_chk[] 			= request.getParameterValues("del_chk");
	String item_etc[] 		= request.getParameterValues("item_etc");
	
	String item_dt				= request.getParameter("item_dt")==null?"":request.getParameter("item_dt");
	String tax_est_dt			= request.getParameter("tax_est_dt")==null?"":request.getParameter("tax_est_dt");
	String item_man				= request.getParameter("item_man")==null?"":request.getParameter("item_man");
	String item_hap_num		= request.getParameter("item_hap_num")==null?"":request.getParameter("item_hap_num");
	String tax_item_etc		= request.getParameter("tax_item_etc")==null?"":request.getParameter("tax_item_etc");
	
	
	if(!item_id.equals("")){
		
		vid_size = item_seq.length;
		
		//거래명세서 조회
		TaxItemBean ti_bean 	= IssueDb.getTaxItemCase(item_id);
		
		ti_bean.setItem_dt			(item_dt);
		ti_bean.setItem_hap_str	(AddUtil.parseDecimalHan(item_hap_num)+"원");
		ti_bean.setItem_hap_num	(AddUtil.parseInt(item_hap_num));
		ti_bean.setItem_man			(item_man);
		ti_bean.setTax_est_dt		(tax_est_dt);
		ti_bean.setTax_item_etc	(tax_item_etc);
		
		if(!IssueDb.updateTaxItem(ti_bean)) flag += 1;


		for(int i = 0 ; i < vid_size ; i++){
			TaxItemListBean til_bean = IssueDb.getTaxItemListCase(item_id, item_seq[i]);
			
			if(del_chk[i].equals("Y")){//삭제
			
				if(!IssueDb.deleteTaxItemList(til_bean)) flag += 1;
				
			}else if(del_chk[i].equals("A")){//추가
				
				til_bean = new TaxItemListBean();
				
				if(AddUtil.parseDigit(item_supply[i]) >0){
					til_bean.setItem_id			(item_id);
					til_bean.setItem_seq		(AddUtil.parseInt(item_seq[i]));
					til_bean.setItem_g			(item_g[i]);
					til_bean.setItem_car_no	(item_car_no[i]);
					til_bean.setItem_car_nm	(item_car_nm[i]);
					til_bean.setItem_dt1		(item_dt1[i]);
					til_bean.setItem_dt2		(item_dt2[i]);
					til_bean.setItem_supply	(AddUtil.parseDigit(item_supply[i]));
					til_bean.setItem_value	(AddUtil.parseDigit(item_value[i]));
					til_bean.setRent_l_cd		(request.getParameter("rent_l_cd")==null?"":request.getParameter("rent_l_cd"));
					til_bean.setCar_mng_id	(request.getParameter("car_mng_id")==null?"":request.getParameter("car_mng_id"));
					til_bean.setTm					(request.getParameter("tm")==null?"":request.getParameter("tm"));
					til_bean.setRent_st			(request.getParameter("rent_st")==null?"":request.getParameter("rent_st"));
					til_bean.setRent_seq		(request.getParameter("rent_seq")==null?"":request.getParameter("rent_seq"));
					til_bean.setGubun				(request.getParameter("gubun")==null?"":request.getParameter("gubun"));
					til_bean.setCar_use			(request.getParameter("car_use")==null?"":request.getParameter("car_use"));
					til_bean.setReg_id			(user_id);
					til_bean.setReg_code		(request.getParameter("reg_code")==null?"":request.getParameter("reg_code"));
					til_bean.setEtc					(item_etc[i]);
					if(!IssueDb.insertTaxItemList(til_bean)) flag += 1;
				}
			}else{
				til_bean.setItem_g			(item_g[i]);
				til_bean.setItem_car_no	(item_car_no[i]);
				til_bean.setItem_car_nm	(item_car_nm[i]);
				til_bean.setItem_dt1		(item_dt1[i]);
				til_bean.setItem_dt2		(item_dt2[i]);
				til_bean.setItem_supply	(AddUtil.parseDigit(item_supply[i]));
				til_bean.setItem_value	(AddUtil.parseDigit(item_value[i]));
				til_bean.setEtc					(item_etc[i]);
				if(!IssueDb.updateTaxItemList(til_bean)) flag += 1;
			}
		}
	}
%>

<html>
<head><title></title>
<script language='JavaScript' src='/include/common.js'></script>
<script language='javascript'>
<!--
	function go_step(){	  
		var fm = document.form1;
		fm.action = 'tax_item_u.jsp';
		fm.target = 'TaxItem';
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
  <input type="hidden" name="item_id" value="<%=item_id%>">  
</form>
<a href="javascript:go_step()">2단계로 가기</a>
<script language='javascript'>
<!--
<%	if(flag > 0){//에러발생%>
		alert("거래명세서 수정중 에러가 발생하였습니다.");
<%	}else{//정상%>
		alert('수정완료');
		go_step();
<%	}%>
//-->
</script>
</body>
</html>
