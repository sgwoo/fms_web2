<%@ page language="java" contentType="text/html;charset=euc-kr"%>
<%@ page import="java.util.*, acar.util.*"%>
<%@ include file="/tax/cookies_base.jsp" %>

<html>
<head><title>FMS</title>
<script language='JavaScript' src='/include/common.js'></script>
<script language='javascript'>
<!--
	function view_tax(tax_no, idx){
		var fm = document.form1;
		fm.tax_no.value = tax_no;
		fm.idx.value = idx;
		fm.action = "tax_mng_c.jsp";
		fm.target = "d_content";		
		fm.submit();
	}
	
	function  viewTaxInvoice(pubCode){
		var iMyHeight;
		width = (window.screen.width-635)/2
		if(width<0)width=0;
		iMyWidth = width; 
		height = 0;
		if(height<0)height=0;
		iMyHeight = height;
		var taxInvoice = window.open("about:blank", "taxInvoice", "resizable=no,  scrollbars=no, left=" + iMyWidth + ",top=" + iMyHeight + ",screenX=" + iMyWidth + ",screenY=" + iMyHeight + ",width=680px, height=760px");
		document.form1.action="https://www.trusbill.or.kr/jsp/directTax/TaxViewIndex.jsp";
		document.form1.method="post";
		document.form1.pubCode.value=pubCode;
		document.form1.docType.value="T"; //세금계산서
		document.form1.userType.value="S"; // S=보내는쪽 처리화면, R= 받는쪽 처리화면
		document.form1.target="taxInvoice";
		document.form1.submit();
		document.form1.target="_self";
		document.form1.pubCode.value="";
		taxInvoice.focus();
		return;
	}
	
	function  viewTaxInvoice2(pubCode){
		var iMyHeight;
		width = (window.screen.width-635)/2
		if(width<0)width=0;
		iMyWidth = width; 
		height = 0;
		if(height<0)height=0;
		iMyHeight = height;
		var taxInvoice = window.open("about:blank", "taxInvoice", "resizable=no,  scrollbars=no, left=" + iMyWidth + ",top=" + iMyHeight + ",screenX=" + iMyWidth + ",screenY=" + iMyHeight + ",width=680px, height=760px");
		document.form1.action="https://www.trusbill.or.kr/jsp/directTax/TaxViewIndex.jsp";
		document.form1.method="post";
		document.form1.pubCode.value=pubCode;
		document.form1.docType.value="T"; //세금계산서
		document.form1.userType.value="R"; // S=보내는쪽 처리화면, R= 받는쪽 처리화면
		document.form1.target="taxInvoice";
		document.form1.submit();
		document.form1.target="_self";
		document.form1.pubCode.value="";
		taxInvoice.focus();
		return;
	}
	
	function  SaleEBill(ebill_st, tax_no){
		var taxInvoice = window.open("about:blank", "SaleEBill", "resizable=no,  scrollbars=yes, status=yes, left=50,top=20, width=750px, height=700px");
		document.form1.action="saleebill_reg.jsp";
		document.form1.method="post";
		document.form1.tax_no.value=tax_no;
		document.form1.ebill_st.value=ebill_st;		
		document.form1.target="SaleEBill";
		document.form1.submit();
		document.form1.target="_self";
		document.form1.tax_no.value="";
		document.form1.ebill_st.value="";
	}	
	
	function autodocu_reg(tax_no, idx){
		var fm = document.form1;
		if(confirm('자동전표를 생성하겠습니까?'))
		{					
			fm.tax_no.value = tax_no;
			fm.idx.value = idx;
			fm.action = "tax_autodocu.jsp";
			fm.target = "i_no";
			//fm.target = "_blank";
			fm.submit();
		}
	}
	//승인요청 문자 일괄 보내기
	function SandSms(){
		var fm = document.form1;
		if(confirm('문자를 보내시겠습니까?'))
		{			
			fm.msg.value = inner.document.form1.msg.value;
			fm.action = "tax_mng_sc_sms.jsp";
			fm.target = "i_no";		
//			fm.target = "d_content";
			fm.submit();	
		}
	}
	
	//사업장등록증이력
	function cl_enp_h(rent_l_cd, client_id, firm_nm)
	{
		var fm = document.form1;
		fm.rent_l_cd.value = rent_l_cd;		
		fm.client_id.value = client_id;
		fm.firm_nm.value = firm_nm;
		window.open("about:blank", "CLIENT_ENP", "left=50, top=50, width=1000, height=600, scrollbars=yes");				
		fm.action = "/acar/mng_client2/client_enp_p.jsp";
		fm.target = "CLIENT_ENP";
		fm.submit();
	}	
	
	
//-->
</script>
<meta http-equiv="content-type" content="text/html; charset=euc-kr">
<link rel=stylesheet type="text/css" href="/include/table_t.css">
</head>
<body>
<%
	int cnt = 3; //현황 출력 영업소 총수
	int height = AddUtil.parseInt(s_height)-emp_top_height-sh_height-(cnt*25)-200;//현황 라인수만큼 제한 아이프레임 사이즈
%>
<form name='form1' action='tax_mng_c.jsp' method='post' target='d_content'>
<%@ include file="/include/search_hidden.jsp" %>
<input type='hidden' name='tax_no' value=''>
<input type='hidden' name='idx' value='<%=idx%>'>
<input type='hidden' name="pubCode" value="">
<input type='hidden' name="docType" value="">
<input type='hidden' name="userType" value="">
<input type='hidden' name="ebill_st" value="">
<input type='hidden' name="msg" value="">
<input type='hidden' name="rent_l_cd" value="">
<input type='hidden' name="client_id" value="">
<input type='hidden' name="firm_nm" value="">
<input type='hidden' name="from_page" value="/tax/tax_mng/tax_mng_sc.jsp">

  <table border="0" cellspacing="0" cellpadding="0" width=100%>
    <tr> 
      <td height="<%=height%>"><iframe src="tax_mng_sc_in.jsp<%=hidden_value%>" name="inner" width="100%" height="<%=height%>" cellpadding="0" cellspacing="0" border="0" frameborder="0" noresize scrolling=yes, marginwidth=0, marginheight=0 > 
        </iframe> </td><!--모니터높이 - sh 길이 - 상단메뉴 길이 - (라인수*40)-->
    </tr>    
</table>
</form>
<iframe src="about:blank" name="i_no" width="0" height="0" frameborder="0" noresize></iframe>
</body>
</html>
