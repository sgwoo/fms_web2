<%@ page language="java" contentType="text/html; charset=euc-kr" %>
<%@ page import="java.util.*, acar.util.*, test.menu.*"%>
<%//@ include file="/acar/cookies.jsp" %>

<%
	String user_id = request.getParameter("user_id")==null?"":request.getParameter("user_id");
	String m_st = request.getParameter("m_st")==null?"01":request.getParameter("m_st");
	String m_st2 = request.getParameter("m_st2")==null?"01":request.getParameter("m_st2");
	String m_cd = request.getParameter("m_cd")==null?"01":request.getParameter("m_cd");
	String reg = request.getParameter("reg")==null?"1":request.getParameter("reg");
	
	
%>

<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN">
<html>
<head>
<title>����ȣ ����</title>
<meta http-equiv="Content-Type" content="text/html; charset=euc-kr">
<link rel=stylesheet type="text/css" href="../include/table.css">
<script language='javascript' src='/include/common.js'></script>
<script language='javascript'>
<!--
	//����ڵ� ������ ����
	function save(){
		var fm = document.form1;
		if(fm.t_con_cd1.value == '')		{	alert('�����Ҹ� �����Ͻʽÿ�');			return;	}
		else if(fm.t_con_cd2.value == '')	{	alert('���⵵�� �����Ͻʽÿ�');		return;	}
		else if(fm.t_con_cd3.value == '')	{	alert('�ڵ���ȸ�縦 �����Ͻʽÿ�');		return;	}
		else if(fm.t_con_cd4.value == '')	{	alert('������ �����Ͻʽÿ�');			return;	}
		else if(fm.t_con_cd5.value == '')	{	alert('�뿩������ �����Ͻʽÿ�');		return;	}

		window.opener.form1.t_con_cd.value = fm.t_con_cd1.value + fm.t_con_cd2.value + fm.t_con_cd3.value + fm.t_con_cd4.value + fm.t_con_cd5.value;
		window.opener.form1.h_brch.value 	= fm.t_con_cd1.value;
		window.opener.form1.t_brch_nm.value = fm.slt_brch.options[fm.slt_brch.selectedIndex].text;
		window.opener.form1.t_com_id.value 	= fm.com_id.value ;
		window.opener.form1.t_com_nm.value 	= fm.com_nm.value ;
		window.opener.form1.t_car_nm.value 	= fm.car_nm.value ;
//		window.opener.form1.t_car_name.value = fm.car_name.value ;
//		window.opener.form1.h_car_id.value = fm.slt_car_name.options[fm.slt_car_name.selectedIndex].value.substring(0,6);
//		window.opener.form1.t_car_seq.value = fm.slt_car_name.options[fm.slt_car_name.selectedIndex].value.substring(8,10);
		var car_name_value = fm.slt_car_name.options[fm.slt_car_name.selectedIndex].value;
		var car_name_value_split = car_name_value.split(",");
		window.opener.form1.h_car_id.value = car_name_value_split[0];
		window.opener.form1.t_car_cd.value = car_name_value_split[1];		
		window.opener.form1.t_car_seq.value = car_name_value_split[2];
		window.opener.form1.t_car_name.value = car_name_value_split[4];		
		//��������
		var car_amt = car_name_value_split[3];
		window.opener.form1.t_car_c.value = parseDecimal(toInt(car_amt));
		window.opener.form1.t_car_cs.value = parseDecimal(sup_amt(toInt(parseDigit(car_amt))));
		window.opener.form1.t_car_cv.value = parseDecimal(toInt(parseDigit(car_amt)) - toInt(parseDigit(window.opener.form1.t_car_cs.value)));

		if(fm.slt_car_st.value == 'R')		{ window.opener.form1.s_car_st[1].selected = true; }		
		else if(fm.slt_car_st.value == 'L')	{ window.opener.form1.s_car_st[2].selected = true; }	
		else if(fm.slt_car_st.value == 'S')	{ window.opener.form1.s_car_st[3].selected = true; }
		window.close();
	}
	
	//����ڵ忡 �ڵ���ȸ�� �ڵ� �ְ� ���� ����Ʈ ��������
	function change_car_com(){
		var fm = document.form1;
		var tot_str = fm.slt_car_com.options[fm.slt_car_com.selectedIndex].value;
		var com_id = tot_str.substring(0,4);
		var com_id_nm = tot_str.substring(4,5);
		var com_name = tot_str.substring(5);	
		fm.t_con_cd3.value = com_id_nm;
		fm.com_id.value = com_id;
		fm.com_nm.value = com_name;
		drop_car_nm();		
		if(tot_str == ''){
			fm.slt_car_nm.options[0] = new Option('����', '');
			return;
		}else{
			fm.target='i_no';
			fm.action='get_car_comp_id_nodisplay.jsp?com_id='+com_id;
			fm.submit();
		}
	}
	function drop_car_nm(){
		var fm = document.form1;
		var car_len = fm.slt_car_nm.length;
		for(var i = 0 ; i < car_len ; i++){
			fm.slt_car_nm.options[car_len-(i+1)] = null;
		}
	}		
	function add_car_nm(idx, val, str){
		document.form1.slt_car_nm[idx] = new Option(str, val);		
	}

	//����ڵ忡 ���� �ڵ� �ְ� ���� ����Ʈ ��������
	function change_car_nm(){
		var fm = document.form1;
		fm.car_cd.value = fm.slt_car_nm.options[fm.slt_car_nm.selectedIndex].value;
		fm.com_id.value = fm.slt_car_com.options[fm.slt_car_com.selectedIndex].value.substring(0,4);
		fm.car_nm.value = fm.slt_car_nm.options[fm.slt_car_nm.selectedIndex].text;
		fm.t_con_cd4.value = fm.car_cd.value;
		drop_car_name();		
		if(fm.car_cd.value == ''){
			fm.slt_car_name.options[0] = new Option('����', '');
			return;
		}else{			
			fm.target='i_no';
//			fm.target='SET_RENT_L_CD';
			fm.action='get_car_id_nodisplay.jsp?com_id='+fm.com_id.value+'&car_cd='+fm.car_cd.value;
			fm.submit();
		}
	}		
	function drop_car_name(){
		var fm = document.form1;
		var car_len = fm.slt_car_name.length;
		for(var i = 0 ; i < car_len ; i++){
			fm.slt_car_name.options[car_len-(i+1)] = null;
		}
	}		
	function add_car_name(idx, val, str){
		document.form1.slt_car_name[idx] = new Option(str, val+','+str);		
	}		
	
	//����ڵ忡 ������ �ڵ� �ֱ�
	function set_branch(){
		var fm = document.form1;
		var idx = fm.slt_brch.selectedIndex;
		fm.t_con_cd1.value = fm.slt_brch.options[idx].value;
	}
	
	//����ڵ忡 �뿩���� �ڵ� �ֱ�
	function set_car_st(){
		var fm = document.form1;
		fm.t_con_cd5.value = fm.slt_car_st.options[fm.slt_car_st.selectedIndex].value;
	}	
	
	//����ڵ忡 �뿩���� �ڵ� �ֱ�
	function set_car_name(){
		var fm = document.form1;
		var car_name_value = fm.slt_car_name.options[fm.slt_car_name.selectedIndex].value;
		var car_name_value_split = car_name_value.split(":");
		fm.car_name.value = car_name_value_split[4];
	}	
