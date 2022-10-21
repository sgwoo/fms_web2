<%@ page language="java" contentType="text/html;charset=euc-kr" %>
<%@ page import="java.util.*, acar.util.*, acar.cont.*, acar.fee.*, acar.credit.*, acar.common.*, tax.*, acar.bill_mng.*, acar.client.*, acar.cls.*"%>
<jsp:useBean id="ClientMngDb" scope="page" class="tax.ClientMngDatabase"/>
<jsp:useBean id="ScdMngDb" scope="page" class="tax.ScdMngDatabase"/>
<jsp:useBean id="a_db" scope="page" class="acar.cont.AddContDatabase"/>
<jsp:useBean id="af_db" scope="page" class="acar.fee.AddFeeDatabase"/>
<jsp:useBean id="as_db" scope="page" class="acar.cls.AddClsDatabase"/>
<jsp:useBean id="al_db" scope="page" class="acar.client.AddClientDatabase"/>
<jsp:useBean id="rs_db" scope="page" class="acar.res_search.ResSearchDatabase"/>
<jsp:useBean id="ac_db" scope="page" class="acar.credit.AccuDatabase"/>
<%@ include file="/tax/cookies_base.jsp" %>

<%
	CommonDataBase c_db = CommonDataBase.getInstance();
	
	String rent_mng_id 	= request.getParameter("rent_mng_id")==null?"":request.getParameter("rent_mng_id");
	String rent_l_cd 	= request.getParameter("rent_l_cd")==null?"":request.getParameter("rent_l_cd");
	String car_mng_id 	= request.getParameter("car_mng_id")==null?"":request.getParameter("car_mng_id");
	String client_id 	= request.getParameter("client_id")==null?"":request.getParameter("client_id");
	String site_id 		= request.getParameter("site_id")==null?"":request.getParameter("site_id");
	String mode = request.getParameter("mode")==null?"":request.getParameter("mode");
	int tae_sum = 0;
	int max_table_line = 3;
	int height = 0;
	int cnt = 0;
	String tax_supply = "";
	String tax_value = "";
	String tax_yn = "N";
	String tax_branch 	= "";
	
	//로그인ID&영업소ID
	LoginBean login = LoginBean.getInstance();
	if(user_id.equals("")) 	user_id = login.getCookieValue(request, "acar_id");
	if(br_id.equals(""))	br_id = login.getCookieValue(request, "acar_br");
	if(auth_rw.equals(""))	auth_rw = rs_db.getAuthRw(user_id, "05", "06", "15");
	
	//계약:고객관련
	ContBaseBean base 		= a_db.getContBaseAll(rent_mng_id, rent_l_cd);
	if(base.getTax_type().equals("2")){//지점
		site_id = base.getR_site();
	}else{
		site_id = "";
	}
	
	//대여정보
	ContFeeBean fee = a_db.getContFee(rent_mng_id, rent_l_cd, "1");
	tax_branch = fee.getBr_id()==""?br_id:fee.getBr_id();
	
	String br_bigo = "";	
	//20090701부터 사업자단위과세
	if(!tax_branch.equals("S1") &&  AddUtil.parseInt(AddUtil.getDate(4)) > 20090631 ){
			
			//종사업장
			Hashtable br2 = c_db.getBranch(tax_branch);
			
			br_bigo = String.valueOf(br2.get("BR_NM"));
			tax_branch = "S1";
		//	t_bean.setBranch_g("S1");
		//	t_bean.setBranch_g2(String.valueOf(ht.get("BR_ID")));
	}
	
	
	//거래처정보
	ClientBean client = al_db.getClient(client_id);
	
	//네오엠 거래처 정보
	NeoErpUDatabase neoe_db = NeoErpUDatabase.getInstance();
	Hashtable ven = neoe_db.getVendorCase(client.getVen_code());
	
	//지점/현장
	Vector c_sites = ClientMngDb.getClientSites(client_id, "1");
	int c_site_size = c_sites.size();
	
	String i_enp_no = client.getEnp_no1() +"-"+ client.getEnp_no2() +"-"+ client.getEnp_no3();
	if(client.getEnp_no1().equals("")) i_enp_no = client.getSsn1() +"-"+ client.getSsn2();
	String i_firm_nm 	= client.getFirm_nm();
	String i_client_nm 	= client.getClient_nm();
	String i_addr 		= client.getO_addr();
	String i_sta 		= client.getBus_cdt();
	String i_item 		= client.getBus_itm();
	String i_taxregno	= client.getTaxregno();
	if(!site_id.equals("")){
		//거래처지점정보
		ClientSiteBean site = al_db.getClientSite(client_id, site_id);
		i_enp_no 		= site.getEnp_no();
		i_firm_nm 		= site.getR_site();
		i_client_nm 	= site.getSite_jang();
		i_addr 			= site.getAddr();
		i_sta 			= site.getBus_cdt();
		i_item 			= site.getBus_itm();
		i_taxregno		= site.getTaxregno();
	}
	
	Vector branches = c_db.getBranchs(); //영업소 리스트 조회
	int brch_size = branches.size();
	
	Hashtable br = c_db.getBranch(tax_branch); //소속영업소 리스트 조회
		
	Vector grts = new Vector();
	int grt_size = 0;
	if(!client_id.equals("")){
		grts = ScdMngDb.getClsContScdListNew("", rent_l_cd, "N");
		grt_size = grts.size();	
	}
	
	//기본정보
	Hashtable fee_base = af_db.getFeebasecls3(rent_mng_id, rent_l_cd);
	
	//해지정보
	ClsBean cls = as_db.getClsCase(rent_mng_id, rent_l_cd);
	
	
	//세금계산서 발행관련 - 해지정산시 미발행계산서  추가 발행
	ClsEtcTaxBean ct = ac_db.getClsEtcTaxCase(rent_mng_id, rent_l_cd);
%>

