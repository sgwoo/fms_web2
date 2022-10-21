<%@ page language="java" contentType="text/html;charset=euc-kr" %>
<%@ page import="java.util.*, acar.common.*, card.*, acar.user_mng.*"%>
<jsp:useBean id="CardDb" scope="page" class="card.CardDatabase"/>
<%@ include file="/tax/cookies_base.jsp" %>

<%
	MaMenuDatabase nm_db = MaMenuDatabase.getInstance();
	CommonDataBase c_db = CommonDataBase.getInstance();
	
	//영업소 리스트 조회
	Vector branches = c_db.getBranchs();
	int brch_size = branches.size();
	//담당자 리스트
	Vector users = c_db.getUserList("", "", "EMP");
	int user_size = users.size();
	//추가 : 소유자 리스트
	Vector users3 = c_db.getUserList2("", "", gubun4);
	int user3_size = users3.size();
	
	Vector users2 = c_db.getUserList("9999", "", "", "N"); //퇴사자 리스트
	int user_size2 = users2.size();
	
	
	//코드 구분:부서명-가산점적용
	CodeBean[] depts = c_db.getCodeAll2("0002", "");
	int dept_size = depts.length;
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
		fm.action="doc_mng_sc2.jsp";
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
            <td class=bar>&nbsp;&nbsp;&nbsp;<img src=/acar/images/center/menu_bar_dot.gif width=4 height=5 align=absmiddle>&nbsp; <span class=style1>재무회계 > 법인전표관리 > <span class=style5>카드전표조회2</span></span></td>
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
      <td><img src="/acar/images/center/arrow_gjgm.gif" >&nbsp;
          <select name='gubun2'>
            <option value="">전체</option>
            <option value="00001" <%if(gubun2.equals("00001")){%> selected <%}%>>복리후생비</option>
            <option value="00002" <%if(gubun2.equals("00002")){%> selected <%}%>>접대비</option>
            <option value="00003" <%if(gubun2.equals("00003")){%> selected <%}%>>여비교통비</option>
            <option value="00004" <%if(gubun2.equals("00004")){%> selected <%}%>>차량유류대</option>
            <option value="00005" <%if(gubun2.equals("00005")){%> selected <%}%>>차량정비비</option>
            <option value="00006" <%if(gubun2.equals("00006")){%> selected <%}%>>사고수리비</option>
            <option value="00007" <%if(gubun2.equals("00007")){%> selected <%}%>>사무용품비</option>
            <option value="00008" <%if(gubun2.equals("00008")){%> selected <%}%>>소모품비</option>
            <option value="00009" <%if(gubun2.equals("00009")){%> selected <%}%>>통신비</option>
            <option value="00010" <%if(gubun2.equals("00010")){%> selected <%}%>>도서인쇄비</option>
            <option value="00011" <%if(gubun2.equals("00011")){%> selected <%}%>>지급수수료</option>
            <option value="00012" <%if(gubun2.equals("00012")){%> selected <%}%>>비품</option>
            <option value="00013" <%if(gubun2.equals("00013")){%> selected <%}%>>선급금</option>
            <option value="00014" <%if(gubun2.equals("00014")){%> selected <%}%>>교육훈련비</option>
			<option value="00015" <%if(gubun2.equals("00015")){%> selected <%}%>>세금과공과</option>		  
			<option value="00016" <%if(gubun2.equals("00016")){%> selected <%}%>>대여사업차량</option>		  
			<option value="00017" <%if(gubun2.equals("00017")){%> selected <%}%>>리스사업차량</option>	
			<option value="00018" <%if(gubun2.equals("00018")){%> selected <%}%>>운반비</option>	
			<option value="00019" <%if(gubun2.equals("00019")){%> selected <%}%>>주차요금</option>			  						
        </select></td>
      <td width="30%"><%if(nm_db.getWorkAuthUser("전산팀",user_id)){%>
        <img src="/acar/images/center/arrow_drj.gif" >&nbsp;
        <select name='gubun8'>          
          <option value="">전체</option>
          <%	if(user_size > 0){
						for (int i = 0 ; i < user_size ; i++){
							Hashtable user = (Hashtable)users.elementAt(i);	%>
          <option value='<%=user.get("USER_ID")%>' <%if(gubun8.equals(user.get("USER_ID"))) out.println("selected");%>><%=user.get("USER_NM")%></option>
          <%		}
				}%>
          <option value="">=퇴사자=</option>
          <%if(user_size2 > 0){
				for (int i = 0 ; i < user_size2 ; i++){
					Hashtable user2 = (Hashtable)users2.elementAt(i);	%>
          <option value='<%=user2.get("USER_ID")%>' <%if(gubun8.equals(user2.get("USER_ID"))) out.println("selected");%>><%=user2.get("USER_NM")%></option>
          <%	}
			}%>
        </select>
        <%}%></td>
      <td width="8%" align="right"><div align="left">
      </div></td>
    </tr>
    <tr>
      <td width="20%">&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;<img src="/acar/images/center/arrow_yus.gif" >&nbsp;&nbsp;&nbsp;
          <select name='s_br' onChange="javascript:GetUsetList('gubun4');">
            <option value=''>전체</option>
            <%	if(brch_size > 0){
					for (int i = 0 ; i < brch_size ; i++){
						Hashtable branch = (Hashtable)branches.elementAt(i);%>
            <option value='<%= branch.get("BR_ID") %>' <%if(s_br.equals(String.valueOf(branch.get("BR_ID")))){%>selected<%}%>><%= branch.get("BR_NM")%></option>
            <%		}
				}%>
          </select>
      </td>
      <td width="17%"><img src="/acar/images/center/arrow_bsm.gif" >&nbsp;
          <select name='gubun3' onChange="javascript:GetUsetList('gubun4');">
            <option value=''>전체</option>
            <%for(int i = 0 ; i < dept_size ; i++){
				CodeBean dept = depts[i];%>
            <option value='<%=dept.getCode()%>' <%if(gubun3.equals(dept.getCode())){%>selected<%}%>><%=dept.getNm()%></option>
            <%	
				}%>
          </select>
      </td>
      <td><img src="/acar/images/center/arrow_syj.gif" >&nbsp;&nbsp;&nbsp;&nbsp;
          <select name='gubun4' onChange="javascript:GetUsetList('gubun7');">
            <option value="">전체</option>
            <%	if(user_size > 0){
						for (int i = 0 ; i < user_size ; i++){
							Hashtable user = (Hashtable)users.elementAt(i);	%>
            <option value='<%=user.get("USER_ID")%>' <%if(gubun4.equals(user.get("USER_ID"))) out.println("selected");%>><%=user.get("USER_NM")%></option>
            <%		}
				}%>
            <option value="">=퇴사자=</option>
            <%if(user_size2 > 0){
				for (int i = 0 ; i < user_size2 ; i++){
					Hashtable user2 = (Hashtable)users2.elementAt(i);	%>
            <option value='<%=user2.get("USER_ID")%>' <%if(gubun4.equals(user2.get("USER_ID"))) out.println("selected");%>><%=user2.get("USER_NM")%></option>
            <%	}
			}%>
          </select>
      </td>
      <td><img src="/acar/images/center/arrow_suj.gif" >&nbsp;
        <select name='gubun7'>
       	
          

          <%	if(user3_size > 0){
						for (int i = 0 ; i < user3_size ; i++){
							Hashtable user3 = (Hashtable)users3.elementAt(i);	%>
          <option value='<%=user3.get("USER_ID")%>' <%if(gubun7.equals(gubun4)) out.println("selected");%>><%=user3.get("USER_NM")%></option>
          <%		}
				}%>
				
          
        </select></td>
      <td align="right"><div align="left">      </div></td>
    </tr>
    <tr>
      <td>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;<img src="/acar/images/center/arrow_glj.gif" >&nbsp;&nbsp;&nbsp;&nbsp;
          <select name='gubun5'>
            <option value="0">전체</option>
            <%	if(cmi_size > 0){
					for (int i = 0 ; i < cmi_size ; i++){
						Hashtable card_m_id = (Hashtable)card_m_ids.elementAt(i);%>
            <option value='<%= card_m_id.get("USER_ID") %>' <%if(gubun5.equals(String.valueOf(card_m_id.get("USER_ID")))){%>selected<%}%>><%= card_m_id.get("USER_NM") %></option>
            <%		}
				}%>
        </select></td>
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
      <td colspan="2"><img src="/acar/images/center/arrow_card.gif" >&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;
          <input type="text" name="t_wd1" class="text">
&nbsp;<span class="style2">(카드번호,소유자구분) </span></td>
      <td align="right">&nbsp;</td>
    </tr>
    <tr>
      <td colspan="2">&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;<img src="/acar/images/center/arrow_siyb.gif" >&nbsp;
      <input type="radio" name="chk2" value="" <%if(chk2.equals("")){%> checked <%}%>>
      전체
      <input type="radio" name="chk2" value="Y" <%if(chk2.equals("Y")){%> checked <%}%>>
      승인
      <input type="radio" name="chk2" value="N" <%if(chk2.equals("N")){%> checked <%}%>>
      미승인 </td>
	  
      <td><div align="right"><a href="javascript:Search();" ><img src=/acar/images/center/button_search.gif border=0 align=absmiddle></a></div></td>
    </tr>
    	
  </table>
</form>
<iframe src="about:blank" name="i_no" width="0" height="0" frameborder="0" noresize></iframe>
</body>
</html>
