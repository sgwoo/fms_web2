<%@ page language="java" contentType="text/html;charset=euc-kr" %>
<%@ page import="java.util.*"%>
<%@ include file="/tax/cookies_base.jsp" %>

<html>
<head>
<title>FMS</title>
<meta http-equiv="content-type" content="text/html; charset=euc-kr">
<%@ include file="/acar/getNaviCookies.jsp" %>
<link rel="stylesheet" type="text/css" href="/include/table_t.css">
<script language="JavaScript" src="/include/common.js"></script>
<script language="JavaScript">
<!--
	//�ϴ������� ����
	function display_sc(st){
		var fm = document.form1;	
		fm.action = 'ars_call_stat_'+st+'_sc.jsp';
		if(st=='ars_group'){
			fm.action = '/fms2/master/select_stat_etc_list1.jsp';
		}
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
						<span class=style1>�濵���� > �繫ȸ�� > <span class=style5>ARS����</span></span></td>
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
        <input type="button" class="button" value="ARS������Ȳ" onclick="javascript:display_sc('sday');">&nbsp;
        <input type="button" class="button" value="ARS���ſ�����Ȳ" onclick="javascript:display_sc('smon');">&nbsp;
        <input type="button" class="button" value="ARS���ſ�����Ȳ" onclick="javascript:display_sc('syear');">&nbsp;
    	<input type="button" class="button" value="�������� ������Ȳ" onclick="javascript:display_sc('base');">&nbsp;
    	<input type="button" class="button" value="������������������Ȳ" onclick="javascript:display_sc('mon');">&nbsp;
    	<input type="button" class="button" value="ARS��Ʈ��" onclick="javascript:display_sc('ars_group');">&nbsp;
    	<input type="button" class="button" value="ARS�ȳ���" onclick="javascript:display_sc('template');">&nbsp;
    </td>
  </tr>	
</table>
</form>
</body>
</html>
