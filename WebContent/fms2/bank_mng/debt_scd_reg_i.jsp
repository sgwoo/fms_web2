<%@ page language="java" contentType="text/html;charset=euc-kr"%>
<%@ page import="java.util.*, acar.util.*, acar.common.*,  acar.bill_mng.*,  acar.bank_mng.*, acar.forfeit_mng.*, acar.cont.*"%>
<jsp:useBean id="FineDocDb" scope="page" class="acar.forfeit_mng.FineDocDatabase"/>
<jsp:useBean id="FineDocBn" 	scope="page" class="acar.forfeit_mng.FineDocBean"/>
<jsp:useBean id="a_db" scope="page" class="acar.cont.AddContDatabase"/>
<jsp:useBean id="rs_db" scope="page" class="acar.res_search.ResSearchDatabase"/>
<jsp:useBean id="code_bean" scope="page" class="acar.common.CodeBean"/>
<jsp:useBean id="ce_bean" class="acar.common.CodeEtcBean" scope="page"/>
<jsp:useBean id="abl_db" scope="page" class="acar.bank_mng.AddBankLendDatabase"/>
<%@ include file="/acar/cookies.jsp" %>
<%@ include file="/acar/access_log.jsp" %>

<% 
	CommonDataBase c_db = CommonDataBase.getInstance();
	NeoErpUDatabase neoe_db = NeoErpUDatabase.getInstance();
	LoginBean login = LoginBean.getInstance();
	
	//로그인 사용자정보	
	String user_id = login.getCookieValue(request, "acar_id");
	
	int flag1 = 0;
	int count = 0;	
	
	String auth_rw 	= request.getParameter("auth_rw")==null?"":request.getParameter("auth_rw");
	String doc_id 	= request.getParameter("doc_id")==null?"":request.getParameter("doc_id");
	
	if(auth_rw.equals(""))	auth_rw = rs_db.getAuthRw(user_id, "05", "05", "11");	
	
	String vid_num="";
	
	String ch_i="";
	String ch_l_id="";
	String ch_gubun="";
	
	String ven_code = "";
	String ven_name = "";
		
	//네오엠-은행정보
	CodeBean[] banks = neoe_db.getCodeAll();
	int bank_size = banks.length;
	
	FineDocBn = FineDocDb.getFineDoc(doc_id);
	
	//대출신청리스트-대출내역서
	Vector FineList = FineDocDb.getBankDocAllLists2(doc_id);
	
	//할부정보
	ContDebtBean f_debt = new ContDebtBean();
	//은행대출 정보
	BankLendBean bl = new BankLendBean();
	BankRtnBean rtn = new BankRtnBean();
	if(FineList.size()>0){
		for(int i=0; i<1; i++){ 
			Hashtable ht = (Hashtable)FineList.elementAt(i);		
			//할부정보
			f_debt = a_db.getContDebt(String.valueOf(ht.get("RENT_MNG_ID")), String.valueOf(ht.get("RENT_L_CD")));
			if(!f_debt.getLend_id().equals("")){
				bl = abl_db.getBankLend(f_debt.getLend_id());
				rtn = abl_db.getBankRtn(f_debt.getLend_id(), f_debt.getRtn_seq());
				f_debt.setFst_pay_dt(bl.getFst_pay_dt());
				f_debt.setCls_rtn_fee_int(bl.getCls_rtn_fee_int());
				f_debt.setCls_rtn_etc(bl.getCls_rtn_etc());
				f_debt.setFund_id(bl.getFund_id());
				f_debt.setBank_code(bl.getBank_code());
				f_debt.setDeposit_no(bl.getDeposit_no_d());
				if(!rtn.getFst_pay_dt().equals("")){
					f_debt.setFst_pay_dt(rtn.getFst_pay_dt());						
				}
				f_debt.setRtn_est_dt(rtn.getRtn_est_dt());
				f_debt.setVen_code(rtn.getVen_code());
				if(ck_acar_id.equals("000029")){
					out.println("f_debt.getLend_id()="+f_debt.getLend_id());
					out.println("f_debt.getRtn_seq()="+f_debt.getRtn_seq());
					out.println("bl.getFst_pay_dt()="+bl.getFst_pay_dt());
					out.println("rtn.getFst_pay_dt()="+rtn.getFst_pay_dt());
				}	
			}
		}
	}
	
	code_bean = c_db.getCodeBean("0003", FineDocBn.getGov_id(), "");
	ce_bean =  c_db.getCodeEtc("0003", FineDocBn.getGov_id());

	if(f_debt.getVen_code().equals("")){
		f_debt.setVen_code(ce_bean.getVen_code());
	}

	Hashtable ven = new Hashtable();
	if(!f_debt.getVen_code().equals("")){
		ven = neoe_db.getVendorCase(f_debt.getVen_code());
		ven_name = String.valueOf(ven.get("VEN_NAME"));
	}	

	long sum_amt1 = 0;
	long sum_amt2 = 0;
	long sum_amt3 = 0;
	long sum_amt4 = 0;
	
	
%>

<html>
<title>FMS</title>
<meta http-equiv="content-type" content="text/html; charset=euc-kr">
	<%@ include file="/acar/getNaviCookies.jsp" %>
