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
	String reg_code = "";
	
	
	//세금계산서 조회
	tax.TaxBean t_bean 		= IssueDb.getTax(tax_no);
	//거래명세서 조회
	TaxItemBean ti_bean 		= IssueDb.getTaxItemCase(t_bean.getItem_id());
	//거래명세서 리스트 조회
	Vector tils	            	= IssueDb.getTaxItemListCase(t_bean.getItem_id());
	int til_size            	= tils.size();
	//공급자
	Hashtable br            	= c_db.getBranch(t_bean.getBranch_g().trim());
	//거래처정보
	ClientBean client       	= al_db.getClient(t_bean.getClient_id().trim());
	
	//거래처지점정보
	ClientSiteBean site     	= al_db.getClientSite(t_bean.getClient_id(), t_bean.getSeq());
	//네오엠 거래처 정보
	Hashtable ven           	= neoe_db.getVendorCase(client.getVen_code());
	//장기계약 상단정보
	LongRentBean bean       	= ScdMngDb.getScdMngLongRentInfo("", t_bean.getRent_l_cd().trim());
	if(til_size > 1){
	  TaxItemListBean til = (TaxItemListBean)tils.elementAt(0);
	  bean  = ScdMngDb.getScdMngLongRentInfo("", til.getRent_l_cd());
	  reg_code = til.getReg_code();
	}
	 
	
	Vector branches = c_db.getBranchs(); //영업소 리스트 조회
	int brch_size = branches.size();
	
	String tax_supply 	= String.valueOf(t_bean.getTax_supply());
	String tax_value 	= String.valueOf(t_bean.getTax_value());
	String i_enp_no 	= client.getEnp_no1() +"-"+ client.getEnp_no2() +"-"+ client.getEnp_no3();
	String i_ssn 		= client.getSsn1() +"-"+ client.getSsn2();
	//if(client.getEnp_no1().equals("")) i_enp_no = "000-00-00000";
	String i_firm_nm 	= client.getFirm_nm();
	String i_client_nm 	= client.getClient_nm();
	String i_addr 		= client.getO_addr();
	String i_sta 		= client.getBus_cdt();
	String i_item 		= client.getBus_itm();
	
	if(t_bean.getGubun().equals("18")){
		i_enp_no 	= t_bean.getRecCoRegNo		();
		i_firm_nm 	= t_bean.getRecCoName		();
		i_client_nm 	= t_bean.getRecCoCeo		();
		i_addr 		= t_bean.getRecCoAddr		();
		i_sta 		= t_bean.getRecCoBizType	();
		i_item 		= t_bean.getRecCoBizSub		();
		if(i_enp_no.equals("") && t_bean.getReccoregnotype().equals("02")){
	  		i_enp_no = t_bean.getRecCoSsn		();
		}	
	}else{
		if(t_bean.getTax_type().equals("2") && !site.getClient_id().equals("")){
		  	i_enp_no 		= site.getEnp_no();
	  		i_firm_nm 		= site.getR_site();
		  	i_client_nm 	= site.getSite_jang();
		  	i_addr 			= site.getAddr();
	  		i_sta 			= site.getBus_cdt();
		  	i_item 			= site.getBus_itm();
		}
	
		if(t_bean.getReccoregnotype().equals("03")){
			i_enp_no 		= "9999999999999";
		}
	
		if(t_bean.getRecCoName().equals("")){
			t_bean.setRecCoSsn		(i_ssn);
			t_bean.setRecCoRegNo	(i_enp_no);
			t_bean.setRecCoName		(i_firm_nm);
			t_bean.setRecCoCeo		(i_client_nm);
			t_bean.setRecCoAddr		(i_addr);
			t_bean.setRecCoBizType	(i_sta);
			t_bean.setRecCoBizSub	(i_item);
			t_bean.setRecTel		(t_bean.getCon_agnt_m_tel());
		}
	}
%>

