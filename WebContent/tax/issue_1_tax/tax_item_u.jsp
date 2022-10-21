<%@ page language="java" contentType="text/html;charset=euc-kr" %>
<%@ page import="java.util.*, acar.util.*, tax.*, acar.client.*, cust.member.*, acar.user_mng.*"%>
<jsp:useBean id="ScdMngDb" scope="page" class="tax.ScdMngDatabase"/>
<jsp:useBean id="IssueDb" scope="page" class="tax.IssueDatabase"/>
<jsp:useBean id="al_db" scope="page" class="acar.client.AddClientDatabase"/>
<jsp:useBean id="m_db" scope="page" class="cust.member.MemberDatabase"/>
<%@ include file="/tax/cookies_base.jsp" %>

<%	
	MaMenuDatabase nm_db = MaMenuDatabase.getInstance();

	String item_id 	= request.getParameter("item_id")==null?"":request.getParameter("item_id");
	String reg_code = "";
	long item_s_amt = 0;
	long item_v_amt = 0;
	int height = 0;
	
	//거래명세서 조회
	TaxItemBean ti_bean 		= IssueDb.getTaxItemCase(item_id);
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
	
	//세금계산서 조회
	tax.TaxBean t_bean 		= IssueDb.getTax_itemId(item_id);
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
	
	//고객 보기
	function view_client_site()
	{
		window.open("/acar/mng_client2/client_site_i_p.jsp?auth_rw=<%=auth_rw%>&user_id=<%=user_id%>&br_id=<%=br_id%>&from_page=/tax/tax_mng/tax_mng_u_m.jsp&client_id=<%=client.getClient_id()%>&site_id=<%=ti_bean.getSeq()%>", "CLIENT", "left=10, top=10, width=900, height=700, scrollbars=yes, status=yes, resizable=yes");
	}		
	

	
	
	//거래명세서 금액셋팅
	function set_amt(idx){
		
		var fm = document.form1;		
			
		fm.item_value[idx].value 	= parseDecimal(toInt(parseDigit(fm.item_supply[idx].value)) * 0.1 );
		fm.item_amt[idx].value 		= parseDecimal(toInt(parseDigit(fm.item_supply[idx].value)) + toInt(parseDigit(fm.item_value[idx].value)));			
		
		fm.t_item_supply.value = 0;
		fm.t_item_value.value = 0;
		fm.t_item_amt.value = 0;	
		
		//거래명세서 합계 계산
		for(i=0; i<idx+1; i++){			
			fm.t_item_supply.value	= parseDecimal(toInt(parseDigit(fm.t_item_supply.value)) + toInt(parseDigit(fm.item_supply[i].value)));			
			fm.t_item_value.value 	= parseDecimal(toInt(parseDigit(fm.t_item_value.value)) + toInt(parseDigit(fm.item_value[i].value)));			
		}			
		fm.t_item_amt.value 		= parseDecimal(toInt(parseDigit(fm.t_item_supply.value)) + toInt(parseDigit(fm.t_item_value.value)));				
	}	
	
	
	<%if(!ti_bean.getItem_id().equals("")){%>	
	//거래명세서 리스트 수정시
	function item_amt_set(obj, idx){
		var fm = document.form1;
		var size = toInt(fm.item_size.value)+1;

		fm.t_item_supply.value = 0;
		fm.t_item_value.value = 0;		
		if(obj == 's'){
			//fm.item_value[idx].value= parseDecimal(toInt(parseDigit(fm.item_supply[idx].value)) * 0.1 );
			fm.item_amt[idx].value 	= parseDecimal(toInt(parseDigit(fm.item_supply[idx].value)) + toInt(parseDigit(fm.item_value[idx].value)));			
		}			
		if(obj == 'v'){
			fm.item_amt[idx].value 	= parseDecimal(toInt(parseDigit(fm.item_supply[idx].value)) + toInt(parseDigit(fm.item_value[idx].value)));			
		}
		if(obj == 'a'){
		}
			
		//거래명세서 합계 계산
		for(i=0; i<size; i++){			
			fm.t_item_supply.value	= parseDecimal(toInt(parseDigit(fm.t_item_supply.value)) + toInt(parseDigit(fm.item_supply[i].value)));			
			fm.t_item_value.value 	= parseDecimal(toInt(parseDigit(fm.t_item_value.value)) + toInt(parseDigit(fm.item_value[i].value)));			
		}
		fm.t_item_amt.value 		= parseDecimal(toInt(parseDigit(fm.t_item_supply.value)) + toInt(parseDigit(fm.t_item_value.value)));		
	}
		
	//거래명세서에서 빼기
	function del_chk_set(idx){
		var fm = document.form1;
		var size = toInt(fm.item_size.value)+1;
		//거래명세서 합계 계산
		for(i=0; i<size; i++){
			if(i== idx && fm.del_chk[idx].value == "Y"){
				fm.t_item_supply.value	= parseDecimal(toInt(parseDigit(fm.t_item_supply.value)) - toInt(parseDigit(fm.item_supply[i].value)));			
				fm.t_item_value.value 	= parseDecimal(toInt(parseDigit(fm.t_item_value.value)) - toInt(parseDigit(fm.item_value[i].value)));			
			}else if(i== idx && fm.del_chk[idx].value == "N"){
				fm.t_item_supply.value	= parseDecimal(toInt(parseDigit(fm.t_item_supply.value)) + toInt(parseDigit(fm.item_supply[i].value)));			
				fm.t_item_value.value 	= parseDecimal(toInt(parseDigit(fm.t_item_value.value)) + toInt(parseDigit(fm.item_value[i].value)));						
			}else if(i== idx && fm.del_chk[idx].value == "A"){
				fm.t_item_supply.value	= parseDecimal(toInt(parseDigit(fm.t_item_supply.value)) + toInt(parseDigit(fm.item_supply[i].value)));			
				fm.t_item_value.value 	= parseDecimal(toInt(parseDigit(fm.t_item_value.value)) + toInt(parseDigit(fm.item_value[i].value)));						
			}
		}
		fm.t_item_amt.value 		= parseDecimal(toInt(parseDigit(fm.t_item_supply.value)) + toInt(parseDigit(fm.t_item_value.value)));
	}
	<%}%>
	
	//내용수정하기	
	function tax_update(){
		var fm = document.form1;
		
		<%if(!ti_bean.getItem_id().equals("")){%>
		fm.item_hap_num.value = parseDigit(fm.t_item_amt.value);
		<%}%>
		
		if(confirm('수정 하시겠습니까?')){
			fm.action = 'tax_item_u_a.jsp';
			fm.target = 'i_no';
			fm.submit();
		}
	}
		
	//삭제하기
	function tax_delete(){
		var fm = document.form1;		
		
		if(!confirm('거래명세서를 삭제 하시겠습니까?'))		{	return; }
		if(!confirm('다시 확인합니다. 삭제 하시겠습니까?'))	{	return; }
		if(!confirm('정말로 삭제 하시겠습니까?'))			{	return; }
		
		if(confirm('진짜로 삭제 하시겠습니까?')){
			fm.action = 'tax_item_d_a.jsp';
			fm.target = 'i_no';
			fm.submit();		
		}		
	}	
	
	function Remail(){
		var fm = document.form1;		
				
		if(confirm('메일을 재발행 하시겠습니까?')){
			fm.action = 'tax_item_remail.jsp';
			fm.target = 'TaxItem';
			fm.submit();		
		}			
	}
	
	
	function item_search(item_seq){
		var fm = document.form1;
		var t_wd = '<%=client.getFirm_nm()%>';
		window.open("tax_item_list_search.jsp?client_id="+fm.client_id.value+"&seq="+fm.seq.value+"&idx="+item_seq+"&t_wd="+t_wd, "ITEM_LIST", "left=50, top=50, width=1150, height=550, scrollbars=yes");		
	}
	
	function goClientFms(mode, client_id, r_site, name, passwd, s_yy, s_mm, gubun){
		var fm = document.form2;
		fm.mode.value = mode;
		fm.clientId.value = client_id;
		fm.rSite.value = r_site;
		fm.memberId.value = name;
		fm.pwd.value = passwd;
		fm.sYy.value = s_yy;
		fm.sMm.value = s_mm;
		fm.classification.value = gubun;
		
		var url="https://client.amazoncar.co.kr/control/fromFms";
		window.open('', 'popForm');
		fm.action = url;
		fm.method = 'POST';
		fm.target = 'popForm';
		fm.submit();
	}
	
	function goClientFms2(mode, client_id, r_site, ssn, s_yy, s_mm, gubun){
		var fm = document.form2;
		fm.mode.value = mode;
		fm.clientId.value = client_id;
		fm.rSite.value = r_site;
		fm.ssn.value = ssn;
		fm.sYy.value = s_yy;
		fm.sMm.value = s_mm;
		fm.classification.value = gubun;
		
		var url="https://client.amazoncar.co.kr/control/fromFms";
		window.open('', 'popForm');
		fm.action = url;
		fm.method = 'POST';
		fm.target = 'popForm';
		fm.submit();
	}