<link rel="stylesheet" type="text/css" href="/include/table_t.css">
<script language="JavaScript" src="/include/common.js"></script>
<script language="JavaScript">
<!--
	//등록
	function Save()
	{
		var fm = document.form1;	
		
		if(fm.doc_id.value == '')		{	alert('문서번호를 입력하십시오.'); 		fm.doc_id.focus(); 		return; }
		if(fm.loan_st.value == '')		{	alert('대출형태를 입력하십시오.'); 		fm.loan_st.focus(); 		return; }
		
		
		if(fm.lend_dt.value == '')		{	alert('대출일을 입력하십시오.'); 		fm.lend_dt.focus(); 		return; }
		if(fm.cpt_cd_st.value == '')		{	alert('금융사형태를 입력하십시오.'); 		fm.cpt_cd_st.focus(); 		return; }
		if(fm.lend_int_way.value == '')		{	alert('이자계산방식을 선택하십시오.'); 		fm.lend_int_way.focus(); 	return; }
		
		
		if(fm.loan_st.value == '2' && fm.lend_id.value ==  '')	{	alert('묶음대출인 경우 계약번호를 반드시 입력하세요.'); 	fm.loan_st.focus(); 		return; }		
		if(fm.fst_pay_dt.value == ''){	alert('1회차결재일을 입력하십시오.'); 				fm.fst_pay_dt.focus(); 		return; }
						
		if(fm.acct_code[0].checked == false && fm.acct_code[1].checked == false )	{ alert('계정과목을 선택하십시오.'); return;}
		
		if(fm.ven_code.value == '')	{ 	alert('거래처를 확인하십시오.'); 		return;}
		if(fm.bank_code.value == '')	{ 	alert('은행을 확인하십시오.'); 			return;}
		if(fm.deposit_no.value == '')	{ 	alert('계좌번호를 확인하십시오.'); 		return;}
		
		if(fm.loan_st.value == '2' && fm.all_alt_tm.value ==  '')	{	alert('묶음대출인 경우 할부횟수를 입력하세요.'); 	fm.all_alt_tm.focus(); 		return; }
		
		if(fm.loan_st.value == '2' && toInt(fm.tot_alt_amt.value) ==  0)	{	set_alt_amt();  }
		
		//개별대출	
		if(fm.loan_st.value == '1' && fm.rtn_est_dt.value != '99'){
			var est_dt = replaceString('-','',fm.fst_pay_dt.value);
			var est_d = est_dt.substring(6,8);
			if(toInt(fm.rtn_est_dt.value) > toInt(est_d) || toInt(fm.rtn_est_dt.value) < toInt(est_d)){
				if(!confirm('1회차결재일과 상한약정일이 다릅니다. 등록하시겠습니까?')){			
					return;
				}
			}
		}
		
		fm.mode.value = '';
		
		if(confirm('등록하시겠습니까?')){					
			fm.action='debt_scd_reg_i_a.jsp';		
			//fm.target='i_no';
			fm.target='_blank';			
			fm.submit();
		}
	}
	
