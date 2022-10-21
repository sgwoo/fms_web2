<%@ page language="java" contentType="text/html;charset=euc-kr"%>
<%@ page import="java.util.*, acar.util.*, acar.common.*"%>
<%@ page import="acar.bill_mng.*"%>
<jsp:useBean id="rs_db" scope="page" class="acar.res_search.ResSearchDatabase"/>
<%@ include file="/acar/cookies.jsp" %>
<%@ include file="/acar/access_log.jsp" %>

<%
	String auth_rw 	= request.getParameter("auth_rw")==null?"":request.getParameter("auth_rw");
	String user_id 	= request.getParameter("user_id")==null?"":request.getParameter("user_id");
	String br_id 	= request.getParameter("br_id")==null?"":request.getParameter("br_id");
	
	//로그인ID&영업소ID
	LoginBean login = LoginBean.getInstance();
	if(user_id.equals("")) 	user_id = login.getCookieValue(request, "acar_id");
	if(br_id.equals(""))	br_id 	= login.getCookieValue(request, "acar_br");
	if(auth_rw.equals(""))	auth_rw = rs_db.getAuthRw(user_id, "05", "01", "13");
	
	CommonDataBase c_db = CommonDataBase.getInstance();
	NeoErpUDatabase neoe_db = NeoErpUDatabase.getInstance();
	
	//담당자 리스트
	Vector users = c_db.getUserList("", "", "EMP");
	int user_size = users.size();
	
	//네오엠-은행정보
	CodeBean[] banks = neoe_db.getCodeAll();
	int bank_size = banks.length;

%>

<html>
<head>
<title>FMS</title>
<meta http-equiv="Content-Type" content="text/html; charset=euc-kr">
	<%@ include file="/acar/getNaviCookies.jsp" %>
<link rel=stylesheet type="text/css" href="/include/table_t.css">
<script language='JavaScript' src='/include/common.js'></script>
<script language="JavaScript">
<!--
	//은행선택시 계좌번호 가져오기
	function change_bank(){
		var fm = document.form1;
		var bank_code = fm.bank_code.options[fm.bank_code.selectedIndex].value;
		fm.bank_code2.value = bank_code.substring(0,3);
		fm.bank_name.value = bank_code.substring(3);
		
		drop_deposit();		

		if(bank_code == ''){
			fm.bank_code.options[0] = new Option('선택', '');
			return;
		}else{
			fm.target='i_no';
			fm.action='/fms2/con_fee/get_deposit_nodisplay.jsp?bank_code='+bank_code.substring(0,3);
			fm.submit();
		}
	}
	
	function drop_deposit(){
		var fm = document.form1;
		var deposit_len = fm.deposit_no.length;
	//	alert(deposit_len);
		for(var i = 0 ; i < deposit_len ; i++){
			fm.deposit_no.options[deposit_len-(i+1)] = null;
		}
	}
		
	function add_deposit(idx, val, str){
		document.form1.deposit_no[idx] = new Option(str, val);		
	}

	
	//디스플레이
	function cng_input1(){
		var fm = document.form1;

		tr_pay1.style.display		= 'none';
		tr_pay2.style.display		= 'none';		
		tr_pay3.style.display		= 'none';
		tr_pay5.style.display		= 'none';
		
		if(fm.ip_method[0].checked == true)			tr_pay1.style.display		= '';
		if(fm.ip_method[1].checked == true)			tr_pay2.style.display		= '';						
		if(fm.ip_method[2].checked == true)			tr_pay3.style.display		= '';
		if(fm.ip_method[3].checked == true)			tr_pay5.style.display		= '';
							
	}	
		
	
	function save(){
	
		var fm = document.form1;
		if(fm.incom_dt.value == '')		{ alert('입금일자를 확인하십시오.'); 	return;}
		if(fm.incom_amt.value == '' || fm.incom_amt.value == '0')		{ alert('입금액을 확인하십시오.'); 	return;}
	//	if(fm.incom_gubun.value == '')	{ alert('입력구분을 확인하십시오.'); 	return;}
		if(fm.ip_method.value == '')	{ alert('입금구분을 확인하십시오.'); 	return;}
	
		
		//계좌인 경우 
		if(fm.ip_method[0].checked == true){	
		   //신한 erp 집금 사용한 경우
			if ( fm.incom_gubun[1].checked == true) {
				if(fm.bank_code3.value == '')	{ alert('은행을 확인하십시오.'); 	return;}
				if(fm.deposit_no3.value == '')	{ alert('계좌번호를 확인하십시오.'); 	return;}
			}else {
				if(fm.bank_code.value == '')	{ alert('은행을 확인하십시오.'); 	return;}
				if(fm.deposit_no.value == '')	{ alert('계좌번호를 확인하십시오.'); 	return;}
			}	
			if(fm.remark.value == '')		{ alert('적요를 확인하십시오.'); 	return;}
		//	if(fm.bank_office.value == '')	{ alert('거래점을 확인하십시오.'); 	return;}	
		}else if (fm.ip_method[1].checked == true){ //카드	
			if(fm.card_cd[0].checked == false && fm.card_cd[1].checked == false && fm.card_cd[2].checked == false  && fm.card_cd[3].checked == false  && fm.card_cd[4].checked == false && fm.card_cd[5].checked == false && fm.card_cd[6].checked == false && fm.card_cd[7].checked == false  && fm.card_cd[8].checked == false  && fm.card_cd[9].checked == false  && fm.card_cd[10].checked == false && fm.card_cd[11].checked == false  )	{ alert('카드사를 선택하세요.'); 	return;}
		//	if(fm.card_no.value == '')	{ alert('카드번호를 확인하십시오.'); 	return;}
			
		} else if(fm.ip_method[2].checked == true){ //현금	
			if(fm.cash_area.value == '')	{ alert('수금장소를 확인하십시오.'); 	return;}
			if(fm.cash_get_id.value == '')	{ alert('수금사원을 확인하십시오.'); 	return;}
		
		} else if (fm.ip_method[3].checked == true){  //대체	
			if(fm.remark5.value == '')	{ alert('내역를 확인하십시오.'); 	return;}
		}		
					
//		if ( fm.p_gubun[1].checked == true ) { alert('cms는 ok-bank에서 처리하세요.'); 	return;}
						
		//if(confirm('1단계를 등록하시겠습니까?')){	
			fm.action='incom_reg_step1_a.jsp';	
			fm.target='d_content';
			fm.submit();
		//}		
	}
	
		//신한 비즈파트너
	function search_shinhan_ebank()
	{
		fm = document.form1;			
					
		window.open("/fms2/account/shinhan_erp_demand.jsp", "AncDisp", "left=100, top=100, width=1100, height=700, scrollbars=yes, status=yes, resizable=yes");
	}	
	
	function search_insidebank()
	{
		fm = document.form1;			
					
		window.open("/fms2/account/shinhan_erp_demand_inside.jsp", "AncDisp", "left=100, top=100, width=1100, height=700, scrollbars=yes, status=yes, resizable=yes");
	}	
	
