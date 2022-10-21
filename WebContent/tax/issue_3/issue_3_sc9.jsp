<%@ page language="java" contentType="text/html;charset=euc-kr" %>
<%@ page import="java.util.*, acar.util.*, acar.cont.*, acar.fee.*, acar.common.*, tax.*, acar.bill_mng.*, acar.client.*, acar.accid.*, acar.res_search.*, acar.user_mng.*, acar.car_register.*"%>
<jsp:useBean id="IssueDb" scope="page" class="tax.IssueDatabase"/>
<jsp:useBean id="ClientMngDb" scope="page" class="tax.ClientMngDatabase"/>
<jsp:useBean id="ScdMngDb" scope="page" class="tax.ScdMngDatabase"/>
<jsp:useBean id="a_db" scope="page" class="acar.cont.AddContDatabase"/>
<jsp:useBean id="af_db" scope="page" class="acar.fee.AddFeeDatabase"/>
<jsp:useBean id="al_db" scope="page" class="acar.client.AddClientDatabase"/>
<jsp:useBean id="rs_db" scope="page" class="acar.res_search.ResSearchDatabase"/>
<jsp:useBean id="cr_bean" class="acar.car_register.CarRegBean" scope="page"/>
<%@ include file="/tax/cookies_base.jsp" %>

