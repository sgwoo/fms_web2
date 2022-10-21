<%@ page language="java" contentType="text/html;charset=euc-kr" %>
<%@ page import="java.util.*, acar.util.*, acar.fee.*, acar.common.*, tax.*, acar.bill_mng.*, acar.client.*"%>
<jsp:useBean id="ScdMngDb" scope="page" class="tax.ScdMngDatabase"/>
<jsp:useBean id="IssueDb" scope="page" class="tax.IssueDatabase"/>
<jsp:useBean id="al_db" scope="page" class="acar.client.AddClientDatabase"/>
<%@ include file="/tax/cookies_base.jsp" %>

<%
	CommonDataBase c_db = CommonDataBase.getInstance();
	NeoErpUDatabase neoe_db = NeoErpUDatabase.getInstance();
	
	String tax_no 	= request.getParameter("tax_no")==null?"":request.getParameter("tax_no");
	String rent_mng_id 	= request.getParameter("rent_mng_id")==null?"":request.getParameter("rent_mng_id");
	String rent_l_cd 	= request.getParameter("rent_l_cd")==null?"":request.getParameter("rent_l_cd");
	String car_mng_id 	= request.getParameter("car_mng_id")==null?"":request.getParameter("car_mng_id");
	String client_id 	= request.getParameter("client_id")==null?"":request.getParameter("client_id");
	String site_id 		= request.getParameter("site_id")==null?"":request.getParameter("site_id");
	String mode = request.getParameter("mode")==null?"":request.getParameter("mode");
	long item_s_amt = 0;
	long item_v_amt = 0;
	int height = 0;
	
	//세금계산서 조회
	tax.TaxBean t_bean 		= IssueDb.getTax(tax_no);
//	Hashtable t_ht 			= IssueDb.getTaxHt(tax_no);
	//거래명세서 조회
	TaxItemBean ti_bean 	= IssueDb.getTaxItemCase(t_bean.getItem_id());
	//거래명세서 리스트 조회
	Vector tils	            = IssueDb.getTaxItemListCase(t_bean.getItem_id());
	int til_size            = tils.size();
	//공급자
	Hashtable br            = c_db.getBranch(t_bean.getBranch_g().trim());
	//거래처정보
	ClientBean client       = al_db.getClient(t_bean.getClient_id().trim());
	
	//거래처지점정보
	ClientSiteBean site     = al_db.getClientSite(t_bean.getClient_id(), t_bean.getSeq());
	//네오엠 거래처 정보
	Hashtable ven           = neoe_db.getVendorCase(client.getVen_code());
	//장기계약 상단정보
	LongRentBean bean       = ScdMngDb.getScdMngLongRentInfo("", t_bean.getRent_l_cd().trim());
	if(til_size > 1){
	  TaxItemListBean til = (TaxItemListBean)tils.elementAt(0);
	  bean  = ScdMngDb.getScdMngLongRentInfo("", til.getRent_l_cd());
	}
	Vector branches = c_db.getBranchs(); //영업소 리스트 조회
	int brch_size = branches.size();
	
	String tax_supply = String.valueOf(t_bean.getTax_supply());
	String tax_value = String.valueOf(t_bean.getTax_value());
	String i_enp_no = client.getEnp_no1() +"-"+ client.getEnp_no2() +"-"+ client.getEnp_no3();
	if(client.getEnp_no1().equals("")) i_enp_no = client.getSsn1() +"-"+ client.getSsn2();
	String i_firm_nm = client.getFirm_nm();
	String i_client_nm = client.getClient_nm();
	String i_addr = client.getO_addr();
	String i_sta = client.getBus_cdt();
	String i_item = client.getBus_itm();
	
	if(t_bean.getTax_type().equals("2") && !site.getClient_id().equals("")){
	  i_enp_no = site.getEnp_no();
	  i_firm_nm = site.getR_site();
	  i_client_nm = site.getSite_jang();
	  i_addr = site.getAddr();
	  i_sta = site.getBus_cdt();
	  i_item = site.getBus_itm();
	}
