<%@ page language="java" contentType="text/html;charset=euc-kr"%>
<%@ page import="java.io.*, java.util.*, acar.util.*, acar.common.*"%>
<%@ page import="acar.pay_mng.*"%>
<%@ include file="/acar/cookies.jsp"%>
<%@ include file="/acar/access_log.jsp" %>

<%
	String auth_rw 		= request.getParameter("auth_rw")	==null?"":request.getParameter("auth_rw");
	String user_id 		= request.getParameter("user_id")	==null?"":request.getParameter("user_id");
	String br_id 		= request.getParameter("br_id")		==null?"":request.getParameter("br_id");
	
	String pay_gubun 	= request.getParameter("pay_gubun")	==null?"":request.getParameter("pay_gubun");
	String pay_est_dt	= request.getParameter("pay_est_dt")==null?AddUtil.getDate():request.getParameter("pay_est_dt");
	String pay_off		= request.getParameter("pay_off")	==null?"":request.getParameter("pay_off");
	String mode			= request.getParameter("mode")		==null?"":request.getParameter("mode");
	
	CommonDataBase c_db = CommonDataBase.getInstance();
	
	String vid[] = request.getParameterValues("ch_cd");
	int vid_size=0;
	int cnt = 0;
	
	if(mode.equals("search") && vid.length>0){
		vid_size = vid.length;
	}
	
	//금융사리스트
	CodeBean[] banks = c_db.getCodeAll("0003");
	int bank_size = banks.length;
%>
<html>
<head>
<title>FMS</title>
<meta http-equiv="Content-Type" content="text/html; charset=euc-kr">
	<%@ include file="/acar/getNaviCookies.jsp" %>
<link rel=stylesheet type="text/css" href="/include/table_t.css">
<script language='JavaScript' src='/include/common.js'></script>
<script language='javascript'>
<!--
	//검색하기
	function search(){
		var fm = document.form1;
		
		if(fm.pay_gubun.value == '') 	{ alert('출금항목을 확인하십시오.'); 		return; }
		
		if(fm.pay_gubun.value == '55' && fm.pay_est_dt.value == '<%=AddUtil.getDate(1)%>') 	{ fm.pay_est_dt.value = '<%=AddUtil.getDate()%>';}
		
		var pop_nm  = "SEARCH_PAY";
		var pop_url = "pay_list_search.jsp";		
		var pop_var = "?auth_rw=<%=auth_rw%>&user_id=<%=user_id%>&br_id=<%=br_id%>&vid_size=<%=vid_size%>&pay_est_dt="+fm.pay_est_dt.value+"&pay_off="+fm.pay_off.value+"&pay_gubun="+fm.pay_gubun.value+"&pay_gubun_nm="+fm.pay_gubun.options[fm.pay_gubun.selectedIndex].text+"&h_cnt="+fm.h_cnt.value;
		var pop_opt = "left=20, top=50, width=1200, height=650, scrollbars=yes, scrollbars=yes, status=yes";
		
		if(fm.t_wd.value != ''){
			pop_var = pop_var+"&s_kd=3&t_wd="+fm.t_wd.value;
		}
		
				
		window.open(pop_url+""+pop_var, pop_nm, pop_opt);
	}	
	
	function save()
	{
		var fm = document.form1;
		
		if(fm.pay_gubun.value == '07' && fm.cardno.value == '') 	{ alert('사전계약계약금입니다. 결제카드를 입력하십시오.'); return;}
		if(fm.pay_gubun.value == '08' && fm.cardno.value == '') 	{ alert('계약금카드결제입니다. 결제카드를 입력하십시오.'); return;}
		
		if(confirm('등록하시겠습니까?')){
			
			var link = document.getElementById("submitLink");
			var originFunc = link.getAttribute("href");
			link.setAttribute('href',"javascript:alert('처리 중입니다. 잠시만 기다려주세요');");
			
			fm.action = 'pay_list_reg_a_step1.jsp';
			fm.target = 'i_no';
			fm.submit();		
			
			link.getAttribute('href',originFunc);	
		}
	}
	
	//지출처조회하기
	function off_search(idx){
		var fm = document.form1;	
		var t_wd = fm.off_nm[idx].value;
		var off_st = fm.off_st[idx].value;
		if(fm.pay_gubun.value == '15' || fm.pay_gubun.value == '16' || fm.pay_gubun.value == '18' || fm.pay_gubun.value == '19') off_st = 'off_id';
		window.open("/fms2/pay_mng/off_list.jsp?way_size=1&auth_rw=<%=auth_rw%>&user_id=<%=user_id%>&br_id=<%=br_id%>&off_st="+off_st+"&idx="+idx+"&t_wd="+t_wd+"&off_st_nm=&vid_size=100", "OFF_LIST", "left=50, top=50, width=1150, height=550, scrollbars=yes, status=yes");		
	}
	
	//조회날짜 셋팅
	function select_dt(){
		var fm = document.form1;
		if(fm.est_dt_st.value == ''){
			fm.pay_est_dt.value = '';			
		}else{
			fm.pay_est_dt.value = ChangeDate(fm.est_dt_st.value);
		}
	}
	
	//지출처별 현황보기
	function search_stat_view(){
		var fm = document.form1;		
		if(fm.pay_gubun.value == '04'){
			tr_stat.style.display	= '';
		}else{
			tr_stat.style.display	= 'none';
		}	
	}
	
	//거래처별 현황보기
	function off_stat_view(){
		var fm = document.form1;
		
		if(fm.pay_gubun.value == '') 	{ alert('출금항목을 확인하십시오.'); 		return; }
		
		if(fm.pay_gubun.value == '55' && fm.pay_est_dt.value == '<%=AddUtil.getDate(1)%>') 	{ fm.pay_est_dt.value = '<%=AddUtil.getDate()%>';}
		
		var pop_nm  = "SEARCH_PAY_STAT";
		var pop_url = "pay_list_search_stat.jsp";		
		var pop_var = "?auth_rw=<%=auth_rw%>&user_id=<%=user_id%>&br_id=<%=br_id%>&pay_est_dt="+fm.pay_est_dt.value+"&pay_off="+fm.pay_off.value+"&pay_gubun="+fm.pay_gubun.value+"&pay_gubun_nm="+fm.pay_gubun.options[fm.pay_gubun.selectedIndex].text;
		var pop_opt = "left=20, top=50, width=600, height=500, scrollbars=yes, status=yes";
		
		if(fm.t_wd.value != ''){
			pop_var = pop_var+"&s_kd=3&t_wd="+fm.t_wd.value;
		}
						
		window.open(pop_url+""+pop_var, pop_nm, pop_opt);
	}	
	
	//카드번호 조회
	function cng_input_card(){
		window.open("/fms2/car_pur/s_cardno.jsp?go_url=/fms2/pay_mng/pay_list_reg.jsp", "CARDNO", "left=10, top=10, width=500, height=700, scrollbars=yes, status=yes, resizable=yes");
	}