//등록 확인 - 보기만
function Save_view()
{
	var fm = document.form1;	
	
	if(fm.doc_id.value == '')		{	alert('문서번호를 입력하십시오.'); 		fm.doc_id.focus(); 		return; }
	if(fm.loan_st.value == '')		{	alert('대출형태를 입력하십시오.'); 		fm.loan_st.focus(); 		return; }
	
	
	if(fm.lend_dt.value == '')		{	alert('대출일을 입력하십시오.'); 		fm.lend_dt.focus(); 		return; }
	if(fm.cpt_cd_st.value == '')		{	alert('금융사형태를 입력하십시오.'); 		fm.cpt_cd_st.focus(); 		return; }
	if(fm.lend_int_way.value == '')		{	alert('이자계산방식을 선택하십시오.'); 		fm.lend_int_way.focus(); 	return; }
	
	
	if(fm.loan_st.value == '2' && fm.lend_id.value ==  '')	{	alert('묶음대출인 경우 계약번호를 반드시 입력하세요.'); 	fm.loan_st.focus(); 		return; }
	if(fm.fst_pay_dt.value == ''){	alert('1회차결재일을 입력하십시오.'); 				fm.fst_pay_dt.focus(); 		return; }	
					
	if(fm.acct_code[0].checked == false && fm.acct_code[1].checked == false )	{ alert('계정과목을 선택하십시오.'); return;}
	
	if(fm.ven_code.value == '')	{ 	alert('거래처를 확인하십시오.'); 		return;}
	if(fm.bank_code.value == '')	{ 	alert('은행을 확인하십시오.'); 			return;}
	if(fm.deposit_no.value == '')	{ 	alert('계좌번호를 확인하십시오.'); 		return;}
	
	if(fm.loan_st.value == '2' && fm.all_alt_tm.value ==  '')	{	alert('묶음대출인 경우 할부횟수를 입력하세요.'); 	fm.all_alt_tm.focus(); 		return; }
	
	if(fm.loan_st.value == '2' && toInt(fm.tot_alt_amt.value) ==  0)	{	set_alt_amt();  }
	
		
	//개별대출	
	if(fm.loan_st.value == '1' && fm.rtn_est_dt.value != '99'){
		var est_dt = replaceString('-','',fm.fst_pay_dt.value);
		var est_d = est_dt.substring(6,8);
		if(toInt(fm.rtn_est_dt.value) > toInt(est_d) || toInt(fm.rtn_est_dt.value) < toInt(est_d)){
			if(!confirm('1회차결재일과 상한약정일이 다릅니다. 등록하시겠습니까?')){			
				return;
			}
		}
	}
	
	fm.mode.value = 'view';
				
	if(confirm('스케줄계산을  확인 하시겠습니까? 스케줄 확인만 합니다.')){					
		fm.action='debt_scd_reg_i_a.jsp';		
		//fm.target='i_no';
		fm.target='_blank';			
		fm.submit();
	}
}	
	
	//대출공문조회
	function find_doc_search(){
		var fm = document.form1;	
		window.open("find_doc_search.jsp", "SEARCH_FINE_GOV", "left=100, top=100, width=500, height=550, resizable=yes, scrollbars=yes, status=yes");
	}

	//조회하기
	function ven_search(){
		var fm = document.form1;
		var t_wd;
		if(fm.ven_name.value != ''){	fm.t_wd.value = fm.ven_name.value;		}
		else{ 							alert('조회할 거래처명을 입력하십시오.'); 	fm.ven_name.focus(); 	return;}		
		
		window.open("/acar/con_debt/vendor_list.jsp?t_wd="+fm.t_wd.value, "VENDOR_LIST", "left=300, top=300, width=430, height=400, resizable=yes, scrollbars=yes, status=yes");		
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
		
	//할부기간,월상환료 셋팅
	function set_alt_term(obj){
		var fm = document.form1;	
		if(obj == fm.alt_start_dt){//할부기간 종료일 셋팅
			fm.action='debt_dt_nodisplay.jsp?alt_start_dt='+fm.alt_start_dt.value+'&tot_alt_tm='+fm.tot_alt_tm.value;
			fm.target='i_no';
			fm.submit();		
		}
		else if(obj == fm.rtn_tot_amt || obj == fm.tot_alt_tm){
			fm.alt_amt.value = parseDecimal(toInt(parseDigit(fm.rtn_tot_amt.value)) / toInt(parseDigit(fm.tot_alt_tm.value)));	
		}
	}			
	
	//월상환료 자동계산
	function set_alt_amt(){
		var fm = document.form1;
		
		
		var tot_lend_int_amt = 0;
		var tot_rtn_tot_amt = 0;
		var tot_alt_amt = 0;
		
		
		
		for(var i = 0 ; i < <%=FineList.size()%> ; i++){
		
			//할부원금
			var o70 	= toInt(parseDigit(fm.case_lend_prn[i].value));
			//적용이자율
			var ao70 	= toFloat(fm.lend_int.value)/100;
			//상환횟수
			var a_b 	= toInt(fm.case_alt_tm[i].value);
			//10만원당월할부금
			//var ao71 	= Math.round( (ao70/12) * (-100000) * Math.pow(1+ao70/12,a_b) / (1-Math.pow(1+ao70/12,a_b)) );
			//월할부금
			//var o71 	= o70/100000*ao71;
			var o71 = 0;
			
			//20210203 월할부금 계산식 변경 
			var d7 = o70;
			var d9 = ao70;			
			var d11 = a_b;
								
			var v = 1+(d9/12);
			var t = -(d11/12)*12;
				
			//월할부금
			var result=(d7*d9/12)/(1-Math.pow(v,t));
				
			//소숫점절사
			if(fm.lend_alt_way.value == '1'){
				o71 = Math.floor(result);	
			}
			//소숫점반올림
			if(fm.lend_alt_way.value == '2'){
				o71 = Math.round(result);	
			}
			//원단위절상
			if(fm.lend_alt_way.value == '7'){
				o71 = Math.ceil(result/10)*10;	
			}
			//원단위절사
			if(fm.lend_alt_way.value == '3'){
				o71 = Math.floor(result/10)*10;	
			}
			//십원단위절상
			if(fm.lend_alt_way.value == '4'){
				o71 = Math.ceil(result/100)*100;	
			}
			//십원단위절사
			if(fm.lend_alt_way.value == '5'){
				o71 = Math.floor(result/100)*100;	
			}
			//십원단위반올림
			if(fm.lend_alt_way.value == '6'){
				o71 = Math.round(result/100)*100;	
			}
			
								
			//월상환금
			fm.case_alt_amt[i].value 		= parseDecimal(o71);
			fm.case_rtn_tot_amt[i].value 	= parseDecimal(o71*a_b);
			//대출이자 
			fm.case_lend_int_amt[i].value 	= parseDecimal(o71*a_b-o70); 
			
			//fm.cha_int[i].value 	= parseDecimal(toInt(parseDigit(fm.t_alt_int[i].value))-toInt(parseDigit(fm.case_lend_int_amt[i].value)));

			
			tot_lend_int_amt = tot_lend_int_amt + toInt(parseDigit(fm.case_lend_int_amt[i].value));
			tot_rtn_tot_amt  = tot_rtn_tot_amt  + toInt(parseDigit(fm.case_rtn_tot_amt[i].value));
			tot_alt_amt      = tot_alt_amt      + toInt(parseDigit(fm.case_alt_amt[i].value));
			
		}		
		
		if(fm.loan_st.value == '1'){//건별대출		
			fm.tot_rtn_tot_amt.value  = parseDecimal(tot_rtn_tot_amt);
			fm.tot_lend_int_amt.value = parseDecimal(tot_lend_int_amt);
			fm.tot_alt_amt.value      = parseDecimal(tot_alt_amt);
		}else if(fm.loan_st.value == '2'){//묶음대출
			//할부원금
			var o70 	= toInt(parseDigit(fm.tot_lend_prn.value));
			//적용이자율
			var ao70 	= toFloat(fm.lend_int.value)/100;
			if(toFloat(fm.lend_int.value) > 0){
				if(toInt(fm.all_alt_tm.value) == 0){
					alert('일괄변경에 있는  할부횟수를 입력하십시오.'); return;
				}
			}
			//상환횟수
			var a_b 	= toInt(fm.all_alt_tm.value);
			//월할부금
			var o71 = 0;
			
			//20210203 월할부금 계산식 변경 
			var d7 = o70;
			var d9 = ao70;			
			var d11 = a_b;
								
			var v = 1+(d9/12);
			var t = -(d11/12)*12;
				
			//월할부금
			var result=(d7*d9/12)/(1-Math.pow(v,t));
				
			//소숫점절사
			if(fm.lend_alt_way.value == '1'){
				o71 = Math.floor(result);	
			}
			//소숫점반올림
			if(fm.lend_alt_way.value == '2'){
				o71 = Math.round(result);	
			}
			//원단위절상
			if(fm.lend_alt_way.value == '7'){
				o71 = Math.ceil(result/10)*10;	
			}
			//원단위절사
			if(fm.lend_alt_way.value == '3'){
				o71 = Math.floor(result/10)*10;	
			}
			//십원단위절상
			if(fm.lend_alt_way.value == '4'){
				o71 = Math.ceil(result/100)*100;	
			}
			//십원단위절사
			if(fm.lend_alt_way.value == '5'){
				o71 = Math.floor(result/100)*100;	
			}
			//십원단위반올림
			if(fm.lend_alt_way.value == '6'){
				o71 = Math.round(result/100)*100;	
			}
			
			//월상환금
			fm.tot_alt_amt.value 		= parseDecimal(o71);
			//총상환금액
			fm.tot_rtn_tot_amt.value 	= parseDecimal(o71*a_b); 
			//대출이자 
			fm.tot_lend_int_amt.value 	= parseDecimal(o71*a_b-o70); 
			
			if(toFloat(fm.lend_int.value) > 0 && toInt(fm.all_alt_tm.value) > 0){			
				alert('묶음대출 월상환료는 '+fm.tot_alt_amt.value+'입니다.');
			}
		}
		
	}
	
	function set_etc_amt(idx){
		var fm = document.form1;	
			
		//할부원금
		var o70 	= toInt(parseDigit(fm.case_lend_prn[idx].value));			
		//상환횟수
		var a_b 	= toInt(fm.case_alt_tm[idx].value);
		//월상환금
		var o71 	= toInt(parseDigit(fm.case_alt_amt[idx].value));			
			
		//총상환금액
		fm.case_rtn_tot_amt[idx].value 		= parseDecimal(o71*a_b); 
		//대출이자 
		fm.case_lend_int_amt[idx].value 	= parseDecimal(o71*a_b-o70); 		
		
	}
	
	function cng_input(){
		var fm = document.form1;	
		
		if(fm.loan_st.value == '1'){//건별대출
			tr_loan.style.display	= '';
		}else{
			tr_loan.style.display	= 'none';			
		}
				
	}
	
	function cng_input_reg_yn(st){
		var fm = document.form1;		
		for(var i = 0 ; i < <%=FineList.size()%> ; i++){
			if(st == 'reg_yn'){
				fm.reg_yn[i].value = fm.all_reg_yn.value;
			}else if(st == 'alt_tm'){
				fm.case_alt_tm[i].value = fm.all_alt_tm.value;
			}
		}
		if(st == 'alt_tm'){
			set_alt_amt();
		}
	}
	
	//이자엔터키
	function enter(idx){
		var fm = document.form1;
		var keyValue = event.keyCode;
		if (keyValue =='13' && idx+1 != <%=FineList.size()%>){
			fm.case_alt_amt[idx+1].focus();
		}
	}
		
	//시설자금 조회
	function search_fund_bank(){
		var fm = document.form1;
		window.open("/fms2/bank_mng/s_fund_bank.jsp?from_page=/fms2/bank_mng/debt_scd_reg_i.jsp&lend_id="+fm.lend_id.value+"&cont_bn="+fm.cpt_cd.value, "SEARCH_LEND_BANK", "left=50, top=50, width=750, height=600, scrollbars=yes");		
	}	
	
	function view_scd_alt(alt_int, m_id, l_cd, c_id){
		if(alt_int == '0'){		//일반할부금스케줄 등록
			alert('스케줄 등록후 확인할 수 있습니다.');
		}else{					//일반할부금스케줄 수정
			window.open("/acar/con_debt/debt_scd_u.jsp?from_page=/fms2/bank_mng/debt_scd_reg_i.jsp&m_id="+m_id+"&l_cd="+l_cd+"&c_id="+c_id, "VIEW_SCD_ALT", "left=50, top=50, width=1150, height=1000, scrollbars=yes");
		}		
	}
	
	
//-->
</script>
</head>
<body>
<form action="" name="form1" method="POST">
<input type="hidden" name="gubun" value="<%=ch_gubun%>">
<input type="hidden" name="t_wd" value="">  
<input type="hidden" name="mode" value="">
<input type="hidden" name="case_size" value="<%=FineList.size()%>">  
<input type="hidden" name="card_yn" value="<%=FineDocBn.getCard_yn()%>">
<table border=0 cellspacing=0 cellpadding=0 width=100%>
	<tr>
		<td>
			<table width=100% border=0 cellpadding=0 cellspacing=0>
				<tr>
					<td width=7><img src=/acar/images/center/menu_bar_1.gif width=7 height=33></td>
					<td class=bar>&nbsp;&nbsp;&nbsp;<img src=/acar/images/center/menu_bar_dot.gif width=4 height=5 align=absmiddle>&nbsp;
						<span class=style1>재무회계 > 구매자금관리 > <span class=style5>할부등록처리</span></span></td>
					<td width=7><img src=/acar/images/center/menu_bar_2.gif width=7 height=33></td>
				</tr>
			</table>
		</td>
	</tr>
	<tr><td class=h></td></tr>	
	<tr><td class=line2></td></tr>
   <tr> 
        <td class="line"> 
            <table border="0" cellspacing="1" cellpadding="0" width='100%'>
                <tr> 
                    <td class='title' width=12%>문서번호</td>
                    <td width=38%>&nbsp;  
                      <input type="text" name="doc_id" size="15" value="<%=FineDocBn.getDoc_id()%>" class="text" readonly style='IME-MODE: active'>
                  
                      <a href="javascript:find_doc_search();"><img src=/acar/images/center/button_in_search1.gif align=absmiddle border=0></a>
                    </td>
                    <td class=title width=12%>대출형태</td>
                    <td width="38%">&nbsp; 
		              <select name='loan_st' onchange="javascript:cng_input()">
		                <option value="">선택</option>
		                <option value="1">건별대출</option>
		                <option value="2">묶음대출</option>
		              </select>
		            </td>
                </tr>
                
                <tr> 
                    <td class='title'>계약번호</td>
                    <td colspan=3>&nbsp;  
                      <input type="text" name="lend_id" size="10" class="text" value='<%=f_debt.getLend_id()%>'>    
					  &nbsp;  &nbsp;  
					  * 묶음대출 상환구분 : 분할/순차
                      <select name='rtn_seq'>
		                <option value="">선택</option>
		                <option value="1" <%if(!f_debt.getRent_l_cd().equals("") && f_debt.getRtn_seq().equals("1")){%>selected<%}%>>1차</option>
		                <option value="2" <%if(!f_debt.getRent_l_cd().equals("") && f_debt.getRtn_seq().equals("2")){%>selected<%}%>>2차</option>
		                <option value="3" <%if(!f_debt.getRent_l_cd().equals("") && f_debt.getRtn_seq().equals("3")){%>selected<%}%>>3차</option>						
		                <option value="4" <%if(!f_debt.getRent_l_cd().equals("") && f_debt.getRtn_seq().equals("4")){%>selected<%}%>>4차</option>												
		              </select>					                 
                    &nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;
					<font color=blue>* 묶음대출인 경우는 반드시 은행대출관리의 계약번호를 입력하세요. </font>                                  
                     </td>
                </tr>
                
                <tr> 
                    <td class='title'>대출은행</td>
                    <td >&nbsp; 
                      <input type="text" name="cpt_cd" size="6" class="text" value="<%=FineDocBn.getGov_id()%>" readonly  >
                        <input type="text" name="bank_nm" size="30" class="text" value="<%=c_db.getNameById(FineDocBn.getGov_id(), "BANK")%>">
                    </td>
                    <td class=title>금융사구분</td>
                    <td>&nbsp; 
		              <select name='cpt_cd_st'>
		                <option value="">선택</option>
		                <option value="1" <%if(code_bean.getEtc().equals("1")){%>selected<%}%>>제1금융권</option>
		                <option value="2" <%if(code_bean.getEtc().equals("2")||code_bean.getEtc().equals("3")){%>selected<%}%>>제2금융권</option>
		              </select>
		            </td>
                </tr>
                <tr> 
                    <td class='title'>대출일자</td>
                    <td  colspan=3>&nbsp; 
                      <input type="text" name="lend_dt" size="12" class="text" value="<%=FineDocBn.getEnd_dt()%>" onBlur='javscript:this.value = ChangeDate(this.value);'>
                    </td>
                </tr>
                <tr> 
                    <td class='title'>이율</td>
                    <td>&nbsp;  
                      <input type="text" name="lend_int" size="10" value='<%=f_debt.getLend_int()%>' class='num' onBlur='javscript:set_alt_amt(); '>%  		
        			</td>
                    <td class=title>이자계산방식</td>
                    <td>&nbsp; 
		              <select name='lend_int_way'>
		                <option value="">선택</option>
		                <option value="1" <%if(code_bean.getVar2().equals("1")){%>selected<%}%>>12개월나누기</option>
		                <option value="2" <%if(code_bean.getVar2().equals("2")){%>selected<%}%>>실이용일적용(365일)</option>
		                <option value="4" <%if(code_bean.getVar2().equals("4")){%>selected<%}%>>실이용일적용(실제일수)</option>
		                <option value="3" <%if(code_bean.getVar2().equals("3")){%>selected<%}%>>별도입력값</option>
		              </select>
		              <input type="text" name="lend_int_per" size="10"  class='num'>
		              &nbsp; 
		              <select name='lend_int_way2'>		                
		                <option value="1" <%if(code_bean.getVar3().equals("1")){%>selected<%}%>>소숫점 절사</option>
		                <option value="8" <%if(code_bean.getVar3().equals("8")){%>selected<%}%>>소숫점 절상</option>
		                <option value="2" <%if(code_bean.getVar3().equals("2")){%>selected<%}%>>소숫점 반올림</option>
		                <option value="7" <%if(code_bean.getVar3().equals("7")){%>selected<%}%>>원단위 절상</option><!-- 원단위절상 추가 20180918 -->
		                <option value="3" <%if(code_bean.getVar3().equals("3")){%>selected<%}%>>원단위 절사</option>
		                <option value="4" <%if(code_bean.getVar3().equals("4")){%>selected<%}%>>십원단위 절상</option>
		                <option value="5" <%if(code_bean.getVar3().equals("5")){%>selected<%}%>>십원단위 절사</option>
		                <option value="6" <%if(code_bean.getVar3().equals("6")){%>selected<%}%>>십원단위 반올림</option> 
		              </select>
		            </td>					
                </tr>
                <tr> 
		            <td class='title'>상환약정일 </td>
		            <td>&nbsp; 
		              <select name='rtn_est_dt'>
		                <%	for(int j=1; j<=31 ; j++){ //1~31일 %>
		                <option value='<%=j%>'  <%if(f_debt.getRtn_est_dt().equals(String.valueOf(j))){%>selected<%}%>><%=j%>일 </option>
		                <% } %>
		                <option value='99'  <%if(f_debt.getRtn_est_dt().equals("99")){%>selected<%}%>> 말일 </option>
		              </select>
		            </td>
                    <td class='title'>1회차결재일</td>
                    <td>&nbsp; 
                      <input type='text' size='12' name='fst_pay_dt' value='<%=f_debt.getFst_pay_dt()%>' class='text' onBlur='javscript:this.value = ChangeDate(this.value); '>
                    </td>           
                </tr>
                      <input type='hidden' name='bank_code2' value=''>
                      <input type='hidden' name='deposit_no2' value=''>
                      <input type='hidden' name='bank_name' value=''>                
                 <tr> 
                    <td class=title>거래처</td>
                    <td>&nbsp; 
                      <input type='text' name='ven_name' size='30' value='<%=ven_name%>' class='text'  style='IME-MODE: active'>
        			  &nbsp;&nbsp;<a href='javascript:ven_search()' onMouseOver="window.status=''; return true"><img src=/acar/images/center/button_search.gif align=absmiddle border=0></a> 
        			  <input type='text' name='ven_code' size='10' value='<%=f_debt.getVen_code()%>' readonly class='text'>
                    </td>
                    <td class=title>계정과목</td>
                    <td>&nbsp; 
                      <input type="radio" name="acct_code" value="26000" >
                      단기차입금 
                      <input type="radio" name="acct_code" value="29300" checked >
                      장기차입금
                      <input type="radio" name="acct_code" value="45450" >
                      리스료
                      </td>
                </tr>
                <tr> 
                    <td class=title>은행</td>
                    <td>&nbsp; 
                      <select name='bank_code' onChange='javascript:change_bank()'>
                      <option value=''>선택</option>
                      <%if(bank_size > 0){
						for(int i = 0 ; i < bank_size ; i++){
							CodeBean bank = banks[i];	%>
                      <option value='<%= bank.getCode()%>:<%= bank.getNm()%>'  <%if(f_debt.getBank_code().equals(bank.getCode()))%>selected<%%>><%= bank.getNm()%></option>
                      <%	}
					}	%>
                    </select>
                    </td>
                    <td class=title>계좌번호</td>
		            <td>&nbsp;
					  <select name='deposit_no'>
		                      <option value=''>계좌를 선택하세요</option>
		                      <%if(!f_debt.getBank_code().equals("")){
        						Vector deposits = neoe_db.getDepositList(f_debt.getBank_code());
        						int deposit_size = deposits.size();
        						for(int i = 0 ; i < deposit_size ; i++){
        							Hashtable deposit = (Hashtable)deposits.elementAt(i);%>
        				<option value='<%=deposit.get("DEPOSIT_NO")%>' <%if(f_debt.getDeposit_no().equals(String.valueOf(deposit.get("DEPOSIT_NO"))))%>selected<%%>><%= deposit.get("DEPOSIT_NO")%>:<%= deposit.get("DEPOSIT_NAME")%></option>
        				<%		}
        				}%>
		                    </select>
					</td>          	  
                </tr>
                <tr> 
                    <td class=title>중도상환<br>수수료율</td>
                    <td>&nbsp; 
                      <input type="text" name="cls_rtn_fee_int" maxlength='5' value="<%=f_debt.getCls_rtn_fee_int()%>" size="5" class=text >
                      (%)</td>
                    <td class=title >중도상환<br>특이사항</td>
                    <td>&nbsp; 
                      <textarea name="cls_rtn_etc" cols="50" rows="2"><%=f_debt.getCls_rtn_etc()%></textarea></td>                    
                </tr>			
                <tr> 
                    <td class=title>자금관리</td>
                    <td colspan='3'>&nbsp; 
                    	<input type="text" name="fund_id" size="10" class="text" value="<%=f_debt.getFund_id()%>"> 
                      <a href="javascript:search_fund_bank()">[자금관리연결]</a>
                    </td>                    
                </tr>			                			
           
            </table>
        </td>
    </tr>
    <tr>
        <td>&nbsp;</td>
    </tr>
    <tr>
        <td>[일괄변경] 
        	<br>       
		       &nbsp;&nbsp;
        	● 등록 <select name='all_reg_yn' onchange="javascript:cng_input_reg_yn('reg_yn')">
		                <option value="Y" selected>Y</option>
		                <option value="N">N</option>
		              </select>
		      &nbsp;&nbsp;&nbsp;
		      ● 할부횟수 <input type="text" name="all_alt_tm" size="3" class="text" value="<%=rtn.getCont_term() %>" onBlur="javscript:cng_input_reg_yn('alt_tm');">회
		      &nbsp;&nbsp;&nbsp;
		      ● 월상환료 절상/절사 
		              <select name='lend_alt_way' onchange="javascript:set_alt_amt()">
		                <option value="1" <%if(code_bean.getVar1().equals("1")){%>selected<%}%>>소숫점 절사</option>
		                <option value="2" <%if(code_bean.getVar1().equals("2")){%>selected<%}%>>소숫점 반올림</option> 
		                <option value="7" <%if(code_bean.getVar1().equals("7")){%>selected<%}%>>원단위 절상</option>		                		                		                		                
		                <option value="3" <%if(code_bean.getVar1().equals("3")){%>selected<%}%>>원단위 절사</option>
		                <option value="4" <%if(code_bean.getVar1().equals("4")){%>selected<%}%>>십원단위 절상</option>
		                <option value="5" <%if(code_bean.getVar1().equals("5")){%>selected<%}%>>십원단위 절사</option>
		                <option value="6" <%if(code_bean.getVar1().equals("6")){%>selected<%}%>>십원단위 반올림</option> 
		              </select>
		       &nbsp;&nbsp;&nbsp;
		      ● 회차 일자계산시 초일 산입여부 
		              <select name='int_day_account'>
		                <option value="2" <%if(code_bean.getVar6().equals("2")){%>selected<%}%>>초일 불산입</option>
		                <option value="1" <%if(code_bean.getVar6().equals("1")){%>selected<%}%>>초일 산입</option>		                		                
		              </select>		              
		       <br>       
		       &nbsp;&nbsp;
		      <input type="checkbox" name="f_day_account" value="Y" <%if(code_bean.getVar4().equals("Y")){%>checked<%}%>> 1회차 이자 일자계산 한다.  
		      <input type="checkbox" name="e_day_account" value="Y" <%if(code_bean.getVar5().equals("Y")){%>checked<%}%>> 마지막회차 이자 일자계산 한다. (마지막회차 약정일이 계약일 기준)
		       <br>       
		       &nbsp;&nbsp;
		      ● 묶음 1회차 상환원리금 <input type='text' name='f_prn_amt' value='0' size='11' maxlength='12' class='num' onBlur='javascript:this.value=parseDecimal(this.value);'>원 (월상환금액이랑 상이한 경우)
		      &nbsp;&nbsp;&nbsp;
		      <input type="checkbox" name="lend_scd_reg_yn" value="N" > 묶음 스케줄 미생성       
		      
		    </td>
    </tr> 
        <%if( auth_rw.equals("2") || auth_rw.equals("4") || auth_rw.equals("6")) {%>
    <tr>
        <td align="right">
      		<a href="javascript:Save()"><img src=/acar/images/center/button_reg.gif border=0 align=absmiddle></a>
      		&nbsp;&nbsp;&nbsp;
      		<a href="javascript:Save_view()">[스케줄계산확인]</a>
      	</td>
    </tr> 
   <% } %>     
    <tr>
    	<td class=h></td>
    </tr>
    <tr><td class=line2></td></tr>
    <tr id=tr_loan style='display:none'> 
        <td class="line"> 
            <table border="0" cellspacing="1" cellpadding="0" width='100%'>
                <tr> 
                    <td width=3% class='title'>등록</td>				
                    <td width=3% class='title'>연번</td>
                    <td width=14% class='title'>상호/성명</td>
                    <td width=10% class='title'>차종</td>
                    <td width=8% class='title'>차량번호</td>
                    <td width=8% class='title'>대출금</td>
                    <td width=6% class='title'>할부횟수</td>					
                    <td width=8% class='title'>대출이자</td>
                    <td width=9% class='title'>상환총금액</td>					
                    <td width=8% class='title'>월상환료</td>					
                    <td width=10% class='title'>대출번호</td>					         
                    <td width=9% class='title'>스케줄이자합계</td>
                    <td width=4% class='title'>스케줄</td>
                </tr>
          <%if(FineList.size()>0){
				for(int i=0; i<FineList.size(); i++){ 
					Hashtable ht = (Hashtable)FineList.elementAt(i);
					//할부정보
					ContDebtBean debt = a_db.getContDebt(String.valueOf(ht.get("RENT_MNG_ID")), String.valueOf(ht.get("RENT_L_CD")));
					
					if(debt.getCpt_cd().equals("0011")){
						sum_amt1 = sum_amt1 + AddUtil.parseLong(String.valueOf(ht.get("AMT4")));	
					}else{
						sum_amt1 = sum_amt1 + AddUtil.parseLong(String.valueOf(ht.get("AMT4"))) + AddUtil.parseLong(String.valueOf(ht.get("AMT5")));
					}
					
					sum_amt2 = sum_amt2 + debt.getLend_int_amt();
					sum_amt3 = sum_amt3 + debt.getRtn_tot_amt();
					sum_amt4 = sum_amt4 + debt.getAlt_amt();
					
					String alt_tm = debt.getTot_alt_tm();
					
					if(alt_tm.equals("") || alt_tm.equals("0")){
						alt_tm = String.valueOf(ht.get("PAID_NO"));
					}
					
					//if(String.valueOf(ht.get("SCD_REG_YN")).equals("N")){
					%>						  
                <tr> 
                    <td align="center">
					  <select name='reg_yn'>
		                <option value="Y" selected>Y</option>
		                <option value="N">N</option>
		              </select></td>
                    <td align="center"><%=i+1%></td>
                    <td align="center"><%=ht.get("FIRM_NM")%></td>
                    <td align="center"><%=ht.get("CAR_NM")%></td>
                    <td align="center"><%=ht.get("CAR_NO")%></td>					
                    <td align="right">
                    <%if(debt.getCpt_cd().equals("0011")){ %>
                    <%=AddUtil.parseDecimal(AddUtil.parseLong(String.valueOf(ht.get("AMT4"))))%>원
                    <%}else{%>
                    <%=AddUtil.parseDecimal(AddUtil.parseLong(String.valueOf(ht.get("AMT4"))) +  AddUtil.parseLong(String.valueOf(ht.get("AMT5"))))%>원
                    <%} %>
                    </td>
                    <td align="center"><input type="text" name="case_alt_tm"       size="3" class="text" value="<%=alt_tm%>" onBlur='javscript:set_alt_amt();'>회</td>					
                    <td align="center"><input type='text' name='case_lend_int_amt' value='<%=Util.parseDecimal(debt.getLend_int_amt())%>' size='11' maxlength='12' class='whitenum' onBlur='javascript:this.value=parseDecimal(this.value);'>원</td>
                    <td align="center"><input type='text' name='case_rtn_tot_amt'  value='<%=Util.parseDecimal(debt.getRtn_tot_amt())%>' size='11' maxlength='12' class='whitenum' onBlur='javascript:this.value=parseDecimal(this.value);'>원</td>
                    <td align="right">
                    (1회차)<input type='text' name='f_case_alt_amt'    value='0' size='11' maxlength='12' class='num' onBlur='javascript:this.value=parseDecimal(this.value);'>원
                    <br>
                    <input type='text' name='case_alt_amt'      value='<%=Util.parseDecimal(debt.getAlt_amt())%>' size='11' maxlength='12' class='num' onBlur='javascript:this.value=parseDecimal(this.value);set_etc_amt(<%=i%>);' onKeyDown='javascript:enter(<%=i%>)'>원
                    </td>										
                    <td align="center"><input type="text" name="case_lend_no"      size="17" class="text" value="<%=debt.getLend_no()%>">					
					<input type='hidden' name='case_m_id' value='<%=ht.get("RENT_MNG_ID")%>'>
					<input type='hidden' name='case_l_cd' value='<%=ht.get("RENT_L_CD")%>'>  
					<%if(debt.getCpt_cd().equals("0011")){ %>
					<input type='hidden' name='case_lend_prn' value='<%=AddUtil.parseLong(String.valueOf(ht.get("AMT4")))%>'>
					<%}else{%>         
					<input type='hidden' name='case_lend_prn' value='<%=AddUtil.parseLong(String.valueOf(ht.get("AMT4"))) +  AddUtil.parseLong(String.valueOf(ht.get("AMT5")))%>'>
					<%} %>
					<input type='hidden' name='t_alt_int' value='<%=ht.get("T_ALT_INT")%>'>				
					<input type='hidden' name='cardno' value='<%=ht.get("CARDNO")%>'>
					<input type='hidden' name='card_end_dt' value='<%=ht.get("CARD_END_DT")%>'>
					</td>          
					<td align="right">
					<!-- (<input type="text" name="cha_int"      size="6" class="whitenum" value="">)
					 -->
					 <input type='hidden' name='cha_int' value=''>	
					<%=AddUtil.parseDecimal(AddUtil.parseLong(String.valueOf(ht.get("T_ALT_INT"))))%>원</td>
					<td align="center"><a href="javascript:view_scd_alt('<%=ht.get("T_ALT_INT")%>','<%=ht.get("RENT_MNG_ID")%>', '<%=ht.get("RENT_L_CD")%>', '<%=ht.get("CAR_MNG_ID")%>')">보기<%//=Util.parseDecimal(debt.getLend_int_amt()-AddUtil.parseLong(String.valueOf(ht.get("T_ALT_INT"))))%></a></td>
                </tr>
          <%		//}
		  		}%>
          <%}%>		  
	<tr>
	  <td colspan="5" class="title">합계</td>	  
	  <td align="right"><input type='text' name='tot_lend_prn'  value='<%=Util.parseDecimal(sum_amt1)%>' size='11' maxlength='12' class='whitenum' readonly >원</td>
	  <td class="title">&nbsp;</td>
	  <td align="right"><input type='text' name='tot_lend_int_amt'  value='<%=Util.parseDecimal(sum_amt2)%>' size='11' maxlength='12' class='whitenum' readonly >원</td>
	  <td align="right"><input type='text' name='tot_rtn_tot_amt'  value='<%=Util.parseDecimal(sum_amt3)%>' size='11' maxlength='12' class='whitenum' readonly >원</td>
	  <td align="right"><input type='text' name='tot_alt_amt'  value='<%=Util.parseDecimal(sum_amt4)%>' size='11' maxlength='12' class='whitenum' readonly >원</td>
	  <td colspan="3" class="title">&nbsp;</td>
	</tr>	          		  		  
            </table>
        </td>
    </tr>	

</table>  
<input type='hidden' name='user_id' value='<%=user_id%>'>           
</form>
<iframe src="about:blank" name="i_no" width="0" height="0" frameborder="0" noresize></iframe>  
<script language='javascript'>
<!--

-->
</script>
</body>
</html>