<html>
<head>
<title>FMS</title>
<meta http-equiv="content-type" content="text/html; charset=euc-kr">
<link rel="stylesheet" type="text/css" href="/include/table_t.css">
<script language="JavaScript" src="/include/common.js"></script>
<script language="JavaScript">
<!--
	//발행
	function tax_reg(){
		   
	   var fm = document.form1;	
		if(fm.tax_r_chk0.checked == false && fm.tax_r_chk1.checked == false && fm.tax_r_chk2.checked == false && fm.tax_r_chk3.checked == false && fm.tax_r_chk4.checked == false && fm.tax_r_chk5.checked == false && fm.tax_r_chk6.checked == false && fm.tax_r_chk7.checked == false ){	alert('세금계산서 발행할 항목을 선택하십시오.'); return; }
		
		if(fm.tax_dt.value == ''){ 	alert('세금계산서일자를 입력하십시오'); 	fm.tax_dt.focus(); 	return;	}
			
		if( toInt(parseDigit(fm.tax_rr_supply[3].value)) == 0 && toInt(parseDigit(fm.tax_rr_supply[4].value)) == 0 && toInt(parseDigit(fm.tax_rr_supply[5].value)) == 0 && toInt(parseDigit(fm.tax_rr_supply[6].value)) == 0 && toInt(parseDigit(fm.tax_rr_supply[7].value)) == 0 ){	alert('세금계산서 발행할 금액을 입력하십시오.'); return; }
							
		if(confirm('수시발행 하시겠습니까?'))
		{			
			fm.target = "i_no";
			fm.action = "cls_i_tax_a.jsp";
			fm.submit();						
		}
	}

	//공급자 셋팅
	function out_set(){
		var fm = document.form1;
		var o_brch = fm.o_enp_no.options[fm.o_enp_no.selectedIndex].value;
		var o_brch_split 	= o_brch.split("||");
		fm.o_br_id.value 	= o_brch_split[0];
		fm.o_addr.value 	= o_brch_split[1];
		fm.o_item.value 	= o_brch_split[2];
		fm.o_sta.value 		= o_brch_split[3];				
	}
	
	//공급받는자 셋팅
	function in_set(){
		var fm = document.form1;
		var i_brch = fm.i_enp_no.options[fm.i_enp_no.selectedIndex].value;
		var i_brch_split 	= i_brch.split("||");
		fm.i_site_id.value 	= i_brch_split[0];
		fm.i_firm_nm.value 	= i_brch_split[1];
		fm.i_client_nm.value= i_brch_split[2];
		fm.i_addr.value 	= i_brch_split[3];				
		fm.i_item.value 	= i_brch_split[4];
		fm.i_sta.value 		= i_brch_split[5];		
		fm.i_taxregno.value = i_brch_split[6];		
	}	
	
	//목록가기
	function go_list(){
		var fm = document.form1;
		fm.target = "d_content";
		fm.action = "issue_3_frame7.jsp";
		fm.submit();
	}
	
	

	
	function view_client(m_id, l_cd, r_st)
	{
		window.open("/fms2/con_fee/con_fee_client_s.jsp?m_id="+m_id+"&l_cd="+l_cd+"&r_st="+r_st, "VIEW_CLIENT", "left=100, top=100, width=720, height=550, scrollbars=yes");
	}
	
	function set_cls_tax_value(v_type){
		var fm = document.form1;
		
		if(v_type == '1'){ // 미납대여료
			fm.tax_rr_value[3].value 	= parseDecimal( toInt(parseDigit(fm.tax_rr_supply[3].value)) * 0.1 );	
		} else if(v_type == '2' ){ // 해지정산금
			fm.tax_rr_value[4].value 	= parseDecimal( toInt(parseDigit(fm.tax_rr_supply[4].value)) * 0.1 );		
		} else if(v_type == '3'){ // 외주비용
			fm.tax_rr_value[5].value 	= parseDecimal( toInt(parseDigit(fm.tax_rr_supply[5].value)) * 0.1 );	
		} else if(v_type == '4'){ // 부대비용
			fm.tax_rr_value[6].value 	= parseDecimal( toInt(parseDigit(fm.tax_rr_supply[6].value)) * 0.1 );	
		} else if(v_type == '5'){ // 손해배상금
			fm.tax_rr_value[7].value 	= parseDecimal( toInt(parseDigit(fm.tax_rr_supply[7].value)) * 0.1 );	
		}	
			
	    set_cls_tax_hap();				   
	}
	
	
	function set_cls_tax_hap(){
		var fm = document.form1;		
		
		fm.tax_rr_hap[2].value 	= parseDecimal( toInt(parseDigit(fm.tax_rr_supply[2].value)) +  toInt(parseDigit(fm.tax_rr_value[2].value)));	
		fm.tax_rr_hap[3].value 	= parseDecimal( toInt(parseDigit(fm.tax_rr_supply[3].value)) +  toInt(parseDigit(fm.tax_rr_value[3].value)));	
		fm.tax_rr_hap[4].value 	= parseDecimal( toInt(parseDigit(fm.tax_rr_supply[4].value)) +  toInt(parseDigit(fm.tax_rr_value[4].value)));	
		fm.tax_rr_hap[5].value 	= parseDecimal( toInt(parseDigit(fm.tax_rr_supply[5].value)) +  toInt(parseDigit(fm.tax_rr_value[5].value)));	
		fm.tax_rr_hap[6].value 	= parseDecimal( toInt(parseDigit(fm.tax_rr_supply[6].value)) +  toInt(parseDigit(fm.tax_rr_value[6].value)));	
		fm.tax_rr_hap[7].value 	= parseDecimal( toInt(parseDigit(fm.tax_rr_supply[7].value)) +  toInt(parseDigit(fm.tax_rr_value[7].value)));	
		
		fm.r_tax_supply.value = 0;
		fm.r_tax_value.value = 0;	
		fm.r_tax_hap.value = 0;	
				
		for(var i=0 ; i<8 ; i++){
		
		  fm.r_tax_supply.value    	= parseDecimal( toInt(parseDigit(fm.r_tax_supply.value)) + toInt(parseDigit(fm.tax_rr_supply[i].value)) );
		  fm.r_tax_value.value     	= parseDecimal( toInt(parseDigit(fm.r_tax_value.value)) + toInt(parseDigit(fm.tax_rr_value[i].value)) );
		}
	
		fm.r_tax_hap.value    		= parseDecimal( toInt(parseDigit(fm.r_tax_supply.value)) + toInt(parseDigit(fm.r_tax_value.value)) );   
		   
	}
			
//-->
</script>

