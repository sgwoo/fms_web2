<%@ page language="java" contentType="text/html;charset=euc-kr" %>
<%@ page import="java.util.*, acar.util.*"%>
<%@ include file="/acar/cookies.jsp" %>

<html>
<head>
<title>�����</title>
<meta http-equiv="Content-Type" content="text/html; charset=euc-kr">
<link rel=stylesheet type="text/css" href="../include/table.css">
<script language='JavaScript' src='/include/common.js'></script>
<script language='javascript'>
<!--
	//�����ȣ �˻�
	function search_zip(str){
		window.open("./s_zip.jsp?idx="+str, "ZIP", "left=300, top=300, height=300, width=350, scrollbars=yes");
	}
		
	//������ּ� ���� ��	
	function set_o_addr(){
		var fm = document.form1;
		if(fm.c_ho.checked == true){
			fm.zip[2].value = fm.zip[1].value;
			fm.addr[2].value = fm.addr[1].value;
		}else{
			fm.zip[2].value = '';
			fm.addr[2].value = '';
		}
	}
	
	function save(){
		var fm = document.form1;	
		//NN check
		if	   (fm.firm_nm.value == '')			{	alert('��ȣ�� �Է��Ͻʽÿ�');				return;	}
		else if(fm.client_nm.value == '')		{	alert('������ �Է��Ͻʽÿ�');				return;	}			
		else if((fm.ssn1.value == '') || (fm.ssn2.value == '')){	
													alert('�ֹ�(����)��Ϲ�ȣ�� �Է��Ͻʽÿ�'); return; }
		else if(fm.client_st.value == '1'){//����
			if((fm.enp_no1.value == '') || (fm.enp_no2.value == '') || (fm.enp_no3.value == '')){ 
													alert('����ڵ�Ϲ�ȣ�� �Է��Ͻʽÿ�'); 	return; }
			else if(fm.addr[1].value == '')		{ 	alert('���� �������� �Է��Ͻʽÿ�'); 		return; }
			else if(fm.addr[2].value == '')		{ 	alert('����� �ּҸ� �Է��Ͻʽÿ�'); 		return; }
			else if(fm.bus_cdt.value == '')		{ 	alert('���¸� �Է��Ͻʽÿ�'); 				return; }
			else if(fm.bus_itm.value == '')		{ 	alert('���� �Է��Ͻʽÿ�'); 				return; }
			else if(fm.open_year.value == '')	{ 	alert('����������� �Է��Ͻʽÿ�'); 		return; }
		}		
			
		if(confirm('����Ͻðڽ��ϱ�?')){
			fm.target='i_no';
			fm.submit();
		}
	}
//-->
</script>
</head>
<body leftmargin="15" onload="javascript:document.form1.firm_nm.focus();">