-->
</script>
</head>

<body>
<form name='form1' action='get_con_cd_p.jsp' method='post'>
<input type='hidden' name='h_com' value=''>
<input type='hidden' name='com_nm' value=''>
<input type='hidden' name='com_id' value=''>
<input type='hidden' name='car_cd' value=''>
<input type='hidden' name='car_nm' value=''>
<input type='hidden' name='car_name' value=''>

  <table border="0" cellspacing="0" cellpadding="0" width=100%>
<%	if(reg.equals("2")){%>
    <tr>
		
      <td align='left'><font color="#666600">- ������ ��ȸ (�縮��) -</font></td>
	</tr>
	<tr>
	<td class='line'>
		<table border="0" cellspacing="1" cellpadding="0" width=100%>
          <tr> 
            <td class='title' width='20%'>������ȣ</td>
            <td width="80%">&nbsp; 
              <input type='text' class='text' name='t_con_cd42' size='15' readonly>
              <a href="#" target="d_content"><img src="../images/bbs/but_search.gif" width="50" height="18" aligh="absmiddle" border="0" alt="���"></a> 
            </td>
          </tr>
        </table>
	</td>
</tr>
<%	}%>
    <tr>
		
      <td align='left'><font color="#666600">- ����ȣ ���� -</font></td>
	</tr>
	<tr>
	<td class='line'>
		<table border="0" cellspacing="1" cellpadding="0" width=100%>
          <tr> 
            <td class='title' width='20%'>������</td>
            <td width="80%">&nbsp; 
              <select name='slt_brch' onChange='javascript:set_branch()'>
			  
                
                <option value=''>����</option>
                
                <option value='I1'>��õ������</option>
                
                <option value='K1'>���ֿ�����</option>
                
                <option value='S1'>����</option>
                
                <option value='S2'>�߾ӿ�����</option>
                
                <option value='S3'>OTO</option>
                
			  								  
              </select>
            </td>
          </tr>
