<%@ page language="java" contentType="text/html;charset=euc-kr" %>
<%@ page import="java.util.*"%>
<%@ include file="/acar/cookies.jsp" %>

<html>
<head>
<title>FMS</title>
<link rel=stylesheet type="text/css" href="/include/table_t.css">
<script language='JavaScript' src='/include/common.js'></script>
<script language='javascript'>
<!--
	//�����ȣ �˻�
	function search_zip(str){
		window.open("/acar/car_rent/zip_s.jsp?idx="+str, "ZIP", "left=100, top=100, height=500, width=400, scrollbars=yes");
	}
		
	//������ּ� ���� ��	
	function set_o_addr(){
		var fm = document.form1;
		if(fm.c_ho.checked == true){
			fm.t_zip[1].value = fm.t_zip[0].value;
			fm.t_addr[1].value = fm.t_addr[0].value;
		}else{
			fm.t_zip[1].value = '';
			fm.t_addr[1].value = '';
		}
	}
	
	function save(){
		var fm = document.form1;	
		//NN check
		if(fm.t_firm_nm.value == '')		{	alert('��ȣ�� �Է��Ͻʽÿ�');		return;	}
		if(fm.t_client_nm.value == '')		{	alert('������ �Է��Ͻʽÿ�');		return;	}	
				
		if(fm.s_cl_gbn.value == '1'){//����
			if((fm.t_enp_no1.value == '') || (fm.t_enp_no2.value == '') || (fm.t_enp_no3.value == '')){ alert('����ڵ�Ϲ�ȣ�� �Է��Ͻʽÿ�'); return; }
			else if(fm.t_addr[0].value == '')	{ alert('���� �������� �Է��Ͻʽÿ�'); 	return; }
			else if(fm.t_addr[1].value == '')	{ alert('����� �ּҸ� �Է��Ͻʽÿ�'); 	return; }
			else if(fm.t_cdt.value == '')		{ alert('���¸� �Է��Ͻʽÿ�'); 		return; }
			else if(fm.t_itm.value == '')		{ alert('���� �Է��Ͻʽÿ�'); 		return; }			
		}else if(fm.s_cl_gbn.value == '2'){//����
			if((fm.t_ssn1.value == '') || (fm.t_ssn2.value == '')){	alert('�ֹε�Ϲ�ȣ�� �Է��Ͻʽÿ�'); return; }
		}else{
			if(fm.t_ssn1.value == '')			{	alert('��������� �Է��Ͻʽÿ�');			return;	}	
		}		
			
		if(fm.email_1.value != '' && fm.email_2.value != ''){
			fm.con_agnt_email.value = fm.email_1.value+'@'+fm.email_2.value;
		}
		
		if(confirm('����Ͻðڽ��ϱ�?')){
			fm.target='i_no';
			fm.submit();
		}
	}

//-->
</script>
</head>