%>

<html>
<head>
<title>FMS</title>
<meta http-equiv="content-type" content="text/html; charset=euc-kr">
<link rel="stylesheet" type="text/css" href="../../include/table.css">
<script language="JavaScript" src="/include/common.js"></script>
<script language="JavaScript">
<!--
	//목록가기
	function go_list(){
		var fm = document.form1;
		fm.target = "d_content";
		fm.action = "tax_mng_frame.jsp";
		fm.submit();
	}
	
	
	//내용수정하기	
	function tax_update(){
		var fm = document.form1;
		if(fm.o_br_id[1].value == '')	{ alert("변경후 발행영업소를 입력하십시오."); 	return;}
		if(fm.tax_dt[1].value == '')	{ alert("변경후 세금일자를 입력하십시오."); 	return;}
		if(fm.tax_supply[1].value == '' || fm.tax_supply[1].value == '0')	{ alert("변경후 공급가를 입력하십시오."); 	return;}
		if(fm.tax_value[1].value == '' || fm.tax_value[1].value == '0')		{ alert("변경후 부가세를 입력하십시오."); 	return;}
		if(fm.tax_g[1].value == '')		{ alert("변경후 품목을 입력하십시오."); 		return;}
		if(fm.tax_bigo[1].value == '')	{ alert("변경후 비고를 입력하십시오."); 		return;}
		
		<%if(!ti_bean.getItem_id().equals("")){%>
		if(fm.tax_supply[1].value != fm.t_item_supply.value)	{ alert("세금계산서 공급가와 거래명세서 공급가 합계가 틀립니다. 확인하십시오."); 	return;}
		if(fm.tax_value[1].value != fm.t_item_value.value)		{ alert("세금계산서 부가세와 거래명세서 부가세 합계가 틀립니다. 확인하십시오."); 	return;}

		fm.item_hap_num.value = parseDigit(fm.t_item_amt.value);
		<%}%>
		
		if(confirm('수정 하시겠습니까?')){
			fm.action = 'tax_mng_u_m_a.jsp';
//			fm.target = 'i_no';
			fm.submit();
		}
	}
	
	<%if(!ti_bean.getItem_id().equals("")){%>	
	//거래명세서 리스트 수정시
	function item_amt_set(obj, idx){
		var fm = document.form1;
		var size = toInt(fm.item_size.value);
		if(size == 1){//1건
			if(obj == 's'){
				fm.item_value.value 	= parseDecimal(toInt(parseDigit(fm.item_supply.value)) * 0.1 );
				fm.item_amt.value 		= parseDecimal(toInt(parseDigit(fm.item_supply.value)) + toInt(parseDigit(fm.item_value.value)));			
			}
			if(obj == 'v'){
//				fm.item_supply.value 	= parseDecimal(toInt(parseDigit(fm.item_value.value)) / 0.1 );
				fm.item_amt.value 		= parseDecimal(toInt(parseDigit(fm.item_supply.value)) + toInt(parseDigit(fm.item_value.value)));			
			}
			if(obj == 'a'){
//				fm.item_supply.value 	= parseDecimal(toInt(parseDigit(fm.item_value.value)) / 1.1 );
//				fm.item_value.value 	= parseDecimal(toInt(parseDigit(fm.item_value.value)) - toInt(parseDigit(fm.item_supply.value)));			
			}			
			fm.t_item_supply.value	= fm.item_supply.value;
			fm.t_item_value.value 	= fm.item_value.value;
		}else{//여러건
			fm.t_item_supply.value = 0;
			fm.t_item_value.value = 0;		
			if(obj == 's'){
				fm.item_value[idx].value 	= parseDecimal(toInt(parseDigit(fm.item_supply[idx].value)) * 0.1 );
				fm.item_amt[idx].value 		= parseDecimal(toInt(parseDigit(fm.item_supply[idx].value)) + toInt(parseDigit(fm.item_value[idx].value)));			
			}			
			if(obj == 'v'){
//				fm.item_supply[idx].value 	= parseDecimal(toInt(parseDigit(fm.item_value[idx].value)) / 0.1 );
				fm.item_amt[idx].value 		= parseDecimal(toInt(parseDigit(fm.item_supply[idx].value)) + toInt(parseDigit(fm.item_value[idx].value)));			
			}
			if(obj == 'a'){
//				fm.item_supply[idx].value 	= parseDecimal(toInt(parseDigit(fm.item_value[idx].value)) / 1.1 );
//				fm.item_value[idx].value 	= parseDecimal(toInt(parseDigit(fm.item_value[idx].value)) - toInt(parseDigit(fm.item_supply[idx].value)));			
			}
			
			//거래명세서 합계 계산
			for(i=0; i<size; i++){			
				fm.t_item_supply.value	= parseDecimal(toInt(parseDigit(fm.t_item_supply.value)) + toInt(parseDigit(fm.item_supply[i].value)));			
				fm.t_item_value.value 	= parseDecimal(toInt(parseDigit(fm.t_item_value.value)) + toInt(parseDigit(fm.item_value[i].value)));			
			}
		}
		fm.t_item_amt.value 		= parseDecimal(toInt(parseDigit(fm.t_item_supply.value)) + toInt(parseDigit(fm.t_item_value.value)));
		
		fm.tax_supply[1].value		= fm.t_item_supply.value;
		fm.tax_value[1].value		= fm.t_item_value.value;
		
	}
		
	//거래명세서에서 빼기
	function del_chk_set(idx){
		var fm = document.form1;
		var size = toInt(fm.item_size.value);
		//거래명세서 합계 계산
		for(i=0; i<size; i++){
			if(i== idx && fm.del_chk[idx].value == "Y"){
				fm.t_item_supply.value	= parseDecimal(toInt(parseDigit(fm.t_item_supply.value)) - toInt(parseDigit(fm.item_supply[i].value)));			
				fm.t_item_value.value 	= parseDecimal(toInt(parseDigit(fm.t_item_value.value)) - toInt(parseDigit(fm.item_value[i].value)));			
			}else if(i== idx && fm.del_chk[idx].value == "N"){
				fm.t_item_supply.value	= parseDecimal(toInt(parseDigit(fm.t_item_supply.value)) + toInt(parseDigit(fm.item_supply[i].value)));			
				fm.t_item_value.value 	= parseDecimal(toInt(parseDigit(fm.t_item_value.value)) + toInt(parseDigit(fm.item_value[i].value)));						
			}
		}

		fm.t_item_amt.value 		= parseDecimal(toInt(parseDigit(fm.t_item_supply.value)) + toInt(parseDigit(fm.t_item_value.value)));
		
		fm.tax_supply[1].value		= fm.t_item_supply.value;
		fm.tax_value[1].value		= fm.t_item_value.value;		
	}
	<%}%>
