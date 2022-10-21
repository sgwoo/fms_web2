<%@ page language="java" contentType="text/html;charset=euc-kr" %>
<%@ page import="java.util.*, acar.bank_mng.*, acar.common.*, acar.util.*, acar.bill_mng.*, acar.pay_mng.*"%>
<jsp:useBean id="abl_db" scope="page" class="acar.bank_mng.AddBankLendDatabase"/>
<jsp:useBean id="as_db" scope="page" class="acar.cls.AddClsDatabase"/>
<jsp:useBean id="rs_db" scope="page" class="acar.res_search.ResSearchDatabase"/>
<%@ include file="/acar/cookies.jsp" %>

<%
	String auth_rw = request.getParameter("auth_rw")==null?"":request.getParameter("auth_rw"); //����
	String user_id = request.getParameter("user_id")==null?ck_acar_id:request.getParameter("user_id");//�α���-ID
	String br_id = request.getParameter("br_id")==null?"":request.getParameter("br_id");//�α���-������
	
	if(auth_rw.equals(""))	auth_rw = rs_db.getAuthRw(user_id, "05", "05", "01");	
		
	//height
	int sh_height = request.getParameter("sh_height")==null?0:Util.parseInt(request.getParameter("sh_height"));//��ܱ���
	
	String bank_id = request.getParameter("bank_id")==null?"":request.getParameter("bank_id");
	String gubun1 = request.getParameter("gubun1")==null?"":request.getParameter("gubun1");
	
	String lend_id = request.getParameter("lend_id")==null?"":request.getParameter("lend_id");
		
	CommonDataBase c_db = CommonDataBase.getInstance();
	PaySearchDatabase 	ps_db 	= PaySearchDatabase.getInstance();
	
	
	/* �ڵ� ����:��1������ */
	CodeBean[] banks = c_db.getBankList("1");
	int bank_size = banks.length;
	/* �ڵ� ����:��1������ */
	CodeBean[] banks2 = c_db.getBankList("2");
	int bank_size2 = banks2.length;
	
	/* ������ ��ȸ */
	Vector branches = c_db.getBranchList();
	int brch_size = branches.size();
	
	//��� ����� ����Ʈ
	Vector users = c_db.getUserList("", "", "EMP");
	int user_size = users.size();
	
	//�α��� ���������
	LoginBean login = LoginBean.getInstance();
	if(user_id.equals("")) user_id = login.getCookieValue(request, "acar_id");
	
	//������� ����
	BankLendBean bl = abl_db.getBankLend(lend_id);

	//�����ߵ���ȯ		
	Vector cls_vt =  as_db.getClsBankList(lend_id);
	int cls_vt_size = cls_vt.size();
		
	NeoErpUDatabase neoe_db = NeoErpUDatabase.getInstance();
		
	//�׿��� ���ฮ��Ʈ
	CodeBean[] a_banks = neoe_db.getCodeAll();
	int a_bank_size = a_banks.length;
	
	
	//20150526 ACAR_ATTACH_FILE LIST---------------------------------------------------------
	
	String content_code = "LEND_BANK";
	String content_seq  = lend_id;
	
	Vector attach_vt = c_db.getAcarAttachFileListEqual(content_code, content_seq, 0);
	int attach_vt_size = attach_vt.size();
	
	//�����縮��Ʈ
	Vector p_bank_vt =  ps_db.getCodeList("0003");
	int p_bank_size = p_bank_vt.size();
		
%>

