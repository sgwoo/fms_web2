<%@ page language="java" contentType="text/html;charset=euc-kr" %>
<%@ page import="java.util.*"%>
<%@ include file="/tax/cookies_base.jsp" %>

<html>
<head>
<title>FMS</title>
<meta http-equiv="content-type" content="text/html; charset=euc-kr">
<link rel="stylesheet" type="text/css" href="/include/table_t.css">
<script language="JavaScript" src="/include/common.js"></script>
<script language="JavaScript">
<!--
	//�ϴ������� ����
	function display_sc(st){
		var fm = document.form1;	
		fm.action = 'scd_pp_cost_'+st+'_sc.jsp';
		fm.target = 'c_foot';
		fm.submit();
	}
	
//-->
</script>

</head>
<body>
<form action="" name="form1" method="POST">
<%@ include file="/include/search_hidden.jsp" %>
<table border=0 cellspacing=0 cellpadding=0 width=1280>
	<tr>
		<td>
			<table width=100% border=0 cellpadding=0 cellspacing=0>
				<tr>
					<td width=7><img src=/acar/images/center/menu_bar_1.gif width=7 height=33></td>
					<td class=bar>&nbsp;&nbsp;&nbsp;<img src=/acar/images/center/menu_bar_dot.gif width=4 height=5 align=absmiddle>&nbsp;
						<span class=style1>�濵���� > �繫ȸ�� > <span class=style5>�����뿩����Ȳ</span></span></td>
					<td width=7><img src=/acar/images/center/menu_bar_2.gif width=7 height=33></td>
				</tr>
			</table>
		</td>
	</tr>
  <tr>
    <td class=h></td>
  </tr>	
  <tr>
    <td align="center">
        <input type="button" class="button" value="�����ݰ���(�����ݱյ����)" onclick="javascript:display_sc('base2');">&nbsp;
        <input type="button" class="button" value="�����뿩�����(������/���ô뿩��/�Ͻó��뿩��)" onclick="javascript:display_sc('base');">&nbsp;
        <input type="button" class="button" value="���͹ݿ�������" onclick="javascript:display_sc('mon');">&nbsp;
        <input type="button" class="button" value="����������" onclick="javascript:display_sc('day');">&nbsp;
            	    
    	<!--  <a href="javascript:display_sc('case');" title='HOME'>��������(�����뿩��)</a> |--> 
    	
    </td>
  </tr>	
</table>
</form>
</body>
</html>