//-->
</script>
<style type="text/css">
<!--
.style1 {color: #FF0000}
-->
</style>
</head>
<body>
<form action="./issue_3_sc_a.jsp" name="form1" method="POST">
<%@ include file="/include/search_hidden.jsp" %>
  <input type="hidden" name="idx" value="<%=idx%>">
  <input type="hidden" name="tax_no" value="<%=tax_no%>">
  <input type="hidden" name="item_id" value="<%=t_bean.getItem_id()%>">  
  <input type="hidden" name="item_size" value="<%=til_size%>">
  <input type="hidden" name="item_hap_num" value="">
  <table width=100% border=0 cellpadding=0 cellspacing=0>
    <tr> 
      <td><font color="navy">세금계산서보관함 -&gt;  </font><span class="style1">세금계산서</span></td>
      <td align="right"><input type="button" name="b_ms2" value="목록" onClick="javascript:go_list();" class="btn">
	  &nbsp;<input type="button" name="b_ms3" value="뒤로가기" onClick="javascript:history.go(-1);" class="btn"></td>	  
    </tr>
    <tr>
      <td colspan="2" class="line"><table border="0" cellspacing="1" cellpadding="0" width='100%'>
        <tr>
          <td width='10%' class='title'>상호</td>
          <td colspan="3">&nbsp;<%=client.getFirm_nm()%>&nbsp;</td>
          <td class='title'>지점/현장</td>
          <td colspan="3" >&nbsp;<span title='<%=site.getR_site()%>'><%=Util.subData(site.getR_site(), 25)%></span></td>
        </tr>
        <tr>
          <td class='title'>발행구분</td>
          <td width="15%">&nbsp;<%=bean.getPrint_st()%></td>
          <td width="10%" class='title'>발행영업소</td>
          <td>&nbsp;<%=bean.getBr_nm()%></td>
          <td width='10%' class='title'>공급받는자</td>
          <td width='15%' >&nbsp;<%=bean.getTax_type()%></td>
          <td width="10%" class='title'>네오엠</td>
          <td width="15%">&nbsp;
              <% if(!client.getVen_code().equals("")){%>
      (<%=client.getVen_code()%>)<span title='<%=ven.get("VEN_NAME")%>'><%=Util.subData(String.valueOf(ven.get("VEN_NAME")), 4)%>
      <% }%>
    </span></td>
        </tr>
        <tr>
          <td class='title'>우편물주소</td>
          <td colspan="3">&nbsp;(<%=bean.getP_zip()%>) <span title='<%=bean.getP_addr()%>'><%=Util.subData(bean.getP_addr(), 25)%></span></td>
          <td class='title'>우편물수취인</td>
          <td colspan="3" >&nbsp;<%=bean.getTax_agnt()%></td>
        </tr>
      </table></td>
    </tr>
    <tr>
      <td colspan="2">&nbsp;</td>
    </tr>
    <tr>
      <td colspan="2">&lt; 세금계산서 &gt; </td>
    </tr>
    <tr>
      <td colspan="2" class="line">
        <table border="0" cellspacing="1" cellpadding="0" width='100%'>
          <tr>
            <td width='10%' class='title'>일련번호</td>
            <td width="90%" colspan="2">&nbsp;<span class="ledger_cont"><%=tax_no%></span></td>
          </tr>
          <tr>
            <td class='title'>구분</td>
            <td width="45%" class='title'>변경전</td>
            <td width="45%" class='title'>변경후</td>
          </tr>
          <tr>
            <td class='title'>발행영업소</td>
            <td align="center"><span class="ledger_contC">
			    <input type="hidden" name="o_br_id" value="<%=t_bean.getBranch_g()%>">
			    <select name='o_br_id_cd' disabled>
		          <option value=''>선택</option>
          			<%	if(brch_size > 0){
							for (int i = 0 ; i < brch_size ; i++){
								Hashtable branch = (Hashtable)branches.elementAt(i);%>
			      <option value='<%=branch.get("BR_ID")%>'  <%if(t_bean.getBranch_g().equals(String.valueOf(branch.get("BR_ID")))){%>selected<%}%>><%= branch.get("BR_NM")%></option>
          			<%		}
						}%>
		        </select>			  
            </span></td>
            <td align="center"><span class="ledger_contC">
			    <select name='o_br_id'>
		          <option value=''>선택</option>
          			<%	if(brch_size > 0){
							for (int i = 0 ; i < brch_size ; i++){
								Hashtable branch = (Hashtable)branches.elementAt(i);%>
			      <option value='<%=branch.get("BR_ID")%>'  <%if(t_bean.getBranch_g().equals(String.valueOf(branch.get("BR_ID")))){%>selected<%}%>><%= branch.get("BR_NM")%></option>
          			<%		}
						}%>
		        </select>			  
            </span></td>
          </tr>
          <tr>
            <td class='title'>세금일자</td>
            <td align="center"><span class="ledger_contC">
              <input name="tax_dt" type="text" class="whitetext" value="<%=AddUtil.ChangeDate2(t_bean.getTax_dt())%>" size="40" readonly>
            </span></td>
            <td align="center"><span class="ledger_contC">
              <input name="tax_dt" type="text" class="taxtext" value="<%=AddUtil.ChangeDate2(t_bean.getTax_dt())%>" size="40" onBlur='javscript:this.value = ChangeDate(this.value);'>
            </span></td>
          </tr>
          <tr>
            <td class='title'>공급가</td>
            <td align="center"><span class="ledger_cont"><span class="ledger_contC">
              <input type="text" name="tax_supply" size="38" value="<%=Util.parseDecimal(t_bean.getTax_supply())%>" class="whitetext" readonly>원
            </span></span></td>
            <td align="center"><span class="ledger_cont"><span class="ledger_contC">
              <input type="text" name="tax_supply" size="38" value="<%=Util.parseDecimal(t_bean.getTax_supply())%>" class="taxtext" onBlur='javascript:this.value=parseDecimal(this.value)'>원
            </span></span></td>
          </tr>
          <tr>
            <td class='title'>부가세</td>
            <td align="center"><span class="ledger_cont"><span class="ledger_contC">
              <input type="text" name="tax_value" size="38" value="<%=Util.parseDecimal(t_bean.getTax_value())%>" class="whitetext" readonly>원
            </span></span></td>
            <td align="center"><span class="ledger_cont"><span class="ledger_contC">
              <input type="text" name="tax_value" size="38" value="<%=Util.parseDecimal(t_bean.getTax_value())%>" class="taxtext" onBlur='javascript:this.value=parseDecimal(this.value)'>원
            </span></span></td>
          </tr>
          <tr>
            <td class='title'>품목</td>
            <td align="center"><span class="ledger_cont"><span class="ledger_contC">
              <input type="text" name="tax_g" size="40" value="<%=t_bean.getTax_g()%>" class="whitetext" readonly>
            </span></span></td>
            <td align="center"><span class="ledger_cont"><span class="ledger_contC">
              <input type="text" name="tax_g" size="40" value="<%=t_bean.getTax_g()%>" class="taxtext">
            </span></span></td>
          </tr>
          <tr>
            <td class='title'>비고</td>
            <td align="center"><span class="ledger_cont"><span class="ledger_contC">
              <input type="text" name="tax_bigo" size="40" value="<%=t_bean.getTax_bigo()%>" class="whitetext" readonly>
            </span></span></td>
            <td align="center"><span class="ledger_cont"><span class="ledger_contC">
              <input type="text" name="tax_bigo" size="40" value="<%=t_bean.getTax_bigo()%>" class="taxtext">
            </span></span></td>
          </tr>
        </table>
      </td>
    </tr>
	<%if(!ti_bean.getItem_id().equals("")){%>
    <tr>
      <td colspan="2">&lt; 거래명세서 &gt; </td>
    </tr>	
    <tr>
      <td colspan="2" class="line"><table border="0" cellspacing="1" cellpadding="0" width='100%'>
        <tr>
          <td width='10%' class='title'>일련번호</td>
          <td width="90%" colspan="2">&nbsp;<span class="ledger_cont"><%=ti_bean.getItem_id()%></span></td>
        </tr>
        <tr>
          <td class='title'>구분</td>
          <td width="45%" class='title'>변경전</td>
          <td width="45%" class='title'>변경후</td>
        </tr>
        <tr>
          <td class='title'>작성일자</td>
          <td align="center"><span class="ledger_contC">
            <input name="item_dt" type="text" class="whitetext" value="<%=AddUtil.ChangeDate2(ti_bean.getItem_dt())%>" size="40" readonly>
          </span></td>
          <td align="center"><span class="ledger_contC">
            <input name="item_dt" type="text" class="taxtext" value="<%=AddUtil.ChangeDate2(ti_bean.getItem_dt())%>" size="40" onBlur='javscript:this.value = ChangeDate(this.value);'>
          </span></td>
        </tr>
      </table></td>
    </tr>
    <tr>
      <td colspan="2">&nbsp;</td>
    </tr>
    <tr>
      <td colspan="2"><table width="100%" border="0" cellspacing="0" cellpadding="0">
        <tr align="center" bgcolor="#CCCCCC">
          <td rowspan="2" width="5%" style="border-top: #000000 1px solid; border-left: #000000 1px solid; border-bottom: #000000 1px solid">연번</td>
          <td rowspan="2" width="10%" style="border-top: #000000 1px solid; border-left: #000000 1px solid; border-bottom: #000000 1px solid">거래구분</td>
          <td rowspan="2" width="10%" style="border-top: #000000 1px solid; border-left: #000000 1px solid; border-bottom: #000000 1px solid">차량번호</td>
          <td width="18%" rowspan="2" bgcolor="#CCCCCC" style="border-top: #000000 1px solid; border-left: #000000 1px solid; border-bottom: #000000 1px solid">차명</td>
          <td height="20" colspan="2" style="border-top: #000000 1px solid; border-left: #000000 1px solid; border-bottom: #000000 1px solid">청구(거래)기준일</td>
          <td rowspan="2" width="10%" style="border-top: #000000 1px solid; border-left: #000000 1px solid; border-bottom: #000000 1px solid">공급가액</td>
          <td rowspan="2" width="10%" style="border-top: #000000 1px solid; border-left: #000000 1px solid; border-bottom: #000000 1px solid">세액</td>
          <td rowspan="2" width="10%" style="border-top: #000000 1px solid; border-left: #000000 1px solid; border-bottom: #000000 1px solid;">합계</td>
          <td rowspan="2" width="7%" style="border-top: #000000 1px solid; border-left: #000000 1px solid; border-bottom: #000000 1px solid; border-right: #000000 1px solid;">빼기</td>
        </tr>
        <tr>
          <td height="20" width="10%" bgcolor="#CCCCCC" align="center" style="border-left: #000000 1px solid; border-bottom: #000000 1px solid">~부터</td>
          <td height="20" width="10%" bgcolor="#CCCCCC" align="center" style="border-left: #000000 1px solid; border-bottom: #000000 1px solid">~까지</td>
        </tr>
        <% for(int i = 0 ; i < til_size ; i++){
										    TaxItemListBean til_bean = (TaxItemListBean)tils.elementAt(i);%>
		<input type='hidden' name="item_seq" value="<%=til_bean.getItem_seq()%>">											
        <tr align="center">
          <td height="22" style="border-left: #000000 1px solid; border-bottom: #000000 1px solid"><%=i+1%></td>
          <td height="22" style="border-left: #000000 1px solid; border-bottom: #000000 1px solid"><input type="text" name="item_g" size="10" value="<%=til_bean.getItem_g()%>" class="taxtext"></td>
          <td height="22" style="border-left: #000000 1px solid; border-bottom: #000000 1px solid"><input type="text" name="item_car_no" size="10" value="<%=til_bean.getItem_car_no()%>" class="taxtext"></td>
          <td height="22" style="border-left: #000000 1px solid; border-bottom: #000000 1px solid"><input type="text" name="item_car_nm" size="20" value="<%=til_bean.getItem_car_nm()%>" class="taxtext"></td>
          <td height="22" style="border-left: #000000 1px solid; border-bottom: #000000 1px solid"><input type="text" name="item_dt1" size="11" value="<%=AddUtil.ChangeDate2(til_bean.getItem_dt1())%>" class="taxtext" onBlur='javscript:this.value = ChangeDate(this.value);'></td>
          <td height="22" style="border-left: #000000 1px solid; border-bottom: #000000 1px solid"><input type="text" name="item_dt2" size="11" value="<%=AddUtil.ChangeDate2(til_bean.getItem_dt2())%>" class="taxtext" onBlur='javscript:this.value = ChangeDate(this.value);'></td>
          <td height="22" style="border-left: #000000 1px solid; border-bottom: #000000 1px solid"><input type="text" name="item_supply" size="10" value="<%=Util.parseDecimal(til_bean.getItem_supply())%>" class="taxnum" onBlur="javascript:this.value=parseDecimal(this.value); item_amt_set('s', <%=i%>);"></td>
          <td height="22" style="border-left: #000000 1px solid; border-bottom: #000000 1px solid"><input type="text" name="item_value" size="10" value="<%=Util.parseDecimal(til_bean.getItem_value())%>" class="taxnum" onBlur="javascript:this.value=parseDecimal(this.value); item_amt_set('v', <%=i%>);"></td>
          <td height="22" style="border-left: #000000 1px solid; border-bottom: #000000 1px solid;"><input type="text" name="item_amt" size="10" value="<%=Util.parseDecimal(til_bean.getItem_supply()+til_bean.getItem_value())%>" class="taxnum" onBlur="javascript:this.value=parseDecimal(this.value); item_amt_set('a', <%=i%>);"></td>
          <td height="22" style="border-left: #000000 1px solid; border-bottom: #000000 1px solid; border-right: #000000 1px solid">
		  <%if(til_size>1){%>
			    <select name='del_chk' onchange="javascript:del_chk_set(<%=i%>);">
		          <option value='N'>수정</option>
		          <option value='Y'>빼기</option>				  
		        </select>				  
		  <%}else{%>&nbsp;<%}%></td>
        </tr>
        <%  item_s_amt = item_s_amt  + Long.parseLong(String.valueOf(til_bean.getItem_supply()));
										    item_v_amt = item_v_amt  + Long.parseLong(String.valueOf(til_bean.getItem_value()));
									     }%>
        <tr>
          <td height="22" colspan="6" align="center" style="border-left: #000000 1px solid; border-bottom: #000000 1px solid" bgcolor="#CCCCCC"><font size="3"><b>합계
                  <!--(①)-->
          </b></font></td>
          <td height="22" style="border-left: #000000 1px solid; border-bottom: #000000 1px solid" align="center"><input type="text" name="t_item_supply" size="10" value="<%=Util.parseDecimal(item_s_amt)%>" class="taxnum" onBlur='javascript:this.value=parseDecimal(this.value)'></td>
          <td height="22" style="border-left: #000000 1px solid; border-bottom: #000000 1px solid" align="center"><input type="text" name="t_item_value" size="10" value="<%=Util.parseDecimal(item_v_amt)%>" class="taxnum" onBlur='javascript:this.value=parseDecimal(this.value)'></td>
          <td height="22" align="center" style="border-left: #000000 1px solid; border-bottom: #000000 1px solid;"><input type="text" name="t_item_amt" size="10" value="<%=Util.parseDecimal(item_s_amt+item_v_amt)%>" class="taxnum" onBlur='javascript:this.value=parseDecimal(this.value)'></td>
          <td height="22" align="center" style="border-left: #000000 1px solid; border-bottom: #000000 1px solid; border-right: #000000 1px solid">&nbsp;</td>
        </tr>
      </table></td>
    </tr>
	<%}%>	
    <tr>
      <td colspan="2">&nbsp;</td>
    </tr>
	<% 	if(!t_bean.getResseq().equals("")){%>
    <tr>
      <td colspan="2">* 트러스빌 취소후 재발급 적용 : 
      <input type="checkbox" name="ebill_yn" value="Y" checked></td>
    </tr>	
	<%}else{%>
	  <input type="hidden" name="ebill_yn" value="N">	
	<%}%>	
    <tr>
      <td colspan="2" align="right"><input type="button" name="b_upd" value="수정" onClick="javascript:tax_update();" class="btn"></td>
    </tr>
  </table>
<script language="JavaScript">
<!--
//-->
</script>  
</form>	
<iframe src="about:blank" name="i_no" width="0" height="0" frameborder="0" noresize></iframe>
</body>
</html>