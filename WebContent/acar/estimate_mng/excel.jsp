<%@ page language="java" contentType="text/html;charset=euc-kr" %>
<%@ page import="java.util.*, acar.util.*, acar.cont.*"%>

<html>
<head>
<title>FMS</title>
<meta http-equiv="Content-Type" content="text/html; charset=euc-kr">
<link rel=stylesheet type="text/css" href="../../include/table.css">
<script language='JavaScript' src='/include/common.js'></script>
<script language='javascript'>
<!--
	//����ϱ�
	function save(){
		var fm = document.form1;
		//fm.action = 'https://fms3.amazoncar.co.kr/acar/admin/excel_ja_var.jsp';
		fm.action = 'excel_ja_var.jsp?reg_dt='+fm.reg_dt.value;
		
		if(fm.filename.value == ''){					alert('������ �����Ͻʽÿ�.'); 		return; 	}
		
		if(!confirm("�ش� ������ ����Ͻðڽ��ϱ�?"))	return;
		fm.submit();
	}
//-->
</script>
</head>

<body>
<center>
  <form name='form1' action='' method='post' enctype="multipart/form-data">
    <table border="0" cellspacing="0" cellpadding="0" width=570>
      <tr> 
        <td> <font color="red">[ ���������� �̿��� ���� ó��  ]</font></td>
      </tr>
      <tr>
        <td align="right" class="line">
		  <table border="0" cellspacing="1" cellpadding="0" width=100%>
            <tr>
              <td width="15%" class='title'>��������</td>
              <td>&nbsp;
			    <input name="reg_dt" type="text" class=text value="<%=AddUtil.getDate()%>"size="18" style1>
              </td>
            </tr>
            <tr>
              <td width="15%" class='title'>����</td>
              <td>&nbsp;
			    <input type="file" name="filename" size="50">
              </td>
            </tr>
            <tr>
              <td class='title'>����</td>
              <td>&nbsp;
			    <input type="radio" name="gubun1" value="1" checked>
                �����ڵ庰 ����(esti_jg_var) ���
			  </td>
            </tr>
          </table>
		</td>
      </tr>
      <tr>
        <td align="right">&nbsp;</td>
      </tr>
      <tr>
        <td align="right"><a href='javascript:save()' onMouseOver="window.status=''; return true"><img src="/images/reg.gif" width="50" height="18" aligh="absmiddle" border="0"></a>&nbsp;
		<a href='javascript:window.close()' onMouseOver="window.status=''; return true"><img src="/images/close.gif" width="50" height="18" aligh="absmiddle" border="0"></a></td>
      </tr>
    </table>
  </form>
</center>
</body>
</html>
