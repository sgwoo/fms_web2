<%@ page language="java" contentType="text/html;charset=euc-kr" %>
<%@ page import="java.util.*, acar.bank_mng.*, acar.common.*, acar.util.*, acar.cls.*"%>
<jsp:useBean id="abl_db" scope="page" class="acar.bank_mng.AddBankLendDatabase"/>
<jsp:useBean id="as_db" scope="page" class="acar.cls.AddClsDatabase"/>
<jsp:useBean id="rs_db" scope="page" class="acar.res_search.ResSearchDatabase"/>
<%@ include file="/acar/cookies.jsp" %>

<html>
<head><title>FMS</title>
<link rel=stylesheet type="text/css" href="../../include/table.css">
<script language='JavaScript' src='/include/common.js'></script>
<script language='javascript'>
<!--
	//����ϱ�
	function save(){
		var fm = document.form1;
		if(fm.lend_id.value == ''){ alert('�������ID�� Ȯ���Ͻʽÿ�'); fm.lend_id.focus(); return;	}		
		else if(fm.rtn_seq.value == ''){ alert('��ȯ���ҹ�ȣ�� Ȯ���Ͻʽÿ�'); fm.rtn_seq.focus(); return;	}		
		else if(fm.cls_rtn_dt.value == ''){ alert('�������ڸ� �Է��Ͻʽÿ�'); fm.cls_rtn_dt.focus(); return; }
		else if(fm.cls_rtn_cau.value == ''){ alert('���������� �Է��Ͻʽÿ�'); fm.cls_rtn_cau.focus(); return; }
		else if(fm.nalt_rest.value == ''){ alert('�̻�ȯ������ �Է��Ͻʽÿ�');	fm.nalt_rest.focus(); return; }
		else if(fm.cls_rtn_amt.value == ''){ alert('�ߵ������ݾ׸� Ȯ���Ͻʽÿ�'); fm.cls_rtn_amt.focus(); return; }			
		if(!confirm('�����Ͻðڽ��ϱ�?'))
			return;
		fm.target='i_no';
		fm.action='cls_u_a.jsp';
		fm.submit();		
	}

	//�Է½� �ڵ� ����ϱ�	
	function set_cls_amt(obj){
		obj.value = parseDecimal(obj.value);
		var fm = document.form1;
		fm.cls_rtn_amt.value = parseDecimal(toInt(parseDigit(fm.nalt_rest.value)) + toInt(parseDigit(fm.cls_rtn_fee.value)) + toInt(parseDigit(fm.cls_etc_fee.value)) + toInt(parseDigit(fm.cls_rtn_int_amt.value)) + toInt(parseDigit(fm.dly_alt.value)) - toInt(parseDigit(fm.be_alt.value)));			
	}
-->
</script>
</head>
<body onload="javascript:document.form1.cls_rtn_cau.focus();">
<%
	String auth_rw = request.getParameter("auth_rw")==null?"":request.getParameter("auth_rw"); //����
	String user_id = request.getParameter("user_id")==null?"":request.getParameter("user_id");//�α���-ID
	String br_id = request.getParameter("br_id")==null?"":request.getParameter("br_id");//�α���-������
	
	//�α���ID&������ID
	LoginBean login = LoginBean.getInstance();
	if(user_id.equals("")) 	user_id = login.getCookieValue(request, "acar_id");
	if(br_id.equals(""))	br_id = login.getCookieValue(request, "acar_br");
	if(auth_rw.equals(""))	auth_rw = rs_db.getAuthRw(user_id, "05", "05", "01");

	String lend_id = request.getParameter("lend_id")==null?"":request.getParameter("lend_id");
	String rtn_seq = request.getParameter("rtn_seq")==null?"":request.getParameter("rtn_seq");
	
	CommonDataBase c_db = CommonDataBase.getInstance();	
	CodeBean[] banks = c_db.getBankList("1"); /* �ڵ� ����:��1������ */	
	int bank_size = banks.length;
	
	Hashtable lend_bank = abl_db.getBankClsinfo(lend_id, rtn_seq);
	
	ClsBankBean cls = as_db.getClsBank(lend_id, rtn_seq);