<%
	CommonDataBase c_db = CommonDataBase.getInstance();
	AccidDatabase as_db = AccidDatabase.getInstance();
	UserMngDatabase umd = UserMngDatabase.getInstance();
	
	String rent_mng_id 	= request.getParameter("rent_mng_id")==null?"":request.getParameter("rent_mng_id");
	String rent_l_cd 	= request.getParameter("rent_l_cd")==null?"":request.getParameter("rent_l_cd");
	String car_mng_id 	= request.getParameter("car_mng_id")==null?"":request.getParameter("car_mng_id");
	String client_id 	= request.getParameter("client_id")==null?"":request.getParameter("client_id");
	String site_id 		= request.getParameter("site_id")==null?"":request.getParameter("site_id");
	String accid_id		= request.getParameter("accid_id")==null?"":request.getParameter("accid_id");
	String seq_no		= request.getParameter("seq_no")==null?"":request.getParameter("seq_no");
	String rent_s_cd	= request.getParameter("rent_s_cd")==null?"":request.getParameter("rent_s_cd");
	String cust_st		= request.getParameter("cust_st")==null?"":request.getParameter("cust_st");
	String mode 		= request.getParameter("mode")==null?"":request.getParameter("mode");
	String go_url 		= request.getParameter("go_url")==null?"":request.getParameter("go_url");
	
	int pay_amt = request.getParameter("pay_amt")==null?0:Util.parseDigit(request.getParameter("pay_amt"));
	int s_amt 	= request.getParameter("s_amt")==null?0:Util.parseDigit(request.getParameter("s_amt"));
	int v_amt 	= request.getParameter("v_amt")==null?0:Util.parseDigit(request.getParameter("v_amt"));
	
	int tae_sum = 0;
	int max_table_line = 3;
	int height = 0;
	String tax_supply = "";
	String tax_value = "";
	String tax_yn = "N";
	String tax_branch 	= "";
	
	//로그인ID&영업소ID
	LoginBean login = LoginBean.getInstance();
	if(user_id.equals("")) 	user_id = login.getCookieValue(request, "acar_id");
	if(br_id.equals(""))	br_id = login.getCookieValue(request, "acar_br");
	if(auth_rw.equals(""))	auth_rw = rs_db.getAuthRw(user_id, "05", "06", "13");
	
	//계약:고객관련
	ContBaseBean base 		= a_db.getContBaseAll(rent_mng_id, rent_l_cd);
	if(base.getTax_type().equals("2")){//지점
		site_id = base.getR_site();
	}else{
		site_id = "";
	}
	
	//대여정보
	ContFeeBean fee = a_db.getContFee(rent_mng_id, rent_l_cd, "1");
	tax_branch = fee.getBr_id()==""?"S1":fee.getBr_id();
	
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
	String i_ven_code	= client.getVen_code();
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
		i_ven_code	= site.getVen_code();
		
		client.setCon_agnt_nm		(site.getAgnt_nm());
		client.setCon_agnt_dept	(site.getAgnt_dept());
		client.setCon_agnt_title(site.getAgnt_title());
		client.setCon_agnt_email(site.getAgnt_email().trim());
		client.setCon_agnt_m_tel(site.getAgnt_m_tel());		
		
		client.setCon_agnt_nm2	 (site.getAgnt_nm2());
		client.setCon_agnt_dept2 (site.getAgnt_dept2());
		client.setCon_agnt_title2(site.getAgnt_title2());
		client.setCon_agnt_email2(site.getAgnt_email2().trim());
		client.setCon_agnt_m_tel2(site.getAgnt_m_tel2());
		
		
	}
	
	Vector branches = c_db.getBranchs(); //영업소 리스트 조회
	int brch_size = branches.size();
	
	
	//계약조회
	Hashtable cont = as_db.getRentCase(rent_mng_id, rent_l_cd);
	
	//사고조회
	AccidentBean a_bean = as_db.getAccidentBean(car_mng_id, accid_id);
	
	//보험청구내역(휴차/대차료)
	MyAccidBean ma_bean = as_db.getMyAccid(car_mng_id, accid_id, AddUtil.parseInt(seq_no));
	
	
	Hashtable ht_ma = ScdMngDb.getMyAccidLScdTaxPay(car_mng_id, accid_id, seq_no);
	Hashtable ht_mt = ScdMngDb.getMyAccidLScdTax(car_mng_id, accid_id, seq_no);
	
	if(AddUtil.parseInt(String.valueOf(ht_ma.get("EXT_PAY_AMT"))) >0){
		pay_amt = AddUtil.parseInt(String.valueOf(ht_ma.get("EXT_PAY_AMT")));
		if(AddUtil.parseInt(String.valueOf(ht_mt.get("TAX_AMT"))) >0){
			pay_amt = pay_amt - AddUtil.parseInt(String.valueOf(ht_mt.get("TAX_AMT")));
		}
		s_amt   = af_db.getSupAmt(pay_amt);
		v_amt 	= pay_amt-s_amt;
		ma_bean.setIns_req_dt(String.valueOf(ht_ma.get("EXT_PAY_DT")));
	}	
	
	
	//단기계약정보
	RentContBean rc_bean = rs_db.getRentContCaseAccid(car_mng_id, accid_id);
	
	//차량정보
	Hashtable reserv = rs_db.getCarInfo(rc_bean.getCar_mng_id());
	
	String accid_dt = a_bean.getAccid_dt();
	String accid_dt_h = "";
	String accid_dt_m = "";
	if(!accid_dt.equals("")){
		accid_dt = a_bean.getAccid_dt().substring(0,8);
		accid_dt_h = a_bean.getAccid_dt().substring(8,10);
		accid_dt_m = a_bean.getAccid_dt().substring(10,12);
	}
	
	int grt_size = 0;
	gubun1 = "9";
	
	//청구서발행 조회 : 청구금액과 입금금액은 다르므로 기발행 청구서하고 연동하지는 않는다. 20170728
	//TaxItemListBean ti = IssueDb.getTaxItemListMyAccid(car_mng_id, accid_id, seq_no);
	TaxItemListBean ti = new TaxItemListBean();
	
	if(!tax_branch.equals("S1") && AddUtil.parseInt(ma_bean.getIns_req_dt()) > 20090631){
		tax_branch = "S1";
	}
		
	Hashtable br = c_db.getBranch(tax_branch); //소속영업소 리스트 조회
	
	UsersBean cust_bean 	= umd.getUsersBean(client_id);
	
	if(!rent_s_cd.equals("") && cust_st.equals("4")){
		i_enp_no 		= cust_bean.getUser_ssn();
		i_firm_nm 		= cust_bean.getUser_nm();
		i_client_nm 		= cust_bean.getUser_nm();
		i_addr 			= cust_bean.getAddr();
		i_sta 			= "";
		i_item 			= "";
		i_ven_code	= "";
	}
	
	CarRegDatabase crd = CarRegDatabase.getInstance();
	cr_bean = crd.getCarRegBean(base.getCar_mng_id());
%>

