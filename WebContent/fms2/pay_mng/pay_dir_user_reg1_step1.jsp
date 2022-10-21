<%@ page language="java" contentType="text/html;charset=euc-kr"%>
<%@ page import="java.io.*, java.util.*, acar.util.*, acar.common.*, acar.user_mng.*"%>
<%@ page import="acar.pay_mng.*"%>
<%@ include file="/acar/cookies.jsp"%>
<%@ include file="/acar/access_log.jsp" %>

<%	


	
	String auth_rw 		= request.getParameter("auth_rw")==null?"":request.getParameter("auth_rw");
	String user_id 		= request.getParameter("user_id")==null?"":request.getParameter("user_id");
	String br_id 		= request.getParameter("br_id")==null?"":request.getParameter("br_id");
	
	String s_kd 		= request.getParameter("s_kd")==null? "":request.getParameter("s_kd");
	String t_wd 		= request.getParameter("t_wd")==null? "" :request.getParameter("t_wd");
	String gubun1 		= request.getParameter("gubun1")==null?"":request.getParameter("gubun1");
	String gubun2 		= request.getParameter("gubun2")==null?"":request.getParameter("gubun2");
	String gubun3 		= request.getParameter("gubun3")==null?"":request.getParameter("gubun3");
	String gubun4 		= request.getParameter("gubun4")==null?"":request.getParameter("gubun4");
	String st_dt 		= request.getParameter("st_dt")==null?"":request.getParameter("st_dt");
	String end_dt 		= request.getParameter("end_dt")==null?"":request.getParameter("end_dt");
	
	int    sh_height	= request.getParameter("sh_height")==null?0:Util.parseInt(request.getParameter("sh_height"));//상단길이
	
	String valus = 	"?auth_rw="+auth_rw+"&user_id="+user_id+"&br_id="+br_id+
					"&s_kd="+s_kd+"&t_wd="+t_wd+"&gubun1="+gubun1+"&gubun2="+gubun2+"&gubun3="+gubun3+"&gubun4="+gubun4+
					"&st_dt="+st_dt+"&end_dt="+end_dt+
				   	"&sh_height="+sh_height+"";
				   	
	CommonDataBase 		c_db 	= CommonDataBase.getInstance();
	PaySearchDatabase 	ps_db 	= PaySearchDatabase.getInstance();
	
	//금융사리스트
	Vector bank_vt =  ps_db.getCodeList("0003");
	int bank_size = bank_vt.size();
	
	//은행계좌번호
	Vector accs = ps_db.getDepositList();
	int acc_size = accs.size();	
	
	
	
	//탁송사유
	CodeBean[] codes = c_db.getCodeAll("0015");
	int c_size = codes.length;
	
	//직원수
	int user_size = c_db.getUserSize();
	
	if(user_size > 30 && user_size < 40) 		user_size = 40;
	else if(user_size > 40 && user_size < 50) 	user_size = 50;
	else if(user_size > 50 && user_size < 60) 	user_size = 60;
	else if(user_size > 60 && user_size < 70) 	user_size = 70;
	else if(user_size > 70 && user_size < 80) 	user_size = 80;
	else if(user_size > 80 && user_size < 90) 	user_size = 90;
	else if(user_size > 90 && user_size < 100) 	user_size = 100;
%>