//-->
</script> 

</head>
<body leftmargin="15">
<form action='' name="form1" method='post'>
  <input type='hidden' name='auth_rw' 	value='<%=auth_rw%>'>
  <input type='hidden' name='user_id' 	value='<%=user_id%>'>
  <input type='hidden' name='br_id' 	value='<%=br_id%>'>
  <input type='hidden' name="from_page" 	value="/fms2/account/incom_reg_step1.jsp">
  <input type='hidden' name='bank_code2' value=''>     
  <input type='hidden' name='deposit_no2'  value=''>    
  <input type='hidden' name='bank_name' 	value=''> 


  <table border='0' cellspacing='0' cellpadding='0' width='100%'>
	<tr>
		<td colspan=10>
			<table width=100% border=0 cellpadding=0 cellspacing=0>
				<tr>
					<td width=7><img src=/acar/images/center/menu_bar_1.gif width=7 height=33></td>
					<td class=bar>&nbsp;&nbsp;&nbsp;<img src=/acar/images/center/menu_bar_dot.gif width=4 height=5 align=absmiddle>&nbsp;<span class=style1>재무회계 > 집금관리 > <span class=style5>
						입금원장등록 [1단계]</span></span></td>
					<td width=7><img src=/acar/images/center/menu_bar_2.gif width=7 height=33></td>
				</tr>
			</table>
		</td>
	</tr>
	<tr>
		<td class=h></td>
	</tr> 
    <tr>
		<td class=line2></td>
	</tr> 
    <tr>
      <td class=line> 
        <table border="0" cellspacing="1" cellpadding='0' width=100%>
		<!--	
          <tr> 
            <td class=title width=13%>처리구분</td>
            <td>&nbsp;
			  <input type="radio" name="pay_st" value="1" checked>신규입금
			</td>					  
          </tr>		
          -->  
          <tr> 
            <td class=title width=13%>입금일자</td>
            <td>&nbsp;
			  <input type='text' name='incom_dt' size='11' maxlength='20' class='text' value="<%=AddUtil.getDate()%>" onBlur='javascript:this.value=ChangeDate(this.value)'>
			   &nbsp;<a href='javascript:search_insidebank()' onMouseOver="window.status=''; return true" title="클릭하세요"><img src="/acar/images/center/button_search.gif" align=absmiddle border="0"></a>
		 	<!--  &nbsp;<a href='javascript:search_shinhan_ebank()' onMouseOver="window.status=''; return true" title="클릭하세요">비즈파트너</a> -->
	 
			   </td>
          </tr>		
          <tr> 
            <td class=title>입금액</td>
            <td>&nbsp;
			  <input type='text' name='incom_amt' size='12' maxlength='12' class='num' value='' onBlur="javascript:this.value=parseDecimal(this.value);" >&nbsp;원</td>
          </tr>		
        </table>
	  </td>
    </tr>

	<tr>
	  <td>&nbsp;</td>
	</tr>
	
	<tr>
		<td class=line2></td>
	</tr>
    <tr id=tr_pay0 style="display:''">
      <td class=line> 
        <table border="0" cellspacing="1" cellpadding='0' width=100%>
          <tr> 
            <td class=title width=13%>입금구분</td>
            <td colspan="3">&nbsp;
			  <input type="radio" name="ip_method" value="1" checked onClick="javascript:cng_input1()">계좌 
			  <input type="radio" name="ip_method" value="2" onClick="javascript:cng_input1()">카드 
              <input type="radio" name="ip_method" value="3" onClick="javascript:cng_input1()">현금
              <input type="radio" name="ip_method" value="5" onClick="javascript:cng_input1()">대체
           
			</td>
          </tr>		  		    
        </table>
	  </td>
    </tr>
    
   
    <tr>
	  <td>&nbsp;</td>
	</tr>
	<tr>
		<td class=line2></td>
	</tr>
    <tr>
      <td class=line> 
        <table border="0" cellspacing="1" cellpadding='0' width=100%>
          <tr> 
            <td class=title width=13%>입력구분</td>
            <td colspan="3">&nbsp;
			  <input type="radio" name="incom_gubun" value="1" checked >직접입력 
			  <input type="radio" name="incom_gubun" value="2" >집금수집 
             
			</td>
          </tr>		  		    
        </table>
	  </td>
    </tr>
 
 
	<tr>
	  <td>&nbsp;</td>
	</tr>
	<tr>
		<td class=line2></td>
	</tr>
    <tr id=tr_pay1 style="display:''">
      <td class=line> 
        <table border="0" cellspacing="1" cellpadding='0' width=100%>
          <tr> 
            <td class=title width=13%>입금은행</td>
            <td>&nbsp;
			  <select name='bank_code' onChange='javascript:change_bank()'>
                      <option value=''>선택</option>
                      <%if(bank_size > 0){
						for(int i = 0 ; i < bank_size ; i++){
							CodeBean bank = banks[i];	%>
                      <option value='<%= bank.getCode()%>:<%= bank.getNm()%>'><%= bank.getNm()%></option>
                      <%	}
					}	%>
                    </select>
                 <input type='text' name='bank_code3' readonly	value=''>     
                 <input type='hidden' name='tran_date' 	value=''> 
                 <input type='hidden' name='tran_date_seq' 	value=''> 
                 <input type='hidden' name='bank_id' 	value=''> 
                 <input type='hidden' name='acct_num' 	value=''> 
                 <input type='hidden' name='acct_seq' 	value=''> 
              
			</td>	
		  </tr>
		  <tr>
            <td class=title>계좌번호</td>
            <td>&nbsp;
			  <select name='deposit_no'>
                      <option value=''>계좌를 선택하세요</option>
                    </select>
              <input type='text' name='deposit_no3' readonly	value=''>          
			</td>
          </tr>		  
          <tr> 
            <td class=title>적요</td>
            <td>&nbsp;
			  <input type='text' name='remark' size='100' class='text' value=""></td>
		  </tr>
		  <tr>			  
            <td class=title>거래점</td>
            <td>&nbsp;
			  <input type='text' name='bank_office' size='40' class='text' value=''></td>
          </tr>		  
        </table>
	  </td>
    </tr>
    <tr id=tr_pay2 style='display:none'>
      <td class=line> 
        <table border="0" cellspacing="1" cellpadding='0' width=100%>
          <tr> 
            <td class=title width=13%>카드사</td>
            <td>&nbsp;
              <input type="radio" name="card_cd" value="1" >BC    <!-- BC -->
			  <input type="radio" name="card_cd" value="2" >국민  <!--국민 -->
			  <input type="radio" name="card_cd" value="3" >신한  <!--신한 -->
			  <input type="radio" name="card_cd" value="4" >하나  <!--외환 -> 하나(20150624)-->
			  <input type="radio" name="card_cd" value="5" >롯데  <!--롯데 -->
			  <input type="radio" name="card_cd" value="6" >현대  <!--현대 -->
			  <input type="radio" name="card_cd" value="7" >삼성  <!--삼성 -->
			  <input type="radio" name="card_cd" value="8" >씨티  <!--씨티 -->
			  <input type="radio" name="card_cd" value="9" >KCP  <!--전화결재 -->
			  <input type="radio" name="card_cd" value="12" >페이엣  <!--전화결재 --> 
			  <input type="radio" name="card_cd" value="11" >나이스  <!--카드 cms결재 --> 
			  <input type="radio" name="card_cd" value="13" >이노페이 <!--sms결재  --> 
			 
		<!--	   <input type="radio" name="card_cd" value="10" >KCP2  --><!--온라인 --> 
             <input type='hidden' name='card_nm' size='40' class='text' value="">
			
			</td>				
          </tr>		
     		      
          <tr> 				  
            <td class=title>카드번호</td>
            <td>&nbsp;
			  <input type='text' name='card_no' size='40' class='text' value="">
			</td>
          </tr>
       
          <tr> 
            <td class=title>적요</td>
            <td>&nbsp;
			  <input type='text' name='remark1' size='100' class='text' value=""></td>
		  </tr>	  	