//-->
</script>
</head>
<body>
<form name='form1' action='' target='' method='post'>
<input type='hidden' name='auth_rw' value='<%=auth_rw%>'>
<input type='hidden' name='user_id' value='<%=user_id%>'>
<input type='hidden' name='br_id' value='<%=br_id%>'>
<input type='hidden' name='vid_size' value='<%=vid_size%>'>

  <table border='0' cellspacing='0' cellpadding='0' width='100%'>
    <tr>
      <td>
    	<table width=100% border=0 cellpadding=0 cellspacing=0>
          <tr>
            <td width=7><img src=/acar/images/center/menu_bar_1.gif width=7 height=33></td>
            <td class=bar>&nbsp;&nbsp;&nbsp;<img src=/acar/images/center/menu_bar_dot.gif width=4 height=5 align=absmiddle>&nbsp;<span class=style1>재무회계 > 집금관리 > <span class=style5>출금원장[조회]등록</span></span></td>
            <td width=7><img src=/acar/images/center/menu_bar_2.gif width=7 height=33></td>
          </tr>
        </table>
      </td>
    </tr>
    <tr>
      <td class=h></td>
    </tr>
    <tr>
      <td>&nbsp;</td>
    </tr>	
    <tr>
      <td><img src=/acar/images/center/icon_arrow.gif align=absmiddle> <span class=style2>
	  [FMS 출금관리항목] 자동차대금/영업수당/자동차보험료/할부금/할부금중도상환/정비비/정비비(정산)/자손공임부가세/자손부품부가세/탁송료/용품비/검사비<br>
	  &nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;
	  과태료/취득세/개별소비세/자동차세/환경개선부담금<br>
	  &nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;
	  해지정산금환불/법인카드결재</span></td>
    </tr>	
    <tr>
      <td class=line2></td>
    </tr>	
    <tr>
      <td class=line>
        <table border="0" cellspacing="1" cellpadding='0' width=100%>
                <tr>
		    <td class="title">조회일자</td>
		    <td>&nbsp;
		        <select name='est_dt_st' onChange='javascript:select_dt();'>		            
          	            <%for (int i = -2 ; i < 2 ; i++){
          	    		String est_dt = c_db.addDay(AddUtil.getDate(4), i);          	    		
          	    		String est_dt_nm = "";
          	    		if(i==-2) 	est_dt_nm = "전전일";
          	    		if(i==-1) 	est_dt_nm = "전일";
          	    		if(i== 0) 	est_dt_nm = "당일";
          	    		if(i== 1) 	est_dt_nm = "익일";          	    		
          	            %>
		            <option value='<%=est_dt%>' <%if(i==0)%>selected<%%>><%=est_dt_nm%></option>		            
          	            <%}%>
          	            <option value=''>직접</option>
	                </select>	
	                &nbsp;			
			<%pay_est_dt=AddUtil.getDate(4);%>
			<input type="text" name="pay_est_dt" size='12' class='text' value="<%= AddUtil.ChangeDate2(pay_est_dt) %>"> 
			&nbsp;(출금예정일자) 
	            </td>
		</tr>		
                <tr>    
			<td width="10%" class="title">조회항목</td>
			<td width="90%">&nbsp;
			  <select name='pay_gubun' onChange='javascript:search_stat_view();' >
                <option value="">----선택----</option>
				
        <option value="01" <%if(pay_gubun.equals("01"))%>selected<%%>>자동차대금</option>
        <option value="06" <%if(pay_gubun.equals("06"))%>selected<%%>>중고차대금</option>
        <option value="07" <%if(pay_gubun.equals("07"))%>selected<%%>>사전계약계약금</option>        
        <option value="08" <%if(pay_gubun.equals("08"))%>selected<%%>>계약금카드결제</option>
				<option value="02" <%if(pay_gubun.equals("02"))%>selected<%%>>영업수당</option>
				<option value="03" <%if(pay_gubun.equals("03"))%>selected<%%>>자동차보험료</option>
				<option value="04" <%if(pay_gubun.equals("04"))%>selected<%%>>할부금</option>
				<option value="05" <%if(pay_gubun.equals("05"))%>selected<%%>>할부금(중도상환)</option>				
				
				<option value="11" <%if(pay_gubun.equals("11"))%>selected<%%>>정비비</option>
				<option value="14" <%if(pay_gubun.equals("14"))%>selected<%%>>정비비(정산)</option>				
				<option value="15" <%if(pay_gubun.equals("15"))%>selected<%%>>피해사고공임부가세</option>
				<option value="16" <%if(pay_gubun.equals("16"))%>selected<%%>>피해사고부품부가세</option>				
				<option value="18" <%if(pay_gubun.equals("18"))%>selected<%%>>피해사고렌트부가세</option>
				<option value="19" <%if(pay_gubun.equals("19"))%>selected<%%>>피해사고유리부가세</option>				
				<option value="12" <%if(pay_gubun.equals("12"))%>selected<%%>>탁송료</option>
				<option value="13" <%if(pay_gubun.equals("13"))%>selected<%%>>용품비</option>
				<option value="17" <%if(pay_gubun.equals("17"))%>selected<%%>>검사비</option>

				
				<option value="25" <%if(pay_gubun.equals("25"))%>selected<%%>>취득세</option>								
				<option value="22" <%if(pay_gubun.equals("22"))%>selected<%%>>개별소비세</option>				
				<option value="23" <%if(pay_gubun.equals("23"))%>selected<%%>>자동차세</option>
				<option value="24" <%if(pay_gubun.equals("24"))%>selected<%%>>환경개선부담금</option>

				<option value="31" <%if(pay_gubun.equals("31"))%>selected<%%>>해지정산금환불</option>				
				<option value="37" <%if(pay_gubun.equals("37"))%>selected<%%>>월렌트정산금환불</option>

				<option value="33" <%if(pay_gubun.equals("33"))%>selected<%%>>계약승계보증금승계</option>				
				<option value="35" <%if(pay_gubun.equals("35"))%>selected<%%>>계약승계보증금환불</option>	
				<option value="36" <%if(pay_gubun.equals("36"))%>selected<%%>>연장계약보증금환불</option>
				
				<option value="41" <%if(pay_gubun.equals("41"))%>selected<%%>>법인카드대금</option>								
				<option value="44" <%if(pay_gubun.equals("44"))%>selected<%%>>법인카드대금(자동차대금)</option>		
				<option value="47" <%if(pay_gubun.equals("47"))%>selected<%%>>법인카드대금(지방세말일결재)</option>
				<option value="48" <%if(pay_gubun.equals("48"))%>selected<%%>>법인카드대금(지방세익월8일결재)</option>
				<option value="45" <%if(pay_gubun.equals("45"))%>selected<%%>>법인카드대금(지방세23일결재)</option>		
				<option value="46" <%if(pay_gubun.equals("46"))%>selected<%%>>법인카드대금(선불기타)</option>		
				<option value="42" <%if(pay_gubun.equals("42"))%>selected<%%>>법인카드대금(지방세20일결재)</option>
				<option value="43" <%if(pay_gubun.equals("43"))%>selected<%%>>법인카드대금(지방세익월5일결재)</option>
				
				<option value="51" <%if(pay_gubun.equals("51"))%>selected<%%>>캠페인포상</option>
				<option value="52" <%if(pay_gubun.equals("52"))%>selected<%%>>제안포상</option>
				<option value="53" <%if(pay_gubun.equals("53"))%>selected<%%>>귀향여비</option>				
     		<option value="55" <%if(pay_gubun.equals("55"))%>selected<%%>>당직비</option>
			  </select>			  
			</td>
		  </tr>
		  <tr>
			<td class="title">지출처</td>
			<td>&nbsp;
			  <input type="text" name="pay_off" size='30' class='text' value="<%=pay_off%>"> 
			  &nbsp;</td>
		  </tr>				  
		  <tr>
			<td class="title">검색</td>
			<td>&nbsp;
			  차량번호 : 
			  <input type="text" name="t_wd" size='30' class='text' value=""> 
			  &nbsp;&nbsp;&nbsp;&nbsp;			  
			  <a href="javascript:search()" onMouseOver="window.status=''; return true" onfocus="this.blur()"><img src=/acar/images/center/button_search.gif border=0 align=absmiddle>
			  </td>
		  </tr>				  
	    </table>
	  </td>
    </tr>	    
    <tr align="right" id=tr_stat style='display:none'>
        <td colspan="2"><a href="javascript:off_stat_view()" onMouseOver="window.status=''; return true" onfocus="this.blur()">[거래처별 금액 확인]</a>                        	
		</td>
    </tr>	
    
