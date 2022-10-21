<%@ page language="java" contentType="text/html;charset=euc-kr" %>
<%@ page import="java.util.*, acar.util.*, acar.common.*, tax.*, acar.fee.*, acar.forfeit_mng.*, acar.bill_mng.*"%>
<jsp:useBean id="IssueDb" scope="page" class="tax.IssueDatabase"/>
<%@ include file="/tax/cookies_base.jsp" %>

<%
	CommonDataBase c_db = CommonDataBase.getInstance();
	
	out.println("세금계산서 수정"+"<br><br>");
	
	String tax_no	 	= request.getParameter("tax_no")==null?"":request.getParameter("tax_no");
	String item_id	 	= request.getParameter("item_id")==null?"":request.getParameter("item_id");
	String item_size	= request.getParameter("item_size")==null?"":request.getParameter("item_size");
	String ebill_yn		= request.getParameter("ebill_yn")==null?"N":request.getParameter("ebill_yn");	
	int flag = 0;
	int vid_size = 0;
	
	String o_br_id[] 	= request.getParameterValues("o_br_id");
	String tax_dt[] 	= request.getParameterValues("tax_dt");
	String tax_supply[] = request.getParameterValues("tax_supply");
	String tax_value[] 	= request.getParameterValues("tax_value");
	String tax_g[] 		= request.getParameterValues("tax_g");
	String tax_bigo[] 	= request.getParameterValues("tax_bigo");
	
	String item_dt[] 	= request.getParameterValues("item_dt");
	String item_seq[] 	= request.getParameterValues("item_seq");
	String item_g[] 	= request.getParameterValues("item_g");
	String item_car_no[]= request.getParameterValues("item_car_no");
	String item_car_nm[]= request.getParameterValues("item_car_nm");
	String item_dt1[] 	= request.getParameterValues("item_dt1");
	String item_dt2[] 	= request.getParameterValues("item_dt2");
	String item_supply[]= request.getParameterValues("item_supply");
	String item_value[] = request.getParameterValues("item_value");
	String del_chk[] 	= request.getParameterValues("del_chk");
	String item_hap_num	= request.getParameter("item_hap_num")==null?"":request.getParameter("item_hap_num");
	if(!item_id.equals("")){
		vid_size = item_seq.length;
	}
	
	//세금계산서 조회
	tax.TaxBean t_bean 		= IssueDb.getTax(tax_no);
	
	t_bean.setTax_dt(tax_dt[1]);
	t_bean.setBranch_g(o_br_id[1]);
	t_bean.setTax_g(tax_g[1]);
	t_bean.setTax_supply(AddUtil.parseDigit(tax_supply[1]));
	t_bean.setTax_value(AddUtil.parseDigit(tax_value[1]));
	t_bean.setTax_bigo(tax_bigo[1]);
	if(!IssueDb.updateTax(t_bean)) flag += 1;

	if(ebill_yn.equals("Y") && !t_bean.getResseq().equals("")){
		//트러스빌 취소후 재발급처리
		SaleEBillBean sb_bean = new SaleEBillBean();
		sb_bean.setResSeq(t_bean.getResseq());
		sb_bean.setTaxSNum1(tax_no);
		sb_bean.setPubDate(t_bean.getTax_dt());
		sb_bean.setRemarks(t_bean.getTax_bigo());
		sb_bean.setSupPrice(t_bean.getTax_supply());
		sb_bean.setTax(t_bean.getTax_value());
		sb_bean.setItemDate1(t_bean.getTax_dt().substring(5,10));
		sb_bean.setItemName1(t_bean.getTax_g());
		sb_bean.setItemSupPrice1(t_bean.getTax_supply());
		sb_bean.setItemTax1(t_bean.getTax_value());
		
		//본사-영업소
		Hashtable br1 = c_db.getBranch("S1");
		//발생-영업소
		Hashtable br = c_db.getBranch(t_bean.getBranch_g());
		
		if(!String.valueOf(br.get("BR_ENT_NO")).equals(String.valueOf(br1.get("BR_ENT_NO")))){
			sb_bean.setRefCoRegNo(String.valueOf(br1.get("BR_ENT_NO")));
			sb_bean.setRefCoName("(주)아마존카");
		}
		sb_bean.setCoRegNo(String.valueOf(br.get("BR_ENT_NO")));
		sb_bean.setCoName("(주)아마존카");
		sb_bean.setCoCeo(String.valueOf(br.get("BR_OWN_NM")));
		sb_bean.setCoAddr(String.valueOf(br.get("BR_ADDR")));
		sb_bean.setCoBizType(String.valueOf(br.get("BR_STA")));
		sb_bean.setCoBizSub(String.valueOf(br.get("BR_ITEM")));
		
		if(!IssueDb.updateSaleEBillTaxUpdate(sb_bean)) flag += 1;
	}

	if(!item_id.equals("")){
	
		//거래명세서 조회
		TaxItemBean ti_bean 	= IssueDb.getTaxItemCase(item_id);
		
		ti_bean.setItem_dt(item_dt[1]);
		ti_bean.setItem_hap_str(AddUtil.parseDecimalHan(item_hap_num)+"원");
		ti_bean.setItem_hap_num(AddUtil.parseInt(item_hap_num));
		if(!IssueDb.updateTaxItem(ti_bean)) flag += 1;


		//거래명세서 리스트 조회
		if(vid_size == 1){
				TaxItemListBean til_bean = IssueDb.getTaxItemListCase(item_id, request.getParameter("item_seq"));
				
				til_bean.setItem_g(request.getParameter("item_g"));
				til_bean.setItem_car_no(request.getParameter("item_car_no"));
				til_bean.setItem_car_nm(request.getParameter("item_car_nm"));
				til_bean.setItem_dt1(request.getParameter("item_dt1"));
				til_bean.setItem_dt2(request.getParameter("item_dt2"));
				til_bean.setItem_supply(AddUtil.parseDigit(request.getParameter("item_supply")));
				til_bean.setItem_value(AddUtil.parseDigit(request.getParameter("item_value")));
				if(!IssueDb.updateTaxItemList(til_bean)) flag += 1;
		}else{
			for(int i=0;i < vid_size;i++){
				TaxItemListBean til_bean = IssueDb.getTaxItemListCase(item_id, item_seq[i]);
				if(del_chk[i].equals("N")){//수정
					til_bean.setItem_g(item_g[i]);
					til_bean.setItem_car_no(item_car_no[i]);
					til_bean.setItem_car_nm(item_car_nm[i]);
					til_bean.setItem_dt1(item_dt1[i]);
					til_bean.setItem_dt2(item_dt2[i]);
					til_bean.setItem_supply(AddUtil.parseDigit(item_supply[i]));
					til_bean.setItem_value(AddUtil.parseDigit(item_value[i]));
					if(!IssueDb.updateTaxItemList(til_bean)) flag += 1;
				}else if(del_chk[i].equals("Y")){//삭제
					if(!IssueDb.deleteTaxItemList(til_bean)) flag += 1;
				}
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
<input type='hidden' name='tax_no' 		value='<%=tax_no%>'>
</form>
<a href="javascript:go_step()">2단계로 가기</a>
<script language='javascript'>
<!--
<%	if(flag > 0){//에러발생%>
		alert("세금계산서 수정중 에러가 발생하였습니다.");
<%	}else{//정상%>
		go_step();
<%	}%>
//-->
</script>
</body>
</html>