<body leftmargin="15" onload="javascript:document.form1.t_firm_nm.focus();">
<form name='form1' action='client_i_a.jsp' method='post'>
<input type='hidden' name='h_map' value=''>
<input type='hidden' name='h_page_gubun' value='NEW'><!--���ο� ���� �����Ѵٴ� �ǹ�-->
<table border=0 cellspacing=0 cellpadding=0 width='100%'>
    <tr> 
        <td colspan=2>
            <table width=100% border=0 cellpadding=0 cellspacing=0>
                <tr>
                    <td width=7><img src=../images/center/menu_bar_1.gif width=7 height=33></td>
                    <td class=bar>&nbsp;&nbsp;&nbsp;<img src=../images/center/menu_bar_dot.gif width=4 height=5 align=absmiddle>&nbsp;<span class=style1>������������ > ������ > ����� > <span class=style5>�����</span></span></td>
                    <td width=7><img src=../images/center/menu_bar_2.gif width=7 height=33></td>
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
        <td class='line'>            
            <table border="0" cellspacing="1" cellpadding='0' width=100%>
                <tr> 
                    <td class='title'> ������</td>
                    <td colspan='3' align='left'>&nbsp; 
                      <select name='s_cl_gbn'>
                        <option value='1'>����</option>
                        <option value='2'>����</option>
                        <option value='3'>���λ����(�Ϲݰ���)</option>
                        <option value='4'>���λ����(���̰���)</option>
                        <option value='5'>���λ����(�鼼�����)</option>
        				<option value='7'>��ŸŰ�</option>
                      </select>
                    </td>
                </tr>
                <tr> 
                    <td class='title'>��ȣ</td>
                    <td colspan='3'>&nbsp; 
                      <input type='text' name='t_firm_nm' size="30" maxlength='80' class='text' value=''>
                    </td>
                </tr>
                <tr> 
                    <td class='title'>�̸�/��ǥ</td>
                    <td>&nbsp; 
                      <input type='text' name='t_client_nm' value='' size='20' maxlength='80' class='text' style='IME-MODE: active'>
                    </td>
                    <td class='title'>����</td>
                    <td>&nbsp; 
                      <select name='nationality'>
                		            <option value="">����</option>
                		            <option value="1">������</option>
                		            <option value="2">�ܱ���</option>
                		          </select>
                		          (�����϶�)
                    </td>
                </tr>
                <tr> 
                    <td class='title' >�ֹ�(����)��Ϲ�ȣ</td>
                    <td colspan='3'>&nbsp; 
                      <input type='text' name='t_ssn1' value='' size="6" class='text' maxlength='6'>
                      - 
                      <input type='text' name='t_ssn2' size="7" class='text' maxlength='7' value=''>
                    </td>
                </tr>
                <tr> 
                    <td class='title' height="2">����ڵ�Ϲ�ȣ</td>
                    <td colspan='3' height="2">&nbsp; 
                      <input type='text' name='t_enp_no1' value='' size='3' class='text' maxlength='3'>
                      - 
                      <input type='text' name='t_enp_no2' value='' size='2' class='text' maxlength='2'>
                      - 
                      <input type='text' name='t_enp_no3' value='' size='5' class='text' maxlength='5'>
                    </td>
                </tr>
                <tr> 
                    <td class='title' width=22%>TEL(����)</td>
                    <td width=28%>&nbsp; 
                      <input type='text' name='t_h_tel' value='' size='15' maxlength='15' class='text'>
                    </td>
                    <td class='title' width=22%>TEL(�繫��)</td>
                    <td width=28%>&nbsp; 
                      <input type='text' name='t_o_tel' value='' size='15' maxlength='15' class='text'>
                    </td>
                </tr>
                <tr> 
                    <td class='title'>�޴���</td>
                    <td>&nbsp; 
                      <input type='text' name='t_m_tel' value='' size='15' maxlength='15' class='text'>
                    </td>
                    <td class='title'>FAX</td>
                    <td>&nbsp; 
                      <input type='text' name='t_fax' value='' size='15' maxlength='15' class='text'>
                    </td>
                </tr>
                <tr> 
                    <td class='title'>Homepage</td>
                    <td colspan='3'>&nbsp; 
                      <input type='text' name='t_homepage' value='http://' size='30' maxlength='30' class='text' style='IME-MODE: inactive'>
                    </td>
                </tr>
                <tr> 
                    <td class='title'>E-mail</td>
                    <td colspan='3'>&nbsp; 
                      <input type='text' size='15' name='email_1' value='' maxlength='100' class='text' style='IME-MODE: inactive'>@<input type='text' size='20' name='email_2' value='' maxlength='100' class='text' style='IME-MODE: inactive'>
					  <select id="email_domain" align="absmiddle" onChange="javascript:document.form1.email_2.value=this.value;">
						<option value="" selected>�����ϼ���</option>
						<option value="hanmail.net">hanmail.net</option>
						<option value="naver.com">naver.com</option>
						<option value="nate.com">nate.com</option>
						<option value="bill36524.com">bill36524.com</option>
						<option value="gmail.com">gmail.com</option>
						<option value="paran.com">paran.com</option>
						<option value="yahoo.com">yahoo.com</option>
						<option value="korea.com">korea.com</option>
						<option value="hotmail.com">hotmail.com</option>
						<option value="chol.com">chol.com</option>
						<option value="daum.net">daum.net</option>
						<option value="hanafos.com">hanafos.com</option>
						<option value="lycos.co.kr">lycos.co.kr</option>
						<option value="dreamwiz.com">dreamwiz.com</option>
						<option value="unitel.co.kr">unitel.co.kr</option>
						<option value="freechal.com">freechal.com</option>
                        <option value="empal.com">empal.com</option>
						<option value="">���� �Է�</option>
						</select>
						<input type='hidden' name='con_agnt_email' value=''>
                    </td>
                </tr>
				<script src="https://t1.daumcdn.net/mapjsapi/bundle/postcode/prod/postcode.v2.js"></script>
				<script>
					function openDaumPostcode() {
						new daum.Postcode({
							oncomplete: function(data) {
								document.getElementById('t_zip').value = data.zonecode;
								document.getElementById('t_addr').value = data.address +" (" + data.buildingName +")" ;
								
							}
						}).open();
					}
				</script>
				<tr>
				  <td class=title>����������</td>
				  <td colspan=5>&nbsp;
					<input type="text" name="t_zip" id="t_zip" size="7" maxlength='7' value="">
					<input type="button" onclick="openDaumPostcode()" value="�����ȣ ã��"><br>
					&nbsp;&nbsp;<input type="text" name="t_addr" id="t_addr" size="70" value="">
				  </td>
				</tr>

				<script>
					function openDaumPostcode1() {
						new daum.Postcode({
							oncomplete: function(data) {
								document.getElementById('t_zip1').value = data.zonecode;
								document.getElementById('t_addr1').value = data.address +" (" + data.buildingName +")" ;
								
							}
						}).open();
					}
				</script>			
				<tr>
				  <td class=title>������ּ�</td>
				  <td colspan=5>&nbsp;<input type='checkbox' name='c_ho' onClick='javascript:set_o_addr()'>
                      ������
					<input type="text" name="t_zip" id="t_zip1" size="7" maxlength='7' value="">
					<input type="button" onclick="openDaumPostcode1()" value="�����ȣ ã��"><br>
					&nbsp;&nbsp;<input type="text" name="t_addr" id="t_addr1" size="70" value="">
				  </td>
				</tr>
                <tr> 
                    <td class='title'>����</td>
                    <td colspan='3'>&nbsp; 
                      <input type='text' name='t_cdt' size='20' class='text' maxlength='40' value="" style='IME-MODE: active'>
                    </td>
                </tr>
                <tr> 
                    <td class='title'>����</td>
                    <td colspan='3'>&nbsp; 
                      <input type='text' name='t_itm' size='20' class='text' maxlength='40' value="">
                    </td>
                </tr>
                <tr> 
                    <td class='title'>���������</td>
                    <td colspan='3'>&nbsp; 
                      <input type='text' name='t_open_year' size='12' class='text' maxlength='10' onBlur='javascript:this.value=ChangeDate(this.value)' value="">
                    </td>
                </tr>
                
            </table>
	    </td>
    </tr>
    <tr height="30">
	    <td align='right'><a href='javascript:save()' onMouseOver="window.status=''; return true"><img src=../images/center/button_conf.gif align=absmiddle border=0></a> 
        &nbsp;<a href='javascript:history.go(-1);'><img src=../images/center/button_list.gif align=absmiddle border=0></a> 
        </td>
    </tr>
</table>
</form>
<iframe src="about:blank" name="i_no" width="0" height="0" frameborder="0" noresize></iframe>
</body>
</html>