<%@ page language="java" contentType="text/html;charset=euc-kr" %>
<%@ page import="java.util.*, acar.util.*, acar.cont.*"%>
<%@ include file="/acar/cookies.jsp" %>
<%
	String auth_rw 		= request.getParameter("auth_rw")	==null?"":request.getParameter("auth_rw");
	String user_id 		= request.getParameter("user_id")	==null?"":request.getParameter("user_id");
	String br_id 		= request.getParameter("br_id")		==null?"":request.getParameter("br_id");
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
		
		if(fm.filename.value == ''){					alert('������ �����Ͻʽÿ�.'); 				return; 	}
		if(fm.filename.value.indexOf('xls') == -1){		alert('���������� �ƴմϴ�.');				return;		}
		if(fm.filename.value.indexOf('xlsx') != -1){	alert('Excel97-2003���չ���(*.xls)�� �ƴմϴ�.');	return;		}
		
		
		if(fm.gubun1[0].checked == true){				fm.action = 'buy_excel_reg_type1.jsp';				}
		else if(fm.gubun1[1].checked == true){			fm.action = 'buy_excel_reg_type1.jsp';				}							
		else{											alert('������ �����Ͻʽÿ�.');		return;				}
		
		if(!confirm("�ش� ������ ����Ͻðڽ��ϱ�?"))	return;

		fm.submit();
		
	}
//-->
</script>
</head>

<body>
<center>
<form name='form1' action='' method='post' enctype="multipart/form-data">
<input type='hidden' name='auth_rw' value='<%=auth_rw%>'>
<input type='hidden' name='user_id' value='<%=user_id%>'>
<input type='hidden' name='br_id' value='<%=br_id%>'>
<table border="0" cellspacing="0" cellpadding="0" width=800>
    <tr> 
        <td> <font color="red">[ ���������� �̿��� ���԰�꼭 ��ǥó��  ]</font></td>
    </tr>
    <tr>
        <td class=line2></td>
    </tr>
    <tr>
        <td align="right" class="line">
	    <table border="0" cellspacing="1" cellpadding="0" width=100%>
                <tr>
                    <td width="200" class='title'>����</td>
                    <td>&nbsp;<input type="file" name="filename" size="50"></td>
                </tr>
                <!-- 
                <tr>
                    <td class='title'>ȸ������</td>
                    <td>&nbsp;<input type="text" name="doc_dt" value="<%=AddUtil.getDate()%>" size="11" maxlength='10' class='default' onBlur='javascript:this.value=ChangeDate(this.value)'></td>
                </tr>
                 -->
                <tr>
                    <td class='title'>����</td>
                    <td>		   
                        <input type="radio" name="gubun1" value="1" checked>
                        <b>�Ե����丮��[�����] �ΰ�����ޱ� ���뺯�ݾ׾��� </b>                                                
                    </td>
                </tr>		
                <tr>
                    <td class=line2></td>
                </tr>			              
                <tr tr id=tr_etc style='display:none'>
                    <td>			   
                        &nbsp;<br>	
                        <input type="radio" name="gubun1" value="2">
                        <b>���� </b> 
                    </td>
                </tr>	
            </table>
        </td>
    </tr>        
    <tr>
        <td><font color=red>* Ȩ�ؽ����� �ٿ�ε��� �������Ϸ� ���Էµ����ʹ� <b>7��</b>�����Դϴ�. </font></td>
    </tr>              
    <tr>
        <td align="right">
            <a href='javascript:save()' onMouseOver="window.status=''; return true"><img src="/acar/images/center/button_reg.gif" align="absmiddle" border="0"></a>&nbsp;
	    <a href='javascript:window.close()' onMouseOver="window.status=''; return true"><img src="/acar/images/center/button_close.gif" align="absmiddle" border="0"></a>
	</td>
    </tr>
</table>
</form>
</center>
</body>
</html>
