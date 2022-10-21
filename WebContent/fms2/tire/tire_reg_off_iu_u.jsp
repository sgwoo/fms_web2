<%@ page language="java" contentType="text/html;charset=euc-kr"%>
<%@ page import="java.util.*,acar.util.*,acar.common.*,acar.user_mng.*"%>
<%@ page import="acar.tire.*"%>
<jsp:useBean id="t_db" scope="page" class="acar.tire.TireDatabase"/>
<%@ include file="/off/cookies.jsp" %> 

<%
	String auth_rw 	= request.getParameter("auth_rw")==null?"":request.getParameter("auth_rw");
	String user_id 	= request.getParameter("user_id")==null?"":request.getParameter("user_id");
	String br_id 	= request.getParameter("br_id")==null?"":request.getParameter("br_id");
	
	String s_kd 	= request.getParameter("s_kd")==null?"":request.getParameter("s_kd");
	String t_wd 	= request.getParameter("t_wd")==null?"":request.getParameter("t_wd");
	String andor 	= request.getParameter("andor")==null?"":request.getParameter("andor");
	String gubun1 	= request.getParameter("gubun1")==null?"":request.getParameter("gubun1");
	String gubun2 	= request.getParameter("gubun2")==null?"":request.getParameter("gubun2");
	String gubun3 	= request.getParameter("gubun3")==null?"":request.getParameter("gubun3");
	String st_dt 	= request.getParameter("st_dt")==null?"":request.getParameter("st_dt");
	String end_dt 	= request.getParameter("end_dt")==null?"":request.getParameter("end_dt");
	String sort 	= request.getParameter("sort")==null?"":request.getParameter("sort");
	
	String dtire_gb 	= request.getParameter("dtire_gb")==null?"":request.getParameter("dtire_gb");
	
	int sh_height = request.getParameter("sh_height")==null?0:Util.parseInt(request.getParameter("sh_height"));//상단길이
	
	String seq 		= request.getParameter("seq")==null?"":request.getParameter("seq");
	String reg_st 		= request.getParameter("reg_st")==null?"":request.getParameter("reg_st");
	String from_page 	= request.getParameter("from_page")==null?"":request.getParameter("from_page");
	String mode 		= request.getParameter("mode")==null?"":request.getParameter("mode");
	String cmd 		= request.getParameter("cmd")==null?"":request.getParameter("cmd");
	String car_mng_id 		= request.getParameter("c_id")==null?"":request.getParameter("c_id");
	String tire_gubun 		= request.getParameter("tire_gubun")==null?"":request.getParameter("tire_gubun");
	
	String off_id_gubun="";
	String title ="";
	if(tire_gubun.equals("000256")){
		title="타이어휠타운";
		from_page="n_tire_reg_off_frame.jsp";
		off_id_gubun= "008634";
	}
	if(tire_gubun.equals("000148")){
		title="두꺼비카센타";
		from_page="tire_reg_off_frame.jsp";
		off_id_gubun="000092";
	}
	if(tire_gubun.equals("000156")){
		title="티스테이션시청점";
		from_page="ts_tire_reg_off_frame.jsp";
		off_id_gubun="006470";
		
	}
	
	CommonDataBase c_db = CommonDataBase.getInstance();
	MaMenuDatabase nm_db = MaMenuDatabase.getInstance();
	
	
	Hashtable ht = t_db.getDtireMMKK(seq, car_mng_id);
	Hashtable ht4 = t_db.getDtireMMKK3(seq, car_mng_id);
	Hashtable ht3 = t_db.fine_serviceYN(String.valueOf(ht.get("CAR_MNG_ID")), off_id_gubun, String.valueOf(ht.get("DTIRE_DT")));
	String	serv_id = String.valueOf(ht3.get("SERV_ID"));
	String s_cnt = String.valueOf(ht4.get("S_CNT"));
	
	//담당자 리스트
	Vector users = c_db.getUserList("", "", "EMP");
	int user_size = users.size();
%>

<html>
<head>
<title>FMS</title>
<meta http-equiv="Content-Type" content="text/html; charset=euc-kr">
<link rel=stylesheet type="text/css" href="../../include/table_t.css">
<script language='JavaScript' src='/include/common.js'></script>



