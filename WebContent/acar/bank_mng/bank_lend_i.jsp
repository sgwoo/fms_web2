<%@ page language="java" contentType="text/html;charset=euc-kr" %>
<%@ page import="java.util.*,acar.util.*,acar.common.*,acar.cont.*, acar.bank_mng.*"%>
<jsp:useBean id="abl_db" scope="page" class="acar.bank_mng.AddBankLendDatabase"/>
<%@ include file="/acar/cookies.jsp" %>

<%
	String auth_rw = request.getParameter("auth_rw")==null?"":request.getParameter("auth_rw"); //����
	String user_id = request.getParameter("user_id")==null?"":request.getParameter("user_id");//�α���-ID
	String br_id = request.getParameter("br_id")==null?"":request.getParameter("br_id");//�α���-������
	
	//height
	int sh_height = request.getParameter("sh_height")==null?0:Util.parseInt(request.getParameter("sh_height"));//��ܱ���
	
	String bank_id = request.getParameter("bank_id")==null?"":request.getParameter("bank_id");
	String gubun1 = request.getParameter("gubun1")==null?"":request.getParameter("gubun1");
	
	String lend_id = request.getParameter("lend_id")==null?"":request.getParameter("lend_id");
	String fund_id = request.getParameter("fund_id")==null?"":request.getParameter("fund_id");
	String seq 	= request.getParameter("seq")==null?"1":request.getParameter("seq");
	
	CommonDataBase c_db = CommonDataBase.getInstance();
	
	CodeBean[] banks = c_db.getBankList("1"); /* �ڵ� ����:��1������ */
	int bank_size = banks.length;
	
	CodeBean[] banks2 = c_db.getBankList("2"); /* �ڵ� ����:��2������ */
	int bank_size2 = banks2.length;
	
	Vector branches = c_db.getBranchList();	/* ������ ��ȸ */
	int brch_size = branches.size();
	
	//��� ����� ����Ʈ
	Vector users = c_db.getUserList("", "", "EMP");
	int user_size = users.size();
	
	//�α��� ���������
	LoginBean login = LoginBean.getInstance();
	if(user_id.equals("")) user_id = login.getCookieValue(request, "acar_id");
	
	//�ڱݰ���
	WorkingFundBean wf = abl_db.getWorkingFundBean(fund_id);

	Vector lends = abl_db.getWorkingFundLendBankList(fund_id);
	int lend_size = lends.size();
	Hashtable wfi_ht = new Hashtable();
	for(int i = 0 ; i < lend_size ; i++){
		Hashtable ht = (Hashtable)lends.elementAt(i);
		if((i+1)==lend_size){
			wfi_ht = ht;
		}
	}	
	
	if(ck_acar_id.equals("000029")){
		out.println("fund_id="+fund_id);
	}	
%>

