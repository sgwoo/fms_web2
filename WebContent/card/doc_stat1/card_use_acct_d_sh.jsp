<%@ page language="java" contentType="text/html;charset=euc-kr" %>
<%@ page import="java.util.*, acar.util.*, acar.common.*, card.*"%>
<jsp:useBean id="CardDb" scope="page" class="card.CardDatabase"/>
<%@ include file="/tax/cookies_base.jsp" %>

<%
	CommonDataBase c_db = CommonDataBase.getInstance();
	//영업소 리스트 조회
	Vector branches = c_db.getBranchs();
	int brch_size = branches.size();
	
	//코드 구분:부서명-가산점적용
	CodeBean[] depts = c_db.getCodeAll2("0002", "");
	int dept_size = depts.length;
	//카드관리자 리스트 조회
	Vector card_m_ids = CardDb.getCardMngIds("card_mng_id", "", "Y");
	int cmi_size = card_m_ids.size();
	//전표스인자 리스트 조회
	Vector card_d_ids = CardDb.getCardMngIds("doc_mng_id", "", "Y");
	int cdi_size = card_d_ids.size();
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
		fm.action="card_use_acct_d_sc.jsp";
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
  <input type="hidden" name="chk1" value="3">  
  <table border=0 cellspacing=0 cellpadding=0 width=100%>
	<tr>
		<td colspan=3>
			<table width=100% border=0 cellpadding=0 cellspacing=0>
				<tr>
					<td width=7><img src=/acar/images/center/menu_bar_1.gif width=7 height=33></td>
					<td class=bar>&nbsp;&nbsp;&nbsp;<img src=/acar/images/center/menu_bar_dot.gif width=4 height=5 align=absmiddle>&nbsp;
						<span class=style1>재무회계 > 법인전표관리 > <span class=style5>계정과목별현황 - 일간</span></span></td>
					<td width=7><img src=/acar/images/center/menu_bar_2.gif width=7 height=33></td>
				</tr>
			</table>
		</td>
	</tr>
	<tr><td class=h></td></tr>
    <tr>
      <td>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;<img src="/acar/images/center/arrow_gjij.gif" >&nbsp;
        <input type="text" name="st_dt" size="12" value="<%=AddUtil.ChangeDate2(st_dt)%>" class="text" onBlur='javascript:this.value=ChangeDate(this.value)'>
		&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;<img src="/acar/images/center/arrow_yus.gif" >&nbsp;
		<%if(br_id.equals("S1")){%>
		<select name='s_br' onChange="javascript:GetUsetList('gubun4');">
		  <option value=''>전체</option>
		  <%	if(brch_size > 0){
					for (int i = 0 ; i < brch_size ; i++){
						Hashtable branch = (Hashtable)branches.elementAt(i);%>
		  <option value='<%= branch.get("BR_ID") %>' <%if(s_br.equals(String.valueOf(branch.get("BR_ID")))){%>selected<%}%>><%= branch.get("BR_NM")%></option>
	  <%		}
				}%>
		</select>
		<%}else{%>
		<%=c_db.getNameById(br_id,"BRCH")%>
		<input type="hidden" name="s_br" value="<%=br_id%>">
		<%}%>
		&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;<img src="/acar/images/center/arrow_bsm.gif" >&nbsp;
		<select name='gubun3' onChange="javascript:GetUsetList('gubun4');">
		  <option value=''>전체</option>
		  <%for(int i = 0 ; i < dept_size ; i++){
						CodeBean dept = depts[i];%>
		  <option value='<%=dept.getCode()%>' <%if(gubun3.equals(dept.getCode())){%>selected<%}%>><%=dept.getNm()%></option>
		  <%	
						}%>
		</select>
		&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;<img src="/acar/images/center/arrow_print.gif" >&nbsp;
        <input type="radio" name="chk2" value="1" <%if(chk2.equals("1")){%> checked <%}%>>
전체
<input type="radio" name="chk2" value="2" <%if(chk2.equals("2")){%> checked <%}%>>
계정과목별
		&nbsp;&nbsp;<a href="javascript:Search();"><img src=/acar/images/center/button_search.gif border=0 align=absmiddle></a></td>
      <td align="right">&nbsp;</td>
    </tr>
  </table>
</form>
<iframe src="about:blank" name="i_no" width="0" height="0" frameborder="0" noresize></iframe>
</body>
</html>