<%	if(reg.equals("1")){%>		  
          <tr> 
            <td class='title' width='20%'>�ڵ���ȸ��</td>
            <td width="80%">&nbsp; 
              <select name='slt_car_com' onChange='javascript:change_car_com()'>
                
                <option value=''>����</option>
                
                <option value='0001H�����ڵ���'>�����ڵ���</option>
                
                <option value='0002K����ڵ���'>����ڵ���</option>
                
                <option value='0003S����Ｚ�ڵ���'>����Ｚ�ڵ���</option>
                
                <option value='0004D�ѱ�GM'>�ѱ�GM</option>
                
                <option value='0005Y�ֿ��ڵ���'>�ֿ��ڵ���</option>
                
                <option value='0006V����'>����</option>
                
                <option value='0007T����Ÿ'>����Ÿ</option>
                
                <option value='0009Z�ú���'>�ú���</option>
                
                <option value='0011W�����ٰ�'>�����ٰ�</option>
                
                <option value='0012Cũ���̽���'>ũ���̽���</option>
                
                <option value='0013BBMW'>BMW</option>
                
                <option value='0014Aĳ����/���'>ĳ����/���</option>
                
                <option value='0015D�ѱ�GM'>�ѱ�GM</option>
                
                <option value='0016D�ѱ�GM'>�ѱ�GM</option>
                
                <option value='0017Z��Ÿ'>��Ÿ</option>
                
                <option value='0018U�ƿ���ڵ���'>�ƿ���ڵ���</option>
                
                <option value='0019D�ѱ�GM'>�ѱ�GM</option>
                
                <option value='0020Z��Ÿ'>��Ÿ</option>
                
                <option value='0021F�����ڵ���'>�����ڵ���</option>
                
                <option value='0022Z��Ÿ'>��Ÿ</option>
                
                <option value='0023H����ĳ��Ż'>����ĳ��Ż</option>
                
                <option value='0024S�Ｚĳ��Ż'>�Ｚĳ��Ż</option>
                
                <option value='0025Hȥ��'>ȥ��</option>
                
                <option value='0026P�����Ӹ���'>�����Ӹ���</option>
                
              </select>
            </td>
          </tr>
          <tr> 
            <td class='title' width='20%'>����</td>
            <td width="80%">&nbsp; 
              <select name='slt_car_nm' onChange='javascript:change_car_nm()'>
                <option value=''>�ڵ���ȸ�縦�����ϼ���</option>
              </select>
              &nbsp; &nbsp; </td>
          </tr>
          <tr> 
            <td class='title' width='20%'>����</td>
            <td width="80%">&nbsp; 
              <select name='slt_car_name' onChange='javascript:set_car_name()'>
                <option value=''>�����������ϼ���</option>
              </select>
            </td>
          </tr>
<%	}%>
		  
          <tr> 
            <td class='title' width='20%'>�뿩����</td>
            <td width="80%">&nbsp; 
              <select name="slt_car_st" onChange='javascript:set_car_st()'>
                <option value="">����</option>
                <option value="R">��Ʈ</option>
                <option value="L">����</option>
                <option value="S">�����</option>
              </select>
              &nbsp; </td>
          </tr>
          <tr> 
            <td class='title' width='20%'>����ȣ</td>
            <td colspan='3'>&nbsp; 
              <input type='text' class='text' name='t_con_cd1' size='2' value='' readonly>
              <input type='text' class='text' name='t_con_cd2' size='2' value='04'>
              <input type='text' class='text' name='t_con_cd3' size='1' value='' readonly>
              <input type='text' class='text' name='t_con_cd4' size='2' readonly>
              &nbsp;|&nbsp; 
              <input type='text' class='text' name='t_con_cd5' size='1' readonly>
            </td>
          </tr>
        </table>
	</td>
</tr>
    <tr>
		
      <td align='right'><a href="#"><img src="../images/bbs/but_confirm.gif" width="50" height="18" aligh="absmiddle" border="0" alt="���"></a> 
        <a href="javascript:window.close()"><img src="../images/bbs/but_close.gif" width="50" height="18" aligh="absmiddle" border="0" alt="���"></a></td>
	</tr>

</table>
</form>
<iframe src="about:blank" name="i_no" width="0" height="0" frameborder="0" noresize></iframe>
</body>
</html>
