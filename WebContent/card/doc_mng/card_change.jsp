<%@ page language="java" contentType="text/html;charset=euc-kr" %>
<%@ page import="java.util.*, acar.util.*, card.*, acar.bill_mng.*"%>
<%@ include file="/tax/cookies_base.jsp" %>

<%
	String cardno 	= request.getParameter("cardno")==null?"":request.getParameter("cardno");
	String buy_id 	= request.getParameter("buy_id")==null?"":request.getParameter("buy_id");
%>

<html>
<head>
<title>FMS</title>
<meta http-equiv="content-type" content="text/html; charset=euc-kr">
<link rel="stylesheet" type="text/css" href="../../include/table_t.css">
<script language="JavaScript" src="/include/common.js"></script>
<script language="JavaScript">
<!--
	//등록
	function Save()
	{
		var fm = document.form1;	
		
		if(fm.cardno.value == '')	{	alert('카드번호를 입력하십시오.'); 	fm.cardno.focus(); 		return; }

		if(confirm('등록하시겠습니까?')){					
			fm.action='card_change_a.jsp';		
			fm.target='i_no';
			fm.submit();
		}
	}


	
	//조회---------------------------------------------------------------------------------------------------------------
	
	//네오엠조회-신용카드
	function Neom_search(s_kd){
		var fm = document.form1;
		fm.s_kd.value = s_kd;
		if(s_kd == 'cardno')	fm.t_wd.value = fm.cardno_search.value;
		window.open("about:blank",'Neom_search','scrollbars=yes,status=no,resizable=yes,width=600,height=500,left=350,top=150');		
		fm.action = "/card/doc_reg/neom_search.jsp";
		fm.target = "Neom_search";
		fm.submit();		
	}
	function Neom_enter(s_kd) {
		var keyValue = event.keyCode;
		if (keyValue =='13') Neom_search(s_kd);
	}	
	
//-->
</script>

</head>
<body onLoad="javascript:document.form1.cardno_search.focus();">
<form action="" name="form1" method="POST">
<%@ include file="/include/search_hidden.jsp" %>
  <input type="hidden" name="o_buy_id" value="<%=buy_id%>">
  <input type="hidden" name="o_cardno" value="<%=cardno%>">
  <input type="hidden" name="user_nm" value="">
  <input type="hidden" name="user_nm" value="">  
  <input type="hidden" name="buy_user_id" value="">
  <input type="hidden" name="etc" value="">  
<table border=0 cellspacing=0 cellpadding=0 width=100%>
		<tr>
		<td colspan=4>
			<table width=100% border=0 cellpadding=0 cellspacing=0>
				<tr>
					<td width=7><img src=/acar/images/center/menu_bar_1.gif width=7 height=33></td>
					<td class=bar>&nbsp;&nbsp;&nbsp;<img src=/acar/images/center/menu_bar_dot.gif width=4 height=5 align=absmiddle>&nbsp;
						<span class=style1>재무회계 > 법인전표승인 > <span class=style5>카드변경</span></span></td>
					<td width=7><img src=/acar/images/center/menu_bar_2.gif width=7 height=33></td>
				</tr>
			</table>
		</td>
	</tr>
	<tr><td class=h></td></tr>	<tr><td class=h></td></tr>
	<tr><td class=line2 colspan=2></td></tr>
    <tr> 
    	<td colspan="2" class="line">
    		<table border="0" cellspacing="1" cellpadding="0" width='100%'>
        		<tr> 
            		<td width='15%'  class='title'>카드 조회</td>
            		<td colspan="3">&nbsp; 
            			<input name="cardno_search" type="text" class="text" value="" size="30" style='IME-MODE: active' onKeyDown="javasript:Neom_enter('cardno')" >
              			&nbsp;<a href="javascript:Neom_search('cardno');" ><img src=/acar/images/center/button_in_search1.gif border=0 align=absmiddle></a>&nbsp;(카드번호/사용자명으로 검색)
						
            		</td>
          		</tr>          
          		<tr> 
            		<td width='15%'  class='title'>신용카드번호</td>
            		<td width="35%">&nbsp; <input name="cardno" type="text" class="whitetext" value="<%=cardno%>" size="30"></td>
            		<td width="15%" class='title'>사용자구분</td>
            		<td>&nbsp; <input name="card_name" type="text" class="whitetext" value="" size="30" redeonly></td>
          		</tr>
          		
          		<tr> 
            		<td class='title'>발급일자</td>
            		<td>&nbsp; <input name="card_sdate" type="text" class="whitetext" value="" size="15" redeonly></td>
            		<td class='title'>만기일자</td>
            		<td>&nbsp; <input name="card_edate" type="text" class="whitetext" value="" size="15" redeonly><input name="buy_dt" type="text" class="whitetext" value="" size="5" redeonly></td>
          		</tr>
				
        	</table>
        </td>
    </tr>   
    <tr>
    	<td class=h></td>
    </tr>
    <%if( auth_rw.equals("2") || auth_rw.equals("4") || auth_rw.equals("6")) {%>
    <tr>
        <td>&nbsp; </td>
        <td align="right">
      		<a href="javascript:Save()"><img src=/acar/images/center/button_reg.gif border=0 align=absmiddle></a>
      	</td>
    </tr> 
    <%}%>
</table>            
</form>    
<iframe src="about:blank" name="i_no" width="0" height="0" frameborder="0" noresize></iframe>         
</body>             
</html>             