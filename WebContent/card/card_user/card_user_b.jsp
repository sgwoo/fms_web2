<%@ page language="java" contentType="text/html;charset=euc-kr" %>
<%@ page import="java.util.*, acar.util.*, acar.common.*, card.*"%>
<jsp:useBean id="CardDb" scope="page" class="card.CardDatabase"/>
<%@ include file="/tax/cookies_base.jsp" %>

<%
	String cardno 	= request.getParameter("cardno")==null?"":request.getParameter("cardno");
	String seq 		= request.getParameter("seq")==null?"01":request.getParameter("seq");

	CommonDataBase c_db = CommonDataBase.getInstance();
	
	//카드정보
	CardBean c_bean = CardDb.getCard(cardno);
	
	CardUserBean cu_bean = CardDb.getCardUser(cardno, seq);
%>

<html>
<head>
<title>FMS</title>
<meta http-equiv="content-type" content="text/html; charset=euc-kr">
<link rel="stylesheet" type="text/css" href="/include/table_t.css">
<script language="JavaScript" src="/include/common.js"></script>
<script language="JavaScript">
<!--
	//수정
	function Save(){
		var fm = document.form1;
		fm.use_s_dt2.value = fm.use_s_dt.value + fm.use_s_dt_h.value
		fm.use_e_dt2.value = fm.use_e_dt.value + fm.use_e_dt_h.value
//		if(fm.use_e_dt2.value == '')	{	alert('카드회수일을 입력하십시오.'); return; }	
					
		if(confirm('수정하시겠습니까?')){					
			fm.action='card_user_b_a.jsp';		
			fm.target='i_no';
			fm.submit();
		}
	}

	//직원조회
	function User_search(nm, idx){
		var fm = document.form1;
		var t_wd = fm.user_nm[idx].value;
		window.open("about:blank",'User_search','scrollbars=yes,status=no,resizable=yes,width=400,height=400,left=250,top=250');		
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
<body topmargin="10" onload="javascript:document.form1.use_e_dt.focus();">
<form action="./client_mng_frame.jsp" name="form1" method="POST">
<%@ include file="/include/search_hidden.jsp" %>
<input type='hidden' name='idx' value='<%=idx%>'>
<input type='hidden' name='seq' value='<%=seq%>'>
<input type='hidden' name='use_s_dt2' value=''>
<input type='hidden' name='use_e_dt2' value=''>

  <table border=0 cellspacing=0 cellpadding=0 width=100%>
   <tr>
		<td colspan=4>
			<table width=100% border=0 cellpadding=0 cellspacing=0>
				<tr>
					<td width=7><img src=/acar/images/center/menu_bar_1.gif width=7 height=33></td>
					<td class=bar>&nbsp;&nbsp;&nbsp;<img src=/acar/images/center/menu_bar_dot.gif width=4 height=5 align=absmiddle>&nbsp;
						<span class=style1>재무회계 > 법인카드관리 > <span class=style5>사용자 카드회수</span></span></td>
					<td width=7><img src=/acar/images/center/menu_bar_2.gif width=7 height=33></td>
				</tr>
			</table>
		</td>
	</tr>
	<tr><td class=h></td></tr>
	<tr><td class=line2></td></tr>
    <tr>
      <td class="line">
	      <table border="0" cellspacing="1" cellpadding="0" width='100%'>
            <tr>
              <td width='20%'  class='title'>신용카드번호</td>
              <td>&nbsp;
                  <input name="cardno" type="text" class="whitetext" value="<%=cardno%>" size="30" redeonly> 
              </td>
            </tr>
          <tr>
            <td class='title'>사용자구분</td>
            <td>&nbsp; 
			  <input name="card_name" type="text" class="whitetext" value="<%=c_bean.getCard_name()%>" size="30" redeonly></td>
          </tr>			
          <tr>
            <td class='title'>발급일자</td>
            <td>&nbsp;
			  <input name="card_sdate" type="text" class="whitetext" value="<%=AddUtil.ChangeDate2(c_bean.getCard_sdate())%>" size="11" onBlur='javascript:this.value=ChangeDate(this.value)' redeonly></td>
          </tr>
          <tr>
            <td class='title'>만기일자</td>
            <td>&nbsp;
			  <input name="card_edate" type="text" class="whitetext" value="<%=AddUtil.ChangeDate2(c_bean.getCard_edate())%>" size="11" onBlur='javascript:this.value=ChangeDate(this.value)' redeonly></td>
          </tr>
          <tr>
            <td class='title'>카드수령일자</td>
            <td>&nbsp;
              <input name="receive_dt" type="text" class="whitetext" value="<%=AddUtil.ChangeDate2(c_bean.getReceive_dt())%>" onBlur='javascript:this.value=ChangeDate(this.value)' size="11" redeonly></td>
          </tr>
          <tr>
            <td class='title'>카드관리자</td>
            <td>&nbsp;
                <input name="user_nm" type="text" class="whitetext" value="<%=c_db.getNameById(c_bean.getCard_mng_id(),"USER")%>" size="10" style='IME-MODE: active' redeonly>
                <input type='hidden' name='card_mng_id' value='<%=c_bean.getCard_mng_id()%>'>
            </td>
          </tr>
          <tr>
            <td class='title'>전표승인자</td>
            <td>&nbsp;
                <input name="user_nm" type="text" class="whitetext" value="<%=c_db.getNameById(c_bean.getDoc_mng_id(),"USER")%>" size="10" style='IME-MODE: active' redeonly>
                <input type='hidden' name='doc_mng_id' value='<%=c_bean.getDoc_mng_id()%>'>
            </td>
          </tr>
          </table></td>
    </tr>
    <tr> 
      <td align="right">&nbsp;</td>
    </tr>	
    <tr><td class=line2></td></tr>	
    <tr>
      <td class="line">
	    <table border="0" cellspacing="1" cellpadding="0" width='100%'>
          <tr>
            <td width='20%' class='title'>사용자</td>
            <td>&nbsp;
              <input name="user_nm" type="text" class="whitetext" value="<%=c_db.getNameById(cu_bean.getUser_id(),"USER")%>" size="10" style='IME-MODE: active' redeonly>
              <input type='hidden' name='card_user_id' value='<%=cu_bean.getUser_id()%>'>
			  </td>
          </tr>
          <tr>
            <td class='title'>카드지급일</td>
            <td>&nbsp;
              <input name="use_s_dt" type="text" class="whitetext" value="<%=AddUtil.ChangeDate2(cu_bean.getUse_s_dt())%>" onBlur='javascript:this.value=ChangeDate(this.value)' size="11" redeonly>
				<%	String use_s_dt_h = "";
					if(cu_bean.getUse_s_dt().length() == 10) use_s_dt_h = cu_bean.getUse_s_dt().substring(8, 10);%>			  
			  <input name="use_s_dt_h" type="text" class="whitetext" value="<%=use_s_dt_h%>" size="2" redeonly>시
<!--			  ( 카드수령일과 동일
              <input type="checkbox" name="dt_chk" value="Y" onClick="javascript:Dt_chk();"> )-->
		    </td>
          </tr>
          <tr>
            <td class='title'>카드회수일</td>
            <td>&nbsp;
              <input name="use_e_dt" type="text" class="text" value="<%=AddUtil.getTime().substring(0,10)%>" onBlur='javascript:this.value=ChangeDate(this.value)' size="11">
			  <input name="use_e_dt_h" type="text" class="text" value="<%=AddUtil.getTime().substring(11,13)%>" size="2">시			  
			  </td>
          </tr>
          <tr>
            <td class='title'>사용시작일</td>
            <td>&nbsp;
              <input name="r_use_s_dt" type="text" class="whitetext" value="<%=AddUtil.ChangeDate2(cu_bean.getR_use_s_dt())%>" onBlur='javascript:this.value=ChangeDate(this.value)' size="11" redeonly>				
		    </td>
          </tr>		  
        </table>
	</td>
  </tr>	
    <tr> 
      <td align="right">
          <%if( auth_rw.equals("2") || auth_rw.equals("4") || auth_rw.equals("6")) {%>
          <a href="javascript:Save();"><img src=/acar/images/center/button_modify.gif border=0 align=absmiddle></a>&nbsp;
          <%}%>
	  <a href="javascript:window.close();"><img src=/acar/images/center/button_close.gif border=0 align=absmiddle></a>
      </td>	  
    </tr>  
  </table>
</form>
<iframe src="about:blank" name="i_no" width="0" height="0" frameborder="0" noresize></iframe>
</body>
</html>
