<%@ page language="java" contentType="text/html;charset=euc-kr" %>
<%@ page import="java.util.*, acar.util.*, acar.cont.*"%>

<html>
<head>
<title>FMS</title>
<meta http-equiv="Content-Type" content="text/html; charset=euc-kr">
<link rel=stylesheet type="text/css" href="/include/table_t.css">
<script language='JavaScript' src='/include/common.js'></script>
<script language='javascript'>
<!--
	//����ϱ�
	function save(){
		var fm = document.form1;
		if(fm.filename.value == ''){					alert('������ �����Ͻʽÿ�.'); 						return; 	}
		if(fm.filename.value.indexOf('xls') == -1){		alert('���������� �ƴմϴ�.');						return;		}
		if(fm.filename.value.indexOf('xlsx') != -1){	alert('Excel97-2003���չ���(*.xls)�� �ƴմϴ�.');	return;		}
				
		if(!confirm("�ش� ������ ����Ͻðڽ��ϱ�?"))	return;
		fm.submit();
	}
//-->
</script>
</head>

<body>
<center>
  <form name='form1' action='target_excel_list.jsp' method='post' enctype="multipart/form-data">
    <table border="0" cellspacing="0" cellpadding="0" width=750>
      <tr> 
        <td> <font color="red">[ ���������� �̿��� SMS ����  ]</font></td>
      </tr>
      <tr>
        <td align="right" class="line">
		  <table border="0" cellspacing="1" cellpadding="0" width=100%>
            <tr>
              <td width="15%" class='title'>����</td>
              <td>&nbsp;
			    <input type="file" name="filename" size="60">
              </td>
            </tr>
          </table>
		</td>
      </tr>
      <tr>
        <td align="center"><span class="style1">- ����� - </span></td>
      </tr>      
      <tr>
        <td class="line">
	      <table border="0" cellspacing="1" cellpadding="0">
            <tr>
              <td width="200" class="title">������</td>
              <td width="200" class="title">���Ź�ȣ</td>
              <td width="350" class="title">���ڳ���</td>
            </tr>
          </table>
		</td>
      </tr>  	  
      <tr>
        <td align="right">* ���ڳ����� ������ ���� ��� �޴��� ���÷��̿� �ִ� ������ �������� �����ϴ�.</td>
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