<%		if(vid_size >0){
			String value01[] = request.getParameterValues("p_st1");
			String value02[] = request.getParameterValues("p_st2");
			String value03[] = request.getParameterValues("p_st3");
			String value04[] = request.getParameterValues("p_cd1");
			String value05[] = request.getParameterValues("p_cd2");
			String value06[] = request.getParameterValues("p_cd3");
			String value07[] = request.getParameterValues("amt");
			String value08[] = request.getParameterValues("bank_nm");
			String value09[] = request.getParameterValues("bank_no");
			String value10[] = request.getParameterValues("off_st");
			String value11[] = request.getParameterValues("off_id");
			String value12[] = request.getParameterValues("off_nm");
			String value13[] = request.getParameterValues("p_cont");
			String value14[] = request.getParameterValues("p_way");
			String value15[] = request.getParameterValues("p_cd4");
			String value16[] = request.getParameterValues("p_cd5");
			String value17[] = request.getParameterValues("p_st4");
			String value18[] = request.getParameterValues("p_st5");
			String value19[] = request.getParameterValues("est_dt");
			String value20[] = request.getParameterValues("ven_code");
			String value21[] = request.getParameterValues("ven_name");
			String value22[] = request.getParameterValues("bank_id");
			String value23[] = request.getParameterValues("sub_amt1");
			String value24[] = request.getParameterValues("sub_amt2");
			String value25[] = request.getParameterValues("sub_amt3");
			String value26[] = request.getParameterValues("card_id");
			String value27[] = request.getParameterValues("card_nm");
			String value28[] = request.getParameterValues("card_no");
			String value29[] = request.getParameterValues("sub_amt4");
			String value30[] = request.getParameterValues("sub_amt5");
			String value31[] = request.getParameterValues("a_bank_id");
			String value32[] = request.getParameterValues("a_bank_nm");
			String value33[] = request.getParameterValues("a_bank_no");
			String value34[] = request.getParameterValues("buy_user_id");
			String value35[] = request.getParameterValues("s_idno");
			String value36[] = request.getParameterValues("acct_code");
			String value37[] = request.getParameterValues("bank_acc_nm");
			String value38[] = request.getParameterValues("bank_cms_bk");
			String value39[] = request.getParameterValues("a_bank_cms_bk");
			String value40[] = request.getParameterValues("off_tel");
			String value41[] = request.getParameterValues("sub_amt6");
			%>	
    <tr>
      <td class=line2></td>
    </tr>				
    <tr>
      <td class=line>
	    <table border="0" cellspacing="1" cellpadding='0' width=100%>
		  <tr>
			<td width=3% rowspan="2" class='title'>연번</td>		  
			<td width=9% rowspan="2" class='title'>출금항목</td>
		    <td width=17% rowspan="2" class='title'>지출처<br>/네오엠거래처</td>						
		    <td width=24% rowspan="2" class='title'>적요</td>			
			<td width=8% rowspan="2" class='title'>금액<%if(pay_gubun.equals("15")||pay_gubun.equals("16")){%><br>/과세표준액<%}%></td>			
			<td width=6% rowspan="2" class='title'>출금방식</td>
			<td colspan="2" class='title'>입금정보</td>				  		  				  
			<td colspan="2" class='title'>카드정보</td>			
		  </tr>
		  <tr>
		    <td width="6%" class='title'>은행</td>
	        <td width="11%" class='title'>계좌번호</td>
		    <td width=6% class='title'>카드사</td>
		    <td width=10% class='title'>카드번호</td>
		  </tr>
<%			for(int i=0; i<vid_size;i++){
				int idx			= AddUtil.parseInt(vid[i]);
				cnt++;%>
		  <tr>
			<td align='center'><%=cnt%></td>
			<td align='center'><%=value02[idx]%></td>
			<td align='center'><input type='text' name='off_nm' class=text size='20' value='<%=value12[idx]%>'>
			<a href="javascript:off_search('<%=i%>')" onMouseOver="window.status=''; return true"><img src=/acar/images/center/button_in_search1.gif border=0 align=absmiddle></a>
			<br><input type='text' name='ven_name' class=text size='25' value='<%=value21[idx]%>'></td>	
			<td align='center'><textarea name="p_cont" cols="36" rows="3" class="text"><%=value13[idx]%></textarea></td>				
			<td align='right'><input type='text' name='amt' class='num' size='15' value='<%=AddUtil.parseDecimalLong(String.valueOf(value07[idx]))%>'>
			<%if(pay_gubun.equals("15")||pay_gubun.equals("16")){%><br><input type='text' name='sub_amt2' class='num' size='15' value='<%=AddUtil.parseDecimalLong(String.valueOf(value24[idx]))%>'><%}%>
			</td>								
			<td align='center'><%=value03[idx]%></td>
			<td align='center'><%=value08[idx]%></td>
			<td align='center'><%=value09[idx]%></td>
			<td align='center'><%=value27[idx]%></td>
			<td align='center'><%=value28[idx]%></td>
		  </tr>		  
			<input type='hidden' name='p_st1' 		value='<%=value01[idx]%>'>
			<input type='hidden' name='p_st2' 		value='<%=value02[idx]%>'>
			<input type='hidden' name='p_st3' 		value='<%=value03[idx]%>'>			
			<input type='hidden' name='p_cd1' 		value='<%=value04[idx]%>'>
			<input type='hidden' name='p_cd2' 		value='<%=value05[idx]%>'>
			<input type='hidden' name='p_cd3' 		value='<%=value06[idx]%>'>
			<input type='hidden' name='bank_nm' 	value='<%=value08[idx]%>'>
			<input type='hidden' name='bank_no' 	value='<%=value09[idx]%>'>
			<input type='hidden' name='off_st' 		value='<%=value10[idx]%>'>
			<input type='hidden' name='off_id' 		value='<%=value11[idx]%>'>
			<input type='hidden' name='p_way' 		value='<%=value14[idx]%>'>			
			<input type='hidden' name='p_cd4' 		value='<%=value15[idx]%>'>
			<input type='hidden' name='p_cd5' 		value='<%=value16[idx]%>'>			
			<input type='hidden' name='p_st4' 		value='<%=value17[idx]%>'>
			<input type='hidden' name='p_st5' 		value='<%=value18[idx]%>'>
			<input type='hidden' name='est_dt' 		value='<%=value19[idx]%>'>
			<input type='hidden' name='ven_code' 	value='<%=value20[idx]%>'>
			<input type='hidden' name='bank_id' 	value='<%=value22[idx]%>'>	
			<input type='hidden' name='sub_amt1'	value='<%=value23[idx]%>'>
			<%if(pay_gubun.equals("15")||pay_gubun.equals("16")){%>
			<%}else{%>
			<input type='hidden' name='sub_amt2'	value='<%=value24[idx]%>'>
			<%}%>
			<input type='hidden' name='sub_amt3'	value='<%=value25[idx]%>'>											
			<input type='hidden' name='card_id' 	value='<%=value26[idx]%>'>
			<input type='hidden' name='card_nm' 	value='<%=value27[idx]%>'>
			<input type='hidden' name='card_no' 	value='<%=value28[idx]%>'>
			<input type='hidden' name='sub_amt4'	value='<%=value29[idx]%>'>
			<input type='hidden' name='sub_amt5'	value='<%=value30[idx]%>'>											
			<input type='hidden' name='a_bank_id' 	value='<%=value31[idx]%>'>				
			<input type='hidden' name='a_bank_nm' 	value='<%=value32[idx]%>'>
			<input type='hidden' name='a_bank_no' 	value='<%=value33[idx]%>'>
			<input type='hidden' name='buy_user_id' value='<%=value34[idx]%>'>
			<input type='hidden' name='s_idno' 		value='<%=value35[idx]%>'>
			<input type='hidden' name='acct_code'	value='<%=value36[idx]%>'>
			<input type='hidden' name='bank_acc_nm'	value='<%=value37[idx]%>'>
			<input type='hidden' name='bank_cms_bk'	value='<%=value38[idx]%>'>			
			<input type='hidden' name='a_bank_cms_bk'	value='<%=value39[idx]%>'>						
			<input type='hidden' name='off_tel'		value='<%=value40[idx]%>'>	
			<input type='hidden' name='sub_amt6'	value='<%=value41[idx]%>'>					
			<input type='hidden' name='h_p_st2'		value=''>
			<input type='hidden' name='h_p_st3'		value=''>
			<input type='hidden' name='h_bank_nm'	value=''>
			<input type='hidden' name='h_bank_no'	value=''>
			<input type='hidden' name='h_card_nm'	value=''>
			<input type='hidden' name='h_card_no'	value=''>
<%			}%>

<%		if(vid_size <100){%>
<%			for(int i=vid_size; i<100;i++){
				cnt++;%>
		  <tr id=tr_h_item<%=cnt%> style='display:none'>
			<td align='center'><%=cnt%></td>
			<td align='center'><input type='text' name='h_p_st2' class=whitetext readonly size='20' value=''></td>
			<td align='center'><input type='text' name='off_nm' class=text size='20' value=''>
			<a href="javascript:off_search('<%=i%>')" onMouseOver="window.status=''; return true"><img src=/acar/images/center/button_in_search1.gif border=0 align=absmiddle></a>
			<br><input type='text' name='ven_name' class=text size='25' value=''></td>	
			<td align='center'><textarea name="p_cont" cols="36" rows="3" class="text"></textarea></td>				
			<td align='right'><input type='text' name='amt' class='num' size='15' value=''>
			<br><input type='text' name='sub_amt2' class='num' size='15' value=''>
			<br>(피해사고부품부가세 등)
			</td>								
			<td align='center'><input type='text' name='h_p_st3' class=whitetext readonly size='10' value=''></td>
			<td align='center'><input type='text' name='h_bank_nm' class=whitetext readonly size='10' value=''></td>
			<td align='center'><input type='text' name='h_bank_no' class=whitetext readonly size='20' value=''></td>
			<td align='center'><input type='text' name='h_card_nm' class=whitetext readonly size='10' value=''></td>
			<td align='center'><input type='text' name='h_card_no' class=whitetext readonly size='20' value=''></td>
		  </tr>		  
			<input type='hidden' name='p_st1' 		value=''>
			<input type='hidden' name='p_st2' 		value=''>
			<input type='hidden' name='p_st3' 		value=''>			
			<input type='hidden' name='p_cd1' 		value=''>
			<input type='hidden' name='p_cd2' 		value=''>
			<input type='hidden' name='p_cd3' 		value=''>
			<input type='hidden' name='bank_nm' 	value=''>
			<input type='hidden' name='bank_no' 	value=''>
			<input type='hidden' name='off_st' 		value=''>
			<input type='hidden' name='off_id' 		value=''>
			<input type='hidden' name='p_way' 		value=''>			
			<input type='hidden' name='p_cd4' 		value=''>
			<input type='hidden' name='p_cd5' 		value=''>			
			<input type='hidden' name='p_st4' 		value=''>
			<input type='hidden' name='p_st5' 		value=''>
			<input type='hidden' name='est_dt' 		value=''>
			<input type='hidden' name='ven_code' 	value=''>
			<input type='hidden' name='bank_id' 	value=''>	
			<input type='hidden' name='sub_amt1'	value=''>			
			<input type='hidden' name='sub_amt3'	value=''>											
			<input type='hidden' name='card_id' 	value=''>
			<input type='hidden' name='card_nm' 	value=''>
			<input type='hidden' name='card_no' 	value=''>
			<input type='hidden' name='sub_amt4'	value=''>
			<input type='hidden' name='sub_amt5'	value=''>											
			<input type='hidden' name='a_bank_id' 	value=''>				
			<input type='hidden' name='a_bank_nm' 	value=''>
			<input type='hidden' name='a_bank_no' 	value=''>
			<input type='hidden' name='buy_user_id' value=''>
			<input type='hidden' name='s_idno' 		value=''>
			<input type='hidden' name='acct_code'	value=''>
			<input type='hidden' name='bank_acc_nm'	value=''>
			<input type='hidden' name='bank_cms_bk'	value=''>			
			<input type='hidden' name='a_bank_cms_bk'	value=''>						
			<input type='hidden' name='off_tel'		value=''>
			<input type='hidden' name='sub_amt6'	value=''>					
<% 			}%>					
<%		}%>

        </table>
	  </td>
    </tr>  
    <tr> 
      <td>&nbsp;</td>
    </tr> 
    <%if(pay_gubun.equals("07") || pay_gubun.equals("08")){%>	
    <tr> 
      <td>※ 사전계약계약금 카드결재이거나 계약금카드결재인 경우 카드번호 입력하십시오. 카드번호 : <input type='text' name='cardno' value='' maxlength='30' size='20' class='text'>&nbsp;
      <span class="b"><a href="javascript:cng_input_card()" onMouseOver="window.status=''; return true" title="클릭하세요"><img src=/acar/images/center/button_in_search.gif align=absmiddle border=0></a></span>
	  (일괄반영 카드번호를 입력합니다.)
	  </td>
    </tr>  	
	<%}%>
	<%if(!pay_gubun.equals("31") && !pay_gubun.equals("37")){%>	
    <tr> 
      <td>※ 통합거래일자 : <input type='text' name='p_est_dt' value='' maxlength='10' size='11' class='text' onBlur='javscript:this.value = ChangeDate(this.value);'>&nbsp;
	  (통합거래일자가 없으면 각 건별 예정일을 거래일자로 등록합니다.)
	  </td>
    </tr>  	
	<%}%>
	<%if(pay_gubun.equals("22") || pay_gubun.equals("23") || pay_gubun.equals("24") || pay_gubun.equals("25")){%>	
    <tr> 
      <td>※ [지방세]취득세/자동차세/환경개선부담금/개별소비세 후불카드결재일 경우 회계처리시 법인카드전표 등록합니다.
	  </td>
    </tr>  	
	<%}%>
	
    <tr> 
      <td>※ <font color=red>지출처(25자), 네오엠 거래처(15자), 적요(100자)의 내용이 길 경우에는 편집해주세요.</font></td>
    </tr>  		

    <%if( auth_rw.equals("2") || auth_rw.equals("4") || auth_rw.equals("6")) {%>		
    <tr> 
        <td align="right"> 
            <a id="submitLink" href="javascript:save();"><img src=/acar/images/center/button_reg.gif align=absmiddle border=0></a>						
        </td>
    </tr>  				
    <%}%>
<%		}%>	



  </table>
<input type='hidden' name='cnt' 	value='<%=cnt%>'>  
<input type='hidden' name='h_cnt' 	value='<%=vid_size%>'>
</form>
<iframe src="about:blank" name="i_no" width="0" height="0" frameborder="0" noresize></iframe>
</body>
</html>