<html>
<head>
<title>FMS</title>
<meta http-equiv="content-type" content="text/html; charset=euc-kr">
<link rel="stylesheet" type="text/css" href="/include/table_t.css">
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
	
	//고객 보기
	function view_client()
	{
		window.open("/fms2/client/client_c.jsp?auth_rw=<%=auth_rw%>&user_id=<%=user_id%>&br_id=<%=br_id%>&from_page=/tax/tax_mng/tax_mng_u_m.jsp&client_id=<%=t_bean.getClient_id()%>", "CLIENT", "left=10, top=10, width=900, height=700, scrollbars=yes, status=yes, resizable=yes");
	}		
	
	
	//내용수정하기	
	function tax_update(){
		var fm = document.form1;
		
		if(fm.o_br_id[1].value == '')	{ alert("변경후 발행영업소를 입력하십시오."); 	return;}
		if(fm.tax_dt[1].value == '')	{ alert("변경후 세금일자를 입력하십시오."); 	return;}
		if(fm.tax_supply[1].value == '' || fm.tax_supply[1].value == '0')	{ alert("변경후 공급가를 입력하십시오."); 	return;}
		if(fm.tax_value[1].value == '' || fm.tax_value[1].value == '0')		{ alert("변경후 부가세를 입력하십시오."); 	return;}
		if(fm.tax_g[1].value == '')		{ alert("변경후 품목을 입력하십시오."); 		return;}
//		if(fm.tax_bigo[1].value == '')	{ alert("변경후 비고를 입력하십시오."); 		return;}

		var reccoregnotype = '';

		if(fm.reccoregnotype[0].checked == true) reccoregnotype='사업자등록번호';
		if(fm.reccoregnotype[1].checked == true) reccoregnotype='주민등록번호';
		if(fm.reccoregnotype[2].checked == true) reccoregnotype='외국인번호';				
		
		if(reccoregnotype != ''){
			if(!confirm('사업자구분이 '+reccoregnotype+'가 맞습니까?')) return;
		}
		
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
				
		
		fm.tax_supply[1].value		= fm.t_item_supply.value;
		fm.tax_value[1].value		= fm.t_item_value.value;
		
		
//		fm.tax_supply.value			= fm.t_item_supply.value;
//		fm.tax_value.value			= fm.t_item_value.value;
//		fm.tax_amt.value			= fm.t_item_amt.value;
		
//		set_tax_amt();			
	}	
	
	
	<%if(!ti_bean.getItem_id().equals("")){%>	
	//거래명세서 리스트 수정시
	function item_amt_set(obj, idx){
		var fm = document.form1;
		var size = toInt(fm.item_size.value);
//		if(size == 1){//1건
//			if(obj == 's'){
//				fm.item_value.value 	= parseDecimal(toInt(parseDigit(fm.item_supply.value)) * 0.1 );
//				fm.item_amt.value 		= parseDecimal(toInt(parseDigit(fm.item_supply.value)) + toInt(parseDigit(fm.item_value.value)));			
//			}
//			if(obj == 'v'){
////				fm.item_supply.value 	= parseDecimal(toInt(parseDigit(fm.item_value.value)) / 0.1 );
//				fm.item_amt.value 		= parseDecimal(toInt(parseDigit(fm.item_supply.value)) + toInt(parseDigit(fm.item_value.value)));			
//			}
//			if(obj == 'a'){
////				fm.item_supply.value 	= parseDecimal(toInt(parseDigit(fm.item_value.value)) / 1.1 );
////				fm.item_value.value 	= parseDecimal(toInt(parseDigit(fm.item_value.value)) - toInt(parseDigit(fm.item_supply.value)));			
//			}			
//			fm.t_item_supply.value	= fm.item_supply.value;
//			fm.t_item_value.value 	= fm.item_value.value;
//		}else{//여러건
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
//		}
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
	
	//고객 조회
	function search_client()
	{
		var fm = document.form1;
		window.open("about:blank",'search_open','scrollbars=yes,status=no,resizable=yes,width=850,height=600,left=50,top=50');		
		fm.action = "/tax/pop_search/s_tax_client.jsp";		
		fm.target = "search_open";
		fm.submit();				
	}				
	
//-->
</script>
</head>
<body>
<form action="./issue_3_sc_a.jsp" name="form1" method="POST">
<%@ include file="/include/search_hidden.jsp" %>
  <input type="hidden" name="idx" value="<%=idx%>">
  <input type="hidden" name="tax_no" value="<%=tax_no%>">
  <input type="hidden" name="item_id" value="<%=t_bean.getItem_id()%>">  
  <input type="hidden" name="item_size" value="<%=til_size%>">
  <input type="hidden" name="item_hap_num" value="">
  <input type="hidden" name="reg_code" value="<%=reg_code%>">
  <input type="hidden" name="rent_l_cd" value="<%//=t_bean.getRent_l_cd()%>">    
  <input type="hidden" name="client_id" value="<%//=t_bean.getClient_id()%>">    
  <input type="hidden" name="site_id" value="<%//=t_bean.getSeq()%>">      
  

<table width=100% border=0 cellpadding=0 cellspacing=0>
    <tr>
		<td colspan=10>
			<table width=100% border=0 cellpadding=0 cellspacing=0>
				<tr>
					<td width=7><img src=/acar/images/center/menu_bar_1.gif width=7 height=33></td>
					<td class=bar>&nbsp;&nbsp;&nbsp;<img src=/acar/images/center/menu_bar_dot.gif width=4 height=5 align=absmiddle>&nbsp;<span class=style1>재무회계 > 세금계산서발행 > 세금계산서보관함 ><span class=style5>
						세금계산서</span></span></td>
					<td width=7><img src=/acar/images/center/menu_bar_2.gif width=7 height=33></td>
				</tr>
			</table>
		</td>
	</tr>
	<tr>
		<td class=h></td>
	</tr>  	
    <tr> 
        <td align="right"><a href="javascript:go_list();"><img src="/acar/images/center/button_list.gif" align="absmiddle" border="0"></a>&nbsp;
	    <a href="javascript:history.go(-1);"><img src="/acar/images/center/button_back_p.gif" align="absmiddle" border="0"></a></td>	  
    </tr>
    <%if(t_bean.getGubun().equals("18")){%>
    <%}else{%>
    <tr>
		<td class=line2 colspan=2></td>
	</tr>  
    <tr>
        <td colspan="2" class="line">
            <table border="0" cellspacing="1" cellpadding="0" width='100%'>
                <tr>
                  <td width='10%' class='title'>상호</td>
                  <td colspan="3">&nbsp;
					<a href="javascript:view_client()"><%=bean.getFirm_nm()%></a>
					&nbsp;</td>
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
            </table>
        </td>
    </tr>
    <%}%>
    <tr>
        <td colspan="2">&nbsp;</td>
    </tr>
    <tr>
        <td colspan="2"><img src=/acar/images/center/icon_arrow.gif align=absmiddle> <span class=style2>세금계산서</span></td>
    </tr>
    <tr>
		<td class=line2 colspan=2></td>
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
                    <td class='title'>공급자<span class="ledger_contC">(종사업자)</span> </td>
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
                  <td class='title'>공급받는자</td>
                  <td align="center"><table width="90%"  border="1">
                    <tr align="center">
                      <td colspan="2"><span class="ledger_cont"><span class="ledger_contC">
                        <input type="text" name="reccoregno" size="30" value="<%=t_bean.getRecCoRegNo()%>" class="whitetext" readonly>
						 &nbsp;
							  (종사업자번호 : <input type="text" name="reccotaxregno" size="4" value="<%=t_bean.getRecCoTaxRegNo()%>" class="whitetext" readonly>)
                      </span></span></td>
                    </tr>
                    <tr align="center">
                      <td colspan="2"><span class="ledger_cont"><span class="ledger_contC">
                        <input type="text" name="reccossn" size="30" value="<%=t_bean.getRecCoSsn()%>" class="whitetext" readonly>
                      </span></span></td>
                    </tr>
                    <tr align="center">
                      <td><span class="ledger_cont"><span class="ledger_contC">
                        <input type="text" name="recconame" size="20" value="<%=t_bean.getRecCoName()%>" class="whitetext" readonly>
                      </span></span></td>
                      <td><span class="ledger_cont"><span class="ledger_contC">
                        <input type="text" name="reccoceo" size="20" value="<%=t_bean.getRecCoCeo()%>" class="whitetext" readonly>
                      </span></span></td>
                    </tr>
                    <tr align="center">
                      <td colspan="2"><span class="ledger_cont"><span class="ledger_contC">
                        <input type="text" name="reccoaddr" size="55" value="<%=t_bean.getRecCoAddr()%>" class="whitetext" readonly>
                      </span></span></td>
                    </tr>
                    <tr align="center">
                      <td><span class="ledger_cont"><span class="ledger_contC">
                        <input type="text" name="reccobiztype" size="20" value="<%=t_bean.getRecCoBizType()%>" class="whitetext" readonly>
                      </span></span></td>
                      <td><span class="ledger_cont"><span class="ledger_contC">
                        <input type="text" name="reccobizsub" size="20" value="<%=t_bean.getRecCoBizSub()%>" class="whitetext" readonly>
                      </span></span></td>
                    </tr>
                    <tr align="center">
                      <td><span class="ledger_cont"><span class="ledger_contC">
                        <input type="text" name="con_agnt_nm" size="20" value="<%=t_bean.getCon_agnt_nm()%>" class="whitetext" readonly>
                      </span></span></td>
                      <td><span class="ledger_cont"><span class="ledger_contC">
                        <input type="text" name="rectel" size="20" value="<%=t_bean.getRecTel()%>" class="whitetext" readonly>
                      </span></span></td>
                    </tr>
                  </table></td>
                  <td align="center"><table width="90%"  border="1">
                    <tr align="center">
                      <td colspan="2"><span class="ledger_contC">
                        <input name="reccoregno" type="text" class="taxtext" value="<%=i_enp_no%>" size="30" >
						&nbsp;
						(종사업자번호 : <input type="text" name="reccotaxregno" size="4" value="<%=t_bean.getRecCoTaxRegNo()%>" class="taxtext">)
						<!--고객조회-->
						  <%if(til_size==1){%>
						  &nbsp;&nbsp;<span class="b"><a href='javascript:search_client()' onMouseOver="window.status=''; return true" title="클릭하세요"><img src=/acar/images/center/button_in_search.gif align=absmiddle border=0></a></span>
						  <%}%>						
                      </span></td>
                    </tr>
                    <tr align="center">
                      <td colspan="2"><span class="ledger_cont"><span class="ledger_contC">
                        <input type="text" name="reccossn" size="40" value="<%=i_ssn%>" size="30" >
                      </span></span></td>
                    </tr>					
                    <tr align="center">
                      <td><span class="ledger_contC">
                        <input name="recconame" type="text" class="taxtext" value="<%=i_firm_nm%>" size="20" >
                      </span></td>
                      <td><span class="ledger_contC">
                        <input name="reccoceo" type="text" class="taxtext" value="<%=i_client_nm%>" size="20" >
                      </span></td>
                    </tr>
                    <tr align="center">
                      <td colspan="2"><span class="ledger_contC">
                        <input name="reccoaddr" type="text" class="taxtext" value="<%=i_addr%>" size="55" >
                      </span></td>
                    </tr>
                    <tr align="center">
                      <td><span class="ledger_contC">
                        <input name="reccobiztype" type="text" class="taxtext" value="<%=i_sta%>" size="20" >
                      </span></td>
                      <td><span class="ledger_contC">
                        <input name="reccobizsub" type="text" class="taxtext" value="<%=i_item%>" size="20" >
                      </span></td>
                    </tr>
                    <tr align="center">
                      <td><span class="ledger_contC">
                      <span class="ledger_cont">
                        <input type="text" name="con_agnt_nm" size="20" value="<%=t_bean.getCon_agnt_nm()%>" class="taxtext" >
                      </span>                      </span></td>
                      <td><span class="ledger_contC">
                      <span class="ledger_cont">
                        <input type="text" name="rectel" size="20" value="<%=t_bean.getRecTel()%>" class="taxtext" >
                      </span>                      </span></td>
                    </tr>
                  </table></td>
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
						<%if(AddUtil.parseInt(t_bean.getReg_dt()) >= 20100929 && t_bean.getGubun().equals("1") && !t_bean.getFee_tm().equals("") && !client.getTm_print_yn().equals("N")){%>
					  	<%=t_bean.getFee_tm()%>회차
					  	<%}%>														
                      <input type="text" name="tax_g" size="40" value="<%=t_bean.getTax_g()%>" class="whitetext" readonly>
                    </span></span></td>
                    <td align="center"><span class="ledger_cont"><span class="ledger_contC">
						<%if(AddUtil.parseInt(t_bean.getReg_dt()) >= 20100929 && t_bean.getGubun().equals("1") && !t_bean.getFee_tm().equals("") && !client.getTm_print_yn().equals("N")){%>
					  	<%=t_bean.getFee_tm()%>회차
					  	<%}%>														
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
                <tr>
                    <td class='title'>사업자구분</td>
                    <td align="center"><span class="ledger_cont"><span class="ledger_contC">
                     <%if(t_bean.getReccoregnotype().equals("01")){%>사업자등록번호
                     <%}else if(t_bean.getReccoregnotype().equals("02")){%>주민등록번호
					 <%}else if(t_bean.getReccoregnotype().equals("03")){%>외국인번호
					 <%}%>                                          
                    </span></span></td>
                    <td align="center"><span class="ledger_cont"><span class="ledger_contC">
                      <input type="radio" name="reccoregnotype" value="01" <%if(t_bean.getReccoregnotype().equals("01")||t_bean.getPubForm().equals("")){%>checked<%}%>>사업자등록번호
                      <input type="radio" name="reccoregnotype" value="02" <%if(t_bean.getReccoregnotype().equals("02")){%>checked<%}%>>주민등록번호 
					  <input type="radio" name="reccoregnotype" value="03" <%if(t_bean.getReccoregnotype().equals("03")){%>checked<%}%>>외국인번호 
                    </span></span></td>
                </tr>						
                <tr>
                    <td class='title'>발행양식</td>
                    <td align="center"><span class="ledger_cont"><span class="ledger_contC">
                     <%if(t_bean.getPubForm().equals("R")){%>영수                               
					 <%}else{%>청구
					 <%}%>                                          
                    </span></span></td>
                    <td align="center"><span class="ledger_cont"><span class="ledger_contC">
                      <input type="radio" name="pubform" value="R" <%if(t_bean.getPubForm().equals("R")){%>checked<%}%>>영수
                      <input type="radio" name="pubform" value="D" <%if(t_bean.getPubForm().equals("D")||t_bean.getPubForm().equals("")){%>checked<%}%>>청구 
                    </span></span></td>
                </tr>				
            </table>
        </td>
    </tr>
    <%if(!t_bean.getGubun().equals("18")){%>
    <tr>
		<td><font color="red">* 상호를 클릭하면 고객관리 세부내역을 확인할수 있습니다. (고객상세내용,사업자등록증,지점관리..)</font></td>
	</tr>
    <tr>
    <%}%>
      <td><font color="red">* 사업자구분이 외국인일 경우 비고에 주민번호를 입력하십시오.</font></td>
    </tr> 
	<!--
    <tr>
	  <td><font color="red">* 공급자가 종사업자(지점)인 경우 비고에 지점명을 입력해야 합니다. </font></td>
	</tr>			
	-->	 
    <tr>
		<td></td>
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
                  <td height="22" style="border-left: #000000 1px solid; border-bottom: #000000 1px solid"><input type="text" name="item_car_no" size="13" value="<%=til_bean.getItem_car_no()%>" class="taxtext"></td>
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
        		  <%}else{%>&nbsp;
        		      <select name='del_chk'>
        		          <option value='N'>수정</option>        		        			  
        		        </select>   		  
        		         		  
        		  <%}%></td>
                </tr>
                <%  		item_s_amt = item_s_amt  + Long.parseLong(String.valueOf(til_bean.getItem_supply()));
        					 item_v_amt = item_v_amt  + Long.parseLong(String.valueOf(til_bean.getItem_value()));
        		 }%>

			<%for(int i =0; i<3; i++){%>
			
				<input type='hidden' name="item_seq" value="<%=til_size+i+1%>">
		        <tr>
		          <td height="22" align="center" style="border-left: #000000 1px solid; border-bottom: #000000 1px solid"><%=til_size+i+1%></td>
		          <td height="22" align="center" style="border-left: #000000 1px solid; border-bottom: #000000 1px solid"><span class="ledger_contC">
		            <input type="text" name="item_g" size="12" value="" class="taxtext" onBlur='javascript:document.form1.tax_g.value=this.value;'>
		          </span></td>
		          <td height="22" align="center" style="border-left: #000000 1px solid; border-bottom: #000000 1px solid"><span class="ledger_contC">
		            <input type="text" name="item_car_no" size="12" value="" class="taxtext" onBlur='javascript:document.form1.tax_bigo.value=this.value;'>
		          </span></td>
		          <td height="22" align="center" style="border-left: #000000 1px solid; border-bottom: #000000 1px solid"><span class="ledger_contC">
		            <input type="text" name="item_car_nm" size="25" value="" class="taxtext">
		          </span></td>
		          <td height="22" align="center" style="border-left: #000000 1px solid; border-bottom: #000000 1px solid"><span class="ledger_contC">
		            <input type="text" name="item_dt1" size="10" value="" class="taxtext">
		          </span></td>
		          <td height="22" align="center" style="border-left: #000000 1px solid; border-bottom: #000000 1px solid"><span class="ledger_contC">
		            <input type="text" name="item_dt2" size="10" value="" class="taxtext">
		          </span></td>
		          <td height="22" align="center" style="border-left: #000000 1px solid; border-bottom: #000000 1px solid"><span class="ledger_contC">
		            <input type="text" name="item_supply" size="10" value="" class="taxnum" onBlur='javascript:this.value=parseDecimal(this.value); set_amt(<%=til_size+i%>);'> 
		            </span></td>
		          <td height="22" align="center" style="border-left: #000000 1px solid; border-bottom: #000000 1px solid"><span class="ledger_contC">
		            <input type="text" name="item_value" size="10" value="" class="taxnum" onBlur='javascript:this.value=parseDecimal(this.value); set_amt(<%=til_size+i%>);'>
					</span></td>
		          <td height="22" align="center" style="border-left: #000000 1px solid; border-bottom: #000000 1px solid; border-right: #000000 1px solid"><span class="ledger_contC">
		            <input type="text" name="item_amt" size="10" value="" class="taxnum" onBlur='javascript:this.value=parseDecimal(this.value);'>
					</span></td>
				  <td height="22" style="border-left: #000000 1px solid; border-bottom: #000000 1px solid; border-right: #000000 1px solid">&nbsp; 	
        			    <select name='del_chk' >
        			      <option value='A'>추가</option>         		                		        	  
        		        </select>				  
        		  </td>
		        </tr>
			<%}%>	        		 
        	        		 
                <tr>
                  <td height="22" colspan="6" align="center" style="border-left: #000000 1px solid; border-bottom: #000000 1px solid" bgcolor="#CCCCCC"><font size="3"><b>합계
                          <!--(①)-->
                  </b></font></td>
                  <td height="22" style="border-left: #000000 1px solid; border-bottom: #000000 1px solid" align="center"><input type="text" name="t_item_supply" size="10" value="<%=Util.parseDecimal(item_s_amt)%>" class="taxnum" onBlur='javascript:this.value=parseDecimal(this.value)'></td>
                  <td height="22" style="border-left: #000000 1px solid; border-bottom: #000000 1px solid" align="center"><input type="text" name="t_item_value" size="10" value="<%=Util.parseDecimal(item_v_amt)%>" class="taxnum" onBlur='javascript:this.value=parseDecimal(this.value)'></td>
                  <td height="22" align="center" style="border-left: #000000 1px solid; border-bottom: #000000 1px solid;"><input type="text" name="t_item_amt" size="10" value="<%=Util.parseDecimal(item_s_amt+item_v_amt)%>" class="taxnum" onBlur='javascript:this.value=parseDecimal(this.value)'></td>
                  <td height="22" align="center" style="border-left: #000000 1px solid; border-bottom: #000000 1px solid; border-right: #000000 1px solid">&nbsp;</td>
                </tr>
            </table>
        </td>
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
        <td colspan="2" align="right"><a href="javascript:tax_update();"><img src=/acar/images/center/button_modify.gif align=absmiddle border=0></a></td>
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