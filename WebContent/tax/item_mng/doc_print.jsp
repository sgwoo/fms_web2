<%@ page language="java" contentType="text/html;charset=euc-kr" %>
<%@ page import="java.util.*, acar.util.*, acar.fee.*, acar.common.*, tax.*, acar.bill_mng.*, acar.client.*, acar.user_mng.*, acar.accid.*"%>
<jsp:useBean id="ScdMngDb" scope="page" class="tax.ScdMngDatabase"/>
<jsp:useBean id="IssueDb" scope="page" class="tax.IssueDatabase"/>
<jsp:useBean id="al_db" scope="page" class="acar.client.AddClientDatabase"/>
<%-- <%@ include file="/tax/cookies_base.jsp" %> --%>

<%
	CommonDataBase c_db = CommonDataBase.getInstance();	
	NeoErpUDatabase neoe_db = NeoErpUDatabase.getInstance();
	AccidDatabase as_db = AccidDatabase.getInstance();
	
	String item_id 	= request.getParameter("item_id")==null?"":request.getParameter("item_id");
	String rent_mng_id 	= request.getParameter("rent_mng_id")==null?"":request.getParameter("rent_mng_id");
	String rent_l_cd 	= request.getParameter("rent_l_cd")==null?"":request.getParameter("rent_l_cd");
	String car_mng_id 	= request.getParameter("car_mng_id")==null?"":request.getParameter("car_mng_id");
	String client_id 	= request.getParameter("client_id")==null?"":request.getParameter("client_id");
	String site_id 		= request.getParameter("site_id")==null?"":request.getParameter("site_id");
	String accid_id		= request.getParameter("accid_id")==null?"":request.getParameter("accid_id");
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

	//사고조회
	AccidentBean a_bean = null;
	if(!accid_id.equals("") && !car_mng_id.equals("")){
		a_bean = as_db.getAccidentBean(car_mng_id, accid_id);
	}
%>
<html>
<head>
<title>거래명세서</title>
<link rel=stylesheet type="text/css" href="../../include/print.css">
<script language='JavaScript' src='/include/common.js'></script>
<script language="JavaScript">
<!--
	function pagesetPrint(){
		var userAgent = navigator.userAgent.toLowerCase();
		if (userAgent.indexOf("edge") > -1) {
			window.print();
		} else if (userAgent.indexOf("whale") > -1) {
			window.print();
		} else if (userAgent.indexOf("chrome") > -1) {
			window.print();
		} else if (userAgent.indexOf("firefox") > -1) {
			window.print();
		} else if (userAgent.indexOf("safari") > -1) {
			window.print();
		} else {
			IE_Print();
		}	
		
	}
	
	function IE_Print(){
		factory1.printing.header='';
		factory1.printing.footer='';
		factory1.printing.leftMargin=10;
		factory1.printing.rightMargin=10;
		factory1.printing.topMargin=20;
		factory1.printing.bottomMargin=20;
		factory1.printing.Print(true, window);
	}
//-->
</script>
</head>
<body leftmargin="15" onLoad="javascript:pagesetPrint()" >
<!-- <OBJECT id=IEPageSetupX classid="clsid:41C5BC45-1BE8-42C5-AD9F-495D6C8D7586" codebase="/pagesetup/IEPageSetupX.cab#version=1,0,18,0" width=0 height=0>	 -->
<!-- 	<param name="copyright" value="http://isulnara.com"> -->
<!-- </OBJECT> -->
<object id=factory1 style="display:none" classid="clsid:1663ed61-23eb-11d2-b92f-008048fdd814" codebase="/smsx.cab#Version=6,3,439,30">
</object>

