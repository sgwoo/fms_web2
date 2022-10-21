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
	
	//�α��� ���������	
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
		
	//�׿���-��������
	CodeBean[] banks = neoe_db.getCodeAll();
	int bank_size = banks.length;
	
	FineDocBn = FineDocDb.getFineDoc(doc_id);
	
	//�����û����Ʈ-���⳻����
	Vector FineList = FineDocDb.getBankDocAllLists2(doc_id);
	
	//�Һ�����
	ContDebtBean f_debt = new ContDebtBean();
	//������� ����
	BankLendBean bl = new BankLendBean();
	BankRtnBean rtn = new BankRtnBean();
	if(FineList.size()>0){
		for(int i=0; i<1; i++){ 
			Hashtable ht = (Hashtable)FineList.elementAt(i);		
			//�Һ�����
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
	//���
	function Save()
	{
		var fm = document.form1;	
		
		if(fm.doc_id.value == '')		{	alert('������ȣ�� �Է��Ͻʽÿ�.'); 		fm.doc_id.focus(); 		return; }
		if(fm.loan_st.value == '')		{	alert('�������¸� �Է��Ͻʽÿ�.'); 		fm.loan_st.focus(); 		return; }
		
		
		if(fm.lend_dt.value == '')		{	alert('�������� �Է��Ͻʽÿ�.'); 		fm.lend_dt.focus(); 		return; }
		if(fm.cpt_cd_st.value == '')		{	alert('���������¸� �Է��Ͻʽÿ�.'); 		fm.cpt_cd_st.focus(); 		return; }
		if(fm.lend_int_way.value == '')		{	alert('���ڰ������ �����Ͻʽÿ�.'); 		fm.lend_int_way.focus(); 	return; }
		
		
		if(fm.loan_st.value == '2' && fm.lend_id.value ==  '')	{	alert('���������� ��� ����ȣ�� �ݵ�� �Է��ϼ���.'); 	fm.loan_st.focus(); 		return; }		
		if(fm.fst_pay_dt.value == ''){	alert('1ȸ���������� �Է��Ͻʽÿ�.'); 				fm.fst_pay_dt.focus(); 		return; }
						
		if(fm.acct_code[0].checked == false && fm.acct_code[1].checked == false )	{ alert('���������� �����Ͻʽÿ�.'); return;}
		
		if(fm.ven_code.value == '')	{ 	alert('�ŷ�ó�� Ȯ���Ͻʽÿ�.'); 		return;}
		if(fm.bank_code.value == '')	{ 	alert('������ Ȯ���Ͻʽÿ�.'); 			return;}
		if(fm.deposit_no.value == '')	{ 	alert('���¹�ȣ�� Ȯ���Ͻʽÿ�.'); 		return;}
		
		if(fm.loan_st.value == '2' && fm.all_alt_tm.value ==  '')	{	alert('���������� ��� �Һ�Ƚ���� �Է��ϼ���.'); 	fm.all_alt_tm.focus(); 		return; }
		
		if(fm.loan_st.value == '2' && toInt(fm.tot_alt_amt.value) ==  0)	{	set_alt_amt();  }
		
		//��������	
		if(fm.loan_st.value == '1' && fm.rtn_est_dt.value != '99'){
			var est_dt = replaceString('-','',fm.fst_pay_dt.value);
			var est_d = est_dt.substring(6,8);
			if(toInt(fm.rtn_est_dt.value) > toInt(est_d) || toInt(fm.rtn_est_dt.value) < toInt(est_d)){
				if(!confirm('1ȸ�������ϰ� ���Ѿ������� �ٸ��ϴ�. ����Ͻðڽ��ϱ�?')){			
					return;
				}
			}
		}
		
		fm.mode.value = '';
		
		if(confirm('����Ͻðڽ��ϱ�?')){					
			fm.action='debt_scd_reg_i_a.jsp';		
			//fm.target='i_no';
			fm.target='_blank';			
			fm.submit();
		}
	}
	
//��� Ȯ�� - ���⸸
function Save_view()
{
	var fm = document.form1;	
	
	if(fm.doc_id.value == '')		{	alert('������ȣ�� �Է��Ͻʽÿ�.'); 		fm.doc_id.focus(); 		return; }
	if(fm.loan_st.value == '')		{	alert('�������¸� �Է��Ͻʽÿ�.'); 		fm.loan_st.focus(); 		return; }
	
	
	if(fm.lend_dt.value == '')		{	alert('�������� �Է��Ͻʽÿ�.'); 		fm.lend_dt.focus(); 		return; }
	if(fm.cpt_cd_st.value == '')		{	alert('���������¸� �Է��Ͻʽÿ�.'); 		fm.cpt_cd_st.focus(); 		return; }
	if(fm.lend_int_way.value == '')		{	alert('���ڰ������ �����Ͻʽÿ�.'); 		fm.lend_int_way.focus(); 	return; }
	
	
	if(fm.loan_st.value == '2' && fm.lend_id.value ==  '')	{	alert('���������� ��� ����ȣ�� �ݵ�� �Է��ϼ���.'); 	fm.loan_st.focus(); 		return; }
	if(fm.fst_pay_dt.value == ''){	alert('1ȸ���������� �Է��Ͻʽÿ�.'); 				fm.fst_pay_dt.focus(); 		return; }	
					
	if(fm.acct_code[0].checked == false && fm.acct_code[1].checked == false )	{ alert('���������� �����Ͻʽÿ�.'); return;}
	
	if(fm.ven_code.value == '')	{ 	alert('�ŷ�ó�� Ȯ���Ͻʽÿ�.'); 		return;}
	if(fm.bank_code.value == '')	{ 	alert('������ Ȯ���Ͻʽÿ�.'); 			return;}
	if(fm.deposit_no.value == '')	{ 	alert('���¹�ȣ�� Ȯ���Ͻʽÿ�.'); 		return;}
	
	if(fm.loan_st.value == '2' && fm.all_alt_tm.value ==  '')	{	alert('���������� ��� �Һ�Ƚ���� �Է��ϼ���.'); 	fm.all_alt_tm.focus(); 		return; }
	
	if(fm.loan_st.value == '2' && toInt(fm.tot_alt_amt.value) ==  0)	{	set_alt_amt();  }
	
		
	//��������	
	if(fm.loan_st.value == '1' && fm.rtn_est_dt.value != '99'){
		var est_dt = replaceString('-','',fm.fst_pay_dt.value);
		var est_d = est_dt.substring(6,8);
		if(toInt(fm.rtn_est_dt.value) > toInt(est_d) || toInt(fm.rtn_est_dt.value) < toInt(est_d)){
			if(!confirm('1ȸ�������ϰ� ���Ѿ������� �ٸ��ϴ�. ����Ͻðڽ��ϱ�?')){			
				return;
			}
		}
	}
	
	fm.mode.value = 'view';
				
	if(confirm('�����ٰ����  Ȯ�� �Ͻðڽ��ϱ�? ������ Ȯ�θ� �մϴ�.')){					
		fm.action='debt_scd_reg_i_a.jsp';		
		//fm.target='i_no';
		fm.target='_blank';			
		fm.submit();
	}
}	
	
	//���������ȸ
	function find_doc_search(){
		var fm = document.form1;	
		window.open("find_doc_search.jsp", "SEARCH_FINE_GOV", "left=100, top=100, width=500, height=550, resizable=yes, scrollbars=yes, status=yes");
	}

	//��ȸ�ϱ�
	function ven_search(){
		var fm = document.form1;
		var t_wd;
		if(fm.ven_name.value != ''){	fm.t_wd.value = fm.ven_name.value;		}
		else{ 							alert('��ȸ�� �ŷ�ó���� �Է��Ͻʽÿ�.'); 	fm.ven_name.focus(); 	return;}		
		
		window.open("/acar/con_debt/vendor_list.jsp?t_wd="+fm.t_wd.value, "VENDOR_LIST", "left=300, top=300, width=430, height=400, resizable=yes, scrollbars=yes, status=yes");		
	}
	
	//���༱�ý� ���¹�ȣ ��������
	function change_bank(){
		var fm = document.form1;
		var bank_code = fm.bank_code.options[fm.bank_code.selectedIndex].value;
		fm.bank_code2.value = bank_code.substring(0,3);
		fm.bank_name.value = bank_code.substring(3);
		
		drop_deposit();		

		if(bank_code == ''){
			fm.bank_code.options[0] = new Option('����', '');
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
		
	//�ҺαⰣ,����ȯ�� ����
	function set_alt_term(obj){
		var fm = document.form1;	
		if(obj == fm.alt_start_dt){//�ҺαⰣ ������ ����
			fm.action='debt_dt_nodisplay.jsp?alt_start_dt='+fm.alt_start_dt.value+'&tot_alt_tm='+fm.tot_alt_tm.value;
			fm.target='i_no';
			fm.submit();		
		}
		else if(obj == fm.rtn_tot_amt || obj == fm.tot_alt_tm){
			fm.alt_amt.value = parseDecimal(toInt(parseDigit(fm.rtn_tot_amt.value)) / toInt(parseDigit(fm.tot_alt_tm.value)));	
		}
	}			
	
	//����ȯ�� �ڵ����
	function set_alt_amt(){
		var fm = document.form1;
		
		
		var tot_lend_int_amt = 0;
		var tot_rtn_tot_amt = 0;
		var tot_alt_amt = 0;
		
		
		
		for(var i = 0 ; i < <%=FineList.size()%> ; i++){
		
			//�Һο���
			var o70 	= toInt(parseDigit(fm.case_lend_prn[i].value));
			//����������
			var ao70 	= toFloat(fm.lend_int.value)/100;
			//��ȯȽ��
			var a_b 	= toInt(fm.case_alt_tm[i].value);
			//10��������Һα�
			//var ao71 	= Math.round( (ao70/12) * (-100000) * Math.pow(1+ao70/12,a_b) / (1-Math.pow(1+ao70/12,a_b)) );
			//���Һα�
			//var o71 	= o70/100000*ao71;
			var o71 = 0;
			
			//20210203 ���Һα� ���� ���� 
			var d7 = o70;
			var d9 = ao70;			
			var d11 = a_b;
								
			var v = 1+(d9/12);
			var t = -(d11/12)*12;
				
			//���Һα�
			var result=(d7*d9/12)/(1-Math.pow(v,t));
				
			//�Ҽ�������
			if(fm.lend_alt_way.value == '1'){
				o71 = Math.floor(result);	
			}
			//�Ҽ����ݿø�
			if(fm.lend_alt_way.value == '2'){
				o71 = Math.round(result);	
			}
			//����������
			if(fm.lend_alt_way.value == '7'){
				o71 = Math.ceil(result/10)*10;	
			}
			//����������
			if(fm.lend_alt_way.value == '3'){
				o71 = Math.floor(result/10)*10;	
			}
			//�ʿ���������
			if(fm.lend_alt_way.value == '4'){
				o71 = Math.ceil(result/100)*100;	
			}
			//�ʿ���������
			if(fm.lend_alt_way.value == '5'){
				o71 = Math.floor(result/100)*100;	
			}
			//�ʿ������ݿø�
			if(fm.lend_alt_way.value == '6'){
				o71 = Math.round(result/100)*100;	
			}
			
								
			//����ȯ��
			fm.case_alt_amt[i].value 		= parseDecimal(o71);
			fm.case_rtn_tot_amt[i].value 	= parseDecimal(o71*a_b);
			//�������� 
			fm.case_lend_int_amt[i].value 	= parseDecimal(o71*a_b-o70); 
			
			//fm.cha_int[i].value 	= parseDecimal(toInt(parseDigit(fm.t_alt_int[i].value))-toInt(parseDigit(fm.case_lend_int_amt[i].value)));

			
			tot_lend_int_amt = tot_lend_int_amt + toInt(parseDigit(fm.case_lend_int_amt[i].value));
			tot_rtn_tot_amt  = tot_rtn_tot_amt  + toInt(parseDigit(fm.case_rtn_tot_amt[i].value));
			tot_alt_amt      = tot_alt_amt      + toInt(parseDigit(fm.case_alt_amt[i].value));
			
		}		
		
		if(fm.loan_st.value == '1'){//�Ǻ�����		
			fm.tot_rtn_tot_amt.value  = parseDecimal(tot_rtn_tot_amt);
			fm.tot_lend_int_amt.value = parseDecimal(tot_lend_int_amt);
			fm.tot_alt_amt.value      = parseDecimal(tot_alt_amt);
		}else if(fm.loan_st.value == '2'){//��������
			//�Һο���
			var o70 	= toInt(parseDigit(fm.tot_lend_prn.value));
			//����������
			var ao70 	= toFloat(fm.lend_int.value)/100;
			if(toFloat(fm.lend_int.value) > 0){
				if(toInt(fm.all_alt_tm.value) == 0){
					alert('�ϰ����濡 �ִ�  �Һ�Ƚ���� �Է��Ͻʽÿ�.'); return;
				}
			}
			//��ȯȽ��
			var a_b 	= toInt(fm.all_alt_tm.value);
			//���Һα�
			var o71 = 0;
			
			//20210203 ���Һα� ���� ���� 
			var d7 = o70;
			var d9 = ao70;			
			var d11 = a_b;
								
			var v = 1+(d9/12);
			var t = -(d11/12)*12;
				
			//���Һα�
			var result=(d7*d9/12)/(1-Math.pow(v,t));
				
			//�Ҽ�������
			if(fm.lend_alt_way.value == '1'){
				o71 = Math.floor(result);	
			}
			//�Ҽ����ݿø�
			if(fm.lend_alt_way.value == '2'){
				o71 = Math.round(result);	
			}
			//����������
			if(fm.lend_alt_way.value == '7'){
				o71 = Math.ceil(result/10)*10;	
			}
			//����������
			if(fm.lend_alt_way.value == '3'){
				o71 = Math.floor(result/10)*10;	
			}
			//�ʿ���������
			if(fm.lend_alt_way.value == '4'){
				o71 = Math.ceil(result/100)*100;	
			}
			//�ʿ���������
			if(fm.lend_alt_way.value == '5'){
				o71 = Math.floor(result/100)*100;	
			}
			//�ʿ������ݿø�
			if(fm.lend_alt_way.value == '6'){
				o71 = Math.round(result/100)*100;	
			}
			
			//����ȯ��
			fm.tot_alt_amt.value 		= parseDecimal(o71);
			//�ѻ�ȯ�ݾ�
			fm.tot_rtn_tot_amt.value 	= parseDecimal(o71*a_b); 
			//�������� 
			fm.tot_lend_int_amt.value 	= parseDecimal(o71*a_b-o70); 
			
			if(toFloat(fm.lend_int.value) > 0 && toInt(fm.all_alt_tm.value) > 0){			
				alert('�������� ����ȯ��� '+fm.tot_alt_amt.value+'�Դϴ�.');
			}
		}
		
	}
	
	function set_etc_amt(idx){
		var fm = document.form1;	
			
		//�Һο���
		var o70 	= toInt(parseDigit(fm.case_lend_prn[idx].value));			
		//��ȯȽ��
		var a_b 	= toInt(fm.case_alt_tm[idx].value);
		//����ȯ��
		var o71 	= toInt(parseDigit(fm.case_alt_amt[idx].value));			
			
		//�ѻ�ȯ�ݾ�
		fm.case_rtn_tot_amt[idx].value 		= parseDecimal(o71*a_b); 
		//�������� 
		fm.case_lend_int_amt[idx].value 	= parseDecimal(o71*a_b-o70); 		
		
	}
	
	function cng_input(){
		var fm = document.form1;	
		
		if(fm.loan_st.value == '1'){//�Ǻ�����
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
	
	//���ڿ���Ű
	function enter(idx){
		var fm = document.form1;
		var keyValue = event.keyCode;
		if (keyValue =='13' && idx+1 != <%=FineList.size()%>){
			fm.case_alt_amt[idx+1].focus();
		}
	}
		
	//�ü��ڱ� ��ȸ
	function search_fund_bank(){
		var fm = document.form1;
		window.open("/fms2/bank_mng/s_fund_bank.jsp?from_page=/fms2/bank_mng/debt_scd_reg_i.jsp&lend_id="+fm.lend_id.value+"&cont_bn="+fm.cpt_cd.value, "SEARCH_LEND_BANK", "left=50, top=50, width=750, height=600, scrollbars=yes");		
	}	
	
	function view_scd_alt(alt_int, m_id, l_cd, c_id){
		if(alt_int == '0'){		//�Ϲ��Һαݽ����� ���
			alert('������ ����� Ȯ���� �� �ֽ��ϴ�.');
		}else{					//�Ϲ��Һαݽ����� ����
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
						<span class=style1>�繫ȸ�� > �����ڱݰ��� > <span class=style5>�Һε��ó��</span></span></td>
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
                    <td class='title' width=12%>������ȣ</td>
                    <td width=38%>&nbsp;  
                      <input type="text" name="doc_id" size="15" value="<%=FineDocBn.getDoc_id()%>" class="text" readonly style='IME-MODE: active'>
                  
                      <a href="javascript:find_doc_search();"><img src=/acar/images/center/button_in_search1.gif align=absmiddle border=0></a>
                    </td>
                    <td class=title width=12%>��������</td>
                    <td width="38%">&nbsp; 
		              <select name='loan_st' onchange="javascript:cng_input()">
		                <option value="">����</option>
		                <option value="1">�Ǻ�����</option>
		                <option value="2">��������</option>
		              </select>
		            </td>
                </tr>
                
                <tr> 
                    <td class='title'>����ȣ</td>
                    <td colspan=3>&nbsp;  
                      <input type="text" name="lend_id" size="10" class="text" value='<%=f_debt.getLend_id()%>'>    
					  &nbsp;  &nbsp;  
					  * �������� ��ȯ���� : ����/����
                      <select name='rtn_seq'>
		                <option value="">����</option>
		                <option value="1" <%if(!f_debt.getRent_l_cd().equals("") && f_debt.getRtn_seq().equals("1")){%>selected<%}%>>1��</option>
		                <option value="2" <%if(!f_debt.getRent_l_cd().equals("") && f_debt.getRtn_seq().equals("2")){%>selected<%}%>>2��</option>
		                <option value="3" <%if(!f_debt.getRent_l_cd().equals("") && f_debt.getRtn_seq().equals("3")){%>selected<%}%>>3��</option>						
		                <option value="4" <%if(!f_debt.getRent_l_cd().equals("") && f_debt.getRtn_seq().equals("4")){%>selected<%}%>>4��</option>												
		              </select>					                 
                    &nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;
					<font color=blue>* ���������� ���� �ݵ�� ������������ ����ȣ�� �Է��ϼ���. </font>                                  
                     </td>
                </tr>
                
                <tr> 
                    <td class='title'>��������</td>
                    <td >&nbsp; 
                      <input type="text" name="cpt_cd" size="6" class="text" value="<%=FineDocBn.getGov_id()%>" readonly  >
                        <input type="text" name="bank_nm" size="30" class="text" value="<%=c_db.getNameById(FineDocBn.getGov_id(), "BANK")%>">
                    </td>
                    <td class=title>�����籸��</td>
                    <td>&nbsp; 
		              <select name='cpt_cd_st'>
		                <option value="">����</option>
		                <option value="1" <%if(code_bean.getEtc().equals("1")){%>selected<%}%>>��1������</option>
		                <option value="2" <%if(code_bean.getEtc().equals("2")||code_bean.getEtc().equals("3")){%>selected<%}%>>��2������</option>
		              </select>
		            </td>
                </tr>
                <tr> 
                    <td class='title'>��������</td>
                    <td  colspan=3>&nbsp; 
                      <input type="text" name="lend_dt" size="12" class="text" value="<%=FineDocBn.getEnd_dt()%>" onBlur='javscript:this.value = ChangeDate(this.value);'>
                    </td>
                </tr>
                <tr> 
                    <td class='title'>����</td>
                    <td>&nbsp;  
                      <input type="text" name="lend_int" size="10" value='<%=f_debt.getLend_int()%>' class='num' onBlur='javscript:set_alt_amt(); '>%  		
        			</td>
                    <td class=title>���ڰ����</td>
                    <td>&nbsp; 
		              <select name='lend_int_way'>
		                <option value="">����</option>
		                <option value="1" <%if(code_bean.getVar2().equals("1")){%>selected<%}%>>12����������</option>
		                <option value="2" <%if(code_bean.getVar2().equals("2")){%>selected<%}%>>���̿�������(365��)</option>
		                <option value="4" <%if(code_bean.getVar2().equals("4")){%>selected<%}%>>���̿�������(�����ϼ�)</option>
		                <option value="3" <%if(code_bean.getVar2().equals("3")){%>selected<%}%>>�����Է°�</option>
		              </select>
		              <input type="text" name="lend_int_per" size="10"  class='num'>
		              &nbsp; 
		              <select name='lend_int_way2'>		                
		                <option value="1" <%if(code_bean.getVar3().equals("1")){%>selected<%}%>>�Ҽ��� ����</option>
		                <option value="8" <%if(code_bean.getVar3().equals("8")){%>selected<%}%>>�Ҽ��� ����</option>
		                <option value="2" <%if(code_bean.getVar3().equals("2")){%>selected<%}%>>�Ҽ��� �ݿø�</option>
		                <option value="7" <%if(code_bean.getVar3().equals("7")){%>selected<%}%>>������ ����</option><!-- ���������� �߰� 20180918 -->
		                <option value="3" <%if(code_bean.getVar3().equals("3")){%>selected<%}%>>������ ����</option>
		                <option value="4" <%if(code_bean.getVar3().equals("4")){%>selected<%}%>>�ʿ����� ����</option>
		                <option value="5" <%if(code_bean.getVar3().equals("5")){%>selected<%}%>>�ʿ����� ����</option>
		                <option value="6" <%if(code_bean.getVar3().equals("6")){%>selected<%}%>>�ʿ����� �ݿø�</option> 
		              </select>
		            </td>					
                </tr>
                <tr> 
		            <td class='title'>��ȯ������ </td>
		            <td>&nbsp; 
		              <select name='rtn_est_dt'>
		                <%	for(int j=1; j<=31 ; j++){ //1~31�� %>
		                <option value='<%=j%>'  <%if(f_debt.getRtn_est_dt().equals(String.valueOf(j))){%>selected<%}%>><%=j%>�� </option>
		                <% } %>
		                <option value='99'  <%if(f_debt.getRtn_est_dt().equals("99")){%>selected<%}%>> ���� </option>
		              </select>
		            </td>
                    <td class='title'>1ȸ��������</td>
                    <td>&nbsp; 
                      <input type='text' size='12' name='fst_pay_dt' value='<%=f_debt.getFst_pay_dt()%>' class='text' onBlur='javscript:this.value = ChangeDate(this.value); '>
                    </td>           
                </tr>
                      <input type='hidden' name='bank_code2' value=''>
                      <input type='hidden' name='deposit_no2' value=''>
                      <input type='hidden' name='bank_name' value=''>                
                 <tr> 
                    <td class=title>�ŷ�ó</td>
                    <td>&nbsp; 
                      <input type='text' name='ven_name' size='30' value='<%=ven_name%>' class='text'  style='IME-MODE: active'>
        			  &nbsp;&nbsp;<a href='javascript:ven_search()' onMouseOver="window.status=''; return true"><img src=/acar/images/center/button_search.gif align=absmiddle border=0></a> 
        			  <input type='text' name='ven_code' size='10' value='<%=f_debt.getVen_code()%>' readonly class='text'>
                    </td>
                    <td class=title>��������</td>
                    <td>&nbsp; 
                      <input type="radio" name="acct_code" value="26000" >
                      �ܱ����Ա� 
                      <input type="radio" name="acct_code" value="29300" checked >
                      ������Ա�
                      <input type="radio" name="acct_code" value="45450" >
                      ������
                      </td>
                </tr>
                <tr> 
                    <td class=title>����</td>
                    <td>&nbsp; 
                      <select name='bank_code' onChange='javascript:change_bank()'>
                      <option value=''>����</option>
                      <%if(bank_size > 0){
						for(int i = 0 ; i < bank_size ; i++){
							CodeBean bank = banks[i];	%>
                      <option value='<%= bank.getCode()%>:<%= bank.getNm()%>'  <%if(f_debt.getBank_code().equals(bank.getCode()))%>selected<%%>><%= bank.getNm()%></option>
                      <%	}
					}	%>
                    </select>
                    </td>
                    <td class=title>���¹�ȣ</td>
		            <td>&nbsp;
					  <select name='deposit_no'>
		                      <option value=''>���¸� �����ϼ���</option>
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
                    <td class=title>�ߵ���ȯ<br>��������</td>
                    <td>&nbsp; 
                      <input type="text" name="cls_rtn_fee_int" maxlength='5' value="<%=f_debt.getCls_rtn_fee_int()%>" size="5" class=text >
                      (%)</td>
                    <td class=title >�ߵ���ȯ<br>Ư�̻���</td>
                    <td>&nbsp; 
                      <textarea name="cls_rtn_etc" cols="50" rows="2"><%=f_debt.getCls_rtn_etc()%></textarea></td>                    
                </tr>			
                <tr> 
                    <td class=title>�ڱݰ���</td>
                    <td colspan='3'>&nbsp; 
                    	<input type="text" name="fund_id" size="10" class="text" value="<%=f_debt.getFund_id()%>"> 
                      <a href="javascript:search_fund_bank()">[�ڱݰ�������]</a>
                    </td>                    
                </tr>			                			
           
            </table>
        </td>
    </tr>
    <tr>
        <td>&nbsp;</td>
    </tr>
    <tr>
        <td>[�ϰ�����] 
        	<br>       
		       &nbsp;&nbsp;
        	�� ��� <select name='all_reg_yn' onchange="javascript:cng_input_reg_yn('reg_yn')">
		                <option value="Y" selected>Y</option>
		                <option value="N">N</option>
		              </select>
		      &nbsp;&nbsp;&nbsp;
		      �� �Һ�Ƚ�� <input type="text" name="all_alt_tm" size="3" class="text" value="<%=rtn.getCont_term() %>" onBlur="javscript:cng_input_reg_yn('alt_tm');">ȸ
		      &nbsp;&nbsp;&nbsp;
		      �� ����ȯ�� ����/���� 
		              <select name='lend_alt_way' onchange="javascript:set_alt_amt()">
		                <option value="1" <%if(code_bean.getVar1().equals("1")){%>selected<%}%>>�Ҽ��� ����</option>
		                <option value="2" <%if(code_bean.getVar1().equals("2")){%>selected<%}%>>�Ҽ��� �ݿø�</option> 
		                <option value="7" <%if(code_bean.getVar1().equals("7")){%>selected<%}%>>������ ����</option>		                		                		                		                
		                <option value="3" <%if(code_bean.getVar1().equals("3")){%>selected<%}%>>������ ����</option>
		                <option value="4" <%if(code_bean.getVar1().equals("4")){%>selected<%}%>>�ʿ����� ����</option>
		                <option value="5" <%if(code_bean.getVar1().equals("5")){%>selected<%}%>>�ʿ����� ����</option>
		                <option value="6" <%if(code_bean.getVar1().equals("6")){%>selected<%}%>>�ʿ����� �ݿø�</option> 
		              </select>
		       &nbsp;&nbsp;&nbsp;
		      �� ȸ�� ���ڰ��� ���� ���Կ��� 
		              <select name='int_day_account'>
		                <option value="2" <%if(code_bean.getVar6().equals("2")){%>selected<%}%>>���� �һ���</option>
		                <option value="1" <%if(code_bean.getVar6().equals("1")){%>selected<%}%>>���� ����</option>		                		                
		              </select>		              
		       <br>       
		       &nbsp;&nbsp;
		      <input type="checkbox" name="f_day_account" value="Y" <%if(code_bean.getVar4().equals("Y")){%>checked<%}%>> 1ȸ�� ���� ���ڰ�� �Ѵ�.  
		      <input type="checkbox" name="e_day_account" value="Y" <%if(code_bean.getVar5().equals("Y")){%>checked<%}%>> ������ȸ�� ���� ���ڰ�� �Ѵ�. (������ȸ�� �������� ����� ����)
		       <br>       
		       &nbsp;&nbsp;
		      �� ���� 1ȸ�� ��ȯ������ <input type='text' name='f_prn_amt' value='0' size='11' maxlength='12' class='num' onBlur='javascript:this.value=parseDecimal(this.value);'>�� (����ȯ�ݾ��̶� ������ ���)
		      &nbsp;&nbsp;&nbsp;
		      <input type="checkbox" name="lend_scd_reg_yn" value="N" > ���� ������ �̻���       
		      
		    </td>
    </tr> 
        <%if( auth_rw.equals("2") || auth_rw.equals("4") || auth_rw.equals("6")) {%>
    <tr>
        <td align="right">
      		<a href="javascript:Save()"><img src=/acar/images/center/button_reg.gif border=0 align=absmiddle></a>
      		&nbsp;&nbsp;&nbsp;
      		<a href="javascript:Save_view()">[�����ٰ��Ȯ��]</a>
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
                    <td width=3% class='title'>���</td>				
                    <td width=3% class='title'>����</td>
                    <td width=14% class='title'>��ȣ/����</td>
                    <td width=10% class='title'>����</td>
                    <td width=8% class='title'>������ȣ</td>
                    <td width=8% class='title'>�����</td>
                    <td width=6% class='title'>�Һ�Ƚ��</td>					
                    <td width=8% class='title'>��������</td>
                    <td width=9% class='title'>��ȯ�ѱݾ�</td>					
                    <td width=8% class='title'>����ȯ��</td>					
                    <td width=10% class='title'>�����ȣ</td>					         
                    <td width=9% class='title'>�����������հ�</td>
                    <td width=4% class='title'>������</td>
                </tr>
          <%if(FineList.size()>0){
				for(int i=0; i<FineList.size(); i++){ 
					Hashtable ht = (Hashtable)FineList.elementAt(i);
					//�Һ�����
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
                    <%=AddUtil.parseDecimal(AddUtil.parseLong(String.valueOf(ht.get("AMT4"))))%>��
                    <%}else{%>
                    <%=AddUtil.parseDecimal(AddUtil.parseLong(String.valueOf(ht.get("AMT4"))) +  AddUtil.parseLong(String.valueOf(ht.get("AMT5"))))%>��
                    <%} %>
                    </td>
                    <td align="center"><input type="text" name="case_alt_tm"       size="3" class="text" value="<%=alt_tm%>" onBlur='javscript:set_alt_amt();'>ȸ</td>					
                    <td align="center"><input type='text' name='case_lend_int_amt' value='<%=Util.parseDecimal(debt.getLend_int_amt())%>' size='11' maxlength='12' class='whitenum' onBlur='javascript:this.value=parseDecimal(this.value);'>��</td>
                    <td align="center"><input type='text' name='case_rtn_tot_amt'  value='<%=Util.parseDecimal(debt.getRtn_tot_amt())%>' size='11' maxlength='12' class='whitenum' onBlur='javascript:this.value=parseDecimal(this.value);'>��</td>
                    <td align="right">
                    (1ȸ��)<input type='text' name='f_case_alt_amt'    value='0' size='11' maxlength='12' class='num' onBlur='javascript:this.value=parseDecimal(this.value);'>��
                    <br>
                    <input type='text' name='case_alt_amt'      value='<%=Util.parseDecimal(debt.getAlt_amt())%>' size='11' maxlength='12' class='num' onBlur='javascript:this.value=parseDecimal(this.value);set_etc_amt(<%=i%>);' onKeyDown='javascript:enter(<%=i%>)'>��
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
					<%=AddUtil.parseDecimal(AddUtil.parseLong(String.valueOf(ht.get("T_ALT_INT"))))%>��</td>
					<td align="center"><a href="javascript:view_scd_alt('<%=ht.get("T_ALT_INT")%>','<%=ht.get("RENT_MNG_ID")%>', '<%=ht.get("RENT_L_CD")%>', '<%=ht.get("CAR_MNG_ID")%>')">����<%//=Util.parseDecimal(debt.getLend_int_amt()-AddUtil.parseLong(String.valueOf(ht.get("T_ALT_INT"))))%></a></td>
                </tr>
          <%		//}
		  		}%>
          <%}%>		  
	<tr>
	  <td colspan="5" class="title">�հ�</td>	  
	  <td align="right"><input type='text' name='tot_lend_prn'  value='<%=Util.parseDecimal(sum_amt1)%>' size='11' maxlength='12' class='whitenum' readonly >��</td>
	  <td class="title">&nbsp;</td>
	  <td align="right"><input type='text' name='tot_lend_int_amt'  value='<%=Util.parseDecimal(sum_amt2)%>' size='11' maxlength='12' class='whitenum' readonly >��</td>
	  <td align="right"><input type='text' name='tot_rtn_tot_amt'  value='<%=Util.parseDecimal(sum_amt3)%>' size='11' maxlength='12' class='whitenum' readonly >��</td>
	  <td align="right"><input type='text' name='tot_alt_amt'  value='<%=Util.parseDecimal(sum_amt4)%>' size='11' maxlength='12' class='whitenum' readonly >��</td>
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