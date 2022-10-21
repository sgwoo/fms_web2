<%@ page language="java" contentType="text/html;charset=euc-kr" %>
<%@ page import="java.util.*, acar.common.*, card.*"%>
<jsp:useBean id="CardDb" scope="page" class="card.CardDatabase"/>
<jsp:useBean id="rs_db" scope="page" class="acar.res_search.ResSearchDatabase"/>
<%@ include file="/tax/cookies_base.jsp" %>

<%
	CommonDataBase c_db = CommonDataBase.getInstance();
	//카드종류 리스트 조회
	Vector card_kinds = CardDb.getCardKinds("", "");
	int ck_size = card_kinds.size();
	//영업소 리스트 조회
	Vector branches = c_db.getBranchs();
	int brch_size = branches.size();
	//담당자 리스트
	Vector users = c_db.getUserList("", "", "EMP");
	int user_size = users.size();
	//코드 구분:부서명-가산점적용
	CodeBean[] depts = c_db.getCodeAll2("0002", "");
	int dept_size = depts.length;
	//카드관리자 리스트 조회
	Vector card_m_ids = CardDb.getCardMngIds("card_mng_id", "", "Y");
	int cmi_size = card_m_ids.size();
	//전표스인자 리스트 조회
	Vector card_d_ids = CardDb.getCardMngIds("doc_mng_id", "", "Y");
	int cdi_size = card_d_ids.size();
	
	if(auth_rw.equals(""))	auth_rw = rs_db.getAuthRw(user_id, "05", "09", "01");
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
		fm.action="card_mng_sc.jsp";
		fm.target="c_foot";		
		fm.submit();
	}
	function enter() {
		var keyValue = event.keyCode;
		if (keyValue =='13') Search();
	}	
	//카드입력
	function CardMngReg(){
		var fm = document.form1;
		fm.action = "card_mng_i.jsp";
		window.open("about:blank", "CardMngView", "left=50, top=50, width=800, height=800, scrollbars=yes, status=yes");
		fm.target = "CardMngView";
		fm.submit();
	}
	//직원리스트
	function GetUsetList(nm){
		var fm = document.form1;
		te = fm.gubun4;
		te.options[0].value = '';
		te.options[0].text = '조회중';
		fm.nm.value = "form1."+nm;
		fm.target = "i_no";
		fm.action = "user_null.jsp";
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
  <input type="hidden" name="go_url" value="/tax/scd_mng/scd_mng_sc.jsp">      
  <input type="hidden" name="nm" value="">
<table border=0 cellspacing=0 cellpadding=0 width=100%>
	<tr>
		<td colspan=7>
			<table width=100% border=0 cellpadding=0 cellspacing=0>
				<tr>
					<td width=7><img src=/acar/images/center/menu_bar_1.gif width=7 height=33></td>
					<td class=bar>&nbsp;&nbsp;&nbsp;<img src=/acar/images/center/menu_bar_dot.gif width=4 height=5 align=absmiddle>&nbsp;
						<span class=style1>재무회계 > 법인카드관리 > <span class=style5>신용카드 관리</span></span></td>
					<td width=7><img src=/acar/images/center/menu_bar_2.gif width=7 height=33></td>
				</tr>
			</table>
		</td>
	</tr>
    <tr>
        <td class=h></td>
    </tr>
    <tr>
      <td width=85>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;<img src=/acar/images/center/arrow_ydgb.gif align=absmiddle></td>
      <td width=160><select name="gubun1" >
          <option value=''>전체</option>
          <option value='1' <%if(gubun1.equals("1")){%>selected<%}%>>구매자금용</option>
          <option value='2' <%if(gubun1.equals("2")){%>selected<%}%>>공용</option>
          <option value='3' <%if(gubun1.equals("3")){%>selected<%}%>>임/직원지급용</option>
          <option value='4' <%if(gubun1.equals("4")){%>selected<%}%>>하이패스</option>		  
	  <option value='5' <%if(gubun1.equals("5")){%>selected<%}%>>세금납부용</option>
	  <option value='6' <%if(gubun1.equals("6")){%>selected<%}%>>포인트</option>					  
        </select>
	  </td>
      <td width=60><img src=/acar/images/center/arrow_cdjr.gif align=absmiddle>&nbsp;</td>
      <td width=150><select name="gubun2" >
          <option value=''>전체</option>
          <%	if(ck_size > 0){
					for (int i = 0 ; i < ck_size ; i++){
						Hashtable card_kind = (Hashtable)card_kinds.elementAt(i);%>
          <option value='<%= card_kind.get("CARD_KIND") %>' <%if(gubun2.equals(String.valueOf(card_kind.get("CARD_KIND")))){%>selected<%}%>><%= card_kind.get("CARD_KIND") %></option>
          <%		}
				}%>
        </select>
		</td>
      <td width=60><img src=/acar/images/center/arrow_syyb.gif align=absmiddle></td>
      <td width=400><input type="radio" name="chk1" value="0" <%if(chk1.equals("0")){%> checked <%}%>>
		전체
		<input type="radio" name="chk1" value="Y" <%if(chk1.equals("Y")){%> checked <%}%>>
		사용
		<input type="radio" name="chk1" value="N" <%if(chk1.equals("N")){%> checked <%}%>>
		폐기</td>
      <td align="right" width=300>&nbsp;</td>
    </tr>
    
    <tr>
      <td>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;<img src=/acar/images/center/arrow_yus.gif align=absmiddle></td>
      <td><%if(br_id.equals("S1")){%>
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
	  </td>
      <td><img src=/acar/images/center/arrow_bsm.gif align=absmiddle>
       <td><select name='gubun3' onChange="javascript:GetUsetList('gubun4');">
          <option value=''>전체</option>
          <%for(int i = 0 ; i < dept_size ; i++){
				CodeBean dept = depts[i];%>
          <option value='<%=dept.getCode()%>' <%if(gubun3.equals(dept.getCode())){%>selected<%}%>><%=dept.getNm()%></option>
          <%	
				}%>
        </select>
	  </td>
      <td><img src=/acar/images/center/arrow_syj.gif align=absmiddle></td>
      <td><select name='gubun4' onChange='javascript:Search();'>
          <option value="">전체</option>
          <%	if(user_size > 0){
						for (int i = 0 ; i < user_size ; i++){
							Hashtable user = (Hashtable)users.elementAt(i);	%>
          <option value='<%=user.get("USER_ID")%>' <%if(gubun4.equals(user.get("USER_ID"))) out.println("selected");%>><%=user.get("USER_NM")%></option>
          <%		}
				}%>
        </select>
	  </td>
      <td align="right">&nbsp;</td>
    </tr>
    
    <tr>
      <td>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;<img src=/acar/images/center/arrow_glj.gif align=absmiddle></td>
      <td><select name='gubun5' onChange='javascript:Search();'>
          <option value="0">전체</option>
          <%	if(cmi_size > 0){
					for (int i = 0 ; i < cmi_size ; i++){
						Hashtable card_m_id = (Hashtable)card_m_ids.elementAt(i);%>
          <option value='<%= card_m_id.get("USER_ID") %>' <%if(gubun5.equals(String.valueOf(card_m_id.get("USER_ID")))){%>selected<%}%>><%= card_m_id.get("USER_NM") %></option>
          <%		}
				}%>
        </select></td>
      <td><img src=/acar/images/center/arrow_sij.gif align=absmiddle></td>
      <td><select name='gubun6' onChange='javascript:Search();'>
          <option value="0">전체</option>
          <%	if(cdi_size > 0){
					for (int i = 0 ; i < cdi_size ; i++){
						Hashtable card_d_id = (Hashtable)card_d_ids.elementAt(i);%>
          <option value='<%= card_d_id.get("USER_ID") %>' <%if(gubun6.equals(String.valueOf(card_d_id.get("USER_ID")))){%>selected<%}%>><%= card_d_id.get("USER_NM") %></option>
          <%		}
				}%>
        </select></td>
      <td><img src=/acar/images/center/arrow_card.gif align=absmiddle></td>
      <td><input type="text" name="t_wd1" class="text" value='<%=t_wd1%>' onKeyDown='javascript:enter()' style='IME-MODE: active'>&nbsp;</font><span class="style2">(카드번호,사용자구분)
        </span> </td>
        <td>&nbsp;</td>
    </tr>
    <tr>
	  <td align="right" colspan=7><a href="javascript:Search();"><img src=/acar/images/center/button_search.gif border=0 align=absmiddle></a>&nbsp;
	  <%if(auth_rw.equals("6")){%>
				<a href="javascript:CardMngReg();"><img src=/acar/images/center/button_reg.gif border=0 align=absmiddle></a>
			<%}%>	
				&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;<!--<a href="javascript:list_print()"><img src="../../images/printer.gif" border="0"></a>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;-->
	  </td>
	</tr>
  </table>
</form>
<iframe src="about:blank" name="i_no" width="0" height="0" frameborder="0" noresize></iframe>
</body>
</html>
