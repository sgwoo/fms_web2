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
	
	//�ڵ����� ����ó��
	function pay_save(){
		var fm = document.form1;		
		if(fm.gjyj_dt.value == ''){					alert('���⿹�����ڸ� �Է��Ͻʽÿ�.');				return; 	}		
		if(fm.gj_dt.value == ''){						alert('�������ڸ� �Է��Ͻʽÿ�.');					return; 	}				
		fm.action = 'excel_all_pay_a.jsp';					
		if(!confirm("����ó���Ͻðڽ��ϱ�?"))	return;
		fm.submit();
	}	

//-->
</script>
</head>

<body>
<center>
  <form name='form1' action='' method='post' enctype="multipart/form-data">
    <table border="0" cellspacing="0" cellpadding="0" width=100%>
      <tr> 
        <td>
            <table width=100% border=0 cellpadding=0 cellspacing=0>
                <tr>
                    <td width=7><img src=/acar/images/center/menu_bar_1.gif width=7 height=33></td>
                    <td class=bar>&nbsp;&nbsp;&nbsp;<img src=/acar/images/center/menu_bar_dot.gif width=4 height=5 align=absmiddle>&nbsp;���¾�ü > ����⵿���� > ���ó�� > <span class=style1><span class=style5>���������� �̿��� ��Ÿ��� ����ó��</span></span></td>
                    <td width=7><img src=/acar/images/center/menu_bar_2.gif width=7 height=33></td>
                </tr>
            </table>            
        </td>
    </tr>
    <tr> 
        <td class=h></td>
    </tr>
    <tr>
        <td><img src=/acar/images/center/icon_arrow.gif align=absmiddle> <span class=style2>�ڵ����� �ϰ� ����ó��</span></td>
    </tr>
    <tr>
        <td class=line2></td>
    </tr>
    <tr>
        <td class=line>
            <table width=100% border=0 cellspacing=1 cellpadding=0>
                <tr>
                    <td class=title width=20%>���⿹������</td>
                    <td>&nbsp;<input type='text' name='gjyj_dt' class='text' size='11' maxlength='10' onBlur='javascript:this.value = ChangeDate(this.value);'></td>
                    <td class=title width=20%>��&nbsp;&nbsp;��&nbsp;&nbsp;��&nbsp;&nbsp;��</td>
                    <td>&nbsp;<input type='text' name='gj_dt' class='text' size='11' maxlength='10' onBlur='javascript:this.value = ChangeDate(this.value);'></td>
                </tr>
            </table>
        </td>
    </tr>
    <tr>
        <td align=right><a href='javascript:pay_save()'><img src=/acar/images/center/button_gccr.gif border=0 align=absmiddle></a></td>	
    </tr>
   
  </table>
  </form>
</center>
</body>
</html>