<html>
<head>
<title>FMS</title>
<link rel="stylesheet" type="text/css" href="/include/table_t.css">
<meta http-equiv="Content-Type" content="text/html; charset=euc-kr">
<script language="JavaScript" src='/include/common.js'></script>
<script language="JavaScript">
<!--
	var popObj = null;
	
	//�˾������� ����
	function ScanOpen(theURL,file_type) { //v2.0
		if( popObj != null ){
			popObj.close();
			popObj = null;
		}
		if(file_type == ''){
			theURL = "https://fms3.amazoncar.co.kr/data/bank/"+theURL+".pdf";
		}else{			
			theURL = "https://fms3.amazoncar.co.kr/data/bank/"+theURL+""+file_type;		
		}
		if(file_type == '.jpg'){
			theURL = '/fms2/lc_rent/img_scan_view.jsp?img_url='+theURL;
			popObj =window.open('','popwin_in1','scrollbars=yes,status=yes,resizable=yes,width=<%=(2100*0.378)+50%>,height=<%=s_height%>,left=0, top=0');
		}else{
			popObj = window.open('','popwin_in1','scrollbars=no,status=yes,resizable=yes,width=820,height=600,left=50, top=50');
		}					
		popObj.location = theURL;
		popObj.focus();		

	}

		
	//����
	function modify(){
		var fm = document.form1;	
		
		var deposit_no = fm.deposit_no_d.options[fm.deposit_no_d.selectedIndex].value;		
		if(deposit_no.indexOf(":") == -1){
			fm.deposit_no_d.value = deposit_no;
		}else{
			var deposit_split = deposit_no.split(":");
			fm.deposit_no_d.value = deposit_split[0];	
 		}
		
		fm.p_bank_nm.value = fm.ps_bank_id.options[fm.ps_bank_id.selectedIndex].text;
		
		if(fm.p_bank_nm.value == '����')		fm.p_bank_nm.value = '';
		
		
		if(confirm('�����Ͻðڽ��ϱ�?')){
			if(fm.cont_dt.value == ''){	alert('������� �Է��Ͻʽÿ�');	fm.cont_dt.focus(); return;	}			
			if(fm.cont_bn_st.value == '1') 	fm.cont_bn.value = fm.cont_bn.value;
			else 							fm.cont_bn.value = fm.cont_bn2.value;
			fm.action='bank_lend_u_a.jsp';
			fm.target='i_no';
			fm.submit();
		}
	}
	
	//���
	function go_to_list(){
		var fm = document.form1;	
		fm.action ='bank_frame_s.jsp';
		fm.target='d_content';		
		fm.submit();	
	}
	
	//����-����Ϸ��϶� 1���Ͻû�ȯ �Է½� ����ݾ�,��ȯ�Ѿ� ����	
	function set_cont_amt(idx){
		var fm = document.form1;	
		fm.idx.value = idx;
		fm.target = 'i_no';
		fm.action = 'lim_dt_nodisplay.jsp';
//		fm.submit();		
	}
	
	//������ �հ� ���
	function set_total_amt(){
		var fm = document.form1;
		fm.total_amt.value = parseDecimal(toInt(parseDigit(fm.charge_amt.value))+toInt(parseDigit(fm.ntrl_fee.value))+toInt(parseDigit(fm.stp_fee.value)));
	}
	
	//�����û�Ⱓ����
	function lend_lim_chk(){
		var fm = document.form1;
		if(fm.lend_lim.value == '1'){//�����û�Ⱓ���� �ִ�.
			if(fm.lend_lim_st.value == '' || fm.lend_lim_et.value == ''){ alert('�����û�Ⱓ ������ �Է��Ͻʽÿ�'); fm.lend_lim_st.focus(); return;}		
			var today = getToday();
			var s_dt = replaceString("-","",fm.lend_lim_st.value);
			var e_dt = replaceString("-","",fm.lend_lim_et.value);
			if(parseInt(s_dt) > parseInt(today) || parseInt(today) > parseInt(e_dt)){
				alert(today+'�� �����û�Ⱓ '+s_dt+'~'+e_dt+'�� �������ϴ�');
				return;
			}			
		}
	}

	//���⺰���
	function mapping_reg(){		
		var fm = document.form1;	
		if(fm.move_st.value == '1'){ alert('���� �Ϸ�� ��������Դϴ�.\n\n���⺰����� �Ͻ� �� �����ϴ�.'); return; }		
//		if(fm.pm_rest_amt.value == '0' && fm.pm_amt.value > '0'){ alert('�����ܾ��� 0�� �Դϴ�.\n\n�����ݾ��� �ʰ��Ͽ� ����� �� �����ϴ�.'); return; }
		if(confirm('�����ܾ��� '+fm.pm_rest_amt.value+'�� �Դϴ�.\n\n���⺰ ����� �Ͻðڽ��ϱ�?')){
			if(fm.rtn_st.value == '0') lend_lim_chk()
			var auth_rw = fm.auth_rw.value;						
			var lend_id = fm.lend_id.value;			
			var cont_bn = fm.cont_bn.value;		
			var lend_int = fm.lend_int.value;
			var max_cltr_rat = fm.max_cltr_rat.value;
			var lend_amt_lim = fm.lend_amt_lim.value;
			var rtn_st = fm.rtn_st.value;		
			var rtn_size = fm.rtn_size.value;				
			if(fm.cont_bn_st.value == '2') cont_bn = fm.cont_bn2.value;
			window.open('bank_mapping_frame_s.jsp?gubun=reg&auth_rw='+auth_rw+'&lend_id='+lend_id+'&cont_bn='+cont_bn+'&lend_int='+lend_int+'&max_cltr_rat='+max_cltr_rat+'&lend_amt_lim='+lend_amt_lim+'&rtn_st='+rtn_st+'&rtn_size='+rtn_size, "MAPPING", "left=100, top=30, width=840, height=610, scrollbars=yes, status=yes");
		}
	}
	
	//���ະ���⸮��Ʈ
	function mapping_list(){
		var fm = document.form1;	
		var lend_id = fm.lend_id.value;	
		var auth_rw = fm.auth_rw.value;		
		var rtn_st = fm.rtn_st.value;		
		var rtn_size = fm.rtn_size.value;		
		var lend_int = fm.lend_int.value;							
		window.open('bank_mapping_frame_s.jsp?gubun=list&auth_rw='+auth_rw+'&lend_id='+lend_id+'&rtn_st='+rtn_st+'&rtn_size='+rtn_size+'&lend_int='+lend_int, "MAPPING", "left=20, top=20, width=900, height=700, scrollbars=yes, status=yes");
	}
	
	//��ȯ������ ���
	function scd_view(gu, idx, rtn_seq, cont_term){
		var fm = document.form1;
		var lend_id = fm.lend_id.value;	
		var auth_rw = fm.auth_rw.value;		
		if(gu == 'i'){
			parent.location='bank_scd_i.jsp?auth_rw='+auth_rw+'&lend_id='+lend_id+'&rtn_seq_r='+rtn_seq+'&cont_term='+cont_term;
		}else{
			parent.location='bank_scd_u.jsp?auth_rw='+auth_rw+'&lend_id='+lend_id+'&rtn_seq_r='+rtn_seq+'&cont_term='+cont_term;
		}
	}
	
	//����������� ����
	function select_agnt(seq, nm, title, tel, email){
		var fm = document.form1;
		fm.seq.value = seq;
		fm.ba_nm.value = nm;
		fm.ba_tel.value = tel;
		fm.ba_title.value = title;
		fm.ba_email.value = email;
	}
	
	//����������� ����
	function modify_agnt(idx){
		var fm = document.form1;
		var ment = '';
		if(idx == '1'){//����
		 	fm.gubun.value='a_u';
			ment = '����';
			if(fm.seq.value == ''){	alert('��ϵ� ����ڸ� �����ϰ� ������ �� ������ư�� �����ʽÿ�');	return;	}
			if(fm.ba_nm.value == ''){ alert('����� �̸��� �Է��Ͻʽÿ�');	return;	}
		}else if(idx == '0'){//�߰�
			ment = '�߰�';		
			fm.gubun.value='a_i';
			if(fm.ba_nm.value == ''){ alert('����� �̸��� �Է��Ͻʽÿ�');	return;	}
		}
		
		if(confirm(ment+'�Ͻðڽ��ϱ�?')){
			fm.action='bank_lend_u_a.jsp';
			fm.target='i_no';
			fm.submit();
		}
	}	
		
	//���÷��� Ÿ��
	function bn_display(){
		var fm = document.form1;
		if(fm.cont_bn_st.options[fm.cont_bn_st.selectedIndex].value == '1'){ //�����籸�� ���ý� ������ ���÷���
			td_bn_1.style.display	= '';
			td_bn_2.style.display	= 'none';
		}else{
			td_bn_1.style.display	= 'none';
			td_bn_2.style.display	= '';
		}
	}	
	//���÷��� Ÿ��
	function docs_display(){
		var fm = document.form1;
		if(fm.cl_lim.options[fm.cl_lim.selectedIndex].value == '1'){ //�ŷ�ó ���Ѽ��ý� ������ ���÷���
			tr_docs.style.display	= '';
		}else{
			tr_docs.style.display	= 'none';
		}
	}	
	//����->����Ϸ�� �߰���ư
	function add_display(){
		var fm = document.form1;
		var rtn_size = fm.rtn_size.value;
		if(fm.rtn_st.options[fm.rtn_st.selectedIndex].value == '1'){//����
			if(rtn_size == '1' && fm.rtn_move_st0.value == '1')		td_add.style.display = '';	
			else if(rtn_size == '2' && fm.rtn_move_st1.value == '1')	td_add.style.display = '';	
			else if(rtn_size == '3' && fm.rtn_move_st2.value == '1')	td_add.style.display = '';	
			else if(rtn_size == '4' && fm.rtn_move_st3.value == '1')	td_add.style.display = '';	
			else if(rtn_size == '5' && fm.rtn_move_st4.value == '1')	td_add.style.display = '';												
			else 								td_add.style.display = 'none';			
		}
	} 
	//��ȯ���м��ý� ���÷��� Ÿ��
	function rtn_display1(){
		var fm = document.form1;
		td_rtn_su.style.display	= 'none';
		td_add.style.display	= 'none';		
		tr_rtn_1.style.display	= '';
		tr_rtn_2.style.display	= 'none';
		tr_rtn_3.style.display	= 'none';
		tr_rtn_4.style.display	= 'none';
		tr_rtn_5.style.display	= 'none';
		if(fm.rtn_st.options[fm.rtn_st.selectedIndex].value == '2'){//����
			td_rtn_su.style.display	= '';
		}
//		if(fm.rtn_st.options[fm.rtn_st.selectedIndex].value == '1'){//����
//			td_add.style.display	= '';
//		}
	}
		
	//��ȯ���� ���ҿ��� ���� ���ý� ���÷��� Ÿ��
	function rtn_display2(){
		var fm = document.form1;
		if(fm.rtn_su.options[fm.rtn_su.selectedIndex].value == '1'){//����(1)
			tr_rtn_1.style.display	= '';
			tr_rtn_2.style.display	= 'none';
			tr_rtn_3.style.display	= 'none';
			tr_rtn_4.style.display	= 'none';
			tr_rtn_5.style.display	= 'none';		
		}else if(fm.rtn_su.options[fm.rtn_su.selectedIndex].value == '2'){//����(2)
			tr_rtn_1.style.display	= '';
			tr_rtn_2.style.display	= '';
			tr_rtn_3.style.display	= 'none';
			tr_rtn_4.style.display	= 'none';
			tr_rtn_5.style.display	= 'none';
		}else if(fm.rtn_su.options[fm.rtn_su.selectedIndex].value == '3'){//����(3)
			tr_rtn_1.style.display	= '';
			tr_rtn_2.style.display	= '';
			tr_rtn_3.style.display	= '';
			tr_rtn_4.style.display	= 'none';
			tr_rtn_5.style.display	= 'none';
		}else if(fm.rtn_su.options[fm.rtn_su.selectedIndex].value == '4'){//����(4)
			tr_rtn_1.style.display	= '';
			tr_rtn_2.style.display	= '';
			tr_rtn_3.style.display	= '';
			tr_rtn_4.style.display	= '';
			tr_rtn_5.style.display	= 'none';
		}else if(fm.rtn_su.options[fm.rtn_su.selectedIndex].value == '5'){//����(5)
			tr_rtn_1.style.display	= '';
			tr_rtn_2.style.display	= '';
			tr_rtn_3.style.display	= '';
			tr_rtn_4.style.display	= '';
			tr_rtn_5.style.display	= '';
		}else{
			tr_rtn_1.style.display	= '';
			tr_rtn_2.style.display	= 'none';
			tr_rtn_3.style.display	= 'none';
			tr_rtn_4.style.display	= 'none';
			tr_rtn_5.style.display	= 'none';
		}
	}
	
	//��ȯ���� ���ҿ��� ���� ���ý� ���÷��� Ÿ��
	function rtn_display3(){
		var fm = document.form1;
		var su = fm.su.value;	
		if(fm.rtn_st.options[fm.rtn_st.selectedIndex].value == '1'){//����
			if(su ==1){		 
				tr_rtn_1.style.display	= '';
				tr_rtn_2.style.display	= '';
				tr_rtn_3.style.display	= 'none';
				tr_rtn_4.style.display	= 'none';
				tr_rtn_5.style.display	= 'none';
			}else if(su ==2){			
				tr_rtn_1.style.display	= '';
				tr_rtn_2.style.display	= '';
				tr_rtn_3.style.display	= '';
				tr_rtn_4.style.display	= 'none';
				tr_rtn_5.style.display	= 'none';
			}else if(su ==3){			
				tr_rtn_1.style.display	= '';
				tr_rtn_2.style.display	= '';
				tr_rtn_3.style.display	= '';
				tr_rtn_4.style.display	= '';
				tr_rtn_5.style.display	= 'none';
			}else if(su ==4){			
				tr_rtn_1.style.display	= '';
				tr_rtn_2.style.display	= '';
				tr_rtn_3.style.display	= '';
				tr_rtn_4.style.display	= '';
				tr_rtn_5.style.display	= '';
			}
			fm.su.value = parseInt(su)+1;			
		}
	}	
	
	//�ߵ�����
	function view_cls(cls_yn, rtn_seq){	
		var fm = document.form1;
		var auth_rw = fm.auth_rw.value;
		var lend_id = fm.lend_id.value;
		var url = "";
		url = "../cls_bank/cls_i.jsp?auth_rw="+auth_rw+"&lend_id="+lend_id+"&rtn_seq="+rtn_seq;
		window.open(url, "CLS_I", "left=100, top=80, width=840, height=550, status=yes, scrollbars=yes");
	}		
	
	//�ߵ�����
	function view_cls_list(cls_yn, rtn_seq){	
		var fm = document.form1;
		var auth_rw = fm.auth_rw.value;
		var lend_id = fm.lend_id.value;
		var url = "";
		url = "../cls_bank/cls_list.jsp?auth_rw="+auth_rw+"&lend_id="+lend_id+"&rtn_seq="+rtn_seq;
		window.open(url, "CLS_LIST", "left=10, top=80, width=1040, height=550, status=yes, scrollbars=yes");
	}			
	
	//�ڵ���ǥ----------------------------------------------------------------------------------------------------
	
	//���༱�ý� ���¹�ȣ ��������
	function change_bank(){
		var fm = document.form1;
		//����
		var bank_code = fm.bank_code.options[fm.bank_code.selectedIndex].value;
		fm.bank_code2.value = bank_code.substring(0,3);
		fm.bank_name.value = bank_code.substring(3);
				
		drop_deposit();		

		if(bank_code == ''){
			fm.bank_code.options[0] = new Option('����', '');
			return;
		}else{
			fm.target='i_no';
			fm.action='get_deposit_nodisplay.jsp?bank_code='+bank_code.substring(0,3);
			fm.submit();
		}
	}	
	function drop_deposit(){
		var fm = document.form1;
		var deposit_len = fm.deposit_no_d.length;
		for(var i = 0 ; i < deposit_len ; i++){
			fm.deposit_no_d.options[deposit_len-(i+1)] = null;
		}
	}		
	function add_deposit(idx, val, str){
		document.form1.deposit_no_d[idx] = new Option(str, val);		
	}		
	//��ȸ�ϱ�
	function ven_search(idx){
		var fm = document.form1;
		window.open("/acar/con_debt/vendor_list.jsp?idx="+idx, "VENDOR_LIST", "left=50, top=50, width=500, height=400, scrollbars=yes");		
	}
	
	//��ĵ���
	function scan_reg(){
		window.open("reg_scan.jsp?lend_id=<%=lend_id%>&alt_st=lend_bank", "SCAN", "left=10, top=10, width=620, height=250, scrollbars=yes, status=yes, resizable=yes");
	}
			
		
	//��ĵ���
	function scan_reg_scd(){
		window.open("reg_scan.jsp?lend_id=<%=lend_id%>&alt_st=scd", "SCAN", "left=10, top=10, width=620, height=250, scrollbars=yes, status=yes, resizable=yes");
	}

	
	//�ü��ڱ� ��ȸ
	function search_fund_bank(){
		var fm = document.form1;
		window.open("/fms2/bank_mng/s_fund_bank.jsp?from_page=/acar/bank_mng/bank_lend_u.jsp&lend_id=<%=lend_id%>&cont_bn=<%=bl.getCont_bn()%>", "SEARCH_LEND_BANK", "left=50, top=50, width=750, height=600, scrollbars=yes");		
	}	
	
	//���ΰ�ħ
	function go_to_self()
	{
		var fm = document.form1;	
		fm.action = 'bank_lend_u.jsp';
		fm.target = 'd_content';		
		fm.submit();
	}	
	
