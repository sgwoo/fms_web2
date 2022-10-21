<%@ page language="java" contentType="text/html;charset=euc-kr" %>
<%@ page import="java.util.*, card.*"%>
<jsp:useBean id="CardDb" scope="page" class="card.CardDatabase"/>
<%@ include file="/tax/cookies_base.jsp" %>

<%
	//카드관리자 리스트 조회
	Vector card_m_ids = CardDb.getCardMngIds("card_mng_id", "", "Y");
	int cmi_size = card_m_ids.size();
	//전표승인자 리스트 조회
	Vector card_d_ids = CardDb.getCardMngIds("doc_mng_id", "", "Y");
	int cdi_size = card_d_ids.size();
%>

<html>
<head>
<title>FMS</title>
<meta http-equiv="content-type" content="text/html; charset=euc-kr">
	<%@ include file="/acar/getNaviCookies.jsp" %>
<link rel="stylesheet" type="text/css" href="/include/table_t.css">
<script language="JavaScript" src="/include/common.js"></script>
<script language="JavaScript">
<!--
	function Search(){
		var fm = document.form1;
		fm.action="doc_mng_sc3.jsp";
		fm.target="c_foot";		
		fm.submit();
	}
	function enter() {
		var keyValue = event.keyCode;
		if (keyValue =='13') Search();
	}	
	//직원리스트
	function GetUsetList(nm){
		var fm = document.form1;
		te = fm.gubun4;
		te.options[0].value = '';
		te.options[0].text = '전체';
		fm.nm.value = "form1."+nm;
		fm.target = "i_no";
		fm.action = "../card_mng/user_null.jsp";
		fm.submit();
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

  <input type="hidden" name="nm" value="">

  <table border=0 cellspacing=0 cellpadding=0 width=100%>
    <tr>
      <td colspan=5><table width=100% border=0 cellpadding=0 cellspacing=0>
          <tr>
            <td width=7><img src=/acar/images/center/menu_bar_1.gif width=7 height=33></td>
            <td class=bar>&nbsp;&nbsp;&nbsp;<img src=/acar/images/center/menu_bar_dot.gif width=4 height=5 align=absmiddle>&nbsp; <span class=style1>재무회계 > 법인전표관리 > <span class=style5>카드전표 팀장확인</span></span></td>
            <td width=7><img src=/acar/images/center/menu_bar_2.gif width=7 height=33></td>
          </tr>
      </table></td>
    </tr>
    <tr>
      <td class=h></td>
    </tr>
    <tr>
      <td colspan="2">&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;<img src="/acar/images/center/arrow_gggub.gif" >&nbsp;
          <select name="gubun1" >
            <option value="1" <%if(gubun1.equals("1")){%> selected <%}%>>거래일자&nbsp;</option>
            <option value="2" <%if(gubun1.equals("2")){%> selected <%}%>>작성일자&nbsp;</option>
            <option value="3" <%if(gubun1.equals("3")){%> selected <%}%>>승인일자&nbsp;</option>
          </select>
          <input type="text" name="st_dt" size="12" value="<%=st_dt%>" class="text">
&nbsp;~&nbsp;
      <input type="text" name="end_dt" size="12" value="<%=end_dt%>" class="text">
      </td>
    <td><img src="/acar/images/center/arrow_sij.gif" >&nbsp;
          <select name='gubun6'>
            <option value="0">전체</option>
            <%	if(cdi_size > 0){
					for (int i = 0 ; i < cdi_size ; i++){
						Hashtable card_d_id = (Hashtable)card_d_ids.elementAt(i);%>
            <option value='<%= card_d_id.get("USER_ID") %>' <%if(gubun6.equals(String.valueOf(card_d_id.get("USER_ID")))){%>selected<%}%>><%= card_d_id.get("USER_NM") %></option>
            <%	}
				}%>
        </select></td>
      <td width="30%"><div align="left"><a href="javascript:Search();" ><img src=/acar/images/center/button_search.gif border=0 align=absmiddle></a></div></td>
      <td width="8%"></td>
    </tr>
        	
  </table>
</form>
<iframe src="about:blank" name="i_no" width="0" height="0" frameborder="0" noresize></iframe>
</body>
</html>