<script language="JavaScript">
<!--
	function save(cmd)
	{
		var fm = document.form1;
		var innTot = 0;
		if(cmd == 'N'){
		if(fm.dtire_dt.value == '')				{	alert('정비일자를 입력하십시오');return;	}		
		if(fm.car_mng_id.value == '')				{	alert('차량번호를 검색하여 등록해 주시기 바랍니다.');			fm.car_mng_id.focus(); 	return;	}
		if(fm.dtire_carno.value == '')			{	alert('차량번호를 정확하게 입력하십시오');	fm.dtire_carno.focus(); 	return;	}		
		if(fm.dtire_km.value == '' || fm.dtire_km.value == 0 )				{	alert('주행거리를 입력하십시오');			fm.dtire_km.focus(); 	return;	}
		if(fm.req_nm.value == '')				{	alert('의뢰자를 입력하십시오');				fm.req_nm.focus(); 		return;	}
		if(fm.dtire_v_amt.value == ''||fm.dtire_v_amt.value == 0)				{	alert('부가세를 입력하십시오');				fm.dtire_v_amt.focus(); 		return;	}
		}		
		//공급가 누계 금액 체크  
		innTot = toInt(parseDigit(fm.dtire_item_s_amt1.value))+toInt(parseDigit(fm.dtire_item_s_amt2.value))+toInt(parseDigit(fm.dtire_item_s_amt3.value))+toInt(parseDigit(fm.dtire_item_s_amt4.value))+toInt(parseDigit(fm.dtire_item_s_amt5.value))+toInt(parseDigit(fm.dtire_item_s_amt6.value));
	
	        if ( innTot != toInt(parseDigit(fm.dtire_s_amt.value))  ) {	alert('공급가 누계액이 맞지 않습니다. 확인하세요');				fm.dtire_s_amt.focus(); 		return;	}
		//if(fm.dtire_gb.value=='2'){
			//if(fm.accid_check.value == '')				{	alert('사고번호를 검색하여 등록해 주시기 바랍니다.');			fm.accid_id.focus(); 	return;	}
		//}
		<%if(ht.get("DTIRE_GB").equals("2")){%> if(fm.accid_check.value == '')				{	alert('사고번호를 검색하여 입력하십시오');return;	}		<%}%>
				 		
		fm.cmd.value = cmd;
		/*itemAmt();
		itemAmt2('2');
		itemAmt2('3');
		itemAmt2('4');
		itemAmt2('5');
		itemAmt2('6');*/
		//alert(fm.dtire_item_s_amt6.value);
		
		if(confirm('수정하시겠습니까?')){
			var link = document.getElementById("submitLink");
			var originFunc = link.getAttribute("href");
			link.setAttribute('href',"javascript:alert('처리 중입니다. 잠시만 기다려주세요');");		
		
			fm.action = "tire_reg_off_iu_a.jsp";			
			fm.target='i_no';
			fm.submit();
			
			link.getAttribute('href',originFunc);
		}
	}
	
	function tire_reg_off_del(){
		var fm = document.form1;

		if(!confirm('삭제하시겠습니까?'))
			return;		
	//	fm.cmd.value = "d";				
		fm.action = "tire_reg_off_d_a.jsp";	
		fm.target='i_no';
		fm.submit();		
	}
	
	function get_length(f) {
		var max_len = f.length;
		var len = 0;
		for(k=0;k<max_len;k++) {
			t = f.charAt(k);
			if (escape(t).length > 4)
				len += 2;
			else
				len++;
		}
		return len;
	}	
	
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
		fm.dtire_dt.value = s_dt;		
	}

	function Keyvalue() {//공급가 + 부가세 = 합계
	
	var fm   = document.form1;
	var innTot = 0;

	innTot = toInt(parseDigit(fm.dtire_s_amt.value))+toInt(parseDigit(fm.dtire_v_amt.value))
	
	//fm.dtire_amt.value = parseDecimal(innTot);
	
	}
	
	function Keyvalue1() {//1~6번 금액 = 공급가
	
	var fm   = document.form1;
	var innTot = 0;
	var innSot = 0;
	var innVot = 0;
	
	innVot = toInt(parseDigit(fm.dtire_item_v_amt1.value))+toInt(parseDigit(fm.dtire_item_v_amt2.value))+toInt(parseDigit(fm.dtire_item_v_amt3.value))+toInt(parseDigit(fm.dtire_item_v_amt4.value))+toInt(parseDigit(fm.dtire_item_v_amt5.value))+toInt(parseDigit(fm.dtire_item_v_amt6.value));
	innSot = toInt(parseDigit(fm.dtire_item_s_amt1.value))+toInt(parseDigit(fm.dtire_item_s_amt2.value))+toInt(parseDigit(fm.dtire_item_s_amt3.value))+toInt(parseDigit(fm.dtire_item_s_amt4.value))+toInt(parseDigit(fm.dtire_item_s_amt5.value))+toInt(parseDigit(fm.dtire_item_s_amt6.value));
	innTot = toInt(parseDigit(fm.dtire_item_t_amt1.value))+toInt(parseDigit(fm.dtire_item_t_amt2.value))+toInt(parseDigit(fm.dtire_item_t_amt3.value))+toInt(parseDigit(fm.dtire_item_t_amt4.value))+toInt(parseDigit(fm.dtire_item_t_amt5.value))+toInt(parseDigit(fm.dtire_item_t_amt6.value));
	
	
	fm.dtire_s_amt.value = parseDecimal(innSot);
	fm.dtire_v_amt.value = parseDecimal(innVot);
	
	fm.dtire_amt.value = parseDecimal(innTot);
	}
	function Keyvalue2() {//1~6번 금액 = 공급가 타이어휠빼고
	
	var fm   = document.form1;
	var innSot = 0;
	
	innSot = toInt(parseDigit(fm.dtire_item_s_amt1.value))+toInt(parseDigit(fm.dtire_item_s_amt2.value))+toInt(parseDigit(fm.dtire_item_s_amt3.value))+toInt(parseDigit(fm.dtire_item_s_amt4.value))+toInt(parseDigit(fm.dtire_item_s_amt5.value))+toInt(parseDigit(fm.dtire_item_s_amt6.value));
	fm.dtire_s_amt.value = parseDecimal(innSot);
	}
	
	function Keyvalue3() {//1~6번 금액 = 공급가 타이어휠빼고
	
	var fm   = document.form1;
	innTot = toInt(parseDigit(fm.dtire_s_amt.value))+toInt(parseDigit(fm.dtire_v_amt.value));
	
	fm.dtire_amt.value = parseDecimal(innTot);
	}
	function Keyvalue4(enumb) {//1~6번 금액 = 공급가 타이어휠만
	
	var fm_element = document.getElementsByName("dtire_item_t_amt"+enumb)[0];
	var fm_element2 = document.getElementsByName("dtire_item_s_amt"+enumb)[0];
	var fm_element3 = document.getElementsByName("dtire_item_v_amt"+enumb)[0];
	fm_element.value= parseDecimal(toInt(parseDigit(fm_element2.value))+toInt(parseDigit(fm_element3.value)));
	}
	//장기고객조회하기
	function Rent_search(){
		var fm = document.form1;	
		var t_wd;
    	window.open("./rent_search.jsp?t_wd="+fm.dtire_carno.value, "RENT_search", "left=350, top=150, width=600, height=400, scrollbars=yes");			    
	}
	function Accid_search(){
		var fm = document.form1;	
		var t_wd;
    	window.open("./accid_search.jsp?t_wd="+fm.dtire_carno.value, "RENT_search", "top=150, width=1400, height=400, scrollbars=yes");			    
	}
	
	function itemAmt(){
	var fm = document.form1;
	var cnt = toInt(fm.dtire_item_su1.value);
	var danga =toInt(fm.dtire_item_amt1.value) ;

	var r_dc1 = toInt(cnt * danga * (toInt(fm.r_dc_per.value)/100));
	var r_dc2 = toInt(danga * (toInt(fm.r_dc_per.value)/100));
	var s_amt = toInt((cnt * danga - r_dc1 ) / 1.1);
	var s_amt2 = toInt((danga - r_dc2 ) / 1.1);
	var v_amt = cnt * danga - r_dc1 - s_amt;

	fm.dtire_price.value = parseDecimal(s_amt2);
	fm.dtire_item_t_amt1.value = parseDecimal(cnt * danga -  r_dc1);
	fm.dtire_item_v_amt1.value = parseDecimal(v_amt);
	fm.dtire_item_s_amt1.value = parseDecimal(s_amt);
	}
	
	function itemAmt2(idx){
		var fm = document.form1;
		var danga = toInt(parseDigit(fm.dtire_item_amt2.value));
		var v_amt = toInt(danga / 1.1) ;
		
		fm.dtire_price2.value = parseDecimal(v_amt);
		fm.dtire_item_t_amt2.value = parseDecimal(danga);
		fm.dtire_item_v_amt2.value = parseDecimal(danga - v_amt);
		fm.dtire_item_s_amt2.value = parseDecimal(v_amt) ;
		fm.dtire_item_amt2.value = parseDecimal(danga);
	}
	
		function itemAmt3(idx){
		var fm = document.form1;
		var danga =  toInt(parseDigit(fm.dtire_item_amt3.value));
		var v_amt =  toInt(danga / 1.1);
		
		fm.dtire_price3.value = parseDecimal(v_amt);
		fm.dtire_item_t_amt3.value = parseDecimal(danga);
		fm.dtire_item_v_amt3.value = parseDecimal(danga -  v_amt);
		fm.dtire_item_s_amt3.value = parseDecimal(v_amt) ;
		fm.dtire_item_amt3.value = parseDecimal(danga);
	}
	
		function itemAmt4(idx){
		var fm = document.form1;
		var danga = toInt(parseDigit(fm.dtire_item_amt4.value));
		var v_amt = toInt(danga / 1.1);
		
		fm.dtire_price4.value = parseDecimal(v_amt);
		fm.dtire_item_t_amt4.value = parseDecimal(danga);
		fm.dtire_item_v_amt4.value = parseDecimal(danga - v_amt);
		fm.dtire_item_s_amt4.value = parseDecimal(v_amt) ;
		fm.dtire_item_amt4.value = parseDecimal(danga);
	}
	
		function itemAmt5(idx){
		var fm = document.form1;
		var danga = toInt(parseDigit(fm.dtire_item_amt5.value));
		var v_amt = toInt(danga / 1.1);
		
		fm.dtire_price5.value = parseDecimal(v_amt);
		fm.dtire_item_t_amt5.value = parseDecimal(danga);
		fm.dtire_item_v_amt5.value = parseDecimal(danga - v_amt);
		fm.dtire_item_s_amt5.value = parseDecimal(v_amt) ;
		fm.dtire_item_amt5.value = parseDecimal(danga);
	}
	
		function itemAmt6(idx){
		var fm = document.form1;
		var danga = toInt(parseDigit(fm.dtire_item_amt6.value));
		var v_amt = toInt(danga / 1.1);

		fm.dtire_price6.value = parseDecimal(v_amt);
		fm.dtire_item_t_amt6.value = parseDecimal(danga);
		fm.dtire_item_v_amt6.value = parseDecimal(danga - v_amt);
		fm.dtire_item_s_amt6.value = parseDecimal(v_amt) ;
		fm.dtire_item_amt6.value = parseDecimal(danga);
	}