%>
<form name='form1' method='post' action='cls_u_a.jsp'>
<input type='hidden' name='lend_id' value='<%=lend_id%>'>
<input type='hidden' name='rtn_seq' value='<%=rtn_seq%>'>
<input type='hidden' name='auth_rw' value='<%=auth_rw%>'>
  <table border="0" cellspacing="0" cellpadding="0" width=800>
    <tr> 
      <td colspan="2"> 
        <table border="0" cellspacing="1" cellpadding="0" width=800>
          <tr> 
            <td align='left'><font color="navy">�繫���� -> ����������</font> -> <font color="red">������� 
              �ߵ�����</font></td>
            <td align='right'><%if(auth_rw.equals("3") || auth_rw.equals("4") || auth_rw.equals("6")){%><a href='javascript:save();' onMouseOver="window.status=''; return true" onfocus="this.blur()"><img src="/images/update.gif" width="50" height="18" aligh="absmiddle" border="0" alt="����"><%}%></a> 
            </td>
          </tr>
        </table>
      </td>
    </tr>
    <tr> 
      <td class='line' colspan="2"> 
        <table border="0" cellspacing="1" cellpadding="0" width=800>
          <tr> 
            <td width='90' class='title'>�������ID</td>
            <td width='110'>&nbsp;<%=lend_id%></td>
            <td width='80' class='title'>�����籸��</td>
            <td width='130'>&nbsp;<%=lend_bank.get("CONT_BN_ST")%></td>
            <td width='80' class='title'>������</td>
            <td width="110">&nbsp;<%=c_db.getNameById((String)lend_bank.get("CONT_BN"), "BANK")%></td>
            <td class='title' width="80">������</td>
            <td>&nbsp;<%=lend_bank.get("BN_BR")%></td>
          </tr>
          <tr> 
            <td class='title' width="90">�����</td>
            <td width="110">&nbsp;<%=lend_bank.get("CONT_DT")%></td>
            <td class='title' width="80">������</td>
            <td width="110">&nbsp;<%=lend_bank.get("LEND_INT")%>%</td>
            <td class='title' width="80">��ȯ����</td>
            <td width="110">&nbsp;<%=lend_bank.get("RTN_ST")%>&nbsp;<%=rtn_seq+"��"%></td>
            <td class='title' width="80">����������</td>
            <td width="110" align="right">&nbsp;<%=AddUtil.parseDecimal(AddUtil.parseInt((String)lend_bank.get("RTN_CONT_AMT")))%>&nbsp;��&nbsp;&nbsp;</td>
          </tr>
          <tr> 
            <td class='title' width="90">�̻�ȯ����</td>
            <td align='right'>&nbsp;<%=AddUtil.parseDecimal(cls.getNalt_rest())%>&nbsp;��&nbsp;&nbsp;</td>
            <td class='title' width="80">����������</td>
            <td width="130">&nbsp;<%=cls.getMax_pay_dt()%></td>
    				<td class='title'>�ߵ���ȯ<br>������</td>
    		 		<td>&nbsp;<%=lend_bank.get("CLS_RTN_FEE_INT")%>%&nbsp;</td>
    				<td class='title'>�ߵ���ȯ<br>Ư�̻���</td>
    				<td>&nbsp;<%=lend_bank.get("CLS_RTN_ETC")%></td>
			    </tr>					
		  
        </table>
      </td>
    </tr>
    <tr> 
      <td colspan="2">&lt;&lt;�ߵ������ݾ� ���⳻��&gt;&gt;</td>
    </tr>
    <tr> 
      <td class='line'> 
        <table border="0" cellspacing="1" cellpadding="0" width="800">
                <tr> 
                    <td class='title'>��������</td>
                    <td>&nbsp; 
                      <input type='text' name='cls_rtn_dt' size='12' class='text' onBlur='javascript: this.value = ChangeDate(this.value)' value='<%=cls.getCls_rtn_dt()%>'></td>
                </tr>		
                <tr> 
                    <td class='title'>�������� </td>
                    <td> &nbsp; 
                      <textarea name='cls_rtn_cau' rows='2' cols='100' style='IME-MODE: active'><%=cls.getCls_rtn_cau()%></textarea>
                    </td>
                </tr>							
		
          <tr> 
            <td width='90' class='title'> �̻�ȯ����</td>
            <td>&nbsp; 
              <input type='text' name='nalt_rest' size='15' value='<%=AddUtil.parseDecimal(cls.getNalt_rest())%>' class='num' onBlur='javascript:this.value=parseDecimal(this.value); set_cls_amt(this);'>
              ��&nbsp;&nbsp;
					  (����������ä :
                      <input type='text' name='nalt_rest_1' size='15' value='<%=AddUtil.parseDecimal(cls.getNalt_rest_1())%>' class='num' onBlur='javascript:this.value=parseDecimal(this.value); '>
                      ��, &nbsp;&nbsp;������Ա� :
                      <input type='text' name='nalt_rest_2' size='15' value='<%=AddUtil.parseDecimal(cls.getNalt_rest_2())%>' class='num' onBlur='javascript:this.value=parseDecimal(this.value); '>
                      ��&nbsp;&nbsp;)</td>
          </tr>
          <tr> 
            <td class='title' width="90">�ߵ�����������</td>
            <td>&nbsp; 
              <input type='text' name='cls_rtn_fee' value='<%=AddUtil.parseDecimal(cls.getCls_rtn_fee())%>' size='15' class='num' onBlur='javascript:this.value=parseDecimal(this.value); set_cls_amt(this);'>
              �� 
              <input type='text' size='4' name='cls_rtn_fee_int' value='<%=cls.getCls_rtn_fee_int()%>' class='num' onBlur='javascript:set_cls_amt(this)' maxlength='4'>
              % </td>
          </tr>
          <tr> 
            <td width='90' class='title'> �������</td>
            <td>&nbsp; 
              <input type='text' name='cls_rtn_int_amt' value='<%=AddUtil.parseDecimal(cls.getCls_rtn_int_amt())%>' size='15' class='num' onBlur='javascript:this.value=parseDecimal(this.value); set_cls_amt(this);'>
              ��&nbsp;</td>
          </tr>
          <tr> 
                    <td class='title'> ��Ÿ������</td>
                    <td>&nbsp; 
                      <input type='text' name='cls_etc_fee' value='<%=AddUtil.parseDecimal(cls.getCls_etc_fee())%>' size='15' class='num' onBlur='javascript:this.value=parseDecimal(this.value); set_cls_amt(this);'>
                      ��&nbsp;(���縻�Ҵ���� ��)</td>
                </tr>  
          <tr> 
            <td width='90' class='title'> ��ü�Һα�</td>
            <td>&nbsp; 
              <input type='text' name='dly_alt' value='<%=AddUtil.parseDecimal(cls.getDly_alt())%>' size='15' class='num' onBlur='javascript:this.value=parseDecimal(this.value); set_cls_amt(this);'>
              ��&nbsp;</td>
          </tr>
          <tr> 
            <td width='90' class='title'> ������</td>
            <td>&nbsp; 
              <input type='text' name='be_alt' value='<%=AddUtil.parseDecimal(cls.getBe_alt())%>' size='15' class='num' onBlur='javascript:this.value=parseDecimal(this.value); set_cls_amt(this);'>
              ��&nbsp;</td>
          </tr>
          <tr> 
            <td width='90' class='title'> �հ�</td>
            <td>&nbsp; 
              <input type='text' name='cls_rtn_amt' value='<%=AddUtil.parseDecimal(cls.getCls_rtn_amt())%>' size='15' class='num' onBlur='javascript:this.value=parseDecimal(this.value);'>
              ��&nbsp;</td>
          </tr>
        </table>
      </td>
    </tr>
    <tr> 
      <td align=''left> <<��������>> </td>
    </tr>
    <tr> 
      <td class='line'> 
        <table border="0" cellspacing="1" cellpadding="0" width=800>
          <tr> 
            <td width='90' class='title'> �����</td>
            <td width='110'>&nbsp; 
              <select name='bk_code'>
                <%	if(bank_size > 0){
								for(int i = 0 ; i < bank_size ; i++){
									CodeBean bank = banks[i];		%>
                <option value='<%= bank.getCode()%>' <%if(cls.getBk_code().equals(bank.getCode()))%>selected<%%>><%= bank.getNm()%></option>
                      <%		}
							}		%>
                    </select>
            </td>
            <td width='80' class='title'> ���¹�ȣ</td>
            <td width="230">&nbsp; 
              <input type="text" size="30" name="acnt_no" value='<%=cls.getAcnt_no()%>' class="text">
            </td>
            <td class='title' width="80">�����ָ�</td>
            <td>&nbsp; 
              <input type='text' size='20' name='acnt_user' value='<%=cls.getAcnt_user()%>' class='text'>
            </td>
          </tr>
        </table>
      </td>
    </tr>
    <tr align="right"> 
      <td> <a href='javascript:window.close();' onMouseOver="window.status=''; return true" onfocus="this.blur()"><img src="/images/close.gif" width="50" height="18" aligh="absmiddle" border="0" alt="�ݱ�"></a></td>
    </tr>
  </table>
</form>
<iframe src="about:blank" name="i_no" width="100" height="50" cellpadding="0" cellspacing="0" border="1" frameborder="0" noresize>
</body>
</html>
