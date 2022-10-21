<%@ page language="java" contentType="text/html;charset=euc-kr" %>
<%@ page import="java.util.*, acar.util.*, acar.fee.*, tax.*, acar.bill_mng.*, acar.client.*"%>
<jsp:useBean id="IssueDb" scope="page" class="tax.IssueDatabase"/>
<jsp:useBean id="al_db" scope="page" class="acar.client.AddClientDatabase"/>
<%@ include file="/tax/cookies_base.jsp" %>

<%
	
	
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
	tax.TaxBean t_bean 			= IssueDb.getTax(tax_no);
	//거래명세서 조회
	TaxItemBean ti_bean 		= IssueDb.getTaxItemCase(t_bean.getItem_id());
	//거래명세서 리스트 조회
	Vector tils	            = IssueDb.getTaxItemListCase(t_bean.getItem_id());
	int til_size            = tils.size();
	//거래처정보
	ClientBean client       = al_db.getClient(ti_bean.getClient_id());
	//거래처지점정보
	ClientSiteBean site     = al_db.getClientSite(ti_bean.getClient_id(), ti_bean.getSeq());
	
	String tax_supply = String.valueOf(t_bean.getTax_supply());
	String tax_value = String.valueOf(t_bean.getTax_value());
	String i_enp_no = client.getEnp_no1() +"-"+ client.getEnp_no2() +"-"+ client.getEnp_no3();
	if(client.getEnp_no1().equals("")) i_enp_no = client.getSsn1() +"-"+ client.getSsn2();
	String i_firm_nm = client.getFirm_nm();
	String i_client_nm = client.getClient_nm();
	String i_addr = client.getO_addr();
	String i_sta = client.getBus_cdt();
	String i_item = client.getBus_itm();
%>

<html>
<head>
<title>FMS</title>
<meta http-equiv="content-type" content="text/html; charset=euc-kr">
<link rel="stylesheet" type="text/css" href="../../include/table.css">
<script language="JavaScript" src="/include/common.js"></script>
<script language="JavaScript">
<!--
	//발행취소
	function tax_cancel(){
		var fm = document.form1;	
		if(fm.tax_no.value == ''){		alert('선택된 세금계산서가 없습니다.'); return; }		
		if(fm.cng_cau.value == ''){		alert('취소사유를 입력하십시오.'); return; }		

		if(confirm('발행취소 하시겠습니까?'))
		{			
			fm.target = "i_no";
			fm.action = "tax_cancel_a.jsp";
			fm.submit();						
		}
	}	
//-->
</script>
<style type="text/css">
<!--
.style1 {color: #FF0000}
-->
</style>
</head>
<body onLoad="javascript:document.form1.cng_cau.focus();">
<form action="" name="form1" method="POST">
<%@ include file="/include/search_hidden.jsp" %>
  <input type="hidden" name="idx" value="<%=idx%>">
  <input type="hidden" name="tax_no" value="<%=tax_no%>">
  <input type="hidden" name="client_id" value="<%=client_id%>">
  <input type="hidden" name="site_id" value="<%=site_id%>">  
  <input type="hidden" name="rent_mng_id" value="<%=rent_mng_id%>">
  <input type="hidden" name="rent_l_cd" value="<%=rent_l_cd%>">
  <input type="hidden" name="car_mng_id" value="<%=car_mng_id%>">
  <input type="hidden" name="mode" value="<%=mode%>">
  <table width=100% border=0 cellpadding=0 cellspacing=0>
    <tr> 
      <td colspan="2"><font color="navy">세금계산서보관함 -&gt;  </font><span class="style1">세금계산서 발행취소 </span></td>
    </tr>
    <tr>
      <td colspan="2" class='line'>
        <table border="0" cellspacing="1" cellpadding="0" width='100%'>
          <tr>
            <td width='15%' class='title'>일련번호</td>
            <td width="20%">&nbsp;<span class="ledger_cont"><%=t_bean.getTax_no()%></span>&nbsp;</td>
            <td width="15%" class='title'>공급받는자</td>
            <td width="50%">&nbsp;<span class="ledger_cont"><%=i_firm_nm%></span></td>
          </tr>
          <tr>
            <td class='title'>세금일자</td>
            <td>&nbsp;<span class="ledger_cont"><%=AddUtil.ChangeDate2(t_bean.getTax_dt())%></span></td>
            <td class='title'>품목</td>
            <td>&nbsp;
              <%if(AddUtil.parseInt(t_bean.getReg_dt()) >= 20100929 && t_bean.getGubun().equals("1") && !t_bean.getFee_tm().equals("")){%>
			  <%=t_bean.getFee_tm()%>회차
			  <%}%>			
			  <%=t_bean.getTax_g()%></td>
          </tr>
          <tr>
            <td class='title'>공급가</td>
            <td>&nbsp;<%=Util.parseDecimal(t_bean.getTax_supply())%></td>
            <td class='title'>부가세</td>
            <td>&nbsp;<%=Util.parseDecimal(t_bean.getTax_value())%></td>
          </tr>
          <tr>
            <td class='title'>합계</td>
            <td>&nbsp;<%=Util.parseDecimal(t_bean.getTax_supply()+t_bean.getTax_value())%></td>
            <td class='title'>비고</td>
            <td>&nbsp;<%=t_bean.getTax_bigo()%></td>
          </tr>
          <tr>
            <td class='title'>취소사유</td>
            <td colspan="3"><textarea name="cng_cau" cols="50" rows="3"></textarea></td>
          </tr>
          <tr>
            <td class='title'>처리구분</td>
            <td colspan="3"><input type="checkbox" name="cng_st" value="Y" checked>트러스빌연동</td>
          </tr>
        </table>
      </td>
    </tr>  
    <tr>
      <td colspan="2">&nbsp;</td>
    </tr>
    <tr>
      <td width="15%">&nbsp;</td>
      <td align="right"><input type="button" name="b_ms2" value="확인" onClick="javascript:tax_cancel();" class="btn"></td>
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
