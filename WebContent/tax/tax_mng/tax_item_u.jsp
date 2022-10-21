<%@ page language="java" contentType="text/html;charset=euc-kr" %>
<%@ page import="java.util.*, acar.util.*, acar.fee.*, acar.common.*, tax.*, acar.bill_mng.*, acar.client.*, cust.member.*"%>
<jsp:useBean id="IssueDb" scope="page" class="tax.IssueDatabase"/>
<jsp:useBean id="al_db" scope="page" class="acar.client.AddClientDatabase"/>
<jsp:useBean id="m_db" scope="page" class="cust.member.MemberDatabase"/>
<%@ include file="/tax/cookies_base.jsp" %>

<%
	
	
	
	String item_id 	= request.getParameter("item_id")==null?"":request.getParameter("item_id");
	String reg_code = "";
	long item_s_amt = 0;
	long item_v_amt = 0;
	int height = 0;
	
	//거래명세서 조회
	TaxItemBean ti_bean 	= IssueDb.getTaxItemCase(item_id);
	//거래명세서 리스트 조회
	Vector tils	            = IssueDb.getTaxItemScdListCase(item_id);
	int til_size            = tils.size();
	
	//거래처정보
	ClientBean client       = al_db.getClient(ti_bean.getClient_id().trim());
	//거래처지점정보
	ClientSiteBean site     = al_db.getClientSite(ti_bean.getClient_id(), ti_bean.getSeq());
	
	//고객FMS
	MemberBean m_bean = m_db.getMemberCase(ti_bean.getClient_id(), ti_bean.getSeq(), "");
	if(m_bean.getMember_id().equals("")) m_bean = m_db.getMemberCase(ti_bean.getClient_id(), "", "");
%>

<html>
<head>
<title>FMS</title>
<meta http-equiv="content-type" content="text/html; charset=euc-kr">
<link rel="stylesheet" type="text/css" href="/include/table_t.css">
<script language="JavaScript" src="/include/common.js"></script>
<script language="JavaScript">
<!--

	//고객 보기
	function view_client()
	{
		window.open("/fms2/client/client_c.jsp?auth_rw=<%=auth_rw%>&user_id=<%=user_id%>&br_id=<%=br_id%>&from_page=/tax/tax_mng/tax_mng_u_m.jsp&client_id=<%=client.getClient_id()%>", "CLIENT", "left=10, top=10, width=900, height=700, scrollbars=yes, status=yes, resizable=yes");
	}		
	

	//내용수정하기	
	function tax_update(){
		var fm = document.form1;
		
		if(confirm('수정 하시겠습니까?')){
			fm.action = 'tax_item_u_a.jsp';
			fm.target = 'i_no';
//			fm.target = 'TaxItem';
			fm.submit();
		}
	}
//-->
</script>
</head>
<body>
<form action="./issue_3_sc_a.jsp" name="form1" method="POST">
<%@ include file="/include/search_hidden.jsp" %>
  <input type="hidden" name="idx" value="<%=idx%>">
  <input type="hidden" name="item_id" value="<%=item_id%>">  
  <input type="hidden" name="item_size" value="<%=til_size%>">
  <input type="hidden" name="client_id" value="<%=ti_bean.getClient_id()%>">  
  <input type="hidden" name="seq" value="<%=ti_bean.getSeq()%>">    
  <input type="hidden" name="item_hap_num" value="">