<form name='form1' action='./s_client_i_a.jsp' method='post'>
<input type='hidden' name='h_page_gubun' value='NEW'><!--���ο� ���� �����Ѵٴ� �ǹ�-->
<table border=0 cellspacing=0 cellpadding=0 width='600'>
  <tr>
    <td><font color="navy">[ �� ��� ]</font></td>
  </tr>
  <tr>
    <td class='line'>            
        <table border="0" cellspacing="1" cellpadding='0' width=600>
          <tr> 
            <td colspan="2" class='title'> ������</td>
            <td colspan='3' align='left'>&nbsp; 
              <select name='client_st'>
                <option value='1'>����</option>
                <option value='2'>����</option>
                <option value='3'>���λ����(�Ϲݰ���)</option>
                <option value='4'>���λ����(���̰���)</option>
                <option value='5'>���λ����(�鼼�����)</option>
              </select>
            </td>
          </tr>
          <tr> 
            <td colspan="2" class='title'>��ȣ</td>
            <td colspan='3'>&nbsp; 
              <input type='text' name='firm_nm' size="50" maxlength='50' class='text' value='' style='IME-MODE: active'>
            </td>
          </tr>
          <tr> 
            <td colspan="2" class='title'>���ε�Ϲ�ȣ</td>
            <td>&nbsp; 
              <input type='text' name='ssn1' value='' size="6" class='text' maxlength='6'>
              - 
              <input type='text' name='ssn2' size="7" class='text' maxlength='7' value=''>
            </td>
            <td class="title">����ڵ�Ϲ�ȣ</td>
            <td>&nbsp; 
              <input type='text' name='enp_no1' value='' size='3' class='text' maxlength='3'>
              - 
              <input type='text' name='enp_no2' value='' size='2' class='text' maxlength='2'>
              - 
              <input type='text' name='enp_no3' value='' size='5' class='text' maxlength='5'>
            </td>
          </tr>
          <tr> 
            <td rowspan="3" class='title'>��ǥ<br>
              �̻� </td>
            <td width='100' class='title'>����</td>
            <td width='179'>&nbsp; 
              <input type='text' name='client_nm' value='' size='20' maxlength='30' class='text' style='IME-MODE: active'>
            </td>
            <td width='126' class="title">�ֹι�ȣ</td>
            <td width='148'>&nbsp;  
              <input type='text' name="c_ssn1" value='' size="6" class='text' maxlength='6'>
              - 
              <input type='text' name='c_ssn2' size="7" class='text' maxlength='7' value=''>
            </td>
          </tr>
          <tr> 
            <td class='title'>������ȭ��ȣ</td>
            <td>&nbsp;  
              <input type='text' name='h_tel' value='' size='15' maxlength='15' class='text'>
              </td>
            <td class="title">�ڵ���</td>
            <td>&nbsp;  
              <input type='text' name='m_tel' value='' size='15' maxlength='15' class='text'>
            </td>
          </tr>
		  <script src="https://t1.daumcdn.net/mapjsapi/bundle/postcode/prod/postcode.v2.js"></script>
				<script>
					function openDaumPostcode() {
						new daum.Postcode({
							oncomplete: function(data) {
								document.getElementById('zip').value = data.zonecode;
								document.getElementById('addr').value = data.roadAddress;
								
							}
						}).open();
					}
				</script>
          <tr> 
            <td class='title'>�ּ�</td>
            <td colspan='3'>&nbsp; 
			<input type="text" name='zip' id="zip" size="7" maxlength='7'>
			<input type="button" onclick="openDaumPostcode()" value="�����ȣ ã��"><br>
			&nbsp;&nbsp;<input type="text" name='addr' id="addr" size="50">
            </td>
          </tr>
          <tr> 
            <td colspan="2" class='title'>�繫����ȭ��ȣ</td>
            <td width="179">&nbsp; 
              <input type='text' name='o_tel' value='' size='15' maxlength='15' class='text'>
            </td>
            <td class='title' width="126">�ѽ���ȣ</td>
            <td width="148">&nbsp; 
              <input type='text' name='fax' value='' size='15' maxlength='15' class='text'>
            </td>
          </tr>
          <tr> 
            <td colspan="2" class='title'>Ȩ������</td>
            <td colspan='3'>&nbsp; 
              <input type='text' name='homepage' value='http://' size='58' maxlength='60' class='text' style='IME-MODE: inactive'>
            </td>
          </tr>
		  <script>
			function openDaumPostcode1() {
				new daum.Postcode({
					oncomplete: function(data) {
						document.getElementById('zip1').value = data.zonecode;
						document.getElementById('addr1').value = data.roadAddress;
						
					}
				}).open();
			}
		</script>
          <tr> 
            <td colspan="2" class='title'>����������</td>
            <td colspan="3">&nbsp; 
              <input type="text" name='zip' id="zip1" size="7" maxlength='7'>
			<input type="button" onclick="openDaumPostcode1()" value="�����ȣ ã��"><br>
			&nbsp;&nbsp;<input type="text" name='addr' id="addr1" size="50">
            </td>
          </tr>
		  <script>
			function openDaumPostcode2() {
				new daum.Postcode({
					oncomplete: function(data) {
						document.getElementById('zip2').value = data.zonecode;
						document.getElementById('addr2').value = data.roadAddress;
						
					}
				}).open();
			}
		</script>
          <tr> 
            <td height="26" colspan="2" class='title'>������ּ�</td>
            <td colspan="3" height="26">&nbsp; 
              <input type="text" name='zip' id="zip2" size="7" maxlength='7'>
			<input type="button" onclick="openDaumPostcode2()" value="�����ȣ ã��"><br>
			&nbsp;&nbsp;<input type="text" name='addr' id="addr2" size="50">
              <input type='checkbox' name='c_ho' onClick='javascript:set_o_addr()'>
              ������</td>
          </tr>
          <tr> 
            <td colspan="2" class='title'>����</td>
            <td colspan='3'>&nbsp; 
              <input type='text' name='bus_cdt' size='40' class='text' maxlength='40' value="" style='IME-MODE: active'>
            </td>
          </tr>
          <tr> 
            <td colspan="2" class='title'>����</td>
            <td colspan='3'>&nbsp; 
              <input type='text' name='bus_itm' size='40' class='text' maxlength='40' value="">
            </td>
          </tr>
          <tr> 
            <td colspan="2" class='title'>���������</td>
            <td colspan='3'>&nbsp; 
              <input type='text' name='open_year' size='12' class='text' maxlength='12' onBlur='javascript:this.value=ChangeDate(this.value)' value="">
            </td>
          </tr>
          <tr> 
            <td colspan="2" class='title'>�ں���/������</td>
            <td colspan='3'>&nbsp; 
              <input type='text' name='firm_price' size='10' class='num' maxlength='20' onBlur='javascript:this.value=parseDecimal2(this.value);' value="">
              �鸸�� &nbsp;/ 
              <input type='text' name='firm_day' size='12' class='text' maxlength='12' onBlur='javascript:this.value=ChangeDate(this.value)' value="">
            </td>
          </tr>
          <tr> 
            <td colspan="2" class='title'>������/������</td>
            <td colspan='3'>&nbsp; 
              <input type='text' name='firm_price_y' size='10' class='num' maxlength='40' onBlur='javascript:this.value=parseDecimal2(this.value);' value="">
              �鸸�� /&nbsp; 
              <input type='text' name='firm_day_y' size='12' class='text' maxlength='12' onBlur='javascript:this.value=ChangeDate(this.value)' value="">
            </td>
          </tr>
        </table>
	</td>
  </tr>
  <tr height="30">
	  <td align='right'><a href='javascript:save()' onMouseOver="window.status=''; return true"><img src="../images/bbs/but_in.gif" width="50" height="18" aligh="absmiddle" border="0"></a> 
        &nbsp;&nbsp;<a href='javascript:history.go(-1);'><img src="../images/bbs/but_backgo.gif" width="70" height="18" aligh="absmiddle" border="0"></a> 
      </td>
  </tr>
</table>
</form>
<iframe src="about:blank" name="i_no" width="110" height="110" cellpadding="0" cellspacing="0" border="1" frameborder="0" noresize></iframe>
</body>
</html>