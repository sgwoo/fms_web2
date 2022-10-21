<%@ page language="java" contentType="text/html;charset=euc-kr" %>
<%@ page import="java.util.*"%>
<%@ page import="acar.util.*"%>
<jsp:useBean id="rs_db" scope="page" class="acar.res_search.ResSearchDatabase"/>
<%@ include file="/acar/cookies.jsp" %>

<%
	String auth_rw = request.getParameter("auth_rw")==null?"":request.getParameter("auth_rw");
	String br_id = request.getParameter("br_id")==null?"":request.getParameter("br_id");
	String user_id = request.getParameter("user_id")==null?"":request.getParameter("user_id");
	
	String s_kd = request.getParameter("s_kd")==null?"":request.getParameter("s_kd");
	String t_wd = request.getParameter("t_wd")==null?"":request.getParameter("t_wd");
	String asc = request.getParameter("asc")==null?"0":request.getParameter("asc");
	
	//�α���ID&������ID
	LoginBean login = LoginBean.getInstance();
	if(user_id.equals("")) 	user_id = login.getCookieValue(request, "acar_id");
	if(br_id.equals(""))	br_id = login.getCookieValue(request, "acar_br");
	if(auth_rw.equals(""))	auth_rw = rs_db.getAuthRw(user_id, "01", "03", "01");
%>

<html>
<head><title>FMS</title>
<meta http-equiv="Content-Type" content="text/html; charset=euc-kr">
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
	function go_to_list()
	{
		var fm = document.form1;
		var auth_rw = fm.auth_rw.value;
		var s_kd = fm.s_kd.value;
		var t_wd = fm.t_wd.value;
		var asc = fm.asc.value;
		location='/acar/mng_client2/client_s_frame.jsp?auth_rw='+auth_rw+'&s_kd='+s_kd+'&t_wd='+t_wd+'&asc='+asc;
	}	
//-->
</script>
<link rel=stylesheet type="text/css" href="/include/table_t.css">
</head>
<body>
<form name='form1' method='post' action='/acar/mng_client2/client_i_a.jsp'>
<input type='hidden' name='auth_rw' value='<%=auth_rw%>'>
<input type='hidden' name='br_id' value='<%=br_id%>'>
<input type='hidden' name='user_id' value='<%=user_id%>'>
<input type='hidden' name='s_kd' value='<%=s_kd%>'>
<input type='hidden' name='t_wd' value='<%=t_wd%>'>
<input type='hidden' name='asc' value='<%=asc%>'>
<table border="0" cellspacing="0" cellpadding="0" width=100%>
    <tr>
    	<td colspan=10>
    	    <table width=100% border=0 cellpadding=0 cellspacing=0>
                <tr>
                    <td width=7><img src=/acar/images/center/menu_bar_1.gif width=7 height=33></td>
                    <td class=bar>&nbsp;&nbsp;&nbsp;<img src=/acar/images/center/menu_bar_dot.gif width=4 height=5 align=absmiddle>&nbsp;<span class=style1>�������� > �ŷ�ó ���� > <span class=style5>�ŷ�ó ���</span></span></td>
                    <td width=7><img src=/acar/images/center/menu_bar_2.gif width=7 height=33></td>
                </tr>
            </table>
    	</td>
    </tr>
    <tr>
        <td class=h></td>
    </tr>
	
