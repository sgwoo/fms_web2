<%@ page language="java" contentType="text/html;charset=euc-kr" %>
<%@ page import="java.util.*, acar.util.*, acar.fee.*, acar.common.*, tax.*, acar.bill_mng.*, acar.client.*, acar.user_mng.*, cust.member.*"%>
<jsp:useBean id="ScdMngDb" scope="page" class="tax.ScdMngDatabase"/>
<jsp:useBean id="IssueDb" scope="page" class="tax.IssueDatabase"/>
<jsp:useBean id="al_db" scope="page" class="acar.client.AddClientDatabase"/>
<jsp:useBean id="rs_db" scope="page" class="acar.res_search.ResSearchDatabase"/>
<jsp:useBean id="user_bean" class="acar.user_mng.UsersBean" scope="page"/>
<jsp:useBean id="m_db" scope="page" class="cust.member.MemberDatabase"/>
<%@ include file="/tax/cookies_base.jsp" %>

<%
	CommonDataBase c_db = CommonDataBase.getInstance();
	NeoErpUDatabase neoe_db = NeoErpUDatabase.getInstance();
	MaMenuDatabase nm_db = MaMenuDatabase.getInstance();
	
	String tax_no 	= request.getParameter("tax_no")==null?"":request.getParameter("tax_no");
	String rent_mng_id 	= request.getParameter("rent_mng_id")==null?"":request.getParameter("rent_mng_id");
	String rent_l_cd 	= request.getParameter("rent_l_cd")==null?"":request.getParameter("rent_l_cd");
	String car_mng_id 	= request.getParameter("car_mng_id")==null?"":request.getParameter("car_mng_id");
	String client_id 	= request.getParameter("client_id")==null?"":request.getParameter("client_id");
	String site_id 		= request.getParameter("site_id")==null?"":request.getParameter("site_id");
	String mode = request.getParameter("mode")==null?"":request.getParameter("mode");
	String pubcode = "";
	long item_s_amt = 0;
	long item_v_amt = 0;
	int height = 0;
	
	//로그인ID&영업소ID
	LoginBean login = LoginBean.getInstance();
	if(user_id.equals("")) 	user_id = login.getCookieValue(request, "acar_id");
	if(br_id.equals(""))	br_id = login.getCookieValue(request, "acar_br");
	if(auth_rw.equals(""))	auth_rw = rs_db.getAuthRw(user_id, "05", "07", "01");
	
	//세금계산서 조회
	tax.TaxBean t_bean 		= IssueDb.getTax(tax_no);
	
	//거래명세서 조회
	TaxItemBean ti_bean 	= IssueDb.getTaxItemCase(t_bean.getItem_id());
	//거래명세서 리스트 조회
	Vector tils	            = IssueDb.getTaxItemListCase(t_bean.getItem_id());
	int til_size            = tils.size();
	//reg_code
	String reg_code			= "";
	if(til_size>0){
		TaxItemListBean til_bean_code = (TaxItemListBean)tils.elementAt(0);
		reg_code 	 		= til_bean_code.getReg_code();
	}
	
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
	//업무대여일때
	UserMngDatabase umd = UserMngDatabase.getInstance();
	if(t_bean.getGubun().equals("13")){
		user_bean = umd.getUsersBean(t_bean.getClient_id().trim());
	}
	
	MemberBean m_bean = m_db.getMemberCase(t_bean.getClient_id(), t_bean.getSeq(), "");
	if(m_bean.getMember_id().equals("")) m_bean = m_db.getMemberCase(t_bean.getClient_id(), "", "");
	
	String tax_supply = String.valueOf(t_bean.getTax_supply());
	String tax_value = String.valueOf(t_bean.getTax_value());
	String i_enp_no = client.getEnp_no1() +"-"+ client.getEnp_no2() +"-"+ client.getEnp_no3();
	if(client.getEnp_no1().equals("")) i_enp_no = client.getSsn1() +"-"+ client.getSsn2();
	String i_firm_nm = client.getFirm_nm();
	String i_client_nm = client.getClient_nm();
	String i_addr = client.getO_addr();
	String i_sta = client.getBus_cdt();
	String i_item = client.getBus_itm();
	
	if(t_bean.getGubun().equals("13")){
		  i_enp_no = user_bean.getUser_ssn1()+"-"+user_bean.getUser_ssn2();
		  i_firm_nm = user_bean.getUser_nm();
		  i_client_nm = "";
		  i_addr = user_bean.getAddr();
		  i_sta = "";
		  i_item = "";
	}else{
		if(t_bean.getTax_type().equals("2") && !site.getClient_id().equals("")){
		  i_enp_no = site.getEnp_no();
		  i_firm_nm = site.getR_site();
		  i_client_nm = site.getSite_jang();
		  i_addr = site.getAddr();
		  i_sta = site.getBus_cdt();
		  i_item = site.getBus_itm();
		}
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
	//발행취소
	function tax_cancel(){
		var fm = document.form1;	
		window.open("about:blank",'tax_cancel','scrollbars=yes,status=no,resizable=yes,width=500,height=250,left=50,top=50');		
		fm.action = "tax_cancel.jsp";
		fm.target = "tax_cancel";
		fm.submit();		
	}
	
	//목록가기
	function go_list(){
		var fm = document.form1;
		fm.target = "d_content";
		fm.action = "tax_mng_frame.jsp";
		fm.submit();
	}
	
	
	function view_client(m_id, l_cd, r_st)
	{
		window.open("/fms2/con_fee/con_fee_client_s.jsp?m_id="+m_id+"&l_cd="+l_cd+"&r_st="+r_st, "VIEW_CLIENT", "left=100, top=100, width=720, height=550, scrollbars=yes");
	}	
	
	//세금계산서인쇄
	function TaxPrint(){
		var fm = document.form1;
		var SUBWIN="tax_print.jsp?tax_no=<%=tax_no%>&client_id=<%=client_id%>&r_site=<%=site_id%>&auth_rw=<%=auth_rw%>";	
		window.open(SUBWIN, "TaxPrint", "left=50, top=50, width=680, height=550, scrollbars=yes, status=yes");
	}	
	//견적서인쇄
	function DocPrint(){
		var fm = document.form1;
		var SUBWIN="doc_print.jsp?tax_no=<%=tax_no%>&item_id=<%=t_bean.getItem_id()%>&client_id=<%=client_id%>&r_site=<%=site_id%>&auth_rw=<%=auth_rw%>";	
		window.open(SUBWIN, "DocPrint", "left=50, top=50, width=700, height=600, scrollbars=yes, status=yes");
	}
	//내용수정	
	function tax_update(){
		var fm = document.form1;
		fm.action = 'tax_mng_u_a.jsp';
		fm.target = 'i_no';
		fm.submit();
	}
	//내용수정-관리자	
	function tax_updateMaster(){
		var fm = document.form1;
		fm.action = 'tax_mng_u_m.jsp';
		fm.target = 'd_content';
		fm.submit();
	}	
	
	//트러스빌 연결
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
	//이메일재발행
	function  SaleEBill(){
		var taxInvoice = window.open("about:blank", "SaleEBill", "resizable=no,  scrollbars=yes, status=yes, left=50,top=20, width=750px, height=700px");
		document.form1.action="saleebill_reg.jsp";
		document.form1.method="post";
		document.form1.ebill_st.value='2';		
		document.form1.target="SaleEBill";
		document.form1.submit();
		document.form1.target="_self";
	}	
	function view_client(m_id, l_cd, r_st)
	{
		window.open("/fms2/con_fee/con_fee_client_s.jsp?m_id="+m_id+"&l_cd="+l_cd+"&r_st="+r_st, "VIEW_CLIENT", "left=100, top=100, width=720, height=550, scrollbars=yes");
	}
	
	
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
  <input type="hidden" name="client_id" value="<%=client_id%>">
  <input type="hidden" name="site_id" value="<%=site_id%>">  
  <input type="hidden" name="rent_mng_id" value="<%=rent_mng_id%>">
  <input type="hidden" name="rent_l_cd" value="<%=rent_l_cd%>">
  <input type="hidden" name="car_mng_id" value="<%=car_mng_id%>">
  <input type="hidden" name="mode" value="<%=mode%>">
  <input type="hidden" name="tax_dt" value="<%=t_bean.getTax_dt()%>">  
  <input type='hidden' name="ebill_st" value="">
  <input type='hidden' name="pubCode" value="">
  <input type='hidden' name="docType" value="">
  <input type='hidden' name="userType" value="">  
  <input type='hidden' name="flist" value="cont">    
  <table width=100% border=0 cellpadding=0 cellspacing=0>
    <tr> 
      <td><font color="navy">세금계산서보관함 -&gt;  </font><span class="style1">세금계산서</span></td>
      <td align="right"><input type="button" name="b_ms2" value="목록" onClick="javascript:go_list();" class="btn">
	  &nbsp;<input type="button" name="b_ms3" value="뒤로가기" onClick="javascript:history.go(-1);" class="btn">
	  <%if(nm_db.getWorkAuthUser("회계업무",user_id) && !t_bean.getTax_st().equals("C")){%><input type="button" name="b_ms3" value="관리자" onClick="javascript:tax_updateMaster();" class="btn"><%}%>	  
	  </td>	  
    </tr>
	<%if(!t_bean.getGubun().equals("13")){%>
    <tr>
      <td colspan="2" class='line'>
        <% if(t_bean.getRent_l_cd().trim().length()==13){// && t_bean.getUnity_chk().equals("0")%>
        <table border="0" cellspacing="1" cellpadding="0" width='100%'>
          <tr>
            <td width='10%' class='title'>계약번호</td>
            <td width='15%'>&nbsp;<%=t_bean.getRent_l_cd()%></td>
            <td width='10%' class='title'>상호</td>
            <td colspan="3">&nbsp;<a href="javascript:view_client('<%=bean.getRent_mng_id()%>','<%=bean.getRent_l_cd()%>','1')"><%=bean.getFirm_nm()%></a></td>
            <td width='10%' class='title'>지점/현장</td>
            <td width='15%'>&nbsp;<span title='<%=bean.getSite_nm()%>'><%=Util.subData(bean.getSite_nm(), 10)%></span></td>
          </tr>
          <tr>
            <td class='title'>차량번호</td>
            <td>&nbsp;<%=bean.getCar_no()%></td>
            <td class='title'>차명</td>
            <td colspan="3">&nbsp;<%=bean.getCar_nm()%>&nbsp;<%=bean.getCar_name()%></td>
            <td class='title'>최초등록일</td>
            <td>&nbsp;<%=AddUtil.ChangeDate2(bean.getInit_reg_dt())%></td>
          </tr>
          <tr>
            <td class='title'>대여방식</td>
            <td>&nbsp;
                <%if(bean.getRent_way().equals("1")) 			out.println("일반식");
              	else if(bean.getRent_way().equals("2"))  	out.println("맞춤식");
              	else if(bean.getRent_way().equals("3")) 	out.println("기본식");%>
            </td>
            <td width='10%' class='title'>대여기간</td>
            <td colspan="3">&nbsp;<%=AddUtil.ChangeDate2(bean.getRent_start_dt())%>~<%=AddUtil.ChangeDate2(bean.getRent_end_dt())%>&nbsp;(<%=bean.getCon_mon()%>개월)</td>
            <td class='title'>발행기한</td>
            <td width='15%'>&nbsp;<%=bean.getLeave_day()%>일</td>
          </tr>
          <% if(!bean.getCms_bank().equals("")){%>
          <tr>
            <td class='title'>자동이체</td>
            <td>&nbsp;<%=bean.getCms_bank()%></td>
            <td width='10%' class='title'>이체기간</td>
            <td colspan="3">&nbsp;<%=AddUtil.ChangeDate2(bean.getCms_start_dt())%>~<%=AddUtil.ChangeDate2(bean.getCms_end_dt())%></td>
            <td class='title'>이체일자</td>
            <td width='15%'>&nbsp;매월 <%=bean.getCms_day()%>일</td>
          </tr>
          <% }%>
          <tr>
            <td class='title'>발행구분</td>
            <td>&nbsp;<%=bean.getPrint_st()%></td>
            <td class='title'>발행영업소</td>
            <td>&nbsp;<%=bean.getBr_nm()%></td>
            <td width='10%' class='title'>공급받는자</td>
            <td width='15%' >&nbsp;<%=bean.getTax_type()%></td>
            <td class='title'>네오엠</td>
            <td>&nbsp;
            <% if(!bean.getVen_code().equals("")){%>
            (<%=bean.getVen_code()%>)<span title='<%=ven.get("VEN_NAME")%>'><%=Util.subData(String.valueOf(ven.get("VEN_NAME")), 4)%></span>
            <% }%>
            </td>
          </tr>
          <tr>
            <td class='title'>우편물주소</td>
            <td colspan="3">&nbsp;(<%=bean.getP_zip()%>) <span title='<%=bean.getP_addr()%>'><%=Util.subData(bean.getP_addr(), 25)%></td>
            <td class='title'>우편물수취인</td>
            <td >&nbsp;<%=bean.getTax_agnt()%></td>
            <td class='title'>전자문서발급</td>
            <td >&nbsp;<%=client.getEtax_not_cau()%></td>
          </tr>          
        </table>
        <% }else{%>
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
            <td >&nbsp;<%=bean.getTax_agnt()%></td>
            <td class='title'>전자문서발급</td>
            <td >&nbsp;<%=client.getEtax_not_cau()%></td>
          </tr>
        </table>
        <% }%>
      </td>	  
    </tr>  
    <tr>
      <td colspan="2" class="line"><table border="0" cellspacing="1" cellpadding="0" width='100%'>
        <tr>
          <td width='10%' class='title'>사무실번호</td>
          <td width='15%'>&nbsp;<%=AddUtil.phoneFormat(client.getO_tel())%></td>
          <td width="10%" class='title'>자택번호</td>
          <td width="15%">&nbsp;
              <%=AddUtil.phoneFormat(client.getH_tel())%></td>
          <td width="10%" class='title'>핸드폰번호</td>
          <td width="15%">&nbsp; <%=AddUtil.phoneFormat(client.getM_tel())%></td>
          <td width="10%" class='title'>팩스번호</td>
          <td width="15%">&nbsp; <%=AddUtil.phoneFormat(client.getFax())%></td>
        </tr>
        <tr>
          <td class='title'>아이디</td>
          <td>&nbsp;<%=m_bean.getMember_id()%></td>
          <td class='title'>비밀번호</td>
          <td>&nbsp;<%=m_bean.getPwd()%>
		  </td>
          <td class='title'>사업자번호</td>
          <td>&nbsp; <%=client.getEnp_no1()%>-<%=client.getEnp_no2()%>-<%=client.getEnp_no3()%></td>
          <td class='title'>생년월일/법인번호</td>
          <td>&nbsp; <%=client.getSsn1()%><%if(client.getClient_st().equals("1")){%>-<%=client.getSsn2()%><%}%></td>
        </tr>
		<% 	if(!client.getEtax_not_cau().equals("")){%>
        <tr>
          <td class='title'>이메일수신거부</td>
          <td colspan="7">&nbsp;<%=client.getEtax_not_cau()%></td>
        </tr>
		<%}%>		
        <tr>
          <td class='title'>reg_code</td>
          <td colspan="7">&nbsp;<%=reg_code%></td>
        </tr>
      </table></td>
    </tr>	
    <tr>
      <td colspan="2"><hr></td>
    </tr>
    <tr>
      <td colspan="2" align="center">
		  <%if(!m_bean.getMember_id().equals("") && !m_bean.getMember_id().equals("amazoncar")){%>
		  <a href="https://fms.amazoncar.co.kr/service/tax_index.jsp?mode=1&client_id=<%=t_bean.getClient_id()%>&r_site=<%=t_bean.getSeq()%>&name=<%=m_bean.getMember_id()%>&passwd=<%=m_bean.getPwd()%>&s_yy=<%=t_bean.getTax_dt().substring(0,4)%>&s_mm=<%=t_bean.getTax_dt().substring(4,6)%>" target="_blank" onFocus="this.blur();"><img src="http://fms1.amazoncar.co.kr/mailing/tax_bill/images/button_fms.gif" border=0></a>
		  <%}else{
		  	String ssn = "";
			if(client.getClient_st().equals("2")) 	ssn = client.getSsn1()+client.getSsn1();
			else 								 	ssn = client.getEnp_no1()+client.getEnp_no2()+client.getEnp_no3();%>
		  <a href="https://fms.amazoncar.co.kr/service/tax_index.jsp?mode=2&client_id=<%=t_bean.getClient_id()%>&r_site=<%=t_bean.getSeq()%>&ssn=<%=ssn%>&s_yy=<%=t_bean.getTax_dt().substring(0,4)%>&s_mm=<%=t_bean.getTax_dt().substring(4,6)%>" target="_blank" onFocus="this.blur();"><img src="http://fms1.amazoncar.co.kr/mailing/tax_bill/images/button_fms.gif" border=0></a>
		  <%}%>
		  <%if(!t_bean.getResseq().equals("")){%>
		  <a href="http://fms1.amazoncar.co.kr/mailing/tax_bill/index_simple.jsp?gubun=2&client_id=<%=t_bean.getClient_id()%>&site_id=<%=t_bean.getSeq()%>&tax_no=<%=tax_no%>" target="_blank" onFocus="this.blur();"><img src="http://fms1.amazoncar.co.kr/mailing/tax_bill/images/button_email.gif" border=0></a>
		  <%}%>
	  </td>
    </tr>	
	<%}else{%>	
    <tr>
      <td colspan="2">&nbsp;</td>
    </tr>
	<%}%>
	<% 	if(!t_bean.getResseq().equals("")){%>
    <tr>
      <td>&lt; 이메일발송 &gt;</td>
      <td align="right"><input type="button" name="b_ms2" value="재발행" onClick="javascript:SaleEBill();" class="btn"></td>
    </tr>
    <tr>
      <td colspan="2" class="line">
        <table border="0" cellspacing="1" cellpadding="0" width='100%'>
          <tr>
            <td width='10%' class='title'>메일수신자</td>
            <td colspan="5"><table border="0" cellspacing="1" cellpadding="0" width='650'>
              <tr>
                <td width='200'>&nbsp;이&nbsp;&nbsp;&nbsp;름 : <%=t_bean.getCon_agnt_nm()%></td>
                <td width='150'>근무부서 : <%=t_bean.getCon_agnt_dept()%></td>
                <td>직&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;위 : <%=t_bean.getCon_agnt_title()%></td>
              </tr>
              <tr>
                <td colspan="2">&nbsp;EMAIL : <%=t_bean.getCon_agnt_email()%></td>
                <td>이동전화 : <%=t_bean.getCon_agnt_m_tel()%></td>
                </tr>
            </table></td>
          </tr>
    	<% 	Vector vts = ScdMngDb.getMailHistoryList(tax_no);
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
            <td align='center'><%=ht.get("MSGFLAG_NM")%></td>
          </tr>
          <%	}%>				  
        </table>
      </td>
    </tr>
	<%}%>	
	<% 	if(!t_bean.getResseq().equals("")){%>	
    <tr>
      <td colspan="2">&lt; 트러스빌 상태 &gt;</td>
    </tr>	
    <tr>
      <td colspan="2" class="line">
        <table border="0" cellspacing="1" cellpadding="0" width='100%'>		 
    	<% 	Vector vts = ScdMngDb.getEbHistoryList(tax_no);
			int vt_size = vts.size();%>		
          <tr>
            <td width='10%' class='title'>연번</td>
            <td width="20%" class='title'>변경일시</td>
            <td width="20%" class='title'>전자문서상태</td>
            <td width="50%" class='title'>기타</td>
          </tr>
          <%	for(int i = 0 ; i < vt_size ; i++){
				      Hashtable ht = (Hashtable)vts.elementAt(i);
					  pubcode = String.valueOf(ht.get("PUBCODE"));%>		  
          <tr>
            <td align='center'><%=i+1%></td>
            <td align='center'><%=AddUtil.ChangeDate3(String.valueOf(ht.get("STATUSDATE")))%></td>
            <td align='center'><%=ht.get("STATUS_NM")%></td>
            <td>&nbsp;<%=ht.get("REASON")%></td>
          </tr>
          <%	}%>		
          <tr>
            <td width='10%' class='title'>트러스빌코드</td>
            <td colspan="3">&nbsp;<%=t_bean.getResseq()%>&nbsp;( <a href="javascript:viewTaxInvoice('<%=pubcode%>');"><%=pubcode%></a> )</td>
          </tr>						  		    		 		  
        </table>
      </td>
    </tr>
	<%}%>
    <% if(t_bean.getTax_st().equals("M") || t_bean.getTax_st().equals("C") || !t_bean.getM_tax_no().equals("")){
          //세금계산서 조회
	        TaxCngBean tc_bean = IssueDb.getTaxCng(tax_no);
	        if(t_bean.getTax_st().equals("O")) tc_bean = IssueDb.getTaxCng(t_bean.getM_tax_no());
	        %>
    <tr>
      <td colspan="2"><% if(t_bean.getTax_st().equals("C")){%>
      &lt; 발행취소 &gt;
      <%}else{%>
      &lt; 매출취소 &gt;
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
    <tr>
      <td>
	  <%if(pubcode.equals("")){%>
	  <a href="javascript:TaxPrint()"><img src="../../images/printer.gif" border="0"></a>
	  <%}else{%>
	  <a href="javascript:viewTaxInvoice('<%=pubcode%>')"><img src="../../images/printer.gif" border="0"></a>	  
	  <%}%>	  
	  </td>
      <td align="right">
	  <%if(auth_rw.equals("2") || auth_rw.equals("4") || auth_rw.equals("6")){%>
	  <%if(t_bean.getTax_st().equals("O") && t_bean.getM_tax_no().equals("")){%><input type="button" name="b_ms2" value="발행취소" onClick="javascript:tax_cancel();" class="btn"><%}%>
	  <%}%>
	  </td>
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
              <td class=ledger_cont  style="BORDER-RIGHT: #0166a9 2px solid; BORDER-TOP: #0166a9 1px solid; BORDER-LEFT: #0166a9 1px solid; BORDER-BOTTOM: #0166a9 0px solid" height=15 align="center">&nbsp;<%=tax_no%>
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
              <td class=ledger_cont   style="BORDER-RIGHT: #0166a9 2px solid; BORDER-TOP: #0166a9 2px solid; BORDER-LEFT: #0166a9 1px solid; BORDER-BOTTOM: #0166a9 2px solid" colspan=3 height=20><%=AddUtil.ChangeEnp(i_enp_no)%></td>
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
              <td class=ledger_contC style="BORDER-RIGHT: #0166a9 1px solid; BORDER-TOP: #0166a9 1px solid; BORDER-LEFT: #0166a9 1px solid; BORDER-BOTTOM: #0166a9 2px solid" height=25 align="center"><input type="text" name="req_m" size="2" value="<%=t_bean.getTax_dt().substring(4,6)%>" class="whitetext" onBlur="javascript:document.form1.tax_m.value=this.value;"></td>
              <td class=ledger_contC style="BORDER-RIGHT: #0166a9 1px solid; BORDER-TOP: #0166a9 1px solid; BORDER-LEFT: #0166a9 1px solid; BORDER-BOTTOM: #0166a9 2px solid" height=25 align="center"><input type="text" name="req_d" size="2" value="<%=t_bean.getTax_dt().substring(6,8)%>" class="whitetext" onBlur="javascript:document.form1.tax_d.value=this.value;"></td>
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
                <input type="text" name="tax_g" size="25" value="<%=t_bean.getTax_g()%>" class="taxtext">
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
                          <input type="radio" name="pubform" value="D" <%if(t_bean.getPubForm().equals("D")){%>checked<%}%>>청구 </td>
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
        </table></td>
    </tr>	
    <tr>
      <td colspan="2" align="right">
	  
	  </td>
    </tr>
    <%if(!ti_bean.getItem_id().equals("")){%>
    <tr>
      <td colspan="2"><a href="javascript:DocPrint()"><img src="../../images/printer.gif" border="0"></a></td>
    </tr>
    <tr>
      <td colspan="2"><table width="100%" border="0" cellspacing="0" cellpadding="0">
        <tr>
          <td style="border: #000000 2px solid" align="center" valign="middle"><table width="95%" border="0" cellspacing="0" cellpadding="0" height="95%">
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
                <td>&nbsp;</td>
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
                            <td height="30" align="center" style="border-left: #000000 1px solid; border-bottom: #000000 1px solid"><span class="ledger_cont"><%=br.get("TEL")%></span>&nbsp;</td>
                            <td height="30" align="center" style="border-left: #000000 1px solid; border-bottom: #000000 1px solid">팩스</td>
                            <td height="30" align="center" style="border-left: #000000 1px solid; border-bottom: #000000 1px solid; border-right: #000000 1px solid;"><span class="ledger_cont"><%=br.get("FAX")%></span>&nbsp;</td>
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
                            <td height="22" colspan="3">&nbsp;&nbsp;<span class="ledger_cont">
							<%if(site.getR_site().equals("")){%>
							<%=client.getFirm_nm()%>
							<%}else{%>
							<%	if(site.getClient_id().equals("000222")){%>
							<%=client.getFirm_nm()%>							
							<%	}%>
							<%}%>
							&nbsp;<%=site.getR_site()%>
							</span></td>
                          </tr>
                          <tr>
                            <td height="22" colspan="5"><b>아래와 같이 계산합니다.</b></td>
                          </tr>
                          <tr>
                            <td height="22">합&nbsp;계&nbsp;금&nbsp;액</td>
                            <td height="22" align="center">:</td>
                            <td height="22" width="10%" style="border-bottom: #000000 1px solid">일금</td>
                            <td height="22" style="border-bottom: #000000 1px solid" align="right" width="48%"><span class="ledger_cont"><%=ti_bean.getItem_hap_str()%></span></td>
                            <td height="22" align="right" style="border-bottom: #000000 1px solid">정(①+②)</td>
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
                      <td rowspan="2" width="80" style="border-top: #000000 1px solid; border-left: #000000 1px solid; border-bottom: #000000 1px solid">거래구분</td>
                      <td rowspan="2" width="90" style="border-top: #000000 1px solid; border-left: #000000 1px solid; border-bottom: #000000 1px solid">차량번호</td>
                      <td rowspan="2" style="border-top: #000000 1px solid; border-left: #000000 1px solid; border-bottom: #000000 1px solid" bgcolor="#CCCCCC">차명</td>
                      <td height="20" colspan="2" style="border-top: #000000 1px solid; border-left: #000000 1px solid; border-bottom: #000000 1px solid">청구(거래)기준일</td>
                      <td rowspan="2" width="70" style="border-top: #000000 1px solid; border-left: #000000 1px solid; border-bottom: #000000 1px solid">공급가액</td>
                      <td rowspan="2" width="60" style="border-top: #000000 1px solid; border-left: #000000 1px solid; border-bottom: #000000 1px solid">세액</td>
                      <td rowspan="2" width="70" style="border-top: #000000 1px solid; border-left: #000000 1px solid; border-bottom: #000000 1px solid; border-right: #000000 1px solid;">합계</td>
                    </tr>
                    <tr>
                      <td height="20" width="70" bgcolor="#CCCCCC" align="center" style="border-left: #000000 1px solid; border-bottom: #000000 1px solid">~부터</td>
                      <td height="20" width="70" bgcolor="#CCCCCC" align="center" style="border-left: #000000 1px solid; border-bottom: #000000 1px solid">~까지</td>
                    </tr>
                    <% for(int i = 0 ; i < til_size ; i++){
										    TaxItemListBean til_bean = (TaxItemListBean)tils.elementAt(i);%>
                    <tr>
                      <td height="22" align="center" style="border-left: #000000 1px solid; border-bottom: #000000 1px solid"><%=i+1%></td>
                      <td height="22" align="center" style="border-left: #000000 1px solid; border-bottom: #000000 1px solid"><%=til_bean.getItem_g()%></td>
                      <td height="22" align="center" style="border-left: #000000 1px solid; border-bottom: #000000 1px solid">&nbsp;<%=til_bean.getItem_car_no()%></td>
                      <td height="22" align="center" style="border-left: #000000 1px solid; border-bottom: #000000 1px solid">&nbsp;<%=til_bean.getItem_car_nm()%></td>
                      <td height="22" align="center" style="border-left: #000000 1px solid; border-bottom: #000000 1px solid">&nbsp;<%=AddUtil.ChangeDate2(til_bean.getItem_dt1())%></td>
                      <td height="22" align="center" style="border-left: #000000 1px solid; border-bottom: #000000 1px solid">&nbsp;<%=AddUtil.ChangeDate2(til_bean.getItem_dt2())%></td>
                      <td height="22" align="right" style="border-left: #000000 1px solid; border-bottom: #000000 1px solid"><%=Util.parseDecimal(til_bean.getItem_supply())%>&nbsp;</td>
                      <td height="22" align="right" style="border-left: #000000 1px solid; border-bottom: #000000 1px solid"><%=Util.parseDecimal(til_bean.getItem_value())%>&nbsp;</td>
                      <td height="22" align="right" style="border-left: #000000 1px solid; border-bottom: #000000 1px solid; border-right: #000000 1px solid"><%=Util.parseDecimal(til_bean.getItem_supply()+til_bean.getItem_value())%>&nbsp;</td>
                    </tr>
                    <%  item_s_amt = item_s_amt  + Long.parseLong(String.valueOf(til_bean.getItem_supply()));
										    item_v_amt = item_v_amt  + Long.parseLong(String.valueOf(til_bean.getItem_value()));
									     }%>
                    <% if(til_size < 10){%>
                    <% for(int i = 0 ; i < 10-til_size ; i++){%>
                    <tr>
                      <td height="22" align="center" style="border-left: #000000 1px solid; border-bottom: #000000 1px solid">&nbsp;</td>
                      <td height="22" align="center" style="border-left: #000000 1px solid; border-bottom: #000000 1px solid">&nbsp;</td>
                      <td height="22" align="center" style="border-left: #000000 1px solid; border-bottom: #000000 1px solid">&nbsp;</td>
                      <td height="22" align="center" style="border-left: #000000 1px solid; border-bottom: #000000 1px solid">&nbsp;</td>
                      <td height="22" align="center" style="border-left: #000000 1px solid; border-bottom: #000000 1px solid">&nbsp;</td>
                      <td height="22" align="center" style="border-left: #000000 1px solid; border-bottom: #000000 1px solid">&nbsp;</td>
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
                      <td height="22" style="border-left: #000000 1px solid; border-bottom: #000000 1px solid; border-right: #000000 1px solid" align="right"><%=Util.parseDecimal(item_s_amt+item_v_amt)%>&nbsp;</td>
                    </tr>
                </table></td>
              </tr>
              <tr>
                <td colspan="3"><font size="1">※ 일할계산(대여료) : (월대여료ⅹ대여일수)÷30일</font></td>
              </tr>
			  <!--
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
                    <%//for(int i = 0 ; i < item_size2 ; i++){
										//Hashtable item2 = (Hashtable)items2.elementAt(i);%>
                    <tr>
                      <td height="22" align="center" style="border-left: #000000 1px solid; border-bottom: #000000 1px solid">&nbsp;</td>
                      <td height="22" align="center" style="border-left: #000000 1px solid; border-bottom: #000000 1px solid">&nbsp;</td>
                      <td height="22" align="right" style="border-left: #000000 1px solid; border-bottom: #000000 1px solid">&nbsp;</td>
                      <td height="22" align="center" style="border-left: #000000 1px solid; border-bottom: #000000 1px solid; border-right: #000000 1px solid">&nbsp;</td>
                    </tr>
                    <%	//		item_s_amt2 = item_s_amt2  + Long.parseLong(String.valueOf(item2.get("ITEM_KI_PR")));
									//}%>
                    <%	//	for(int i = 0 ; i < 5-item_size2 ; i++){%>
                    <tr>
                      <td height="22" align="center" style="border-left: #000000 1px solid; border-bottom: #000000 1px solid">&nbsp;</td>
                      <td height="22" align="center" style="border-left: #000000 1px solid; border-bottom: #000000 1px solid">&nbsp;</td>
                      <td height="22" align="right" style="border-left: #000000 1px solid; border-bottom: #000000 1px solid">&nbsp;</td>
                      <td height="22" align="center" style="border-left: #000000 1px solid; border-bottom: #000000 1px solid; border-right: #000000 1px solid">&nbsp;</td>
                    </tr>
                    <%	//}%>
                    <tr>
                      <td height="22" colspan="2" align="center" style="border-left: #000000 1px solid; border-bottom: #000000 1px solid" bgcolor="#CCCCCC"><font size="3"><b>합계(②)</b></font></td>
                      <td height="22" style="border-left: #000000 1px solid; border-bottom: #000000 1px solid" align="right">&nbsp;</td>
                      <td height="22" style="border-left: #000000 1px solid; border-bottom: #000000 1px solid; border-right: #000000 1px solid">&nbsp;</td>
                    </tr>
                </table></td>
              </tr>-->
              <tr>
                <td height="20">&nbsp;</td>
                <td height="20">&nbsp;</td>
                <td height="20">&nbsp;</td>
              </tr>
          </table></td>
        </tr>
      </table></td>
    </tr>
    <tr>
      <td colspan="2">&nbsp;</td>
    </tr>	
    <%}%>    
    <tr>
      <td colspan="2" align="right">&nbsp;	</td>
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
