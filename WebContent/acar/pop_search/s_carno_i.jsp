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
	function save(){
		var fm = document.form1;	
		if(fm.car_no.value == '')			{	alert('������ȣ�� �Է��Ͻʽÿ�');		fm.car_no.focus();  		return;	}
		else if(fm.init_reg_dt.value == ''){	alert('���ʵ�����ڸ� �Է��Ͻʽÿ�');	fm.init_reg_dt.focus();		return;	}
		else if(fm.br_id.value = '')		{	alert('���������� ������ �ּ���!');		fm.br_id.focus();			return;	}	
		
		if(!confirm('����Ͻðڽ��ϱ�?'))	return;
		
		fm.target='i_no';
		fm.action='./s_carno_i_a.jsp'
		fm.submit();
		
	}
	
	function checkCarNo(){
		fm = document.form1;
		if(fm.car_no.value == ''){	alert("������ȣ�� �Է��� �ּ���!");	fm.car_no.focus(); return; }
		fm.target = "i_no";
		fm.action = "./s_carno_chk.jsp";
		fm.submit();
	}
//-->
</script>
</head>
<body leftmargin="15" onload="javascript:document.form1.car_no.focus();">

<form name='form1' method='post'>
  <table border=0 cellspacing=0 cellpadding=0 width='100%'>
    <tr>
      <td><font color="#666600">< ��Ϲ�ȣ ���� ></font>&nbsp;</td>
  </tr>
  <tr>
    <td class='line'>            
        <table border="0" cellspacing="1" cellpadding='0' width=100%>
          <tr> 
            <td class='title' width="20%"> ������ȣ</td>
            <td colspan='3' align='left'>&nbsp; <a href="javascript:checkCarNo();"><span  class="pop">[�ߺ�üũ]</span></a> 
              <input type='text' name="car_no" size='20' class='text' style="IME-MODE:active;">
            </td>
          </tr>
          <tr> 
            <td class='title' width="20%">���ʵ������</td>
            <td width="30%">&nbsp; <input type='text' name='init_reg_dt' size='13' class='text' maxlength='10' onBlur='javascript:this.value=ChangeDate(this.value)' value=""> 
            </td>
            <td width='20%' class="title">�������</td>
            <td width='30%'>&nbsp; <input type="radio" name="reg_ext" value="1" checked>
              ���� 
              <input type="radio" name="reg_ext" value="2">
              ���</td>
          </tr>
          <tr> 
            <td class='title'>��������</td>
            <td><select name='br_id'>
                <option value='' selected>����</option>
                <option value='I1' > ��õ������ </option>
                <option value='K1' > ���ֿ����� </option>
                <option value='S1' > ���� </option>
                <option value='S2' > �߾ӿ����� </option>
                <option value='S3' > OTO </option>
              </select></td>
            <td class="title">&nbsp;</td>
            <td>&nbsp;</td>
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
<iframe src="about:blank" name="i_no" width="100" height="100" cellpadding="0" cellspacing="0" border="1" frameborder="0" noresize></iframe>
</body>
</html>