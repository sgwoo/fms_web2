<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN">
<html>
<head>
<title>FMS</title>
<meta http-equiv="Content-Type" content="text/html; charset=euc-kr">
<link rel=stylesheet type="text/css" href="../../include/table.css">
<script language='JavaScript' src='/include/common.js'></script>
<script language='javascript'>
<!--
	//�����ȣ �˻�
	function search_zip(str){
		window.open("/acar/car_rent/zip_s.jsp?idx="+str, "ZIP", "left=100, top=100, height=500, width=400, scrollbars=yes");
	}
	
	function save(){
		var fm = document.form1;	
		//NN check
		if(fm.off_nm.value == '')			{	alert('��ȣ�� �Է��Ͻʽÿ�');		return;	}
		else if(fm.own_nm.value == '')		{	alert('��ǥ�ڸ� �Է��Ͻʽÿ�');		return;	}			
		else if((fm.t_ent_no1.value == '') || (fm.t_ent_no2.value == '') || (fm.t_ent_no3.value == '')){ alert('����ڹ�ȣ�� �Է��Ͻʽÿ�'); return; }
		else if(fm.off_sta.value == '')		{ alert('���¸� �Է��Ͻʽÿ�'); 		return; }
		else if(fm.off_item.value == '')		{ alert('������ �Է��Ͻʽÿ�'); 		return; }
		else if(fm.off_tel.value == '')	{ alert('�繫����ȭ��ȣ�� �Է��Ͻʽÿ�'); 	return; }
		else if(fm.t_addr.value == '')	{ alert('�ּҸ� �Է��Ͻʽÿ�'); 	return; }
					
		if(confirm('����Ͻðڽ��ϱ�?')){
			fm.target='i_no';
			fm.submit();
		}
	}

-->
</script>
</head>

<body onload="javascript:document.form1.car_comp_id.focus();">
<form name='form1' action='./cus0401_d_sc_serv_off_i_a.jsp' method='post'>
<input type='hidden' name='h_map' value=''>
<input type='hidden' name='h_page_gubun' value='NEW'><!--���ο� ���� �����Ѵٴ� �ǹ�-->
  <table width="500" border="0" cellspacing="1" cellpadding="0">
    <tr> 
      <td width="380"><font color="navy">������ -> ���������� </font>-> <font color="red">�����ü��� 
        </font></td>
      <td width="120"><a href='javascript:save()' onMouseOver="window.status=''; return true"><img src="/images/reg.gif" width="50" height="18" aligh="absmiddle" border="0"></a> 
        &nbsp;<a href='javascript:history.go(-1);'><img src="/images/list.gif" width="50" height="18" aligh="absmiddle" border="0"></a></td>
    </tr>
    <tr> 
      <td colspan="2" class="line"><table width="500" border="0" cellspacing="1" cellpadding="0">
          <tr> 
            <td width="100" class="title">������ü</td>
            <td width="400"><select name='car_comp_id'>
                <option value="0001">�����ڵ���</option>
                <option value="0002">����ڵ���</option>
                <option value="0003">����Ｚ�ڵ���</option>
                <option value="0004">�ѱ�GM</option>
                <option value="0005">�ֿ��ڵ���</option>
                <option value="0006">����</option>
                <option value="0007">����Ÿ</option>
                <option value="0009">��Ÿ</option>
                <option value="0011">�����ٰ�</option>
                <option value="0012">ũ���̽���</option>
                <option value="0013">BMW</option>
              </select></td>
          </tr>
          <tr> 
            <td class="title">��ȣ</td>
            <td><input type='text' name='off_nm' size="30" maxlength='30' class='text' value='' style='IME-MODE: active'></td>
          </tr>
          <tr> 
            <td height="22" class="title">�޼�</td>
            <td><select name='off_st'>
                <option value="1">1��</option>
                <option value="2">2��</option>
                <option value="3">3��</option>
                <option value="4">4��</option>
                <option value="5">5��</option>
                <option value="6">��Ÿ</option>
              </select></td>
          </tr>
          <tr> 
            <td class="title">��ǥ��</td>
            <td><input type='text' name='own_nm' size="30" maxlength='30' class='text' value='' style='IME-MODE: active'></td>
          </tr>
          <tr> 
            <td class="title">����ڹ�ȣ</td>
            <td><input type='text' name='t_ent_no1' value='' size='3' class='text' maxlength='3'>
              - 
              <input type='text' name='t_ent_no2' value='' size='2' class='text' maxlength='2'>
              - 
              <input type='text' name='t_ent_no3' value='' size='5' class='text' maxlength='5'></td>
          </tr>
          <tr> 
            <td class="title">����</td>
            <td><input type='text' name='off_sta' size="30" maxlength='30' class='text' value='' style='IME-MODE: active'></td>
          </tr>
          <tr> 
            <td class="title">����</td>
            <td><input type='text' name='off_item' size="30" maxlength='30' class='text' value='' style='IME-MODE: active'></td>
          </tr>
          <tr> 
            <td class="title">�繫����ȭ��ȣ</td>
            <td><input type='text' name='off_tel' size="30" maxlength='30' class='text' value=''></td>
          </tr>
          <tr> 
            <td class="title">�ѽ���ȣ</td>
            <td><input type='text' name='off_fax' size="30" maxlength='30' class='text' value=''></td>
          </tr>
          <tr> 
            <td height="22" class="title">Ȩ������</td>
            <td><input type='text' name='homepage' size="30" maxlength='30' class='text' value='http://'></td>
          </tr>
		  <script src="https://t1.daumcdn.net/mapjsapi/bundle/postcode/prod/postcode.v2.js"></script>
			<script>
				function openDaumPostcode() {
					new daum.Postcode({
						oncomplete: function(data) {
							document.getElementById('t_zip').value = data.zonecode;
							document.getElementById('t_addr').value = data.address;
							
						}
					}).open();
				}
			</script>
          <tr> 
            <td class="title">�ּ�</td>
            <td><input type="text" name='t_zip' id="t_zip" size="7" maxlength='7'>
								<input type="button" onclick="openDaumPostcode()" value="�����ȣ ã��"><br>
								&nbsp;&nbsp;<input type="text" name='t_addr' id="t_addr" size="50"></td>
          </tr>
          <tr> 
            <td class="title">���°�������</td>
            <td><input type='text' name='bank' size="30" maxlength='30' class='text' value='' style='IME-MODE: active'></td>
          </tr>
          <tr> 
            <td class="title">���¹�ȣ</td>
            <td><input type='text' name='acc_no' size="30" maxlength='30' class='text' value=''></td>
          </tr>
          <tr> 
            <td class="title">������</td>
            <td><input type='text' name='acc_nm' size="30" maxlength='30' class='text' value='' style='IME-MODE: active'></td>
          </tr>
          <tr> 
            <td class="title">���</td>
            <td><textarea  class="textarea" name="note" cols="63" rows="2"  style='IME-MODE: active'></textarea></td>
          </tr>
        </table></td>
    </tr>
  </table>
</form>
<iframe src="about:blank" name="i_no" width="0" height="0" frameborder="0" noresize></iframe>
</body>
</html>
