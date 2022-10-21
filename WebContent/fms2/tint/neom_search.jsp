<%@ page language="java" contentType="text/html;charset=euc-kr" %>
<%@ page import="java.util.*, card.*"%>
<jsp:useBean id="CardDb" scope="page" class="card.CardDatabase"/>
<%@ include file="/tax/cookies_base.jsp" %>

<%
	String go_url 	= request.getParameter("go_url")==null?"":request.getParameter("go_url");

	if(!auth_rw.equals("6")) user_id = "";
	
	//카드 리스트 조회
	Vector card_kinds = CardDb.getCards("", "Y", t_wd, user_id);
	int ck_size = card_kinds.size();
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
		fm.action="neom_search.jsp";
		fm.submit();
	}
	function enter() {
		var keyValue = event.keyCode;
		if (keyValue =='13') Search();
	}	
	function setCardCode(code, name, sdate, edate, etc, user_id, user_nm, card_kind, com_code){
		var fm = document.form1;	

		opener.form1.cardno.value 		= code;		
		opener.form1.card_name.value 	= name;
		opener.form1.card_sdate.value 	= ChangeDate(sdate);
		if(edate.length == 6){
			edate = edate+getMonthDateCnt(edate.substring(0,4), edate.substring(4,6));
		}
		opener.form1.card_edate.value 	= ChangeDate(edate);
		opener.form1.etc.value 			= etc;	
		if(user_id != ''){
			opener.form1.buy_user_id.value 	= user_id;
			opener.form1.user_nm.value 	= user_nm;		
		}
		opener.form1.buy_dt.focus();
		opener.form1.cardno_search.value= '';

		window.close();	
	}
	
//-->
</script>


</head>
<body>
<form action="./neom_search.jsp" name="form1" method="POST">
  <input type='hidden' name="s_width" value="<%=s_width%>">   
  <input type='hidden' name="s_height" value="<%=s_height%>">     
  <input type='hidden' name="sh_height" value="<%=sh_height%>">   
  <input type='hidden' name='auth_rw' value='<%=auth_rw%>'>
  <input type='hidden' name='user_id' value='<%=user_id%>'>  
  <input type="hidden" name="idx" value="<%=idx%>">
  <input type="hidden" name="s_kd" value="<%=s_kd%>">  
  <input type="hidden" name="go_url" value="<%=go_url%>">    
  <table border=0 cellspacing=0 cellpadding=0 width=100%>
    <tr> 
      <td>&nbsp;&nbsp;<%if(s_kd.equals("cardno")){%><img src="/acar/images/center/arrow_cardm.gif" ><%}else if(s_kd.equals("item")){%><img src="/acar/images/center/arrow_carm.gif" ><%}else if(s_kd.equals("ven")){%><img src="/acar/images/center/arrow_glcm.gif" ><%}else if(s_kd.equals("depositma")){%><img src="/acar/images/center/arrow_bank.gif" ><%}%>&nbsp;
        <input name="t_wd" type="text" class="text" value="<%=t_wd%>" size="20" onKeyDown="javasript:enter()" style='IME-MODE: active'>
        &nbsp;<a href="javascript:Search();"><img src=/acar/images/center/button_search.gif border=0 align=absmiddle></a></td>
    </tr>
    <tr><td class=h></td></tr>
    <tr><td class=line2></td></tr>
    <tr>
      <td class="line" >
	    <table border="0" cellspacing="1" cellpadding="0" width='100%'>
	    	
          <tr>
            <td width='10%' class='title'>연번</td>
            <td width='45%' class='title'>코드</td>
            <td width='45%' class='title'>이름</td>
          </tr>
          <%	if(ck_size > 0){
					for (int i = 0 ; i < ck_size ; i++){
						Hashtable card_kind = (Hashtable)card_kinds.elementAt(i);%>
          <tr>
            <td align="center"><%=i+1%></td>
            <td align="center">
			<a href="javascript:setCardCode('<%= card_kind.get("CARDNO") %>','<%= card_kind.get("CARD_NAME") %>','<%= card_kind.get("CARD_SDATE") %>','<%= card_kind.get("CARD_EDATE") %>','<%= card_kind.get("ETC") %>','<%= card_kind.get("USER_CODE") %>','<%= card_kind.get("USER_NM") %>','<%= card_kind.get("CARD_KIND") %>','<%= card_kind.get("COM_CODE") %>')"><%= card_kind.get("CARDNO") %></a>
			</td>
            <td align="center"><%= card_kind.get("CARD_NAME") %></td>
          </tr>
		  <%	}%>
		  <%}else{%>
          <tr>		  
            <td colspan="3" align="center">등록된 데이타가 없습니다.</td>
          </tr>
		  <%}%>		  
        </table>
	</td>
  </tr>
   
    <tr>
      <td align="right">
      	<a href="javascript:window.close();"><img src=/acar/images/center/button_close.gif border=0 align=absmiddle></a>
      	</td>
    </tr>
  </table>
</form>
</body>
</html>

