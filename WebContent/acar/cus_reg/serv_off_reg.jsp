<%@ page contentType="text/html; charset=euc-kr" %>
<%@ page language="java" %> 
<%@ page import="java.util.*" %>
<%@ page import="acar.util.*" %>
<%@ page import="acar.pay_mng.*" %>
<%@ include file="/acar/cookies.jsp" %>
<%
//�����縮��Ʈ
	PaySearchDatabase 	ps_db 	= PaySearchDatabase.getInstance();
	Vector bank_vt =  ps_db.getCodeList("0003");
	int bank_size = bank_vt.size();
%>
<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN">
<html>
<head>
<title>FMS</title>
<meta http-equiv="Content-Type" content="text/html; charset=euc-kr">
<link rel=stylesheet type="text/css" href="/include/table_t.css">
<script language='JavaScript' src='/include/common.js'></script>
<script language='javascript'>
<!--
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
	//����ڵ�Ϲ�ȣ üũ
function CheckBizNo() {
	
	var fm = document.form1;

	var strNumb1 = fm.t_ent_no1.value;
    var strNumb2 = fm.t_ent_no2.value;
    var strNumb3 = fm.t_ent_no3.value;

    var strNumb = strNumb1+strNumb2+strNumb3;
    if (strNumb.length != 10) {
        alert("����ڵ�Ϲ�ȣ�� �߸��Ǿ����ϴ�.");
		fm.t_ent_no1.value = '';
		fm.t_ent_no2.value = '';
		fm.t_ent_no3.value = '';
        return ;
    }
    
        sumMod  =   0;
        sumMod  +=  parseInt(strNumb.substring(0,1));
        sumMod  +=  parseInt(strNumb.substring(1,2)) * 3 % 10;
        sumMod  +=  parseInt(strNumb.substring(2,3)) * 7 % 10;
        sumMod  +=  parseInt(strNumb.substring(3,4)) * 1 % 10;
        sumMod  +=  parseInt(strNumb.substring(4,5)) * 3 % 10;
        sumMod  +=  parseInt(strNumb.substring(5,6)) * 7 % 10;
        sumMod  +=  parseInt(strNumb.substring(6,7)) * 1 % 10;
        sumMod  +=  parseInt(strNumb.substring(7,8)) * 3 % 10;
        sumMod  +=  Math.floor(parseInt(strNumb.substring(8,9)) * 5 / 10);
        sumMod  +=  parseInt(strNumb.substring(8,9)) * 5 % 10;
        sumMod  +=  parseInt(strNumb.substring(9,10));
    
    if (sumMod % 10  !=  0) {
        alert("�߸��� ����� ��Ϲ�ȣ �Դϴ�.");
		fm.t_ent_no1.value = '';
		fm.t_ent_no2.value = '';
		fm.t_ent_no3.value = '';
        return ;
    }
        alert("�ùٸ� ����� ��Ϲ�ȣ �Դϴ�.");
    	return ;
}
-->
</script>
</head>

