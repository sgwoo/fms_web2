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
		fm.action = 'card_'+st+'_sc.jsp';		
		if(st=='rtn' || st=='pay'){
			fm.action = 'card_'+st+'_sc2.jsp';
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
						<span class=style1>�濵���� > �繫ȸ�� > <span class=style5>ī��ĳ������Ȳ</span></span></td>
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
    	<input type="button" class="button" value="HOME" onclick="javascript:display_sc('base');">&nbsp;
    	<input type="button" class="button" value="���(�ű�/����)" onclick="javascript:display_sc('reg');">&nbsp;
    	<input type="button" class="button" value="������Ȳ" onclick="javascript:display_sc('cont');">&nbsp;
    	<input type="button" class="button" value="������Ȳ" onclick="javascript:display_sc('day');">&nbsp;
    	<input type="button" class="button" value="������Ȳ" onclick="javascript:display_sc('mon');">&nbsp;
    	<input type="button" class="button" value="ī��纰������Ȳ" onclick="javascript:display_sc('pay');">&nbsp;
    	<input type="button" class="button" value="�Աݿ���(ī��ĳ����)" onclick="javascript:display_sc('incom');">
    	<input type="button" class="button" value="ī���ݻ�ȯ������" onclick="javascript:display_sc('rtn');">
    	<!--  
    	<a href="javascript:display_sc('base');" title='HOME'>HOME</a> | 
    	<a href="javascript:display_sc('reg');" title='HOME'>���(�ű�/����)</a> | 
    	<a href="javascript:display_sc('cont');" title='HOME'>������Ȳ</a> | 
    	<a href="javascript:display_sc('day');" title='HOME'>������Ȳ</a> | 
    	<a href="javascript:display_sc('mon');" title='HOME'>������Ȳ</a> | 
    	<a href="javascript:display_sc('pay');" title='HOME'>ī��纰������Ȳ</a> | 
    	<a href="javascript:display_sc('incom');" title='HOME'>�Աݿ���(ī��ĳ����)</a> -->
    </td>
  </tr>	
</table>
</form>
</body>
</html>
