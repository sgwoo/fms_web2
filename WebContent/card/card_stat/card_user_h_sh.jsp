<%@ page language="java" contentType="text/html;charset=euc-kr" %>
<%@ page import="java.util.*, card.*"%>
<%@ include file="/tax/cookies_base.jsp" %>

<%
	String cardno 	= request.getParameter("cardno")==null?"":request.getParameter("cardno");
	
	
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
		if(fm.cardno.value == ''){ alert('이력을 조회할 카드를 선택하십시오.'); return;}
		fm.action="card_mng_h_sc.jsp";
		fm.target="cd_foot";		
		fm.submit();
	}
	function enter() {
		var keyValue = event.keyCode;
		if (keyValue =='13') Search();
	}	
	//직원조회
	function User_search(nm, idx){
		var fm = document.form1;
		var t_wd = fm.user_nm.value;
		window.open("about:blank",'User_search','scrollbars=yes,status=no,resizable=yes,width=400,height=500,left=150,top=150');		
		fm.action = "../card_mng/user_search.jsp?nm="+nm+"&idx="+idx+"&t_wd="+t_wd;
		fm.target = "User_search";
		fm.submit();		
	}
	function enter(nm, idx) {
		var keyValue = event.keyCode;
		if (keyValue =='13') User_search(nm, idx);
	}	

	
//-->
</script>

</head>
<body onload="javascript:document.form1.user_nm.focus();">
<form action="" name="form1" method="POST">
  <input type='hidden' name="s_width" value="<%=s_width%>">   
  <input type='hidden' name="s_height" value="<%=s_height%>">     
  <input type='hidden' name="sh_height" value="<%=sh_height%>">   
  <input type='hidden' name='auth_rw' value='<%=auth_rw%>'>
  <input type='hidden' name='br_id' value='<%=br_id%>'>
  <input type='hidden' name='user_id' value='<%=user_id%>'>    
  <input type="hidden" name="idx" value="<%=idx%>">
  <input type="hidden" name="type" value="search">  
  <input type="hidden" name="go_url" value="/card/card_stat/card_user_h_sc.jsp">      
  <input type="hidden" name="s_kd" value="">
  <input type="hidden" name="t_wd" value="">  
  <input type="hidden" name="card_user_id" value="">
<table border=0 cellspacing=0 cellpadding=0 width=100%>
	<tr>
		<td colspan=4>
			<table width=100% border=0 cellpadding=0 cellspacing=0>
				<tr>
					<td width=7><img src=/acar/images/center/menu_bar_1.gif width=7 height=33></td>
					<td class=bar>&nbsp;&nbsp;&nbsp;<img src=/acar/images/center/menu_bar_dot.gif width=4 height=5 align=absmiddle>&nbsp;
						<span class=style1>재무회계 > 법인카드관리 > <span class=style5>사용자별 신용카드이력</span></span></td>
					<td width=7><img src=/acar/images/center/menu_bar_2.gif width=7 height=33></td>
				</tr>
			</table>
		</td>
	</tr>
	  <tr><td class=h></td></tr>
    <tr>
      <td>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;<img src=/acar/images/center/arrow_syj.gif align=absmiddle>&nbsp;
	  <input name="user_nm" type="text" class="text" value="" size="10" style='IME-MODE: active' onKeyDown="javasript:enter('card_user_id', '')">
	  &nbsp;<a href="javascript:User_search('card_user_id', '');"><img src=/acar/images/center/button_search.gif border=0 align=absmiddle></a>
	  </td>
      <td align="right">&nbsp;</td>
    </tr>
  
  </table>
</form>
<iframe src="about:blank" name="i_no" width="0" height="0" frameborder="0" noresize></iframe>
</body>
</html>