<html>
<head>
<title>FMS</title>
<meta http-equiv="content-type" content="text/html; charset=euc-kr">
<link rel="stylesheet" type="text/css" href="/include/table_t.css">
<script language="JavaScript" src="/include/common.js"></script>
<script language="JavaScript">
<!--
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
	<%if(!rent_s_cd.equals("") && cust_st.equals("4")){%>
	<%}else{%>		
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
	<%}%>
	}	
	
	//발행
	function tax_reg(){
		var fm = document.form1;	
		if(confirm('발행 하시겠습니까?'))
		{			
		
			fm.tax_bigo_t.value 	= charRound(fm.tax_bigo.value ,150);
			fm.tax_bigo_50.value 	= charRound(fm.tax_bigo.value ,150);
			
			fm.target = "i_no";
//			fm.target = "d_content";
						
//			fm.action = "tax_reg_step_accid.jsp";

			<%//if(ti.getItem_value()==0){%>
			fm.action = "tax_reg_step1.jsp";						
			<%//}else{%>
			//fm.action = "tax_reg_step2_2.jsp";			
			<%//}%>

			fm.submit();						
		}
	}

	//목록가기
	function go_list(){
		var fm = document.form1;
		fm.target = "d_content";
		fm.action = "issue_3_frame9.jsp";
		fm.submit();
	}	
	
	function view_client(m_id, l_cd, r_st)
	{
		window.open("/fms2/con_fee/con_fee_client_s.jsp?m_id="+m_id+"&l_cd="+l_cd+"&r_st="+r_st, "VIEW_CLIENT", "left=100, top=100, width=720, height=550, scrollbars=yes");
	}
	
	//공급가, 부가세, 합계 입력시 자동계산
	function set_item_amt(obj)
	{
		obj.value = parseDecimal(obj.value);
		var fm = document.form1;
		
		if(obj==fm.item_supply[0]){			//공급가
			fm.item_value[0].value 	= parseDecimal(toInt(parseDigit(fm.item_supply[0].value)) * 0.1 );
			fm.item_amt[0].value 	= parseDecimal(toInt(parseDigit(fm.item_supply[0].value)) + toInt(parseDigit(fm.item_value[0].value)));
		}else if(obj==fm.item_value[0]){ 	//부가세
			fm.item_supply[0].value = parseDecimal(toInt(parseDigit(fm.item_value[0].value)) / 0.1 );
			fm.item_amt[0].value 	= parseDecimal(toInt(parseDigit(fm.item_supply[0].value)) + toInt(parseDigit(fm.item_value[0].value)));
		}else if(obj==fm.item_amt[0]){ 		//합계
			fm.item_supply[0].value = parseDecimal(sup_amt(toInt(parseDigit(obj.value))));
			fm.item_value[0].value 	= parseDecimal(toInt(parseDigit(obj.value)) - toInt(parseDigit(fm.item_supply[0].value)));			
		}
		fm.t_item_supply.value		= fm.item_supply[0].value;
		fm.t_item_value.value		= fm.item_value[0].value;
		fm.t_item_amt.value			= fm.item_amt[0].value;
	}
	
	//문자열 일정길이 자르기
	function charRound(f, b_len){	
	
		var max_len = f.length;
		var ff = '';
		var len = 0;
		
		for(k=0;k<max_len;k++) {
		
			if(len >= b_len) break; //지정길이보다 길면 종료
			
			t = f.charAt(k);			
			ff += t;
			
			if (escape(t).length > 4)
				len += 2;
			else
				len++;
		}	
		return ff;			
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
  <input type="hidden" name="car_mng_id" value="<%=car_mng_id%>">  
  <input type="hidden" name="tm" value="<%=accid_id%>">      
  <input type="hidden" name="seq_no" value="<%=seq_no%>">   
  <input type="hidden" name="rent_s_cd" value="<%=rent_s_cd%>">      
  <input type="hidden" name="cust_st" value="<%=cust_st%>">             
  <input type="hidden" name="mode" value="<%=mode%>">  
  <input type="hidden" name="scd_size" value="<%=grt_size%>">
  <input type='hidden' name='go_url' value='<%=go_url%>'>
  <input type="hidden" name="count" value="0">
  <input type="hidden" name="reg_gu" value="3_9">  
  <input type="hidden" name="item_list_cnt" value="1">      
  <input type="hidden" name="reg_code" value="<%=ti.getReg_code()%>">    
  <input type="hidden" name="item_id" value="<%=ti.getItem_id()%>">      
  <input type="hidden" name="item_seq" value="<%=ti.getItem_seq()%>">      
  <input type="hidden" name="tax_bigo_t" value="">        
  <input type="hidden" name="tax_bigo_50" value="">          
  
<table width=100% border=0 cellpadding=0 cellspacing=0>
	<tr>
		<td colspan=2>
			<table width=100% border=0 cellpadding=0 cellspacing=0>
				<tr>
					<td width=7><img src=/acar/images/center/menu_bar_1.gif width=7 height=33></td>
					<td class=bar>&nbsp;&nbsp;&nbsp;<img src=/acar/images/center/menu_bar_dot.gif width=4 height=5 align=absmiddle>&nbsp;<span class=style1>재무회계 > 세금계산서발행 > 수시발행 > <span class=style5>
						대차료</span></span></td>
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
    <tr>
        <td colspan="2">
            <table width="100%"  border="0" cellpadding="0" cellspacing="0">
                <tr>
                  <td width="49%"><img src=/acar/images/center/icon_arrow.gif align=absmiddle> <span class=style2>고객</span></td>
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
        			  <input type="hidden" name="i_ven_code" value="<%=i_ven_code%>">
        			    <select name='i_enp_no' onChange='javascript:in_set();'>
						<%if(!rent_s_cd.equals("") && cust_st.equals("4")){%>
                        <option value='<%=i_enp_no%>' selected><%=i_enp_no%> <%=i_firm_nm%></option>				  						
						<%}else{%>
        				<%		if(c_site_size > 0){%>
        		          <option value=''>선택</option>
        				<%		}%>  
        		          <option value='00||<%=client.getFirm_nm()%>||<%=client.getClient_nm()%>||<%=client.getO_addr()%>||<%=client.getBus_cdt()%>||<%=client.getBus_itm()%>||<%=client.getTaxregno()%>' <%if(site_id.equals("")){%>selected<%}%>><%if(!client.getEnp_no1().equals("")){%><%=client.getEnp_no1()%>-<%=client.getEnp_no2()%>-<%=client.getEnp_no3()%> 본사<%}else{%><%=client.getSsn1()%>-<%=client.getSsn2()%><%}%></option>				  
        					<%	for(int i = 0 ; i < c_site_size ; i++){
        							ClientSiteBean site = (ClientSiteBean)c_sites.elementAt(i);%>	  		
        
        			      <option value='<%=site.getSeq()%>||<%=site.getR_site()%>||<%=site.getSite_jang()%>||<%=site.getAddr()%>||<%=site.getBus_itm()%>||<%=site.getBus_cdt()%>||<%=site.getTaxregno()%>' <%if(site_id.equals(site.getSeq())){%>selected<%}%>><%=AddUtil.ChangeSsn(AddUtil.ChangeEnp(site.getEnp_no()))%> <%=Util.subData(site.getR_site(), 15)%></option>
                  			<%	}%>							
						<%}%>	
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
            </table>
        </td>
    </tr>		
    <tr>
      <td colspan="2" class=h></td>
    </tr>
    <tr>
      <td><img src=/acar/images/center/icon_arrow.gif align=absmiddle> <span class=style2>보험사</span></td>
      <td align="right">
	  </td>
    </tr>
    <tr><td class=line2 colspan=2></td></tr>
    <tr> 
      <td class=line colspan="2"> 
        <table border="0" cellspacing="1" width=100%>
          <tr> 
            <td class=title width="10%">보험사</td>
            <td width="15%"> 
              &nbsp;<%=ma_bean.getIns_com()%>
            </td>
            <td class=title width="10%">보험담당자</td>
            <td width="15%"> 
              &nbsp;<%=ma_bean.getIns_nm()%>
            </td>
            <td width="10%" class=title>연락처Ⅰ</td>
            <td width="15%"> 
              &nbsp;<%=ma_bean.getIns_tel()%>
            </td>
            <td width="10%" class=title>연락처Ⅱ</td>
            <td width="15%"> 
              &nbsp;<%=ma_bean.getIns_tel2()%>
            </td>			
          </tr>		
          <tr> 
            <td class=title>접수번호</td>
            <td>&nbsp;No.<%=ma_bean.getIns_num()%> </td>		  
            <td class=title>팩스</td>
            <td>&nbsp;<%=ma_bean.getIns_fax()%> </td>
            <td class=title>주소</td>
            <td colspan="3">&nbsp;<%=ma_bean.getIns_addr()%>            </td>
          </tr>
        </table>
      </td>
    </tr>
    <tr>
      <td colspan="2" class=h></td>
    </tr>	
    <tr>
      <td><img src=/acar/images/center/icon_arrow.gif align=absmiddle> <span class=style2>대차료</span></td>
      <td align="right">
	  </td>
    </tr>
    <tr><td class=line2 colspan=2></td></tr>
    <tr>
      <td colspan="2" class="line">
        <table border="0" cellspacing="1" cellpadding="0" width='100%'>
        <tr>
          <td width='4%' rowspan="2" class='title'>구분</td>
          <td width='9%' rowspan="2" class='title'>계약번호</td>
          <td width='9%' rowspan="2" class='title'>상호</td>
          <td colspan="2" class='title'>사고차량</td>
          <td colspan="2" class='title'>대차차량</td>
          <td width="7%" rowspan="2" class='title'>사고일자</td>
          <td width="7%" rowspan="2" class='title'>사고구분</td>
          <td width='7%' rowspan="2" class='title'>청구금액</td>
          <td width='7%' rowspan="2" class='title'>청구일자</td>
          <td width='7%' rowspan="2" class='title'>입금금액</td>
          <td width='7%' rowspan="2" class='title'>입금일자</td>
        </tr>
        <tr>
          <td width='8%' class='title'>차량번호</td>
          <td width='10%' class='title'>차명</td>
          <td width='8%' class='title'>차량번호</td>
          <td width='10%' class='title'>차명</td>
        </tr>
        </tr>
        <tr>	  		
          <td align="center">대차료</td>
          <td align="center"><%=rent_l_cd%></td>
          <td align="center"><span title='<%=i_firm_nm%>'><%=AddUtil.subData(i_firm_nm, 6)%></span></a></td>
          <td align="center"><%=cont.get("CAR_NO")%></td>
          <td align="center"><span title=<%=cont.get("CAR_NM")%>'><%=AddUtil.subData(String.valueOf(cont.get("CAR_NM")), 5)%></span></td>		  
          <td align="center"><%=ma_bean.getIns_car_no()%></td>
          <td align="center"><span title='<%=ma_bean.getIns_car_nm()%>'><%=AddUtil.subData(ma_bean.getIns_car_nm(), 5)%></span></td>		  
          <td align="center"><%=AddUtil.ChangeDate2(accid_dt)%></td>		  
          <td align="center">                
		    <%if(a_bean.getAccid_st().equals("1")){%>피해자<%}%>
            <%if(a_bean.getAccid_st().equals("2")){%>가해자<%}%>
            <%if(a_bean.getAccid_st().equals("3")){%>쌍방<%}%>
            <%if(a_bean.getAccid_st().equals("5")){%>사고자차<%}%>
            <%if(a_bean.getAccid_st().equals("4")){%>운행자차<%}%>
            <%if(a_bean.getAccid_st().equals("6")){%>수해<%}%>
	      </td>		  
          <td align="right"><%=AddUtil.parseDecimal(ma_bean.getIns_req_amt())%>원&nbsp;</td>
          <td align="center"><%=AddUtil.ChangeDate2(ma_bean.getIns_req_dt())%></td>
          <td align="right"><%=Util.parseDecimal(pay_amt)%><%//=Util.parseDecimal(String.valueOf(ht_ma.get("EXT_PAY_AMT")))%>원&nbsp;</td>
          <td align="center"><%=AddUtil.ChangeDate2(String.valueOf(ht_ma.get("EXT_PAY_DT")))%></td>          
        </tr>
      </table></td>
    </tr>
	<input type='hidden' name="req_dt" value="<%=ma_bean.getIns_req_dt()%>">
    <tr>
      <td colspan="2" class=h></td>
    </tr>
    <tr>
      <td><img src=/acar/images/center/icon_arrow.gif align=absmiddle> <span class=style2>거래명세서</span></td>
      <td align="right">
	  </td>
    </tr>
    <tr>
      <td colspan="2" class="line">
        <table width="100%" border="0" cellspacing="0" cellpadding="0">
        <tr align="center" bgcolor="#CCCCCC">
          <td rowspan="2" width="5%" style="border-top: #000000 1px solid; border-left: #000000 1px solid; border-bottom: #000000 1px solid">연번</td>
          <td rowspan="2" width="10%" style="border-top: #000000 1px solid; border-left: #000000 1px solid; border-bottom: #000000 1px solid">거래구분</td>
          <td rowspan="2" width="10%" style="border-top: #000000 1px solid; border-left: #000000 1px solid; border-bottom: #000000 1px solid">차량번호</td>
          <td width="25%" rowspan="2" bgcolor="#CCCCCC" style="border-top: #000000 1px solid; border-left: #000000 1px solid; border-bottom: #000000 1px solid">차명</td>
          <td height="20" colspan="2" style="border-top: #000000 1px solid; border-left: #000000 1px solid; border-bottom: #000000 1px solid">청구(거래)기준일</td>
          <td rowspan="2" width="10%" style="border-top: #000000 1px solid; border-left: #000000 1px solid; border-bottom: #000000 1px solid">공급가액</td>
          <td rowspan="2" width="10%" style="border-top: #000000 1px solid; border-left: #000000 1px solid; border-bottom: #000000 1px solid">세액</td>
          <td rowspan="2" width="10%" style="border-top: #000000 1px solid; border-left: #000000 1px solid; border-bottom: #000000 1px solid; border-right: #000000 1px solid;">합계</td>
        </tr>
        <tr>
          <td height="20" width="10%" bgcolor="#CCCCCC" align="center" style="border-left: #000000 1px solid; border-bottom: #000000 1px solid">~부터</td>
          <td height="20" width="10%" bgcolor="#CCCCCC" align="center" style="border-left: #000000 1px solid; border-bottom: #000000 1px solid">~까지</td>
        </tr>
		<input type='hidden' name="l_cd" value="<%=rent_l_cd%>">
		<input type='hidden' name="c_id" value="<%=car_mng_id%>">		
		<input type='hidden' name="tm" value="<%=accid_id%>">		
		<input type='hidden' name="seq" value="<%=1%>">
		<input type='hidden' name="rent_st" value="">
		<%
			if(v_amt > 0){
				ma_bean.setMc_s_amt(s_amt);
				ma_bean.setMc_v_amt(v_amt);
				ma_bean.setIns_req_dt(ma_bean.getIns_pay_dt());
			}
		%>
        <tr>
          <td height="22" align="center" style="border-left: #000000 1px solid; border-bottom: #000000 1px solid"><%=1%></td>
          <td height="22" align="center" style="border-left: #000000 1px solid; border-bottom: #000000 1px solid"><span class="ledger_contC">
            <input type="text" name="item_g" size="12" value="대차료" class="whitetext" readonly>
          </span></td>
          <td height="22" align="center" style="border-left: #000000 1px solid; border-bottom: #000000 1px solid"><span class="ledger_contC">
            <input type="text" name="item_car_no" size="12" value="<%=cont.get("CAR_NO")%>" class="whitetext" readonly>
          </span></td>
          <td height="22" align="center" style="border-left: #000000 1px solid; border-bottom: #000000 1px solid"><span class="ledger_contC">
            <input type="text" name="item_car_nm" size="25" value="<%=cont.get("CAR_NM")%>" class="whitetext" readonly>
          </span></td>
          <td height="22" align="center" style="border-left: #000000 1px solid; border-bottom: #000000 1px solid"><span class="ledger_contC">
            <input type="text" name="item_dt1" size="10" value="<%=AddUtil.ChangeDate2(ma_bean.getIns_use_st())%>" class="whitetext" readonly>
          </span></td>
          <td height="22" align="center" style="border-left: #000000 1px solid; border-bottom: #000000 1px solid"><span class="ledger_contC">
            <input type="text" name="item_dt2" size="10" value="<%=AddUtil.ChangeDate2(ma_bean.getIns_use_et())%>" class="whitetext" readonly>
          </span></td>
          <td height="22" align="center" style="border-left: #000000 1px solid; border-bottom: #000000 1px solid"><span class="ledger_contC">
            <input type="text" name="item_supply" size="10" value="<%=AddUtil.parseDecimal(ma_bean.getMc_s_amt())%>" class="num" onBlur='javascript:this.value=parseDecimal(this.value);set_item_amt(this);'> 
            </span></td>
          <td height="22" align="center" style="border-left: #000000 1px solid; border-bottom: #000000 1px solid"><span class="ledger_contC">
            <input type="text" name="item_value" size="10" value="<%=AddUtil.parseDecimal(ma_bean.getMc_v_amt())%>" class="num" onBlur='javascript:this.value=parseDecimal(this.value);set_item_amt(this);'>
			</span></td>
          <td height="22" align="center" style="border-left: #000000 1px solid; border-bottom: #000000 1px solid; border-right: #000000 1px solid"><span class="ledger_contC">
            <input type="text" name="item_amt" size="10" value="<%=AddUtil.parseDecimal(ma_bean.getMc_s_amt()+ma_bean.getMc_v_amt())%>" class="num" onBlur='javascript:this.value=parseDecimal(this.value);set_item_amt(this);'>
			</span></td>
        </tr>
        <tr>
          <td height="22" colspan="6" align="center" style="border-left: #000000 1px solid; border-bottom: #000000 1px solid" bgcolor="#CCCCCC">합계</td>
          <td height="22" align="center" style="border-left: #000000 1px solid; border-bottom: #000000 1px solid"><span class="ledger_contC">
            <input type="text" name="t_item_supply" size="10" value="<%=AddUtil.parseDecimal(ma_bean.getMc_s_amt())%>" class="whitenum" >
			</span></td>
          <td height="22" align="center" style="border-left: #000000 1px solid; border-bottom: #000000 1px solid"><span class="ledger_contC">
            <input type="text" name="t_item_value" size="10" value="<%=AddUtil.parseDecimal(ma_bean.getMc_v_amt())%>" class="whitenum" >
			</span></td>
          <td height="22" align="center" style="border-left: #000000 1px solid; border-bottom: #000000 1px solid; border-right: #000000 1px solid"><span class="ledger_contC">
            <input type="text" name="t_item_amt" size="10" value="<%=AddUtil.parseDecimal(ma_bean.getMc_s_amt()+ma_bean.getMc_v_amt())%>" class="whitenum" >
			</span></td>
        </tr>
      </table></td>
    </tr>
        
	<input type='hidden' name="l_cd" value="">
	<input type='hidden' name="c_id" value="">		
	<input type='hidden' name="tm" value="">		
	<input type='hidden' name="seq" value="">	
	<input type='hidden' name="rent_st" value="">
	<input type='hidden' name="item_g" value="">
	<input type='hidden' name="item_car_no" value="">		
	<input type='hidden' name="item_car_nm" value="">		
	<input type='hidden' name="item_dt1" value="">
	<input type='hidden' name="item_dt2" value="">	
	<input type='hidden' name="item_supply" value="0">		
	<input type='hidden' name="item_value" value="0">
	<input type='hidden' name="item_amt" value="0">	
		
    <tr>
      <td colspan="2" class=h></td>
    </tr>
    <tr>
      <td colspan="2" class=h></td>
    </tr>
    <tr>
      <td><img src=/acar/images/center/icon_arrow.gif align=absmiddle> <span class=style2>세금계산서</span> <font color=red>(작성일자가 오늘보다 크면 발행이 되지 않습니다.)</font></td>
      <td align="right">
	  </td>
    </tr>
    <tr><td class=line2 colspan=2></td></tr>
    <tr>
      <td colspan="2" class="line"><table border="0" cellspacing="1" cellpadding="0" width='100%'>
    
        <tr>
          <td width='10%' class='title'>세금일자</td>
          <td width='90%'>&nbsp;
              <input type='text' size='11' name='tax_dt' value='<%=ma_bean.getIns_pay_dt()%>' maxlength='50' class='text'></td>
          </tr>
        <tr>
          <td width='10%' class='title'>항목</td>
          <td width='90%'>&nbsp;
              <input type='text' size='50' name='tax_g' value='대차료(<%=cont.get("CAR_NO")%>)' maxlength='50' class='text'>
             &nbsp;&nbsp;&nbsp;&nbsp;
               <input type="radio" name="pubform" value="R" checked >영수&nbsp;
               <input type="radio" name="pubform" value="D">청구&nbsp;              
              </td>
          </tr>
        <tr>
          <td class='title'>비고</td>
          <td>&nbsp;
          	<textarea name="tax_bigo" cols="120" rows="3" class=default style='IME-MODE: active'>사고대차 No.<%=ma_bean.getIns_num()%>(<%=AddUtil.ChangeDate2(ma_bean.getIns_use_st())%>~<%=AddUtil.ChangeDate2(ma_bean.getIns_use_et())%>) 보험사 기납입건으로 납부하지 않으셔도 됩니다. 공제받지못할 매입세액으로 신고 하시기 바랍니다.</textarea>
          	<!--<textarea name="tax_bigo" cols="120" rows="3" class=default style='IME-MODE: active'>사고대차 No.<%=ma_bean.getIns_num()%>(<%=AddUtil.ChangeDate2(ma_bean.getIns_use_st())%>~<%=AddUtil.ChangeDate2(ma_bean.getIns_use_et())%>) 보험사 기납입건으로 납부하지 않으셔도 됩니다. 부가세 매입세액 불공제 신고 하시기 바랍니다.</textarea>-->
          	<!--
            <input type='text' size='120' name='tax_bigo' value='사고대차 No.<%=ma_bean.getIns_num()%>(<%=AddUtil.ChangeDate2(ma_bean.getIns_use_st())%>~<%=AddUtil.ChangeDate2(ma_bean.getIns_use_et())%>) 보험사 기납입건으로 납부하지 않으셔도 됩니다. 부가세 매입세액 불공제 신고 하시기 바랍니다.' maxlength='300' class='text'>
       			(한글 20자, 영문/숫자 40자이내)-->
			</td>
          </tr>
      </table></td>
    </tr>		
    <tr>
      <td colspan="2" class=h></td>
    </tr>	
    <tr>
      <td><img src=/acar/images/center/icon_arrow.gif align=absmiddle> <span class=style2>전자세금계산서 이메일 발송</span></td>
      <td align="right">
	  </td>
    </tr>
    <tr><td class=line2 colspan=2></td></tr>
	<%	if(!rent_s_cd.equals("") && cust_st.equals("4")){
			client.setCon_agnt_nm	("");
			client.setCon_agnt_dept	("");
			client.setCon_agnt_title("");
			client.setCon_agnt_email("");
			client.setCon_agnt_m_tel("");
		}%>
    <tr>
      <td colspan="2" class="line"><table border="0" cellspacing="1" cellpadding="0" width='100%'>
        <tr>
          <td width='10%' class='title'>수신담당자</td>
          <td>&nbsp;이름 : 
          	<input type='text' size='15' name='con_agnt_nm' value='<%=client.getCon_agnt_nm()%>' maxlength='20' class='text'>
          	&nbsp;부서 : 
            <input type='text' size='15' name='con_agnt_dept' value='<%=client.getCon_agnt_dept()%>' maxlength='15' class='text'>
            &nbsp;직위 : 
            <input type='text' size='15' name='con_agnt_title' value='<%=client.getCon_agnt_title()%>' maxlength='10' class='text'>
            &nbsp;EMAIL : 
            <input type='text' size='40' name='con_agnt_email' value='<%=client.getCon_agnt_email()%>' maxlength='30' class='text' style='IME-MODE: inactive'>
            &nbsp;이동전화 :                         
            <input type='text' size='15' name='con_agnt_m_tel' value='<%=client.getCon_agnt_m_tel()%>' maxlength='15' class='text'>
          </td>
        </tr>
        <tr>
          <td width='10%' class='title'>추가담당자</td>
          <td>&nbsp;이름 : 
          	<input type='text' size='15' name='con_agnt_nm2' value='<%=client.getCon_agnt_nm2()%>' maxlength='20' class='text'>
          	&nbsp;부서 : 
            <input type='text' size='15' name='con_agnt_dept2' value='<%=client.getCon_agnt_dept2()%>' maxlength='15' class='text'>
            &nbsp;직위 : 
            <input type='text' size='15' name='con_agnt_title2' value='<%=client.getCon_agnt_title2()%>' maxlength='10' class='text'>
            &nbsp;EMAIL : 
            <input type='text' size='40' name='con_agnt_email2' value='<%=client.getCon_agnt_email2()%>' maxlength='30' class='text'>
            &nbsp;이동전화 :                         
            <input type='text' size='15' name='con_agnt_m_tel2' value='<%=client.getCon_agnt_m_tel2()%>' maxlength='15' class='text'>
          </td>
        </tr>
      </table></td>
    </tr>	
    <tr>
      <td class=h></td>
    </tr>
    <tr>
      <td><img src=/acar/images/center/icon_arrow.gif align=absmiddle> <span class=style2>매출구분</span></td>
      <td align="right">
	  </td>
    </tr>
    <tr>
      <td colspan="2" class="line"><table border="0" cellspacing="1" cellpadding="0" width='100%'>
      	<tr><td class=line2 style='height:1'></td></tr>
        <tr>
          <td width='10%' class='title'>매출</td>
          <td width='90%'>&nbsp;
		      <input type="radio" name="car_use" value="1" <%if(cr_bean.getCar_use().equals("1"))%>checked<%%>>
              대여사업매출&nbsp;
              <input type="radio" name="car_use" value="2" <%if(cr_bean.getCar_use().equals("2"))%>checked<%%>>
              리스사업매출&nbsp;
			  </td>
          </tr>
      </table></td>
    </tr>				
    <tr>
      <td colspan="2" class=h></td>
    </tr>	
    <tr>
      <td colspan="2" align="right">
	  <%//if(auth_rw.equals("2") || auth_rw.equals("4") || auth_rw.equals("6")){%>
	  <a href="javascript:tax_reg();"><img src="/acar/images/center/button_reg.gif" align="absmiddle" border="0">
	  <%//}%>
	  </td>
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