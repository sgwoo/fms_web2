<%@ page language="java" contentType="text/html;charset=euc-kr" %>
<html>
<head><title>FMS</title>
<script language='javascript' src='/include/common.js'></script>
<script language='javascript'>
<!--
	function save()
	{
		if(confirm('����Ͻðڽ��ϱ�?'))
		{
			var fm = document.form1;
			if(fm.firm_nm.value == ''){			alert('��ȣ�� �Է��Ͻʽÿ�');	return;	}
			else if(fm.client_nm.value == ''){	alert('����ڸ� �Է��Ͻʽÿ�');	return;	}
			else if((!isNum(fm.ssn1.value)) || (!isNum(fm.ssn2.value)) || ((fm.ssn1.value.length != 6)&&(fm.ssn1.value.length != 0)) || ((fm.ssn2.value.length != 7)&&(fm.ssn2.value.length != 0)))	{	alert('�ֹε�Ϲ�ȣ(���ι�ȣ)�� Ȯ���Ͻʽÿ�');	return;	}
			else if((!isNum(fm.enp_no1.value)) || (!isNum(fm.enp_no2.value)) || (!isNum(fm.enp_no3.value))|| ((fm.enp_no1.value.length != 3)&&(fm.enp_no1.value.length != 0)) || ((fm.enp_no2.value.length != 2)&&(fm.enp_no2.value.length != 0)) || ((fm.enp_no3.value.length != 5)&&(fm.enp_no3.value.length != 0)))	{	alert('����ڵ�Ϲ�ȣ�� Ȯ���Ͻʽÿ�');	return;	}
			else if(!isTel(fm.h_tel.value))	{	alert('������ȭ��ȣ�� Ȯ���Ͻʽÿ�');	return;	}
			else if(!isTel(fm.o_tel.value))	{	alert('ȸ����ȭ��ȣ�� Ȯ���Ͻʽÿ�');	return;	}
			else if(!isTel(fm.m_tel.value))	{	alert('�޴�����ȣ�� Ȯ���Ͻʽÿ�');	return;	}
			else if(!isTel(fm.fax.value))	{	alert('�ѽ���ȣ�� Ȯ���Ͻʽÿ�');	return;	}
			else if(!isTel(fm.con_agnt_o_tel.value)){	alert('������ȭ��ȣ�� Ȯ���Ͻʽÿ�');	return;	}
			else if(!isTel(fm.con_agnt_m_tel.value)){	alert('ȸ����ȭ��ȣ�� Ȯ���Ͻʽÿ�');	return;	}
			else if(!isTel(fm.con_agnt_fax.value)){	alert('�޴�����ȣ�� Ȯ���Ͻʽÿ�');	return;	}
			
			fm.target='i_no';
			fm.submit();
		}
	}

	function search_zip(str)
	{
		window.open("/acar/common/zip_s.jsp?idx="+str, "ZIP", "left=100, top=100, height=500, width=400, scrollbars=yes");
	}	
	
	function set_o_addr()
	{
		var fm = document.form1;
		if(fm.c_ho.checked == true)
		{
			fm.t_zip[1].value = fm.t_zip[0].value;
			fm.t_addr[1].value = fm.t_addr[0].value;
		}
		else
		{
			fm.t_zip[1].value = '';
			fm.t_addr[1].value = '';
		}
	}	
