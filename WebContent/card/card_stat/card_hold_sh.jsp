<%@ page language="java" contentType="text/html;charset=euc-kr" %>
<%@ page import="java.util.*, card.*"%>
<%@ include file="/tax/cookies_base.jsp" %>

<%
	
%>

<html>
<head>
<title>FMS</title>
<meta http-equiv="content-type" content="text/html; charset=euc-kr">
<link rel="stylesheet" type="text/css" href="/include/table_t.css">
<script language="JavaScript" src="/include/common.js"></script>
<script language="JavaScript">
<!--
	function Search(){
		var fm = document.form1;
		fm.action="card_end_sc.jsp";
		fm.target="cd_foot";		
		fm.submit();
	}
	function enter() {
		var keyValue = event.keyCode;
		if (keyValue =='13') Search();
	}	
//-->
</script>

</head>
<body>
<form action="" name="form1" method="POST">
  <input type='hidden' name="s_width" value="<%=s_width%>">   
  <input type='hidden' name="s_height" value="<%=s_height%>">     
  <input type='hidden' name="sh_height" value="<%=sh_height%>">   
  <input type='hidden' name='auth_rw' value='<%=auth_rw%>'>
  <input type='hidden' name='br_id' value='<%=br_id%>'>
  <input type='hidden' name='user_id' value='<%=user_id%>'>    
  <input type="hidden" name="idx" value="<%=idx%>">
  <input type="hidden" name="type" value="search">  
  <input type="hidden" name="go_url" value="/tax/scd_mng/scd_mng_sc.jsp">      
  <input type="hidden" name="nm" value="">
  <table border=0 cellspacing=0 cellpadding=0 width=100%>
	<tr>
		<td colspan=4>
			<table width=100% border=0 cellpadding=0 cellspacing=0>
				<tr>
					<td width=7><img src=/acar/images/center/menu_bar_1.gif width=7 height=33></td>
					<td class=bar>&nbsp;&nbsp;&nbsp;<img src=/acar/images/center/menu_bar_dot.gif width=4 height=5 align=absmiddle>&nbsp;
						<span class=style1>�繫ȸ�� > ������ǥ���� > <span class=style5>ī�庸����Ȳ</span></span></td>
					<td width=7><img src=/acar/images/center/menu_bar_2.gif width=7 height=33></td>
				</tr>
			</table>
		</td>
	</tr>
	<tr><td class=h></td></tr>
    <tr>
      <td>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;<img src=/acar/images/center/arrow_gji.gif border=0 align=absmiddle>&nbsp;
		<input type="text" name="st_dt" size="12" value="<%=AddUtil.getDate()%>" class="whitetext">
      </td>
      <td align="right">&nbsp;</td>
    </tr>
  </table>
</form>
<iframe src="about:blank" name="i_no" width="0" height="0" frameborder="0" noresize></iframe>
</body>
</html>