<!--		    
          <tr> 
            <td class=title>수금사원</td>
            <td>&nbsp;
			  <select name="card_get_id">
			    <option value="">선택</option>
                <%if(user_size > 0){
					for(int i = 0 ; i < user_size ; i++){
						Hashtable user = (Hashtable)users.elementAt(i); %>
                <option value='<%=user.get("USER_ID")%>'><%=user.get("USER_NM")%></option>
                <%	}
				}		%>
              </select></td>
          </tr>	
 -->       
        </table>
	  </td>
    </tr>
    <tr id=tr_pay3 style='display:none'>
      <td class=line> 
        <table border="0" cellspacing="1" cellpadding='0' width=100%>
          <tr> 
            <td class=title width=13%>수금장소</td>
            <td>&nbsp;
			  <input type='text' name='cash_area' size='40' class='text' value="">
			</td>					  
          </tr>		  
          <tr> 
            <td class=title>적요</td>
            <td>&nbsp;
			  <input type='text' name='remark2' size='100' class='text' value=""></td>
		  </tr>	 
		  <tr> 
            <td class=title>수금사원</td>
            <td>&nbsp;
			  <select name="cash_get_id">
			    <option value="">선택</option>
                <%if(user_size > 0){
					for(int i = 0 ; i < user_size ; i++){
						Hashtable user = (Hashtable)users.elementAt(i); %>
                <option value='<%=user.get("USER_ID")%>'><%=user.get("USER_NM")%></option>
                <%	}
				}		%>
              </select>
			</td>
          </tr>	 	  
        </table>
	  </td>
    </tr>
   
    <tr id=tr_pay5 style='display:none'>
      <td class=line> 
        <table border="0" cellspacing="1" cellpadding='0' width=100%>
          <tr> 
            <td class=title width=13%>내역</td>
            <td>&nbsp;
			  <input type='text' name='remark5' size='100' class='text' value="">
			</td>					  
          </tr>		  
      
        </table>
	  </td>
    </tr>
    <tr>
      <td>&nbsp;</td>
    </tr>
       <%if(auth_rw.equals("4")||auth_rw.equals("6")){%> 
    <tr>
		<td align="right"><a href="javascript:save();"><img src=/acar/images/center/button_next.gif border=0 align=absmiddle></a></td>
	</tr>	
	<% } %>	
		
  </table>
</form>
<iframe src="about:blank" name="i_no" width="0" height="0" frameborder="0" noresize></iframe>
<script language="JavaScript">
<!--	
//-->
</script>
</body>
</html>