//-->
</script>
</head>
<body>
<form name='form2' method='POST'>
	<input type='hidden' name='mode' value=''>
	<input type='hidden' name='clientId' value=''>
	<input type='hidden' name='rSite' value=''>
	<input type='hidden' name='memberId' value=''>
	<input type='hidden' name='pwd' value=''>
	<input type='hidden' name='sYy' value=''>
	<input type='hidden' name='sMm' value=''>
	<input type='hidden' name='ssn' value=''>
	<input type='hidden' name='classification' value=''>
</form>
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
                  <td width='40%'  >&nbsp;<a href="javascript:view_client_site()"><span title='<%=site.getR_site()%>'><%=Util.subData(site.getR_site(), 25)%></span></a></td>
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
		  <%-- <a href="https://fms.amazoncar.co.kr/service/tax_index.jsp?mode=1&client_id=<%=ti_bean.getClient_id()%>&r_site=<%=ti_bean.getSeq()%>&name=<%=m_bean.getMember_id()%>&passwd=<%=m_bean.getPwd()%>&s_yy=<%=ti_bean.getItem_dt().substring(0,4)%>&s_mm=<%=ti_bean.getItem_dt().substring(4,6)%>&gubun=tax_item" target="_blank" onFocus="this.blur();"><img src=/acar/images/center/button_e_cfms.gif align=absmiddle border=0></a>&nbsp; --%>
		  <a href="javascript:goClientFms('1', '<%=ti_bean.getClient_id()%>', '<%=ti_bean.getSeq()%>', '<%=m_bean.getMember_id()%>', '<%=m_bean.getPwd()%>', '<%=ti_bean.getItem_dt().substring(0,4)%>', '<%=ti_bean.getItem_dt().substring(4,6)%>', 'tax_item')" ><img src=/acar/images/center/button_e_cfms.gif align=absmiddle border=0></a>&nbsp;
		  <%}else{
		  		String ssn = "";
				if(client.getClient_st().equals("2")) 	ssn = client.getSsn1()+client.getSsn1();
				else 								 	ssn = client.getEnp_no1()+client.getEnp_no2()+client.getEnp_no3();%>
		  <% 	if ( !m_bean.getMember_id().equals("") ) {%> 
		  <%-- <a href="https://fms.amazoncar.co.kr/service/tax_index.jsp?mode=2&client_id=<%=ti_bean.getClient_id()%>&r_site=<%=ti_bean.getSeq()%>&ssn=<%=ssn%>&s_yy=<%=ti_bean.getItem_dt().substring(0,4)%>&s_mm=<%=ti_bean.getItem_dt().substring(4,6)%>&gubun=tax_item" target="_blank" onFocus="this.blur();"><img src=/acar/images/center/button_e_cfms.gif align=absmiddle border=0></a>&nbsp; --%>
		   <%-- <a href="https://fms.amazoncar.co.kr/service/tax_index.jsp?mode=2&client_id=<%=ti_bean.getClient_id()%>&r_site=<%=ti_bean.getSeq()%>&ssn=<%=ssn%>&s_yy=<%=ti_bean.getItem_dt().substring(0,4)%>&s_mm=<%=ti_bean.getItem_dt().substring(4,6)%>&gubun=tax_item" target="_blank" onFocus="this.blur();"><img src=/acar/images/center/button_e_cfms.gif align=absmiddle border=0></a>&nbsp; --%>
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
	<%if(!ti_bean.getItem_id().equals("")){%>
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
                  <td class='title'>거래명세서일자</td>
                  <td>&nbsp;<input name="item_dt" type="text" class="taxtext" value="<%=AddUtil.ChangeDate2(ti_bean.getItem_dt())%>" size="11" onBlur='javscript:this.value = ChangeDate(this.value);'></td>
                </tr>			
                <tr>
                  <td class='title'>계산서(예정)일자</td>
                  <td>&nbsp;<input name="tax_est_dt" type="text" class="taxtext" value="<%=AddUtil.ChangeDate2(ti_bean.getTax_est_dt())%>" size="11" onBlur='javscript:this.value = ChangeDate(this.value);'></td>
                </tr>							
                <tr>
                  <td class='title'>담당자</td>
                  <td>&nbsp;<input name="item_man" type="text" class="taxtext" value="<%=ti_bean.getItem_man()%>" size="11"></td>
                </tr>		
                 <tr>
                  <td class='title'>비고</td>
                  <td>&nbsp;<textarea name="tax_item_etc" rows="6" cols="90"><%=ti_bean.getTax_item_etc()%></textarea></td>
                </tr>							
            </table>
        </td>
    </tr>
    <tr>
        <td colspan="2">&nbsp;</td>
    </tr>
    <tr>
        <td colspan="2">
            <table width="100%" border="0" cellspacing="0" cellpadding="0">
                <tr align="center" bgcolor="#CCCCCC">
                  <td rowspan="2" width="3%" style="border-top: #000000 1px solid; border-left: #000000 1px solid; border-bottom: #000000 1px solid">연번</td>
                  <td rowspan="2" width="9%" style="border-top: #000000 1px solid; border-left: #000000 1px solid; border-bottom: #000000 1px solid">실입금예정일</td>				  
                  <td rowspan="2" width="10%" style="border-top: #000000 1px solid; border-left: #000000 1px solid; border-bottom: #000000 1px solid">거래구분</td>
                  <td rowspan="2" width="10%" style="border-top: #000000 1px solid; border-left: #000000 1px solid; border-bottom: #000000 1px solid">차량번호</td>
                  <td rowspan="2" width="11%" bgcolor="#CCCCCC" style="border-top: #000000 1px solid; border-left: #000000 1px solid; border-bottom: #000000 1px solid">차명</td>
                  <td height="20" colspan="2" style="border-top: #000000 1px solid; border-left: #000000 1px solid; border-bottom: #000000 1px solid">청구(거래)기준일</td>
                  <td rowspan="2" width="10%" style="border-top: #000000 1px solid; border-left: #000000 1px solid; border-bottom: #000000 1px solid">공급가액</td>
                  <td rowspan="2" width="10%" style="border-top: #000000 1px solid; border-left: #000000 1px solid; border-bottom: #000000 1px solid">세액</td>
                  <td rowspan="2" width="10%" style="border-top: #000000 1px solid; border-left: #000000 1px solid; border-bottom: #000000 1px solid;">합계</td>
                  <td rowspan="2" width="6%" style="border-top: #000000 1px solid; border-left: #000000 1px solid; border-bottom: #000000 1px solid;" >빼기</td>
                  <td rowspan="2" width="3%" style="border-top: #000000 1px solid; border-left: #000000 1px solid; border-bottom: #000000 1px solid; border-right: #000000 1px solid;">bill_yn</td>				  
                </tr>
                <tr>
                  <td height="20" width="9%" bgcolor="#CCCCCC" align="center" style="border-left: #000000 1px solid; border-bottom: #000000 1px solid">~부터</td>
                  <td height="20" width="9%" bgcolor="#CCCCCC" align="center" style="border-left: #000000 1px solid; border-bottom: #000000 1px solid">~까지</td>
                </tr>
                <% for(int i = 0 ; i < til_size ; i++){
        			    TaxItemListBean til_bean = (TaxItemListBean)tils.elementAt(i);
						reg_code = til_bean.getReg_code();%>
        		<input type='hidden' name="item_seq" value="<%=til_bean.getItem_seq()%>">
                <tr align="center">
                  <td height="22" style="border-left: #000000 1px solid; border-bottom: #000000 1px solid" rowspan='2'><%=i+1%></td>
                  <td height="22" style="border-left: #000000 1px solid; border-bottom: #000000 1px solid" rowspan='2'><%=til_bean.getR_fee_est_dt()%></td>				  
                  <td height="22" style="border-left: #000000 1px solid; border-bottom: #000000 1px solid"><input type="text" name="item_g" size="10" value="<%=til_bean.getItem_g()%>" class="taxtext"></td>
                  <td height="22" style="border-left: #000000 1px solid; border-bottom: #000000 1px solid"><input type="text" name="item_car_no" size="13" value="<%=til_bean.getItem_car_no()%>" class="taxtext"></td>
                  <td height="22" style="border-left: #000000 1px solid; border-bottom: #000000 1px solid"><input type="text" name="item_car_nm" size="15" value="<%=til_bean.getItem_car_nm()%>" class="taxtext"></td>
                  <td height="22" style="border-left: #000000 1px solid; border-bottom: #000000 1px solid"><input type="text" name="item_dt1" size="11" value="<%=AddUtil.ChangeDate2(til_bean.getItem_dt1())%>" class="taxtext" onBlur='javscript:this.value = ChangeDate(this.value);'></td>
                  <td height="22" style="border-left: #000000 1px solid; border-bottom: #000000 1px solid"><input type="text" name="item_dt2" size="11" value="<%=AddUtil.ChangeDate2(til_bean.getItem_dt2())%>" class="taxtext" onBlur='javscript:this.value = ChangeDate(this.value);'></td>
                  <td height="22" style="border-left: #000000 1px solid; border-bottom: #000000 1px solid"><input type="text" name="item_supply" size="10" value="<%=Util.parseDecimal(til_bean.getItem_supply())%>" class="taxnum" onBlur="javascript:this.value=parseDecimal(this.value); item_amt_set('s', <%=i%>);"></td>
                  <td height="22" style="border-left: #000000 1px solid; border-bottom: #000000 1px solid"><input type="text" name="item_value" size="10" value="<%=Util.parseDecimal(til_bean.getItem_value())%>" class="taxnum" onBlur="javascript:this.value=parseDecimal(this.value); item_amt_set('v', <%=i%>);"></td>
                  <td height="22" style="border-left: #000000 1px solid; border-bottom: #000000 1px solid;"><input type="text" name="item_amt" size="10" value="<%=Util.parseDecimal(til_bean.getItem_supply()+til_bean.getItem_value())%>" class="taxnum" onBlur="javascript:this.value=parseDecimal(this.value); item_amt_set('a', <%=i%>);"></td>
                  <td height="22" style="border-left: #000000 1px solid; border-bottom: #000000 1px solid;">
        		  <%if(til_size>1){%>
        			    <select name='del_chk' onchange="javascript:del_chk_set(<%=i%>);">
        		          <option value='N'>-</option>
        		          <option value='Y'>빼기</option>				  
        		        </select>				  
        		  <%}else{%>&nbsp;
        		      <select name='del_chk'>
        		          <option value='N'>-</option>        		        			  
        		        </select>   		  
        		         		  
        		  <%}%></td>
                  <td height="22" style="border-left: #000000 1px solid; border-bottom: #000000 1px solid; border-right: #000000 1px solid"><%=til_bean.getBill_yn()%>&nbsp;</td>				  				  
                </tr>
                <tr>
                	<td colspan='8' height="22" style="border-left: #000000 1px solid; border-bottom: #000000 1px solid">
                		&nbsp;&nbsp;<input type="text" name="item_etc" size="100" value="<%=til_bean.getEtc()%>" class="taxtext"></td>
                	<td colspan='2' height="22" style="border-left: #000000 1px solid; border-bottom: #000000 1px solid;">&nbsp;</td>
                </tr>
                <%  		item_s_amt = item_s_amt  + Long.parseLong(String.valueOf(til_bean.getItem_supply()));
        								item_v_amt = item_v_amt  + Long.parseLong(String.valueOf(til_bean.getItem_value()));
        		 }%>
				 <input type='hidden' name="item_seq" value="<%=til_size+1%>">
				 <input type='hidden' name="rent_l_cd" value="">
				 <input type='hidden' name="car_mng_id" value="">
				 <input type='hidden' name="tm" value="">
				 <input type='hidden' name="rent_st" value="">				 				 
				 <input type='hidden' name="rent_seq" value="">				 				 				 
				 <input type='hidden' name="gubun" value="">
				 <input type='hidden' name="car_use" value="">
				 <input type='hidden' name="item_etc" value="">
				<%if(nm_db.getWorkAuthUser("전산팀",ck_acar_id) || nm_db.getWorkAuthUser("세금계산서담당자",ck_acar_id) || nm_db.getWorkAuthUser("스케줄변경담당자",ck_acar_id)){%>	 
		        <tr align="center"><!--id=h_tr style="display:none"-->
		          <td height="22" align="center" style="border-left: #000000 1px solid; border-bottom: #000000 1px solid"><%=til_size+1%></td>
		          <td height="22" align="center" style="border-left: #000000 1px solid; border-bottom: #000000 1px solid">
				  <a href="javascript:item_search('<%=til_size%>')" onMouseOver="window.status=''; return true"><img src=/acar/images/center/button_in_search1.gif border=0 align=absmiddle></a>
				  </td>				  
		          <td height="22" align="center" style="border-left: #000000 1px solid; border-bottom: #000000 1px solid"><span class="ledger_contC">
		            <input type="text" name="item_g" size="12" value="" class="whitetext" >
		          </span></td>
		          <td height="22" align="center" style="border-left: #000000 1px solid; border-bottom: #000000 1px solid"><span class="ledger_contC">
		            <input type="text" name="item_car_no" size="12" value="" class="whitetext"  >
		          </span></td>
		          <td height="22" align="center" style="border-left: #000000 1px solid; border-bottom: #000000 1px solid"><span class="ledger_contC">
		            <input type="text" name="item_car_nm" size="15" value="" class="whitetext" >
		          </span></td>
		          <td height="22" align="center" style="border-left: #000000 1px solid; border-bottom: #000000 1px solid"><span class="ledger_contC">
		            <input type="text" name="item_dt1" size="10" value="" class="whitetext" >
		          </span></td>
		          <td height="22" align="center" style="border-left: #000000 1px solid; border-bottom: #000000 1px solid"><span class="ledger_contC">
		            <input type="text" name="item_dt2" size="10" value="" class="whitetext" >
		          </span></td>
		          <td height="22" align="center" style="border-left: #000000 1px solid; border-bottom: #000000 1px solid"><span class="ledger_contC">
		            <input type="text" name="item_supply" size="10" value="" class="whitenum"  > 
		            </span></td>
		          <td height="22" align="center" style="border-left: #000000 1px solid; border-bottom: #000000 1px solid"><span class="ledger_contC">
		            <input type="text" name="item_value" size="10" value="" class="whitenum"  >
					</span></td>
		          <td height="22" align="center" style="border-left: #000000 1px solid; border-bottom: #000000 1px solid;"><span class="ledger_contC">
		            <input type="text" name="item_amt" size="10" value="" class="whitenum"  >
					</span></td>
				  <td height="22" align="center" style="border-left: #000000 1px solid; border-bottom: #000000 1px solid;">
        			    <select name='del_chk' >
        			      <option value='A'>추가</option>         		                		        	  
        		        </select>				  
        		  </td>
		          <td height="22" align="center" style="border-left: #000000 1px solid; border-bottom: #000000 1px solid; border-right: #000000 1px solid">&nbsp;</td>				  
		        </tr>	
		        <%} %>			 
                <tr>
                  <td height="22" colspan="7" align="center" style="border-left: #000000 1px solid; border-bottom: #000000 1px solid" bgcolor="#CCCCCC"><font size="3"><b>합계
                          <!--(①)-->
                  </b></font></td>
                  <td height="22" style="border-left: #000000 1px solid; border-bottom: #000000 1px solid" align="center"><input type="text" name="t_item_supply" size="10" value="<%=Util.parseDecimal(item_s_amt)%>" class="taxnum" onBlur='javascript:this.value=parseDecimal(this.value)'></td>
                  <td height="22" style="border-left: #000000 1px solid; border-bottom: #000000 1px solid" align="center"><input type="text" name="t_item_value" size="10" value="<%=Util.parseDecimal(item_v_amt)%>" class="taxnum" onBlur='javascript:this.value=parseDecimal(this.value)'></td>
                  <td height="22" align="center" style="border-left: #000000 1px solid; border-bottom: #000000 1px solid;"><input type="text" name="t_item_amt" size="10" value="<%=Util.parseDecimal(item_s_amt+item_v_amt)%>" class="taxnum" onBlur='javascript:this.value=parseDecimal(this.value)'></td>
                  <td height="22" align="center" style="border-left: #000000 1px solid; border-bottom: #000000 1px solid;">&nbsp;</td>
		          <td height="22" align="center" style="border-left: #000000 1px solid; border-bottom: #000000 1px solid; border-right: #000000 1px solid">&nbsp;</td>				  				  
                </tr>
            </table>
        </td>
    </tr>
	<%}%>	
    <tr>
        <td colspan="2">&nbsp;</td>
    </tr>
	<%if(nm_db.getWorkAuthUser("전산팀",ck_acar_id) || nm_db.getWorkAuthUser("세금계산서담당자",ck_acar_id) || nm_db.getWorkAuthUser("스케줄변경담당자",ck_acar_id)){%>	
    <tr>
        <td colspan="2" align="right"><a href="javascript:tax_update();"><img src=/acar/images/center/button_modify.gif align=absmiddle border=0></a></td>
    </tr>
    <tr>
        <td colspan="2">&nbsp;</td>
    </tr>
    <tr>
        <td colspan="2" align="right"><a href="javascript:tax_delete();"><img src=/acar/images/center/button_delete.gif align=absmiddle border=0></a></td>
    </tr>		
    <tr>
        <td colspan="2">&nbsp;</td>
    </tr>	
    <tr>
        <td colspan="2"><hr></td>
    </tr>
    <%}%>		
    <tr>
      <td><img src=/acar/images/center/icon_arrow.gif align=absmiddle> <span class=style2>이메일 발송</span></td>
      <td align="right"></td>
    </tr>
    <tr>
        <td class=line2 colspan=2></td>
    </tr>
    <tr>
      <td colspan="2" class="line">
        <table border="0" cellspacing="1" cellpadding="0" width='100%'>	
		  
    	<% 	Vector vts = ScdMngDb.getTaxItemMailHistoryList(item_id);
			int vt_size = vts.size();%>		
          <tr>
            <td width='10%' class='title'>연번</td>
            <td width="20%" class='title'>발송일시</td>
            <td width="20%" class='title'>이메일주소</td>
            <td width="30%" class='title'>열람일시</td>
            <td width="10%" class='title'>수신여부</td>
            <td width="10%" class='title'>발송상태</td>
          </tr>
          <%	for(int i = 0 ; i < vt_size ; i++){
				      Hashtable ht = (Hashtable)vts.elementAt(i);%>		  
          <tr>
            <td align='center'><%=i+1%></td>
            <td align='center'><%=AddUtil.ChangeDate3(String.valueOf(ht.get("STIME")))%></td>
            <td align='center'><%=ht.get("EMAIL")%></td>
            <td align='center'><%=AddUtil.ChangeDate3(String.valueOf(ht.get("OTIME")))%></td>
            <td align='center'><%=ht.get("OCNT_NM")%></td>
            <td align='center'><%=ht.get("MSGFLAG_NM")%><%//=ht.get("ERRCODE")%></td>
          </tr>
          <%	}%>				  
        </table>
      </td>
    </tr>
    <tr>
      <td colspan="2" class="line">
        <table border="0" cellspacing="1" cellpadding="0" width='100%'>
          <tr>
            <td width='10%' class='title'>메일수신자</td>
            <td colspan="5"><table border="0" cellspacing="1" cellpadding="0" width='90%'>
			  <%if(!ti_bean.getSeq().equals("") && !site.getAgnt_email().equals("")){%>
              <tr>
                <td>
								&nbsp;[수신담당자] 이&nbsp;&nbsp;&nbsp;름 : <input type='text' size='20' name='con_agnt_nm' value='<%=site.getAgnt_nm()%>' maxlength='20' class='text'>
                &nbsp;&nbsp;EMAIL : <input type='text' size='30' name='con_agnt_email' value='<%=site.getAgnt_email()%>' maxlength='40' class='text' style='IME-MODE: inactive'>
                &nbsp;&nbsp;이동전화 : <input type='text' size='20' name='con_agnt_m_tel' value='<%=site.getAgnt_m_tel()%>' maxlength='20' class='text'>
				</td>
              </tr>
              <tr>
                <td>
								&nbsp;[추가담당자] 이&nbsp;&nbsp;&nbsp;름 : <input type='text' size='20' name='con_agnt_nm2' value='<%=site.getAgnt_nm2()%>' maxlength='20' class='text'>
                &nbsp;&nbsp;EMAIL : <input type='text' size='30' name='con_agnt_email2' value='<%=site.getAgnt_email2()%>' maxlength='40' class='text' style='IME-MODE: inactive'>
                &nbsp;&nbsp;이동전화 : <input type='text' size='20' name='con_agnt_m_tel2' value='<%=site.getAgnt_m_tel2()%>' maxlength='20' class='text'>
				</td>
              </tr>              
			  <%}else{%>
              <tr>
                <td>
								&nbsp;[수신담당자] 이&nbsp;&nbsp;&nbsp;름 : <input type='text' size='20' name='con_agnt_nm' value='<%=client.getCon_agnt_nm()%>' maxlength='20' class='text'>
                &nbsp;&nbsp;EMAIL : <input type='text' size='30' name='con_agnt_email' value='<%=client.getCon_agnt_email()%>' maxlength='40' class='text'>
                &nbsp;&nbsp;이동전화 : <input type='text' size='20' name='con_agnt_m_tel' value='<%=client.getCon_agnt_m_tel()%>' maxlength='20' class='text'>
				</td>
              </tr>			  
              <tr>
                <td>
								&nbsp;[추가담당자] 이&nbsp;&nbsp;&nbsp;름 : <input type='text' size='20' name='con_agnt_nm2' value='<%=client.getCon_agnt_nm2()%>' maxlength='20' class='text'>
                &nbsp;&nbsp;EMAIL : <input type='text' size='30' name='con_agnt_email2' value='<%=client.getCon_agnt_email2()%>' maxlength='40' class='text'>
                &nbsp;&nbsp;이동전화 : <input type='text' size='20' name='con_agnt_m_tel2' value='<%=client.getCon_agnt_m_tel2()%>' maxlength='20' class='text'>
				</td>
              </tr>			  
			  <%}%>
            </table></td>
          </tr>
        </table>
      </td>
    </tr>	
    <%if(client.getItem_mail_yn().equals("N")){%>
    <tr>
        <td><font color=red>* 거래명세서메일수신여부가 거부입니다.</font></td>
    </tr>
    <%}else{%>
    <tr>
        <td colspan="2" align="right"><a href="javascript:Remail();"><img src="/acar/images/center/button_email_re_send.gif" align="absmiddle" border="0"></a></td>
    </tr>		    
    <%}%>
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