<%@ page language="java" contentType="text/html;charset=euc-kr"%>
<%@ page import="java.io.*, java.util.*, acar.util.*, acar.common.*"%>
<%@ page import="acar.pay_mng.*, acar.cont.*, acar.car_register.*, acar.accid.*, acar.cus_reg.*, acar.bill_mng.*, acar.user_mng.*"%>
<jsp:useBean id="cr_bean"   class="acar.car_register.CarRegBean"       scope="page"/>
<%@ include file="/acar/cookies.jsp"%>

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
	String gubun5 		= request.getParameter("gubun5")==null?"":request.getParameter("gubun5");
	String st_dt 		= request.getParameter("st_dt")==null?"":request.getParameter("st_dt");
	String end_dt 		= request.getParameter("end_dt")==null?"":request.getParameter("end_dt");
	
	int    sh_height	= request.getParameter("sh_height")==null?0:Util.parseInt(request.getParameter("sh_height"));//상단길이
	
	String r_acct_code 	= request.getParameter("r_acct_code")==null?"":request.getParameter("r_acct_code");
	String reqseq 		= request.getParameter("reqseq")==null?"":request.getParameter("reqseq");
	String from_page 	= request.getParameter("from_page")==null?"":request.getParameter("from_page");
	int    i_seq 		= request.getParameter("i_seq")==null?1:AddUtil.parseInt(request.getParameter("i_seq"));
	
	String mode 		= request.getParameter("mode")==null?"":request.getParameter("mode");	
	
	String chk="0";
	long total_amt1	= 0;
	long total_amt2	= 0;
	
	CommonDataBase 		c_db = CommonDataBase.getInstance();
	AccidDatabase 		as_db = AccidDatabase.getInstance();
	PayMngDatabase 		pm_db = PayMngDatabase.getInstance();
	NeoErpUDatabase neoe_db = NeoErpUDatabase.getInstance();
	MaMenuDatabase nm_db = MaMenuDatabase.getInstance();
	UserMngDatabase    	umd 	= UserMngDatabase.getInstance();
	
	
	//출금원장
	PayMngBean pay 	= pm_db.getPay(reqseq);
	
	//출금원장 세부 항목
	Vector vt =  pm_db.getPayItemList(reqseq);
	int vt_size = vt.size();
	
	if(i_seq == 0 && vt_size>0)	i_seq = 1;
	
	//출금원장
	PayMngBean item	= pm_db.getPayItem(reqseq, i_seq);
	
	//송금원장
	PayMngActBean act = pm_db.getPayAct(pay.getBank_code(), pay.getP_pay_dt(), pay.getOff_nm(), pay.getBank_no(), pay.getA_bank_no());
	
	
	
	
	
	
	
	
	//탁송사유
	CodeBean[] codes = c_db.getCodeAll("0015");
	int c_size = codes.length;
	
	//등록자
	UsersBean reger_bean 	= umd.getUsersBean(pay.getReg_id());
	
	//직원수
	int user_size = c_db.getUserSize();
	
	if(user_size > 30 && user_size < 40) 		user_size = 40;
	else if(user_size > 40 && user_size < 50) 	user_size = 50;
	else if(user_size > 50 && user_size < 60) 	user_size = 60;
	else if(user_size > 60 && user_size < 70) 	user_size = 70;
	else if(user_size > 70 && user_size < 80) 	user_size = 80;
	else if(user_size > 80 && user_size < 90) 	user_size = 90;
	else if(user_size > 90 && user_size < 100) 	user_size = 100;
	
	
	String valus = 	"?auth_rw="+auth_rw+"&user_id="+user_id+"&br_id="+br_id+"&from_page="+from_page+
					"&s_kd="+s_kd+"&t_wd="+t_wd+"&gubun1="+gubun1+"&gubun2="+gubun2+"&st_dt="+st_dt+"&end_dt="+end_dt+"&gubun3="+gubun3+"&gubun4="+gubun4+
					"&reqseq="+reqseq+"";
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
	
	//스캔등록
	function scan_file(file_st){
		window.open("reg_scan.jsp?auth_rw=<%=auth_rw%>&user_id=<%=user_id%>&br_id=<%=br_id%>&reqseq=<%=reqseq%>&from_page=/fms2/pay_mng/pay_upd_step2.jsp&file_st="+file_st, "SCAN", "left=300, top=300, width=620, height=200, scrollbars=yes, status=yes, resizable=yes");
	}	
	
	//리스트
	function list(){
		var fm = document.form1;		
		if(fm.from_page.value == ''){
			fm.action = '/fms2/pay_mng/pay_upd_step2.jsp';
		}else{
			fm.action = fm.from_page.value;
		}			
		fm.target = 'd_content';
		fm.submit();
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
		window.open("/fms2/pay_mng/off_list.jsp?auth_rw=<%=auth_rw%>&user_id=<%=user_id%>&br_id=<%=br_id%>&off_st="+fm.off_st.value+"&idx="+idx+"&t_wd="+t_wd+"&off_st_nm="+off_st_nm, "OFF_LIST", "left=50, top=50, width=1150, height=550, scrollbars=yes");		
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
		window.open("/card/doc_reg/rent_search.jsp?auth_rw=<%=auth_rw%>&user_id=<%=user_id%>&br_id=<%=br_id%>&go_url=/fms2/pay_mng/pay_dir_reg.jsp&t_wd="+fm.t_wd.value, "RENT_search", "left=350, top=150, width=600, height=400, scrollbars=yes");		
	}
	
	
		
	//금액셋팅
	function tot_buy_amt2(){
		var fm = document.form1;		
		//fm.buy_amt.value 			= parseDecimal(toInt(parseDigit(fm.sub_amt1.value)) + toInt(parseDigit(fm.sub_amt2.value)) + toInt(parseDigit(fm.sub_amt3.value)) + toInt(parseDigit(fm.sub_amt4.value)) + toInt(parseDigit(fm.sub_amt5.value)) + toInt(parseDigit(fm.sub_amt6.value)));		
	}		
		
	//금액셋팅
	function tot_buy_amt(){
		var fm = document.form1;		
		if(fm.ven_st[1].checked == true )
		{		
			fm.buy_s_amt.value 		= parseDecimal(sup_amt(toInt(parseDigit(fm.buy_amt.value))));
			fm.buy_v_amt.value 		= parseDecimal(toInt(parseDigit(fm.buy_amt.value)) - toInt(parseDigit(fm.buy_s_amt.value)));		
		}	
	}		
	function set_buy_amt(){
		var fm = document.form1;	
		fm.buy_amt.value 		= parseDecimal(toInt(parseDigit(fm.buy_s_amt.value)) + toInt(parseDigit(fm.buy_v_amt.value)));		
	}
	function set_buy_v_amt(){
		var fm = document.form1;	
		fm.buy_v_amt.value 		= parseDecimal(toInt(parseDigit(fm.buy_s_amt.value)) * 0.1 );
		set_buy_amt();			
	}		
	function cng_input_vat()
	{
		var fm 		= document.form1;
		var inVat	= toInt(parseDigit(fm.buy_v_amt.value));
		
		if(fm.vat_Rdio[0].checked == true && toInt(parseDigit(fm.buy_v_amt.value)) > 0)
		{
			var inAmt = Math.round(toInt(parseDigit(fm.buy_v_amt.value)) + 1);			
			fm.buy_v_amt.value = parseDecimal(inAmt);
			set_buy_amt();	
		}
		if(fm.vat_Rdio[1].checked == true && toInt(parseDigit(fm.buy_v_amt.value)) > 0)
		{
			var inAmt = Math.round(toInt(parseDigit(fm.buy_v_amt.value)) - 1);			
			fm.buy_v_amt.value = parseDecimal(inAmt);
			set_buy_amt();	
		}
	}	
	function cng_input_vat2()
	{
		var fm 		= document.form1;
		var inVat	= toInt(parseDigit(fm.buy_v_amt.value));
		
		if(fm.vat_Rdio2.checked == true && inVat > 0)
		{
			fm.buy_v_amt.value = 0;
			set_buy_amt();	
		}else{
			set_buy_v_amt();
			set_buy_amt();				
		}
	}		

	//지출처 선택시
	function cng_off_input(){
		var fm = document.form1;
		fm.off_nm.focus();
		if(fm.off_st.options[fm.off_st.selectedIndex].value == 'user_id' && fm.buy_user_id.value != ''){
		}
	}
	

		
	function save()
	{
		var fm = document.form1;
		
		//현금이면서 이체계좌 있는거 체크
		if(fm.p_way[0].checked == true && fm.bank_no.value != ''){
			alert('출금방식이 현금인데 입금계좌번호가 있습니다. 확인하십시오.'); 
			return;
		}
		
		if(confirm('수정하시겠습니까?')){
			
			var link = document.getElementById("submitLink");
			var originFunc = link.getAttribute("href");
			link.setAttribute('href',"javascript:alert('처리 중입니다. 잠시만 기다려주세요');");
			
			fm.action = 'pay_upd_step2_a.jsp';
			fm.target = 'i_no';
			fm.submit();		
			
			link.getAttribute('href',originFunc);
		}
	}	
	
	//송금리스트
	function view_pay_act(bank_code, p_pay_dt, off_nm, bank_no, a_bank_no){
		window.open("pay_r_act_u.jsp<%=valus%>&bank_code="+bank_code+"&p_pay_dt="+p_pay_dt+"&off_nm="+off_nm+"&bank_no="+bank_no+"&a_bank_no="+a_bank_no, "VIEW_PAY_ACT", "left=10, top=10, width=1000, height=750, scrollbars=yes");							
	}
	
	//삭제하기
	function pay_delete(){
		var fm = document.form1;		
		
		if(!confirm('출금에서 삭제 하시겠습니까?')){	return; }
		if(!confirm('다시 확인합니다. 출금에서 삭제 하시겠습니까?')){	return; }
		if(!confirm('정말로 출금에서 삭제 하시겠습니까?')){	return; }
		
		if(confirm('진짜로 출금에서 삭제 하시겠습니까?')){
			fm.action = 'pay_upd_step1_d.jsp';
			fm.target = 'i_no';
			fm.submit();		
		}		
	}
	

	//수정화면
	function update_page(i_seq){
		window.open("pay_upd_step2_in.jsp<%=valus%>&mode=<%=mode%>&i_seq="+i_seq, "UPDATE_PAY_ITEM", "left=10, top=10, width=1200, height=750, scrollbars=yes");					
	}
		
	//네오엠전표조회
	function doc_reg(){
		var fm = document.form1;
		
		if(fm.ven_code.value == ''){ alert('네오엠거래처코드가 없습니다.'); return; }
		
		if(confirm('미지급금전표를 발행하시겠습니까?')){
			fm.action = 'pay_c_u_25300_a.jsp';
			fm.target = 'i_no';
		}
	}		
	
	
	//네오엠전표조회
	function doc_reg_search(){
		var fm = document.form1;
		
		if(fm.ven_code.value == ''){ alert('네오엠거래처코드가 없습니다.'); return; }
		
		if(confirm('미지급금전표를 발행하시겠습니까?')){
			fm.action = 'pay_c_u_25300_s_a.jsp';
			fm.target = 'i_no';
			fm.submit();		
		}
	}
	

	function view_autodocu(reqseq){
		window.open('pay_autodocu.jsp<%=valus%>', "PAY_AUTODOCU", "left=0, top=0, width=800, height=400, scrollbars=yes, status=yes, resizable=yes");	
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
  <input type='hidden' name='gubun5' 	value='<%=gubun5%>'>  
  <input type='hidden' name='st_dt' 	value='<%=st_dt%>'>
  <input type='hidden' name='end_dt' 	value='<%=end_dt%>'>
  <input type='hidden' name='sh_height' value='<%=sh_height%>'>  
  <input type='hidden' name='reqseq' 	value='<%=reqseq%>'>        
  <input type='hidden' name='from_page' value='<%=from_page%>'>      
  <input type='hidden' name='r_est_dt' 	value='<%=pay.getP_est_dt()%>'>            
  <input type='hidden' name='off_id' 	value='<%=pay.getOff_id()%>'>              
  <input type='hidden' name='p_gubun' 	value='<%=item.getP_gubun()%>'>                
  <input type="hidden" name="rent_mng_id" value="<%=item.getP_cd1()%>">
  <input type="hidden" name="rent_l_cd" value="<%=item.getP_cd2()%>">
  <input type="hidden" name="car_mng_id" value="<%=item.getP_cd3()%>">
  <input type="hidden" name="client_id" value="">  
  <input type="hidden" name="accid_id" 	value="<%=item.getP_cd4()%>">
  <input type="hidden" name="serv_id" 	value="<%=item.getP_cd5()%>">
  <input type="hidden" name="maint_id" 	value="<%=item.getP_cd6()%>">  
  <input type='hidden' name='r_acct_code' value='<%=r_acct_code%>'>
  <input type='hidden' name='go_url' 	value='/fms2/pay_mng/pay_upd_step2.jsp'>      
  <input type='hidden' name='acct_code_nm' value=''>      
  <input type="hidden" name="ven_nm_cd" value="">
  <input type="hidden" name="mode" value="<%=mode%>">  

  <table width="100%" border="0" cellspacing="0" cellpadding="0">
	<tr>
		<td colspan=10>
			<table width=100% border=0 cellpadding=0 cellspacing=0>
				<tr>
					<td width=7><img src=/acar/images/center/menu_bar_1.gif width=7 height=33></td>
					<td class=bar>&nbsp;&nbsp;&nbsp;<img src=/acar/images/center/menu_bar_dot.gif width=4 height=5 align=absmiddle>&nbsp;<span class=style1>재무회계 > 집금관리 > <span class=style5>
						출금원장 수정 (2단계)</span></span></td>
					<td width=7><img src=/acar/images/center/menu_bar_2.gif width=7 height=33></td>
				</tr>
			</table>
		</td>
	</tr>
    <tr>
        <td class=h></td>
    </tr>
	<%if(!mode.equals("view")){%>
	<tr>
	    <td align="right"><a href="javascript:list()" onMouseOver="window.status=''; return true" onfocus="this.blur()"><img src=/acar/images/center/button_list.gif border=0 align=absmiddle></a></td></td>
	<tr> 
	<%}%>
    <tr>
      <td class=h></td>
    </tr>
    <tr>
      <td class=line2></td>
    </tr>    
    <tr>
      <td class=line> 
        <table border="0" cellspacing="1" cellpadding='0' width=100%>
          <tr>
            <td width="15%" class=title>출금코드</td>
            <td >&nbsp;			  
              <%=reqseq%> </td>
          </tr>		
          <tr>
            <td width="15%" class=title>출금일자</td>
            <td >&nbsp;			  
              <%=AddUtil.ChangeDate2(pay.getP_pay_dt())%> </td>
          </tr>		
          <tr>
            <td class=title>금액</td>
            <td>&nbsp;
              <%=AddUtil.parseDecimalLong(pay.getAmt())%>
              원 &nbsp;
		    </td>
          </tr>		  
          <tr>
            <td class=title>지출처</td>
            <td>&nbsp;
              <select name='off_st' class='default' onchange="javascript:cng_off_input()" disabled>
                <option value="" >선택</option>                
                <option value="off_id"   <%if(pay.getOff_st().equals("off_id"))	%>selected<%%>>협력업체</option>
                <option value="gov_id"   <%if(pay.getOff_st().equals("gov_id"))	%>selected<%%>>관공서</option>
                <option value="com_code" <%if(pay.getOff_st().equals("com_code"))%>selected<%%>>카드사</option>
				<option value="br_id"    <%if(pay.getOff_st().equals("br_id"))	%>selected<%%>>아마존카</option>
				<option value="user_id"  <%if(pay.getOff_st().equals("user_id"))%>selected<%%>>아마존카사원</option>
				<option value="other"    <%if(pay.getOff_st().equals("other")||pay.getOff_st().equals("ven_code"))	%>selected<%%>>기타</option>
              </select><br>
			  &nbsp;
              <input type='text' name='off_nm' size='55' value='<%=pay.getOff_nm()%>' class='whitetext' style='IME-MODE: active' onKeyDown="javasript:enter('off_id', '')" readonly>
              &nbsp;<img src=/acar/images/center/arrow.gif align=absmiddle> 사업자등록번호 :
			  <%//네오엠코드 처리
				if(!pay.getVen_code().equals("") && pay.getS_idno().equals("")){
					Hashtable vendor = neoe_db.getVendorCase(pay.getVen_code());
					pay.setS_idno(String.valueOf(vendor.get("S_IDNO")));
				}%>
              <input type='text' name='off_idno' size='12' value='<%=pay.getS_idno()%>' class='whitetext'>
			  &nbsp;<img src=/acar/images/center/arrow.gif align=absmiddle> 연락처 :
              <input type='text' name='off_tel' size='13' value='<%=pay.getOff_tel()%>' class='whitetext'>
			  <input type="hidden" name="off_id" value="<%=pay.getOff_id()%>" class='whitetext'></td>
          </tr>				  
          <tr>
            <td class=title>네오엠거래처</td>
            <td>&nbsp;
			  <input type='text' name='ven_name' size='55' value='<%=pay.getVen_name()%>' class='text' style='IME-MODE: active' onKeyDown="javasript:ven_enter('')" readonly>
			  <a href="javascript:ven_search('')" onMouseOver="window.status=''; return true"><img src=/acar/images/center/button_in_search1.gif border=0 align=absmiddle></a> 	
			  &nbsp;<img src=/acar/images/center/arrow.gif align=absmiddle> 코드 : <input type='text' name='ven_code' size='8' value='<%=pay.getVen_code()%>' class='text'></td>
          </tr>
          <tr>
            <td class=title>과세유형</td>
            <td><input type="hidden" name="ve_st" value="">&nbsp;
			  <input type="radio" name="ven_st" value="1" <%if(pay.getVen_st().equals("1"))	%>checked<%%>>
              일반과세&nbsp;
              <input type="radio" name="ven_st" value="2" <%if(pay.getVen_st().equals("2"))	%>checked<%%> >
              간이과세&nbsp;
              <input type="radio" name="ven_st" value="3" <%if(pay.getVen_st().equals("3"))	%>checked<%%> >
              면세&nbsp;
              <input type="radio" name="ven_st" value="4" <%if(pay.getVen_st().equals("4"))	%>checked<%%> >
              비영리법인(국가기관/단체)&nbsp;
              <input type="radio" name="ven_st" value="0" <%if(pay.getVen_st().equals("0"))	%>checked<%%> >
              없음&nbsp;			  
              <a href="https://teht.hometax.go.kr/websquare/websquare.html?w2xPath=/ui/ab/a/a/UTEABAAA13.xml" target="_blank"><img src=/acar/images/center/button_in_search_gsc.gif align=absmiddle border=0></a> </td>
          </tr>	
          <tr>
            <td class=title>세금계산서유무</td>
            <td>&nbsp;
			    <input type='radio' name="tax_yn" value='Y' <%if(pay.getTax_yn().equals("Y"))	%>checked<%%> >있다
				<input type='radio' name="tax_yn" value='N' <%if(pay.getTax_yn().equals("N"))	%>checked<%%> >없다
				<input type='radio' name="tax_yn" value='C' <%if(pay.getTax_yn().equals("C"))	%>checked<%%> >현금영수증(승인번호 : <input type='text' name='cash_acc_no' size='9' maxlength='9' value='<%=pay.getCash_acc_no()%>' class='default' >)
			</td>
          </tr>		
          <tr>
            <td class=title>미지급금발행여부</td>
            <td >&nbsp;
			    <input type='radio' name="acct_code_st" value='1' <%if(pay.getAcct_code_st().equals("1"))	%>checked<%%> >모른다.				
				<input type='radio' name="acct_code_st" value='4' <%if(pay.getAcct_code_st().equals("4"))	%>checked<%%> >미지급금 처리하지 않는다.
				<input type='radio' name="acct_code_st" value='2' <%if(pay.getAcct_code_st().equals("2"))	%>checked<%%> >기발행한 미지급금 전표가 있다.
				<input type='radio' name="acct_code_st" value='3' <%if(pay.getAcct_code_st().equals("3"))	%>checked<%%> >원장수정시 미지급금 전표를 발행하겠다.			
			</td>
          </tr>		
          <tr>
            <td class=title>출금시간</td>
            <td>&nbsp;
			  	<input type='radio' name="at_once" value='Y' <%if(pay.getAt_once().equals("Y"))	%>checked<%%> >
				즉시
				<input type='radio' name="at_once" value='N' <%if(pay.getAt_once().equals("N")||pay.getAt_once().equals(""))%>checked<%%> >
                지정
			</td>
          </tr>		
          <tr>
            <td class=title>송금통합여부</td>
            <td>&nbsp;
			  	<input type='radio' name="act_union_yn" value='N' <%if(pay.getAct_union_yn().equals("N"))	%>checked<%%> >
				개별송금
				<input type='radio' name="act_union_yn" value='Y' <%if(pay.getAct_union_yn().equals("Y")||pay.getAct_union_yn().equals(""))%>checked<%%> >
                통합송금 (동일 수신처는 묶어서 송금처리)
			</td>
          </tr>		  		  		    		    		  
          <%
                   	//20150526 ACAR_ATTACH_FILE LIST---------------------------------------------------------
                   	
			String content_code = "PAY";
			String content_seq  = reqseq; 
			
			Vector attach_vt = attach_vt = c_db.getAcarAttachFileList(content_code, content_seq, 0);
			int attach_vt_size = attach_vt.size();   
			
			if(attach_vt_size > 0){
				for (int j = 0 ; j < attach_vt_size ; j++){
 					Hashtable ht = (Hashtable)attach_vt.elementAt(j);               
          %>
          <tr>
            <%if(j==0){%><td rowspan="5" class=title>증빙서류</td><%}%>
            <td>&nbsp;
                <a href="javascript:openPopF('<%=ht.get("FILE_TYPE")%>','<%=ht.get("SEQ")%>');" title='보기' ><%=ht.get("FILE_NAME")%></a>
                &nbsp;&nbsp;
                <a href="https://fms3.amazoncar.co.kr/fms2/attach/delete.jsp?SEQ=<%=ht.get("SEQ")%>" target='_blank'><img src="/acar/images/center/button_in_delete.gif" align="absmiddle" border="0"></a>
 	    </td>
         </tr>
         <%			}%>
         <%		}%>
         
         <%		for(int i=attach_vt_size;i < 5;i++){%>
          <tr>         
            <%if(attach_vt_size==0 && i==0){%><td rowspan="5" class=title>증빙서류</td><%}%>   
            <td>&nbsp;
                <a href="javascript:scan_file('')" title='등록하기'><img src=/acar/images/center/button_in_reg.gif align=absmiddle border=0></a>
 	    </td>
         </tr>                  
         <%		}%>   
		  <%if(pay.getM_amt() > 0 ){%>
          <tr>
            <td class=title>미지출</td>
            <td >&nbsp;미지출금액 : <%=pay.getM_amt()%>, 사유 : <%=pay.getM_cau()%>
			</td>
          </tr>		  
		  <%}%>			  
          <tr>
            <td class=title>송금결과</td>
            <td >&nbsp;입금계좌 : <%=pay.getBank_nm()%> <%=pay.getBank_no()%>, 출금계좌 : <%=pay.getA_bank_nm()%> <%=pay.getA_bank_no()%>, 
			           <%if(!pay.getA_bank_no().equals("")){%>송금일자 : <a href="javascript:view_pay_act('<%=pay.getBank_code()%>','<%=pay.getP_pay_dt()%>','<%=pay.getOff_nm()%>','<%=pay.getBank_no()%>','<%=pay.getA_bank_no()%>');"><%=act.getR_act_dt()%></a>, 송금금액 : <%=act.getAmt()%>원, 이체수수료 : <%=act.getCommi()%>원, bank_code : <%=pay.getBank_code()%><%}%>
					   <%if(pay.getP_way().equals("3") || pay.getP_way().equals("2") || pay.getP_way().equals("7")){%>
					   <br>
					   &nbsp;<%if(pay.getP_way().equals("2")){%>선불카드<%}else if(pay.getP_way().equals("2")){%>후불카드<%}else if(pay.getP_way().equals("7")){%>카드할부<%}%> : <%=pay.getCard_nm()%> <%=pay.getCard_no()%>
					   <%}%>
			</td>
          </tr>		  			  
          <tr>
            <td class=title>출금자동전표</td>
            <td >&nbsp;<%if(!pay.getAutodocu_write_date().equals("")){%>전표일자 : <%=pay.getAutodocu_write_date()%>, 전표구분 : <%=pay.getAutodocu_data_gubun()%>, 전표번호 : <a href="javascript:view_autodocu('<%=pay.getReqseq()%>');"><%=pay.getAutodocu_data_no()%></a>, pay_code : <%=pay.getPay_code()%> <%}%>
			</td>
          </tr>		  			  
		</table>
	  </td>
	</tr> 	
	<tr>
	  <td>※ 등록자 : <%=reger_bean.getUser_nm()%>, 등록일 : <%=pay.getReg_dt()%></td>
	</tr>  				
	<tr>
	  <td>※ 수정과 스캔등록은 동시에 되지 않습니다. 수정을 먼저하고 스캔등록해주세요.&nbsp;</td>
	</tr>  		
	<%	int pay_chk_cnt  =  pm_db.getPayRegChk2(pay);
		if(pay_chk_cnt>1 && pay.getReg_st().equals("D") && item.getP_st2().equals("차량정비비")){%> 			
	<tr>
	  <td><font color=red>※ 거래일자, 지출처명, 금액이 동일한 건이 이미 기등록되어 있습니다. 확인하십시오.</font></td>
	</tr> 		
	<%	}%>			
    <tr>
	    <td align='right'>
		<%if(pay.getReg_id().equals(user_id) || nm_db.getWorkAuthUser("전산팀",user_id) || nm_db.getWorkAuthUser("회계업무",user_id)){%>		
		<!--[조회등록]미지급금전표발행-->		
		<%	if(pay.getReg_st().equals("S") && !pay.getR_acct_code().equals("25300")){%>
		<%			if(item.getP_gubun().equals("11")||item.getP_gubun().equals("12")||item.getP_gubun().equals("13")||item.getP_gubun().equals("15")||item.getP_gubun().equals("16")||item.getP_gubun().equals("18")||item.getP_gubun().equals("19")){%>
		&nbsp;&nbsp;&nbsp;&nbsp;<a href="javascript:doc_reg_search()" onMouseOver="window.status=''; return true" onfocus="this.blur()"><img src=/acar/images/center/button_jpbh_mgg.gif border=0 align=absmiddle></a>
		<%			}%>
		<%	}%>
		<!--삭제-->
		&nbsp;&nbsp;&nbsp;&nbsp;<a href="javascript:pay_delete();"><img src=/acar/images/center/button_delete.gif align=absmiddle border=0></a>
		<%}%>				
	    </td>
	</tr>	
	
	<tr>
	  <td><hr></td>
	</tr>  			
	<tr>
	  <td><img src=/acar/images/center/icon_arrow.gif align=absmiddle> <span class=style2>세부리스트</span></td>
	</tr>  		
    <tr>
      <td class=line> 
        <table border="0" cellspacing="1" cellpadding='0' width=100%>
          <tr>
            <td width="10%" class=title>연번</td>
            <td width="10%" class=title>비용담당자</td>
            <td width="10%" class=title>금액</td>						
            <td width="10%" class=title>구분</td>			
            <td width="10%" class=title>계정과목</td>			
            <td width="50%" class=title>적요</td>									
          </tr>          
          <%	
          	String p_gubun_nm = ""; 
          	total_amt1 	= AddUtil.parseLong(String.valueOf(pay.getAmt()));
		 	for(int i = 0 ; i < vt_size ; i++){
				PayMngBean pm = (PayMngBean)vt.elementAt(i);
				total_amt2 	= total_amt2 + AddUtil.parseLong(String.valueOf(pm.getI_amt()));
				p_gubun_nm = pm.getP_st2()+pm.getP_st4();
				double cha_amt = 0;
				if(p_gubun_nm.equals("영업수당vat")){
					cha_amt 	= AddUtil.parseDouble(String.valueOf(pm.getSub_amt2())) - ( AddUtil.parseDouble(String.valueOf(pm.getSub_amt1()))*0.1 );
				}
		  %>			  
          <tr>
            <td align="center"><%=i+1%><input type="hidden" name="i_seq" 	value="<%=pm.getI_seq()%>">  </td>
            <td align="center"><%=pm.getBuy_user_nm()%></td>			
            <td align="right"><a href="javascript:update_page('<%=pm.getI_seq()%>');"><%=AddUtil.parseDecimalLong(pm.getI_amt())%>원</a>
            <font color=red>
            <br>
            <%=AddUtil.parseDecimalLong(pm.getSub_amt1())%>원
            <br>
            <%=AddUtil.parseDecimalLong(pm.getSub_amt2())%>원            
            </font>
            <%if(cha_amt>100){ %>
            <br>
            <font color=orange><b>(금액확인:<%=cha_amt%>원)</b></font>
            <%} %>
            </td>
            <td align="center"><%=pm.getP_st2()%></td>	
            <td align="center"><%=pm.getAcct_code()%></td>			
            <td>&nbsp;<textarea name="p_cont" cols="90" rows="2" class="text"><%=pm.getP_cont()%></textarea>
              <%if(ck_acar_id.equals("000029")) {%>
			  <br>|| p_cd1:<%=pm.getP_cd1()%> || p_cd2:<%=pm.getP_cd2()%> || p_cd3:<%=pm.getP_cd3()%> || p_cd4:<%=pm.getP_cd4()%> || p_cd5:<%=pm.getP_cd5()%> ||p_cd6:<%=pm.getP_cd6()%> ||
			  <br>|| p_st1:<%=pm.getP_st1()%> || p_st2:<%=pm.getP_st2()%> || p_st3:<%=pm.getP_st3()%> || p_st4:<%=pm.getP_st4()%> || p_st5:<%=pm.getP_st5()%> ||
			  <%} %>
			</td>												
          </tr>
	      <%}%>		
		  <tr>
		    <td class='title' colspan="2">합계</td>
		    <td class='title' style='text-align:right;'><%=AddUtil.parseDecimalLong(total_amt2)%>원</td>		
		    <td class='title' colspan="3">&nbsp;
			<%if(total_amt1 >total_amt2){%>
			<font color=red>미등록분이 <%=AddUtil.parseDecimalLong(total_amt1-total_amt2)%>원이 있습니다.</font>
			<%}%>
			</td>			
		  </tr>	  
		</table>
	  </td>
	</tr> 					
	<tr>
	  <td>&nbsp;</td>
	</tr>  
	<%if(!mode.equals("view")){%>
            <%if( auth_rw.equals("2") || auth_rw.equals("4") || auth_rw.equals("6")) {%>				
    <tr>
	    <td align='right'>
	    <a id="submitLink" href="javascript:save()" onMouseOver="window.status=''; return true" onfocus="this.blur()"><img src=/acar/images/center/button_modify.gif border=0 align=absmiddle></a>
	    </td>
	</tr>	
	    <%}%>
	<%}else{%>	
    <tr>
	    <td align='right'>
	    <a href="javascript:window.close()" onMouseOver="window.status=''; return true" onfocus="this.blur()"><img src=/acar/images/center/button_close.gif border=0 align=absmiddle></a>
	    </td>
	</tr>	
	<%}%>
	<tr>
	    <td align="right">&nbsp;</td>
	</tr>	
  </table>
</form>
<script language='javascript'>
<!--
//	Keyvalue();
//-->
</script>
</body>
</html>
<iframe src="about:blank" name="i_no" width="0" height="0" frameborder="0" noresize></iframe>