</head>
<body>
<form action="./issue_3_sc_a.jsp" name="form1" method="POST">
<%@ include file="/include/search_hidden.jsp" %>
  <input type="hidden" name="idx" value="<%=idx%>">
  <input type="hidden" name="client_id" value="<%=client_id%>">
  <input type="hidden" name="site_id" value="<%=site_id%>">  
  <input type="hidden" name="rent_mng_id" value="<%=rent_mng_id%>">
  <input type="hidden" name="rent_l_cd" value="<%=rent_l_cd%>">      
  <input type="hidden" name="car_mng_id" value="<%=fee_base.get("CAR_MNG_ID")%>">  
  <input type="hidden" name="mode" value="<%=mode%>">  
  <input type="hidden" name="scd_size" value="<%=grt_size%>">
  <input type="hidden" name="count" value="0">
  <input type="hidden" name="tax_type" value="<%=base.getTax_type()%>">  
  <input type="hidden" name="firm_nm" value="<%=fee_base.get("FIRM_NM")%>">  
  <input type="hidden" name="br_bigo" value="<%=br_bigo%>">
      
  <table width=100% border=0 cellpadding=0 cellspacing=0>
	<tr>
		<td colspan=10>
			<table width=100% border=0 cellpadding=0 cellspacing=0>
				<tr>
					<td width=7><img src=/acar/images/center/menu_bar_1.gif width=7 height=33></td>
					<td class=bar>&nbsp;&nbsp;&nbsp;<img src=/acar/images/center/menu_bar_dot.gif width=4 height=5 align=absmiddle>&nbsp;<span class=style1>재무회계 > 세금계산서발행 > 수시발행 > <span class=style5>
						해지정산</span></span></td>
					<td width=7><img src=/acar/images/center/menu_bar_2.gif width=7 height=33></td>
				</tr>
			</table>
		</td>
	</tr>
	<tr>
		<td class=h></td>
	</tr>  
	<tr>
	    <td align="right" colspan=2><a href="javascript:go_list();"><img src="/acar/images/center/button_list.gif" align="absmiddle" border="0"></a></td>  
	</tr>
	<tr><td class=line2 colspan=2></td></tr>  
    <tr> 
      <td class='line' colspan="2"> 
        <table border="0" cellspacing="1" cellpadding="0" width=100%>	
          <tr> 
            <td width='10%' class='title'>계약번호</td>
            <td width="15%">&nbsp;<%=rent_l_cd%></td>
            <td width='10%' class='title'>상호</td>
            <td colspan="3">&nbsp;<%=fee_base.get("FIRM_NM")%></td>
            <td class='title' width="10%">고객명</td>
            <td width="15%">&nbsp;<%=fee_base.get("CLIENT_NM")%></td>
          </tr>
          <tr> 
            <td class='title' width="10%">차량번호</td>
            <td width="15%">&nbsp;<%=fee_base.get("CAR_NO")%></td>
            <td width='10%' class='title'>차명</td>
            <td colspan="3">&nbsp;<%=fee_base.get("CAR_NM")%></td>
            <td class='title' width="10%">최초등록일</td>
            <td>&nbsp;<%=fee_base.get("INIT_REG_DT")%></td>
          </tr>
          <tr> 
            <td class='title' width="10%">대여방식</td>
            <td width="15%">&nbsp;
              <%if(!fee_base.get("RENT_WAY").equals("1")){%>
              일반식 
              <%}else if(fee_base.get("RENT_WAY").equals("2")){%>
              맞춤식 
              <%}else{%>
              기본식 
              <%}%>
              </td>
            <td class='title' width="10%">대여기간</td>
            <td colspan="3">&nbsp;<%=fee_base.get("RENT_START_DT")%>~&nbsp; 
              <%if(fee_base.get("RENT_ST").equals("1")){ out.println(fee_base.get("RENT_END_DT")); }else{ out.println(fee_base.get("EX_RENT_END_DT")); }%>
            </td>
            <td class='title' width="10%">계약기간</td>
            <td>&nbsp;<%=fee_base.get("TOT_CON_MON")%> 개월</td>
          </tr>
          <tr> 
            <td class='title' width="10%">월대여료</td>
            <td width="15%">&nbsp; 
              <%if(fee_base.get("RENT_ST").equals("1")){%>
              <%=AddUtil.parseDecimal(AddUtil.parseInt((String)fee_base.get("FEE_AMT")))%> 
              <%}else{%>
              <%=AddUtil.parseDecimal(AddUtil.parseInt((String)fee_base.get("EX_FEE_AMT")))%> 
              <%}%>
              원</td>
            <td class='title' width="10%">선납금</td>
            <td width="15%">&nbsp; 
              <%if(fee_base.get("RENT_ST").equals("1")){%>
              <%=AddUtil.parseDecimal((String)fee_base.get("PP_AMT"))%> 
              <%}else{%>
              <%=AddUtil.parseDecimal((String)fee_base.get("EX_PP_AMT"))%> 
              <%}%>
              원</td>
            <td class='title' width="10%">개시대여료</td>
            <td width="15%">&nbsp; 
              <%if(fee_base.get("RENT_ST").equals("1")){%>
              <%=AddUtil.parseDecimal((String)fee_base.get("IFEE_AMT"))%> 
              <%}else{%>
              <%=AddUtil.parseDecimal((String)fee_base.get("EX_IFEE_AMT"))%> 
              <%}%>
              원</td>
            <td class='title' width="10%">보증금</td>
            <td>&nbsp; 
              <%if(fee_base.get("RENT_ST").equals("1")){%>
              <%=AddUtil.parseDecimal((String)fee_base.get("GRT_AMT"))%> 
              <%}else{%>
              <%=AddUtil.parseDecimal((String)fee_base.get("EX_GRT_AMT"))%> 
              <%}%>
              원</td>
          </tr>
        </table>
      </td>
    </tr>
    <tr> 
      <td colspan="2" class=h></td>
    </tr>
    <tr><td class=line2 colspan=2></td></tr>
    <tr>
      <td colspan="2" class="line"> 
        <table border="0" cellspacing="1" cellpadding="0" width=100%>
          <tr> 
            <td width='10%' class='title'>해지구분</td>
            <td width="15%">&nbsp;<%=cls.getCls_st()%> 
            </td>
            <td width='10%' class='title'>해지일</td>
            <td width="15%">&nbsp;<%=cls.getCls_dt()%> 
            </td>
            <td class='title' width="10%">이용기간</td>
            <td width="40%">&nbsp;<%=cls.getR_mon()%>개월 <%=cls.getR_day()%>일
              </td>
          </tr>
          <tr> 
            <td width='10%' class='title'>해지내역 </td>
            <td colspan="5">&nbsp;<%=cls.getCls_cau()%>
            </td>
          </tr>
        </table>
      </td>
    </tr>
    <tr> 
      <td colspan="2"></td>
    </tr> 		
    <tr>
      <td colspan="2"><table width="100%"  border="0" cellpadding="0" cellspacing="0">
        <tr>
          <td width="49%"><img src=/acar/images/center/icon_arrow.gif align=absmiddle> <span class=style2>공급받는자</span></td>
          <td width="1%">&nbsp;</td>
          <td width="50%"><img src=/acar/images/center/icon_arrow.gif align=absmiddle> <span class=style2>공급자</span></td>
        </tr>
        <tr>
          <td class="line">
          <table border="0" cellspacing="1" cellpadding="0" width='100%'>
            <tr><td class=line2 style='height:1'></td></tr>
            <tr>
              <td width='20%' class='title'>등록번호</td>
              <td colspan="3">&nbsp;
			  <input type="hidden" name="i_site_id" value="<%=site_id%>">
			    <select name='i_enp_no' onChange='javascript:in_set();'>
				<%if(c_site_size > 0){%>
		          <option value=''>선택</option>
				<%}%>  
		          <option value='00||<%=client.getFirm_nm()%>||<%=client.getClient_nm()%>||<%=client.getO_addr()%>||<%=client.getBus_cdt()%>||<%=client.getBus_itm()%>||<%=client.getTaxregno()%>' <%if(site_id.equals("")){%>selected<%}%>><%if(!client.getEnp_no1().equals("")){%><%=client.getEnp_no1()%>-<%=client.getEnp_no2()%>-<%=client.getEnp_no3()%> 본사<%}else{%><%=client.getSsn1()%>-<%=client.getSsn2()%><%}%></option>				  
					<%	for(int i = 0 ; i < c_site_size ; i++){
							ClientSiteBean site = (ClientSiteBean)c_sites.elementAt(i);%>	  		

			      <option value='<%=site.getSeq()%>||<%=site.getR_site()%>||<%=site.getSite_jang()%>||<%=site.getAddr()%>||<%=site.getBus_itm()%>||<%=site.getBus_cdt()%>||<%=site.getTaxregno()%>' <%if(site_id.equals(site.getSeq())){%>selected<%}%>><%=AddUtil.ChangeSsn(AddUtil.ChangeEnp(site.getEnp_no()))%> <%=Util.subData(site.getR_site(), 15)%></option>
          			<%	}%>
		        </select>	
				&nbsp;(종사업장번호 : <input type="text" name="i_taxregno" size="4" value="<%=i_taxregno%>" class="whitetext" readonly>)	 		 			    
			    </td>
              </tr>
            <tr>
              <td class='title'>상호(법인명)</td>
              <td colspan="3">&nbsp;<input type="text" name="i_firm_nm" size="50" value="<%=i_firm_nm%>" class="whitetext" readonly></td>
              </tr>
            <tr>
              <td class='title'>성명</td>
              <td colspan="3">&nbsp;<input type="text" name="i_client_nm" size="50" value="<%=i_client_nm%>" class="whitetext" readonly></td>
              </tr>
            <tr>
              <td class='title'>사업장주소</td>
              <td colspan="3">&nbsp;<input type="text" name="i_addr" size="50" value="<%=i_addr%>" class="whitetext" readonly></td>
            </tr>
            <tr>
              <td class='title'>업태</td>
              <td width="30%">&nbsp;<input type="text" name="i_sta" size="16" value="<%=i_sta%>" class="whitetext" readonly></td>
              <td width="15%" class='title'>종목</td>
              <td width="35%">&nbsp;<input type="text" name="i_item" size="20" value="<%=i_item%>" class="whitetext" readonly></td>
            </tr>
          </table></td>
          <td>&nbsp;</td>
          <td class="line">
            <table border="0" cellspacing="1" cellpadding="0" width='100%'>
            <tr><td class=line2 style='height:1'></td></tr>
            <tr>
              <td width='20%' class='title'>등록번호</td>
              <td colspan="3">&nbsp;
			    <input type="hidden" name="o_br_id" value="<%=br.get("BR_ID")%>">  
			    <select name='o_enp_no' onChange='javascript:out_set();'>
		          <option value=''>선택</option>
          			<%	if(brch_size > 0){
							for (int i = 0 ; i < brch_size ; i++){
								Hashtable branch = (Hashtable)branches.elementAt(i);%>
			      <option value='<%=branch.get("BR_ID")%>||<%=branch.get("BR_ADDR")%>||<%=branch.get("BR_ITEM")%>||<%=branch.get("BR_STA")%>'  <%if(tax_branch.equals(String.valueOf(branch.get("BR_ID")))){%>selected<%}%>><%= AddUtil.ChangeEnp(String.valueOf(branch.get("BR_ENT_NO")))%> <%= branch.get("BR_NM")%></option>
          			<%		}
						}%>
		        </select>			  
			  </td>
            </tr>
            <tr>
              <td class='title'>상호(법인명)</td>
              <td colspan="3">&nbsp;(주)아마존카</td>
            </tr>
            <tr>
              <td class='title'>성명</td>
              <td colspan="3">&nbsp;<%=br.get("BR_OWN_NM")%></td>
            </tr>
            <tr>
              <td class='title'>사업장주소</td>
              <td colspan="3">&nbsp;<input type="text" name="o_addr" size="50" value="<%=br.get("BR_ADDR")%>" class="whitetext" readonly></td>
            </tr>
            <tr>
              <td class='title'>업태</td>
              <td width="30%">&nbsp;<input type="text" name="o_sta" size="16" value="<%=br.get("BR_STA")%>" class="whitetext" readonly></td>
              <td width="15%" class='title'>종목</td>
              <td width="35%">&nbsp;<input type="text" name="o_item" size="20" value="<%=br.get("BR_ITEM")%>" class="whitetext" readonly></td>
            </tr>
          </table></td>
        </tr>
      </table></td>
    </tr>		
    <tr>
      <td colspan="2" class=h></td>
    </tr>
  <input type="hidden" name="rifee_s_amt" value="<%=AddUtil.parseDecimal(cls.getRifee_s_amt())%>">
  <input type="hidden" name="rfee_s_amt" value="<%=AddUtil.parseDecimal(cls.getRfee_s_amt())%>">
  <input type="hidden" name="nfee_amt" value="<%=AddUtil.parseDecimal(cls.getNfee_amt())%>">
  <input type="hidden" name="dly_amt" value="<%=AddUtil.parseDecimal(cls.getDly_amt())%>">
  <input type="hidden" name="dft_amt" value="<%=AddUtil.parseDecimal(cls.getDft_amt())%>">
  <input type="hidden" name="car_ja_amt" value="<%=AddUtil.parseDecimal(cls.getCar_ja_amt())%>">
  <input type="hidden" name="etc_amt" value="<%=AddUtil.parseDecimal(cls.getEtc_amt())%>">
  <input type="hidden" name="etc2_amt" value="<%=AddUtil.parseDecimal(cls.getEtc2_amt())%>">
  <input type="hidden" name="etc4_amt" value="<%=AddUtil.parseDecimal(cls.getEtc4_amt())%>">
  <input type="hidden" name="car_no" value="<%=fee_base.get("CAR_NO")%>">  
  <input type="hidden" name="car_nm" value="<%=fee_base.get("CAR_NM")%>">    
      <tr> 
        <td colspan="2" align='left' ><img src=/acar/images/center/icon_arrow.gif align=absmiddle> <span class=style2>세금계산서</span></td>
      </tr>
      <tr>
        <td colspan="2" class=line2></td>
      </tr>
      <tr>
        <td class=line>
            <table width=100%  border=0 cellspacing=1 cellpadding=0>
               <tr> 
                 <td class='title' width="10%"> 세금계산서발행일</td>
        	     <td width="90%">&nbsp;<input type='text' name='tax_dt' size='11' class='text' onBlur='javascript: this.value = ChangeDate(this.value)'></td>          
               </tr>
            </table>
        </td>        
      </tr>    
                           
      <tr>
        <td class=line>
            <table width=100%  border=0 cellspacing=1 cellpadding=0>
               <tr> 
                  <td width="3%" rowspan="2" class='title'>연번</td>
                  <td colspan="4" class='title'>예정</td>
                  <td colspan="6" class='title'>발행</td>                
                </tr>
                <tr> 
               	  <td width="10%" class='title'>정산항목</td>          
   				  <td width="10%" class='title'>공급가</td> 
   				  <td width="10%" class='title'>부가세</td>       
   				  <td width="10%" class='title'>합계</td>                     
                  <td width="13%" class='title'>품목</td>
                  <td width="10%" class='title'>공급가</td>
                  <td width="10%" class='title'>부가세</td>
                  <td width="10%" class='title'>합계</td>
                  <td width="13%" class='title'>비고</td>
                  <td width="3%" class='title'>발행</td>
                </tr>
                <tr> 
                  <td height="23" align="center">1</td>
                  <td align="center">잔여개시대여료</td>
                  <td align='center'><input type='text' name='tax_r_supply' readonly size='12' class='num' value='<%=AddUtil.parseDecimal(ct.getRifee_s_amt_s())%>' onBlur='javascript:this.value=parseDecimal(this.value);'> 원</td>
                  <td align='center'><input type='text' name='tax_r_value' readonly size='12' class='num' value='<%=AddUtil.parseDecimal(ct.getRifee_s_amt_v())%>' onBlur='javascript:this.value=parseDecimal(this.value);'> 원</td>
                  <td align='center'><input type='text' name='tax_r_hap' readonly size='12' class='num' value='<%=AddUtil.parseDecimal(ct.getRifee_s_amt_s()+ct.getRifee_s_amt_v())%>' onBlur='javascript:this.value=parseDecimal(this.value);'> 원</td>
                  <td align="center"><input type='text' readonly name='tax_r_g' size='20' class='text' value='<%=ct.getRifee_etc()%>'></td>
                  <td align='center'><input type='text' name='tax_rr_supply' readonly size='12' class='num' value='<%=AddUtil.parseDecimal(ct.getR_rifee_s_amt_s())%>' onBlur='javascript:this.value=parseDecimal(this.value);'> 원</td>
                  <td align='center'><input type='text' name='tax_rr_value' readonly size='12' class='num'  value='<%=AddUtil.parseDecimal(ct.getR_rifee_s_amt_v())%>' onBlur='javascript:this.value=parseDecimal(this.value);'> 원</td>
                  <td align='center'><input type='text' name='tax_rr_hap' readonly size='12' class='num' value='<%=AddUtil.parseDecimal(ct.getR_rifee_s_amt_s()+ct.getR_rifee_s_amt_v())%>'  onBlur='javascript:this.value=parseDecimal(this.value);'> 원</td>
                  <td align='center'><input type='text' readonly name='tax_r_bigo' size='22' class='text' value=''></td>
                  <td align="center"><input type='checkbox' name='tax_r_chk0' value='Y' <%if(ct.getTax_r_chk0().equals("Y")){%>checked<%}%>   ></td>
                </tr>
                <tr> 
                  <td align="center">2</td>
                  <td align="center">잔여선납금</td>
                 <td align='center'><input type='text'  readonly name='tax_r_supply' size='12' class='num' value='<%=AddUtil.parseDecimal(ct.getRfee_s_amt_s())%>'  onBlur='javascript:this.value=parseDecimal(this.value);'> 원</td>
                  <td align='center'><input type='text' readonly  name='tax_r_value' size='12' class='num' value='<%=AddUtil.parseDecimal(ct.getRfee_s_amt_v())%>'  onBlur='javascript:this.value=parseDecimal(this.value);'> 원</td>
                  <td align='center'><input type='text' readonly name='tax_r_hap' size='12' class='num' value='<%=AddUtil.parseDecimal(ct.getRfee_s_amt_s()+ct.getRfee_s_amt_v())%>' onBlur='javascript:this.value=parseDecimal(this.value);'> 원</td>
                  <td align="center"><input type='text' readonly name='tax_r_g' size='20' class='text' value='<%=ct.getRfee_etc()%>'></td>
                  <td align='center'><input type='text' readonly name='tax_rr_supply' size='12' class='num' value='<%=AddUtil.parseDecimal(ct.getR_rfee_s_amt_s())%>' onBlur='javascript:this.value=parseDecimal(this.value);'> 원</td>
                  <td align='center'><input type='text' readonly name='tax_rr_value' size='12' class='num'  value='<%=AddUtil.parseDecimal(ct.getR_rfee_s_amt_v())%>' onBlur='javascript:this.value=parseDecimal(this.value);'> 원</td>
                  <td align='center'><input type='text' readonly name='tax_rr_hap' size='12' class='num' value='<%=AddUtil.parseDecimal(ct.getR_rfee_s_amt_s()+ct.getR_rfee_s_amt_v())%>' onBlur='javascript:this.value=parseDecimal(this.value);'> 원</td>
                  <td align='center'><input type='text' readonly name='tax_r_bigo' size='22' class='text' value=''></td>
                  <td align="center"> <input type='checkbox' name='tax_r_chk1' value='Y' <%if(ct.getTax_r_chk1().equals("Y")){%>checked<%}%>   ></td>
                </tr>
                
                <tr> 
                  <td align="center">3</td>
                  <td align="center">취소대여료</td>
                  <td align='center'><input type='text' readonly name='tax_r_supply' size='12' class='num' value='<%=AddUtil.parseDecimal(ct.getDfee_c_amt_s())%>' onBlur='javascript:this.value=parseDecimal(this.value);'> 원</td>
                  <td align='center'><input type='text' readonly name='tax_r_value' size='12' class='num' value='<%=AddUtil.parseDecimal(ct.getDfee_c_amt_v())%>' onBlur='javascript:this.value=parseDecimal(this.value);'> 원</td>
                  <td align='center'><input type='text' readonly name='tax_r_hap' size='12' class='num' value='<%=AddUtil.parseDecimal(ct.getDfee_c_amt_s()+ct.getDfee_c_amt_v())%>' onBlur='javascript:this.value=parseDecimal(this.value);'> 원</td>
                  <td align="center"><input type='text' readonly name='tax_r_g' size='20' class='text' value='<%=ct.getDfee_c_etc()%>'></td>
                  <td align='center'><input type='text' readonly name='tax_rr_supply' size='12' class='num' value='<%=AddUtil.parseDecimal(ct.getR_dfee_c_amt_s())%>' onBlur='javascript:this.value=parseDecimal(this.value);'> 원</td>
                  <td align='center'><input type='text' readonly name='tax_rr_value' size='12' class='num' value='<%=AddUtil.parseDecimal(ct.getR_dfee_c_amt_v())%>' onBlur='javascript:this.value=parseDecimal(this.value);'> 원</td>
                  <td align='center'><input type='text' readonly name='tax_rr_hap' size='12' class='num' value='<%=AddUtil.parseDecimal(ct.getR_dfee_c_amt_s()+ct.getR_dfee_c_amt_v())%>' onBlur='javascript:this.value=parseDecimal(this.value);'> 원</td>
                  <td align='center'><input type='text' readonly name='tax_r_bigo' size='22' class='text' value=''></td>
                  <td align="center"><input type='checkbox' name='tax_r_chk2' value='Y' <%if(ct.getTax_r_chk2().equals("Y")){%>checked<%}%>   ></td>
                </tr>
                
                 <tr> 
                  <td align="center">4</td>
                  <td align="center">미납대여료</td>
                  <td align='center'><input type='text' readonly name='tax_r_supply' size='12' class='num' value='<%=AddUtil.parseDecimal(ct.getDfee_amt_s())%>' onBlur='javascript:this.value=parseDecimal(this.value);'> 원</td>
                  <td align='center'><input type='text' readonly name='tax_r_value' size='12' class='num' value='<%=AddUtil.parseDecimal(ct.getDfee_amt_v())%>' onBlur='javascript:this.value=parseDecimal(this.value);'> 원</td>
                  <td align='center'><input type='text' readonly name='tax_r_hap' size='12' class='num' value='<%=AddUtil.parseDecimal(ct.getDfee_amt_s()+ct.getDfee_amt_v())%>' onBlur='javascript:this.value=parseDecimal(this.value);'> 원</td>
                  <td align="center"><input type='text' readonly name='tax_r_g' size='20' class='text' value='<%=ct.getDfee_etc()%>'></td>
                  <td align='center'><input type='text' name='tax_rr_supply' size='12' class='num' value='<%=AddUtil.parseDecimal(ct.getR_dfee_amt_s())%>'  onBlur='javascript:this.value=parseDecimal(this.value); set_cls_tax_value(1);'> 원</td>
                  <td align='center'><input type='text' name='tax_rr_value' size='12' class='num' value='<%=AddUtil.parseDecimal(ct.getR_dfee_amt_v())%>'  onBlur='javascript:this.value=parseDecimal(this.value); set_cls_tax_hap();'> 원</td>
                  <td align='center'><input type='text' readonly name='tax_rr_hap' size='12' class='num' value='<%=AddUtil.parseDecimal(ct.getR_dfee_amt_s()+ct.getR_dfee_amt_v())%>' onBlur='javascript:this.value=parseDecimal(this.value);'> 원</td>
                  <td align='center'><input type='text' readonly name='tax_r_bigo' size='22' class='text' value=''></td>
                  <td align="center"><input type='checkbox' name='tax_r_chk3' value='Y' <%if(ct.getTax_r_chk3().equals("Y")){%>checked<%}%>  ></td>
                </tr>
                                            
                <tr> 
                  <td align="center">5</td>
                  <td align="center">해지위약금</td>
                  <td align='center'><input type='text' readonly name='tax_r_supply' size='12' class='num' value='<%=AddUtil.parseDecimal(ct.getDft_amt_s())%>' onBlur='javascript:this.value=parseDecimal(this.value);'> 원</td>
                  <td align='center'><input type='text' readonly name='tax_r_value' size='12' class='num'  value='<%=AddUtil.parseDecimal(ct.getDft_amt_v())%>' onBlur='javascript:this.value=parseDecimal(this.value);'> 원</td>
                  <td align='center'><input type='text' readonly name='tax_r_hap' size='12' class='num' value='<%=AddUtil.parseDecimal(ct.getDft_amt_s()+ct.getDft_amt_v())%>' onBlur='javascript:this.value=parseDecimal(this.value);'> 원</td>
                  <td align="center"><input type='text' readonly name='tax_r_g' size='20' class='text' value='<%=ct.getDft_etc()%>' ></td>
                  <td align='center'><input type='text' name='tax_rr_supply' size='12' class='num' value='<%=AddUtil.parseDecimal(ct.getR_dft_amt_s())%>' onBlur='javascript:this.value=parseDecimal(this.value); set_cls_tax_value(2);'> 원</td>
                  <td align='center'><input type='text' name='tax_rr_value' size='12' class='num' value='<%=AddUtil.parseDecimal(ct.getR_dft_amt_v())%>' onBlur='javascript:this.value=parseDecimal(this.value); set_cls_tax_hap();'> 원</td>
                  <td align='center'><input type='text' readonly name='tax_rr_hap' size='12' class='num' value='<%=AddUtil.parseDecimal(ct.getR_dft_amt_s()+ct.getR_dft_amt_v())%>' onBlur='javascript:this.value=parseDecimal(this.value);'> 원</td>
                  <td align='center'><input type='text' readonly name='tax_r_bigo' size='22' class='text' value=''></td>
                  <td align="center"><input type='checkbox' name='tax_r_chk4' value='Y' <%if(ct.getTax_r_chk4().equals("Y")){%>checked<%}%>    ></td>
                </tr>
                <tr> 
                  <td align="center">6</td>
                  <td align="center">회수외주비용</td>
                  <td align='center'><input type='text' readonly name='tax_r_supply' size='12' class='num' value='<%=AddUtil.parseDecimal(ct.getEtc_amt_s())%>' onBlur='javascript:this.value=parseDecimal(this.value);'> 원</td>
                  <td align='center'><input type='text' readonly name='tax_r_value' size='12' class='num' value='<%=AddUtil.parseDecimal(ct.getEtc_amt_v())%>' onBlur='javascript:this.value=parseDecimal(this.value);'> 원</td>
                  <td align='center'><input type='text' readonly name='tax_r_hap' size='12' class='num' value='' onBlur='javascript:this.value=parseDecimal(this.value);'> 원</td>
                  <td align="center"><input type='text' readonly name='tax_r_g' size='20' class='text'  value='<%=ct.getEtc_etc()%>'></td>
                  <td align='center'><input type='text' name='tax_rr_supply' size='12' class='num' value='<%=AddUtil.parseDecimal(ct.getR_etc_amt_s())%>' onBlur='javascript:this.value=parseDecimal(this.value); set_cls_tax_value(3);'> 원</td>
                  <td align='center'><input type='text' name='tax_rr_value' size='12' class='num' value='<%=AddUtil.parseDecimal(ct.getR_etc_amt_v())%>' onBlur='javascript:this.value=parseDecimal(this.value); set_cls_tax_hap();'> 원</td>
                  <td align='center'><input type='text' readonly name='tax_rr_hap' size='12' class='num' value='<%=AddUtil.parseDecimal(ct.getR_etc_amt_s()+ct.getR_etc_amt_v())%>' onBlur='javascript:this.value=parseDecimal(this.value);'> 원</td> 
                  <td align='center'><input type='text' readonly name='tax_r_bigo' size='22' class='text' value=''></td>
                  <td align="center"><input type='checkbox' name='tax_r_chk5' value='Y' <%if(ct.getTax_r_chk5().equals("Y")){%>checked<%}%>    ></td>
                </tr> 
                <tr> 
                  <td align="center">7</td>
                  <td align="center">회수부대비용</td>
                  <td align='center'><input type='text' readonly name='tax_r_supply' size='12' class='num' value='<%=AddUtil.parseDecimal(ct.getEtc2_amt_s())%>' onBlur='javascript:this.value=parseDecimal(this.value);'> 원</td>
                  <td align='center'><input type='text' readonly name='tax_r_value' size='12' class='num' value='<%=AddUtil.parseDecimal(ct.getEtc2_amt_v())%>' onBlur='javascript:this.value=parseDecimal(this.value);'> 원</td>
                  <td align='center'><input type='text' readonly name='tax_r_hap' size='12' class='num' value='<%=AddUtil.parseDecimal(ct.getEtc2_amt_s()+ct.getEtc2_amt_v())%>' onBlur='javascript:this.value=parseDecimal(this.value);'> 원</td>
                  <td align="center"><input type='text' readonly name='tax_r_g' size='20' class='text'  value='<%=ct.getEtc2_etc()%>'></td>
                  <td align='center'><input type='text' name='tax_rr_supply' size='12' class='num' value='<%=AddUtil.parseDecimal(ct.getR_etc2_amt_s())%>' onBlur='javascript:this.value=parseDecimal(this.value); set_cls_tax_value(4);'> 원</td>
                  <td align='center'><input type='text' name='tax_rr_value' size='12' class='num' value='<%=AddUtil.parseDecimal(ct.getR_etc2_amt_v())%>' onBlur='javascript:this.value=parseDecimal(this.value); set_cls_tax_hap();'> 원</td>
                  <td align='center'><input type='text' readonly name='tax_rr_hap' size='12' class='num' value='<%=AddUtil.parseDecimal(ct.getR_etc2_amt_s()+ct.getR_etc2_amt_v())%>' onBlur='javascript:this.value=parseDecimal(this.value);'> 원</td> 
                  <td align='center'><input type='text' readonly name='tax_r_bigo' size='22' class='text' value=''></td>
                  <td align="center"><input type='checkbox' name='tax_r_chk6' value='Y' <%if(ct.getTax_r_chk6().equals("Y")){%>checked<%}%>    ></td>
                </tr> 
                <tr> 
                  <td align="center">8</td>
                  <td align="center">손해배상금</td>
                  <td align='center'><input type='text' readonly name='tax_r_supply' size='12' class='num' value='<%=AddUtil.parseDecimal(ct.getEtc4_amt_s())%>' onBlur='javascript:this.value=parseDecimal(this.value);'> 원</td>
                  <td align='center'><input type='text' readonly name='tax_r_value' size='12' class='num' value='<%=AddUtil.parseDecimal(ct.getEtc4_amt_v())%>' onBlur='javascript:this.value=parseDecimal(this.value); set_cls_tax_hap();'> 원</td>
                  <td align='center'><input type='text' readonly name='tax_r_hap' size='12' class='num' value='<%=AddUtil.parseDecimal(ct.getEtc4_amt_s()+ct.getEtc4_amt_v())%>' onBlur='javascript:this.value=parseDecimal(this.value);'> 원</td>
                  <td align="center"><input type='text' readonly name='tax_r_g' size='20' class='text'  value='<%=ct.getEtc4_etc()%>'></td>
                  <td align='center'><input type='text' name='tax_rr_supply' size='12' class='num' value='<%=AddUtil.parseDecimal(ct.getR_etc4_amt_s())%>' onBlur='javascript:this.value=parseDecimal(this.value); set_cls_tax_value(5);'> 원</td>
                  <td align='center'><input type='text' name='tax_rr_value' size='12' class='num' value='<%=AddUtil.parseDecimal(ct.getR_etc4_amt_v())%>' onBlur='javascript:this.value=parseDecimal(this.value); set_cls_tax_hap();'> 원</td>
                  <td align='center'><input type='text' readonly name='tax_rr_hap' size='12' class='num' value='<%=AddUtil.parseDecimal(ct.getR_etc4_amt_s()+ct.getR_etc4_amt_v())%>' onBlur='javascript:this.value=parseDecimal(this.value);'> 원</td>
                  <td align='center'><input type='text' readonly name='tax_r_bigo' size='22' class='text' value=''></td>
                  <td align="center"><input type='checkbox' name='tax_r_chk7' value='Y' <%if(ct.getTax_r_chk7().equals("Y")){%>checked<%}%>  ></td>
                </tr> 
                
                <tr> 
                  <td class="title_p" align="center" colspan=2>&nbsp;계</td>
                  <td class="title_p" align='center'><input type='text' readonly name='p_tax_supply' size='12' class='num' value='' onBlur='javascript:this.value=parseDecimal(this.value);'> 원</td>
                  <td class="title_p" align='center'><input type='text' readonly name='p_tax_value' size='12' class='num' value='' onBlur='javascript:this.value=parseDecimal(this.value); '> 원</td>
                  <td class="title_p" align='center'><input type='text' readonly name='p_tax_hap' size='12' class='num' value='' onBlur='javascript:this.value=parseDecimal(this.value);'> 원</td>
                  <td class="title_p" align="center">&nbsp;</td>
                  <td class="title_p" align='center'><input type='text' readonly name='r_tax_supply' size='12' class='num' value='' onBlur='javascript:this.value=parseDecimal(this.value); ;'> 원</td>
                  <td class="title_p" align='center'><input type='text' readonly name='r_tax_value' size='12' class='num' value='' onBlur='javascript:this.value=parseDecimal(this.value); '> 원</td>
                  <td class="title_p" align='center'><input type='text' readonly name='r_tax_hap' size='12' class='num' value='' onBlur='javascript:this.value=parseDecimal(this.value);'> 원</td>
                  <td class="title_p" align='center' colspan=2>&nbsp;</td>                  
                </tr>  
               
            </table>
        </td>
    </tr>
    <tr>
        <td>&nbsp;</td>
    </tr>  
  
  
    <tr>
      <td colspan="2" align="right">
	  <%if(auth_rw.equals("2") || auth_rw.equals("4") || auth_rw.equals("6")){%>
	  <a href="javascript:tax_reg();"><img src="/acar/images/center/button_reg.gif" align="absmiddle" border="0"></a>
	  <%}%>
	  </td>
    </tr>		
  </table>
