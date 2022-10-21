<%@ page language="java" contentType="text/html;charset=euc-kr" %>
<%@ page import="java.util.*, acar.util.*, acar.common.*, card.*"%>
<jsp:useBean id="CardDb" scope="page" class="card.CardDatabase"/>
<jsp:useBean id="rs_db" scope="page" class="acar.res_search.ResSearchDatabase"/>
<%@ include file="/tax/cookies_base.jsp" %>

<%
	String card_kind 	= request.getParameter("card_kind")==null?"":request.getParameter("card_kind");
	String s_card 	= request.getParameter("s_card")==null?"":request.getParameter("s_card");
	String cardno 	= request.getParameter("cardno")==null?"":request.getParameter("cardno");
	String seq 	= request.getParameter("seq")==null?"":request.getParameter("seq");
	
	CommonDataBase c_db = CommonDataBase.getInstance();
	
	if(auth_rw.equals(""))	auth_rw = rs_db.getXmlAuthRw(user_id, "/card/cash_back/cash_back_frame.jsp");
	
	//카드정보
	CardBean c_bean = CardDb.getCard(cardno);
	
	//카드약정정보
	CardContBean cont_bean = CardDb.getCardCont(cardno, seq);	
	
	
%>

<html>
<head>
<title>FMS</title>
<meta http-equiv="content-type" content="text/html; charset=euc-kr">
<link rel="stylesheet" type="text/css" href="/include/table_t.css">
<script language="JavaScript" src="/include/common.js"></script>
<script language="JavaScript">
<!--
	//네오엠조회
	function Card_search(s_kd){
		var fm = document.form1;
		fm.s_kd.value = s_kd;
		if(s_kd == 'cardno')	fm.t_wd.value = fm.cardno.value;
		if(s_kd == 'agnt_nm')	fm.t_wd.value = fm.agnt_nm.value;
		if(s_kd == 'master_nm')	fm.t_wd.value = fm.master_nm.value;
		if(s_kd == 'n_ven')		fm.t_wd.value = fm.card_kind.value;
		window.open("about:blank",'Card_search','scrollbars=yes,status=no,resizable=yes,width=600,height=500,left=250,top=250');
		fm.action = "card_search.jsp";
		fm.target = "Card_search";
		fm.submit();		
	}
	function Card_enter(s_kd) {
		var keyValue = event.keyCode;
		if (keyValue =='13') Card_search(s_kd);
	}	

	//수정
	function Save(){
		var fm = document.form1;
		
		if(fm.cardno.value == '')	{ alert('신용카드가 선택되지 않았습니다.'); return; }
		if(fm.cont_dt.value == '')	{ alert('약정일자를 입력하십시오.'); return; }
		//if(fm.give_day.value == '')	{ alert('신용공여일수를 입력하십시오.'); return; }
		//if(fm.cont_amt.value == '' || fm.cont_amt.value == '0')	{ alert('신용한도를 입력하십시오.'); return; }
		if(fm.allot_link_yn[0].checked == false && fm.allot_link_yn[1].checked == false)	{alert('대출연계여부를 선택하십시오.');return;}
		if(fm.save_per1.value == '' || fm.save_per1.value == '0')	{ alert('Cash back 일반 적립율을 입력하십시오.'); return; }
		if(fm.allot_link_yn[1].checked == true && (fm.save_per2.value == '' || fm.save_per2.value == '0'))	{ alert('Cash back 대출연계 적립율을 입력하십시오.'); return; }
		//if(fm.agnt_nm.value == '')	{ alert('담당자 이름을 입력하십시오.'); return; }
		//if(fm.agnt_tel.value == '')	{ alert('담당자 연락처를 입력하십시오.'); return; }
		//if(fm.agnt_m_tel.value == '')	{ alert('담당자 핸드폰을 입력하십시오.'); return; }
		
		<%if(!seq.equals("")){%>
			if(fm.reg_type[0].checked == false && fm.reg_type[1].checked == false)	{alert('변경구분을 선택하십시오.');return;}
		<%}%>	
		
		var ment = "수정하시겠습니까?";
		
		if(fm.seq.value == ''){
			ment = "등록하시겠습니까?";
		}
		
		if(confirm(ment)){
			fm.action='card_cont_ui_a.jsp';		
			fm.target='i_no';
			fm.submit();
		}
	}
		
	function Close(){
		window.close();
	}

//-->
</script>