//-->
</script>
</head>

<body leftmargin=15>
<form action="bank_lend_u_a.jsp" name="form1" method="POST">
<input type='hidden' name='auth_rw' value='<%=auth_rw%>'>
<input type="hidden" name="user_id" value="<%=user_id%>">
<input type="hidden" name="br_id" value="<%=br_id%>">
<input type='hidden' name='sh_height' value='<%=sh_height%>'>
<input type='hidden' name='bank_id' value='<%=bank_id%>'>
<input type='hidden' name='gubun1' value='<%=gubun1%>'>
<input type="hidden" name="lend_id" value="<%=lend_id%>">
<input type='hidden' name='gubun' value=''>
<input type='hidden' name='idx' value=''>
<input type='hidden' name='alt_st' value='lend_bank'>
<table border=0 cellspacing=0 cellpadding=0 width=100%>
    <tr> 
        <td colspan="2"><img src=../images/center/icon_arrow.gif align=absmiddle> <span class=style2>��������</span></td>
    </tr>
    <tr>
        <td colspan=2 class=line2></td>
    </tr>
    <tr> 
        <td class=line colspan="2"> 
            <table border="0" cellspacing="1" width=100%>
                <tr> 
                    <td class=title width=10%>�����</td>
                    <td width=15%>&nbsp; 
                      <input type="text" name="cont_dt" maxlength='11' value="<%=bl.getCont_dt()%>" size="11" class=text onBlur='javascript:this.value=ChangeDate(this.value)'>
                    </td>
                    <td class=title width=10%>�����籸��</td>
                    <td width=15%>&nbsp; 
                      <select name='cont_bn_st'  onChange='javascript:bn_display()'>
                        <option value="1" <%if(bl.getCont_bn_st().equals("1")){%>selected<%}%>>��1������</option>
                        <option value="2" <%if(bl.getCont_bn_st().equals("2")){%>selected<%}%>>��2������</option>
                      </select>
                    </td>
                    <td class=title width=10%>������</td>
                    <td width=15%> 
                        <table width=100% border="0" cellspacing="0" cellpadding="0">
                            <tr> 
                                <td id="td_bn_1" <%if(bl.getCont_bn_st().equals("1") || bl.getCont_bn_st().equals("")){%>style="display:''"<%}else{%>style='display:none'<%}%> >&nbsp; 
                                    <select name='cont_bn'>
                                      <%	if(bank_size > 0){
                								for(int i = 0 ; i < bank_size ; i++){
                									CodeBean bank = banks[i];		%>
                                      <option value='<%= bank.getCode()%>' <%if(bl.getCont_bn().equals(bank.getCode())){%>selected<%}%>><%= bank.getNm()%></option>
                                      <%		}
                							}		%>
                                    </select>
                                </td>
                                <td id="td_bn_2" <%if(bl.getCont_bn_st().equals("2")){%>style="display:''"<%}else{%>style='display:none'<%}%> >&nbsp; 
                                    <select name='cont_bn2'>
                                      <%	if(bank_size2 > 0){
                								for(int i = 0 ; i < bank_size2 ; i++){
                									CodeBean bank2 = banks2[i];		%>
                                      <option value='<%= bank2.getCode()%>' <%if(bl.getCont_bn().equals(bank2.getCode())){%>selected<%}%>><%= bank2.getNm()%></option>
                                      <%		}
                							}		%>
                                    </select>
                                </td>
                            </tr>
                        </table>
                    </td>
                    <td class=title width=10%>��౸��</td>
                    <td width=15%>&nbsp; 
                      <select name='cont_st'>
                        <option value="0" <%if(bl.getCont_st().equals("0")){%>selected<%}%>>�ű�</option>
                        <option value="1" <%if(bl.getCont_st().equals("1")){%>selected<%}%>>����</option>
                      </select>
                    </td>
                </tr>
                <tr> 
                    <td class=title>����</td>
                    <td colspan="3">&nbsp; 
                      <input type="text" name="bn_br" maxlength='30' value="<%=bl.getBn_br()%>" size="43" class=text>
                    </td>
                    <td class=title>������ȭ��ȣ</td>
                    <td>&nbsp; 
                      <input type="text" name="bn_tel" maxlength='15' value="<%=bl.getBn_tel()%>" size="15" class=text>
                    </td>
                    <td class=title>�����ѽ���ȣ</td>
                    <td>&nbsp; 
                      <input type="text" name="bn_fax" maxlength='15' value="<%=bl.getBn_fax()%>" size="15" class=text>
                    </td>
                </tr>
            </table>
        </td>
    </tr>
    <tr></tr><tr></tr><tr></tr>
    <tr> 
        <td class=line colspan="2"> 
            <table border="0" cellspacing="1" width=100%>
                <tr> 
                    <td class=title width=10%>NO</td>
                    <td class=title width=15%>���� �����</td>
                    <td class=title width=15%>����</td>
                    <td class=title width=20%>����ó</td>
                    <td class=title width=25%>E-mail</td>
                    <td class=title width=15%>&nbsp;</td>
                </tr>
              <%Vector agnts = abl_db.getBankAgnts(lend_id);
    			int agnt_size = agnts.size();
    			if(agnt_size > 0){%>
              <%				for(int i = 0 ; i < agnt_size ; i++){
    					BankAgntBean agnt = (BankAgntBean)agnts.elementAt(i);%>
                <tr> 
                    <td align="center"><%=agnt.getSeq()%></td>
                    <td align="center"><a href="javascript:select_agnt('<%=agnt.getSeq()%>', '<%=agnt.getBa_nm()%>', '<%=agnt.getBa_title()%>', '<%=agnt.getBa_tel()%>', '<%=agnt.getBa_email()%>')" onMouseOver="window.status=''; return true"><%=agnt.getBa_nm()%></a></td>
                    <td align="center"><%=agnt.getBa_title()%></td>
                    <td align="center"><%=agnt.getBa_tel()%></td>
                    <td align="center"><%=agnt.getBa_email()%></td>
                    <td></td>
                </tr>
              <%				}
    			}		%>
                <tr align="center"> 
                    <td> 
                      <input type="hidden" name="seq" value="" size="12" maxlength='30'>
                    </td>
                    <td> 
                      <input type="text" name="ba_nm" value="" size="12" maxlength='30' class=text>
                    </td>
                    <td> 
                      <input type="text" name="ba_title" value="" size="13" maxlength='30' class=text>
                    </td>
                    <td> 
                      <input type="text" name="ba_tel" value="" size="15" maxlength='15' class=text>
                    </td>
                    <td> 
                      <input type="text" name="ba_email" value="" size="25" maxlength='50' class=text>
                    </td>
                    <td> 
                      <a href="javascript:modify_agnt('1');"><img src=../images/center/button_in_modify.gif align=absmiddle border=0></a>
                      &nbsp;&nbsp; 
                      <a href="javascript:modify_agnt('0');"><img src=../images/center/button_in_plus.gif align=absmiddle border=0></a>
                    </td>
                </tr>
            </table>
        </td>
    </tr>
    <tr></tr><tr></tr><tr></tr>
    <tr> 
        <td class=line colspan="2"> 
            <table border="0" cellspacing="1" width=100%>
                <tr> 
                    <td class=title width=10%>��� ������</td>
                    <td width=15%>&nbsp; 
                      <select name='br_id'>
                        <option value=''>����</option>
                        <%	if(brch_size > 0)	{
        						for (int i = 0 ; i < brch_size ; i++){
        							Hashtable branch = (Hashtable)branches.elementAt(i);		%>
                        <option value='<%=branch.get("BR_ID")%>' <%if(bl.getBr_id().equals(branch.get("BR_ID"))){%>selected<%}%>><%= branch.get("BR_NM")%></option>
                        <%		}
        					}			%>
                      </select>
                    </td>
                    <td class=title width=10%>�����</td>
                    <td width=15%>&nbsp; 
                      <select name='mng_id'>
                        <%	if(user_size > 0){
        						for(int i = 0 ; i < user_size ; i++){
        							Hashtable user = (Hashtable)users.elementAt(i);	%>
                        <option value='<%= user.get("USER_ID") %>' <%if(bl.getMng_id().equals(user.get("USER_ID"))){%>selected<%}%>><%= user.get("USER_NM")%></option>
                        <%		}
        					}		%>
                      </select>
                    </td>
                    <td class=title width=10%>���࿩��</td>
                    <td width=40%>&nbsp; 
                      <select name='move_st'>
                        <option value="0" <%if(bl.getMove_st().equals("0")){%>selected<%}%>>����</option>
                        <option value="1" <%if(bl.getMove_st().equals("1")){%>selected<%}%>>�Ϸ�</option>
                      </select>
                    </td>
                </tr>
            </table>
        </td>
    </tr>
    <tr>
        <td class=h></td>
    </tr>
    <tr> 
        <td colspan="2"><img src=../images/center/icon_arrow.gif align=absmiddle> <span class=style2>��������</span></td>
    </tr>
    <tr>
        <td colspan=2 class=line2></td>
    </tr>
    <tr> 
        <td class=line colspan="2"> 
            <table border="0" cellspacing="1" width=100%>
                <tr> 
                    <td class=title>�ŷ�ó ����</td>
                    <td colspan="7">&nbsp; 
                      <select name='cl_lim'  onChange='javascript:docs_display()'>
                        <option value="1" <%if(bl.getCl_lim().equals("1")){%>selected<%}%>>��</option>
                        <option value="0" <%if(bl.getCl_lim().equals("0")){%>selected<%}%>>��</option>
                      </select>
                    </td>
                </tr>
                <tr id=tr_docs  <%if(!bl.getCl_lim().equals("0")){%>style="display:''"<%}else{%>style='display:none'<%}%>> 
                    <td class=title>������</td>
                    <td colspan="7">&nbsp; 
                      <textarea name="cl_lim_sub" cols="90" rows="2"><%=bl.getCl_lim_sub()%></textarea>
                    </td>
                </tr>
                <tr> 
                    <td class=title>���� ����</td>
                    <td colspan="7">&nbsp; 
                      <select name='ps_lim'>
                        <option value="1" <%if(bl.getPs_lim().equals("1")){%>selected<%}%>>��</option>
                        <option value="0" <%if(bl.getPs_lim().equals("0")){%>selected<%}%>>��</option>
                      </select>
                    </td>
                </tr>
                <tr> 
                    <td class=title style='height:40'>����ݾ�<br>����</td>
                    <td colspan="5">&nbsp; 
                      <select name='lend_amt_lim'>
                        <option value="" <%if(bl.getLend_amt_lim().equals("")){%>selected<%}%>>����</option>
                        <option value="1" <%if(bl.getLend_amt_lim().equals("1")){%>selected<%}%>>(��������(Ź�۷�����)/1.1)�� ���� �ݾ׿� �������� ����</option>
                        <option value="3" <%if(bl.getLend_amt_lim().equals("3")){%>selected<%}%>>(��������(Ź�۷�����)/1.1)�� ���� �ݾ׿� õ������ ����</option>
                        <option value="4" <%if(bl.getLend_amt_lim().equals("4")){%>selected<%}%>>(��������(Ź�۷�����)/1.1)�� ���� �ݾ׿� ������� ����</option>
        				<option value="2" <%if(bl.getLend_amt_lim().equals("2")){%>selected<%}%>>(��������(Ź�۷�����)�� 85%)�� ���� �ݾ׿� �������� ����</option>
        				<option value="5" <%if(bl.getLend_amt_lim().equals("5")){%>selected<%}%>>(��������(Ź�۷�����)�� 70%)�� ���� �ݾ׿� �������� ����</option>				
                        <option value="0" <%if(bl.getLend_amt_lim().equals("0")){%>selected<%}%>>����</option>
                      </select>
                      <font color="#999999">(����)</font><%=bl.getRtn_change()%></td>
                    <td class=title>��ȯ���� ����<br>�ܾ����� ��ü</td>
                    <td>&nbsp; 
                      <select name='rtn_change'>
                        <option value="0" <%if(bl.getRtn_change().equals("0")){%>selected<%}%>>��</option>
                        <option value="1" <%if(bl.getRtn_change().equals("1")){%>selected<%}%>>��</option>
                      </select>
                    </td>
                </tr>		  
                <tr> 
                    <td class=title style='height:40'>�����缳��<br>ä���ְ��</td>
                    <td>&nbsp;������� 
                      <input type="text" name="max_cltr_rat" value="<%=bl.getMax_cltr_rat()%>" maxlength='5' size="3" class=text>
                      (%)</td>
                    <td class=title>�����û<br>�Ⱓ���� ����</td>
                    <td>&nbsp; 
                      <select name='lend_lim'>
                        <option value="1" <%if(bl.getLend_lim().equals("1")){%>selected<%}%>>��</option>
                        <option value="0" <%if(bl.getLend_lim().equals("0")){%>selected<%}%>>��</option>
                      </select>
                    </td>
                    <td class=title>�����û<br>�Ⱓ����</td>
                    <td colspan="3">&nbsp; 
                      <input type="text" name="lend_lim_st" value="<%=bl.getLend_lim_st()%>" size="11" class=text onBlur='javascript:this.value=ChangeDate(this.value)'>
                      ~ 
                      <input type="text" name="lend_lim_et" value="<%=bl.getLend_lim_et()%>" size="11" class=text onBlur='javascript:this.value=ChangeDate(this.value)'>
                    </td>
                </tr>
                <tr> 
                    <td class=title style='height:40'>ä�Ǿ絵���<br>��༭</td>
                    <td colspan="7">&nbsp; 
                      <input type="text" name="cre_docs" value="<%=bl.getCre_docs()%>" maxlength='80' size="80" class=text>
                      <font color="#999999">(��:������ �Ժ���)</font></td>
                </tr>
                <tr> 
                    <td class=title>��Ÿ</td>
                    <td colspan="7">&nbsp; 
                      <textarea name="note" cols="152" rows="2"><%=bl.getNote()%></textarea>
                    </td>
                </tr>
                <tr> 
                    <td class=title>��������</td>
                    <td>&nbsp; 
                      <input type="text" name="f_rat" value="<%=bl.getF_rat()%>" size="5" maxlength='5' class=text>
                      (%)</td>
                    <td class=title>�����ھ�</td>
                    <td>&nbsp; 
                      <input type="text" name="f_amt" maxlength='9' value="<%=AddUtil.parseDecimal(bl.getF_amt())%>" size="10" class=num onBlur='javascript:this.value=parseDecimal(this.value)'>
                      ��</td>
                    <td class=title>����Ⱓ</td>
                    <td colspan="3">&nbsp; 
                      <input type="text" name="f_start_dt" value="<%=bl.getF_start_dt()%>" size="11" class=text onBlur='javascript:this.value=ChangeDate(this.value)'>
                      ~ 
                      <input type="text" name="f_end_dt" value="<%=bl.getF_end_dt()%>" size="11" class=text onBlur='javascript:this.value=ChangeDate(this.value)'>
                    </td>
                </tr>
                <tr> 
                    <td class='title' width=10%>������</td>
                    <td width=15%>&nbsp; 
                      <input type="text" name="charge_amt" maxlength='9' value="<%=AddUtil.parseDecimal(bl.getCharge_amt())%>" size="10" class=num onBlur='javascript:this.value=parseDecimal(this.value); set_total_amt();'>
                      ��</td>
                    <td class='title' width=10%>������</td>
                    <td width=15%>&nbsp; 
                      <input type="text" name="ntrl_fee" maxlength='9' value="<%=AddUtil.parseDecimal(bl.getNtrl_fee())%>" size="10" class=num onBlur='javascript:this.value=parseDecimal(this.value); set_total_amt();'>
                      ��</td>
                    <td class='title' width=10%>������</td>
                    <td width=15%>&nbsp; 
                      <input type="text" name="stp_fee" maxlength='9' value="<%=AddUtil.parseDecimal(bl.getStp_fee())%>" size="10" class=num onBlur='javascript:this.value=parseDecimal(this.value); set_total_amt();'>
                      ��</td>
                    <td class='title' width=10%">�հ�</td>
                    <td width=15%>&nbsp; 
                      <input type="text" name="total_amt" maxlength='9' value="<%=AddUtil.parseDecimal(bl.getCharge_amt()+bl.getNtrl_fee()+bl.getStp_fee())%>" size="10" class=whitenum onBlur='javascript:this.value=parseDecimal(this.value)'>
                      ��</td>
                </tr>
                <tr> 
                    <td class=title>����</td>
                    <td colspan="7">&nbsp; 
                      <textarea name="condi" cols="152" rows="2"><%=bl.getCondi()%></textarea>
                    </td>
                </tr>
            </table>
        </td>
    </tr>
    <tr>
        <td class=h></td>
    </tr>
    <tr> 
        <td colspan="2"><img src=../images/center/icon_arrow.gif align=absmiddle> <span class=style2>�������</span></td>
    </tr>
    <tr>
        <td colspan=2 class=line2></td>
    </tr>
    <tr> 
        <td class=line colspan="2"> 
            <table border="0" cellspacing="1" width=100%>
                <tr> 
                    <td class=title width=10%>����ݾ�</td>
                    <td width=15%>&nbsp; 
                      <input type="text" name="cont_amt"  value="<%=AddUtil.parseDecimalLong(bl.getCont_amt())%>" size="15" class=num onBlur='javascript:this.value=parseDecimal(this.value)'>
                      ��</td>
                    <td class=title width=10%>��������</td>
                    <td width=15%>&nbsp; 
                      <input type="text" name="lend_int" value="<%=bl.getLend_int()%>" maxlength='10' size="10" class=text>
                      (%)</td>
                    <td class=title width=10%>��ȯ����</td>
                    <td width=40%> 
                        <table width="100%" border="0" cellspacing="0" cellpadding="0">
                            <tr> 
                                <td width="70">&nbsp; 
                                    <select name='rtn_st'  onChange='javascript:rtn_display1()'>
                                      <option value="0" <%if(bl.getRtn_st().equals("0")){%>selected<%}%>>��ü</option>
                                      <option value="1" <%if(bl.getRtn_st().equals("1")){%>selected<%}%>>����</option>
                                      <option value="2" <%if(bl.getRtn_st().equals("2")){%>selected<%}%>>����</option>
                                    </select>
                                </td>
                                <td width="70" id="td_rtn_su"> 
                                    <select name='rtn_su'  onChange='javascript:rtn_display2()'>
                                      <option value=""  <%if(bl.getRtn_su().equals("")){%>selected<%}%>>����</option>
                                      <option value="1" <%if(bl.getRtn_su().equals("1")){%>selected<%}%>>1</option>					  
                                      <option value="2" <%if(bl.getRtn_su().equals("2")){%>selected<%}%>>2</option>
                                      <option value="3" <%if(bl.getRtn_su().equals("3")){%>selected<%}%>>3</option>
                                      <option value="4" <%if(bl.getRtn_su().equals("4")){%>selected<%}%>>4</option>
                                      <option value="5" <%if(bl.getRtn_su().equals("5")){%>selected<%}%>>5</option>
                                    </select>
                                </td>
                                <td align="right"><img src=../images/center/arrow_help.gif align=absmiddle> : <a href="#" title="��ȯ����. ����� �������� ������ �����Ѵ�.">��ü</a>/ 
                                <a href="#" title="��ȯ�� ������ �߻��Ѵ�.(1��,2��)  �������� ��ȯ���� �����Ѵ�. ����� �����Ѵ�.">����</a>/ 
                                <a href="#" title="�ѹ��� �������� �����Ͽ� ��ȯ�Ѵ�.">����</a>&nbsp;&nbsp;</td>            				  
                            </tr>
                        </table>
                    </td>
                </tr>
                <tr> 
                    <td class='title'>ä��Ȯ������</td>
                    <td colspan='5'>&nbsp; 
                            <select name='bond_get_st'>
                              <option value="" <%if(bl.getBond_get_st().equals("")){%>selected<%}%>>����</option>
                              <option value="1" <%if(bl.getBond_get_st().equals("1")){%>selected<%}%>>��༭ 
                              </option>
                              <option value="2" <%if(bl.getBond_get_st().equals("2")){%>selected<%}%>>��༭+�ΰ�����</option>
                              <option value="3" <%if(bl.getBond_get_st().equals("3")){%>selected<%}%>>��༭+�ΰ�����+������</option>
                              <option value="4" <%if(bl.getBond_get_st().equals("4")){%>selected<%}%>>��༭+�ΰ�����+������+LOAN 
                              ���뺸���������</option>
                              <option value="5" <%if(bl.getBond_get_st().equals("5")){%>selected<%}%>>��༭+�ΰ�����+������+LOAN 
                              ���뺸����������</option>
                              <option value="6" <%if(bl.getBond_get_st().equals("6")){%>selected<%}%>>��༭+���뺸����</option>
                              <option value="7" <%if(bl.getBond_get_st().equals("7")){%>selected<%}%>>��Ÿ</option>
                            </select>
                          &nbsp;�߰�����:&nbsp; 
                            <input type="text" name="bond_get_st_sub" maxlength='40' value="<%=bl.getBond_get_st_sub()%>" size="40" class=text>
                    </td>
                </tr>
                <tr> 
                    <td class=title width=10%>�ߵ���ȯ<br>��������</td>
                    <td width=15%>&nbsp; 
                      <input type="text" name="cls_rtn_fee_int" maxlength='5' value="<%=bl.getCls_rtn_fee_int()%>" size="5" class=text >
                      (%)</td>
                    <td class=title wwidth=10%>�ߵ���ȯ<br>Ư�̻���</td>
                    <td colspan='3'>&nbsp; 
                      <textarea name="cls_rtn_etc" cols="90" rows="2"><%=bl.getCls_rtn_etc()%></textarea></td>                    
                </tr>	
                <tr> 
                    <td class='title'>����������༭</td>
                    <td colspan='5'>&nbsp; 
			<%if(attach_vt_size > 0){%>
			    <%	for (int j = 0 ; j < attach_vt_size ; j++){
    					Hashtable ht = (Hashtable)attach_vt.elementAt(j);%>
    					&nbsp;<a href="javascript:openPopP('<%=ht.get("FILE_TYPE")%>','<%=ht.get("SEQ")%>');" title='����' ><img src="/acar/images/center/button_in_see.gif" align="absmiddle" border="0"></a>
    					&nbsp;<a href="https://fms3.amazoncar.co.kr/fms2/attach/delete.jsp?SEQ=<%=ht.get("SEQ")%>" target='_blank'><img src="/acar/images/center/button_in_delete.gif" align="absmiddle" border="0"></a>
    					<%if(j+1 < attach_vt_size){%><br><%}%>
    			    <%	}%>		
        		<%}else{%>		
        		<a href="javascript:scan_reg()"><img src=/acar/images/center/button_in_reg.gif border=0 align=absmiddle></a>
        		<%}%>
                    </td>
                </tr>											
            </table>
        </td>
    </tr>
    <tr>
        <td class=h></td>
    </tr>
    <tr> 
        <td colspan="2"><img src=../images/center/icon_arrow.gif align=absmiddle> <span class=style2>�����û�� ���񼭷�</span></td>
    </tr>
    <tr>
        <td colspan=2 class=line2></td>
    </tr>
    <tr> 
        <td class=line colspan="2"> 
            <table border="0" cellspacing="1" width=100%>
                <tr> 
                    <td class=title width=10%>�����û��<br>�غ񼭷�</td>
                    <td colspan=3 width=90%>&nbsp; 
                      <textarea name="docs" cols="152" rows="2"><%=bl.getDocs()%></textarea>
                    </td>
                </tr>
            </table>
        </td>
    </tr>