<script language="JavaScript">
<!--
	set_tax_init();

	//세금계산서
	function set_tax_init(){
		var fm = document.form1;
	  
		//미납대여료
	//	if(toInt(parseDigit(fm.nfee_amt.value)) > 0){
		if(toInt(parseDigit(fm.tax_r_supply[3].value)) > 0){
		     
		//		fm.tax_r_supply[3].value 	= fm.nfee_amt.value;
		//		fm.tax_r_value[3].value 	= parseDecimal( toInt(parseDigit(fm.nfee_amt.value)) * 0.1 );
				fm.tax_r_g[3].value       = "해지 미납 대여료";
				fm.tax_r_bigo[3].value    = fm.car_no.value+" 해지";
			//	fm.tax_r_chk3.checked   	= true;
		}
	
		//중도해지위약금
	//	if(toInt(parseDigit(fm.dft_amt.value)) > 0){
		if(toInt(parseDigit(fm.tax_r_supply[4].value)) > 0){
			  
		//		fm.tax_r_supply[4].value 	= fm.dft_amt.value;
		//		fm.tax_r_value[4].value 	= parseDecimal( toInt(parseDigit(fm.dft_amt.value)) * 0.1 );
				fm.tax_r_g[4].value       = "해지 위약금";
				fm.tax_r_bigo[4].value    = fm.car_no.value+" 해지";
			//	fm.tax_r_chk4.checked   	= true;
		}
		
		//회수외주비용
	//	if(toInt(parseDigit(fm.etc_amt.value)) > 0){
		if(toInt(parseDigit(fm.tax_r_supply[5].value)) > 0){
			  
		//		fm.tax_r_supply[5].value 	= fm.etc_amt.value;
		//		fm.tax_r_value[5].value 	= parseDecimal( toInt(parseDigit(fm.dft_amt.value)) * 0.1 );
				fm.tax_r_g[5].value       = "해지 회수외주비용";
				fm.tax_r_bigo[5].value    = fm.car_no.value+" 해지";
			//	fm.tax_r_chk5.checked   	= true;
		}
		
		//회수부대비용
	//	if(toInt(parseDigit(fm.etc2_amt.value)) > 0){
		if(toInt(parseDigit(fm.tax_r_supply[6].value)) > 0){
			  
		//		fm.tax_r_supply[6].value 	= fm.etc2_amt.value;
		//		fm.tax_r_value[6].value 	= parseDecimal( toInt(parseDigit(fm.etc2_amt.value)) * 0.1 );
				fm.tax_r_g[6].value       = "해지 회수부대비용";
				fm.tax_r_bigo[6].value    = fm.car_no.value+" 해지";
			//	fm.tax_r_chk6.checked   	= true;
		}
		//기타손해배상금
	//	if(toInt(parseDigit(fm.etc4_amt.value)) > 0){
		if(toInt(parseDigit(fm.tax_r_supply[7].value)) > 0){
			  
			//	fm.tax_r_supply[7].value 	= fm.etc4_amt.value;
			//	fm.tax_r_value[7].value 	= parseDecimal( toInt(parseDigit(fm.etc4_amt.value)) * 0.1 );
				fm.tax_r_g[7].value       = "해지 손해배상금";
				fm.tax_r_bigo[7].value    = fm.car_no.value+" 해지";
			//	fm.tax_r_chk7.checked   	= true;
		}
		
		
			
		fm.p_tax_supply.value = 0;
		fm.p_tax_value.value = 0;
		fm.p_tax_hap.value = 0;
		fm.r_tax_supply.value = 0;
		fm.r_tax_value.value = 0;	
		fm.r_tax_hap.value = 0;	
				
		for(var i=0 ; i<8 ; i++){
		  fm.p_tax_supply.value    	= parseDecimal( toInt(parseDigit(fm.p_tax_supply.value)) + toInt(parseDigit(fm.tax_r_supply[i].value)) );
		  fm.p_tax_value.value     	= parseDecimal( toInt(parseDigit(fm.p_tax_value.value)) + toInt(parseDigit(fm.tax_r_value[i].value)) );
		  fm.r_tax_supply.value    	= parseDecimal( toInt(parseDigit(fm.r_tax_supply.value)) + toInt(parseDigit(fm.tax_rr_supply[i].value)) );
		  fm.r_tax_value.value     	= parseDecimal( toInt(parseDigit(fm.r_tax_value.value)) + toInt(parseDigit(fm.tax_rr_value[i].value)) );
		}
		fm.p_tax_hap.value    		= parseDecimal( toInt(parseDigit(fm.p_tax_supply.value)) + toInt(parseDigit(fm.p_tax_value.value)) );
		fm.r_tax_hap.value    		= parseDecimal( toInt(parseDigit(fm.r_tax_supply.value)) + toInt(parseDigit(fm.r_tax_value.value)) );
		
	
	
	}		
//-->
</script>  
</form>	
<iframe src="about:blank" name="i_no" width="0" height="0" frameborder="0" noresize></iframe>
</body>
</html>