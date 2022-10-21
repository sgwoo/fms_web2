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
	//하단페이지 보기
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
						<span class=style1>경영정보 > 재무회계 > <span class=style5>ARS관리</span></span></td>
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
        <input type="button" class="button" value="ARS수신현황" onclick="javascript:display_sc('sday');">&nbsp;
        <input type="button" class="button" value="ARS수신월간현황" onclick="javascript:display_sc('smon');">&nbsp;
        <input type="button" class="button" value="ARS수신월별현황" onclick="javascript:display_sc('syear');">&nbsp;
    	<input type="button" class="button" value="당직수당 예정현황" onclick="javascript:display_sc('base');">&nbsp;
    	<input type="button" class="button" value="월별당직수당지급현황" onclick="javascript:display_sc('mon');">&nbsp;
    	<input type="button" class="button" value="ARS파트너" onclick="javascript:display_sc('ars_group');">&nbsp;
    	<input type="button" class="button" value="ARS안내문" onclick="javascript:display_sc('template');">&nbsp;
    </td>
  </tr>	
</table>
</form>
</body>
</html>