<%	Vector rtns = abl_db.getBankRtn(lend_id);
	int rtn_size = rtns.size();%>
	<tr>
	    <td class=h></td>
	</tr>	
    <tr> 
        <td width="740"><img src=../images/center/icon_arrow.gif align=absmiddle> <span class=style2>��ȯ����</span></td>
        <td id="td_add" width="60" align="right" style='display:none'> 
            <input type="button" name="rtn_add" value="�߰�" onClick="javascript:rtn_display3();" title="��ȯ������ ������ ���, ��ȯ�� �߰��Ͻ� �� �ֽ��ϴ�.">
        </td>
    </tr>
    <tr>
        <td class=line2></td>
    </tr>
<%	for(int i = 0 ; i < rtn_size ; i++){
		BankRtnBean rtn = (BankRtnBean)rtns.elementAt(i);
		int rtn_scd_size = Integer.parseInt(abl_db.getRtnScdYn(lend_id, rtn.getSeq()));
		
		long rtn_cont_amt = rtn.getRtn_cont_amt();
		
		Hashtable ven = new Hashtable();
		if(!rtn.getVen_code().equals("")){
			ven = neoe_db.getVendorCase(rtn.getVen_code());
		}
		
%>
	
    <tr id='tr_rtn_<%=i+1%>' style="display:<%if(!rtn.getSeq().equals("")) {%>''<% } else {%>none<%}%>"> 
        <input type='hidden' name='rtn_seq<%=i%>' value='<%=rtn.getSeq()%>'>
	    <input type='hidden' name='ven_value<%=i%>' value=''>
	    <input type='hidden' name='firm_value<%=i%>' value=''>
        <td class=line colspan="2"> 
            <table border="0" cellspacing="1" width=100%>
                <tr> 
                    <td class=title>����ݾ�</td>
                    <td>&nbsp; 
                      <%if(bl.getRtn_st().equals("1") && rtn.getRtn_move_st().equals("0")){%>
                      - 
                      <input type="text" name="rtn_cont_amt<%=i%>" value="<%=AddUtil.parseDecimalLong(rtn_cont_amt)%>" size="15"  class=num onBlur='javascript:this.value=parseDecimal(this.value)'>
                      �� 
                      <%}else{%>
                      <input type="text" name="rtn_cont_amt<%=i%>" value="<%=AddUtil.parseDecimalLong(rtn.getRtn_cont_amt())%>" size="15"  class=num onBlur='javascript:this.value=parseDecimal(this.value)'>
                      �� 
                      <%}%>
                    </td>
                    <td class=title>����Ⱓ</td>
                    <td colspan="3">&nbsp; 
                      <input type="text" name="loan_start_dt<%=i%>" value="<%=rtn.getLoan_start_dt()%>" size="11" class=text onBlur='javascript:this.value=ChangeDate(this.value)'>
                      ~ 
                      <input type="text" name="loan_end_dt<%=i%>" value="<%=rtn.getLoan_end_dt()%>" size="11" class=text onBlur='javascript:this.value=ChangeDate(this.value)'>
                    </td>
                    <td class=title>���࿩��</td>
                    <td>&nbsp; 
                      <select name='rtn_move_st<%=i%>'>
                        <option value="0" <%if(rtn.getRtn_move_st().equals("0"))%>selected<%%>>����</option>
                        <option value="1" <%if(rtn.getRtn_move_st().equals("1"))%>selected<%%>>�Ϸ�</option>
                      </select>
                    </td>
                </tr>
                <tr> 
                    <td class=title width=10%>��ȯ�ѱݾ�</td>
                    <td width=15%>&nbsp;                       
                      <%if(bl.getRtn_st().equals("1") && rtn.getRtn_move_st().equals("0")){%>
                      <input type="text" name="rtn_tot_amt<%=i%>" value="<%=AddUtil.parseDecimalLong(rtn_cont_amt)%>" size="15"  class=num onBlur='javascript:this.value=parseDecimal(this.value)'>
                      �� 
                      <%}else{%>
                      <input type="text" name="rtn_tot_amt<%=i%>" value="<%=AddUtil.parseDecimalLong(rtn.getRtn_tot_amt())%>" size="15"  class=num onBlur='javascript:this.value=parseDecimal(this.value)'>
                      �� 
                      <%}%>
                    </td>
                    <td class=title width=10%>����ȯ�ݾ�</td>
                    <td width=15%>&nbsp; 
                      <input type="text" name="alt_amt<%=i%>" value="<%=AddUtil.parseDecimal(rtn.getAlt_amt())%>" size="12" class=num onBlur='javascript:this.value=parseDecimal(this.value)'>
                      ��</td>
                    <td class=title width=10%>��ȯ������</td>
                    <td width=15%>&nbsp; 
                      <input type="text" name="cont_start_dt<%=i%>" maxlength='11' value="<%=rtn.getCont_start_dt()%>" size="11" class=text  onBlur='javascript:this.value=ChangeDate(this.value)'>
                    </td>
                    <td class=title width=10%>��ȯ������</td>
                    <td width=15%>&nbsp; 
                      <input type="text" name="cont_end_dt<%=i%>" maxlength='11' value="<%=rtn.getCont_end_dt()%>" size="11" class=text  onBlur='javascript:this.value=ChangeDate(this.value)'>
                    </td>
                </tr>
                <tr> 
                    <td class=title>��ȯ����</td>
                    <td>&nbsp; 
                      <input type="text" name="cont_term<%=i%>" value="<%=rtn.getCont_term()%>" maxlength='4' size="4" class=text>
                      ����</td>
                    <td class=title>��ȯ������</td>
                    <td>&nbsp; 
                      <select name='rtn_est_dt<%=i%>'>
                        <%	for(int j=1; j<=31 ; j++){ //1~31�� %>
                        <option value='<%=j%>' <%if(rtn.getRtn_est_dt().equals(String.valueOf(j))){%>selected<%}%>><%=j%>��</option>
                        <% } %>
                        <option value='99' <%if(rtn.getRtn_est_dt().equals("99")){%>selected<%}%>>����</option>
                      </select>
                    </td>
                    <td class='title'>��ȯ����</td>
                    <td>&nbsp; 
                      <select name='rtn_cdt<%=i%>'>
                        <option value='1' <%if(rtn.getRtn_cdt().equals("1")){%>selected<%}%>>�����ݱյ�</option>
                        <option value='2' <%if(rtn.getRtn_cdt().equals("2")){%>selected<%}%>>���ݱյ�</option>
                      </select>
                    </td>
                    <td class='title'>��ȯ���</td>
                    <td>&nbsp; 
                      <select name='rtn_way<%=i%>'>
                        <option value='1' <%if(rtn.getRtn_way().equals("1")){%>selected<%}%>>�ڵ���ü</option>
                        <option value='2' <%if(rtn.getRtn_way().equals("2")){%>selected<%}%>>����</option>
                        <option value='3' <%if(rtn.getRtn_way().equals("3")){%>selected<%}%>>��Ÿ</option>
                      </select>
                    </td>
                </tr>
                <tr> 
                    <td class=title>1�� �Ͻû�ȯ��</td>
                    <td>&nbsp; 
                      <input type="text" name="rtn_one_amt<%=i%>" value="<%=AddUtil.parseDecimal(rtn.getRtn_one_amt())%>" size="12" maxlength='12' class=num  onBlur="javascript:this.value=parseDecimal(this.value); set_cont_amt('<%=i%>');">
                      �� </td>
                    <td class=title>1�� �Ͻû�ȯ��</td>
                    <td>&nbsp; 
                      <input type="text" name="rtn_one_dt<%=i%>" maxlength='11' value="<%=rtn.getRtn_one_dt()%>" size="11" class=text  onBlur='javascript:this.value=ChangeDate(this.value)'>
                    </td>
                    <td class='title' style='height:40'>2�� ������<br>��ȯ</td>
                    <td colspan="3">&nbsp; 
                      <input type="text" name="rtn_two_amt<%=i%>" value="<%=AddUtil.parseDecimal(rtn.getRtn_two_amt())%>" size="11" maxlength='12' class=num  onBlur='javascript:this.value=parseDecimal(this.value)'>
                      �� </td>
                </tr>
                <tr> 
                    <td class=title>���¹�ȣ</td>
                    <td colspan="3">&nbsp; 
                      <input name="deposit_no<%=i%>" type="text" class=text id="deposit_no" value="<%=rtn.getDeposit_no()%>" size="20" ></td>
                    <td class='title'>�׿����ŷ�ó</td>
                    <td colspan="3">&nbsp;
                      <input type='text' name='ven_name<%=i%>' size='30' value='<%=ven.get("VEN_NAME")==null?"":ven.get("VEN_NAME")%>' class='text' onKeyDown='javascript:enter()' style='IME-MODE: active'>
        			  &nbsp;&nbsp;<a href='javascript:ven_search(<%=i%>)' onMouseOver="window.status=''; return true"><img src=../images/center/button_in_search1.gif align=absmiddle border=0></a> 
        			  <input type='hidden' name='ven_code<%=i%>' size='10' value='<%=rtn.getVen_code()%>' class='text'></td>
                </tr>
                <tr> 
                    <td class=title>�ߵ���ȯ����</td>
                    <td colspan="4">&nbsp; 
                      <textarea name="cls_rtn_condi<%=i%>" cols="82" rows="3"><%=rtn.getCls_rtn_condi()%></textarea>
                    </td>
                    <td colspan="2" align="center"> 
                      <%if(bl.getRtn_st().equals("1")){//����
        			  		if(rtn_scd_size > 0 && rtn.getRtn_move_st().equals("1")){%>
                      <a href ="javascript:scd_view('u','<%=i%>','<%=rtn.getSeq()%>','<%=rtn.getCont_term()%>');"><img src=../images/center/button_in_sch.gif align=absmiddle border=0></a> 
                      <%	}else if(rtn_scd_size == 0 && rtn.getRtn_move_st().equals("1")){%>
                      <input type="button" name="rtn_sch_mk<%=i%>" value="��ȯ������ ���" onClick="javascript:scd_view('i','<%=i%>','<%=rtn.getSeq()%>','<%=rtn.getCont_term()%>');">
                      <%	}
        			  	}else if(bl.getRtn_st().equals("2")){//����
        					if(rtn_scd_size > 0){%>
                      <a href ="javascript:scd_view('u','<%=i%>','<%=rtn.getSeq()%>','<%=rtn.getCont_term()%>');"><img src=../images/center/button_in_sch.gif align=absmiddle border=0></a>	
                      <%	}else if(rtn_scd_size == 0){%>
                      <input type="button" name="rtn_sch_mk<%=i%>" value="��ȯ������ ���" onClick="javascript:scd_view('i','<%=i%>','<%=rtn.getSeq()%>','<%=rtn.getCont_term()%>');">
                      <%	}
        			  	}else{}%>
                    </td>
                    <td align="center"> 					  
                      <%if(bl.getRtn_st().equals("1")){//����
        			  		if(rtn_scd_size > 0 && rtn.getRtn_move_st().equals("1")){%>
                      <a href="javascript:view_cls('<%=rtn.getCls_yn()%>','<%=rtn.getSeq()%>');"><img src=../images/center/button_in_jdsh.gif align=absmiddle border=0></a>
                      <%	}
        			  	}else if(bl.getRtn_st().equals("2")){//����
        					if(rtn_scd_size > 0){%>
                      <a href="javascript:view_cls('<%=rtn.getCls_yn()%>','<%=rtn.getSeq()%>');"><img src=../images/center/button_in_jdsh.gif align=absmiddle border=0></a>
                      <%	}
        			  	}else{}%>
					  <%if(cls_vt_size>0){//�ߵ���ȯ �̷�%>	
					  &nbsp; &nbsp; &nbsp;<a href="javascript:view_cls_list('<%=rtn.getCls_yn()%>','<%=rtn.getSeq()%>');" title='�ߵ���ȯ �̷� ����'><img src=../images/center/button_in_see.gif align=absmiddle border=0></a>
					  <%}%>
                    </td>
                </tr>
            </table>
        </td>
    </tr>
    <tr></tr><tr></tr>
    <%}%>
    <input type='hidden' name='rtn_size' value='<%=rtn_size%>'>
	<input type='hidden' name='su' value='<%=rtn_size%>'>
    <%for(int i=rtn_size; i<5; i++){%>
    <tr id='tr_rtn_<%=i+1%>' style='display:none'> 
        <input type='hidden' name='rtn_seq<%=i%>' value='<%=i+1%>'>
	    <input type='hidden' name='ven_value<%=i%>' value=''>
	    <input type='hidden' name='firm_value<%=i%>' value=''>	  
        <td class=line colspan="2"> 
            <table border="0" cellspacing="1" width=100%>
                <tr> 
                    <td class=title>����ݾ�</td>
                    <td>&nbsp; 
                      <input type="text" name="rtn_cont_amt<%=i%>"  value="0" size="12" class=num onBlur='javascript:this.value=parseDecimal(this.value)'>
                      ��</td>
                    <td>����Ⱓ</td>
                    <td colspan="3">&nbsp; 
                      <input type="text" name="loan_start_dt<%=i%>" value="" size="11" class=text onBlur='javascript:this.value=ChangeDate(this.value)'>
                      ~ 
                      <input type="text" name="loan_end_dt<%=i%>" value="" size="11" class=text onBlur='javascript:this.value=ChangeDate(this.value)'>
                    </td>
                    <td class=title>���࿩��</td>
                    <td>&nbsp; 
                      <select name='rtn_move_st<%=i%>'>
                        <option value="0" selected>����</option>
                        <option value="1">�Ϸ�</option>
                      </select>
                    </td>
                </tr>
                <tr> 
                    <td class=title width=10%>��ȯ�ѱݾ�</td>
                    <td width=15%>&nbsp; 
                      <input type="text" name="rtn_tot_amt<%=i%>" value="" size="12"  class=num onBlur='javascript:this.value=parseDecimal(this.value)'>
                      ��</td>
                    <td class=title width=10%>����ȯ�ݾ�</td>
                    <td width=15%>&nbsp; 
                      <input type="text" name="alt_amt<%=i%>" value="" size="12" maxlength='12' class=num onBlur='javascript:this.value=parseDecimal(this.value)'>
                      ��</td>
                    <td class=title width=10%>��ȯ������</td>
                    <td width=15%>&nbsp; 
                      <input type="text" name="cont_start_dt<%=i%>" maxlength='11' value="" size="11" class=text  onBlur='javascript:this.value=ChangeDate(this.value)'>
                    </td>
                    <td class=title width=10%>��ȯ������</td>
                    <td width=15%>&nbsp; 
                      <input type="text" name="cont_end_dt<%=i%>" maxlength='11' value="" size="11" class=text  onBlur='javascript:this.value=ChangeDate(this.value)'>
                    </td>
                </tr>
                <tr> 
                    <td class=title>��ȯ����</td>
                    <td>&nbsp; 
                      <input type="text" name="cont_term<%=i%>" value="" maxlength='4' size="4" class=text>
                      ����</td>
                    <td class=title>��ȯ������</td>
                    <td>&nbsp; 
                      <select name='rtn_est_dt<%=i%>'>
                        <%	for(int j=1; j<=31 ; j++){ //1~31�� %>
                        <option value='<%=j%>'><%=j%>�� </option>
                        <% } %>
                        <option value='99'> ���� </option>
                      </select>
                    </td>
                    <td class='title'>��ȯ����</td>
                    <td>&nbsp; 
                      <select name='rtn_cdt<%=i%>'>
                        <option value='1'>�����ݱյ�</option>
                        <option value='2'>���ݱյ�</option>
                      </select>
                    </td>
                    <td class='title'>��ȯ���</td>
                    <td>&nbsp; 
                      <select name='rtn_way<%=i%>'>
                        <option value='1'>�ڵ���ü</option>
                        <option value='2'>����</option>
                        <option value='3'>��Ÿ</option>
                      </select>
                    </td>
                </tr>
                <tr> 
                    <td class=title>1�� �Ͻû�ȯ��</td>
                    <td>&nbsp; 
                      <input type="text" name="rtn_one_amt<%=i%>" value="" size="12"  class=num  onBlur='javascript:this.value=parseDecimal(this.value)'>
                      �� </td>
                    <td class=title>1�� �Ͻû�ȯ��</td>
                    <td>&nbsp; 
                      <input type="text" name="rtn_one_dt<%=i%>" maxlength='11' value="" size="11" class=text  onBlur='javascript:this.value=ChangeDate(this.value)'>
                    </td>
                    <td class='title' style='height:40'>2�� ������<br>��ȯ</td>
                    <td colspan="3">&nbsp; 
                      <input type="text" name="rtn_two_amt<%=i%>" value="" size="12"  class=num  onBlur='javascript:this.value=parseDecimal(this.value)'>
                      �� </td>
                </tr>
                <tr> 
                    <td class=title>���¹�ȣ</td>
                    <td colspan="3">&nbsp; 
                      <input name="deposit_no<%=i%>" type="text" class=text id="deposit_no" value="" size="20" ></td>
                    <td class='title'>�׿����ŷ�ó</td>
                    <td colspan="3">&nbsp;
                      <input type='text' name='ven_name<%=i%>' size='30' value='<%//=ven.get("VEN_NAME")==null?"":ven.get("VEN_NAME")%>' class='text' onKeyDown='javascript:enter()' style='IME-MODE: active'>
        			  &nbsp;&nbsp;<a href='javascript:ven_search(<%=i%>)' onMouseOver="window.status=''; return true">�˻�</a> 
        			  <input type='hidden' name='ven_code<%=i%>' size='10' value='<%//=rtn.getVen_code()%>' class='text'></td>
                </tr>		  
                <tr> 
                    <td class=title>�ߵ���ȯ����</td>
                    <td colspan="7">&nbsp; 
                      <textarea name="cls_rtn_condi<%=i%>" cols="90" rows="2"></textarea>
                    </td>
                </tr>
            </table>
        </td>
    </tr>
    <%}%>
    <tr>
        <td class=h></td>
    </tr>
    <tr> 
        <td colspan="2"><img src=../images/center/icon_arrow.gif align=absmiddle> <span class=style2>�Һ� �ڵ���ǥ ����</span></td>
    </tr>
