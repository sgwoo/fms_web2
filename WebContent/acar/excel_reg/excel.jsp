<%@ page language="java" contentType="text/html;charset=euc-kr" %>
<%@ page import="java.util.*, acar.util.*, acar.cont.*"%>

<%
	String action = request.getParameter("action")==null?"":request.getParameter("action");
	String car_id = request.getParameter("car_id")==null?"":request.getParameter("car_id");
	String t_fst_pay_amt = request.getParameter("t_fst_pay_amt")==null?"":request.getParameter("t_fst_pay_amt");
	
%>
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
		if(fm.action == ''){							alert('�۾��� ��Ȯ���� �ʽ��ϴ�.');					return; 	}
		if(!confirm("�ش� ������ ����Ͻðڽ��ϱ�?"))	return;
		fm.submit();
	}
//-->
</script>
</head>

<body>
<center>
<form name='form1' action='<%=action%>' method='post' enctype="multipart/form-data">
<input type='hidden' name='car_id' value='<%=car_id%>'>
<input type='hidden' name='t_fst_pay_amt' value='<%=t_fst_pay_amt%>'>
    <table border="0" cellspacing="0" cellpadding="0" width=570>
        <tr> 
            <td> <font color="red">[ ���������� �̿��� �ϰ� ó��  ] : <%if(action.equals("scd_alt.jsp")){%>�Һαݻ�ȯ������ ����<%}else if(action.equals("scd_alt_int.jsp")){%>�Һαݻ�ȯ������ ���� ����<%}else{%>�ڵ�����ȯ�� ó��<%}%></font></td>
        </tr>
        <tR>
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
                </table>
		    </td>
        </tr>
        <tr>
            <td align="center">* ����Ȯ���� <b>*.xls</b> �� ���ϸ� �����մϴ�.</td>
        </tr>
        <tr>
            <td align="right"><a href='javascript:save()' onMouseOver="window.status=''; return true"><img src=/acar/images/center/button_reg.gif align=absmiddle border=0></a>&nbsp;
		    <a href='javascript:window.close()' onMouseOver="window.status=''; return true"><img src=/acar/images/center/button_close.gif align=absmiddle border=0></a></td>
        </tr>
    </table>
</form>
</center>
</body>
</html>
