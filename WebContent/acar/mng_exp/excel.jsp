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
		
		if(fm.gubun1[0].checked == true)				fm.action = 'excel_pay.jsp';		
		else if(fm.gubun1[1].checked == true)			fm.action = 'excel_reg.jsp';
			
		if(!confirm("�ش� ������ ����Ͻðڽ��ϱ�?"))	return;
		fm.submit();
	}
	
	//�ڵ����� ����ó��
	function pay_save(){
		var fm = document.form1;		
		if(fm.exp_est_dt.value == ''){					alert('���⿹�����ڸ� �Է��Ͻʽÿ�.');				return; 	}		
		if(fm.exp_dt.value == ''){						alert('�������ڸ� �Է��Ͻʽÿ�.');					return; 	}				
		fm.action = 'excel_all_pay_a.jsp';					
		if(!confirm("�ڵ����� ����ó���Ͻðڽ��ϱ�?"))	return;
		fm.submit();
	}	
	//ȯ�氳���δ�� ����ó��
	function pay_save2(){
		var fm = document.form1;		
		if(fm.exp_est_dt2.value == ''){					alert('���⿹�����ڸ� �Է��Ͻʽÿ�.');				return; 	}		
		if(fm.exp_dt2.value == ''){						alert('�������ڸ� �Է��Ͻʽÿ�.');					return; 	}				
		fm.action = 'excel_all_pay_b.jsp';					
		if(!confirm("ȯ�氳���δ�� ����ó���Ͻðڽ��ϱ�?"))	return;
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
        <td>
            <table width=100% border=0 cellpadding=0 cellspacing=0>
                <tr>
                    <td width=7><img src=/acar/images/center/menu_bar_1.gif width=7 height=33></td>
                    <td class=bar>&nbsp;&nbsp;&nbsp;<img src=/acar/images/center/menu_bar_dot.gif width=4 height=5 align=absmiddle>&nbsp;�繫ȸ�� > ���������� > ��Ÿ��ϰ��ú�� > <span class=style1><span class=style5>���������� �̿��� ��Ÿ��� ����ó��</span></span></td>
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
                    <td width="15%" class='title'>����</td>
                    <td>&nbsp;
    			        <input type="file" name="filename" size="50">
                    </td>
                </tr>			
                <tr>
                    <td class='title'>����</td>
                    <td>&nbsp;
			        <input type="radio" name="gubun1" value="1" checked>
                    ��Ÿ��� ����ó��
				    <input type="radio" name="gubun1" value="2" checked>
                    ��Ÿ��� ���ó��
			        </td>
                </tr>
            </table>
		</td>
    </tr>
    <tr>
        <td align="center">* ����Ȯ���� <b>*.xls</b> �� ���ϸ� �����մϴ�.</td>
    </tr>	  
    <tr>
        <td align="right">&nbsp;</td>
    </tr>
    <tr>
        <td align="right"><a href='javascript:save()'><img src="../images/center/button_reg.gif"  align="absmiddle" border="0"></a>&nbsp;
		<a href='javascript:window.close()'><img src="../images/center/button_close.gif" align="absmiddle" border="0"></a></td>
    </tr>
    <tr>
        <td align="right"><hr></td>
    </tr>

  </table>
  </form>
</center>
</body>
</html>
