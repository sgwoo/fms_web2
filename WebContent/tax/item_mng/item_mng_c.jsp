<%@ page language="java" contentType="text/html;charset=euc-kr" %>
<%@ page import="java.util.*, acar.util.*, acar.fee.*, acar.common.*, tax.*, acar.bill_mng.*, acar.client.*, acar.user_mng.*"%>
<jsp:useBean id="ScdMngDb" scope="page" class="tax.ScdMngDatabase"/>
<jsp:useBean id="IssueDb" scope="page" class="tax.IssueDatabase"/>
<jsp:useBean id="al_db" scope="page" class="acar.client.AddClientDatabase"/>
<%@ include file="/tax/cookies_base.jsp" %>

<%
	CommonDataBase c_db = CommonDataBase.getInstance();	
	NeoErpUDatabase neoe_db = NeoErpUDatabase.getInstance();
	MaMenuDatabase nm_db = MaMenuDatabase.getInstance();
	
	String item_id 	= request.getParameter("item_id")==null?"":request.getParameter("item_id");
	String rent_mng_id 	= request.getParameter("rent_mng_id")==null?"":request.getParameter("rent_mng_id");
	String rent_l_cd 	= request.getParameter("rent_l_cd")==null?"":request.getParameter("rent_l_cd");
	String car_mng_id 	= request.getParameter("car_mng_id")==null?"":request.getParameter("car_mng_id");
	String client_id 	= request.getParameter("client_id")==null?"":request.getParameter("client_id");
	String site_id 		= request.getParameter("site_id")==null?"":request.getParameter("site_id");
	String mode = request.getParameter("mode")==null?"":request.getParameter("mode");
	long item_s_amt = 0;
	long item_v_amt = 0;
	long item_s_amt2 = 0;
	int height = 0;
	
	//세금계산서 조회
	tax.TaxBean t_bean 	= IssueDb.getTax_itemId(item_id);
	//거래명세서 조회
	TaxItemBean ti_bean 	= IssueDb.getTaxItemCase(item_id);
	//거래명세서 리스트 조회
	Vector tils	        = IssueDb.getTaxItemListCase(item_id);
	int til_size            = tils.size();
	
	String item_gubun = "";
	for(int i = 0 ; i < til_size ; i++){
  	TaxItemListBean til_bean = (TaxItemListBean)tils.elementAt(i);
  	if(item_gubun.equals("") && til_bean.getGubun().equals("7")){
	  	item_gubun = til_bean.getGubun();
  		//면책금 무통장입금시에만 처리
			String serv_paid_type = IssueDb.getServicePaidType(til_bean.getCar_mng_id(), til_bean.getTm());
			if(!serv_paid_type.equals("2")) item_gubun = ""; //무통장이 아니면 안함
		}
  }
  	
	//거래명세서 기타 리스트 조회
	Vector tiks	        = IssueDb.getTaxItemKiCase(item_id);
	int tik_size            = tiks.size();
	
	//거래처정보
	ClientBean client       = al_db.getClient(ti_bean.getClient_id().trim());	
	//거래처지점정보
	ClientSiteBean site     = al_db.getClientSite(ti_bean.getClient_id(), ti_bean.getSeq());
	//네오엠 거래처 정보
	Hashtable ven           = neoe_db.getVendorCase(client.getVen_code());
	
	//장기계약 상단정보
	LongRentBean bean  	= new LongRentBean();
	if(til_size > 0){
	  TaxItemListBean til = (TaxItemListBean)tils.elementAt(0);
	  bean  = ScdMngDb.getScdMngLongRentInfo("", til.getRent_l_cd());
	}
	
	//20090701부터 사업자단위과세
	if(!bean.getBr_id().equals("S1") && AddUtil.parseInt(ti_bean.getItem_dt()) > 20090631){
		//종사업장
		bean.setBr_id("S1");
	}
	
	//공급자
	Hashtable br            = c_db.getBranch(bean.getBr_id().trim());
	
	String tax_supply 	= String.valueOf(t_bean.getTax_supply());
	String tax_value 	= String.valueOf(t_bean.getTax_value());
	String i_enp_no 	= client.getEnp_no1() +"-"+ client.getEnp_no2() +"-"+ client.getEnp_no3();
	if(client.getEnp_no1().equals("")) i_enp_no = client.getSsn1() +"-"+ client.getSsn2();
	String i_firm_nm 	= client.getFirm_nm();
	String i_client_nm 	= client.getClient_nm();
	String i_addr 		= client.getO_addr();
	String i_sta 		= client.getBus_cdt();
	String i_item 		= client.getBus_itm();
	
	if(t_bean.getTax_type().equals("")){
		if(bean.getTax_type().equals("본사"))	t_bean.setTax_type("1");
		else                                    t_bean.setTax_type("2");
	}
	
	if(t_bean.getTax_type().equals("2") && !site.getClient_id().equals("")){
	  i_enp_no 	= site.getEnp_no();
	  i_firm_nm 	= site.getR_site();
	  i_client_nm 	= site.getSite_jang();
	  i_addr 	= site.getAddr();
	  i_sta 	= site.getBus_cdt();
	  i_item 	= site.getBus_itm();
	} else if(!t_bean.getRecCoName().equals("")){
		i_firm_nm 	= t_bean.getRecCoName		();
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
	//발행취소
	function tax_cancel(){
		var fm = document.form1;	
		window.open("about:blank",'tax_cancel','scrollbars=yes,status=no,resizable=yes,width=500,height=250,left=50,top=50');		
		fm.action = "tax_cancel.jsp";
		fm.target = "tax_cancel";
//		fm.submit();		
	}
	
	//목록가기
	function go_list(){
		var fm = document.form1;
		fm.target = "d_content";
		fm.action = "item_mng_frame.jsp";
		fm.submit();
	}
	
	
	function view_client(m_id, l_cd, r_st)
	{
		window.open("/fms2/con_fee/con_fee_client_s.jsp?m_id="+m_id+"&l_cd="+l_cd+"&r_st="+r_st, "VIEW_CLIENT", "left=100, top=100, width=720, height=550, scrollbars=yes");
	}	
	
	//세금계산서인쇄
	function TaxPrint(){
		var fm = document.form1;
		var SUBWIN="tax_print.jsp?tax_no=<%=t_bean.getTax_no()%>&client_id=<%=client_id%>&r_site=<%=site_id%>&auth_rw=<%=auth_rw%>";	
		window.open(SUBWIN, "TaxPrint", "left=50, top=50, width=680, height=550, scrollbars=yes, status=yes");
	}	
	//견적서인쇄
	function DocPrint(){
		var fm = document.form1;
		var SUBWIN="doc_print.jsp?item_id=<%=item_id%>&client_id=<%=client_id%>&r_site=<%=site_id%>&auth_rw=<%=auth_rw%>";	
		window.open(SUBWIN, "DocPrint", "left=50, top=50, width=1000, height=800, scrollbars=yes, status=yes");
	}
	//내용수정	
	function tax_update(){
		var fm = document.form1;
		fm.action = 'item_mng_u_a.jsp';
		fm.target = 'i_no';
//		fm.submit();
	}
	
	function ViewTaxItem(){		
		var taxItemInvoice = window.open("about:blank", "TaxItem", "resizable=no,  scrollbars=yes, status=yes, left=50,top=20, width=1200px, height=800px");
		var fm = document.form1;
		fm.target="TaxItem";
		fm.action = "/tax/issue_1_tax/tax_item_u.jsp";
		fm.submit();			
	}						
	
//-->
</script>

</head>
<body>
<form action="./issue_3_sc_a.jsp" name="form1" method="POST">
<%@ include file="/include/search_hidden.jsp" %>
  <input type="hidden" name="idx" value="<%=idx%>">
  <input type="hidden" name="item_id" value="<%=item_id%>">
  <input type="hidden" name="client_id" value="<%=client_id%>">
  <input type="hidden" name="site_id" value="<%=site_id%>">  
  <input type="hidden" name="rent_mng_id" value="<%=rent_mng_id%>">
  <input type="hidden" name="rent_l_cd" value="<%=rent_l_cd%>">
  <input type="hidden" name="car_mng_id" value="<%=car_mng_id%>">
  <input type="hidden" name="mode" value="<%=mode%>">
  <table width=100% border=0 cellpadding=0 cellspacing=0>
    <tr>
		<td colspan=2>
			<table width=100% border=0 cellpadding=0 cellspacing=0>
				<tr>
					<td width=7><img src=/acar/images/center/menu_bar_1.gif width=7 height=33></td>
					<td class=bar>&nbsp;&nbsp;&nbsp;<img src=/acar/images/center/menu_bar_dot.gif width=4 height=5 align=absmiddle>&nbsp;<span class=style1>재무회계 > 세금계산서관리 > 거래명세서보관함 > <span class=style5>
						거래명세서</span></span></td>
					<td width=7><img src=/acar/images/center/menu_bar_2.gif width=7 height=33></td>
				</tr>
			</table>
		</td>
	</tr>
	<tr>
		<td class=h></td>
	</tr>  
    <tr>
        <td align="right" colspan=2>
	    <a href="javascript:go_list();"><img src="/acar/images/center/button_list.gif" align="absmiddle" border="0"></a>&nbsp;
	    <a href="javascript:history.go(-1);"><img src="/acar/images/center/button_back_p.gif" align="absmiddle" border="0"></a>
	    </td>
	</tr>
	<tr><td class=line2 colspan=2></td></tr>
    <tr>
        <td colspan="2" class='line'>
        <%// if(t_bean.getUnity_chk().equals("1") || (t_bean.getRent_l_cd().length()==0 && t_bean.getUnity_chk().equals("0"))){%>
        <%// if(t_bean.getRent_l_cd().length()==0 && t_bean.getUnity_chk().equals("0")){%>
            <table border="0" cellspacing="1" cellpadding="0" width='100%'>
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
                    </td>
                </tr>
                <tr>
                    <td class='title'>우편물주소</td>
                    <td colspan="3">&nbsp;(<%=bean.getP_zip()%>) <span title='<%=bean.getP_addr()%>'><%=Util.subData(bean.getP_addr(), 25)%></td>
                    <td class='title'>우편물수취인</td>
                    <td colspan="3" >&nbsp;<%=bean.getTax_agnt()%></td>
                </tr>
            </table>
        </td>
    </tr>  
    <tr>
        <td colspan="2"></td>
    </tr>
    <% if(t_bean.getTax_st().equals("M") || t_bean.getTax_st().equals("C") || !t_bean.getM_tax_no().equals("")){
          //세금계산서 조회
	        TaxCngBean tc_bean = IssueDb.getTaxCng(t_bean.getTax_no());
	        if(t_bean.getTax_st().equals("O")) tc_bean = IssueDb.getTaxCng(t_bean.getM_tax_no());
	        %>
    <tr>
        <td colspan="2"><% if(t_bean.getTax_st().equals("C")){%>
        <img src=/acar/images/center/icon_arrow.gif align=absmiddle> <span class=style2>발행취소</span>
        <%}else{%>
        <img src=/acar/images/center/icon_arrow.gif align=absmiddle> <span class=style2>매출취소</span>
        <%}%></td>
    </tr>
    <tr>
        <td colspan="2" class="line">
            <table border="0" cellspacing="1" cellpadding="0" width='100%'>
              <tr>
                <td width='10%' class='title'>취소사유</td>
                <td colspan="3">&nbsp;<%=tc_bean.getCng_cau()%></td>
              </tr>
              <tr>
                <td class='title'>취소일자</td>
                <td width="40%">&nbsp;<%=AddUtil.ChangeDate2(tc_bean.getCng_dt())%></td>
                <td width="10%" class='title'>담당자</td>
                <td width="40%">&nbsp;<%=c_db.getNameById(tc_bean.getCng_id(), "USER")%></td>
              </tr>
            </table>
         </td>
    </tr>
    <% }%>    
	<%if(!t_bean.getTax_no().equals("")){%>
    <tr>
        <td><a href="javascript:TaxPrint()"><img src="/acar/images/center/button_print.gif" align="absmiddle" border="0"></a></td>
        <td align="right">
		<%if(t_bean.getTax_st().equals("O") && t_bean.getM_tax_no().equals("")){%>      	
      	<!--<a href="javascript:tax_cancel();"><img src="/acar/images/center/button_cancel_bh.gif" align="absmiddle" border="0"></a>-->
      	<%}%></td>
    </tr>	
    <tr>
        <td colspan="2">
            <table style="BORDER-COLLAPSE: collapse" cellspacing=0 bordercolordark=white cellpadding=0 width=100% bordercolorlight=#0166a9>
              <tbody>
               <tr>
                  <td class=ledger_titleB style="BORDER-RIGHT: #0166a9 1px solid; BORDER-TOP: #0166a9 2px solid; BORDER-LEFT: #0166a9 2px solid; BORDER-BOTTOM: #0166a9 0px solid" width=64% height=38 rowspan=2 align="center"><p>세 금 계 산 서 (공급받는자 보관용)</p></td>
                  <td class=ledger_titleB style="BORDER-RIGHT: #0166a9 2px solid; BORDER-TOP: #0166a9 2px solid; BORDER-LEFT: #0166a9 1px solid; BORDER-BOTTOM: #0166a9 1px solid" width=15% height=15 align="center">책 번 호</td>
                  <td class=ledger_cont   style="BORDER-RIGHT: #0166a9 2px solid; BORDER-TOP: #0166a9 2px solid; BORDER-LEFT: #0166a9 1px solid; BORDER-BOTTOM: #0166a9 1px solid" align=right width=21% height=15>&nbsp;<font color=#0166a9>권&nbsp; 호</font></td>
               </tr>
               <tr>
                 <td class=ledger_titleB style="BORDER-RIGHT: #0166a9 2px solid; BORDER-TOP: #0166a9 1px solid; BORDER-LEFT: #0166a9 1px solid; BORDER-BOTTOM: #0166a9 0px solid" height=15 align="center">일련번호 </td>
                  <td class=ledger_cont  style="BORDER-RIGHT: #0166a9 2px solid; BORDER-TOP: #0166a9 1px solid; BORDER-LEFT: #0166a9 1px solid; BORDER-BOTTOM: #0166a9 0px solid" height=15 align="center">&nbsp;<%=t_bean.getTax_no()%>
                  </td>
                </tr>
              </tbody>
            </table>
            <table style="BORDER-COLLAPSE: collapse" cellspacing=0 cellpadding=0 width="100%">
              <tbody>
                <tr>
                  <td class=ledger_titleB style="BORDER-RIGHT: #0166a9 1px solid; BORDER-TOP: #0166a9 1px solid; BORDER-LEFT: #0166a9 2px solid; BORDER-BOTTOM: #0166a9 0px solid" width=4% rowspan=4 align="center">
                    공<br>
                    <br>
                    급<br>
                    <br>
                    자</td>
                  <td class=ledger_titleB style="BORDER-RIGHT: #0166a9 1px solid; BORDER-TOP: #0166a9 2px solid; BORDER-LEFT: #0166a9 2px solid; BORDER-BOTTOM: #0166a9 1px solid" height=20 align="center" width="8%">등록번호</td>
                  <td class=ledger_cont   style="BORDER-RIGHT: #0166a9 0px solid; BORDER-TOP: #0166a9 2px solid; BORDER-LEFT: #0166a9 1px solid; BORDER-BOTTOM: #0166a9 1px solid" colspan=2 height=20><%= AddUtil.ChangeEnp(String.valueOf(br.get("BR_ENT_NO")))%></td>
                  <td class=ledger_cont   style="BORDER-RIGHT: #0166a9 2px solid; BORDER-TOP: #0166a9 2px solid; BORDER-LEFT: #0166a9 0px solid; BORDER-BOTTOM: #0166a9 1px solid" height=20>
                    <table cellspacing=0 cellpadding=0 align=right border=0>
                      <tbody>
                        <tr>
                          <td width=40 height=1></td>
                        </tr>
                      </tbody>
                    </table>
                  </td>
                  <td class=ledger_titleB style="BORDER-RIGHT: #0166a9 1px solid; BORDER-TOP: #0166a9 1px solid; BORDER-LEFT: #0166a9 1px solid; BORDER-BOTTOM: #0166a9 0px solid" width=4% height=20 rowspan=4 align="center">
                    공<br>
                    급<br>
                    받<br>
                    는<br>
                    자</td>
                  <td class=ledger_titleB style="BORDER-RIGHT: #0166a9 1px solid; BORDER-TOP: #0166a9 2px solid; BORDER-LEFT: #0166a9 2px solid; BORDER-BOTTOM: #0166a9 2px solid" width=8% height=20 align="center">등록번호</td>
                  <td class=ledger_cont   style="BORDER-RIGHT: #0166a9 2px solid; BORDER-TOP: #0166a9 2px solid; BORDER-LEFT: #0166a9 1px solid; BORDER-BOTTOM: #0166a9 2px solid" colspan=3 height=20><%=i_enp_no%></td>
                </tr>
                <tr>
                  <td class=ledger_titleB style="BORDER-RIGHT: #0166a9 1px solid; BORDER-TOP: #0166a9 1px solid; BORDER-LEFT: #0166a9 2px solid; BORDER-BOTTOM: #0166a9 2px solid" height=20 align="center"><p>상 호<br>
                    (법인명)</p></td>
                  <td class=ledger_cont   style="BORDER-RIGHT: #0166a9 1px solid; BORDER-TOP: #0166a9 1px solid; BORDER-LEFT: #0166a9 1px solid; BORDER-BOTTOM: #0166a9 2px solid" width=15% height=20>주식회사아마존카 </td>
                  <td class=ledger_titleB style="BORDER-RIGHT: #0166a9 1px solid; BORDER-TOP: #0166a9 1px solid; BORDER-LEFT: #0166a9 1px solid; BORDER-BOTTOM: #0166a9 2px solid" width=8% height=20 align="center">성 명<br>
                    (대표자)</td>
                  <td class=ledger_cont   style="BORDER-RIGHT: #0166a9 2px solid; BORDER-TOP: #0166a9 1px solid; BORDER-LEFT: #0166a9 1px solid; BORDER-BOTTOM: #0166a9 2px solid" width=15% height=20><%=br.get("BR_OWN_NM")%></td>
                  <td class=ledger_titleB style="BORDER-RIGHT: #0166a9 1px solid; BORDER-TOP: #0166a9 1px solid; BORDER-LEFT: #0166a9 1px solid; BORDER-BOTTOM: #0166a9 1px solid" height=20 align="center">상 호<br>
                    (법인명)</td>
                  <td class=ledger_cont   style="BORDER-RIGHT: #0166a9 1px solid; BORDER-TOP: #0166a9 1px solid; BORDER-LEFT: #0166a9 1px solid; BORDER-BOTTOM: #0166a9 1px solid" width=15% height=20><%=i_firm_nm%></td>
                  <td class=ledger_titleB style="BORDER-RIGHT: #0166a9 1px solid; BORDER-TOP: #0166a9 1px solid; BORDER-LEFT: #0166a9 1px solid; BORDER-BOTTOM: #0166a9 1px solid" width=8% height=20 align="center">성 명<br>
                    (대표자)</td>
                  <td class=ledger_cont   style="BORDER-RIGHT: #0166a9 2px solid; BORDER-TOP: #0166a9 1px solid; BORDER-LEFT: #0166a9 1px solid; BORDER-BOTTOM: #0166a9 1px solid" width=15% height=13><%=i_client_nm%></td>
                </tr>
                <tr>
                  <td class=ledger_titleB style="BORDER-RIGHT: #0166a9 1px solid; BORDER-TOP: #0166a9 1px solid; BORDER-LEFT: #0166a9 1px solid; BORDER-BOTTOM: #0166a9 1px solid" height=20 align="center">사 업 장<br>
                    주소 </td>
                  <td class=ledger_cont   style="BORDER-RIGHT: #0166a9 1px solid; BORDER-TOP: #0166a9 1px solid; BORDER-LEFT: #0166a9 1px solid; BORDER-BOTTOM: #0166a9 1px solid" height="20" colspan=3><%=br.get("BR_ADDR")%></td>
                  <td class=ledger_titleB style="BORDER-RIGHT: #0166a9 1px solid; BORDER-TOP: #0166a9 1px solid; BORDER-LEFT: #0166a9 1px solid; BORDER-BOTTOM: #0166a9 1px solid" height=20 align="center">사 업 장<br>
                    주소<br>
                  </td>
                  <td class=ledger_cont   style="BORDER-RIGHT: #0166a9 2px solid; BORDER-TOP: #0166a9 1px solid; BORDER-LEFT: #0166a9 1px solid; BORDER-BOTTOM: #0166a9 1px solid" height="20" colspan=3><%=i_addr%></td>
                </tr>
                <tr>
                  <td class=ledger_titleB style="BORDER-RIGHT: #0166a9 1px solid; BORDER-TOP: #0166a9 1px solid; BORDER-LEFT: #0166a9 1px solid; BORDER-BOTTOM: #0166a9 0px solid" height=20 align="center">업 태</td>
                  <td class=ledger_cont   style="BORDER-RIGHT: #0166a9 1px solid; BORDER-TOP: #0166a9 1px solid; BORDER-LEFT: #0166a9 1px solid; BORDER-BOTTOM: #0166a9 0px solid" height=20><%=br.get("BR_STA")%></td>
                  <td class=ledger_titleB style="BORDER-RIGHT: #0166a9 1px solid; BORDER-TOP: #0166a9 1px solid; BORDER-LEFT: #0166a9 1px solid; BORDER-BOTTOM: #0166a9 0px solid" height=20 align="center">종 목</td>
                  <td class=ledger_cont   style="BORDER-RIGHT: #0166a9 1px solid; BORDER-TOP: #0166a9 1px solid; BORDER-LEFT: #0166a9 1px solid; BORDER-BOTTOM: #0166a9 0px solid" height=20><%=br.get("BR_ITEM")%></td>
                  <td class=ledger_titleB style="BORDER-RIGHT: #0166a9 1px solid; BORDER-TOP: #0166a9 1px solid; BORDER-LEFT: #0166a9 1px solid; BORDER-BOTTOM: #0166a9 0px solid" height=20 align="center">업 태</td>
                  <td class=ledger_cont   style="BORDER-RIGHT: #0166a9 1px solid; BORDER-TOP: #0166a9 1px solid; BORDER-LEFT: #0166a9 1px solid; BORDER-BOTTOM: #0166a9 0px solid" height=20><%=i_sta%></td>
                  <td class=ledger_titleB style="BORDER-RIGHT: #0166a9 1px solid; BORDER-TOP: #0166a9 1px solid; BORDER-LEFT: #0166a9 1px solid; BORDER-BOTTOM: #0166a9 0px solid" height=20 align="center">종 목</td>
                  <td class=ledger_cont   style="BORDER-RIGHT: #0166a9 2px solid; BORDER-TOP: #0166a9 1px solid; BORDER-LEFT: #0166a9 1px solid; BORDER-BOTTOM: #0166a9 0px solid" height=13><%=i_item%></td>
                </tr>
              </tbody>
            </table>
            <table style="BORDER-COLLAPSE: collapse" cellspacing=0 cellpadding=0 width=100%>
              <tbody>
                <tr align="center">
                  <td class=ledger_titleB style="BORDER-RIGHT: #0166a9 1px solid; BORDER-TOP: #0166a9 2px solid; BORDER-LEFT: #0166a9 2px solid; BORDER-BOTTOM: #0166a9 1px solid" colspan=3 height=25>작 성</td>
                  <td class=ledger_titleB style="BORDER-RIGHT: #0166a9 1px solid; BORDER-TOP: #0166a9 2px solid; BORDER-LEFT: #0166a9 1px solid; BORDER-BOTTOM: #0166a9 1px solid" colspan=12 height=25>공 &nbsp;&nbsp;&nbsp;&nbsp;급 &nbsp;&nbsp;&nbsp;가 &nbsp;&nbsp;&nbsp;액</td>
                 <td class=ledger_titleB style="BORDER-RIGHT: #0166a9 2px solid; BORDER-TOP: #0166a9 2px solid; BORDER-LEFT: #0166a9 1px solid; BORDER-BOTTOM: #0166a9 1px solid" colspan=10 height=25>세 &nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;액</td>
                  <td class=ledger_titleB style="BORDER-RIGHT: #0166a9 2px solid; BORDER-TOP: #0166a9 2px solid; BORDER-LEFT: #0166a9 2px solid; BORDER-BOTTOM: #0166a9 1px solid" width=36% height=25>비 &nbsp;고</td>
                </tr>
                <tr>
                  <td class=ledger_titleB style="BORDER-RIGHT: #0166a9 1px solid; BORDER-TOP: #0166a9 1px solid; BORDER-LEFT: #0166a9 2px solid; BORDER-BOTTOM: #0166a9 1px solid" width=8% height=25 align="center">년</td>
                  <td class=ledger_titleB style="BORDER-RIGHT: #0166a9 1px solid; BORDER-TOP: #0166a9 1px solid; BORDER-LEFT: #0166a9 1px solid; BORDER-BOTTOM: #0166a9 1px solid" width=4% height=25 align="center">월</td>
                  <td class=ledger_titleB style="BORDER-RIGHT: #0166a9 1px solid; BORDER-TOP: #0166a9 1px solid; BORDER-LEFT: #0166a9 1px solid; BORDER-BOTTOM: #0166a9 1px solid" width=4% height=25 align="center">일</td>
                  <td class=ledger_titleB style="BORDER-RIGHT: #0166a9 1px solid; BORDER-TOP: #0166a9 1px solid; BORDER-LEFT: #0166a9 1px solid; BORDER-BOTTOM: #0166a9 1px solid" width=6% height=25 align="center">공란수</td>
                  <td class=ledger_titleB style="BORDER-RIGHT: #0166a9 1px solid; BORDER-TOP: #0166a9 1px solid; BORDER-LEFT: #0166a9 1px solid; BORDER-BOTTOM: #0166a9 1px solid" width=2% height=25 align="center">백</td>
                  <td class=ledger_titleB style="BORDER-RIGHT: #0166a9 1px solid; BORDER-TOP: #0166a9 1px solid; BORDER-LEFT: #0166a9 1px solid; BORDER-BOTTOM: #0166a9 1px solid" width=2% height=25 align="center">십</td>
                  <td class=ledger_titleB style="BORDER-RIGHT: #0166a9 1px solid; BORDER-TOP: #0166a9 1px solid; BORDER-LEFT: #0166a9 1px solid; BORDER-BOTTOM: #0166a9 1px solid" width=2% height=25 align="center">억</td>
                  <td class=ledger_titleB style="BORDER-RIGHT: #0166a9 1px solid; BORDER-TOP: #0166a9 1px solid; BORDER-LEFT: #0166a9 1px solid; BORDER-BOTTOM: #0166a9 1px solid" width=2% height=25 align="center">천</td>
                  <td class=ledger_titleB style="BORDER-RIGHT: #0166a9 1px solid; BORDER-TOP: #0166a9 1px solid; BORDER-LEFT: #0166a9 1px solid; BORDER-BOTTOM: #0166a9 1px solid" width=2% height=25 align="center">백</td>
                  <td class=ledger_titleB style="BORDER-RIGHT: #0166a9 1px solid; BORDER-TOP: #0166a9 1px solid; BORDER-LEFT: #0166a9 1px solid; BORDER-BOTTOM: #0166a9 1px solid" width=2% height=25 align="center">십</td>
                  <td class=ledger_titleB style="BORDER-RIGHT: #0166a9 1px solid; BORDER-TOP: #0166a9 1px solid; BORDER-LEFT: #0166a9 1px solid; BORDER-BOTTOM: #0166a9 1px solid" width=2% height=25 align="center">만</td>
                  <td class=ledger_titleB style="BORDER-RIGHT: #0166a9 1px solid; BORDER-TOP: #0166a9 1px solid; BORDER-LEFT: #0166a9 1px solid; BORDER-BOTTOM: #0166a9 1px solid" width=2% height=25 align="center">천</td>
                  <td class=ledger_titleB style="BORDER-RIGHT: #0166a9 1px solid; BORDER-TOP: #0166a9 1px solid; BORDER-LEFT: #0166a9 1px solid; BORDER-BOTTOM: #0166a9 1px solid" width=2% height=25 align="center">백</td>
                  <td class=ledger_titleB style="BORDER-RIGHT: #0166a9 1px solid; BORDER-TOP: #0166a9 1px solid; BORDER-LEFT: #0166a9 1px solid; BORDER-BOTTOM: #0166a9 1px solid" width=2% height=25 align="center">십</td>
                  <td class=ledger_titleB style="BORDER-RIGHT: #0166a9 1px solid; BORDER-TOP: #0166a9 1px solid; BORDER-LEFT: #0166a9 1px solid; BORDER-BOTTOM: #0166a9 1px solid" width=2% height=25 align="center">일</td>
                  <td class=ledger_titleB style="BORDER-RIGHT: #0166a9 1px solid; BORDER-TOP: #0166a9 1px solid; BORDER-LEFT: #0166a9 1px solid; BORDER-BOTTOM: #0166a9 1px solid" width=2% height=25 align="center">십</td>
                  <td class=ledger_titleB style="BORDER-RIGHT: #0166a9 1px solid; BORDER-TOP: #0166a9 1px solid; BORDER-LEFT: #0166a9 1px solid; BORDER-BOTTOM: #0166a9 1px solid" width=2% height=25 align="center">억</td>
                  <td class=ledger_titleB style="BORDER-RIGHT: #0166a9 1px solid; BORDER-TOP: #0166a9 1px solid; BORDER-LEFT: #0166a9 1px solid; BORDER-BOTTOM: #0166a9 1px solid" width=2% height=25 align="center">천</td>
                  <td class=ledger_titleB style="BORDER-RIGHT: #0166a9 1px solid; BORDER-TOP: #0166a9 1px solid; BORDER-LEFT: #0166a9 1px solid; BORDER-BOTTOM: #0166a9 1px solid" width=2% height=25 align="center">백</td>
                  <td class=ledger_titleB style="BORDER-RIGHT: #0166a9 1px solid; BORDER-TOP: #0166a9 1px solid; BORDER-LEFT: #0166a9 1px solid; BORDER-BOTTOM: #0166a9 1px solid" width=2% height=25 align="center">십</td>
                  <td class=ledger_titleB style="BORDER-RIGHT: #0166a9 1px solid; BORDER-TOP: #0166a9 1px solid; BORDER-LEFT: #0166a9 1px solid; BORDER-BOTTOM: #0166a9 1px solid" width=2% height=25 align="center">만</td>
                  <td class=ledger_titleB style="BORDER-RIGHT: #0166a9 1px solid; BORDER-TOP: #0166a9 1px solid; BORDER-LEFT: #0166a9 1px solid; BORDER-BOTTOM: #0166a9 1px solid" width=2% height=25 align="center">천</td>
                  <td class=ledger_titleB style="BORDER-RIGHT: #0166a9 1px solid; BORDER-TOP: #0166a9 1px solid; BORDER-LEFT: #0166a9 1px solid; BORDER-BOTTOM: #0166a9 1px solid" width=2% height=25 align="center">백</td>
                  <td class=ledger_titleB style="BORDER-RIGHT: #0166a9 1px solid; BORDER-TOP: #0166a9 1px solid; BORDER-LEFT: #0166a9 1px solid; BORDER-BOTTOM: #0166a9 1px solid" width=2% height=25 align="center">십</td>
                  <td class=ledger_titleB style="BORDER-RIGHT: #0166a9 1px solid; BORDER-TOP: #0166a9 1px solid; BORDER-LEFT: #0166a9 1px solid; BORDER-BOTTOM: #0166a9 1px solid" width=2% height=25 align="center">일</td>
                  <td rowspan=2 align="center" class=ledger_cont style="BORDER-RIGHT: #0166a9 2px solid; BORDER-TOP: #0166a9 1px solid; BORDER-LEFT: #0166a9 2px solid; BORDER-BOTTOM: #0166a9 1px solid"><span class="ledger_contC">
                    <input type="text" name="tax_bigo" size="40" value="<%=t_bean.getTax_bigo()%>" class="whitetext">
                  </span></td>
                </tr>
                <tr>
                  <td class=ledger_contC style="BORDER-RIGHT: #0166a9 1px solid; BORDER-TOP: #0166a9 1px solid; BORDER-LEFT: #0166a9 2px solid; BORDER-BOTTOM: #0166a9 2px solid" height=25 align="center"><input type="text" name="req_y" size="4" value="<%=t_bean.getTax_dt().substring(0,4)%>" class="whitetext"></td>
                  <td class=ledger_contC style="BORDER-RIGHT: #0166a9 1px solid; BORDER-TOP: #0166a9 1px solid; BORDER-LEFT: #0166a9 1px solid; BORDER-BOTTOM: #0166a9 2px solid" height=25 align="center"><input type="text" name="req_m" size="2" value="<%=t_bean.getTax_dt().substring(4,6)%>" class="whitetext"></td>
                  <td class=ledger_contC style="BORDER-RIGHT: #0166a9 1px solid; BORDER-TOP: #0166a9 1px solid; BORDER-LEFT: #0166a9 1px solid; BORDER-BOTTOM: #0166a9 2px solid" height=25 align="center"><input type="text" name="req_d" size="2" value="<%=t_bean.getTax_dt().substring(6,8)%>" class="whitetext"></td>
                  <td class=ledger_contC style="BORDER-RIGHT: #0166a9 1px solid; BORDER-TOP: #0166a9 1px solid; BORDER-LEFT: #0166a9 1px solid; BORDER-BOTTOM: #0166a9 2px solid" height=25 align="center"><input type="text" name="gongran" size="1" value="<%=11-tax_supply.length()%>" class="whitetext"></td>
                  <%for(int i=0; i<11-tax_supply.length(); i++){%>
                  <td class=ledger_contC style="BORDER-RIGHT: #0166a9 1px solid; BORDER-TOP: #0166a9 1px solid; BORDER-LEFT: #0166a9 1px solid; BORDER-BOTTOM: #0166a9 2px solid" height=25 align="center"><input type="text" name="s_amt" size="1" value="" class="whitetext"></td>
                  <%}%>
                  <%for(int i=0; i<tax_supply.length(); i++){%>
                  <td class=ledger_contC style="BORDER-RIGHT: #0166a9 1px solid; BORDER-TOP: #0166a9 1px solid; BORDER-LEFT: #0166a9 1px solid; BORDER-BOTTOM: #0166a9 2px solid" height=25 align="center"><input type="text" name="s_amt" size="1" value="<%=tax_supply.charAt(i)%>" class="whitetext"></td>
                  <%}%>
                  <%for(int i=0; i<10-tax_value.length(); i++){%>
                  <td class=ledger_contC style="BORDER-RIGHT: #0166a9 1px solid; BORDER-TOP: #0166a9 1px solid; BORDER-LEFT: #0166a9 1px solid; BORDER-BOTTOM: #0166a9 2px solid" height=25 align="center"><input type="text" name="v_amt" size="1" value="" class="whitetext"></td>
                  <%}%>
                  <%for(int i=0; i<tax_value.length(); i++){%>
                  <td class=ledger_contC style="BORDER-RIGHT: #0166a9 1px solid; BORDER-TOP: #0166a9 1px solid; BORDER-LEFT: #0166a9 1px solid; BORDER-BOTTOM: #0166a9 2px solid" height=25 align="center"><input type="text" name="v_amt" size="1" value="<%=tax_value.charAt(i)%>" class="whitetext"></td>
                  <%}%>
                </tr>
              </tbody>
            </table>
            <table style="BORDER-COLLAPSE: collapse" cellspacing=0 bordercolordark=white cellpadding=0 width=100% bordercolorlight=#0166a9>
              <tbody>
                <tr>
                  <td class=ledger_titleB style="BORDER-RIGHT: #0166a9 1px solid; BORDER-TOP: #0166a9 0px solid; BORDER-LEFT: #0166a9 2px solid; BORDER-BOTTOM: #0166a9 1px solid" colspan=2 height=30 align="center">월&nbsp;&nbsp;일</td>
                  <td class=ledger_titleB style="BORDER-RIGHT: #0166a9 1px solid; BORDER-TOP: #0166a9 0px solid; BORDER-LEFT: #0166a9 1px solid; BORDER-BOTTOM: #0166a9 1px solid" width=26% height=30 align="center">품&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;목</td>
                  <td class=ledger_titleB style="BORDER-RIGHT: #0166a9 1px solid; BORDER-TOP: #0166a9 0px solid; BORDER-LEFT: #0166a9 1px solid; BORDER-BOTTOM: #0166a9 1px solid" width=10% height=30 align="center">규 격</td>
                  <td class=ledger_titleB style="BORDER-RIGHT: #0166a9 1px solid; BORDER-TOP: #0166a9 0px solid; BORDER-LEFT: #0166a9 1px solid; BORDER-BOTTOM: #0166a9 1px solid" width=10% height=30 align="center">수 량</td>
                  <td class=ledger_titleB style="BORDER-RIGHT: #0166a9 1px solid; BORDER-TOP: #0166a9 0px solid; BORDER-LEFT: #0166a9 1px solid; BORDER-BOTTOM: #0166a9 1px solid" width=10% height=30 align="center">단 가</td>
                  <td class=ledger_titleB style="BORDER-RIGHT: #0166a9 1px solid; BORDER-TOP: #0166a9 0px solid; BORDER-LEFT: #0166a9 1px solid; BORDER-BOTTOM: #0166a9 1px solid" width=15% height=30 align="center">공급가액</td>
                  <td class=ledger_titleB style="BORDER-RIGHT: #0166a9 1px solid; BORDER-TOP: #0166a9 0px solid; BORDER-LEFT: #0166a9 1px solid; BORDER-BOTTOM: #0166a9 1px solid" width=15% height=30 align="center">세 액</td>
                  <td class=ledger_titleB style="BORDER-RIGHT: #0166a9 2px solid; BORDER-TOP: #0166a9 0px solid; BORDER-LEFT: #0166a9 1px solid; BORDER-BOTTOM: #0166a9 1px solid" width=6% height=30 align="center">비 고</td>
                </tr>
                <tr>
                  <td class=ledger_contC style="BORDER-RIGHT: #0166a9 1px solid; BORDER-TOP: #0166a9 1px solid; BORDER-LEFT: #0166a9 2px solid; BORDER-BOTTOM: #0166a9 1px solid" width=4% height=25 align="center"><input type="text" name="tax_m" size="2" value="<%=t_bean.getTax_dt().substring(4,6)%>" class="whitetext"></td>
                  <td class=ledger_contC style="BORDER-RIGHT: #0166a9 1px solid; BORDER-TOP: #0166a9 1px solid; BORDER-LEFT: #0166a9 1px solid; BORDER-BOTTOM: #0166a9 1px solid" width=4% height=25 align="center"><input type="text" name="tax_d" size="2" value="<%=t_bean.getTax_dt().substring(6,8)%>" class="whitetext"></td>
                  <td class=ledger_cont  style="BORDER-RIGHT: #0166a9 1px solid; BORDER-TOP: #0166a9 1px solid; BORDER-LEFT: #0166a9 1px solid; BORDER-BOTTOM: #0166a9 1px solid" height=25>&nbsp;<span class="ledger_contC">
        	       <%if(AddUtil.parseInt(t_bean.getReg_dt()) >= 20100929 && t_bean.getGubun().equals("1") && !t_bean.getFee_tm().equals("") && !client.getTm_print_yn().equals("N")){%>
				   <%=t_bean.getFee_tm()%>회차
				   <%}%>
                    <input type="text" name="tax_g" size="25" value="<%=t_bean.getTax_g()%>" class="whitetext">
                  </span></td>
                  <td class=ledger_cont style="BORDER-RIGHT: #0166a9 1px solid; BORDER-TOP: #0166a9 1px solid; BORDER-LEFT: #0166a9 1px solid; BORDER-BOTTOM: #0166a9 1px solid" height=25></td>
                  <td class=ledger_cont style="BORDER-RIGHT: #0166a9 1px solid; BORDER-TOP: #0166a9 1px solid; BORDER-LEFT: #0166a9 1px solid; BORDER-BOTTOM: #0166a9 1px solid" height=25></td>
                  <td class=ledger_cont style="BORDER-RIGHT: #0166a9 1px solid; BORDER-TOP: #0166a9 1px solid; BORDER-LEFT: #0166a9 1px solid; BORDER-BOTTOM: #0166a9 1px solid" height=25></td>
                  <td class=ledger_cont style="BORDER-RIGHT: #0166a9 1px solid; BORDER-TOP: #0166a9 1px solid; BORDER-LEFT: #0166a9 1px solid; BORDER-BOTTOM: #0166a9 1px solid" height=25 align="center"><span class="ledger_contC">
                    <input type="text" name="tax_supply" size="11" value="<%=Util.parseDecimal(t_bean.getTax_supply())%>" class="whitenum" readonly>
                  </span></td>
                  <td class=ledger_cont style="BORDER-RIGHT: #0166a9 1px solid; BORDER-TOP: #0166a9 1px solid; BORDER-LEFT: #0166a9 1px solid; BORDER-BOTTOM: #0166a9 1px solid" height=25 align="center"><span class="ledger_contC">
                    <input type="text" name="tax_value" size="10" value="<%=Util.parseDecimal(t_bean.getTax_value())%>" class="whitenum" readonly>
                  </span></td>
                  <td class=ledger_cont style="BORDER-RIGHT: #0166a9 2px solid; BORDER-TOP: #0166a9 1px solid; BORDER-LEFT: #0166a9 1px solid; BORDER-BOTTOM: #0166a9 1px solid" height=25></td>
                </tr>
              </tbody>
            </table>
            <table style="BORDER-COLLAPSE: collapse" cellspacing=0 bordercolordark=white cellpadding=0 width=100% bordercolorlight=#0166a9>
              <tbody>
              <tbody>
                <tr>
                  <td class=ledger_titleB style="BORDER-RIGHT: #0166a9 1px solid; BORDER-TOP: #0166a9 0px solid; BORDER-LEFT: #0166a9 2px solid; BORDER-BOTTOM: #0166a9 1px solid" width=16% height=25 align="center">합계금액</td>
                  <td class=ledger_titleB style="BORDER-RIGHT: #0166a9 1px solid; BORDER-TOP: #0166a9 0px solid; BORDER-LEFT: #0166a9 1px solid; BORDER-BOTTOM: #0166a9 1px solid" width=16% height=25 align="center">현 &nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;금</td>
                  <td class=ledger_titleB style="BORDER-RIGHT: #0166a9 1px solid; BORDER-TOP: #0166a9 0px solid; BORDER-LEFT: #0166a9 1px solid; BORDER-BOTTOM: #0166a9 1px solid" width=16% height=25 align="center">수&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;표</td>
                  <td class=ledger_titleB style="BORDER-RIGHT: #0166a9 1px solid; BORDER-TOP: #0166a9 0px solid; BORDER-LEFT: #0166a9 1px solid; BORDER-BOTTOM: #0166a9 1px solid" width=16% height=25 align="center">어&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;음</td>
                  <td class=ledger_titleB style="BORDER-RIGHT: #0166a9 1px solid; BORDER-TOP: #0166a9 0px solid; BORDER-LEFT: #0166a9 1px solid; BORDER-BOTTOM: #0166a9 1px solid" width=15% height=25 align="center">외 상 미 수 금</td>
                  <td class=ledger_titleB style="BORDER-RIGHT: #0166a9 2px solid; BORDER-TOP: #0166a9 0px solid; BORDER-LEFT: #0166a9 1px solid; BORDER-BOTTOM: #0166a9 2px solid" align=middle width=21% rowspan=2><table cellspacing=0 cellpadding=0 width=140 border=0>
                      <tbody>
                        <tr class=ledger_titleB>
                          <td width="47%">이금액을</td>
                          <td width="45%"><input type="radio" name="pubform" value="R" <%if(t_bean.getPubForm().equals("R")){%>checked<%}%>>영수<br>
                              <input type="radio" name="pubform" value="D" <%if(t_bean.getPubForm().equals("D")){%>checked<%}%> >청구 </td>
                          <td width="8%">함</td>
                        </tr>
                      </tbody>
                  </table></td>
                </tr>
                <tr>
                  <td class=ledger_cont style="BORDER-RIGHT: #0166a9 1px solid; BORDER-TOP: #0166a9 1px solid; BORDER-LEFT: #0166a9 2px solid; BORDER-BOTTOM: #0166a9 2px solid" height=30 align="center"><span class="ledger_contC">
                    <input type="text" name="tax_amt" size="11" value="<%=Util.parseDecimal(t_bean.getTax_supply()+t_bean.getTax_value())%>" class="whitenum">
                  </span>원</td>
                  <td class=ledger_cont style="BORDER-RIGHT: #0166a9 1px solid; BORDER-TOP: #0166a9 1px solid; BORDER-LEFT: #0166a9 1px solid; BORDER-BOTTOM: #0166a9 2px solid" width=100 height=30 align="right">&nbsp; </td>
                  <td class=ledger_cont style="BORDER-RIGHT: #0166a9 1px solid; BORDER-TOP: #0166a9 1px solid; BORDER-LEFT: #0166a9 1px solid; BORDER-BOTTOM: #0166a9 2px solid" width=100 height=30 align="right">&nbsp; 0 </td>
                  <td class=ledger_cont style="BORDER-RIGHT: #0166a9 1px solid; BORDER-TOP: #0166a9 1px solid; BORDER-LEFT: #0166a9 1px solid; BORDER-BOTTOM: #0166a9 2px solid" width=100 height=30 align="right">&nbsp; 0 </td>
                  <td class=ledger_cont style="BORDER-RIGHT: #0166a9 1px solid; BORDER-TOP: #0166a9 1px solid; BORDER-LEFT: #0166a9 1px solid; BORDER-BOTTOM: #0166a9 2px solid" width=100 height=30 align="right">&nbsp; 0 </td>
                </tr>
              </tbody>
            </table>
        </td>
    </tr>	
    <tr>
        <td colspan="2" align="right">
		  
		</td>
    </tr>
    <% }%>    
    <%if(!ti_bean.getItem_id().equals("")){%>
    <tr>
        <td colspan="2"><a href="javascript:DocPrint()"><img src="/acar/images/center/button_print.gif" align="absmiddle" border="0"></a>
	  		<%//if(nm_db.getWorkAuthUser("전산팀",user_id) || nm_db.getWorkAuthUser("본사출납",user_id)){%>
	  		&nbsp;<a href="javascript:ViewTaxItem()" title='거래명세서수정'><img src=/acar/images/center/button_email_re_send.gif align=absmiddle border=0></a>
	  		<%//}%>		
		</td>
    </tr>
    <tr>
        <td colspan="2">
            <table width="100%" border="0" cellspacing="0" cellpadding="0">
                <tr>
                    <td style="border: #000000 2px solid" align="center" valign="middle">
                        <table width="95%" border="0" cellspacing="0" cellpadding="0" height="95%">
                          <tr>
                            <td height="20">&nbsp;</td>
                            <td height="20">&nbsp;</td>
                            <td height="20">&nbsp;</td>
                          </tr>
                          <tr>
                            <td width="260">&nbsp;</td>
                            <td align="center" width="180" style="border-bottom: #000000 1px solid" height="30"><font size="5">거 래 명 세 서</font></td>
                            <td width="260">&nbsp;</td>
                          </tr>
                          <tr>
                            <td>&nbsp;</td>
                            <td align="center" height="25" valign="bottom">(고 객 용)</td>
                            <td align="right"><% if ( item_gubun.equals("7")) {%>입금계좌번호:신한은행 140-004-023871<br>(주)아마존카<%}%></td>
                          </tr>
                          <tr>
                            <td colspan="3"><table width="100%" border="0" cellspacing="0" cellpadding="0">
                                <tr>
                                  <td width="50%" height="40">&nbsp;</td>
                                  <td width="5%">&nbsp;</td>
                                  <td rowspan="2"><table width="100%" border="0" cellspacing="0" cellpadding="0">
                                      <tr>
                                        <td height="150" rowspan="5" width="30" align="center" style="border-top: #000000 1px solid; border-left: #000000 1px solid; border-bottom: #000000 1px solid">공<br>
                                            <br>
                                    급<br>
                                    <br>
                                    자</td>
                                        <td height="30" align="center" style="border-top: #000000 1px solid; border-left: #000000 1px solid; border-bottom: #000000 1px solid">등록번호</td>
                                        <td height="30" colspan="3" align="center" style="border-top: #000000 1px solid; border-left: #000000 1px solid; border-right: #000000 1px solid; border-bottom: #000000 1px solid"><span class="ledger_cont"><%= AddUtil.ChangeEnp(String.valueOf(br.get("BR_ENT_NO")))%></span></td>
                                      </tr>
                                      <tr>
                                        <td height="30" align="center" style="border-left: #000000 1px solid; border-bottom: #000000 1px solid">상호</td>
                                        <td height="30" align="center" style="border-left: #000000 1px solid; border-bottom: #000000 1px solid"><span class="ledger_cont">주식회사아마존카 </span></td>
                                        <td height="30" align="center" style="border-left: #000000 1px solid; border-bottom: #000000 1px solid">성명</td>
                                        <td height="30" align="center" style="border-left: #000000 1px solid; border-bottom: #000000 1px solid; border-right: #000000 1px solid;"><span class="ledger_cont"><%=br.get("BR_OWN_NM")%></span></td>
                                      </tr>
                                      <tr>
                                        <td height="30" align="center" style="border-left: #000000 1px solid; border-bottom: #000000 1px solid">사업장<br>주소</td>
                                        <td height="30" colspan="3" style="border-left: #000000 1px solid; border-bottom: #000000 1px solid; border-right: #000000 1px solid;"><span class="ledger_cont"><%=br.get("BR_ADDR")%></span></td>
                                      </tr>
                                      <tr>
                                        <td height="30" align="center" style="border-left: #000000 1px solid; border-bottom: #000000 1px solid">업태</td>
                                        <td height="30" align="center" style="border-left: #000000 1px solid; border-bottom: #000000 1px solid"><span class="ledger_cont"><%=br.get("BR_STA")%></span></td>
                                        <td height="30" align="center" style="border-left: #000000 1px solid; border-bottom: #000000 1px solid">종목</td>
                                        <td height="30" align="center" style="border-left: #000000 1px solid; border-bottom: #000000 1px solid; border-right: #000000 1px solid;"><span class="ledger_cont"><%=br.get("BR_ITEM")%></span></td>
                                      </tr>
                                      <tr>
                                        <td height="30" align="center" style="border-left: #000000 1px solid; border-bottom: #000000 1px solid">대표전화</td>
                                        <td height="30" align="center" style="border-left: #000000 1px solid; border-bottom: #000000 1px solid"><span class="ledger_cont"><%=br.get("TEL")%></span></td>
                                        <td height="30" align="center" style="border-left: #000000 1px solid; border-bottom: #000000 1px solid">팩스</td>
                                        <td height="30" align="center" style="border-left: #000000 1px solid; border-bottom: #000000 1px solid; border-right: #000000 1px solid;"><span class="ledger_cont"><%=br.get("FAX")%></span></td>
                                      </tr>
                                  </table></td>
                                </tr>
                                <tr>
                                  <td><table width="100%" border="0" cellspacing="0" cellpadding="0">
                                      <tr>
                                        <td height="22" width="20%">관&nbsp;리&nbsp;번&nbsp;호</td>
                                        <td height="22" width="5%" align="center">:</td>
                                        <td height="22" colspan="2">&nbsp;&nbsp;<span class="ledger_cont"><%=ti_bean.getItem_id()%></span></td>
                                        <td height="22" width="17%">&nbsp;</td>
                                      </tr>
                                      <tr>
                                        <td height="22">작&nbsp;&nbsp;&nbsp;성&nbsp;&nbsp;&nbsp;일</td>
                                        <td height="22" align="center">:</td>
                                        <td height="22" colspan="2">&nbsp;&nbsp;<span class="ledger_cont"><%=AddUtil.ChangeDate2(ti_bean.getItem_dt())%></span></td>
                                        <td height="22">&nbsp;</td>
                                      </tr>
                                      <tr>
                                        <td height="22">상호&nbsp;(성명)</td>
                                        <td height="22" align="center">:</td>
                                        <td height="22" colspan="3">&nbsp;&nbsp;<span class="ledger_cont"><%=i_firm_nm%><%//=client.getFirm_nm()%>&nbsp;<%//=site.getR_site()%></span></td>
                                      </tr>
                                      <tr>
                                        <td height="22" colspan="5"><b>아래와 같이 계산합니다.</b></td>
                                      </tr>
                                      <tr>
                                        <td height="22">합&nbsp;계&nbsp;금&nbsp;액</td>
                                        <td height="22" align="center">:</td>
                                        <td height="22" width="10%" style="border-bottom: #000000 1px solid">일금</td>
                                        <td height="22" style="border-bottom: #000000 1px solid" align="right" width="48%"><span class="ledger_cont"><%=ti_bean.getItem_hap_str()%></span></td>
                                        <td height="22" align="right" style="border-bottom: #000000 1px solid">정<!--(①+②)--></td>
                                      </tr>
                                  </table></td>
                                  <td>&nbsp;</td>
                                </tr>
                            </table></td>
                          </tr>
                          <tr>
                            <td height="20" align="right">(￦<span class="ledger_cont"><%=Util.parseDecimal(ti_bean.getItem_hap_num())%></span>)</td>
                            <td height="30" rowspan="2">&nbsp;</td>
                            <td height="30" align="right" rowspan="2">작성자 : &nbsp;<span class="ledger_cont"><%=ti_bean.getItem_man()%></span>&nbsp;</td>
                          </tr>
                          <tr>
                            <td height="15" align="right">&nbsp;</td>
                          </tr>
                          <tr>
                            <td colspan="3"><table width="100%" border="0" cellspacing="0" cellpadding="0">
                                <tr align="center" bgcolor="#CCCCCC">
                                  <td rowspan="2" width="30" style="border-top: #000000 1px solid; border-left: #000000 1px solid; border-bottom: #000000 1px solid">연번</td>
                                  <td rowspan="2" width="150" style="border-top: #000000 1px solid; border-left: #000000 1px solid; border-bottom: #000000 1px solid">거래구분</td>
                                  <td rowspan="2" width="90" style="border-top: #000000 1px solid; border-left: #000000 1px solid; border-bottom: #000000 1px solid">차량번호</td>
                                  <td rowspan="2" width="200" style="border-top: #000000 1px solid; border-left: #000000 1px solid; border-bottom: #000000 1px solid" bgcolor="#CCCCCC">차명</td>
                                  <td height="20" colspan="2" style="border-top: #000000 1px solid; border-left: #000000 1px solid; border-bottom: #000000 1px solid">청구(거래)기준일</td>
                                  <td rowspan="2" width="70" style="border-top: #000000 1px solid; border-left: #000000 1px solid; border-bottom: #000000 1px solid">공급가액</td>
                                  <td rowspan="2" width="60" style="border-top: #000000 1px solid; border-left: #000000 1px solid; border-bottom: #000000 1px solid">세액</td>
                                  <td rowspan="2" width="70" style="border-top: #000000 1px solid; border-left: #000000 1px solid; border-bottom: #000000 1px solid; ">합계</td>
                                  <td rowspan="2" style="border-top: #000000 1px solid; border-left: #000000 1px solid; border-bottom: #000000 1px solid; border-right: #000000 1px solid;">비고</td>
                                </tr>
                                <tr>
                                  <td height="20" width="70" bgcolor="#CCCCCC" align="center" style="border-left: #000000 1px solid; border-bottom: #000000 1px solid">~부터</td>
                                  <td height="20" width="70" bgcolor="#CCCCCC" align="center" style="border-left: #000000 1px solid; border-bottom: #000000 1px solid">~까지</td>
                                </tr>
                                <% 
                                 int til_count = 0;
                                for(int i = 0 ; i < til_size ; i++){
            										    TaxItemListBean til_bean = (TaxItemListBean)tils.elementAt(i);  
            										    if(til_bean.getItem_value() != 0 ){
            										        til_count++;
            										    %>
                                <tr>
                                  <td height="22" align="center" style="border-left: #000000 1px solid; border-bottom: #000000 1px solid"><%=til_count%></td>
                                  <td height="22" align="center" style="border-left: #000000 1px solid; border-bottom: #000000 1px solid">
								  <%=til_bean.getItem_g()%>
								  <%if(!til_bean.getReg_dt().equals("") && AddUtil.parseInt(AddUtil.replace(til_bean.getReg_dt().substring(0,10),"-","")) >= 20100929 &&  til_bean.getGubun().equals("1") && !til_bean.getTm().equals("") && !client.getTm_print_yn().equals("N")){%>
						          (<%=til_bean.getTm()%>회차)
						          <%}%>
								  </td>
                                  <td height="22" align="center" style="border-left: #000000 1px solid; border-bottom: #000000 1px solid">&nbsp;<%=til_bean.getItem_car_no()%></td>
                                  <td height="22" align="center" style="border-left: #000000 1px solid; border-bottom: #000000 1px solid">&nbsp;<%=til_bean.getItem_car_nm()%></td>
                                  <td height="22" align="center" style="border-left: #000000 1px solid; border-bottom: #000000 1px solid">&nbsp;<%=AddUtil.ChangeDate2(til_bean.getItem_dt1())%></td>
                                  <td height="22" align="center" style="border-left: #000000 1px solid; border-bottom: #000000 1px solid">&nbsp;<%=AddUtil.ChangeDate2(til_bean.getItem_dt2())%></td>
                                  <td height="22" align="right" style="border-left: #000000 1px solid; border-bottom: #000000 1px solid"><%=Util.parseDecimal(til_bean.getItem_supply())%>&nbsp;</td>
                                  <td height="22" align="right" style="border-left: #000000 1px solid; border-bottom: #000000 1px solid"><%=Util.parseDecimal(til_bean.getItem_value())%>&nbsp;</td>
                                  <td height="22" align="right" style="border-left: #000000 1px solid; border-bottom: #000000 1px solid; "><%=Util.parseDecimal(til_bean.getItem_supply()+til_bean.getItem_value())%>&nbsp;</td>
                                  <td height="22" align="left" style="border-left: #000000 1px solid; border-bottom: #000000 1px solid; border-right: #000000 1px solid">&nbsp;<%=til_bean.getEtc()%></td>
                                </tr>
                                <%  item_s_amt = item_s_amt  + Long.parseLong(String.valueOf(til_bean.getItem_supply()));
            										    item_v_amt = item_v_amt  + Long.parseLong(String.valueOf(til_bean.getItem_value()));
            									     }}%>
                                <% if(til_size < 10){%>
                                <% for(int i = 0 ; i < 10-til_count ; i++){%>
                                <tr>
                                  <td height="22" align="center" style="border-left: #000000 1px solid; border-bottom: #000000 1px solid">&nbsp;</td>
                                  <td height="22" align="center" style="border-left: #000000 1px solid; border-bottom: #000000 1px solid">&nbsp;</td>
                                  <td height="22" align="center" style="border-left: #000000 1px solid; border-bottom: #000000 1px solid">&nbsp;</td>
                                  <td height="22" align="center" style="border-left: #000000 1px solid; border-bottom: #000000 1px solid">&nbsp;</td>
                                  <td height="22" align="center" style="border-left: #000000 1px solid; border-bottom: #000000 1px solid">&nbsp;</td>
                                  <td height="22" align="center" style="border-left: #000000 1px solid; border-bottom: #000000 1px solid">&nbsp;</td>
                                  <td height="22" align="right" style="border-left: #000000 1px solid; border-bottom: #000000 1px solid">&nbsp;</td>
                                  <td height="22" align="right" style="border-left: #000000 1px solid; border-bottom: #000000 1px solid">&nbsp;</td>
                                  <td height="22" align="right" style="border-left: #000000 1px solid; border-bottom: #000000 1px solid; ">&nbsp;</td>
                                  <td height="22" align="left" style="border-left: #000000 1px solid; border-bottom: #000000 1px solid; border-right: #000000 1px solid">&nbsp;</td>
                                </tr>
                                <% }%>
                                <% }%>
                                <tr>
                                  <td height="22" colspan="6" align="center" style="border-left: #000000 1px solid; border-bottom: #000000 1px solid" bgcolor="#CCCCCC"><font size="3"><b>합계<!--(①)--></b></font></td>
                                  <td height="22" style="border-left: #000000 1px solid; border-bottom: #000000 1px solid" align="right"><%=Util.parseDecimal(item_s_amt)%>&nbsp;</td>
                                  <td height="22" style="border-left: #000000 1px solid; border-bottom: #000000 1px solid" align="right"><%=Util.parseDecimal(item_v_amt)%>&nbsp;</td>
                                  <td height="22" style="border-left: #000000 1px solid; border-bottom: #000000 1px solid; align="right"><%=Util.parseDecimal(item_s_amt+item_v_amt)%>&nbsp;</td>
                                  <td height="22" style="border-left: #000000 1px solid; border-bottom: #000000 1px solid; border-right: #000000 1px solid">&nbsp;</td>
                                </tr>
                            </table></td>
                          </tr>
                          <tr>
                            <td colspan="4"><font size="1">※ 일할계산(대여료) : (월대여료ⅹ대여일수)÷30일</font></td>
                          </tr>

                          <tr>
                            <td>&nbsp;</td>
                            <td>&nbsp;</td>
                            <td>&nbsp;</td>
                          </tr>

                          <tr>
                            <td><font size="3"><b>※ 기타</b></font></td>
                            <td>&nbsp;</td>
                            <td>&nbsp;</td>
                          </tr>
                          <tr>
                            <td colspan="3"><table width="100%" border="0" cellspacing="0" cellpadding="0">
                                <tr align="center" bgcolor="#CCCCCC">
                                  <td height="25" width="180" style="border-top: #000000 1px solid; border-left: #000000 1px solid; border-bottom: #000000 1px solid">청구구분</td>
                                  <td height="25" width="560" style="border-top: #000000 1px solid; border-left: #000000 1px solid; border-bottom: #000000 1px solid" bgcolor="#CCCCCC">적요</td>
                                  <td height="25" width="70" style="border-top: #000000 1px solid; border-left: #000000 1px solid; border-bottom: #000000 1px solid">금액</td>
                                  <td height="25" style="border-top: #000000 1px solid; border-left: #000000 1px solid; border-bottom: #000000 1px solid; border-right: #000000 1px solid;">비고</td>
                                </tr>
                                <% 	
                                 til_count=0;
                                for(int i = 0 ; i < tik_size ; i++){
            					TaxItemKiBean tik_bean = (TaxItemKiBean)tiks.elementAt(i);%>
                                <tr>
                                  <td height="22" align="center" style="border-left: #000000 1px solid; border-bottom: #000000 1px solid"><%=tik_bean.getItem_ki_g()%></td>
                                  <td height="22" align="center" style="border-left: #000000 1px solid; border-bottom: #000000 1px solid">&nbsp;<%=tik_bean.getItem_ki_app()%></td>
                                  <td height="22" align="right" style="border-left: #000000 1px solid; border-bottom: #000000 1px solid"><%=Util.parseDecimal(tik_bean.getItem_ki_pr())%>&nbsp;</td>
                                  <td height="22" align="center" style="border-left: #000000 1px solid; border-bottom: #000000 1px solid; border-right: #000000 1px solid">&nbsp;<%=tik_bean.getItem_ki_bigo()%></td>
                                </tr>
                                <%		item_s_amt2 = item_s_amt2  + Long.parseLong(String.valueOf(tik_bean.getItem_ki_pr()));
            				}%>
            				<%
            						for(int i = 0 ; i < til_size ; i++){
            								TaxItemListBean til_bean = (TaxItemListBean)tils.elementAt(i);
            										    if(til_bean.getItem_value() == 0 ){
            										    til_count++;
            						%>
            						 <tr>
                                  <td height="22" align="center" style="border-left: #000000 1px solid; border-bottom: #000000 1px solid"><%=til_bean.getItem_g()%></td>
                                  <td height="22" align="center" style="border-left: #000000 1px solid; border-bottom: #000000 1px solid">&nbsp;
                               
                                  <%=til_bean.getItem_car_no()%> <%=til_bean.getItem_car_nm()%>
                                   <% if ( til_bean.getGubun().equals("7")) {%> 자기차량 손해 면책금 <% }  %>
                                   <% if ( til_bean.getGubun().equals("15")) {%> <%=til_bean.getEtc()%> <% }  %>
                                    
                                  </td>
                                  <td height="22" align="right" style="border-left: #000000 1px solid; border-bottom: #000000 1px solid"><%=Util.parseDecimal(til_bean.getItem_supply())%>&nbsp;</td>
                                  <td height="22" align="center" style="border-left: #000000 1px solid; border-bottom: #000000 1px solid; border-right: #000000 1px solid">&nbsp;
                                  <% if ( !til_bean.getGubun().equals("15")) {%><%=til_bean.getEtc()%><% } %><%if(!ti_bean.getTax_item_etc().equals("")){%><%=ti_bean.getTax_item_etc()%><%}%></td>
                                </tr>
                                <%
                                  item_s_amt2 = item_s_amt2  + Long.parseLong(String.valueOf(til_bean.getItem_supply()));
                                }   }%>
                                <%	for(int i = 0 ; i < 5-tik_size ; i++){%>
                                <tr>
                                  <td height="22" align="center" style="border-left: #000000 1px solid; border-bottom: #000000 1px solid">&nbsp;</td>
                                  <td height="22" align="center" style="border-left: #000000 1px solid; border-bottom: #000000 1px solid">&nbsp;</td>
                                  <td height="22" align="right" style="border-left: #000000 1px solid; border-bottom: #000000 1px solid">&nbsp;</td>
                                  <td height="22" align="center" style="border-left: #000000 1px solid; border-bottom: #000000 1px solid; border-right: #000000 1px solid">&nbsp;</td>
                                </tr>
                                <%	}%>
                                <tr>
                                  <td height="22" colspan="2" align="center" style="border-left: #000000 1px solid; border-bottom: #000000 1px solid" bgcolor="#CCCCCC"><font size="3"><b>합계<!--(②)--></b></font></td>
                                  <td height="22" style="border-left: #000000 1px solid; border-bottom: #000000 1px solid" align="right"><%=Util.parseDecimal(item_s_amt2)%>&nbsp;</td>
                                  <td height="22" style="border-left: #000000 1px solid; border-bottom: #000000 1px solid; border-right: #000000 1px solid">&nbsp;</td>
                                </tr>
                            </table></td>
                          </tr>
                       
                          <tr>
                            <td height="20">&nbsp;</td>
                            <td height="20">&nbsp;</td>
                            <td height="20">&nbsp;</td>
                          </tr>
                    </table>
                </td>
            </tr>
        </table>
     </td>
    </tr>
    <tr>
      <td colspan="2">&nbsp;</td>
    </tr>	
    <%}%>    
    <tr>
      <td colspan="2" align="right">&nbsp;</td>
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
