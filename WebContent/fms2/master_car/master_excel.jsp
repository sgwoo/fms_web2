<%@ page language="java" contentType="text/html;charset=euc-kr" %>
<%@ page import="java.util.*, acar.util.*, acar.cont.*"%>
<%@ include file="/acar/cookies.jsp" %>
<%
	String user_id 		= request.getParameter("user_id")==null?"":request.getParameter("user_id");
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
		//if(fm.filename.value.indexOf('xls') == -1){		alert('���������� �ƴմϴ�.');						return;		}
		//if(fm.filename.value.indexOf('xlsx') != -1){	alert('Excel97-2003���չ���(*.xls)�� �ƴմϴ�.');	return;		}
		//alert(fm.filename.value.indexOf('xlsx') != -1);
		if (fm.filename.value.indexOf('xlsx') != -1) {
			fm.action = 'master_excel_xlsx_reg.jsp?user_id=<%=user_id%>';
		} else {
			fm.action = 'master_excel_xlsx_reg.jsp?user_id=<%=user_id%>';
		}
		
		//fm.action = 'master_excel_reg.jsp';		
			
		if(!confirm("�ش� ������ ����Ͻðڽ��ϱ�?"))	return;
		fm.submit();
	}
	
	
//-->
</script>
</head>

<body>
<center>
  <form name='form1' action='' method='post' enctype="multipart/form-data">
     <input type='hidden' name='user_id' value='<%=user_id%>'>
    <table border="0" cellspacing="0" cellpadding="0" width=800>
      <tr> 
        <td>
            <table width=100% border=0 cellpadding=0 cellspacing=0>
                <tr>
                    <td width=7><img src=/acar/images/center/menu_bar_1.gif width=7 height=33></td>
                    <td class=bar>&nbsp;&nbsp;&nbsp;<img src=/acar/images/center/menu_bar_dot.gif width=4 height=5 align=absmiddle>&nbsp;������ > ����Ÿ�ڵ��� > <span class=style1><span class=style5>���������� �̿��� ���񽺳��� ���</span></span></td>
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
                    <td colspan="2">&nbsp;
    			        <input type="file" name="filename" size="50">
                    </td>
                </tr>			
                <tr>
                    <td class='title'>����</td>
                    <td>&nbsp;
				    <input type="radio" name="gubun1" value="1" checked>����Ÿ�ڵ��� ���ó��
					&nbsp;&nbsp;
					<input type="radio" name="gubun1" value="5" checked>�Ｚ�ִ�ī���� ���ó��
					&nbsp;&nbsp;
					<input type="radio" name="gubun1" value="7" checked>���ǵ����Ʈ ���ó��
			        </td>
			        <td align="center"><a href="https://fms3.amazoncar.co.kr/data/sample/master_sample.xls">������ϻ���</a></td>
                </tr>
            </table>
		</td>
    </tr>
    <tr>
        <td align=right>* ����Ȯ���� <b>*.xls</b> �� ���ϸ� �����մϴ�.</td>
    </tr>	  
    <tr>
        <td class=h>&nbsp;</td>
    </tr>
    <tr>
        <td align="right"><a href='javascript:save()'><img src="/acar/images/center/button_reg.gif"  align="absmiddle" border="0"></a>&nbsp;
		<a href='javascript:window.close()'><img src="/acar/images/center/button_close.gif" align="absmiddle" border="0"></a></td>
    </tr>
  </table>
  </form>
</center>
</body>
</html>
