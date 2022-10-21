<%@ page language="java" contentType="text/html;charset=euc-kr" %>
<%@ page import="java.util.*, acar.common.*, card.*"%>
<jsp:useBean id="CardDb" scope="page" class="card.CardDatabase"/>
<%@ include file="/tax/cookies_base.jsp" %>

<%

	//String gubun7 = request.getParameter("gubun7")==null?"":request.getParameter("gubun7");

	CommonDataBase c_db = CommonDataBase.getInstance();
	//영업소 리스트 조회
	Vector branches = c_db.getBranchs();
	int brch_size = branches.size();
	//담당자 리스트
	Vector users = c_db.getUserList("", "", "EMP");
	int user_size = users.size();
	Vector users2 = c_db.getUserList("9999", "", "", "N"); //퇴사자 리스트
	int user_size2 = users2.size();
	//코드 구분:부서명-가산점적용
	CodeBean[] depts = c_db.getCodeAll2("0002", "");
	int dept_size = depts.length;
	//카드관리자 리스트 조회
	Vector card_m_ids = CardDb.getCardMngIds("card_mng_id", "", "Y");
	int cmi_size = card_m_ids.size();
	//전표스인자 리스트 조회
	Vector card_d_ids = CardDb.getCardMngIds("doc_mng_id", "", "Y");
	int cdi_size = card_d_ids.size();
	
	//카드종류 리스트 조회
	Vector card_kinds = CardDb.getCardKinds("", "");
	int ck_size = card_kinds.size();
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
		var chk1;
		if(fm.chk1[2].checked == true && fm.st_dt.value == ''){ alert('임의기간으로 조회를 원하시면 일자를 넣어주십시오.'); fm.st_dt.focus(); return; }
		if(fm.chk1[0].checked == true) chk1 = 1;
		if(fm.chk1[1].checked == true) chk1 = 2;
		if(fm.chk1[2].checked == true) chk1 = 3;
		fm.action="card_use_card_sc"+chk1+".jsp";
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
		<td colspan=2>
			<table width=100% border=0 cellpadding=0 cellspacing=0>
				<tr>
					<td width=7><img src=/acar/images/center/menu_bar_1.gif width=7 height=33></td>
					<td class=bar>&nbsp;&nbsp;&nbsp;<img src=/acar/images/center/menu_bar_dot.gif width=4 height=5 align=absmiddle>&nbsp;
						<span class=style1>재무회계 > 법인전표관리 > <span class=style5>카드별사용현황(기간)</span></span></td>
					<td width=7><img src=/acar/images/center/menu_bar_2.gif width=7 height=33></td>
				</tr>
			</table>
		</td>
	</tr>
	<tr><td colspan=2 class=h></td></tr> 
    <tr>
      <td>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;<img src=/acar/images/center/arrow_cdjr.gif align=absmiddle>&nbsp;&nbsp;
	    <select name="gubun2" >
          <option value=''>전체</option>
          <%	if(ck_size > 0){
					for (int i = 0 ; i < ck_size ; i++){
						Hashtable card_kind = (Hashtable)card_kinds.elementAt(i);%>
          <option value='<%= card_kind.get("CARD_KIND") %>' <%if(gubun2.equals(String.valueOf(card_kind.get("CARD_KIND")))){%>selected<%}%>><%= card_kind.get("CARD_KIND") %></option>
          <%		}
				}%>
        </select>
		&nbsp;&nbsp;
	    <img src="/acar/images/center/arrow_ggjh.gif" >&nbsp;
        <input type="radio" name="chk1" value="1" <%if(chk1.equals("1")){%> checked <%}%>>
		당일
		<input type="radio" name="chk1" value="2" <%if(chk1.equals("2")){%> checked <%}%>>
		당월 
		<input type="radio" name="chk1" value="3" <%if(chk1.equals("3")){%> checked <%}%>>
		임의기간 &nbsp;
		<input type="text" name="st_dt" size="12" value="<%=st_dt%>" class="text">
		&nbsp;~&nbsp;
		<input type="text" name="end_dt" size="12" value="<%=end_dt%>" class="text">
		
		&nbsp;&nbsp;</td>
      <td align="right">&nbsp;</td>
    </tr>
    <tr>
      <td>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;<img src="/acar/images/center/arrow_yus.gif" >&nbsp;&nbsp;&nbsp;&nbsp;
        <%if(br_id.equals("S1")){%>
        <select name='s_br'>
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
        <%}%> &nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;<img src="/acar/images/center/arrow_bsm.gif" >&nbsp;
        <select name='gubun3'>
          <option value=''>전체</option>
          <%for(int i = 0 ; i < dept_size ; i++){
				CodeBean dept = depts[i];%>
          <option value='<%=dept.getCode()%>' <%if(gubun3.equals(dept.getCode())){%>selected<%}%>><%=dept.getNm()%></option>
          <%	
				}%>
        </select>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;
		<img src="/acar/images/center/arrow_suj.gif" >&nbsp;<select name='gubun7'><!-- onChange='javascript:Search();'-->
          <option value="">전체</option>
          <%	if(user_size > 0){
						for (int i = 0 ; i < user_size ; i++){
							Hashtable user = (Hashtable)users.elementAt(i);	%>
          <option value='<%=user.get("USER_ID")%>' <%if(gubun7.equals(user.get("USER_ID"))) out.println("selected");%>><%=user.get("USER_NM")%></option>
          <%		}
				}%>
		  <option value="">=퇴사자=</option>
          <%if(user_size2 > 0){
				for (int i = 0 ; i < user_size2 ; i++){
					Hashtable user2 = (Hashtable)users2.elementAt(i);	%>
          <option value='<%=user2.get("USER_ID")%>' <%if(gubun7.equals(user2.get("USER_ID"))) out.println("selected");%>><%=user2.get("USER_NM")%></option>
          <%	}
			}%>						
        </select>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;
		<img src=/acar/images/center/arrow_jrjg.gif align=absmiddle>&nbsp;
                      <select name='sort'>
                        <option value='1' <%if(sort.equals("1")){%> selected <%}%>>소유자</option>
                        <option value='2' <%if(sort.equals("2")){%> selected <%}%>>카드번호</option>
                      </select>
		</td>
      <td align="right">&nbsp;</td>
    </tr>
    <tr>
	  <td align="right" colspan=2><a href="javascript:Search();" ><img src=/acar/images/center/button_search.gif border=0 align=absmiddle></a>&nbsp;
	  </td>
	</tr>	
  </table>
</form>
<iframe src="about:blank" name="i_no" width="0" height="0" frameborder="0" noresize></iframe>
</body>
</html>