-->
</script>
<link rel=stylesheet type="text/css" href="../../include/table.css">
</head>
<body>
<form name='form1' method='post' action='/acar/mng_client2/client_i_a.jsp'>
<table border="0" cellspacing="0" cellpadding="0" width=800>
	<tr>
		
      <td> <font color="navy">�������� -> </font><font color="red">���ǸŰ� 
        ������</font></td>
	</tr>
	<tr>
		<td align='right'> <a href="javascript:save()"><img src="/images/reg.gif" width="50" height="18" aligh="absmiddle" border="0"></a></td>
	</tr>	

	<tr>
	<td class='line'>
		 
        <table border="0" cellspacing="1" cellpadding="0" width=800>
          <tr> 
            <td class='title' width='100'> ����</td>
            <td width='170'> &nbsp; 
              <select name='client_st'>
                <option value='1'> ���� </option>
                <option value='2'> ���� </option>
                <option value='3'> ���λ����(�Ϲݰ���) </option>
                <option value='4'> ���λ����(���̰���) </option>
                <option value='5'>���λ����(�鼼�����)</option>
              </select>
            </td>
            <td class='title' width='100'>��ȣ</td>
            <td width='170' align='left'>&nbsp; 
              <input type='text' name='firm_nm' size='20' maxlength='40' class='text' style='IME-MODE: active'>
            </td>
            <td class='title' width='100'>�����</td>
            <td>&nbsp; 
              <input type='text' size='15' name='client_nm' maxlength='40' class='text'>
            </td>
          </tr>
          <tr> 
            <td class='title'>�ֹε�Ϲ�ȣ<br/>
              (���ι�ȣ)</td>
            <td>&nbsp; 
              <input type='text' size='6' name='ssn1' maxlength='6' class='text'>
              - 
              <input type='text' name='ssn2' maxlength='7' size='7' class='text'>
            </td>
            <td class='title' width='100'>����ڵ�Ϲ�ȣ</td>
            <td>&nbsp; 
              <input type='text' size='3' name='enp_no1' maxlength='3' class='text'>
              - 
              <input type='text' size='2' name='enp_no2' maxlength='2' class='text'>
              - 
              <input type='text' size='5' name='enp_no3' maxlength='5' class='text'>
            </td>
            <td class='title' width='80'>�������뵵</td>
            <td>&nbsp; 
              <input type='text' size='10' name='car_use' value='' maxlength='10' class='text'>
            </td>
          </tr>
          <tr> 
            <td class='title'>�����</td>
            <td>&nbsp; 
              <input type='text' size='20' name='com_nm' maxlength='20' class='text'>
            </td>
            <td class='title'>�ٹ��μ�</td>
            <td>&nbsp; 
              <input type='text' size='15' name='dept' maxlength='15' class='text'>
            </td>
            <td class='title'>����</td>
            <td>&nbsp; 
              <input type='text' size='10' name='title' maxlength='10' class='text'>
            </td>
          </tr>
          <tr> 
            <td class='title'>������ȭ��ȣ</td>
            <td>&nbsp; 
              <input type='text' size='15' name='h_tel' maxlength='15' class='text'>
            </td>
            <td class='title'>ȸ����ȭ��ȣ</td>
            <td>&nbsp; 
              <input type='text' size='15' name='o_tel' maxlength='15' class='text'>
            </td>
            <td class='title'>�޴���</td>
            <td>&nbsp; 
              <input type='text' size='15' name='m_tel' maxlength='15' class='text'>
            </td>
          </tr>
          <tr> 
            <td class='title'>FAX</td>
            <td>&nbsp; 
              <input type='text' size='15' name='fax' maxlength='15' class='text'>
            </td>
            <td class='title'>Homepage</td>
            <td colspan='3'>&nbsp; 
              <input type='text' size='50' name='homepage' value='' maxlength='70' class='text' style='IME-MODE: inactive'>
            </td>
          </tr>
		  <script src="https://t1.daumcdn.net/mapjsapi/bundle/postcode/prod/postcode.v2.js"></script>
			<script>
				function openDaumPostcode() {
					new daum.Postcode({
						oncomplete: function(data) {
							document.getElementById('t_zip').value = data.zonecode;
							document.getElementById('t_addr').value = data.roadAddress;
							
						}
					}).open();
				}
			</script>
          <tr> 
            <td class='title'>���������� �ּ�</td>
            <td colspan='5'> &nbsp; 
			<input type="text" name='t_zip' id="t_zip" size="7" maxlength='7'>
			<input type="button" onclick="openDaumPostcode()" value="�����ȣ ã��"><br>
			&nbsp;&nbsp;<input type="text" name='t_addr' id="t_addr"  size="50">
            </td>
          </tr>
		  <script>
				function openDaumPostcode2() {
					new daum.Postcode({
						oncomplete: function(data) {
							document.getElementById('t_zip2').value = data.zonecode;
							document.getElementById('t_addr2').value = data.roadAddress;
							
						}
					}).open();
				}
			</script>
          <tr> 
            <td class='title'>����� �ּ�</td>
            <td colspan='5'> &nbsp; 
              <input type="text" name='t_zip' id="t_zip2" size="7" maxlength='7'>
			<input type="button" onclick="openDaumPostcode2()" value="�����ȣ ã��"><br>
			&nbsp;&nbsp;<input type="text" name='t_addr' id="t_addr2"  size="50">
              <input type='checkbox' name='c_ho' onClick='javascript:set_o_addr()'>
              ��</td>
          </tr>
          <tr> 
            <td class='title'>����</td>
            <td>&nbsp; 
              <input type='text' size='20' name='bus_cdt' maxlength='40' class='text'>
            </td>
            <td class='title'>����</td>
            <td>&nbsp; 
              <input type='text' size='20' name='bus_itm' value='' maxlength='40' class='text'>
            </td>
            <td class='title'>���������</td>
            <td>&nbsp; 
              <input type='text' name='t_open_year' size='12' class='text' maxlength='10' onBlur='javascript:this.value=ChangeDate(this.value)' value="">
            </td>
          </tr>
          <tr> 
            <td class='title'>�ں���/������</td>
            <td>&nbsp; 
              <input type='text' name='t_firm_price' size='7' class='num' maxlength='20' onBlur='javascript:this.value=parseDecimal2(this.value);' value="">
              �鸸�� 
              <input type='text' name='t_firm_day' size='12' class='text' maxlength='10' onBlur='javascript:this.value=ChangeDate(this.value)' value="">
            </td>
            <td class='title'>������/������</td>
            <td colspan="3">&nbsp; 
              <input type='text' name='t_firm_price_y' size='7' class='num' maxlength='40' onBlur='javascript:this.value=parseDecimal2(this.value);' value="">
              �鸸�� 
              <input type='text' name='t_firm_day_y' size='12' class='text' maxlength='10' onBlur='javascript:this.value=ChangeDate(this.value)' value="">
            </td>
          </tr>
          <tr> 
            <td class='title' rowspan='2'>���������</td>
            <td colspan='5'> &nbsp�̸�: 
              <input type='text' size='15' name='con_agnt_nm' maxlength='20' class='text'>
              &nbsp;�繫��: 
              <input type='text' size='15' name='con_agnt_o_tel' maxlength='15' class='text'>
              &nbsp;�̵���ȭ: 
              <input type='text' size='15' name='con_agnt_m_tel' maxlength='15' class='text'>
              &nbsp;FAX: 
              <input type='text' size='15' name='con_agnt_fax' maxlength='15' class='text'>
            </td>
          </tr>
          <tr> 
            <td colspan='5'>&nbsp;EMAIL: 
              <input type='text' size='20' name='con_agnt_email' maxlength='30' class='text' style='IME-MODE: inactive'>
              &nbsp;�ٹ��μ�: 
              <input type='text' size='20' name='con_agnt_dept' maxlength='15' class='text' style='IME-MODE: inactive'>
              &nbsp;����: 
              <input type='text' size='20' name='con_agnt_title' maxlength='10' class='text'>
            </td>
          </tr>
          <tr> 
            <td class='title'> Ư�̻��� </td>
            <td colspan='5'>&nbsp; 
              <textarea name='etc' rows='5' cols='100' maxlenght='500'></textarea>
            </td>
          </tr>
        </table>
	</td>
	</tr>
</table>
</form>
<iframe src="about:blank" name="i_no" width="0" height="0" frameborder="0" noresize>
</iframe>
</body>
</html>
