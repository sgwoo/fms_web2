<%@ page language="java" contentType="text/html;charset=euc-kr" %>
<%@ page import="java.io.*, java.util.*, java.text.*, acar.util.*, jxl.*, card.*, acar.bill_mng.*"%>
<jsp:useBean id="CardDb" scope="page" class="card.CardDatabase"/>

<%
	//excel ������ ���� ���
	String path = request.getRealPath("/file/");
	Vector vt = new Vector();
	
	//ExcelUpload file = new ExcelUpload("C:\\Inetpub\\wwwroot\\file\\", request.getInputStream());
	ExcelUpload file = new ExcelUpload(path, request.getInputStream());	
	String filename = file.getFilename();
	
	FileInputStream fi = new FileInputStream(new File(path+""+filename+".xls"));

	Workbook workbook = Workbook.getWorkbook(fi);
	
	//������ ù��° sheet ������ �´�. 
	Sheet sheet = workbook.getSheet(0);
	
	for(int i = 0; i < sheet.getRows(); i++){
	
		Hashtable ht = new Hashtable();
		
		for(int j = 0; j < sheet.getColumns(); j++){
			
			Cell cell = sheet.getCell(j,i);
			
			ht.put(Integer.toString(j), cell.getContents());
			
		}
		vt.add(ht);
	}
	
	String gubun1 	= file.getParameter("gubun1")==null?"":file.getParameter("gubun1");
	
	
	NeoErpUDatabase neoe_db = NeoErpUDatabase.getInstance();
	
	//ī������ ����Ʈ ��ȸ
	Vector card_kinds = CardDb.getCardKinds("CODE", "Y");
	int ck_size = card_kinds.size();
	
	
	
	//������¹�ȣ
	Vector banks = neoe_db.getFeeDepositList();				//-> neoe_db ��ȯ
	int bank_size = banks.size();
%>
<HTML>
<HEAD>
<TITLE>FMS</TITLE>
<META HTTP-EQUIV="Content-Type" CONTENT="text/html; charset=euc-kr">
<link rel=stylesheet type="text/css" href="/acar/include/table.css">
<script language="JavaScript" src="/include/common.js"></script>
<!--<script language="JavaScript" src="/acar/include/info.js"></script>-->
<SCRIPT LANGUAGE="JavaScript">
<!--
	//����ϱ�
	function save(){
		fm = document.form1;

		if(fm.start_row.value == '')		{ alert('������ ��ȣ�� �Է��Ͻʽÿ�.'); 	return; }
		if(fm.value_line.value == '')		{ alert('�������� ��ȣ�� �Է��Ͻʽÿ�.'); 	return; }		
		
		if(fm.card_st.value == '')	{		alert('�뵵������ �����Ͻʽÿ�.'); return; }
		if(fm.ven_code.value == ''){		alert('�ŷ�ó�� �����Ͻʽÿ�.'); return; }		
		if(fm.receive_dt.value == ''){		alert('ī��������� �Է��Ͻʽÿ�.'); return; }				
		
		if(fm.card_kind.value == ''){		alert('ī�������� �����Ͻʽÿ�.'); return; }		

		fm.use_s_dt2.value = fm.use_s_dt.value + fm.use_s_dt_h.value
//		fm.use_e_dt2.value = fm.use_e_dt.value + fm.use_e_dt_h.value
		
		
		if(!confirm("����Ͻðڽ��ϱ�?"))	return;
		fm.action = 'card_excel_all_reg_a.jsp';
		fm.submit();
	}
	
	//�׿�����ȸ
	function Neom_search(s_kd){
		var fm = document.form1;
		fm.s_kd.value = s_kd;
		if(s_kd == 'cardno')	fm.t_wd.value = fm.cardno.value;
		window.open("about:blank",'Neom_search','scrollbars=yes,status=no,resizable=yes,width=600,height=500,left=250,top=250');		
		fm.action = "/card/card_mng/neom_search.jsp";
		fm.target = "Neom_search";
		fm.submit();		
	}
	function Neom_enter(s_kd) {
		var keyValue = event.keyCode;
		if (keyValue =='13') Neom_search(s_kd);
	}	
	
	//������ȸ
	function User_search(nm, idx){
		var fm = document.form1;
		var t_wd = fm.user_nm[idx].value;
		window.open("about:blank",'User_search','scrollbars=yes,status=no,resizable=yes,width=400,height=400,left=250,top=250');		
		fm.action = "/card/card_mng/user_search.jsp?nm="+nm+"&idx="+idx+"&t_wd="+t_wd;
		fm.target = "User_search";
		fm.submit();		
	}
	function enter(nm, idx) {
		var keyValue = event.keyCode;
		if (keyValue =='13') User_search(nm, idx);
	}	
	
	//�ŷ�ó��ȸ�ϱ�
	function search(idx){
		var fm = document.form1;
		var t_wd = "ī��";		
		if(fm.ven_name.value != '') t_wd = fm.ven_name.value;
//		if(fm.card_kind.value != '')	t_wd = fm.card_kind.value.substr(0,2);
		window.open("/acar/con_debt/vendor_list.jsp?idx="+idx+"&t_wd="+t_wd, "VENDOR_LIST", "left=300, top=300, width=450, height=400, scrollbars=yes");		
	}	

	//ī������ϰ� ī�������� ���Ͻ� üũ�ϸ� �� �ѱ��
	function Dt_chk(){
		var fm = document.form1;
		if(fm.dt_chk.checked == true){
			fm.use_s_dt.value = fm.receive_dt.value;
		}else{
			fm.use_s_dt.value = '';
		}
	}	
