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
		
		fm.action = 'user_excel_reg.jsp';		
		
		if(!confirm("�ش� ������ ����Ͻðڽ��ϱ�?"))	return;
		fm.submit();
	}
	
//-->
</script>
</head>

<body>

  <form name='form1' action='' method='post' enctype="multipart/form-data">
    <table border="0" cellspacing="0" cellpadding="0" width=560>
	<tr>
    	<td colspan=10>
    	    <table width=100% border=0 cellpadding=0 cellspacing=0>
                <tr>
                    <td width=7><img src=/acar/images/center/menu_bar_1.gif width=7 height=33></td>
                    <td class=bar>&nbsp;&nbsp;&nbsp;<img src=/acar/images/center/menu_bar_dot.gif width=4 height=5 align=absmiddle>&nbsp;<span class=style1>���ݰ��� > <span class=style5>����ڿ������</span></span></td>
                    <td width=7><img src=/acar/images/center/menu_bar_2.gif width=7 height=33></td>
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
        <td align="right" class="line">
		    <table border="0" cellspacing="1" cellpadding="0" width=100%>
                <tr>
                    <td width="100" class='title'>����</td>
                    <td>&nbsp;
    			        <input type="file" name="filename" size="40">
                    </td>
                </tr>		
                <tr>
                    <td width="100" class='title'>sheet</td>
                    <td>&nbsp;
    			        <input type="text" name="sheet_num" size="2" value='0'>��° sheet
                    </td>
                </tr>						
            </table>
		</td>
    </tr>
    <tr>
        <td align="right">&nbsp;</td>
    </tr>
    <tr>
        <td>* ����Ȯ���� <b>*.xls</b> �� ���ϸ� �����մϴ�.</td>
    </tr>	  
    <tr>
        <td>* ����� : [A]�̸� [B]�ݾ�</td>
    </tr>	
    <tr>
        <td>* sheet : 0���� �����Ѵ�.</td>
    </tr>		  
    <tr>
        <td align="right">&nbsp;</td>
    </tr>
    <tr>
        <td align="right"><a href='javascript:save()'><img src="/acar/images/center/button_reg.gif"  align="absmiddle" border="0"></a>&nbsp;		
		</td>
    </tr>
  </table>
  </form>

</body>
</html>