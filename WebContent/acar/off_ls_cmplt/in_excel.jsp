<%@ page language="java" contentType="text/html;charset=euc-kr" %>
<%@ page import="java.util.*, acar.util.*, acar.cont.*"%>
<%@ include file="/acar/cookies.jsp" %>
<%
	String user_id 		= request.getParameter("user_id")==null?ck_acar_id:request.getParameter("user_id");	

	String from_page = request.getParameter("from_page")==null?"":request.getParameter("from_page");
	
%>
<html>
<head>
<title>FMS</title>
<meta http-equiv="Content-Type" content="text/html; charset=euc-kr">
<link rel=stylesheet type="text/css" href="../../include/table_t.css">
<script language='JavaScript' src='/include/common.js'></script>
<script language='javascript'>
<!--
	//����ϱ�
	function save(){
		var fm = document.form1;
		if(fm.filename.value == ''){					alert('������ �����Ͻʽÿ�.'); 						return; 	}
		if(fm.filename.value.indexOf('xls') == -1 && fm.filename.value.indexOf('xlsx') == -1) {		alert('���������� �ƴմϴ�.');		return;	}
		
		fm.action = 'in_excel_reg.jsp';
		
		if(fm.gubun1[1].checked == true){			fm.action = 'in_excel_reg_deep.jsp';	}	
		
		fm.target = '_blank';	
			
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
    <table border="0" cellspacing="0" cellpadding="0" width=570>
      <tr> 
        <td>
            <table width=100% border=0 cellpadding=0 cellspacing=0>
                <tr>
                    <td width=7><img src=/acar/images/center/menu_bar_1.gif width=7 height=33></td>
                    <td class=bar>&nbsp;&nbsp;&nbsp;<img src=/acar/images/center/menu_bar_dot.gif width=4 height=5 align=absmiddle>&nbsp;������ > ���·���� > <span class=style1><span class=style5>�������� ���</span></span></td>
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
                    <td class='title' rowspan='2'>����</td>
                    <td>&nbsp;
				    <input type="radio" name="gubun1" value="1"  checked>������Ȳ ���
			        </td>
					<td align="center"></td>
                </tr>
                <tr>
                    <td>&nbsp;
				    <input type="radio" name="gubun1" value="2" <%if(from_page.equals("/acar/off_ls_cmplt/off_ls_stat_grid_sc.jsp")){ %>checked<%}%>>������ ���������� ���
			        </td>
					<td align="center"></td>
                </tr>
            </table>
		</td>
    </tr>
    <tr>
        <td align=right>* ���� ���ϸ� �����մϴ�.</td>
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
