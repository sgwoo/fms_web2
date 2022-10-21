<%@ page language="java" contentType="text/html;charset=euc-kr" %>
<%@ page import="java.util.*, acar.util.*, card.*, acar.bill_mng.*"%>
<jsp:useBean id="CardDb" scope="page" class="card.CardDatabase"/>
<%@ include file="/tax/cookies_base.jsp" %>

<%
	NeoErpUDatabase neoe_db = NeoErpUDatabase.getInstance();
	
	//카드종류 리스트 조회
	Vector card_kinds = CardDb.getCardKinds("CODE", "Y");
	int ck_size = card_kinds.size();
	
	
	//은행계좌번호
	Vector banks = neoe_db.getFeeDepositList();
	int bank_size = banks.size();
%>

<html>
<head>
<title>FMS</title>
<meta http-equiv="content-type" content="text/html; charset=euc-kr">
<link rel="stylesheet" type="text/css" href="/include/table_t.css">
<script language="JavaScript" src="/include/common.js"></script>
<script language="JavaScript">
<!--
	//등록
	function Save(){
		var fm = document.form1;
		
		if(fm.use_s_m.value == fm.use_e_m.value){
			if(toInt(fm.use_s_day.value) >= toInt(fm.use_e_day.value)){
				alert('카드사용기간 일자를 확인하십시오.'); return;
			}
		}
		
		if(fm.cardno.value == '')	{		alert('카드번호를 입력하십시오.'); return; }
		if(fm.card_st.value == '')	{		alert('용도구분을 선택하십시오.'); return; }
		
		if(fm.card_kind.value == ''){		alert('카드종류을 선택하십시오.'); return; }		
		
		if(fm.card_paid.value == '')	{		alert('지불구분을 선택하십시오.'); return; }		
		if(fm.ven_code.value == ''){		alert('거래처를 선택하십시오.'); return; }		
		if(fm.receive_dt.value == ''){		alert('카드수령일을 입력하십시오.'); return; }				
		if(fm.user_nm[0].value == '' || fm.card_mng_id.value == ''){	alert('카드관리자를 검색하십시오.'); 	return; }
		if(fm.user_nm[1].value == '' || fm.doc_mng_id.value == ''){		alert('전표승인자를 검색하십시오.'); 	return; }				
		if(fm.card_user_id.value != ''){
			if(fm.use_s_dt.value == ''){	alert('카드지급일을 입력하십시오.'); return; }
			if(fm.use_s_dt_h.value == ''){	alert('카드지급시간을 입력하십시오.'); return; }			
		}
		

		fm.use_s_dt2.value = fm.use_s_dt.value + fm.use_s_dt_h.value
		fm.use_e_dt2.value = fm.use_e_dt.value + fm.use_e_dt_h.value
		if(confirm('등록하시겠습니까?')){					
			fm.action='card_mng_i_a.jsp';		
			fm.target='i_no';
//			fm.target='CardMngView';
			fm.submit();
		}
	}

	//네오엠조회
	function Neom_search(s_kd){
		var fm = document.form1;
		fm.s_kd.value = s_kd;
		if(s_kd == 'cardno')	fm.t_wd.value = fm.cardno.value;
		window.open("about:blank",'Neom_search','scrollbars=yes,status=no,resizable=yes,width=600,height=500,left=250,top=250');		
		fm.action = "neom_search.jsp";
		fm.target = "Neom_search";
		fm.submit();		
	}
	function Neom_enter(s_kd) {
		var keyValue = event.keyCode;
		if (keyValue =='13') Neom_search(s_kd);
	}	
	
	//직원조회
	function User_search(nm, idx){
		var fm = document.form1;
		var t_wd = fm.user_nm[idx].value;
		window.open("about:blank",'User_search','scrollbars=yes,status=no,resizable=yes,width=400,height=400,left=250,top=250');		
		fm.action = "user_search.jsp?nm="+nm+"&idx="+idx+"&t_wd="+t_wd;
		fm.target = "User_search";
		fm.submit();		
	}
	function enter(nm, idx) {
		var keyValue = event.keyCode;
		if (keyValue =='13') User_search(nm, idx);
	}	
	
	//거래처조회하기
	function search(idx){
		var fm = document.form1;
		var t_wd = "카드";		
		if(fm.ven_name.value != '') t_wd = fm.ven_name.value;
		window.open("/acar/con_debt/vendor_list.jsp?idx="+idx+"&t_wd="+t_wd, "VENDOR_LIST", "left=300, top=300, width=450, height=400, scrollbars=yes");		
	}	

	//카드수령일과 카드지급일 동일시 체크하면 값 넘기기
	function Dt_chk(){
		var fm = document.form1;
		if(fm.dt_chk.checked == true){
			fm.use_s_dt.value = fm.receive_dt.value;
		}else{
			fm.use_s_dt.value = '';
		}
	}
	