<form name='form1' method='post' action='tax_frame.jsp' target=''>

  <table border='0' cellspacing='0' cellpadding='0' width='710' >
    <tr>
        <td colspan="2">
        <table width='710' cellpadding="0" cellspacing="0">
          <tr> 
            <td colspan="2"> 
            <table width="700" border="0" cellspacing="0" cellpadding="0">
                <tr>
                    <td style="border: #000000 2px solid" align="center" valign="middle">
                        <table width="95%" border="0" cellspacing="0" cellpadding="0" height="95%">
                          <tr>
                            <td height="20">&nbsp;</td>
                            <td height="20">&nbsp;</td>
                            <td height="20">&nbsp;</td>
                          </tr>
                          <tr>
                            <td width="230">&nbsp;</td>
                            <td align="center" width="180" style="border-bottom: #000000 1px solid" height="30"><font size="5">거 래 명 세 서</font></td>
                            <td width="230">&nbsp;</td>
                          </tr>
                          <tr>
                            <td>&nbsp;</td>
                            <td align="center" height="25" valign="bottom">(고 객 용)</td>
                            <td align="right"><% if ( item_gubun.equals("7")) {%>입금계좌번호:신한은행 140-004-023871<br>(주)아마존카<%}%></td>
                          </tr>
                          <tr>
                            <td colspan="3"><table width="100%" border="0" cellspacing="0" cellpadding="0">
                                <tr>
                                  <td width="50%" height="15">&nbsp;</td>
                                  <td width="5%">&nbsp;</td>
                                  <td rowspan="2"><table width="100%" border="0" cellspacing="0" cellpadding="0">
                                      <tr>
                                        <td height="150" rowspan="5" width="30" align="center" style="border-top: #000000 1px solid; border-left: #000000 1px solid; border-bottom: #000000 1px solid"><font size="1">공<br>
                                            <br>
                                    급<br>
                                    <br>
                                    자</font></td>
                                        <td height="25" align="center" style="border-top: #000000 1px solid; border-left: #000000 1px solid; border-bottom: #000000 1px solid"><font size="1">등록번호</font></td>
                                        <td height="25" colspan="3" align="center" style="border-top: #000000 1px solid; border-left: #000000 1px solid; border-right: #000000 1px solid; border-bottom: #000000 1px solid"><span class="ledger_cont"><font size="1"><%= AddUtil.ChangeEnp(String.valueOf(br.get("BR_ENT_NO")))%></font></span></td>
                                      </tr>
                                      <tr>
                                        <td height="25" align="center" style="border-left: #000000 1px solid; border-bottom: #000000 1px solid"><font size="1">상호</font></td>
                                        <td height="25" align="center" style="border-left: #000000 1px solid; border-bottom: #000000 1px solid"><span class="ledger_cont"><font size="1">주식회사아마존카</font></span></td>
                                        <td height="25" align="center" style="border-left: #000000 1px solid; border-bottom: #000000 1px solid"><font size="1">성명</font></td>
                                        <td height="25" align="center" style="border-left: #000000 1px solid; border-bottom: #000000 1px solid; border-right: #000000 1px solid;"><span class="ledger_cont"><font size="1"><%=br.get("BR_OWN_NM")%></font></span></td>
                                      </tr>
                                      <tr>
                                        <td height="25" align="center" style="border-left: #000000 1px solid; border-bottom: #000000 1px solid"><font size="1">사업장<br>주소</font></td>
                                        <td height="25" colspan="3" style="border-left: #000000 1px solid; border-bottom: #000000 1px solid; border-right: #000000 1px solid;"><span class="ledger_cont"><font size="1"><%=br.get("BR_ADDR")%></font></span></td>
                                      </tr>
                                      <tr>
                                        <td height="25" align="center" style="border-left: #000000 1px solid; border-bottom: #000000 1px solid"><font size="1">업태</font></td>
                                        <td height="25" align="center" style="border-left: #000000 1px solid; border-bottom: #000000 1px solid"><span class="ledger_cont"><font size="1"><%=br.get("BR_STA")%></font></span></td>
                                        <td height="25" align="center" style="border-left: #000000 1px solid; border-bottom: #000000 1px solid"><font size="1">종목</font></td>
                                        <td height="25" align="center" style="border-left: #000000 1px solid; border-bottom: #000000 1px solid; border-right: #000000 1px solid;"><span class="ledger_cont"><font size="1"><%=br.get("BR_ITEM")%></font></span></td>
                                      </tr>
                                      <tr>
                                        <td height="25" align="center" style="border-left: #000000 1px solid; border-bottom: #000000 1px solid"><font size="1">대표전화</font></td>
                                        <td height="25" align="center" style="border-left: #000000 1px solid; border-bottom: #000000 1px solid"><span class="ledger_cont"><font size="1"><%=br.get("TEL")%></font></span></td>
                                        <td height="25" align="center" style="border-left: #000000 1px solid; border-bottom: #000000 1px solid"><font size="1">팩스</font></td>
                                        <td height="25" align="center" style="border-left: #000000 1px solid; border-bottom: #000000 1px solid; border-right: #000000 1px solid;"><span class="ledger_cont"><font size="1"><%=br.get("FAX")%></font></span></td>
                                      </tr>
                                  </table></td>
                                </tr>
                                <tr>
                                  <td><table width="100%" border="0" cellspacing="0" cellpadding="0">
                                      <tr>
                                        <td height="22" width="25%">관&nbsp;리&nbsp;번&nbsp;호</td>
                                        <td height="22" width="5%" align="center">:</td>
                                        <td height="22" colspan="2">&nbsp;&nbsp;<span class="ledger_cont"><%=ti_bean.getItem_id()%></span></td>
                                        <td height="22" width="20%">&nbsp;</td>
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
                                        <td height="22" colspan="3">&nbsp;&nbsp;<span class="ledger_cont">
                                        	<%if(!accid_id.equals("") && !car_mng_id.equals("")){ %>
                                        		<%=a_bean.getSub_firm_nm()%>
                                        	<%}else{ %>
                                        		<%=i_firm_nm%><%//=client.getFirm_nm()%>&nbsp;<%//=site.getR_site()%>
                                        	<%} %>
                                        </span></td>
                                      </tr>
                                      <tr>
                                        <td height="22" colspan="5"><b>아래와 같이 계산합니다.</b></td>
                                      </tr>
                                      <tr>
                                        <td height="22">합&nbsp;계&nbsp;금&nbsp;액</td>
                                        <td height="22" align="center">:</td>
                                        <td height="22" width="12%" style="border-bottom: #000000 1px solid">일금</td>
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
                                  <td rowspan="2" width="25" style="border-top: #000000 1px solid; border-left: #000000 1px solid; border-bottom: #000000 1px solid">연번</td>
                                  <td rowspan="2" width="70" style="border-top: #000000 1px solid; border-left: #000000 1px solid; border-bottom: #000000 1px solid">거래구분</td>
                                  <td rowspan="2" width="70" style="border-top: #000000 1px solid; border-left: #000000 1px solid; border-bottom: #000000 1px solid">차량번호</td>
                                  <td rowspan="2" width="100" style="border-top: #000000 1px solid; border-left: #000000 1px solid; border-bottom: #000000 1px solid" bgcolor="#CCCCCC">차명</td>
                                  <td height="20" colspan="2" style="border-top: #000000 1px solid; border-left: #000000 1px solid; border-bottom: #000000 1px solid">청구(거래)기준일</td>
                                  <td rowspan="2" width="60" style="border-top: #000000 1px solid; border-left: #000000 1px solid; border-bottom: #000000 1px solid">공급가액</td>
                                  <td rowspan="2" width="55" style="border-top: #000000 1px solid; border-left: #000000 1px solid; border-bottom: #000000 1px solid">세액</td>
                                  <td rowspan="2" width="65" style="border-top: #000000 1px solid; border-left: #000000 1px solid; border-bottom: #000000 1px solid;">합계</td>
                                  <td rowspan="2" width="80" style="border-top: #000000 1px solid; border-left: #000000 1px solid; border-bottom: #000000 1px solid; border-right: #000000 1px solid;">비고</td>
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
                                  <td height="22" align="center" style="border-left: #000000 1px solid; border-bottom: #000000 1px solid ;"><%=til_count%></td>
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
                                  <td height="22" align="right" style="border-left: #000000 1px solid; border-bottom: #000000 1px solid;"><%=Util.parseDecimal(til_bean.getItem_supply()+til_bean.getItem_value())%>&nbsp;</td>
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
                                  <td height="22" align="right" style="border-left: #000000 1px solid; border-bottom: #000000 1px solid">&nbsp;</td>
                                  <td height="22" align="right" style="border-left: #000000 1px solid; border-bottom: #000000 1px solid; border-right: #000000 1px solid">&nbsp;</td>
                                </tr>
                                <% }%>
                                <% }%>
                                <tr>
                                  <td height="22" colspan="6" align="center" style="border-left: #000000 1px solid; border-bottom: #000000 1px solid" bgcolor="#CCCCCC"><font size="3"><b>합계<!--(①)--></b></font></td>
                                  <td height="22" style="border-left: #000000 1px solid; border-bottom: #000000 1px solid" align="right"><%=Util.parseDecimal(item_s_amt)%>&nbsp;</td>
                                  <td height="22" style="border-left: #000000 1px solid; border-bottom: #000000 1px solid" align="right"><%=Util.parseDecimal(item_v_amt)%>&nbsp;</td>
                                  <td height="22" style="border-left: #000000 1px solid; border-bottom: #000000 1px solid;" align="right"><%=Util.parseDecimal(item_s_amt+item_v_amt)%>&nbsp;</td>
                                  <td height="22" style="border-left: #000000 1px solid; border-bottom: #000000 1px solid; border-right: #000000 1px solid" align="right">&nbsp;</td>
                                </tr>
                            </table></td>
                          </tr>
                          <tr>
                            <td colspan="3"><font size="1">※ 일할계산(대여료) : (월대여료ⅹ대여일수)÷30일</font></td>
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
                                  <td height="25" width="110" style="border-top: #000000 1px solid; border-left: #000000 1px solid; border-bottom: #000000 1px solid">청구구분</td>
                                  <td height="25" style="border-top: #000000 1px solid; border-left: #000000 1px solid; border-bottom: #000000 1px solid" bgcolor="#CCCCCC">적요</td>
                                  <td height="25" width="70" style="border-top: #000000 1px solid; border-left: #000000 1px solid; border-bottom: #000000 1px solid">금액</td>
                                  <td height="25" width="130" style="border-top: #000000 1px solid; border-left: #000000 1px solid; border-bottom: #000000 1px solid; border-right: #000000 1px solid;">비고</td>
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
                                  <td height="22" align="center" style="border-left: #000000 1px solid; border-bottom: #000000 1px solid">&nbsp;<%=til_bean.getItem_car_no()%> <%=til_bean.getItem_car_nm()%> 
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
                                <%	for(int i = 0 ; i < 5-tik_size-til_count ; i++){%>
                                <tr>
                                  <td height="22" align="center" style="border-left: #000000 1px solid; border-bottom: #000000 1px solid">&nbsp;</td>
                                  <td height="22" align="center" style="border-left: #000000 1px solid; border-bottom: #000000 1px solid">&nbsp;</td>
                                  <td height="22" align="right" style="border-left: #000000 1px solid; border-bottom: #000000 1px solid">&nbsp;</td>
                                  <td height="22" align="center" style="border-left: #000000 1px solid; border-bottom: #000000 1px solid; border-right: #000000 1px solid">&nbsp;</td>
                                </tr>
                                <%	}%>
                                <tr>
                                  <td height="22" colspan="2" align="center" style="border-left: #000000 1px solid; border-bottom: #000000 1px solid" bgcolor="#CCCCCC"><b>합계<!--(②)--></b></td>
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
    </table>
    </tr>
  </table>
<DIV id=Layer1 style="Z-INDEX: 1; LEFT: 670px; WIDTH: 68px; POSITION: absolute; TOP: 120px; HEIGHT: 68px"><IMG src='/images/cust/3c7kR522I6Sqs_70.gif'></DIV>
  </form>
<script language='javascript'>
<!--	
//-->
</script>
</body>
</html>