//-->
</SCRIPT>
<style type="text/css">
<!--
.style1 {color: #999999}
-->
</style>
</HEAD>
<BODY>
<p>
</p>
<form action="" method='post' name="form1">
<input type='hidden' name='gubun1' value='<%=gubun1%>'>
<input type='hidden' name='row_size' value='<%=sheet.getRows()%>'>
<input type='hidden' name='col_size' value='<%=sheet.getColumns()%>'>
<input type='hidden' name='use_yn' value='Y'>
<input type='hidden' name='use_s_dt2' value=''>
<input type='hidden' name='use_e_dt2' value=''>

<table border="0" cellspacing="0" cellpadding="0" width="<%=30+(300*sheet.getColumns())%>">
  <tr>
    <td>&lt; ���� ���� �б� &gt; </td>
  </tr>
  <tr>
    <td><hr></td>
  </tr>
  <tr>
    <td>&lt; ���� &gt; </td>
  </tr>      
  <tr>
    <td class="line">
	  <table border="0" cellspacing="1" cellpadding="0" width=100%>  
        <tr>
    	  <td width="100" height="30" class="title">������</td>
    	  <td>&nbsp;
		  <input type='text' name='start_row' size='3' value='1' class='text'>��</td>
        </tr>
        <tr>
    	  <td width="100" height="30" class="title">��������</td>
    	  <td>&nbsp;
		  <input type='text' name='value_line' size='3' value='<%=vt.size()-1%>' class='text'>��</td>
        </tr>
	  </table>
	</td>
  </tr>  
    <tr> 
      <td align="right">&nbsp;</td>
    </tr>
    <tr>
      <td class="line">
	    <table border="0" cellspacing="1" cellpadding="0" width='100%'>
          <tr>
            <td class='title'>�߱�����</td>
            <td>&nbsp;
			<input name="card_sdate" type="text" class="text" value="" size="11" onBlur='javascript:this.value=ChangeDate(this.value)'></td>
          </tr>
          <tr>
            <td class='title'>��������</td>
            <td>&nbsp;
			<input name="card_edate" type="text" class="text" value="" size="11" onBlur='javascript:this.value=ChangeDate(this.value)'></td>
          </tr>		  		  		
          <tr>
            <td width='20%' class='title'>�뵵����</td>
            <td>&nbsp;
          	  <select name="card_st" >
            	<option value=''>����</option>
				<option value='1'>�����ڱݿ�</option>
				<option value='2'>����</option>
				<option value='3'>��/�������޿�</option>
				<option value='4'>�����н�</option>				
          	  </select>        
			  </td>
          </tr>
          <tr>
            <td width='20%' class='title'>ī������</td>
            <td>&nbsp;
          	  <select name="card_type" >
            	<option value=''>����</option>
				<option value='1'>VISA</option>
				<option value='2'>MASTER</option>
				<option value='3'>BC</option>
				<option value='4'>DYNASTY</option>				
          	  </select>        
			  </td>
          </tr>
          <tr>
            <td width='20%' class='title'>ī������</td>
            <td>&nbsp;
          	  <select name="card_kind" >
            	<option value=''>����</option>
            	<%	if(ck_size > 0){
						for (int i = 0 ; i < ck_size ; i++){
							Hashtable card_kind = (Hashtable)card_kinds.elementAt(i);%>
            	<option value='<%= card_kind.get("CODE") %>'><%= card_kind.get("CARD_KIND") %></option>
            	<%		}
					}%>
          	  </select>      
			  </td>
          </tr>
          <tr>
            <td width='20%' class='title'>���ұ���</td>
            <td>&nbsp;
          	  <select name="card_paid" >
            	<option value=''>����</option>
				<option value='2'>����ī��</option>
				<option value='3'>�ĺ�ī��</option>
				<option value='5'>����Ʈ</option>
				<option value='7'>ī���Һ�</option>
          	  </select>        
			  </td>
          </tr>          
          <tr>
            <td class='title'>�ŷ�ó</td>
            <td>&nbsp;  
			<input type='text' name='ven_code' value='' size="6" class="text" redeonly>&nbsp;<input name="ven_name" type="text" class="text" value="" size="30"> <a href="javascript:search('');"><img src=/acar/images/center/button_in_search1.gif border=0 align=absmiddle></a></td>
          </tr>			
          <tr>
            <td class='title'>������</td>
            <td>&nbsp; �ſ� 
              <input type="text" name="pay_day" size="2" class=text>
            �� ���� </td>
          </tr>
            <tr>
              <td class='title'>��������</td>
              <td>&nbsp; <select name='acc_no'>
                        <option value=''>���¸� �����ϼ���</option>
					    <%	if(bank_size > 0){
								for(int i = 0 ; i < bank_size ; i++){
									Hashtable bank = (Hashtable)banks.elementAt(i);%>
						<option value='<%= bank.get("DEPOSIT_NO")%>'>[<%=bank.get("CHECKD_NAME")%>]<%= bank.get("DEPOSIT_NO")%>&nbsp;:&nbsp;<%= bank.get("DEPOSIT_NAME")%></option>
			            <%		}
							}%>

                      </select>
			  </td>
            </tr>          
          <tr>
            <td class='title'>ī����Ⱓ</td>
            <td>&nbsp;
              <select name="use_s_m" >
                <option value="">����</option>			  
                <option value="1">������</option>
                <option value="2">����</option>
              </select>
              <input type="text" name="use_s_day" size="2" class=text>
				�� ~ 
			  <select name="use_e_m" >
                <option value="">����</option>			  
  				<option value="2">����</option>
  				<option value="3">���</option>
			  </select>
			  <input type="text" name="use_e_day" size="2" class=text>
			  	��</td>
          </tr>
          <tr>
            <td class='title'>�ѵ�����</td>
            <td>&nbsp;
			<select name="limit_st" >
              <option value="">����</option>			
              <option value="1">�����ѵ�</option>
              <option value="2">�����ѵ�</option>
            </select></td>
          </tr>
		  <!--
          <tr>
            <td class='title'>�ѵ��ݾ�</td>
            <td>&nbsp;
			<input type="text" name="limit_amt" size="10" class=num onBlur='javascript:this.value=parseDecimal(this.value)'>
			��</td>
          </tr>
		  -->
          <tr>
            <td class='title'>ī���������</td>
            <td>&nbsp;
              <input name="receive_dt" type="text" class="text" onBlur='javascript:this.value=ChangeDate(this.value)' value="" size="11"></td>
          </tr>
		 
          <tr>
            <td class='title'>���</td>
            <td>&nbsp;
			<input type="text" name="etc" size="70" class=text>			
			</td>
          </tr>
          <tr>
            <td width='20%' class='title'>ī��������</td>
            <td>&nbsp;
              <input name="use_s_dt" type="text" class="text" value="" onBlur='javascript:this.value=ChangeDate(this.value)' size="11">
			  <input name="use_s_dt_h" type="text" class="text" value="" size="2">��
			  ( ī������ϰ� ����
              <input type="checkbox" name="dt_chk" value="Y" onClick="javascript:Dt_chk();"> )
		    </td>
          </tr>		  		  
        </table>
	</td>
  </tr>  
  <tr>
    <td>&nbsp;</td>
  </tr>      
  <tr>
    <td>�� Į���� : [A]ī���ȣ('-'�ִ»���)	 [B]����ڱ���	[C]ī������	 [D]�ѵ��ݾ� 	 [E]ī������� ���� 	[F]��ǥ������ ���� </td>
  </tr>        
  <tr>
    <td>&nbsp;</td>
  </tr>    
  <tr>
    <td class="line">
	  <table border="0" cellspacing="1" cellpadding="0">  
        <tr>
    	  <td width="30" class="title">����</td>
    	  <td colspan='<%=sheet.getColumns()%>' class="title">���� ����Ÿ</td>
  		</tr>
<%
	int vt_size = vt.size();
	for (int i = 0 ; i < vt_size ; i++){
		Hashtable content = (Hashtable)vt.elementAt(i);%>  
        <tr>
    	  <td width="30" height="30" class="title"><%=i%></td>
		  <% for(int j = 0; j < sheet.getColumns(); j++){%>
    	  <td width="300" align="center"><input name="value<%=j%>" type="text" class=text style1   value="<%=content.get(Integer.toString(j))%>" size="30"></td>
		  <%	}%>
  		</tr>
<%	}%>
	  </table>
	</td>
  </tr> 
  <tr>  
    <td>
	  &nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;
	  <a href='javascript:save()' onMouseOver="window.status=''; return true"><img src="/acar/images/center/button_reg.gif" aligh="absmiddle" border="0"></a>&nbsp;
	  <a href='javascript:window.close()' onMouseOver="window.status=''; return true"><img src="/acar/images/center/button_close.gif" aligh="absmiddle" border="0"></a></td>
    </tr>
</table>
</form>
<iframe src="about:blank" name="i_no" width="0" height="0" frameborder="0" noresize></iframe>
</BODY>
</HTML>