<input type='hidden' name='bank_code2' value='<%=bl.getBank_code()%>'>
<input type='hidden' name='deposit_no2' value='<%=bl.getDeposit_no_d()%>'>
<input type='hidden' name='bank_name' value=''>
    <tr>
        <td colspan=2 class=line2></td>
    </tr>
    <tr> 
        <td class='line' colspan="2"> 
            <table border="0" cellspacing="1" cellpadding="0" width=100%>
                <tr> 
        		    <td class=title width=10%>�ڵ���ǥ</td>
        			<td width=40%>&nbsp;
        			  <input type="checkbox" name="autodoc_yn" value="Y" <%if(bl.getAutodoc_yn().equals("Y")){%>checked<%}%>></td>
                    <td class=title width=10%>��������</td>
                    <td width=40%>&nbsp;
                      <input type="radio" name="acct_code" value="26000" <%if(bl.getAcct_code().equals("26000"))%>checked<%%>>
        				�ܱ����Ա�
        			  <input type="radio" name="acct_code" value="29300" <%if(bl.getAcct_code().equals("26400")||bl.getAcct_code().equals("29300"))%>checked<%%>>
        				������Ա�</td>
                </tr>
                <tr> 
                    <td class=title>����</td>
                    <td rowspan='2'>&nbsp; 
                      <select name='bank_code' onChange='javascript:change_bank()'>
                        <option value=''>����</option>
                        <%if(a_bank_size > 0){
        						for(int i = 0 ; i < a_bank_size ; i++){
        							CodeBean a_bank = a_banks[i];	%>
                        <option value='<%= a_bank.getCode()%><%= a_bank.getNm()%>' <%if(bl.getBank_code().equals(a_bank.getCode()))%>selected<%%>> <%= a_bank.getNm()%> 
                        </option>
                        <%	}
        					}	%>
                      </select>
                    </td>
                    <td class=title>��� ���¹�ȣ</td>
                    <td>&nbsp; 
                      <select name='deposit_no_d'>
                        <option value=''>���¸� �����ϼ���</option>
        				<%if(!bl.getBank_code().equals("")){
        						Vector deposits = neoe_db.getDepositList(bl.getBank_code());
        						int deposit_size = deposits.size();
        						for(int i = 0 ; i < deposit_size ; i++){
        							Hashtable deposit = (Hashtable)deposits.elementAt(i);%>
        				<option value='<%=deposit.get("DEPOSIT_NO")%>' <%if(bl.getDeposit_no_d().equals(String.valueOf(deposit.get("DEPOSIT_NO"))))%>selected<%%>><%= deposit.get("DEPOSIT_NO")%>:<%= deposit.get("DEPOSIT_NAME")%></option>
        				<%		}
        				}%>
                      </select>
                      (�ڵ���ü)
                    </td>
                </tr>
            </table>
        </td>
    </tr>
    <tr> 
        <td colspan="2"><img src=../images/center/icon_arrow.gif align=absmiddle> <span class=style2>�Һλ�ȯ��� ������ü�� ���</span></td>
    </tr>              
    <tr>
        <td colspan=2 class=line2></td>
    </tr>
    <tr> 
        <td class='line' colspan="2"> 
            <table border="0" cellspacing="1" cellpadding="0" width=100%>                
                <tr>
            		<td class=title width=10%>�Աݰ���</td>
            		<td >&nbsp;
              			<select name='ps_bank_id'>
                			<option value=''>����</option>
                			<%	for(int i = 0 ; i < p_bank_size ; i++){
									Hashtable bank_ht = (Hashtable)p_bank_vt.elementAt(i);
							%>
                			<option value='<%= bank_ht.get("BANK_ID")%>' <%if(String.valueOf(bank_ht.get("BANK_ID")).equals(bl.getP_bank_id())||String.valueOf(bank_ht.get("NM")).equals(bl.getP_bank_nm()))	%>selected<%%>><%= bank_ht.get("NM")%></option>
                			<%	}%>
              			</select>
            			<input type='text' name='p_bank_no' size='33' value='<%=bl.getP_bank_no()%>' class='default' >							
						<input type='hidden' name='p_bank_id' 	value='<%=bl.getP_bank_id()%>'>
						<input type='hidden' name='p_bank_nm' 	value='<%=bl.getP_bank_nm()%>'>
            			(����ó ����, <font color="#FF0000">������ü�� ��</font>) 
            		</td>
          		</tr>                
            </table>
        </td>
    </tr>
    	
    <tr>
        <td class=h></td>
    </tr>
    <tr> 
        <td colspan="2"><img src=../images/center/icon_arrow.gif align=absmiddle> <span class=style2>�ڱݰ���</span></td>
    </tr> 
    <tr> 
        <td colspan="2" class=line2></td>
    </tr>
    <tr> 
        <td class=line colspan="2"> 
            <table border=0 cellspacing=1 width=100%>
                <tr> 
                    <td class=title width=10%>������ȣ</td>
                    <td>&nbsp;
        			<%if(bl.getFund_id().equals("")){%>
        			<a href="javascript:search_fund_bank()">[�ڱݰ�������]</a>
        			<%}else{
        				WorkingFundBean wf = abl_db.getWorkingFundBean(bl.getFund_id());%>
        			<%=wf.getFund_no()%>
        			<%}%>			
        			</td>
                    
                </tr>
            </table>
        </td>
    </tr>       
    
    <tr> 
        <td colspan="2">&nbsp;</td>
    </tr>
    <tr> 
        <td colspan="2" class=line2></td>
    </tr>
    <tr> 
        <td class=line colspan="2"> 
            <table border=0 cellspacing=1 width=100%>
                <tr> 
                    <td class=title width=10%>�����ݾ�</td>
                    <td width=15%>
        			<%if(bl.getCont_bn().equals("0016") && bl.getCont_amt() == 0){%>
        			<input type="text" name="pm_amt" value="<%=AddUtil.parseDecimalLong(bl.getLend_a_amt())%>" size="12" class=whitenum>��
        			<%}else{%>
        			<input type="text" name="pm_amt" value="<%=AddUtil.parseDecimalLong(bl.getCont_amt())%>" size="12" class=whitenum>��			
        			<%}%>			
        			</td>
                    <td class=title width=10%>������αݾ�</td>
                    <td width=15%><input type="text" name="lend_a_amt" value="<%=AddUtil.parseDecimalLong(bl.getLend_a_amt())%>" size="12" class=whitenum>��</td>
                    <td class=title width=10%>�����ܾ�</td>
                    <td width=40%>
        			<%if(bl.getCont_bn().equals("0016") && bl.getCont_amt() == 0){%>			
        					<input type="text" name="pm_rest_amt" value="0" size="12" class=whitenum>��			
        			<%}else{%>
        				<%if(bl.getRtn_change().equals("1")){%>
        					<input type="text" name="pm_rest_amt" value="<%=AddUtil.parseDecimal(bl.getPm_rest_amt()+bl.getAlt_pay_amt())%>" size="12" class=whitenum>��
        				<%}else{%>
        					<input type="text" name="pm_rest_amt" value="<%=AddUtil.parseDecimal(bl.getPm_rest_amt())%>" size="12" class=whitenum>��
        				<%}%>	
        			<%}%>						
        			</td>		
                </tr>
            </table>
        </td>
    </tr>
    <tr> 
        <td colspan="2">&nbsp;</td>
    </tr>
    <tr> 
        <td colspan="2"> 
            <table border="0" cellspacing="1" width=100%>
                <tr> 
                    <td>
        			<a href="javascript:mapping_list()"><img src=../images/center/button_list_bank.gif align=absmiddle border=0></a>&nbsp;&nbsp;
        		    <%if( auth_rw.equals("4") || auth_rw.equals("6")) {%>	
        			<a href="javascript:mapping_reg()"><img src=../images/center/button_reg_dc.gif align=absmiddle border=0></a> 
        		    <% } %>	
                    </td>
                    <td align='right' width="150"></td>
                </tr>
            </table>
        </td>
    </tr>
    <tr> 
        <td colspan="2">&nbsp;</td>
    </tr>    
    <tr> 
        <td colspan="2"><img src=/acar/images/center/icon_arrow.gif align=absmiddle> <span class=style2>������ ��ĵ����</span>
            &nbsp;&nbsp;&nbsp;&nbsp;<%if( auth_rw.equals("4") || auth_rw.equals("6")) {%><a href="javascript:scan_reg_scd()"><img src=/acar/images/center/button_in_reg.gif border=0 align=absmiddle></a><%}%>	
        </td>
    </tr> 
    <%
    		//20160831 ACAR_ATTACH_FILE LIST---------------------------------------------------------
	
				content_code = "LEND_BANK";
				content_seq  = "scd"+lend_id;
	
				attach_vt = c_db.getAcarAttachFileList(content_code, content_seq, 0);
				attach_vt_size = attach_vt.size();
				
				if(attach_vt_size>0){
    %>  
	<tr>
	    <td class=line2></td>
	</tr>
    <tr>
        <td colspan="2" class=line>
            <table border="0" cellspacing="1" cellpadding="0" width=100%>
                <tr>
                  <td width="10%" class=title>����</td>
                  <td width="60%" class=title>��ĵ����</td>
                  <td width="20%" class=title>�������</td>
                  <td width="10%" class=title>����</td>
                </tr>    
                <%for (int j = 0 ; j < attach_vt_size ; j++){
                		Hashtable ht = (Hashtable)attach_vt.elementAt(j);
                %>
                <tr>
                    <td align="center"><%=j+1%></td>                    
                    <td align="center"><a href="javascript:openPopP('<%=ht.get("FILE_TYPE")%>','<%=ht.get("SEQ")%>');" title='����' ><%=ht.get("FILE_NAME")%></a></td>
                    <td align="center"><%=ht.get("REG_DATE")%></td>
                    <td align="center"><%if( auth_rw.equals("4") || auth_rw.equals("6")) {%><a href="https://fms3.amazoncar.co.kr/fms2/attach/delete.jsp?SEQ=<%=ht.get("SEQ")%>" target='_blank'><img src="/acar/images/center/button_in_delete.gif" align="absmiddle" border="0"></a><%}%></td>
                </tr>
                <%}%>
            </table>
        </td>
    </tr>                
    <%	}%>     
</table>
</form>
<script language='javascript'>
<!--
	add_display();
//-->
</script>
<iframe src="about:blank" name="i_no" width="0" height="0" frameborder="0" noresize>
</iframe>
</body>
</html>