</head>
<body topmargin="10" <%if(cardno.equals("")){%>onload="javascript:document.form1.cardno.focus();"<%}%>>
<form action="" name="form1" method="POST">
<%@ include file="/include/search_hidden.jsp" %>
<input type='hidden' name='go_url' value='/card/cash_back/card_cont_ui.jsp'>
<input type='hidden' name='card_kind' value='<%=card_kind%>'>
<input type='hidden' name='s_card' value='<%=s_card%>'>
<input type='hidden' name='seq' value='<%=seq%>'>
<input type='hidden' name='mode' value=''>
  <table border=0 cellspacing=0 cellpadding=0 width=100%>
	<tr>
		<td colspan=4>
			<table width=100% border=0 cellpadding=0 cellspacing=0>
				<tr>
					<td width=7><img src=/acar/images/center/menu_bar_1.gif width=7 height=33></td>
					<td class=bar>&nbsp;&nbsp;&nbsp;<img src=/acar/images/center/menu_bar_dot.gif width=4 height=5 align=absmiddle>&nbsp;
						<span class=style1>경영정보 > 재무회계 > <span class=style5>Cash back 약정 <%if(seq.equals("")){%>등록<%}else{%>수정<%}%> [<%=c_db.getNameByIdCode("0031", card_kind, "")%>] </span></span></td>
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
              	<%if(cardno.equals("")){%>
                  <input name="cardno" type="text" class="text" value="" size="30" style='IME-MODE: active' onKeyDown="javasript:Card_enter('cardno')"> 
				          <a href="javascript:Card_search('cardno');"><img src=/acar/images/center/button_in_search1.gif border=0 align=absmiddle></a>
				        <%}else{%>  
                  <input name="cardno" type="text" class="whitetext" value="<%=cardno%>" size="30" redeonly>				        
				        <%}%>
              </td>
            </tr>
            <tr>
              <td width='20%'  class='title'>카드구분</td>
              <td>&nbsp;
				        <input name="card_paid" type="text" class="whitetext" value="<%if(c_bean.getCard_paid().equals("2")){%>선불카드<%}else if(c_bean.getCard_paid().equals("3")){%>후불카드<%}else if(c_bean.getCard_paid().equals("5")){%>포인트<%}else if(c_bean.getCard_paid().equals("7")){%>카드할부<%}%>" size="30" redeonly>
              </td>
            </tr>            
            <tr>
              <td width='20%'  class='title'>사용자구분</td>
              <td>&nbsp;
				        <input name="card_name" type="text" class="whitetext" value="<%=c_bean.getCard_name()%>" size="30" redeonly>
              </td>
            </tr>            
		    </td>
                </tr>
            </table>
        </td>
    </tr>
    <tr> 
        <td align="right">&nbsp;</td>
    </tr>
    <tr><td class=line2></td></tr> 	
    <tr>
        <td class="line">
	        <table border="0" cellspacing="1" cellpadding="0" width='100%'>
            <tr>
              <td width='20%' class='title'>약정일자</td>
              <td>&nbsp;
                  <input name="cont_dt" type="text" class="text" value="<%=AddUtil.ChangeDate2(cont_bean.getCont_dt())%>" size="12" onBlur='javascript:this.value=ChangeDate(this.value)'></td>
            </tr>
            <tr>
              <td class='title'>신용공여일수</td>
              <td>&nbsp;
                  <input type="text" name="give_day" size="2" value="<%=cont_bean.getGive_day()%>" class=num> 일
                  &nbsp;&nbsp;&nbsp;
                  <input type='radio' name="give_day_st" value='1' <%if(cont_bean.getGive_day_st().equals("") || cont_bean.getGive_day_st().equals("1"))%>checked<%%>>
        				  영업일
        	        <input type='radio' name="give_day_st" value='2' <%if(cont_bean.getGive_day_st().equals("2"))%>checked<%%>>
        				  달력일
			  </td>
            </tr>
            <tr>
              <td class='title'>신용한도</td>
              <td>&nbsp;
                  <input type="text" name="cont_amt" size="15" value="<%=AddUtil.parseDecimalLong(cont_bean.getCont_amt())%>" class=num onBlur='javascript:this.value=parseDecimal(this.value)'>
      		원</td>
            </tr>         
            <tr>
              <td class='title'>대출연계여부</td>
              <td>&nbsp;
              	  <input type='radio' name="allot_link_yn" value='N' <%if(cont_bean.getAllot_link_yn().equals("N"))%>checked<%%>>
        				  없다
        	        <input type='radio' name="allot_link_yn" value='Y' <%if(cont_bean.getAllot_link_yn().equals("Y"))%>checked<%%>>
        				  있다
              </td>
            </tr>
            <tr>
              <td class='title'>Cash back 적립율</td>
              <td>&nbsp;
                  일반 : <input type="text" name="save_per1" size="4" value="<%=cont_bean.getSave_per1()%>" class=num>%
                  &nbsp;
                  (선불카드,카드할부)
                  대출연계 : <input type="text" name="save_per2" size="4" value="<%=cont_bean.getSave_per2()%>" class=num>%
      		    </td>
            </tr>
            <tr>
              <td rowspan='2' class='title'>적립금 입금예정일</td>
              <td>&nbsp;
              	  <input type="checkbox" name="save_in_dt_st1" value="Y" <%if(cont_bean.getSave_in_dt_st1().equals("Y"))%>checked<%%>>
                  수시
                  <input type="checkbox" name="save_in_dt_st2" value="Y" <%if(cont_bean.getSave_in_dt_st2().equals("Y"))%>checked<%%>>
                  약정일
                  <input type="checkbox" name="save_in_dt_st3" value="Y" <%if(cont_bean.getSave_in_dt_st3().equals("Y"))%>checked<%%>>
                  매월 
                  <input type="text" name="save_in_dt" size="2" value="<%=cont_bean.getSave_in_dt()%>" class=num>일
              </td>
            </tr>
            <tr>
              <td>&nbsp;
              	  <textarea rows='2' cols='90' name='save_in_st'><%=cont_bean.getSave_in_st()%></textarea>
              </td>
            </tr>
            <tr>
              <td class='title'>담당자</td>
              <td>&nbsp;
              	  <a href="javascript:Card_search('agnt_nm');"><img src=/acar/images/center/button_in_search1.gif border=0 align=absmiddle></a>
              	  &nbsp;
                  이름 : <input type="text" name="agnt_nm" size="10" value="<%=cont_bean.getAgnt_nm()%>" class=text> 
                  &nbsp;
                  연락처 : <input type="text" name="agnt_tel" size="15" value="<%=cont_bean.getAgnt_tel()%>" class=text>
                  &nbsp;
                  핸드폰 : <input type="text" name="agnt_m_tel" size="15" value="<%=cont_bean.getAgnt_m_tel()%>" class=text>
              </td>
            </tr>
            <tr>
              <td class='title'>관리자</td>
              <td>&nbsp;
              	  <a href="javascript:Card_search('master_nm');"><img src=/acar/images/center/button_in_search1.gif border=0 align=absmiddle></a>
              	  &nbsp;
                  이름 : <input type="text" name="master_nm" size="10" value="<%=cont_bean.getMaster_nm()%>" class=text> 
                  &nbsp;
                  연락처 : <input type="text" name="master_tel" size="15" value="<%=cont_bean.getMaster_tel()%>" class=text>
                  &nbsp;
                  핸드폰 : <input type="text" name="master_m_tel" size="15" value="<%=cont_bean.getMaster_m_tel()%>" class=text>
              </td>
            </tr>
            <tr>
              <td class='title'>적요</td>
              <td>&nbsp;
                  <textarea rows='2' cols='90' name='etc'><%=cont_bean.getEtc()%></textarea>
              </td>
            </tr>
            <tr>
              <td class='title'>입금원장 연동</td>
              <td>&nbsp;
                  <a href="javascript:Card_search('n_ven');"><img src=/acar/images/center/button_in_search1.gif border=0 align=absmiddle></a>
                  &nbsp;
                  거래처코드 : <input type="text" name="n_ven_code" size="10" value="<%=cont_bean.getN_ven_code()%>" class=text readonly> 
                  &nbsp;
                  거래처명 : <input type="text" name="n_ven_name" size="25" value="<%=cont_bean.getN_ven_name()%>" class=text readonly>
              </td>
            </tr>            
            <%if(!seq.equals("")){%>
            <tr>
              <td class='title'>변경구분</td>
              <td>&nbsp;
                  <input type='radio' name="reg_type" value='H'>
        				  변경(이력관리)
        	        <input type='radio' name="reg_type" value='U'>
        				  내용정정
              </td>
            </tr>
            <%}%>

          </table></td>
  </tr>
  <tr><td class=h></td></tr>  
    <tr> 
      <td align="right">
        <%if( auth_rw.equals("6")) {%>
        <a href="javascript:Save();"><img src=/acar/images/center/button_<%if(seq.equals("")){%>reg<%}else{%>modify<%}%>.gif border=0 align=absmiddle></a>
        &nbsp;
        <%}%>
	      <a href="javascript:Close();"><img src=/acar/images/center/button_close.gif border=0 align=absmiddle></a>
      </td>
    </tr>
  </table>
</form>
<iframe src="about:blank" name="i_no" width="0" height="0" frameborder="0" noresize></iframe>
</body>
</html>