//-->
</script> 
<style type="text/css">
<!--
.style1 {color: #666666}
-->
</style>
</head>
<body leftmargin="15" >
<form action='' name="form1" method='post'>
  <input type='hidden' name='auth_rw' 	value='<%=auth_rw%>'>
  <input type='hidden' name='user_id' 	value='<%=user_id%>'>
  <input type='hidden' name='br_id' 	value='<%=br_id%>'>
  <input type='hidden' name='s_kd'  	value='<%=s_kd%>'>
  <input type='hidden' name='t_wd' 		value='<%=t_wd%>'>			
  <input type='hidden' name='andor'	 	value='<%=andor%>'>
  <input type='hidden' name='gubun1' 	value='<%=gubun1%>'>  
  <input type='hidden' name='gubun2' 	value='<%=gubun2%>'> 
  <input type='hidden' name='gubun3' 	value='<%=gubun3%>'>       
  <input type='hidden' name='st_dt' 	value='<%=st_dt%>'>  
  <input type='hidden' name='end_dt' 	value='<%=end_dt%>'>        
  <input type='hidden' name='sort' 		value='<%=sort%>'>
  <input type='hidden' name='sh_height' value='<%=sh_height%>'>
  <input type='hidden' name='seq' 	value='<%=String.valueOf(ht.get("SEQ"))%>'>
  <input type='hidden' name='from_page' value='<%=from_page%>'>    
  <input type='hidden' name='mode' 		value='<%=mode%>'>      
	<input type='hidden' name='cmd' 		value=''>  
	<input type='hidden' name='tire_gubun' value='<%=tire_gubun%>'>  

  <input type='hidden' name='c_id' 		value='<%=String.valueOf(ht.get("CAR_MNG_ID"))%>'>  
  <input type='hidden' name='serv_id' 	value='<%=String.valueOf(ht.get("SERV_ID"))%>'>  
  <input type='hidden' name='dtire_price' 		value=''>  
  <input type='hidden' name='dtire_price2' 		value=''>
  <input type='hidden' name='dtire_price3' 		value=''>
  <input type='hidden' name='dtire_price4' 		value=''>
  <input type='hidden' name='dtire_price5' 		value=''>
  <input type='hidden' name='dtire_price6' 		value=''>
  
<table border='0' cellspacing='0' cellpadding='0' width='100%'>
	<tr>
    	<td colspan=10>
    	    <table width=100% border=0 cellpadding=0 cellspacing=0>
                <tr>
                    <td width=7><img src=/acar/images/center/menu_bar_1.gif width=7 height=33></td>
                    <td class=bar>&nbsp;&nbsp;&nbsp;<img src=/acar/images/center/menu_bar_dot.gif width=4 height=5 align=absmiddle>&nbsp;<span class=style1>정비관리 > 거래등록 > <span class=style5> <%=title%> 정비내역 
					<%if(seq.equals("")){%>등록<%}else{%>수정<%}%></span></span></td>
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
        <td class='line'> 
            <table border="0" cellspacing="1" cellpadding="0" width=100%>
                <tr> 
                    <td width='20%' class='title'>정비일자</td>
                    <td width='80%' colspan="3">&nbsp;
        			  <input type='text' name="dtire_dt" value='<%=AddUtil.ChangeDate2(String.valueOf(ht.get("DTIRE_DT")))%>' size='12' class='text' onBlur='javascript:this.value=ChangeDate(this.value)'>&nbsp;&nbsp;
					  <input type='radio' name="date_type" value='1'  onClick="javascript:date_type_input(1)">오늘
						<input type='radio' name="date_type" value='2'  onClick="javascript:date_type_input(2)">어제
						<input type='radio' name="date_type" value='3'  onClick="javascript:date_type_input(3)">그제
        			</td>
				</tr>
				<tr>
					<td width='20%' class='title'>차량번호</td>
                    <td width='80%' colspan="3">&nbsp;
						<input type='text' name="dtire_carno" value='<%=ht.get("DTIRE_CARNO")%>' size='20' class='text' >&nbsp;<a href="javascript:Rent_search();"><img src=/acar/images/center/button_in_search1.gif border=0 align=absmiddle></a>
					<input type='hidden' name='car_mng_id' 		value=''> <input type='hidden' name='rent_mng_id' 		value=''>   
					<input type='hidden' name='rent_l_cd' 		value='<%=String.valueOf(ht.get("RENT_L_CD"))%>'>    &nbsp; <font color="red">※차량번호를 검색하여 등록하시기 바랍니다.</font>
        			</td>
				</tr>
				<tr>
					<td width='20%' class='title'>차종</td>
                    <td width='80%' colspan="3">&nbsp;
						<input type='text' name="dtire_carnm" value='<%=ht.get("DTIRE_CARNM")%>' size='20' class='text' >
        			</td>
				</tr>
				<%if(ht.get("DTIRE_GB").equals("2")){%>
					<tr>
						<td width='20%' class='title'>사고번호</td>
		    		 <td width='80%' colspan="3">&nbsp; 
		    		 		<input type='text' name="accid_id" value='' size='20' class='text' >
		    		 		<input type='hidden' name='accid_check' 		value=''>
		    		 	<a href="javascript:Accid_search();"><img src=/acar/images/center/button_in_sgdr.gif border=0 align=absmiddle></a>
		    		 	</td>
					</tr>
				<%}%>
				<tr>
					<td width='2%' class='title'>주행거리</td>
                    <td width='80%' colspan="3">&nbsp;
						<input type='text' name="dtire_km" value='<%=ht.get("DTIRE_KM")%>' size='20' class='text' >&nbsp;km  
        			</td>
				</tr>
				<tr>
					<td width='20%' class='title'>정비구분</td>
                    <td width='80%' colspan="3">&nbsp;
						<input type="radio" name="dtire_gb" value="1" <%if(ht.get("DTIRE_GB").equals("1")){%> checked <%}%>>일반정비&nbsp;
						<input type="radio" name="dtire_gb" value="2" <%if(ht.get("DTIRE_GB").equals("2")){%> checked <%}%>>사고수리&nbsp;
						<input type="radio" name="dtire_gb" value="3" <%if(ht.get("DTIRE_GB").equals("3")){%> checked <%}%>>재리스정비&nbsp;
        			</td>
                </tr>					
                <tr> 
                    <td width='20%' class='title'>담당자</td>
                    <td width='80%' colspan="3">&nbsp;
        			  <select name='req_nm'>
                        <option value="">선택</option>
                        <%	if(user_size > 0){
        						for(int i = 0 ; i < user_size ; i++){
        							Hashtable user = (Hashtable)users.elementAt(i); %>
                        <option value='<%=user.get("USER_ID")%>' <%if(ht.get("REQ_NM").equals(user.get("USER_ID"))){%>selected<%}%>><%=user.get("USER_NM")%></option>
                        <%		}
        					}%>
                      </select>
        			</td>
				</tr>
			</table>
        </td>
    </tr>
	<tr> 
        <td class='line'> 
            <table border="0" cellspacing="1" cellpadding="0" width=100%>			
				<tr>
					<td width='5%' class='title'>연번</td>
                	<td width='12%' align="" class='title'>품목</td>	
					<td width='18%' class='title'>내역</td>
					<td width='5%' class='title'>수량</td>
					<td width='12%' align="" class='title'>단가</td>
					<td width='12%' align="" class='title'>DC</td>
					<td width='12%' align="" class='title'>공급가액</td>	
					<td width='12%' align="" class='title'>VAT</td>
					<td width='12%' align="" class='title'>최종금액</td>
                </tr>
				<tr>
					<td width='' class='title'>1</td>
                	<td width='' align="" class='title'>타이어</td>	
					<td width='' class=''><input type='text' name="dtire_item1" value='<%=ht.get("DTIRE_ITEM1")%>' size='30' class='text' ></td>
                	<td width='' align=""><input type='text' name="dtire_item_su1" value='<%=ht.get("DTIRE_ITEM_SU1")%>' size='4' class='num' <%if(!tire_gubun.equals("000256")){%>onBlur="javascript:itemAmt();Keyvalue1();"<%}%>></td>	
					<td width='' align="right"  style="padding-right:5;"><input type='text' name="dtire_item_amt1" value='<%=ht.get("DTIRE_ITEM_AMT1")%>' size='10' class='num' <%if(!tire_gubun.equals("000256")){%>onBlur="javascript:itemAmt();Keyvalue1();"<%}%>>원</td>	
					<td width='' align="center"  >
					
						<%
							if(AddUtil.parseInt(String.valueOf(ht.get("DTIRE_DT") )) >=20220401    ){%>
						<select name="r_dc_per" onChange="javascript:itemAmt();Keyvalue1();" <%if(!tire_gubun.equals("000256")){%>disabled<%}%>>
								<option value="0" <%if(ht.get("DC").equals("")){%> selected <%}%> >DC 선택</option>
								<option value="42%" <%if(ht.get("DC").equals("42%") ){%> selected <%}%>>42%</option>
								<option value="28%" <%if(ht.get("DC").equals("28%") ){%> selected <%}%>>28%</option>																						
						</select>						
						<%
							}else if(AddUtil.parseInt(String.valueOf(ht.get("DTIRE_DT") )) >=20210501  &&  AddUtil.parseInt(String.valueOf(ht.get("DTIRE_DT") ))  < 20220401    ){%>
						<select name="r_dc_per" onChange="javascript:itemAmt();Keyvalue1();" <%if(!tire_gubun.equals("000256")){%>disabled<%}%>>
								<option value="0" <%if(ht.get("DC").equals("")){%> selected <%}%> >DC 선택</option>
								<option value="27%" <%if(ht.get("DC").equals("27%") ){%> selected <%}%>>27%</option>
								<option value="14%" <%if(ht.get("DC").equals("14%") ){%> selected <%}%>>14%</option>																						
						</select>						
					
						<%
							}else if(AddUtil.parseInt(String.valueOf(ht.get("DTIRE_DT") )) >=20170501  &&  AddUtil.parseInt(String.valueOf(ht.get("DTIRE_DT") ))  < 20210501    ){%>
						<select name="r_dc_per" onChange="javascript:itemAmt();Keyvalue1();" <%if(!tire_gubun.equals("000256")){%>disabled<%}%>>
								<option value="0" <%if(ht.get("DC").equals("")){%> selected <%}%> >DC 선택</option>
								<option value="52%" <%if(ht.get("DC").equals("52%")   ){%> selected <%}%>>UHP 52%</option>
								<option value="40%" <%if(ht.get("DC").equals("40%") ){%> selected <%}%>>60/65 40%</option>
								<option value="35%" <%if(ht.get("DC").equals("35%") ){%> selected <%}%>>70 35%</option>
								<option value="25%" <%if(ht.get("DC").equals("25%")  ){%> selected <%}%>>기타 25%</option>						
						</select>
						<%} else if (AddUtil.parseInt(String.valueOf(ht.get("DTIRE_DT") )) >=20170216  &&  AddUtil.parseInt(String.valueOf(ht.get("DTIRE_DT") ))  < 20170501  ){%>
						<select name="r_dc_per" onChange="javascript:itemAmt();Keyvalue1();" <%if(!tire_gubun.equals("000256")){%>disabled<%}%>>
								<option value="0" <%if(ht.get("DC").equals("")){%> selected <%}%> >DC 선택</option>
								<option value="50%" <%if(ht.get("DC").equals("50%")   ){%> selected <%}%>>UHP 50%</option>
								<option value="38%" <%if(ht.get("DC").equals("38%") ){%> selected <%}%>>60/65 38%</option>
								<option value="33%" <%if(ht.get("DC").equals("33%") ){%> selected <%}%>>70 33%</option>
								<option value="25%" <%if(ht.get("DC").equals("25%")  ){%> selected <%}%>>기타 25%</option>						
						</select>
						<%} else{%>						
						<select name="r_dc_per" onChange="javascript:itemAmt();Keyvalue1();" <%if(!tire_gubun.equals("000256")){%>disabled<%}%>>
								<option value="0" <%if(ht.get("DC").equals("")){%> selected <%}%> >DC 선택</option>
								<option value="55%" <%if(ht.get("DC").equals("55%")){%> selected <%}%>>UHP 55%</option>
								<option value="43%" <%if(ht.get("DC").equals("43%")){%> selected <%}%>>60/65 43%</option>
								<option value="38%" <%if(ht.get("DC").equals("38%")){%> selected <%}%>>70 38%</option>
								<option value="30%" <%if(ht.get("DC").equals("30%")){%> selected <%}%>>기타 30%</option>
						</select>						
						<%}%>
					</td>	
					<td width='' align="right"  style="padding-right:5;">
						<input type='text' name="dtire_item_s_amt1" value='<%=AddUtil.parseDecimal(String.valueOf(ht.get("DTIRE_ITEM_S_AMT1")))%>' size='10' class='num' onBlur="javascript:Keyvalue4(1);Keyvalue1();">원</td>	
					<td width='' align="right"  style="padding-right:5;">
						<input type='text' name="dtire_item_v_amt1" value='<%=AddUtil.parseDecimal(String.valueOf(ht.get("DTIRE_ITEM_V_AMT1")))%>' size='10' class='num' onBlur="javascript:Keyvalue4(1);Keyvalue1();">원</td>	
					<td width='' align="right"  style="padding-right:5; ">
						<input type='text' name="dtire_item_t_amt1" value='<%=AddUtil.parseDecimal(String.valueOf(ht.get("DTIRE_ITEM_T_AMT1")))%>' size='10' class='num' onBlur='javascript:this.value=parseDecimal(this.value); Keyvalue1(); '  readonly >원</td>	
                </tr>
				<tr>
					<td width='' class='title'>2</td>
                	<td width='' align="" class='title'>휠얼라이먼트</td>	
					<td width='' class=''><input type='text' name="dtire_item2" value='<%=ht.get("DTIRE_ITEM2")%>' size='30' class='text' ></td>
					<td width='' align="center" >1</td>
					<td width='' align="right"  style="padding-right:5; ">
						<input type='text' name="dtire_item_amt2" value='<%=ht.get("DTIRE_ITEM_AMT2")%>' size='10' class='num' onBlur="javascript:itemAmt2('2'); Keyvalue();  Keyvalue1();">원</td>	
					<td width='' align="center" ></td>
					<td width='' align="right"  style="padding-right:5;">
						<input type='text' name="dtire_item_s_amt2" value='<%=AddUtil.parseDecimal(String.valueOf(ht.get("DTIRE_ITEM_S_AMT2")))%>' size='10' class='num' onBlur="javascript:Keyvalue4(2);Keyvalue1();" >원</td>	
					<td width='' align="right"  style="padding-right:5; ">
						<input type='text' name="dtire_item_v_amt2" value='<%=AddUtil.parseDecimal(String.valueOf(ht.get("DTIRE_ITEM_V_AMT2")))%>' size='10' class='num' onBlur="javascript:Keyvalue4(2);Keyvalue1();">원</td>	
                	<td width='' align="right"  style="padding-right:5; ">
						<input type='text' name="dtire_item_t_amt2" value='<%=AddUtil.parseDecimal(String.valueOf(ht.get("DTIRE_ITEM_T_AMT2")))%>' size='10' class='num' onBlur='javascript:this.value=parseDecimal(this.value); Keyvalue1(); '  readonly >원</td>	
                </tr>			
				<tr>
					<td width='' class='title'>3</td>
                	<td width='' align="" class='title'>엔진오일</td>	
					<td width='' class=''><input type='text' name="dtire_item3" value='<%=ht.get("DTIRE_ITEM3")%>' size='30' class='text' ></td>
					<td width='' align="center" >1</td>
					<td width='' align="right"  style="padding-right:5; ">
						<input type='text' name="dtire_item_amt3" value='<%=ht.get("DTIRE_ITEM_AMT3")%>' size='10' class='num' onBlur="javascript:itemAmt3('3'); Keyvalue();  Keyvalue1();">원</td>	
					<td width='' align="center" ></td>
					<td width='' align="right"  style="padding-right:5;">
						<input type='text' name="dtire_item_s_amt3" value='<%=AddUtil.parseDecimal(String.valueOf(ht.get("DTIRE_ITEM_S_AMT3")))%>' size='10' class='num' onBlur="javascript:Keyvalue4(3);Keyvalue1();" >원</td>
					<td width='' align="right"  style="padding-right:5;">
						<input type='text' name="dtire_item_v_amt3" value='<%=AddUtil.parseDecimal(String.valueOf(ht.get("DTIRE_ITEM_V_AMT3")))%>' size='10' class='num' onBlur="javascript:Keyvalue4(3);Keyvalue1();" >원</td>	
					<td width='' align="right"  style="padding-right:5; ">
						<input type='text' name="dtire_item_t_amt3" value='<%=AddUtil.parseDecimal(String.valueOf(ht.get("DTIRE_ITEM_T_AMT3")))%>' size='10' class='num' onBlur='javascript:this.value=parseDecimal(this.value); Keyvalue1(); '  readonly >원</td>	
                </tr>			
				<tr>
					<td width='' class='title'>4</td>
                	<td width='' align="" class='title' >윈도우브러쉬</td>	
					<td width='' class=''><input type='text' name="dtire_item4" value='<%=ht.get("DTIRE_ITEM4")%>' size='30' class='text' ></td>
					<td width='' align="center" >1</td>
					<td width='' align="right"  style="padding-right:5; ">
						<input type='text' name="dtire_item_amt4" value='<%=ht.get("DTIRE_ITEM_AMT4")%>' size='10' class='num' onBlur="javascript:itemAmt4('4'); Keyvalue();  Keyvalue1();">원</td>	
					<td width='' align="center" ></td>
                	<td width='' align="right"  style="padding-right:5;">
						<input type='text' name="dtire_item_s_amt4" value='<%=AddUtil.parseDecimal(String.valueOf(ht.get("DTIRE_ITEM_S_AMT4")))%>' size='10' class='num' onBlur="javascript:Keyvalue4(4);Keyvalue1();" >원</td>	
					<td width='' align="right"  style="padding-right:5; ">
						<input type='text' name="dtire_item_v_amt4" value='<%=AddUtil.parseDecimal(String.valueOf(ht.get("DTIRE_ITEM_V_AMT4")))%>' size='10' class='num' onBlur="javascript:Keyvalue4(4);Keyvalue1();">원</td>	
					<td width='' align="right"  style="padding-right:5; ">
						<input type='text' name="dtire_item_t_amt4" value='<%=AddUtil.parseDecimal(String.valueOf(ht.get("DTIRE_ITEM_T_AMT4")))%>' size='10' class='num' onBlur='javascript:this.value=parseDecimal(this.value); Keyvalue1(); '  readonly >원</td>	
                </tr>
				<tr>
					<td width='' class='title'>5</td>
                	<td width='' align="" class='title'>브레이크라이닝</td>	
					<td width='' class=''><input type='text' name="dtire_item5" value='<%=ht.get("DTIRE_ITEM5")%>' size='30' class='text' ></td>
					<td width='' align="center" >1</td>
					<td width='' align="right"  style="padding-right:5; ">
						<input type='text' name="dtire_item_amt5" value='<%=ht.get("DTIRE_ITEM_AMT5")%>' size='10' class='num' onBlur="javascript:itemAmt5('5'); Keyvalue();  Keyvalue1();">원</td>	
					<td width='' align="center"  ></td>
                	<td width='' align="right"  style="padding-right:5;">
						<input type='text' name="dtire_item_s_amt5" value='<%=AddUtil.parseDecimal(String.valueOf(ht.get("DTIRE_ITEM_S_AMT5")))%>' size='10' class='num' onBlur="javascript:Keyvalue4(5);Keyvalue1();" >원</td>
					<td width='' align="right"  style="padding-right:5; ">
						<input type='text' name="dtire_item_v_amt5" value='<%=AddUtil.parseDecimal(String.valueOf(ht.get("DTIRE_ITEM_V_AMT5")))%>' size='10' class='num' onBlur="javascript:Keyvalue4(5);Keyvalue1();">원</td>
					<td width='' align="right"  style="padding-right:5;">
						<input type='text' name="dtire_item_t_amt5" value='<%=AddUtil.parseDecimal(String.valueOf(ht.get("DTIRE_ITEM_T_AMT5")))%>' size='10' class='num' onBlur='javascript:this.value=parseDecimal(this.value); Keyvalue1(); '  readonly >원</td>	
                </tr>				
				<tr>
					<td width='' class='title'>6</td>
                	<td width='' align="" class='title'>기타정비</td>	
					<td width='' class=''><input type='text' name="dtire_item6" value='<%=ht.get("DTIRE_ITEM6")%>' size='30' class='text' ></td>
					<td width='' align="center" >1</td>
					<td width='' align="right"  style="padding-right:5;">
						<input type='text' name="dtire_item_amt6" value='<%=ht.get("DTIRE_ITEM_AMT6")%>' size='10' class='num' onBlur="javascript:itemAmt6('6'); Keyvalue();  Keyvalue1();">원</td>	
					<td width='' align="center" ></td>
					<td width='' align="right"  style="padding-right:5;">
						<input type='text' name="dtire_item_s_amt6" value='<%=AddUtil.parseDecimal(String.valueOf(ht.get("DTIRE_ITEM_S_AMT6")))%>' size='10' class='num' onBlur="javascript:Keyvalue4(6);Keyvalue1();" >원</td>	
					<td width='' align="right"  style="padding-right:5; ">
						<input type='text' name="dtire_item_v_amt6" value='<%=AddUtil.parseDecimal(String.valueOf(ht.get("DTIRE_ITEM_V_AMT6")))%>' size='10' class='num' onBlur="javascript:Keyvalue4(6);Keyvalue1();">원</td>	                	  	
					<td width='' align="right"  style="padding-right:5; ">
						<input type='text' name="dtire_item_t_amt6" value='<%=AddUtil.parseDecimal(String.valueOf(ht.get("DTIRE_ITEM_T_AMT6")))%>' size='10' class='num' onBlur='javascript:this.value=parseDecimal(this.value); Keyvalue1(); ' readonly >원</td>	
                </tr>

				<tr>
					<td width='' class='title' colspan="6">합계</td>
                	<td width='' align="right" style="padding-right:5;">
										<input type='text' name="dtire_s_amt" data-mini="true" size='10' value='<%=AddUtil.parseDecimal(String.valueOf(ht.get("DTIRE_S_AMT")))%>'  class='num' onBlur='javascript:this.value=parseDecimal(this.value); '  readonly >원 </td>	
        
				
				
                	<td width='' align="right" style="padding-right:5;">
											<input type='text' name="dtire_v_amt" data-mini="true" size='10' value='<%=AddUtil.parseDecimal(String.valueOf(ht.get("DTIRE_V_AMT")))%>' class='num' onBlur='javascript:this.value=parseDecimal(this.value); '  readonly >원 </td>	
            
	
			
                	<td width=''  align="right" style="padding-right:5;">
						<input type='text' name="dtire_amt" data-mini="true" size='10' value='<%=AddUtil.parseDecimal(String.valueOf(ht.get("DTIRE_AMT")))%>' class='num' readonly>원 </td>	
              		
				</tr>
				<tr>
			
                    <td colspan="2" class='title'>특이사항</td>
                    <td width='' colspan="7" align="center">
						<textarea rows='5' name='dtire_note' cols='130' maxlength='2000' style='IME-MODE: active' ><%=ht.get("DTIRE_NOTE")%></textarea>
					</td>	
               
				
            </table>
        </td>
    </tr>


	<tr>
	    <td> <font color='red'>※정비내역을 반드시 입력하여 주시기 바랍니다. 한 건 이라도 누락시 월 정산결재가 지연됩니다.</font></td>
	</tr>	
	
	<tr>
	    <td align="right">
		<%if(s_cnt.equals("0")&&!cmd.equals("nothing")){%>
			<a id="submitLink" href="javascript:window.save('RN');" onMouseOver="window.status=''; return true"><img src="/acar/images/center/button_reg.gif"  border="0" align=absmiddle></a>&nbsp;&nbsp;&nbsp;
		<%}%>
			<%if(nm_db.getWorkAuthUser("전산팀",user_id) || nm_db.getWorkAuthUser("협력업체담당",user_id)){%>
			<a href="javascript:tire_reg_off_del()" onMouseOver="window.status=''; return true"><img src="/acar/images/center/button_delete.gif"  aligh="absmiddle" border="0"></a>
			<%}%>
		</td>
	</tr>		

</table>
</form>
<iframe src="about:blank" name="i_no" width="0" height="0" frameborder="0" noresize></iframe>
<script language="JavaScript">
<!--	
<% if(AddUtil.parseInt(String.valueOf(ht.get("DTIRE_DT") )) >=20170216   && tire_gubun.equals("000256") ){%>
		itemAmt();Keyvalue1();
<%}%>
//-->
</script>
</body>
</html>