<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN">
<html>
<head>
<title>FMS</title>
<meta http-equiv="Content-Type" content="text/html; charset=euc-kr">
<link rel="stylesheet" type="text/css" href="/include/table_t.css"></link>
<style type=text/css>
<!-- 
.style1 {color: #666666}
.style2 {color: #515150; font-weight: bold;}
.style3 {color: #b3b3b3; font-size: 11px;}
.style4 {color: #737373; font-size: 11px;}
.style5 {color: #ef620c; font-weight: bold;}
.style6 {color: #4ca8c2; font-weight: bold;}
.style7 {color: #666666; font-size: 11px;}
-->
</style>
<script language='JavaScript' src='/include/common.js'></script>
<script language="JavaScript" src="InnoAP.js"></script>
<script language="JavaScript">
<!--
	function date_type_input(date_type){
		var fm = document.form1;
		var today = new Date();
		var s_dt = "";
		var dt = today;
		if(date_type==2){			
			dt = new Date(today.valueOf()-(24*60*60*1000));
		}else if(date_type == 3){
			dt = new Date(today.valueOf()-(24*60*60*1000)*2);			
		}
		s_dt = String(dt.getFullYear())+"-";
		if((dt.getMonth()+1) < 10) 	s_dt = s_dt+"0";
		s_dt = s_dt+String(dt.getMonth()+1)+"-";
		if(dt.getDate() < 10) 		s_dt = s_dt+"0";
		s_dt = s_dt+String(dt.getDate());
		fm.p_est_dt.value = s_dt;		
	}
	
	//엔터키 처리
	function enter(nm, idx) {
		var keyValue = event.keyCode;
		if (keyValue =='13'){		 			
			if(nm == 'off_id')			off_search(idx);			
		}
	}	

	//지출처조회하기
	function off_search(idx){
		var fm = document.form1;	
		var t_wd = fm.off_nm.value;
		var off_st_nm = fm.off_st.options[fm.off_st.selectedIndex].text;
		if(fm.off_st.value == ''){		alert('조회할 지출처 구분을 선택하십시오.'); 	fm.off_st.focus(); 	return;}
		if(fm.off_nm.value == ''){		alert('조회할 지출처명을 입력하십시오.'); 		fm.off_nm.focus(); 	return;}
		window.open("/fms2/pay_mng/off_list.jsp?way_size=1&auth_rw=<%=auth_rw%>&user_id=<%=user_id%>&br_id=<%=br_id%>&off_st="+fm.off_st.value+"&idx="+idx+"&t_wd="+t_wd+"&off_st_nm="+off_st_nm, "OFF_LIST", "left=50, top=50, width=1150, height=550, scrollbars=yes");		
	}
	
	//네오엠 조회하기
	function ven_search(idx){
		var fm = document.form1;	
		if(fm.ven_name.value == ''){	alert('조회할 네오엠거래처명을 입력하십시오.'); fm.ven_name.focus(); return;}
		window.open("/card/doc_reg/vendor_list.jsp?auth_rw=<%=auth_rw%>&user_id=<%=user_id%>&br_id=<%=br_id%>&idx="+idx+"&t_wd="+fm.ven_name.value+"&from_page=/fms2/pay_mng/off_list.jsp", "VENDOR_LIST", "left=150, top=150, width=950, height=550, scrollbars=yes");		
	}			
	function ven_enter(idx) {
		var keyValue = event.keyCode;
		if (keyValue =='13') ven_search(idx);
	}				
	
	//장기고객조회하기
	function Rent_search(){
		var fm = document.form1;	
		if(fm.car_info.value != '')	fm.t_wd.value = fm.car_info.value;
		window.open("/card/doc_reg/rent_search.jsp?go_url=/fms2/pay_mng/pay_dir_reg.jsp&t_wd="+fm.t_wd.value, "RENT_search", "left=350, top=150, width=600, height=400, scrollbars=yes");		
	}
	function Rent_enter() {
		var keyValue = event.keyCode;
		if (keyValue =='13') Rent_search();
	}		
	
	//직원전기차충전등록 리스트 확인
	function view_pay_dir_user_list(){
		var fm = document.form1;
		window.open("view_pay_dir_user_list.jsp?off_id="+fm.off_id.value, "VIEW_PAY_DIR_USER_LIST", "left=350, top=150, width=800, height=800, scrollbars=yes");
	}
	
	function save()
	{
		var fm = document.form1;
		fm.bank_nm.value = fm.s_bank_id.options[fm.s_bank_id.selectedIndex].text;
		
		if(fm.bank_nm.value == '선택')		fm.bank_nm.value = '';
		
		if(fm.p_est_dt.value == '')		{	alert('거래일자를 선택하십시오.'); 	fm.p_est_dt.focus(); 		return; }
		
		if(fm.off_id.value == '')			{	alert('지출처를 선택하십시오.'); 		fm.off_id.focus(); 	return; }
		
		if(fm.ven_code.value == '')		{	alert('네오엠거래처코드가 없습니다. 검색하여 선택하십시오.'); 		fm.ven_code.focus(); 		return; }				
		
		if(fm.buy_amt.value == '' || fm.buy_amt.value == '0')		{	alert('금액을 입력하십시오.'); 		fm.buy_amt.focus(); 		return; }
		
		if(fm.tot_dist.value == '' || fm.tot_dist.value == '0' ||  toInt(parseDigit(fm.tot_dist.value)) == 0   ) { alert('주행거리를 입력하십시오.'); fm.tot_dist.focus(); 		return;}
		
		if(fm.car_mng_id.value == '')	{	alert('차량정보가 없습니다. 검색하여 선택하십시오.'); 		fm.car_info.focus(); 		return; }				
		
		if(confirm('등록하시겠습니까?')){		
			
			var link = document.getElementById("submitLink");
			var originFunc = link.getAttribute("href");
			link.setAttribute('href',"javascript:alert('처리 중입니다. 잠시만 기다려주세요');");
		
			fm.action = 'pay_dir_user_reg1_step1_a.jsp';
			fm.target = 'i_no';
			fm.submit();	
			
			link.getAttribute('href',originFunc);	
		}
	}		
//-->
</script>
</head>

<body leftmargin="15">
<form action="" name="form1" method="POST">
  <input type='hidden' name='auth_rw' 	value='<%=auth_rw%>'>
  <input type='hidden' name='user_id' 	value='<%=user_id%>'>
  <input type='hidden' name='br_id' 	value='<%=br_id%>'>
  <input type='hidden' name='s_kd'  	value='<%=s_kd%>'>
  <input type='hidden' name='t_wd' 		value='<%=t_wd%>'>			
  <input type='hidden' name='gubun1' 	value='<%=gubun1%>'>  
  <input type='hidden' name='gubun2' 	value='<%=gubun2%>'>  
  <input type='hidden' name='gubun3' 	value='<%=gubun3%>'>
  <input type='hidden' name='gubun4' 	value='<%=gubun4%>'>
  <input type='hidden' name='st_dt' 	value='<%=st_dt%>'>
  <input type='hidden' name='end_dt' 	value='<%=end_dt%>'>
  <input type='hidden' name='sh_height' value='<%=sh_height%>'>  
  <input type="hidden" name="rent_mng_id" value="">
  <input type="hidden" name="rent_l_cd" value="">
  <input type="hidden" name="car_mng_id" value="">
  <input type="hidden" name="client_id" value="">  
  <input type="hidden" name="accid_id" 	value="">
  <input type="hidden" name="serv_id" 	value="">
  <input type="hidden" name="maint_id" 	value="">  
  <input type='hidden' name='go_url' 	value='/fms2/pay_mng/pay_dir_user_reg1_step1.jsp'>      
  <input type='hidden' name='acct_code_nm' value=''>      
  <input type="hidden" name="ven_nm_cd" value="">
  <input type="hidden" name="mode" value="">  
  <input type="hidden" name="buy_user_id" value="">  
  <input type="hidden" name="user_nm" value="">  
  <input type="hidden" name="user_nm" value="">  


  <table width="100%" border="0" cellspacing="0" cellpadding="0">
	<tr>
		<td colspan=10>
			<table width=100% border=0 cellpadding=0 cellspacing=0>
				<tr>
					<td width=7><img src=/acar/images/center/menu_bar_1.gif width=7 height=33></td>
					<td class=bar>&nbsp;&nbsp;&nbsp;<img src=/acar/images/center/menu_bar_dot.gif width=4 height=5 align=absmiddle>&nbsp;<span class=style1>재무회계 > 집금관리 > <span class=style5>
						직원전기차충전출금등록 (1단계) </span></span></td>
					<td width=7><img src=/acar/images/center/menu_bar_2.gif width=7 height=33></td>
				</tr>
			</table>
		</td>
	</tr>
    <tr>
        <td class=h></td>
    </tr>
    <tr>
        <td align='right'><input type="button" class="button" value="직원전기차충전등록 리스트 확인" onclick="javascript:view_pay_dir_user_list();"></td>
    </tr>
    <tr>
        <td class=line2></td>
    </tr>     
    <tr>
      <td class=line> 
        <table border="0" cellspacing="1" cellpadding='0' width=100%>
          <tr>
            <td width="15%" class=title>거래일자</td>
            <td >&nbsp;			  
              <input type="text" name="p_est_dt" size='11' class='default' value="" onBlur='javascript:this.value = ChangeDate(this.value);'> 
			  &nbsp;&nbsp;
			    <input type='radio' name="date_type" value='1'  onClick="javascript:date_type_input(1)">오늘
				<input type='radio' name="date_type" value='2'  onClick="javascript:date_type_input(2)">어제
				<input type='radio' name="date_type" value='3'  onClick="javascript:date_type_input(3)">그제
			  </td>
          </tr>		
          <tr>
            <td class=title>지출처</td>
            <td>&nbsp;
              <select name='off_st' class='default'>
				<option value="user_id" >아마존카사원</option>
              </select><br>
			  &nbsp;
              <input type='text' name='off_nm' size='55' value='<%=session_user_nm%>' class='default' style='IME-MODE: active' onKeyDown="javascript:enter('off_id', '')">
			  <a href="javascript:off_search('')" onMouseOver="window.status=''; return true"><img src=/acar/images/center/button_in_search1.gif border=0 align=absmiddle></a> 	
              &nbsp;<img src=/acar/images/center/arrow.gif align=absmiddle> 사업자등록번호 :
              <input type='text' name='off_idno' size='12' value='' class='whitetext'>
			  &nbsp;<img src=/acar/images/center/arrow.gif align=absmiddle> 연락처 :
              <input type='text' name='off_tel' size='13' value='' class='whitetext'>
			  <input type="hidden" name="off_id" value="<%=ck_acar_id%>"></td>
          </tr>				  
          <tr>
            <td class=title>네오엠거래처</td>
            <td>&nbsp;
			  <input type='text' name='ven_name' size='55' value='' class='text' style='IME-MODE: active' onKeyDown="javascript:ven_enter('')">
			  <a href="javascript:ven_search('')" onMouseOver="window.status=''; return true"><img src=/acar/images/center/button_in_search1.gif border=0 align=absmiddle></a> 	
			  &nbsp;<img src=/acar/images/center/arrow.gif align=absmiddle> 코드 : <input type='text' name='ven_code' size='8' value='' class='text'></td>
          </tr>
          <tr>
            <td class=title>과세유형</td>
            <td><input type="hidden" name="ve_st" value="">&nbsp;
			  <input type="radio" name="ven_st" value="1">
              일반과세&nbsp;
              <input type="radio" name="ven_st" value="2" >
              간이과세&nbsp;
              <input type="radio" name="ven_st" value="3" >
              면세&nbsp;
              <input type="radio" name="ven_st" value="4" >
              비영리법인(국가기관/단체)&nbsp;
              <input type="radio" name="ven_st" value="0" checked >
              없음&nbsp;			  
              <a href="https://teht.hometax.go.kr/websquare/websquare.html?w2xPath=/ui/ab/a/a/UTEABAAA13.xml" target="_blank"><img src=/acar/images/center/button_in_search_gsc.gif align=absmiddle border=0></a> </td>			  
          </tr>	          
          <tr>
            <td class=title>금액</td>
            <td>&nbsp;
              <input type="text" name="buy_amt" value="" size="15" class=defaultnum onBlur='javascript:this.value=parseDecimal(this.value);'>
              원 &nbsp; 
		    </td>
          </tr>
          <tr>
            <td class=title>출금방식</td>
            <td>&nbsp;
				<input type='radio' name="p_way" value='5' checked>
                계좌이체</td>
          </tr>
          <tr>
            <td class=title>입금계좌</td>
            <td >&nbsp;			  
              <select name='s_bank_id'>
                <option value=''>선택</option>
                <%	for(int i = 0 ; i < bank_size ; i++){
								Hashtable bank_ht = (Hashtable)bank_vt.elementAt(i);
								%>
                <option value='<%= bank_ht.get("BANK_ID")%>' ><%= bank_ht.get("NM")%></option>
                <%	}%>
              </select>
            <input type='text' name='bank_no' size='30' value='' class='default' > 
			&nbsp;예금주 : <input type='text' name='bank_acc_nm' size='33' value='' class='default' >
			<input type='hidden' name='bank_id' 	value=''>
			<input type='hidden' name='bank_nm' 	value=''>
            (지출처 계좌, <font color="#FF0000">계좌이체일 때</font>)             </td>
          </tr>
          <tr>
            <td class=title>출금계좌</td>
            <td >&nbsp;
			  <select name='deposit_no'>
                <option value=''>계좌를 선택하세요</option>
                <%	if(acc_size > 0){
										for(int i = 0 ; i < acc_size ; i++){
											Hashtable acc = (Hashtable)accs.elementAt(i);
											if(String.valueOf(acc.get("DEPOSIT_NO")).equals("140-004-023871")){%>
                <option value='<%= acc.get("DEPOSIT_NO")%>' <%if(String.valueOf(acc.get("DEPOSIT_NO")).equals("140-004-023871")){%>selected<%}%>>[<%=acc.get("CHECKD_NAME")%>]<%= acc.get("DEPOSIT_NO")%>&nbsp;:&nbsp;<%= acc.get("DEPOSIT_NAME")%></option>
                <%		}}
									}%>
              </select> 
			  &nbsp;
			  (아마존카 계좌) 
            </td>
          </tr>
		</table>
	  </td>
	</tr> 		
	<tr>
	  <td>&nbsp;</td>
	</tr>  		
    <tr>
    	<td class="line">
    		<table border="0" cellspacing="1" cellpadding="0" width='100%'>
        		<tr>
            <td width="15%"class=title>계정과목</td>
            <td width="85%">&nbsp;
              <select name='acct_code' class='default'>
                <option value="45800" selected>차량유류대</option>
              </select></td>
        		</tr>
      		</table>
      	</td>
    </tr> 	
    <tr id=tr_acct2 style='display:""'>
    	<td class="line">
      		<table border="0" cellspacing="1" cellpadding="0" width='100%'>
        		<tr>
          			<td width="8%" rowspan="3" class='title' >구분</td>
          			<td width="7%" class='title'>유종</td>
          		
          			<td width="85%">&nbsp;
						<input type="radio" name="acct_code_g" value="27" checked>전기/수소
			  		</td>
				</tr>				
				<tr>
					<td class='title'>용도</td>
					<td>&nbsp;
						<input type="radio" name="acct_code_g2" value="11" checked>업무
					</td>
				</tr>
				<tr>
					<td class='title'>주행거리</td>
					<td>&nbsp;
						<input type='text' size='7' class='num'  name='tot_dist' value='' >&nbsp;km&nbsp;(거래일자 기준)	
					</td>
				</tr>
			</table>
      	</td>
    </tr>	
  <tr id=tr_acct3_1 style='display:""'>
      <td class="line">
      	<table border="0" cellspacing="1" cellpadding="0" width='100%'>
        <tr>
          <td width="15%" class='title'>차량</td>
          <td width="85%">&nbsp;
            <input name="car_info" type="text" class="text" value="<%=session_user_nm%>" size="50" style='IME-MODE: active' onKeyDown="javasript:Rent_enter()">			
            <a href="javascript:Rent_search();"><img src=/acar/images/center/button_in_search1.gif border=0 align=absmiddle></a>
              &nbsp;(차량번호/상호로 검색)</td>
        </tr>
      </table></td>
    </tr>	
    <tr id=tr_acct98 style="display:''">
    	<td class="line">
    		<table border="0" cellspacing="1" cellpadding="0" width='100%'>
        		<tr>
          			<td width="15%" class='title'>적요</td>
          			<td width="85%">&nbsp;
            			<textarea name="p_cont" cols="90" rows="2" class="text"></textarea> (한글40자이내)
            		</td>
        		</tr>
      		</table>
      	</td>
    </tr>    
	<tr>
	  <td>&nbsp;</td>
	</tr>  		
    <tr>
	    <td align='right'>
	    <a id="submitLink" href="javascript:save()" onMouseOver="window.status=''; return true" onfocus="this.blur()"><img src=/acar/images/center/button_reg.gif border=0 align=absmiddle></a>
	    </td>
	</tr>		
  </table>
</form>
<script language='javascript'>
<!--

//-->
</script>
</body>
</html>
<iframe src="about:blank" name="i_no" width="0" height="0" frameborder="0" noresize></iframe>

