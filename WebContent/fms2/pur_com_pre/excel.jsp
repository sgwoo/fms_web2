<%@ page language="java" contentType="text/html;charset=euc-kr" %>
<%@ page import="java.util.*, acar.util.*"%>
<%@ include file="/acar/cookies.jsp" %>

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
		if(fm.filename.value == ''){				alert('������ �����Ͻʽÿ�.'); 				return; 	}
		if(fm.filename.value.indexOf('xls') == -1){		alert('���������� �ƴմϴ�.');				return;		}
		if(fm.filename.value.indexOf('xlsx') != -1){		alert('Excel97-2003���չ���(*.xls)�� �ƴմϴ�.');	return;		}
		fm.action = 'excel_reg.jsp';
		if(!confirm("�ش� ������ ����Ͻðڽ��ϱ�?"))	return;
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
        <td> <font color="red">[ ���������� �̿��� ������� ���  ]</font></td>
    </tr>
    <tr>
        <td class=line2></td>
    </tr>
    <tr>
        <td align="right" class="line">
	    <table border="0" cellspacing="1" cellpadding="0" width=100%>
                <tr>
                    <td width="40" class='title'>����</td>
                    <td>&nbsp;<input type="file" name="filename" size="100"></td>
                </tr>
                <tr>
                    <td class='title'>����</td>
                    <td>	
                        <table border="0" cellspacing="1" cellpadding="0">
                            <tr>
                            	
                                <td style="font-size : 8pt;" class="title">1)�������</td>
                                <td style="font-size : 8pt;" class="title">2)�����ȣ</td>
                                <td style="font-size : 8pt;" class="title">3)��û�Ͻ�</td><!-- ��û�Ͻ� �߰�(20181107)-->
                                <td style="font-size : 8pt;" class="title">4)����</td>
                                <td style="font-size : 8pt;" class="title">5)���</td>
                                <td style="font-size : 8pt;" class="title">6)�������</td>
                                <td style="font-size : 8pt;" class="title">7)�������</td>
                                <td style="font-size : 8pt;" class="title">8)���Ͻ�����</td><!-- ���Ͻ����� �߰� 20210721 -->
                                <td style="font-size : 8pt;" class="title">9)�Һ��ڰ�</td>
                                <td style="font-size : 8pt;" class="title">10)����</td>
                                <td style="font-size : 8pt;" class="title">11)������������</td>
                                <td style="font-size : 8pt;" class="title">12)�������</td>
                                <td style="font-size : 8pt;" class="title">13)���</td>
                                <td style="font-size : 8pt;" class="title">14)�����</td>
                                <td style="font-size : 8pt;" class="title">15)����</td>
                                <td style="font-size : 8pt;" class="title">16)���ּ���</td>
                                <td style="font-size : 8pt;" class="title">17)����ȣ</td>
                                <td style="font-size : 8pt;" class="title">18)��������</td>
                                <td style="font-size : 8pt;" class="title">19)������Ʈ���⿩��</td>
                                <td style="font-size : 8pt;" class="title">20)��ü��������</td>
                                <td style="font-size : 8pt;" class="title">21)�������޹��</td>
                                <td style="font-size : 8pt;" class="title">22)ī��/������</td>
                                <td style="font-size : 8pt;" class="title">23)��������</td>
                                <td style="font-size : 8pt;" class="title">24)ī��/���¹�ȣ</td>
                                <td style="font-size : 8pt;" class="title">25)����/������</td>
                                <td style="font-size : 8pt;" class="title">26)�������⿹����</td>
                                
                            </tr>
                        </table>
                    </td>
                </tr>		
            </table>
	</td>
    </tr>	      
    <tr>
        <td align="right">&nbsp;</td>
    </tr>
    <tr>
        <td align="center">
            <a href='javascript:save();'><img src="/acar/images/center/button_reg.gif" align="absmiddle" border="0"></a>&nbsp;
	          <a href='javascript:window.close();' onMouseOver="window.status=''; return true"><img src="/acar/images/center/button_close.gif" align="absmiddle" border="0"></a>
	</td>
    </tr>
</table>
</form>
</center>
</body>
</html>