<table width=100% border=0 cellpadding=0 cellspacing=0>
    <tr>
		<td colspan=10>
			<table width=100% border=0 cellpadding=0 cellspacing=0>
				<tr>
					<td width=7><img src=/acar/images/center/menu_bar_1.gif width=7 height=33></td>
					<td class=bar>&nbsp;&nbsp;&nbsp;<img src=/acar/images/center/menu_bar_dot.gif width=4 height=5 align=absmiddle>&nbsp;<span class=style1>재무회계 > 세금계산서발행 > <span class=style5>
						거래명세서 </span></span></td>
					<td width=7><img src=/acar/images/center/menu_bar_2.gif width=7 height=33></td>
				</tr>
			</table>
		</td>
	</tr>
	<tr>
		<td class=h></td>
	</tr>  	
    <tr>
		<td class=line2 colspan=2></td>
	</tr>  
    <tr>
        <td colspan="2" class="line">
            <table border="0" cellspacing="1" cellpadding="0" width='100%'>
                <tr>
                  <td width='10%' class='title'>상호</td>
                  <td width='40%' >&nbsp;
					<a href="javascript:view_client()"><%=client.getFirm_nm()%></a>
					&nbsp;</td>
                  <td width='10%' class='title'>지점/현장</td>
                  <td width='40%'  >&nbsp;<span title='<%=site.getR_site()%>'><%=Util.subData(site.getR_site(), 25)%></span></td>
                </tr>
            </table>
        </td>
    </tr>
    
    <tr>
        <td colspan="2">&nbsp;</td>
    </tr>	
    <tr>
      <td colspan="2" align="center">
		  <%if(!m_bean.getMember_id().equals("") && !m_bean.getMember_id().equals("amazoncar")){%>
		  <a href="https://fms.amazoncar.co.kr/service/tax_index.jsp?mode=1&client_id=<%=ti_bean.getClient_id()%>&r_site=<%=ti_bean.getSeq()%>&name=<%=m_bean.getMember_id()%>&passwd=<%=m_bean.getPwd()%>&s_yy=<%=ti_bean.getItem_dt().substring(0,4)%>&s_mm=<%=ti_bean.getItem_dt().substring(4,6)%>&gubun=tax_item" target="_blank" onFocus="this.blur();"><img src=/acar/images/center/button_e_cfms.gif align=absmiddle border=0></a>&nbsp;
		  <%}else{
		  		String ssn = "";
				if(client.getClient_st().equals("2")) 	ssn = client.getSsn1()+client.getSsn1();
				else 								 	ssn = client.getEnp_no1()+client.getEnp_no2()+client.getEnp_no3();%>
		  <% 	if ( !m_bean.getMember_id().equals("") ) {%> 
		  <a href="https://fms.amazoncar.co.kr/service/tax_index.jsp?mode=2&client_id=<%=ti_bean.getClient_id()%>&r_site=<%=ti_bean.getSeq()%>&ssn=<%=ssn%>&s_yy=<%=ti_bean.getItem_dt().substring(0,4)%>&s_mm=<%=ti_bean.getItem_dt().substring(4,6)%>&gubun=tax_item" target="_blank" onFocus="this.blur();"><img src=/acar/images/center/button_e_cfms.gif align=absmiddle border=0></a>&nbsp; 
		  <% 	} %> 
		  <%}%>
		  <%if(!ti_bean.getTax_est_dt().equals("")){%>
		  <a href="http://fms1.amazoncar.co.kr/mailing/tax_bill/bill_doc_simple.jsp?gubun=2&client_id=<%=ti_bean.getClient_id()%>&site_id=<%=ti_bean.getSeq()%>&item_id=<%=item_id%>" target="_blank" onFocus="this.blur();"><img src=/acar/images/center/button_e_email.gif align=absmiddle border=0></a>
		  <%}%>
	  </td>
    </tr>			
    <tr>
        <td colspan="2">&nbsp;</td>
    </tr>
    <tr>
        <td colspan="2"><img src=/acar/images/center/icon_arrow.gif align=absmiddle> <span class=style2>거래명세서</span></td>
    </tr>
    <tr>
		<td class=line2 colspan=2></td>
	</tr>  	
    <tr>
        <td colspan="2" class="line">
            <table border="0" cellspacing="1" cellpadding="0" width='100%'>
                <tr>
                  <td width='20%' class='title'>일련번호</td>
                  <td width="80%">&nbsp;<span class="ledger_cont"><%=ti_bean.getItem_id()%></span></td>
                </tr>
                <tr>
                  <td width='20%' class='title'>청구금액</td>
                  <td width="80%">&nbsp;<span class="ledger_cont"><%=Util.parseDecimal(ti_bean.getItem_hap_num())%>원</span></td>
                </tr>				
                <tr>
                  <td class='title'>거래명세서일자</td>
                  <td>&nbsp;<input name="item_dt" type="text" class="taxtext" value="<%=AddUtil.ChangeDate2(ti_bean.getItem_dt())%>" size="11" onBlur='javscript:this.value = ChangeDate(this.value);'></td>
                </tr>			
                <tr>
                  <td class='title'>담당자</td>
                  <td>&nbsp;<input name="item_man" type="text" class="taxtext" value="<%=ti_bean.getItem_man()%>" size="11"></td>
                </tr>							
            </table>
        </td>
    </tr>
    <tr>
        <td colspan="2">&nbsp;</td>
    </tr>
    <tr>
        <td colspan="2" align="right"><a href="javascript:tax_update();"><img src=/acar/images/center/button_modify.gif align=absmiddle border=0></a></td>
    </tr>
    <tr>
        <td colspan="2">&nbsp;</td>
    </tr>
</table>
<script language="JavaScript">
<!--
//-->
</script>  
<input type="hidden" name="reg_code" value="<%=reg_code%>">
</form>	
<iframe src="about:blank" name="i_no" width="0" height="0" frameborder="0" noresize></iframe>
</body>
</html>