<body onload="javascript:document.form1.car_comp_id.focus();">
<form name='form1' action='cus_reg_serv_off_i_a.jsp' method='post'>
<input type='hidden' name='h_map' value=''>
<input type='hidden' name='h_page_gubun' value='NEW'><!--���ο� ���� �����Ѵٴ� �ǹ�-->
<table width=100% border="0" cellspacing="0" cellpadding="0">
    <tr>
    	<td>
    	    <table width=100% border=0 cellpadding=0 cellspacing=0>
                <tr>
                    <td width=7><img src=/acar/images/center/menu_bar_1.gif width=7 height=33></td>
                    <td class=bar>&nbsp;&nbsp;&nbsp;<img src=/acar/images/center/menu_bar_dot.gif width=4 height=5 align=absmiddle>&nbsp;<span class=style1>������ > ���������� > <span class=style5>�����ü���</span></span></td>
                    <td width=7><img src=/acar/images/center/menu_bar_2.gif width=7 height=33></td>
                </tr>
            </table>
    	</td>
    </tr>
    <tr>
        <td class=h></td>
    </tr>
    <tr> 
        <td align=right colspan=2><a href='javascript:save()' onMouseOver="window.status=''; return true"><img src=/acar/images/center/button_reg.gif align="absmiddle" border="0"></a> 
        &nbsp;<a href='javascript:history.go(-1);'><img src=/acar/images/center/button_list.gif align="absmiddle" border="0"></a></td>
    </tr>
    <tr>
        <td class=line2></td>
    </tr>
    <tr> 
        <td class="line">
            <table width=100% border="0" cellspacing="1" cellpadding="0">
                <tr> 
                    <td width=20% class="title">������ü</td>
                    <td>&nbsp;<select name='car_comp_id'>
                        <option value="0001">�����ڵ���</option>
                        <option value="0002">����ڵ���</option>
                        <option value="0003">�����ڸ����ڵ���</option>
                        <option value="0004">�ѱ�����</option>
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
                    <td>&nbsp;<input type='text' name='off_nm' size="30" maxlength='30' class='text' value='' style='IME-MODE: active'></td>
                </tr>
                <tr> 
                    <td height="22" class="title">�޼�</td>
                    <td>&nbsp;<select name='off_st'>
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
                    <td>&nbsp;<input type='text' name='own_nm' size="30" maxlength='30' class='text' value='' style='IME-MODE: active'></td>
                </tr>
                <tr> 
                    <td class="title">����ڹ�ȣ</td>
                    <td>&nbsp;<input type='text' name='t_ent_no1' value='' size='3' class='text' maxlength='3'>
                      - 
                      <input type='text' name='t_ent_no2' value='' size='2' class='text' maxlength='2'>
                      - 
                      <input type='text' name='t_ent_no3' value='' size='5' class='text' maxlength='5' OnBlur="CheckBizNo();"></td>
                </tr>
                <tr> 
                    <td class="title">����</td>
                    <td>&nbsp;<input type='text' name='off_sta' size="30" maxlength='30' class='text' value='' style='IME-MODE: active'></td>
                </tr>
                <tr> 
                    <td class="title">����</td>
                    <td>&nbsp;<input type='text' name='off_item' size="30" maxlength='30' class='text' value='' style='IME-MODE: active'></td>
                </tr>
                <tr> 
                    <td class="title">�繫����ȭ��ȣ</td>
                    <td>&nbsp;<input type='text' name='off_tel' size="30" maxlength='30' class='text' value=''></td>
                </tr>
                <tr> 
                    <td class="title">�ѽ���ȣ</td>
                    <td>&nbsp;<input type='text' name='off_fax' size="30" maxlength='30' class='text' value=''></td>
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
                    <td>&nbsp;
					<input type="text" name='t_zip' id="t_zip" value="" size="7" maxlength='7'>
					<input type="button" onclick="openDaumPostcode()" value="�����ȣ ã��"><br>
					&nbsp;&nbsp;<input type="text" name='t_addr' id="t_addr" value="" size="50">
                </tr>
                <tr> 
                    <td class="title">���°�������</td>
					<td>&nbsp;<select name='bank'>
						<option value=''>����</option>
						<%	for(int i = 0 ; i < bank_size ; i++){
										Hashtable bank_ht = (Hashtable)bank_vt.elementAt(i);
										%>
						<option value='<%= bank_ht.get("NM")%>' ><%= bank_ht.get("NM")%></option>
						<%	}%>
					  </select></td>
 <!--                   <td>&nbsp;<input type='text' name='bank' size="30" maxlength='30' class='text' value='' style='IME-MODE: active'></td> -->
                </tr>
                <tr> 
                    <td class="title">���¹�ȣ</td>
                    <td>&nbsp;<input type='text' name='acc_no' size="30" maxlength='30' class='text' value=''></td>
                </tr>
                <tr> 
                    <td class="title">������</td>
                    <td>&nbsp;<input type='text' name='acc_nm' size="30" maxlength='30' class='text' value='' style='IME-MODE: active'></td>
                </tr>
                <tr> 
                    <td class="title">���</td>
                    <td>&nbsp;<textarea  class="textarea" name="note" cols="63" rows="2"  style='IME-MODE: active'></textarea></td>
                </tr>
            </table>
        </td>
    </tr>
</table>
</form>
<iframe src="about:blank" name="i_no" width="0" height="0" frameborder="0" noresize></iframe>
</body>
</html>
