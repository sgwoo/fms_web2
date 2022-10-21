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
	//하단페이지 보기
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
						<span class=style1>경영정보 > 재무회계 > <span class=style5>카드캐쉬백현황</span></span></td>
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
    	<input type="button" class="button" value="등록(신규/변경)" onclick="javascript:display_sc('reg');">&nbsp;
    	<input type="button" class="button" value="약정현황" onclick="javascript:display_sc('cont');">&nbsp;
    	<input type="button" class="button" value="일일현황" onclick="javascript:display_sc('day');">&nbsp;
    	<input type="button" class="button" value="월간현황" onclick="javascript:display_sc('mon');">&nbsp;
    	<input type="button" class="button" value="카드사별수금현황" onclick="javascript:display_sc('pay');">&nbsp;
    	<input type="button" class="button" value="입금원장(카드캐쉬백)" onclick="javascript:display_sc('incom');">
    	<input type="button" class="button" value="카드대금상환스케줄" onclick="javascript:display_sc('rtn');">
    	<!--  
    	<a href="javascript:display_sc('base');" title='HOME'>HOME</a> | 
    	<a href="javascript:display_sc('reg');" title='HOME'>등록(신규/변경)</a> | 
    	<a href="javascript:display_sc('cont');" title='HOME'>약정현황</a> | 
    	<a href="javascript:display_sc('day');" title='HOME'>일일현황</a> | 
    	<a href="javascript:display_sc('mon');" title='HOME'>월간현황</a> | 
    	<a href="javascript:display_sc('pay');" title='HOME'>카드사별수금현황</a> | 
    	<a href="javascript:display_sc('incom');" title='HOME'>입금원장(카드캐쉬백)</a> -->
    </td>
  </tr>	
</table>
</form>
</body>
</html>
