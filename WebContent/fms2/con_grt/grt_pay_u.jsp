<%@ page language="java" contentType="text/html;charset=euc-kr"%>
<%@ page import="java.util.*, acar.util.*, acar.cont.*, acar.ext.*, acar.bill_mng.*, acar.client.*, acar.car_mst.*, tax.*, acar.common.*"%>
<jsp:useBean id="ae_db" scope="page" class="acar.ext.AddExtDatabase"/>
<jsp:useBean id="al_db" scope="page" class="acar.client.AddClientDatabase"/>
<jsp:useBean id="a_db" scope="page" class="acar.cont.AddContDatabase"/>
<jsp:useBean id="ScdMngDb" scope="page" class="tax.ScdMngDatabase"/>
<%@ include file="/acar/cookies.jsp" %>

<%
	String auth = request.getParameter("auth")==null?"":request.getParameter("auth");	
	String auth_rw = request.getParameter("auth_rw")==null?"":request.getParameter("auth_rw");
	String user_id = request.getParameter("user_id")==null?"":request.getParameter("user_id");//로그인-ID
	String br_id = request.getParameter("br_id")==null?"":request.getParameter("br_id");//로그인-영업소
	String gubun1 = request.getParameter("gubun1")==null?"2":request.getParameter("gubun1");
	String gubun2 = request.getParameter("gubun2")==null?"5":request.getParameter("gubun2");
	String gubun3 = request.getParameter("gubun3")==null?"3":request.getParameter("gubun3");
	String gubun4 = request.getParameter("gubun4")==null?"1":request.getParameter("gubun4");
	String st_dt = request.getParameter("st_dt")==null?"":request.getParameter("st_dt");
	String end_dt = request.getParameter("end_dt")==null?"":request.getParameter("end_dt");
	String s_kd = request.getParameter("s_kd")==null?"0":request.getParameter("s_kd");
	String t_wd = request.getParameter("t_wd")==null?"":request.getParameter("t_wd");
	String sort_gubun = request.getParameter("sort_gubun")==null?"0":request.getParameter("sort_gubun");
	String asc = request.getParameter("asc")==null?"0":request.getParameter("asc");
	String idx = request.getParameter("idx")==null?"0":request.getParameter("idx");
	
	String mode 	= request.getParameter("mode")==null?"":request.getParameter("mode");
	String m_id 	= request.getParameter("m_id")==null?"":request.getParameter("m_id");
	String l_cd 	= request.getParameter("l_cd")==null?"":request.getParameter("l_cd");
	String rent_st 	= request.getParameter("rent_st")==null?"":request.getParameter("rent_st");
	String pp_st 	= request.getParameter("pp_st")==null?"":request.getParameter("pp_st");
	String pp_tm 	= request.getParameter("pp_tm")==null?"":request.getParameter("pp_tm");
	
	String pay_dt	= request.getParameter("pay_dt")==null?Util.getDate():request.getParameter("pay_dt");
	String est_dt	= request.getParameter("est_dt")==null?pay_dt:request.getParameter("est_dt");
	int pay_amt		= request.getParameter("pay_amt")==null?0:Util.parseDigit(request.getParameter("pay_amt"));
	
	//선수금 스케줄 조회
	ExtScdBean pay_grt = ae_db.getAGrtScd(m_id, l_cd, rent_st, pp_st, pp_tm);
	
	if(!est_dt.equals("") && pay_grt.getExt_est_dt().equals("")) 		pay_grt.setExt_est_dt(est_dt);
	if(!pay_dt.equals("") && pay_grt.getExt_pay_dt().equals("")) 		pay_grt.setExt_pay_dt(pay_dt);
	if(pay_amt > 0        && pay_grt.getExt_pay_amt() == 0 ) 			pay_grt.setExt_pay_amt(pay_amt);
	
	
	String client_id	= "";
	String site_id 		= "";
	String tax_branch	= "";
	String bank_code 	= "";
	String deposit_no 	= "";
	
	//장기계약 상단정보
	LongRentBean bean       = ScdMngDb.getScdMngLongRentInfo("", l_cd);
	
	//계약:고객관련
	ContBaseBean base 		= a_db.getContBaseAll(m_id, l_cd);
	if(base.getTax_type().equals("2")){//지점
		site_id = base.getR_site();
	}else{
		site_id = "";
	}
	client_id = base.getClient_id();
	
	//대여정보
	ContFeeBean fee = a_db.getContFeeNew(m_id, l_cd, "1");
	tax_branch 	= fee.getBr_id()==""?br_id:fee.getBr_id();
	
	//거래처정보
	ClientBean client = al_db.getClient(client_id);
	bank_code 	= client.getBank_code()==""?"260":client.getBank_code();
	deposit_no 	= client.getDeposit_no();
	
	String i_enp_no = client.getEnp_no1() +""+ client.getEnp_no2() +""+ client.getEnp_no3();
	if(client.getEnp_no1().equals("")) i_enp_no = client.getSsn1() +""+ client.getSsn2();
	String i_ssn 		= client.getSsn1() +""+ client.getSsn2();
	String i_firm_nm 	= client.getFirm_nm();
	String i_client_nm 	= client.getClient_nm();
	String i_sta 		= client.getBus_cdt();
	String i_item 		= client.getBus_itm();
	String i_zip 		= client.getO_zip();
	String i_addr 		= client.getO_addr();
	String i_tel 		= client.getO_tel();
	String i_agnt_nm	= client.getCon_agnt_nm();
	String i_agnt_email	= client.getCon_agnt_email();
	String i_agnt_m_tel = client.getCon_agnt_m_tel();
	
	if(!site_id.equals("")){
		//거래처지점정보
		ClientSiteBean site = al_db.getClientSite(client_id, site_id);
		i_enp_no 		= site.getEnp_no();
		i_firm_nm 		= site.getR_site();
		i_client_nm 	= site.getSite_jang();
		i_sta 			= site.getBus_cdt();
		i_item 			= site.getBus_itm();
		i_zip 			= site.getZip();
		i_addr 			= site.getAddr();
		i_tel 			= site.getTel();
		i_agnt_nm		= site.getAgnt_nm();
		i_agnt_email	= site.getAgnt_email();
		i_agnt_m_tel 	= site.getAgnt_m_tel();
	}
	
	NeoErpUDatabase neoe_db = NeoErpUDatabase.getInstance();
	
	//네오엠-거래처정보
	CodeBean[] vens = neoe_db.getCodeAll(i_firm_nm);
	int ven_size = vens.length;
	//네오엠-은행정보
	CodeBean[] banks = neoe_db.getCodeAll();
	int bank_size = banks.length;
	//네오엠-은행 계좌번호
	Vector deposits = neoe_db.getDepositList(bank_code);
	int deposit_size = deposits.size();
	
	//차량기본정보
	ContCarBean car 	= a_db.getContCar(m_id, l_cd);
	//자동차회사&차종&자동차명
	AddCarMstDatabase a_cmb = AddCarMstDatabase.getInstance();
	CarMstBean mst 		= a_cmb.getCarNmCase(car.getCar_id(), car.getCar_seq());