<%	if(auth_rw.equals("2") || auth_rw.equals("4") || auth_rw.equals("6")){%>	
	<tr>
		<td align='right'> <a href="javascript:save()"><img src="/acar/images/center/button_reg.gif"  align="absmiddle" border="0"></a>
		        &nbsp;&nbsp;<a href="javascript:go_to_list()" onMouseOver="window.status=''; return true"><img src="/acar/images/center/button_list.gif" align="absmiddle" border="0"></a> 
		</td>
	</tr>	
<%	}%>
    <tr>
        <td class=line2></td>
    </tr>
	<tr>
	    <td class='line'>		 
            <table border="0" cellspacing="1" cellpadding="0" width=100%>
                <tr> 
                    <td class='title' width='12%'> ������ </td>
                    <td width='38%'> &nbsp; 
                      <select name='client_st'>
                        <option value='1'> ���� </option>
                        <option value='2'> ���� </option>
                        <option value='3'> ���λ����(�Ϲݰ���) </option>
                        <option value='4'> ���λ����(���̰���) </option>
                        <option value='5'> ���λ����(�鼼�����)</option>
        				<option value='6'> �����</option>
                      </select>
                    </td>
                    <td class='title' width='12%'>���������</td>
                    <td width='38%' align='left'>&nbsp;
                    <input type='text' name='t_open_year' size='12' class='text' maxlength='12' onBlur='javascript:this.value=ChangeDate(this.value)' value=""></td>
                </tr>
                <tr>
                    <td class='title'>��ȣ</td>
                    <td align='left'>&nbsp;
                        <input type='text' name='firm_nm' size='30' maxlength='40' class='text' style='IME-MODE: active'>
                    </td>
                    <td class='title'>�����</td>
                    <td>&nbsp;
                        <input type='text' size='30' name='client_nm' maxlength='40' class='text'>
                    </td> 
                </tr>
                <tr> 
                    <td class='title'>�ֹ�(����)��ȣ</td>
                    <td>&nbsp; 
                      <input type='text' name='ssn1' maxlength='6' size='6' class='text'>
                      - 
                      <input type='text' name='ssn2' maxlength='7' size='7' class='text'>
                    </td>
                    <td class='title'>����ڹ�ȣ</td>
                    <td>&nbsp; 
                      <input type='text' size='3' name='enp_no1' maxlength='3' class='text'>
                      - 
                      <input type='text' size='2' name='enp_no2' maxlength='2' class='text'>
                      - 
                      <input type='text' size='5' name='enp_no3' maxlength='5' class='text'>
                    </td>
                </tr>
				<script src="https://t1.daumcdn.net/mapjsapi/bundle/postcode/prod/postcode.v2.js"></script>
				<script>
					function openDaumPostcode() {
						new daum.Postcode({
							oncomplete: function(data) {
								document.getElementById('t_zip').value = data.zonecode;
								document.getElementById('t_addr').value = data.address +" ("+ data.buildingName+")";
								
							}
						}).open();
					}
				</script>			
				<tr>
				  <td class=title>����������</td>
				  <td colspan=3>&nbsp;
					<input type="text" name='t_zip' id="t_zip" size="7" maxlength='7'>
					<input type="button" onclick="openDaumPostcode()" value="�����ȣ ã��"><br>
					&nbsp;&nbsp;<input type="text" name='t_addr' id="t_addr" size="100">
				  </td>
				</tr>
				<script>
					function openDaumPostcode1() {
						new daum.Postcode({
							oncomplete: function(data) {
								document.getElementById('t_zip1').value = data.zonecode;
								document.getElementById('t_addr1').value = data.address +" ("+ data.buildingName+")";
								
							}
						}).open();
					}
				</script>		
                <tr> 
                    <td class='title'>����� �ּ�</td>
                    <td colspan='3'> &nbsp; 
                      <input type="text" name='t_zip' id="t_zip1" size="7" maxlength='7'>
					<input type="button" onclick="openDaumPostcode1()" value="�����ȣ ã��"><br>
					&nbsp;&nbsp;<input type="text" name='t_addr' id="t_addr1" size="100">
                      <input type='checkbox' name='c_ho' onClick='javascript:set_o_addr()'>
                      ��</td>
                </tr>
                <tr> 
                    <td class='title'>����</td>
                    <td>&nbsp; 
                      <input type='text' size='30' name='bus_cdt' maxlength='40' class='text'>
                    </td>
                    <td class='title'>����</td>
                    <td>&nbsp; 
                      <input type='text' size='30' name='bus_itm' value='' maxlength='40' class='text'>
                    </td>
                </tr>
                <tr> 
                    <td class='title'>�����</td>
                    <td colspan="3">&nbsp; 
                      <input type='text' size='30' name='com_nm' maxlength='20' class='text'>
                    </td>
                </tr>
                <tr>
                    <td class='title'>�ٹ��μ�</td>
                    <td>&nbsp;
                        <input type='text' size='30' name='dept' maxlength='15' class='text'>
                    </td>
                    <td class='title'>����</td>
                    <td>&nbsp;
                        <input type='text' size='30' name='title' maxlength='10' class='text'>
                    </td> 
                </tr>
                <tr> 
                    <td class='title'>������ȭ��ȣ</td>
                    <td>&nbsp; 
                      <input type='text' size='30' name='h_tel' maxlength='15' class='text'>
                    </td>
                    <td class='title'>ȸ����ȭ��ȣ</td>
                    <td>&nbsp; 
                      <input type='text' size='30' name='o_tel' maxlength='15' class='text'>
                    </td>
                </tr>
                <tr>
                    <td class='title'>�޴���</td>
                    <td>&nbsp;
                        <input type='text' size='30' name='m_tel' maxlength='15' class='text'>
                    </td> 
                    <td class='title'>FAX</td>
                    <td>&nbsp;
                        <input type='text' size='30' name='fax' maxlength='15' class='text'>
                    </td>
                </tr>
                <tr> 
                    <td class='title'>Homepage</td>
                    <td colspan="3">&nbsp; 
                    <input type='text' size='50' name='homepage' value='' maxlength='70' class='text' style='IME-MODE: inactive'>            </td>
                </tr>
                <tr> 
                    <td class='title' rowspan='2'>�����</td>
                    <td colspan='3'> &nbsp;<img src=/acar/images/center/arrow.gif align=absmiddle> �̸�: 
                      <input type='text' size='15' name='con_agnt_nm' maxlength='20' class='text'>
                      &nbsp;<img src=/acar/images/center/arrow.gif align=absmiddle> �繫��: 
                      <input type='text' size='15' name='con_agnt_o_tel' maxlength='15' class='text'>
                      &nbsp;<img src=/acar/images/center/arrow.gif align=absmiddle> �̵���ȭ: 
                      <input type='text' size='15' name='con_agnt_m_tel' maxlength='15' class='text'>
                      &nbsp;<img src=/acar/images/center/arrow.gif align=absmiddle> FAX: 
                      <input type='text' size='15' name='con_agnt_fax' maxlength='15' class='text'>
                    </td>
                </tr>
                <tr> 
                    <td colspan='3'>&nbsp;<img src=/acar/images/center/arrow.gif align=absmiddle> EMAIL: 
                      <input type='text' size='20' name='con_agnt_email' maxlength='30' class='text' style='IME-MODE: inactive'>
                      &nbsp;<img src=/acar/images/center/arrow.gif align=absmiddle> �ٹ��μ�: 
                      <input type='text' size='20' name='con_agnt_dept' maxlength='15' class='text' style='IME-MODE: inactive'>
                      &nbsp;<img src=/acar/images/center/arrow.gif align=absmiddle> ����: 
                      <input type='text' size='20' name='con_agnt_title' maxlength='10' class='text'>
                    </td>
                </tr>
                <tr>
                    <td class='title'>��꼭���౸��</td>
                    <td>&nbsp;
                      <select name='print_st'>
                        <option value='1'>���Ǻ�</option>
                        <option value='2'>�ŷ�ó����</option>
                        <option value='3'>��������</option>
                        <option value='4'>��������</option>
                      </select></td>
                    <td class='title'>�������뵵</td>
                    <td>&nbsp;
                        <input type='text' size='30' name='car_use' value='' maxlength='10' class='text'>
                    </td>
                </tr>
                <tr> 
                    <td class='title'>�ں���/������</td>
                    <td>&nbsp; 
                      <input type='text' name='t_firm_price' size='10' class='num' maxlength='20' onBlur='javascript:this.value=parseDecimal2(this.value);' value="">
                      �鸸�� 
                      <input type='text' name='t_firm_day' size='12' class='text' maxlength='12' onBlur='javascript:this.value=ChangeDate(this.value)' value="">
                    </td>
                    <td class='title'>������/������</td>
                    <td>&nbsp; 
                      <input type='text' name='t_firm_price_y' size='10' class='num' maxlength='40' onBlur='javascript:this.value=parseDecimal2(this.value);' value="">
                      �鸸�� 
                      <input type='text' name='t_firm_day_y' size='12' class='text' maxlength='12' onBlur='javascript:this.value=ChangeDate(this.value)' value="">
                    </td>
                </tr>
                <tr> 
                    <td class='title'> Ư�̻��� </td>
                    <td colspan='3'>&nbsp; 
                      <textarea name='etc' rows='5' cols='120' maxlenght='500'></textarea>
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