//-->
</script>

</head>
<body topmargin="10" onload="javascript:document.form1.cardno.focus();">
<form action="./client_mng_frame.jsp" name="form1" method="POST">
<%@ include file="/include/search_hidden.jsp" %>
<input type='hidden' name='idx' value='<%=idx%>'>
<input type='hidden' name='use_yn' value='Y'>
<input type='hidden' name='use_s_dt2' value=''>
<input type='hidden' name='use_e_dt2' value=''>
  <table border=0 cellspacing=0 cellpadding=0 width=100%>
   <tr>
		<td colspan=4>
			<table width=100% border=0 cellpadding=0 cellspacing=0>
				<tr>
					<td width=7><img src=/acar/images/center/menu_bar_1.gif width=7 height=33></td>
					<td class=bar>&nbsp;&nbsp;&nbsp;<img src=/acar/images/center/menu_bar_dot.gif width=4 height=5 align=absmiddle>&nbsp;
						<span class=style1>재무회계 > 법인카드관리 > <span class=style5>신용카드 등록</span></span></td>
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
                  <input name="cardno" type="text" class="text" value="" size="30" style='IME-MODE: active' onKeyDown="javasript:Neom_enter('cardno')"> 
				  <a href="javascript:Neom_search('cardno');"><img src=/acar/images/center/button_in_search1.gif border=0 align=absmiddle></a>
              </td>
            </tr>
          <tr>
            <td class='title'>사용자구분</td>
            <td>&nbsp; 
			<input name="card_name" type="text" class="text" value="" size="30">(한글10자)</td>
          </tr>			
          <tr>
            <td class='title'>발급일자</td>
            <td>&nbsp;
			<input name="card_sdate" type="text" class="text" value="" size="11" onBlur='javascript:this.value=ChangeDate(this.value)'></td>
          </tr>
          <tr>
            <td class='title'>만기일자</td>
            <td>&nbsp;
			<input name="card_edate" type="text" class="text" value="" size="11" onBlur='javascript:this.value=ChangeDate(this.value)'></td>
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
            <td width='20%' class='title'>용도구분</td>
            <td>&nbsp;
          	  <select name="card_st" >
            	<option value=''>선택</option>
				<option value='1'>구매자금용</option>
				<option value='2'>공용</option>
				<option value='3'>임/직원지급용</option>
				<option value='4'>하이패스</option>				
				<option value='5'>세금납부용</option>				
				<option value='6'>포인트</option>				
          	  </select>        
			  </td>
          </tr>
          <tr>
            <td width='20%' class='title'>카드유형</td>
            <td>&nbsp;
          	  <select name="card_type" >
            	<option value=''>선택</option>
				<option value='1'>VISA</option>
				<option value='2'>MASTER</option>
				<option value='3'>BC</option>
				<option value='4'>DYNASTY</option>				
          	  </select>        
			  </td>
          </tr>
          <tr>
            <td width='20%' class='title'>카드종류</td>
            <td>&nbsp;
          	  <select name="card_kind" >
            	<option value=''>선택</option>
            	<%	if(ck_size > 0){
						for (int i = 0 ; i < ck_size ; i++){
							Hashtable card_kind = (Hashtable)card_kinds.elementAt(i);%>
            	<option value='<%= card_kind.get("CODE") %>'><%= card_kind.get("CARD_KIND") %></option>
            	<%		}
					}%>
          	  </select>      			  
			  </td>
          </tr>
          <tr>
            <td width='20%' class='title'>지불구분</td>
            <td>&nbsp;
          	  <select name="card_paid" >
            	<option value=''>선택</option>
				<option value='2'>선불카드</option>
				<option value='3'>후불카드</option>
				<option value='5'>포인트</option>
				<option value='7'>카드할부</option>
          	  </select>        
			  </td>
          </tr>          
          <tr>
            <td class='title'>거래처</td>
            <td>&nbsp;  
			<input type='text' name='ven_code' value='' size="6" class="text" redeonly>&nbsp;<input name="ven_name" type="text" class="text" value="" size="30"> <a href="javascript:search('');"><img src=/acar/images/center/button_in_search1.gif border=0 align=absmiddle></a></td>
          </tr>			
          <tr>
            <td class='title'>결제일</td>
            <td>&nbsp; 매월 
              <input type="text" name="pay_day" size="2" class=text>
            일 결제 </td>
          </tr>
            <tr>
              <td class='title'>결제계좌</td>
              <td>&nbsp; <select name='acc_no'>
                        <option value=''>계좌를 선택하세요</option>
					    <%	if(bank_size > 0){
								for(int i = 0 ; i < bank_size ; i++){
									Hashtable bank = (Hashtable)banks.elementAt(i);%>
						<option value='<%= bank.get("DEPOSIT_NO")%>'>[<%=bank.get("CHECKD_NAME")%>]<%= bank.get("DEPOSIT_NO")%>&nbsp;:&nbsp;<%= bank.get("DEPOSIT_NAME")%></option>
			            <%		}
							}%>

                      </select>
			  </td>
            </tr>          
          <tr>
            <td class='title'>카드사용기간</td>
            <td>&nbsp;
              <select name="use_s_m" >
                <option value="">선택</option>			  
                <option value="1">전전월</option>
                <option value="2">전월</option>
              </select>
              <input type="text" name="use_s_day" size="2" class=text>
				일 ~ 
			  <select name="use_e_m" >
                <option value="">선택</option>			  
  				<option value="2">전월</option>
  				<option value="3">당월</option>
			  </select>
			  <input type="text" name="use_e_day" size="2" class=text>
			  	일</td>
          </tr>
          <tr>
            <td class='title'>한도구분</td>
            <td>&nbsp;
			<select name="limit_st" >
              <option value="">선택</option>			
              <option value="1">개별한도</option>
              <option value="2">통합한도</option>
            </select></td>
          </tr>
          <tr>
            <td class='title'>한도금액</td>
            <td>&nbsp;
			<input type="text" name="limit_amt" size="15" class=num onBlur='javascript:this.value=parseDecimal(this.value)'>
			원</td>
          </tr>
          <tr>
            <td class='title'>카드수령일자</td>
            <td>&nbsp;
              <input name="receive_dt" type="text" class="text" onBlur='javascript:this.value=ChangeDate(this.value)' value="" size="11"></td>
          </tr>
          <tr>
            <td class='title'>카드관리자</td>
            <td>&nbsp;
			  <input name="user_nm" type="text" class="text" value="" size="10" style='IME-MODE: active' onKeyDown="javasript:enter('card_mng_id', 0)">
			  <input type='hidden' name='card_mng_id' value=''>
              <a href="javascript:User_search('card_mng_id', 0);"><img src=/acar/images/center/button_in_search1.gif border=0 align=absmiddle></a></td>
          </tr>
          <tr>
            <td class='title'>전표승인자</td>
            <td>&nbsp;
              <input name="user_nm" type="text" class="text" value="" size="10" style='IME-MODE: active' onKeyDown="javasript:enter('doc_mng_id', 1)">
			  <input type='hidden' name='doc_mng_id' value=''>
              <a href="javascript:User_search('doc_mng_id', 1);"><img src=/acar/images/center/button_in_search1.gif border=0 align=absmiddle></a></td>
          </tr>
          <tr>
            <td class='title'>비고</td>
            <td>&nbsp;
			<input type="text" name="etc" size="70" class=text>			
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
            <td width='20%' class='title'>사용자</td>
            <td>&nbsp;
              <input name="user_nm" type="text" class="text" value="" size="10" style='IME-MODE: active' onKeyDown="javasript:enter('card_user_id', 2)">
              <input type='hidden' name='card_user_id' value=''>
              <a href="javascript:User_search('card_user_id', 2);" ><img src=/acar/images/center/button_in_search1.gif border=0 align=absmiddle></a>       
			  </td>
          </tr>
          <tr>
            <td width='20%' class='title'>카드지급일</td>
            <td>&nbsp;
              <input name="use_s_dt" type="text" class="text" value="<%=AddUtil.getTime().substring(0,10)%>" onBlur='javascript:this.value=ChangeDate(this.value)' size="11">
			  <input name="use_s_dt_h" type="text" class="text" value="<%=AddUtil.getTime().substring(11,13)%>" size="2">시
<!--			  ( 카드수령일과 동일
              <input type="checkbox" name="dt_chk" value="Y" onClick="javascript:Dt_chk();"> )-->
		    </td>
          </tr>
          <tr>
            <td class='title'>카드회수일</td>
            <td>&nbsp;
              <input name="use_e_dt" type="text" class="text" value="" onBlur='javascript:this.value=ChangeDate(this.value)' size="11">
			  <input name="use_e_dt_h" type="text" class="text" value="" size="2">시
			  </td>
          </tr>
        </table>
	</td>
  </tr>  
    <tr> 
      <td align="right">
          <%if( auth_rw.equals("2") || auth_rw.equals("4") || auth_rw.equals("6")) {%>
          <a href="javascript:Save();"><img src=/acar/images/center/button_reg.gif border=0 align=absmiddle></a>&nbsp;
          <%}%>
	  <a href="javascript:window.close();"><img src=/acar/images/center/button_close.gif border=0 align=absmiddle></a></td>
    </tr>  
  </table>
</form>
<iframe src="about:blank" name="i_no" width="0" height="0" frameborder="0" noresize></iframe>
</body>
</html>