<html>
<head>
<title>FMS</title>
<link rel="stylesheet" type="text/css" href="/include/table_t.css">
<meta http-equiv="Content-Type" content="text/html; charset=euc-kr">
<script language="JavaScript" src='/include/common.js'></script>
<script language="JavaScript">
<!--
	function save()
	{
		var fm = document.form1;	
	
		if(confirm('����Ͻðڽ��ϱ�?'))
		{
			if(fm.cont_dt.value == ''){	alert('������� �Է��Ͻʽÿ�');		fm.cont_dt.focus(); 		return;	}
			fm.action ='bank_lend_i_a.jsp';
			fm.target='i_no';
			fm.submit();
		}
	}
	
	function go_to_list()
	{
		parent.location='/acar/bank_mng/bank_frame_s.jsp?auth_rw='+document.form1.auth_rw.value;
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
		if(fm.cl_lim.options[fm.cl_lim.selectedIndex].value == '0'){ //�ŷ�ó ���Ѽ��ý� ������ ���÷���
			tr_docs.style.display	= 'none';
		}else{
			tr_docs.style.display	= '';
		}
	}	
		
	//��ȯ���м��ý� ���÷��� Ÿ��
	function rtn_display1(){
		var fm = document.form1;
		td_rtn_su.style.display	= 'none';
		tr_rtn_1.style.display	= 'none';
		tr_rtn_2.style.display	= 'none';
		tr_rtn_3.style.display	= 'none';
		tr_rtn_4.style.display	= 'none';
		tr_rtn_5.style.display	= 'none';
		if(fm.rtn_st.options[fm.rtn_st.selectedIndex].value == '2'){//����
			td_rtn_su.style.display	= '';
		}
		if(fm.rtn_st.options[fm.rtn_st.selectedIndex].value == '1'){//����
			tr_rtn_1.style.display	= '';
		}
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
	
	//�ü��ڱ� ��ȸ
	function search_fund_bank(){
		var fm = document.form1;
		window.open("/fms2/bank_mng/s_fund_bank.jsp?from_page=/acar/bank_mng/bank_lend_i.jsp", "SEARCH_LEND_BANK", "left=50, top=50, width=750, height=600, scrollbars=yes");		
	}		

//-->
</script>
</head>
<body leftmargin="15">
<form action="bank_lend_i_a.jsp" name="form1" method="POST">
<input type='hidden' name='auth_rw' value='<%=auth_rw%>'>
<input type="hidden" name="user_id" value="<%=user_id%>">
<input type="hidden" name="br_id" value="<%=br_id%>">
<input type='hidden' name='sh_height' value='<%=sh_height%>'>
<input type='hidden' name='bank_id' value='<%=bank_id%>'>
<input type='hidden' name='gubun1' value='<%=gubun1%>'>
<input type="hidden" name="lend_id" value="<%=lend_id%>">

<table border=0 cellspacing=0 cellpadding=0 width=100%>
    <tr>
        <td class=h></td>
    </tr>
    <tr> 
        <td colspan="2" class=line2></td>
    </tr>
    <tr> 
        <td class=line colspan="2"> 
            <table border=0 cellspacing=1 width=100%>
                <tr> 
                    <td class=title width=10%>�ڱݰ�����ȣ</td>
                    <td>&nbsp;        			
        			<input type="text" name="fund_id" maxlength='5' value="<%=fund_id%>" size="5" class=whitetext readonly>        			
        			&nbsp;
        			<a href="javascript:search_fund_bank()">[�ڱݰ�������]</a>        					
        			</td>                    
                </tr>
            </table>
        </td>
    </tr>     
    <tr>
        <td class=h></td>
    </tr>      
    <tr>
        <td class=line2></td>
    </tr>
    <tr>
        <td class=line>            
            <table border="0" cellspacing="1" width=100%>
                <tr> 
                    <td class=title width=10%>�����</td>
                    <td width=15%>&nbsp; 
                      <input type="text" name="cont_dt" maxlength='11' value="<%=AddUtil.ChangeDate2(wf.getCont_dt())%>" size="11" class=text onBlur='javascript:this.value=ChangeDate(this.value)'>
                    </td>
                    <td class=title width=10%>�����籸��</td>
                    <td width=15%>&nbsp; 
                      <select name='cont_bn_st'  onChange='javascript:bn_display()'>
                        <option value="1" <%if(wf.getCont_bn_st().equals("1")||wf.getCont_bn_st().equals("")){%>selected<%}%>selected>��1������</option>
                        <option value="2" <%if(wf.getCont_bn_st().equals("2")){%>selected<%}%>>��2������</option>
                      </select>
                    </td>
                    <td class=title width=10%>������</td>
                    <td width=15%> 
                      <table width="100%" border="0" cellspacing="0" cellpadding="0">
                        <tr> 
                          <td id="td_bn_1" style="display:''">&nbsp; 
                            <select name='cont_bn'>
                              <%	if(bank_size > 0){
        								for(int i = 0 ; i < bank_size ; i++){
        									CodeBean bank = banks[i];		%>
                              <option value='<%= bank.getCode()%>' <%if(wf.getCont_bn().equals(bank.getCode())){%>selected<%}%>><%= bank.getNm()%></option>
                              <%		}
        							}		%>
                            </select>
                          </td>
                          <td id="td_bn_2" style='display:none'>&nbsp; 
                            <select name='cont_bn2'>
                              <%	if(bank_size2 > 0){
        								for(int i = 0 ; i < bank_size2 ; i++){
        									CodeBean bank2 = banks2[i];		%>
                              <option value='<%= bank2.getCode()%>' <%if(wf.getCont_bn().equals(bank2.getCode())){%>selected<%}%>><%= bank2.getNm()%></option>
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
                        <option value="0" selected>�ű�</option>
                        <option value="1">����</option>
                      </select>
                    </td>
                </tr>
                <tr> 
                    <td class=title>����</td>
                    <td colspan="3">&nbsp; 
                      <input type="text" name="bn_br" maxlength='30' value="<%=wf.getBn_br()%>" size="43" class=text style='IME-MODE: active'>
                    </td>
                    <td class=title>������ȭ��ȣ</td>
                    <td>&nbsp; 
                      <input type="text" name="bn_tel" maxlength='15' value="<%=wf.getBn_tel()%>" size="15" class=text>
                    </td>
                    <td class=title>�����ѽ���ȣ</td>
                    <td>&nbsp; 
                      <input type="text" name="bn_fax" maxlength='15' value="" size="15" class=text>
                    </td>
                </tr>
                <tr> 
                    <td class=title>����<br>
                      �����</td>
                    <td>&nbsp; 
                      <input type="text" name="ba_nm" value="<%=wf.getBa_agnt()%>" size="12" maxlength='30' class=text>
                    </td>
                    <td class=title>����</td>
                    <td>&nbsp; 
                      <input type="text" name="ba_title" value="<%=wf.getBa_title()%>" size="12" maxlength='30' class=text>
                    </td>
                    <td class=title>����ó</td>
                    <td>&nbsp; 
                      <input type="text" name="ba_tel" value="<%=wf.getBn_tel()%>" size="15" maxlength='15' class=text>
                    </td>
                    <td class=title>E-mail</td>
                    <td>&nbsp; 
                      <input type="text" name="ba_email" value="" size="15" maxlength='50' class=text style='IME-MODE: inactive'>
                    </td>
                </tr>
                <tr> 
                    <td class=title>��� ������</td>
                    <td>&nbsp; 
                      <select name='br_id'>
                        <option value=''>����</option>
                        <%	if(brch_size > 0)	{
        						for (int i = 0 ; i < brch_size ; i++){
        							Hashtable branch = (Hashtable)branches.elementAt(i);		%>
                        <option value='<%=branch.get("BR_ID")%>' <%if(acar_br.equals(String.valueOf(branch.get("BR_ID")))){%>selected<%}%>><%= branch.get("BR_NM")%></option>
                        <%		}
        					}			%>
                      </select>
                    </td>
                    <td class=title>�����</td>
                    <td>&nbsp; 
                      <select name='mng_id'>
                        <%	if(user_size > 0){
        						for(int i = 0 ; i < user_size ; i++){
        							Hashtable user = (Hashtable)users.elementAt(i);	%>
                        <option value='<%= user.get("USER_ID") %>' 
        						<%if(user_id.equals(user.get("USER_ID"))){%>selected<%}%>> 
                        <%= user.get("USER_NM")%></option>
                        <%		}
        					}		%>
                      </select>
                    </td>
                    <td class=title>���࿩��</td>
                    <td colspan="3">&nbsp; 
                      <select name='move_st'>
                        <option value="0" selected>����</option>
                        <option value="1">�Ϸ�</option>
                      </select>
                    </td>
                </tr>
            </table>
        </td>
    </tr>
    <tr>
        <td class=h></td>
    </tR>
    <tr>    	
        <td><img src=/acar/images/center/icon_arrow.gif align=absmiddle> <span class=style2>��������</span></td>
    </tr>
    <tr>
        <td class=line2></td>
    </tr>
    <tr>
        <td class=line>            
            <table border="0" cellspacing="1" width=100%>
                <tr> 
                    <td class=title width=10%>�ŷ�ó ����</td>
                    <td colspan="7">&nbsp; 
                      <select name='cl_lim'  onChange='javascript:docs_display()'>
                        <option value="1">��</option>
                        <option value="0" selected>��</option>
                      </select>
                    </td>
                </tr>
                <tr id=tr_docs  style='display:none'> 
                    <td class=title>������</td>
                    <td colspan="7">&nbsp; 
                      <textarea name="cl_lim_sub" cols="90" rows="2" style='IME-MODE: active'></textarea>
                    </td>
                </tr>
                <tr> 
                    <td class=title>���� ����</td>
                    <td colspan="7">&nbsp; 
                      <select name='ps_lim'>
                        <option value="1">��</option>
                        <option value="0" selected>��</option>
                      </select>
                      &nbsp;&nbsp; </td>
                </tr>
                <tr> 
                    <td class=title>����ݾ�<br>����</td>
                    <td colspan="5">&nbsp; 
                      <select name='lend_amt_lim'>
                        <option value="">����</option>
                        <option value="1">(��������(Ź�۷�����)/1.1)�� ���� �ݾ׿� �������� ����</option>
                        <option value="3">(��������(Ź�۷�����)/1.1)�� ���� �ݾ׿� õ������ ����</option>
        				<option value="4">(��������(Ź�۷�����)/1.1)�� ���� �ݾ׿� ������� ����</option>
                        <option value="2">(��������(Ź�۷�����)�� 85%)�� ���� �ݾ׿� �������� ����</option>
                        <option value="5">(��������(Ź�۷�����)�� 70%)�� ���� �ݾ׿� �������� ����</option>				
                        <option value="0">����</option>
                      </select>
                      <font color="#999999">(����)</font></td>
                    <td class=title>��ȯ���� ����<br>�ܾ����� ��ü</td>
                    <td>&nbsp; 
                      <select name='rtn_change'>
                        <option value="1">��</option>
                        <option value="0" selected>��</option>
                      </select>
                    </td>
                </tr>
                <tr> 
                    <td class=title>�����缳��<br>
                      ä���ְ��</td>
                    <td>&nbsp;������� 
                      <input type="text" name="max_cltr_rat" value="" maxlength='5' size="3" class=num>
                      (%)</td>
                    <td class=title>�����û<br>
                      �Ⱓ���� ����</td>
                    <td>&nbsp; 
                      <select name='lend_lim'>
                        <option value="1">��</option>
                        <option value="0" selected>��</option>
                      </select>
                    </td>
                    <td class=title>�����û<br>
                      �Ⱓ����</td>
                    <td colspan="3">&nbsp; 
                      <input type="text" name="lend_lim_st" value="" size="11" class=text onBlur='javascript:this.value=ChangeDate(this.value)'>
                      ~ 
                      <input type="text" name="lend_lim_et" value="" size="11" class=text onBlur='javascript:this.value=ChangeDate(this.value)'>
                    </td>
                </tr>
                <tr> 
                    <td class=title>ä�Ǿ絵���<br>
                      ��༭</td>
                    <td colspan="7">&nbsp;&nbsp; 
                      <input type="text" name="cre_docs" value="" maxlength='80' size="80" class=text>
                      <font color="#999999">(��:������ �Ժ���)</font></td>
                </tr>
                <tr> 
                    <td class=title>��Ÿ</td>
                    <td colspan="7">&nbsp; 
                      <textarea name="note" cols="90" rows="2"></textarea>
                    </td>
                </tr>
                <tr> 
                    <td class=title>��������</td>
                    <td>&nbsp; 
                      <input type="text" name="f_rat" value="" size="5" maxlength='5' class=num>
                      (%)</td>
                    <td class=title>�����ھ�</td>
                    <td>&nbsp; 
                      <input type="text" name="f_amt" maxlength='9' value="" size="10" class=num onBlur='javascript:this.value=parseDecimal(this.value)'>
                      ��</td>
                    <td class=title>����Ⱓ</td>
                    <td colspan="3">&nbsp; 
                      <input type="text" name="f_start_dt" value="" size="11" class=text onBlur='javascript:this.value=ChangeDate(this.value)'>
                      ~ 
                      <input type="text" name="f_end_dt" value="" size="11" class=text onBlur='javascript:this.value=ChangeDate(this.value)'>
                    </td>
                </tr>
                <tr> 
                    <td class='title' width=10%>������</td>
                    <td width=15%>&nbsp; 
                      <input type="text" name="charge_amt" maxlength='9' value="" size="10" class=num onBlur='javascript:this.value=parseDecimal(this.value)'>
                      ��</td>
                    <td class='title' width=10%>������</td>
                    <td width=15%>&nbsp; 
                      <input type="text" name="ntrl_fee" maxlength='9' value="" size="10" class=num onBlur='javascript:this.value=parseDecimal(this.value)'>
                      ��</td>
                    <td class='title' width=10%>������</td>
                    <td width=15%>&nbsp; 
                      <input type="text" name="stp_fee" maxlength='9' value="" size="10" class=num onBlur='javascript:this.value=parseDecimal(this.value)'>
                      ��</td>
                    <td class='title' width=10%>�հ�</td>
                    <td width=15%>&nbsp; 
                      <input type="text" name="total_amt" maxlength='9' value="" size="10" class=whitenum onBlur='javascript:this.value=parseDecimal(this.value)'>
                      ��</td>
                </tr>
                <tr> 
                    <td class=title>����</td>
                    <td colspan="7">&nbsp; 
                      <textarea name="condi" cols="90" rows="2"></textarea>
                    </td>
                </tr>
            </table>
        </td>
    </tr>	
    <tr>
        <td class=h></td>
    </tR>
	<tr>
    	<td><img src=/acar/images/center/icon_arrow.gif align=absmiddle> <span class=style2>�������</span></td>
    </tr>
    <tr>
        <td class=line2></td>
    </tr>
    <tr>
        <td class=line>            
            <table border="0" cellspacing="1" width=100%>
                <tr> 
                    <td class=title width=10%>�Ѵ���ݾ�</td>
                    <td width=15%>&nbsp; 
                      <input type="text" name="cont_amt"  value="<%=AddUtil.parseDecimalLong(String.valueOf(wfi_ht.get("CONT_AMT")))%>" size="15" class=num onBlur='javascript:this.value=parseDecimal(this.value)'>
                      ��</td>
                    <td class=title wwidth=10%>��������</td>
                    <td width=15%>&nbsp; 
                      <input type="text" name="lend_int" value="<%=wfi_ht.get("LEND_INT")%>" size="10" class=text>
                      (%)</td>
                    <td class=title width=10%>��ȯ����</td>
                    <td width=40%>
                        <table width="100%" border="0" cellspacing="0" cellpadding="0">
                            <tr> 
                                <td width="70">&nbsp; 
                                    <select name='rtn_st' onChange='javascript:rtn_display1()'>
                                      <option value="0">��ü</option>
                                      <option value="1" selected>����</option>
                                      <option value="2">����</option>
                                    </select>
                                </td>
                                <td id="td_rtn_su" style='display:none' width="70"> 
                                    <select name='rtn_su' onChange='javascript:rtn_display2()'>
                                      <option value="">����</option>
                                      <option value="1" selected>1</option>
                                      <option value="2">2</option>
                                      <option value="3">3</option>
                                      <option value="4">4</option>
                                      <option value="5">5</option>
                                    </select>
                                </td>
                                <td align="right"><img src=/acar/images/center/arrow_help.gif align=absmiddle> : <a href="#" title="��ȯ����. ����� �������� ������ �����Ѵ�.">��ü</a>/ 
                                    <a href="#" title="��ȯ�� ������ �߻��Ѵ�.(1��,2��) �������� ��ȯ���� �����Ѵ�. ����� �����Ѵ�.">����</a>/ 
                                    <a href="#" title="�ѹ��� �������� �����Ͽ� ��ȯ�Ѵ�.">����</a>&nbsp;&nbsp;</td>
                            </tr>
                        </table>
                    </td>
                </tr>
                <tr> 
                    <td class='title'>ä��Ȯ������</td>
                    <td colspan='5'>&nbsp; 
                        <select name='bond_get_st'>
                          <option value="">����</option>
                          <option value="1">��༭ </option>
                          <option value="2">��༭+�ΰ�����</option>
                          <option value="3">��༭+�ΰ�����+������</option>
                          <option value="4">��༭+�ΰ�����+������+LOAN ���뺸���������</option>
                          <option value="5">��༭+�ΰ�����+������+LOAN ���뺸����������</option>
                          <option value="6">��༭+���뺸����</option>
                        </select>
                      &nbsp;�߰�����:&nbsp;
                        <input type="text" name="bond_get_st_sub"  value="" size="40" class=text>
                    </td>
                </tr>
                <tr> 
                    <td class=title width=10%>�ߵ���ȯ<br>��������</td>
                    <td width=15%>&nbsp; 
                      <input type="text" name="cls_rtn_fee_int"  value="" size="5" class=text >
                      (%)</td>
                    <td class=title wwidth=10%>�ߵ���ȯ<br>Ư�̻���</td>
                    <td colspan='3'>&nbsp; 
                      <textarea name="cls_rtn_etc" cols="90" rows="2"></textarea></td>                    
                </tr>				
            </table>
        </td>
    </tr>
    <tr>
        <td class=h></td>
    </tR>
    <tr>    	
        <td><img src=/acar/images/center/icon_arrow.gif align=absmiddle> <span class=style2>�����û�� ���񼭷�</span></td>
    </tr>
    <tr>
        <td class=line2></td>
    </tr>
    <tr>
        <td class=line>            
            <table border="0" cellspacing="1" width=100%>
                <tr> 
                    <td class=title width=10%>�����û��<br>
                      �غ񼭷�</td>
                    <td colspan=3>&nbsp; 
                      <textarea name="docs" cols="90" rows="2"></textarea>
                    </td>
                </tr>
            </table>
        </td>
    </tr>
    <tr>
        <td class=h></td>
    </tR>
	<tr>
    	<td><img src=/acar/images/center/icon_arrow.gif align=absmiddle> <span class=style2>��ȯ����</span></td>
    </tr>
    <tr>
        <td class=line2></td>
    </tr>
	<%for(int i=0; i<5; i++){%>
    <tr id='tr_rtn_<%=i+1%>' style='display:none'>
	<input type='hidden' name='rtn_seq<%=i%>' value='<%=i+1%>'>
        <td class=line>            
            <table border="0" cellspacing="1" width=100%>
                <tr> 
                    <td class=title>����ݾ�</td>
                    <td>&nbsp; 
                      <input type="text" name="rtn_cont_amt<%=i%>" value="<%=AddUtil.parseDecimalLong(String.valueOf(wfi_ht.get("CONT_AMT")))%>" size="15" class=num onBlur='javascript:this.value=parseDecimal(this.value)'>
                      ��</td>
                    <td class=title>����Ⱓ</td>
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
                      <input type="text" name="rtn_tot_amt<%=i%>" value="" size="15" class=num onBlur='javascript:this.value=parseDecimal(this.value)'>
                      ��</td>
                    <td class=title width=10%>����ȯ�ݾ�</td>
                    <td width=15%>&nbsp; 
                      <input type="text" name="alt_amt<%=i%>" value="" size="11" class=num onBlur='javascript:this.value=parseDecimal(this.value)'>
                      ��</td>
                    <td class=title width=10%>��ȯ������</td>
                    <td width=15%>&nbsp; 
                      <input type="text" name="cont_start_dt<%=i%>" value="" size="11" class=text  onBlur='javascript:this.value=ChangeDate(this.value)'>
                    </td>
                    <td class=title width=10%>��ȯ������</td>
                    <td width=15%>&nbsp; 
                      <input type="text" name="cont_end_dt<%=i%>" value="" size="11" class=text  onBlur='javascript:this.value=ChangeDate(this.value)'>
                    </td>
                </tr>
                <tr> 
                    <td class=title>��ȯ����</td>
                    <td>&nbsp; 
                      <input type="text" name="cont_term<%=i%>" value=""  size="4" class=text>
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
                      <input type="text" name="rtn_one_dt<%=i%>"  value="" size="11" class=text  onBlur='javascript:this.value=ChangeDate(this.value)'>
                    </td>
                    <td class='title'>2�� ������<br>��ȯ</td>
                    <td>&nbsp; 
                      <input type="text" name="rtn_two_amt<%=i%>" value="" size="11"  class=num  onBlur='javascript:this.value=parseDecimal(this.value)'>
                      �� </td>
                    <td class='title'>���¹�ȣ</td>
                    <td>&nbsp; 
        			<input name="deposit_no<%=i%>" type="text" class=text id="deposit_no" value="" size="12" ></td>
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
    <tr></tr><tr></tr><tr></tr>
	<%}%>	
</table>
</form>
<iframe src="about:blank" name="i_no" width="0" height="0" frameborder="0" noresize>
</iframe>
<script language='javascript'>
<!--
rtn_display1();
rtn_display2();
-->
</script>
</body>
</html>