%>

<html>
<head><title>FMS</title>
<script language='JavaScript' src='../../include/common.js'></script>
<script language='javascript'>
<!--
	function save()
	{

		var fm = document.form1;
		var ment  = '';
		
		<%if(pp_st.equals("0") || (pp_st.equals("5") && pay_grt.getExt_v_amt()==0)){%>
		if(fm.ebill.checked == true){
			if(fm.agnt_nm.value == "")		{ alert("수신담당자명을 입력하십시오."); return; }
			if(fm.agnt_email.value == "")	{ alert("수신이메일를 입력하십시오."); return; }
			
			if(fm.agnt_email.value.indexOf("@") == -1) { alert('이메일 주소를 확인하십시오.'); return;}

			ment = '트러스빌 전자입금표를 발행하시겠습니까?';
			
			fm.firm_nm.value 	= charRound(fm.firm_nm.value  	,38);
			fm.client_nm.value 	= charRound(fm.client_nm.value	,18);
			fm.i_sta.value 		= charRound(fm.i_sta.value  	,38);				
			fm.i_item.value 	= charRound(fm.i_item.value  	,38);						
			
		}
		<%}%>
		
		<%if(mode.equals("pay")){%>
		if( !isDate(fm.pay_dt.value) || (fm.pay_dt.value == '') || (fm.pay_amt.value == '') || (parseDigit(fm.pay_amt.value) == '0') || (parseDigit(fm.pay_amt.value).length > 8))
		{
			alert('입금일과 입금액을 확인하십시오');
			return;
		}
		if(toInt(parseDigit(fm.grt_amt.value))<toInt(parseDigit(fm.pay_amt.value)))
		{
			alert('입금액을 확인하세요');
			return;
		}
		if(fm.autodoc.checked == true){
			if(fm.ven_code.value == ""){ alert("거래처명이 맞지 않습니다.\n\nFMS 거래처관리의 거래처명과 \n네오엠의 거래처명이 같은지 확인하십시오."); return; }
			//거래처
			var ven_code = fm.ven_code.options[fm.ven_code.selectedIndex].value;
			var ven_code_split = ven_code.split("#");
			
			fm.ven_code2.value 	= ven_code_split[0];
			fm.ven_nm.value 	= ven_code_split[1];
			
			var bank_code = fm.bank_code.options[fm.bank_code.selectedIndex].value;
			fm.bank_code2.value = bank_code.substring(0,3);
			fm.bank_name.value = bank_code.substring(3);
			
			//계좌번호		
			var deposit_no = fm.deposit_no.options[fm.deposit_no.selectedIndex].value;
			var deposit_split = deposit_no.split(":");
			
			fm.deposit_no2.value = deposit_split[0];			

			if(fm.ven_nm.value == "")		{ alert("거래처명을 확인하십시오."); 	return; }			
			if(fm.bank_code.value == "")	{ alert("은행을 선택하십시오."); 		return; }			
			if(fm.deposit_no.value == "")	{ alert("계좌번호를 선택하십시오."); 	return; }									
		}		
		ment = '입금처리하시겠습니까?';			
		<%}%>
		
		if(confirm(ment))
		{		
			fm.target = 'i_no';
			fm.action = 'grt_pay_u_a.jsp'
			fm.submit();
		}
	}
	
	//은행선택시 계좌번호 가져오기
	function change_bank(){
		var fm = document.form1;
		var bank_code = fm.bank_code.options[fm.bank_code.selectedIndex].value;
		fm.bank_code2.value = bank_code.substring(0,3);
		fm.bank_name.value = bank_code.substring(3);
		
		drop_deposit();		

		if(bank_code == ''){
			fm.bank_code.options[0] = new Option('선택', '');
			return;
		}else{
			fm.target='i_no';
			fm.action='/fms2/con_fee/get_deposit_nodisplay.jsp?bank_code='+bank_code.substring(0,3);
			fm.submit();
		}
	}
	
	function drop_deposit(){
		var fm = document.form1;
		var deposit_len = fm.deposit_no.length;
		for(var i = 0 ; i < deposit_len ; i++){
			fm.deposit_no.options[deposit_len-(i+1)] = null;
		}
	}
		
	function add_deposit(idx, val, str){
		document.form1.deposit_no[idx] = new Option(str, val);		
	}
	
	//거래처 약식등록하기
	function vendor_reg(){
		var fm = document.form1;	
		if(fm.l_cd.value == ""){ alert("계약번호가 없습니다."); return; }	
		fm.ven_nm.value 	= charRound('<%=i_firm_nm%>'  ,28);
		fm.dname.value 		= charRound('<%=i_client_nm%>',28);
		fm.uptae.value 		= charRound('<%=i_sta%>'      ,28);				
		fm.jong.value 		= charRound('<%=i_item%>'     ,28);						
		fm.target='i_no';
		fm.action='vendor_reg_a.jsp';
		fm.submit();
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
<meta http-equiv="content-type" content="text/html; charset=euc-kr">
<link rel=stylesheet type="text/css" href="/include/table_t.css">
</head>
<body>
<form name='form1' action='/fms2/con_grt/grt_pay_u_a.jsp' method='post'>
<input type='hidden' name='auth' value='<%=auth%>'>
<input type='hidden' name='auth_rw' value='<%=auth_rw%>'>
<input type='hidden' name='user_id' value='<%=user_id%>'>
<input type='hidden' name='br_id' value='<%=br_id%>'>
<input type='hidden' name='gubun1' value='<%=gubun1%>'>
<input type='hidden' name='gubun2' value='<%=gubun2%>'>
<input type='hidden' name='gubun3' value='<%=gubun3%>'>
<input type='hidden' name='gubun4' value='<%=gubun4%>'>
<input type='hidden' name='st_dt' value='<%=st_dt%>'>
<input type='hidden' name='end_dt' value='<%=end_dt%>'>
<input type='hidden' name='s_kd' value='<%=s_kd%>'>
<input type='hidden' name='t_wd' value='<%=t_wd%>'>
<input type='hidden' name='sort_gubun' value='<%=sort_gubun%>'>
<input type='hidden' name='asc' value='<%=asc%>'>
<input type='hidden' name='idx' value='<%=idx%>'>
<input type='hidden' name='mode' value='<%=mode%>'>
<input type='hidden' name='m_id' value='<%=m_id%>'>
<input type='hidden' name='l_cd' value='<%=l_cd%>'>
<input type='hidden' name='rent_st' value='<%=rent_st%>'>
<input type='hidden' name='pp_st' value='<%=pp_st%>'>
<input type='hidden' name='pp_tm' value='<%=pp_tm%>'>
<input type='hidden' name='node_code' value='<%=tax_branch%>01'>
<input type='hidden' name='client_id' value='<%=client_id%>'>
<input type='hidden' name='ven_code2' value=''>
<input type='hidden' name='bank_code2' value=''>
<input type='hidden' name='deposit_no2' value=''>
<input type='hidden' name='bank_name' value=''>
<!--네오엠  거래처-->
<input type='hidden' name='ven_nm' value=''>
<input type='hidden' name='dname' value=''>
<input type='hidden' name='uptae' value=''>
<input type='hidden' name='jong' value=''>
<!--트러스빌거래처-->
<input type='hidden' name='tax_branch' value='<%=tax_branch%>'>
<input type='hidden' name='client_st' value='<%=client.getClient_st()%>'>
<input type='hidden' name='firm_nm'	  value='<%=i_firm_nm%>'>
<input type='hidden' name='client_nm' value='<%=i_client_nm%>'>
<input type='hidden' name='enp_no' 	  value='<%=i_enp_no%>'>
<input type='hidden' name='ssn' 	  value='<%=i_ssn%>'>
<input type='hidden' name='i_sta' 	  value='<%=i_sta%>'>
<input type='hidden' name='i_item' 	  value='<%=i_item%>'>
<input type='hidden' name='zip' 	  value='<%=i_zip%>'>
<input type='hidden' name='addr' 	  value='<%=i_addr%>'>
<input type='hidden' name='tel' 	  value='<%=i_tel%>'>

<table border="0" cellspacing="0" cellpadding="0" width=100%>
	<tr> 
        <td>
            <table width=100% border=0 cellpadding=0 cellspacing=0>
                <tr>
                    <td width=7><img src=/acar/images/center/menu_bar_1.gif width=7 height=33></td>
                    <td class=bar>&nbsp;&nbsp;&nbsp;<img src=/acar/images/center/menu_bar_dot.gif width=4 height=5 align=absmiddle>&nbsp;<span class=style1>재무회계 > 수금관리 > 선수금 관리 > <span class=style5>선수금 수금 처리</span></span></td>
                    <td width=7><img src=/acar/images/center/menu_bar_2.gif width=7 height=33></td>
                </tr>
            </table>            
        </td>
    </tr>
    <tr> 
        <td class=h></td>
    </tr>
	<tr>
		<td>
			 <table border="0" cellspacing="0" cellpadding="0" width=100%>
			    <tr>
			        <td class=line2></td>
			    </tr>
			 	<tr>
			 		<td class='line'>
			 			<table border="0" cellspacing="1" cellpadding="0" width=100%>
							<tr>
								<td width=20% class='title'>계약번호</td>
								<td width=30%>&nbsp;<%=l_cd%></td>
								<td width=20% class='title'>상호</td>
								<td width=30%>
								    <table border="0" cellspacing="0" cellpadding="3" width=100%>
							            <tr><td><%=i_firm_nm%></td>
							            </tr>
							        </table>
							    </td>
							</tr>
							<tr>
								<td class='title'>구분</td>
								<td>&nbsp;<%if(pp_st.equals("0")){%>보증금<%}else if(pp_st.equals("1")){%>선납금<%}else if(pp_st.equals("2")){%>개시대여료<%}else if(pp_st.equals("5")){%>승계수수료<%}%></td>
								<td class='title'>회차</td>
								<td>&nbsp;<%=pay_grt.getExt_tm()%></td>
							</tr>
							<tr>
								<td class='title'>공급가</td>
								<td>&nbsp;<input type='text' name='grt_s_amt' size='10' value='<%=Util.parseDecimal(pay_grt.getExt_s_amt())%>' class='whitenum' readonly>원</td>
								<td class='title'>부가세</td>
								<td>&nbsp;<input type='text' name='grt_v_amt' size='10' value='<%=Util.parseDecimal(pay_grt.getExt_v_amt())%>' class='whitenum' readonly>원</td>
							</tr>
							<tr>
							  <td class='title'>입금예정일</td>
							  <td>&nbsp;<%=pay_grt.getExt_est_dt()%></td>
							  <td class='title'>합계</td>
							  <td>&nbsp;<input type='text' name='grt_amt' size='11' value='<%=Util.parseDecimal(pay_grt.getExt_s_amt()+pay_grt.getExt_v_amt())%>' class='whitenum' readonly>원</td>
						  </tr>
							<tr>
							  <td class='title'>입금일자</td>
							  <td>
						      &nbsp;<input type='text' name='pay_dt' size='11' value='<%=pay_grt.getExt_pay_dt()%>' class='text' onBlur='javascript:this.value=ChangeDate(this.value);'></td>
							  <td class='title'>실입금액</td>
							  <td>
						      &nbsp;<input type='text' name='pay_amt' size='10' maxlength='10' value='<%=Util.parseDecimal(pay_grt.getExt_pay_amt())%>' class='num' onBlur='javascript:this.value=parseDecimal(this.value)'>원</td>
						  </tr>
						</table>
					</td>
				</tr>				
				<tr>
					<td colspan='6' >&nbsp;</td>
				</tr>
				<%if(pp_st.equals("0") || (pp_st.equals("5") && pay_grt.getExt_v_amt()==0)){%>
				<tr>
			        <td class=line2></td>
			    </tr>
				<tr>
					<td colspan='6' class='line'>
						<table border="0" cellspacing="1" cellpadding="0" width=100%>
							<tr>
								<td rowspan="6" width=7% class='title' align="center">트<br>러<br>스<br>빌</td>
								<td width='20%' class='title'>전자입금표</td>
								<td width="73%">&nbsp;
								  <input type="checkbox" name="ebill" value="Y" <%if(!i_agnt_email.equals(""))%>checked<%%>>
							    발행</td>
							</tr>							
							<tr>
								<td class='title'>수신거부</td>
								<td>&nbsp;
							    <%=client.getEtax_not_cau()%></td>
							</tr>
							<tr>
								<td class='title'>담당자</td>
								<td>&nbsp;
							    <input type='text' size='15' name='agnt_nm' value='<%=i_agnt_nm%>' maxlength='20' class='text'></td>
							</tr>
							<tr>
							  <td class='title'>EMAIL</td>
							  <td>&nbsp;
						      <input type='text' size='40' name='agnt_email' value='<%=i_agnt_email%>' maxlength='30' class='text'></td>
						  </tr>
							<tr>
							  <td class='title'>이동전화</td>
							  <td>&nbsp;
                                <input type='text' size='15' name='agnt_m_tel' value='<%=i_agnt_m_tel%>' maxlength='15' class='text'></td>
						  </tr>
							<tr>
							  <td class='title'>비고</td>
							  <td>&nbsp;
								<textarea name="bigo" cols="45" class="text" rows="2"><%if(pp_st.equals("0")){%>장기대여보증금<%}else if(pp_st.equals("1")){%>선납금<%}else if(pp_st.equals("2")){%>개시대여료<%}else if(pp_st.equals("5")){%>계약승계수수료<%}%></textarea>
                                </td>
						  </tr>
							
					  </table>
					</td>
				</tr>	
				<tr>
					<td colspan='6' >&nbsp;</td>
				</tr>
				<%}%>		
				<%if(mode.equals("pay")){%>	
				<tr>
			        <td class=line2></td>
			    </tr>
				<tr>
					<td colspan='6' class='line'>						
                        <table border="0" cellspacing="1" cellpadding="0" width=100%>
                            <tr> 
                              <td class='title' align="center" rowspan="7" width=7%>N<br>
                                E<br>
                                O<br>
                                |<br>
                                M</td>
                              <td width=20% class='title'>자동전표</td>
                              <td width=73%>&nbsp; 
                                <input type="checkbox" name="autodoc" value="Y" checked>생성
                              </td>
                            </tr>
                            <tr> 
                              <td class='title'>거래처</td>
                              <td>&nbsp; 
                                <select name='ven_code'>
                                  <%if(ven_size > 0){
            							for(int i = 0 ; i < ven_size ; i++){
            								CodeBean ven = vens[i];	%>
                                  <option value='<%= ven.getCode()%>#<%= ven.getNm()%>'>(<%= ven.getCode()%>)<%= ven.getNm()%></option>
                                  <%	}
            					}	%>
                                </select>
            					<%if(ven_size==0 && !i_firm_nm.equals("")){%><input type="button" name="b_ms2" value="약식등록" class="btn" onClick="javascript:vendor_reg();" ><%}%>
                              </td>
                            </tr>
                            <tr> 
                              <td class='title'>발생일자</td>
                              <td>&nbsp; 
                                <input type='text' name='acct_dt' size='12' value='<%=pay_grt.getExt_pay_dt()%>' class='text' onBlur='javascript:this.value=ChangeDate(this.value);'>
                              </td>
                            </tr>
                            <tr> 
                              <td class='title'>계정과목</td>
                              <td>&nbsp; 
            				  <%if(pp_st.equals("0")){%>
            				    <input type="radio" name="acct_code" value="31100" checked>
                                장기대여보증금
            				  <%}else{%>
                                <input type="radio" name="acct_code" value="10800" checked>
                                외상매출금 
                                <input type="radio" name="acct_code" value="25900">
                                선수금
            				  <%}%>					
            					</td>
                            </tr>
                            <tr> 
                              <td class='title'>은행</td>
                              <td>&nbsp; 
                                <select name='bank_code' onChange='javascript:change_bank()'>
                                  <option value=''>선택</option>
                                  <%if(bank_size > 0){
            							for(int i = 0 ; i < bank_size ; i++){
            								CodeBean bank = banks[i];	%>
            	                  <option value='<%= bank.getCode()%><%= bank.getNm()%>' <%if(bank_code.equals(bank.getCode())){%> selected <%}%>><%= bank.getNm()%></option>
                                  <%	}
            						}	%>
                                </select>
                              </td>
                            </tr>
                            <tr> 
                              <td class='title'>계좌번호</td>
                              <td>&nbsp; 
                                <select name='deposit_no'>
                                  <option value=''>선택</option>
            					  <%if(deposit_size > 0){
            							for(int i = 0 ; i < deposit_size ; i++){
            								Hashtable deposit = (Hashtable)deposits.elementAt(i);%>
            	                  <option value='<%= deposit.get("DEPOSIT_NO")%>' <%if(deposit_no.equals(String.valueOf(deposit.get("DEPOSIT_NO")))){%> selected <%}%>><%= deposit.get("DEPOSIT_NO")%>:<%= deposit.get("DEPOSIT_NAME")%></option>
                                  <%	}
            						}	%>					  
                                </select>
                              </td>
                            </tr>
                            <tr> 
                              <td class='title'>적요</td>
                              <td>&nbsp; 
                                <textarea name="acct_cont" cols="45" class="text" rows="2"><%if(pp_st.equals("0")){%>장기대여보증금<%}else if(pp_st.equals("1")){%>선납금<%}else if(pp_st.equals("2")){%>개시대여료<%}else if(pp_st.equals("5")){%>승계수수료<%}%>-<%=i_firm_nm%> <%=base.getCar_no()%><%if(base.getCar_no().equals("")){%><%=l_cd%><%}%></textarea>
                              </td>
                            </tr>
                        </table>
					</td>
				</tr>
				<%}%>							
			</table>
		</td>
	</tr>
	<tr>
		<td align='right'>
		<%if(mode.equals("pay")){  %><a href="javascript:save()"><img src=/acar/images/center/button_igcl.gif align=absmiddle border=0></a><%  }%>
		<%if(mode.equals("ebill")){%><a href="javascript:save()"><img src=/acar/images/center/button_igpbh.gif align=absmiddle border=0></a><%}%>
		&nbsp;<a href="javascript:window.close()"><img src=/acar/images/center/button_close.gif align=absmiddle border=0></a>
		</td>
	</tr>
</table>
</form>
<script language='javascript'>
<!--
//-->
</script>
<iframe src="about:blank" name="i_no" width="0" height="0" frameborder="0" noresize></iframe>
</body>
</html>