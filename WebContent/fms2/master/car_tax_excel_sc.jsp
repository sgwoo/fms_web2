<%@ page language="java" contentType="text/html;charset=euc-kr" %>
<%@ page import="java.util.*, acar.util.*, acar.cont.*"%>
<%@ include file="/acar/cookies.jsp" %>
<%@ include file="/acar/access_log.jsp" %>

<html>
<head>
<title>FMS</title>
<meta http-equiv="Content-Type" content="text/html; charset=euc-kr">
<%@ include file="/acar/getNaviCookies.jsp" %>
<link rel=stylesheet type="text/css" href="/include/table_t.css">
<script language='JavaScript' src='/include/common.js'></script>
<script language='javascript'>
<!--
	//����ϱ�
	function save(){
		var fm = document.form1;
		fm.target = '_blank';
		fm.action = 'car_tax_excel.jsp';		
		fm.submit();
	}
	
//-->
</script>
</head>

<body>

  <form name='form1' action='' method='post' enctype="multipart/form-data">
    <table border="0" cellspacing="0" cellpadding="0" width=100%>
	<tr>
    	<td colspan=10>
    	    <table width=100% border=0 cellpadding=0 cellspacing=0>
                <tr>
                    <td width=7><img src=/acar/images/center/menu_bar_1.gif width=7 height=33></td>
                    <td class=bar>&nbsp;&nbsp;&nbsp;<img src=/acar/images/center/menu_bar_dot.gif width=4 height=5 align=absmiddle>&nbsp;<span class=style1>ADMIN > <span class=style5>Ư�Ҽ�����Ȯ��</span></span></td>
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
    			        <a href='javascript:save()'><img src="/acar/images/center/button_reg.gif"  align="absmiddle" border="0"></a>
                    </td>
                </tr>		
            </table>
		</td>
    </tr>
    <tr>
        <td align=right>* ����Ȯ���� <b>*.xls</b> �� ���ϸ� �����մϴ�.</td>
    </tr>	  
    <tr>
        <td align="right">&nbsp;
		</td>
    </tr>
    <tr>
        <td> A:���ʵ����, B:�����ȣ, C:������ȣ</td>
    </tr>    
    
  </table>
  </form>

</body>
</html>