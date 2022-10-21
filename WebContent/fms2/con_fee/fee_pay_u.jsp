<%@ page language="java" contentType="text/html;charset=euc-kr"%>
<%@ page import="java.util.*, acar.util.*, acar.cont.*, acar.fee.*, acar.bill_mng.*, acar.common.*"%>
<jsp:useBean id="af_db" scope="page" class="acar.fee.AddFeeDatabase"/>
<%@ include file="/acar/cookies.jsp" %>

<html>
<head><title>FMS</title>
<script language='JavaScript' src='../../include/common.js'></script>
<script language='javascript'>
<!--
	function save()
	{
		var fm = document.form1;
		if( !isDate(fm.t_rc_dt.value) || (fm.t_rc_dt.value == '') || (fm.t_rc_amt.value == '') || (parseDigit(fm.t_rc_amt.value) == '0') || (parseDigit(fm.t_rc_amt.value).length > 8))
		{
			alert('�Աݿ����ϰ� �Աݾ��� Ȯ���Ͻʽÿ�');
			return;
		}
		if(toInt(parseDigit(fm.t_fee_amt.value))<toInt(parseDigit(fm.t_rc_amt.value)))
		{
			alert('�Աݾ��� Ȯ���ϼ���');
			return;
		}
		if(fm.autodoc.checked == true){
			if(fm.ven_code.value == ""){ alert("�ŷ�ó���� ���� �ʽ��ϴ�.\n\nFMS �ŷ�ó������ �ŷ�ó��� \n�׿����� �ŷ�ó���� ������ Ȯ���Ͻʽÿ�."); return; }
			//�ŷ�ó
			//var ven_code = fm.ven_code.options[fm.ven_code.selectedIndex].value;
			//var ven_code_split = ven_code.split("#");
			//fm.ven_code2.value = ven_code_split[0];
			//fm.firm_nm.value = ven_code_split[1];
			//���¹�ȣ		
			var deposit_no = fm.deposit_no.options[fm.deposit_no.selectedIndex].value;
			var deposit_split = deposit_no.split(":");
			fm.deposit_no2.value = deposit_split[0];			

			if(fm.ven_name.value == ""){ alert("�ŷ�ó���� Ȯ���Ͻʽÿ�."); return; }			
			if(fm.bank_code.value == ""){ alert("������ �����Ͻʽÿ�."); return; }			
			if(fm.deposit_no.value == ""){ alert("���¹�ȣ�� �����Ͻʽÿ�."); return; }									
		}
		if(confirm('�Ա�ó���Ͻðڽ��ϱ�?'))
		{		
			fm.target = 'PAY_FEE';
			fm.target = 'i_no';
			fm.action='fee_pay_u_a.jsp'
			fm.submit();
		}
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
			fm.action='get_deposit_nodisplay.jsp?bank_code='+bank_code.substring(0,3);
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

	//��ȸ�ϱ�
	function ven_search(idx){
		var fm = document.form1;	
		window.open("/acar/con_debt/vendor_list.jsp?idx=&t_wd="+fm.ven_name.value, "VENDOR_LIST", "left=300, top=300, width=430, height=250, scrollbars=yes");		
	}
	function enter(){
		var keyValue = event.keyCode;
		if (keyValue =='13') ven_search('');
	}
	
//-->
</script>
<meta http-equiv="content-type" content="text/html; charset=euc-kr">
<link rel=stylesheet type="text/css" href="../../include/table_t.css">
</head>
<body>
<%
	String auth = request.getParameter("auth")==null?"":request.getParameter("auth");
	String auth_rw = request.getParameter("auth_rw")==null?"":request.getParameter("auth_rw");
	String user_id = request.getParameter("user_id")==null?"":request.getParameter("user_id");//�α���-ID
	String br_id = request.getParameter("br_id")==null?"":request.getParameter("br_id");//�α���-������
	String m_id = request.getParameter("m_id")==null?"":request.getParameter("m_id");
	String l_cd = request.getParameter("l_cd")==null?"":request.getParameter("l_cd");
	String r_st = request.getParameter("r_st")==null?"":request.getParameter("r_st");
	String prv_mon_yn = request.getParameter("prv_mon_yn")==null?"":request.getParameter("prv_mon_yn");//����������Ⱓ���Կ���
	String fee_tm = request.getParameter("fee_tm")==null?"":request.getParameter("fee_tm");
	String tm_st1 = request.getParameter("tm_st1")==null?"":request.getParameter("tm_st1");
	String rent_seq = request.getParameter("rent_seq")==null?"":request.getParameter("rent_seq");
	String ext_dt = request.getParameter("ext_dt")==null?"":request.getParameter("ext_dt");
	String b_dt = request.getParameter("b_dt")==null?"":request.getParameter("b_dt");
	String rent_dt = request.getParameter("rent_dt")==null?"":request.getParameter("rent_dt");
	String page_gubun = request.getParameter("page_gubun")==null?"":request.getParameter("page_gubun");
	
	FeeScdBean a_fee = af_db.getScdNew(m_id, l_cd, r_st, rent_seq, fee_tm, tm_st1);
	
	Hashtable rtn = af_db.getFeeRtnCase(m_id, l_cd, r_st, rent_seq);
	
	NeoErpUDatabase neoe_db = NeoErpUDatabase.getInstance();
	
	BillMngBean bill = neoe_db.getFeeBillCase(m_id, l_cd); //�״�� ���
	
	String firm_nm 		= bill.getFirm_nm();
	String client_id 	= bill.getClient_id();
	String ven_code 	= bill.getVen_code();
	
	if(!String.valueOf(rtn.get("FIRM_NM")).equals("") && !String.valueOf(rtn.get("FIRM_NM")).equals("null")){
		firm_nm 	= String.valueOf(rtn.get("FIRM_NM"));
		client_id 	= String.valueOf(rtn.get("CLIENT_ID"));
		ven_code 	= String.valueOf(rtn.get("VEN_CODE"));
	}
	
	//�׿���-�ŷ�ó����
	CodeBean[] vens = neoe_db.getCodeAll(firm_nm);
	int ven_size = vens.length;
	//�׿���-��������
	CodeBean[] banks = neoe_db.getCodeAll();
	int bank_size = banks.length;
%>
<form name='form1' action='/fms2/con_fee/fee_pay_u_a.jsp' method='post'>
<input type='hidden' name='auth_rw' value='<%=auth_rw%>'>
<input type='hidden' name='user_id' value='<%=user_id%>'>
<input type='hidden' name='br_id' value='<%=br_id%>'>
<input type='hidden' name='auth' value='<%=auth%>'>
<input type='hidden' name='m_id' value='<%=m_id%>'>
<input type='hidden' name='l_cd' value='<%=l_cd%>'>
<input type='hidden' name='r_st' value='<%=r_st%>'>
<input type='hidden' name='prv_mon_yn' value='<%=prv_mon_yn%>'>
<input type='hidden' name='b_dt' value='<%=b_dt%>'>
<input type='hidden' name='rent_dt' value='<%=rent_dt%>'>
<input type='hidden' name='ext_dt' value=''>
<input type='hidden' name='h_fee_tm' value='<%=fee_tm%>'>
<input type='hidden' name='h_tm_st1' value='<%=tm_st1%>'>
<input type='hidden' name='rent_seq' value='<%=rent_seq%>'>
<input type='hidden' name='h_rc_dt' value=''>
<input type='hidden' name='h_rc_amt' value=''>
<input type='hidden' name='node_code' value='<%=l_cd.substring(0,2)%>01'>
<input type='hidden' name='ven_code2' value=''>
<input type='hidden' name='firm_nm' value=''>
<input type='hidden' name='bank_code2' value=''>
<input type='hidden' name='deposit_no2' value=''>
<input type='hidden' name='bank_name' value=''>
<input type='hidden' name='page_gubun' value='<%=page_gubun%>'>
<input type='hidden' name='client_id' value='<%=client_id%>'>

<table border="0" cellspacing="0" cellpadding="0" width=100%>
    <tr> 
        <td>
            <table width=100% border=0 cellpadding=0 cellspacing=0>
                <tr>
                    <td width=7><img src=/acar/images/center/menu_bar_1.gif width=7 height=33></td>
                    <td class=bar>&nbsp;&nbsp;&nbsp;<img src=/acar/images/center/menu_bar_dot.gif width=4 height=5 align=absmiddle>&nbsp;<span class=style1><span class=style5>�뿩�� ����ó��</span></span></td>	
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
								<td width='13%' class='title'>ȸ��</td>
								<td width='20%'>&nbsp;<%=a_fee.getFee_tm()%></td>
								<td width='13%' class='title'>����</td>
								<td width='19%'>&nbsp;<input type='text' name='t_tm_st1' size='5' class='white'  value='<%if(a_fee.getTm_st1().equals("0")){%>�뿩��<%}else{%>�ܾ�<%}%>' ></td>
								<td width='15%' class='title'>�Աݿ�����</td>
								<td width='20%'>&nbsp;<%=a_fee.getFee_est_dt()%></td>
							</tr>
							<tr>
								<td class='title'>���ް�</td>
								<td>&nbsp;<%=Util.parseDecimal(a_fee.getFee_s_amt())%>��</td>
								<td class='title'>�ΰ���</td>
								<td>&nbsp;<%=Util.parseDecimal(a_fee.getFee_v_amt())%>��</td>
								<td class='title'>���뿩��</td>
								<td>&nbsp;<input type='text' name='t_fee_amt' size='10' value='<%=Util.parseDecimal(a_fee.getFee_s_amt()+a_fee.getFee_v_amt())%>' class='whitenum' readonly>��</td>
							</tr>
							<tr>
								<td class='title'>��ü�ϼ�</td>
								<td>&nbsp;<%=a_fee.getDly_days()%>��</td>
								<td class='title'>��ü��</td>
								<td colspan='3'>&nbsp;&nbsp;<%=Util.parseDecimal(a_fee.getDly_fee())%>��</td>
							</tr>
						</table>
					</td>
				</tr>
				<tr>
				</tr>
				<tr>
					<td class='line'>
						<table border="0" cellspacing="1" cellpadding="0" width=100%>
							<tr>
								<td width='13%' class='title'>�Ա�����</td>
								<td width='20%'>&nbsp;<input type='text' name='t_rc_dt' size='12' value='<%=Util.getDate()%>' class='text' onBlur='javascript:this.value=ChangeDate(this.value);'></td>
								<td width='13%' class='title'>���Աݾ�</td>
								<td>&nbsp;<input type='text' name='t_rc_amt' size='10' maxlength='10' value='<%=Util.parseDecimal(a_fee.getFee_s_amt()+a_fee.getFee_v_amt())%>' class='num' onBlur='javascript:this.value=parseDecimal(this.value)'>��&nbsp;</td>
							</tr>
						</table>
					</td>
				</tr>
				<tr>
					<td>&nbsp;</td>
				</tr>
				<tr>
                    <td class=line2></td>
                </tr>
				<tr>
					<td class='line'>						
                        <table border="0" cellspacing="1" cellpadding="0" width=100%>
                            <tr> 
                                <td class='title' align="center" rowspan="7" width=13%>N<br>
                                    E<br>
                                    O<br>
                                    |<br>
                                    M</td>
                                <td width='20%' class='title'>�ڵ���ǥ</td>
                                <td> 
                                    &nbsp;<input type="checkbox" name="autodoc" value="Y" >
                                </td>
                            </tr>
                            <tr> 
                                <td class='title'>�ŷ�ó</td>
                                <td>&nbsp;<%	Hashtable ven = neoe_db.getVendorCase(ven_code);%>
                				    <input type='text' name='ven_code' size='5' value='<%=ven_code%>' class='whitetext'>
                					<input type='text' name='ven_name' size='30' value='<%=ven.get("VEN_NAME")==null?"":ven.get("VEN_NAME")%>' class='text' onKeyDown='javascript:enter()' style='IME-MODE: active'>
                			        &nbsp;<a href="javascript:ven_search('')" onMouseOver="window.status=''; return true"><img src=/acar/images/center/button_in_search1.gif align=absmiddle border="0"></a> 
                			        
                					<!--
                                    <select name='ven_code'>
                                      <%//if(ven_size > 0){
                						//	for(int i = 0 ; i < ven_size ; i++){
                						//		CodeBean ven = vens[i];	%>
                                      <option value='<%//= ven.getCode()%>#<%//= ven.getNm()%>'>(<%//= ven.getCode()%>)<%//= ven.getNm()%></option>
                                      <%//	}
                					//}	%>
                                    </select>
                					-->
                                </td>
                            </tr>
                            <tr> 
                                <td class='title'>�߻�����</td>
                                <td> 
                                    &nbsp; <input type='text' name='acct_dt' size='12' value='<%=Util.getDate()%>' class='text' onBlur='javascript:this.value=ChangeDate(this.value);'>
                                </td>
                            </tr>
                            <tr> 
                                <td class='title'>��������</td>
                                <td> 
                                    &nbsp; <input type="radio" name="acct_code" value="10800" checked>
                                    �ܻ����� 
                                    <input type="radio" name="acct_code" value="25900">
                                    ������</td>
                            </tr>
                            <tr> 
                                <td class='title'>����</td>
                                <td> 
                                    &nbsp; <select name='bank_code' onChange='javascript:change_bank()'>
                                      <option value=''>����</option>
                                      <%if(bank_size > 0){
                						for(int i = 0 ; i < bank_size ; i++){
                							CodeBean bank = banks[i];	%>
                                      <option value='<%= bank.getCode()%><%= bank.getNm()%>' <%if(bill.getFee_bank().equals(bank.getCode())){%> selected <%}%>> 
                                      <%= bank.getNm()%> </option>
                                      <%	}
                					}	%>
                                    </select>
                                </td>
                            </tr>
                            <tr> 
                                <td class='title'>���¹�ȣ</td>
                                <td> 
                                    &nbsp; <select name='deposit_no'>
                                        <option value=''>���¸� �����ϼ���</option>
                                    </select>
                                </td>
                            </tr>
                            <tr> 
                                <td class='title'>����</td>
                                <td> 
                                    &nbsp; <textarea name="acct_cont" cols="45" class="text" rows="2">�뿩��(<%=a_fee.getFee_tm()%>ȸ��)<%=bill.getCar_no()%>(<%=firm_nm%>)</textarea>
                                </td>
                            </tr>
                        </table>
					</td>
				</tr>
			</table>
		</td>
	</tr>
	<tr>
		<td align='right'><a href="javascript:save()"><img src=/acar/images/center/button_igcl.gif align=absmiddle border="0"></a></td>
	</tr>
</table>
</form>
<iframe src="about:blank" name="i_no" width="0" height="0" frameborder="0" noresize></iframe>
</body>
</html>