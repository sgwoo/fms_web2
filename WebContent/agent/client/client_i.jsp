<%@ page language="java" contentType="text/html;charset=euc-kr" %>
<%@ page import="java.util.*"%>
<%@ page import="acar.util.*"%>
<%@ include file="/agent/cookies.jsp" %>

<%
	
	String auth_rw = request.getParameter("auth_rw")==null?"":request.getParameter("auth_rw");
	String br_id = request.getParameter("br_id")==null?"":request.getParameter("br_id");
	String user_id = request.getParameter("user_id")==null?"":request.getParameter("user_id");
	
	String s_kd = request.getParameter("s_kd")==null?"":request.getParameter("s_kd");
	String t_wd = request.getParameter("t_wd")==null?"":request.getParameter("t_wd");
	String asc = request.getParameter("asc")==null?"0":request.getParameter("asc");
	String from_page = request.getParameter("from_page")==null?"":request.getParameter("from_page");  //popup 요청한 페이지
	
	//로그인ID&영업소ID
	LoginBean login = LoginBean.getInstance();
	if(user_id.equals("")) 	user_id = login.getCookieValue(request, "acar_id");
	if(br_id.equals(""))	br_id = login.getCookieValue(request, "acar_br");
%>

<html>
<head><title>FMS</title>
<meta http-equiv="Content-Type" content="text/html; charset=euc-kr">
<script language='javascript' src='../../include/common.js'></script>
<script language='javascript'>
<!--
//불량고객 
function view_badcust()
{
	var fm = document.form1;
	if ( fm.client_st.value == '1' || fm.client_st.value == '6' ) {//법인
		if(fm.firm_nm[0].value == '')				{	alert('상호를 입력하십시오');				return;	}
		if(fm.client_nm[0].value == '')				{	alert('대표자를 입력하십시오');			return;	}
	} else if ( fm.client_st.value == '2' ) {//개인
		if(fm.firm_nm[2].value == '')				{	alert('성명을 입력하십시오');				return;	}
  	} else {		
		if(fm.firm_nm[1].value == '')				{	alert('상호를 입력하십시오');				return;	}
		if(fm.client_nm[1].value == '')				{	alert('대표자를 입력하십시오');			return;	}
		if(fm.ssn1[1].value == '')					{	alert('생년월일을 입력하십시오');			return;	}		
	}
	window.open("about:blank", "BAD_CUST_LIST", "resizable=no,  scrollbars=yes, status=yes, left=50,top=20, width=1400px, height=900px");
	fm.target="BAD_CUST_LIST";
	fm.action = "/acar/bad_cust/stat_badcust_list.jsp"; 
	fm.submit();
	return;
}	

	function save()
	{
					
			var fm = document.form1;
			
			if(fm.badcust_chk.value == ''){
				//alert('불량고객 확인을 하십시오.'); 	return;				
			}		
				
			if ( fm.client_st.value == '1' || fm.client_st.value == '6' ) {		//법인
			
				if(fm.firm_nm[0].value == ''){					alert('상호를 입력하십시오');				return;	}
				if(fm.client_nm[0].value == ''){				alert('대표자를 입력하십시오');				return;	}
				
				if ( fm.firm_type.value == '6' || fm.firm_type.value == '7' || fm.firm_type.value == '8' || fm.firm_type.value == '9' || fm.firm_type.value == '10' || fm.firm_type.value == '11' ) {	//국가,지방자치,정부투자기관,정부연구기관,비영리
					//법인번호가 없는 법인형태일때에는 법인번호 입력못하게 (20191008)
					if(fm.ssn1[0].value!=''||fm.ssn2[0].value!='')	{	alert('법인번호가 없는 법인형태입니다.\n\n법인번호는 입력하지말고, 운전면허번호를 입력해주세요.');	fm.ssn1[0].value="";	fm.ssn2[0].value=""; 	return;	}
				}else{
				
					if(fm.ssn1[0].value == '')				{	alert('주민등록번호(법인번호)를 입력하십시오');		return;	}
					if(fm.ssn2[0].value == '')				{	alert('주민등록번호(법인번호)를 입력하십시오');		return;	}						
					if((!isNum(fm.ssn1[0].value)) || (!isNum(fm.ssn2[0].value)) || ((fm.ssn1[0].value.length != 6)&&(fm.ssn1[0].value.length != 0)))	{	alert('주민등록번호(법인번호)를 확인하십시오');	return;	} // || ((fm.ssn2[0].value.length != 7)&&(fm.ssn2[0].value.length != 0))
				}
				
				if(fm.enp_no1[0].value == '')				{	alert('사업자등록번호를 입력하십시오');			return;	}
				if(fm.enp_no2[0].value == '')				{	alert('사업자등록번호를 입력하십시오');			return;	}
				if(fm.enp_no3[0].value == '')				{	alert('사업자등록번호를 입력하십시오');			return;	}							
				if((!isNum(fm.enp_no1[0].value)) || (!isNum(fm.enp_no2[0].value)) || (!isNum(fm.enp_no3[0].value))|| ((fm.enp_no1[0].value.length != 3)&&(fm.enp_no1[0].value.length != 0)) || ((fm.enp_no2[0].value.length != 2)&&(fm.enp_no2[0].value.length != 0)) || ((fm.enp_no3[0].value.length != 5)&&(fm.enp_no3[0].value.length != 0)))	{	alert('사업자등록번호를 확인하십시오');	return;	}
				
				CheckBizNo();
				
				if(!isTel(fm.o_tel[0].value))	{			alert('회사전화번호를 확인하십시오');				return;	}
				if(!isTel(fm.fax[0].value))	{				alert('팩스번호를 확인하십시오');					return;	}
				
				if(fm.o_tel[0].value == '' || fm.o_tel[0].value.length < 7){				alert('회사전화번호를 입력하십시오');				return;	}
				
				if(fm.t_zip[0].value == '' || fm.t_addr[0].value == ''){
					alert('사업장주소 우편번호 검색하십시오.');
				}
				if(fm.t_addr_sub[0].value == ''){
					alert('사업장주소 상세주소를 입력하십시오.');
				}
								
					
			} else if ( fm.client_st.value == '2' ) {		//개인
			
				if(fm.firm_nm[2].value == '')				{	alert('성명을 입력하십시오');				return;	}
				
				//주민번호 앞자리 확인 (6자리)
				if( parseInt(fm.ssn1[2].value.substring(0,2)) == 19 || parseInt(fm.ssn1[2].value.substring(0,2)) == 20 ){
					alert("주민등록번호 앞자리는 생년월일 6자리만 입력하십시오."); return;
				}
			
				Biz_ck (); //주민번호 체크
				if(fm.firm_nm[2].value == '')				{	alert('성명을 입력하십시오');				return;	}
				if(fm.ssn1[2].value == '')				{	alert('주민등록번호를 입력하십시오');			return;	}
				if(fm.ssn2[2].value == '')				{	alert('주민등록번호를 입력하십시오');			return;	}
				if(fm.ssn2[2].value == '*')				{	alert('주민등록번호를 입력하십시오');			return;	}
				if(fm.ssn2[2].value == '1')				{	alert('주민등록번호를 입력하십시오');			return;	}
				if(fm.ssn2[2].value == '2')				{	alert('주민등록번호를 입력하십시오');			return;	}
				if(fm.ssn2[2].value == '3')				{	alert('주민등록번호를 입력하십시오');			return;	}
				if(fm.ssn2[2].value == '4')				{	alert('주민등록번호를 입력하십시오');			return;	}
				if(fm.ssn2[2].value == '*******')			{	alert('주민등록번호를 입력하십시오');			return;	}
				if(fm.ssn2[2].value == '1******')			{	alert('주민등록번호를 입력하십시오');			return;	}
				if(fm.ssn2[2].value == '2******')			{	alert('주민등록번호를 입력하십시오');			return;	}
				if(fm.ssn2[2].value == '3******')			{	alert('주민등록번호를 입력하십시오');			return;	}
				if(fm.ssn2[2].value == '4******')			{	alert('주민등록번호를 입력하십시오');			return;	}
				if((!isNum(fm.ssn1[2].value)) || (!isNum(fm.ssn2[2].value)) || ((fm.ssn1[2].value.length != 6)&&(fm.ssn1[2].value.length != 0)) || ((fm.ssn2[2].value.length != 7)&&(fm.ssn2[2].value.length != 0)))	{	alert('주민등록번호를 확인하십시오');	return;	}
				if(!isTel(fm.m_tel[2].value))				{	alert('휴대폰번호를 확인하십시오');			return;	}
				
				
				if(fm.m_tel[2].value == '' || fm.m_tel[2].value.length < 10){				alert('휴대폰번호를 입력하십시오');			return;	}
				
				if(fm.o_tel[2].value == '' && fm.h_tel[2].value == ''){							alert('회사전화번호나 자택번호를 입력하십시오');				return;	}
				if(fm.o_tel[2].value.length < 7 && fm.h_tel[2].value.length < 10){	alert('회사전화번호나 자택번호를 정확히 입력하십시오');	return;	}
				
				if(fm.t_zip[5].value == '' || fm.t_addr[5].value == ''){
					alert('자택주소 우편번호 검색하십시오.');
				}
				if(fm.t_addr_sub[2].value == ''){
					alert('자택주소 상세주소를 입력하십시오.');
				}
				
				
		  } else {		
									
				if(fm.firm_nm[1].value == ''){					alert('상호를 입력하십시오');				return;	}
				if(fm.client_nm[1].value == ''){				alert('대표자를 입력하십시오');				return;	}
				
				//20140807 개인정보보험법으로 불필요한 주민번호 수집은 안됨
				if(fm.ssn1[1].value == '')			{	alert('생년월일을 입력하십시오');		return;	}
				
				//주민번호 앞자리 확인 (6자리)
				if( parseInt(fm.ssn1[1].value.substring(0,2)) == 19 || parseInt(fm.ssn1[1].value.substring(0,2)) == 20 ){
					alert("생년월일 6자리만 입력하십시오."); return;
				}
				
				if(fm.enp_no1[1].value == '')				{	alert('사업자등록번호를 입력하십시오');			return;	}
				if(fm.enp_no2[1].value == '')				{	alert('사업자등록번호를 입력하십시오');			return;	}
				if(fm.enp_no3[1].value == '')				{	alert('사업자등록번호를 입력하십시오');			return;	}				
				if((!isNum(fm.enp_no1[1].value)) || (!isNum(fm.enp_no2[1].value)) || (!isNum(fm.enp_no3[1].value))|| ((fm.enp_no1[1].value.length != 3)&&(fm.enp_no1[1].value.length != 0)) || ((fm.enp_no2[1].value.length != 2)&&(fm.enp_no2[1].value.length != 0)) || ((fm.enp_no3[1].value.length != 5)&&(fm.enp_no3[1].value.length != 0)))	{	alert('사업자등록번호를 확인하십시오');	return;	}
				
				CheckBizNo();
				
				if(!isTel(fm.o_tel[1].value))	{				alert('회사전화번호를 확인하십시오');			return;	}
				if(!isTel(fm.fax[1].value))	{				alert('팩스번호를 확인하십시오');			return;	}
				
				if(fm.m_tel[1].value == '' || fm.m_tel[1].value.length < 10){				alert('휴대폰번호를 입력하십시오');					return;	}
				
				if(fm.o_tel[1].value == '' && fm.h_tel[1].value == ''){							alert('회사전화번호나 자택번호를 입력하십시오');				return;	}
				if(fm.o_tel[1].value.length < 7 && fm.h_tel[1].value.length < 10){	alert('회사전화번호나 자택번호를 정확히 입력하십시오');	return;	}
				
				if(fm.t_zip[3].value == '' || fm.t_addr[3].value == ''){
					alert('사업장소재지 우편번호 검색하십시오.');
				}
				if(fm.t_addr_sub[1].value == ''){
					alert('사업장소재지 상세주소를 입력하십시오.');
				}
				
			}
			
			if ( fm.client_st.value == '1' || fm.client_st.value == '6' ) {		//법인
				if(fm.ssn1[0].value=="" && fm.ssn2[0].value==""){	//법인번호가 없는 법인형태인경우에는 운전면허번호체크(20191001) 
					if(fm.lic_no.value == '' || fm.lic_no.value.length < 12){
						alert('법인번호가 없는 법인형태인 경우에는 운전면허번호를 입력하십시오.');
						return;
					}
				}
			}else{ //개인,개인사업자
				if(fm.lic_no.value == '' || fm.lic_no.value.length < 12){
					alert('개인,개인사업자는 운전면허번호를 입력하십시오.');
					return;
				}
			}
			
			if(fm.email_1.value != '' && fm.email_2.value != ''){
				fm.con_agnt_email.value = fm.email_1.value+'@'+fm.email_2.value;
			}else{
				fm.con_agnt_email.value = '';
			}
			
			if(fm.email_3.value != '' && fm.email_4.value != ''){
				fm.con_agnt_email2.value = fm.email_3.value+'@'+fm.email_4.value;
			}else{
				fm.con_agnt_email2.value = '';
			}			
						
			var email_len = fm.repre_email_1.length;
			
			for(var i=0; i<email_len; i++){
				if(fm.repre_email_1[i].value != '' && fm.repre_email_2[i].value != ''){
					fm.repre_email[i].value = fm.repre_email_1[i].value+'@'+fm.repre_email_2[i].value;
				}else{
					fm.repre_email[i].value = '';
				}
			}
			
			
							
			if(fm.con_agnt_email.value == ''){
				alert('세금계산서 담당자-이메일주소를 입력하십시오.'); return;
			}							
			
			if(fm.etc_cms.value == ''){
				alert('면책금 cms 청구여부를 입력하십시오.'); return;
			}	
			
			if(fm.fine_yn.value == ''){
				alert('선납과태료 청구여부를 입력하십시오.'); return;
			}	
			

			if(fm.print_st.value == ''){
				alert('계산서발행구분을 입력하십시오.'); return;
			}	

		if(confirm('등록하시겠습니까?'))
		{												     
			fm.action = "client_i_a.jsp";
			fm.target='i_no';
			fm.submit();
		}
	}

	function set_o_addr()
	{
		var fm = document.form1;
			
		if(fm.c_ho.checked == true)
		{
			fm.t_zip[1].value = fm.t_zip[0].value;
			fm.t_addr[1].value = fm.t_addr[0].value;
		}
		else
		{
			fm.t_zip[1].value = '';
			fm.t_addr[1].value = '';
		}
	}	
	
	function set_tax()
	{
		var fm = document.form1;
		
		if(fm.c_tax.checked == true)
		{
			if ( fm.client_st.value == '1'  || fm.client_st.value == '6' ) {		//법인
				fm.con_agnt_nm.value 	= fm.client_nm[0].value;
				fm.con_agnt_o_tel.value = fm.o_tel[0].value;
				fm.con_agnt_m_tel.value = fm.m_tel[0].value;
				fm.con_agnt_fax.value   = fm.fax[0].value;			
			} else if ( fm.client_st.value == '2' ) {		//개인
				fm.con_agnt_nm.value 	= fm.firm_nm[2].value;
				fm.con_agnt_m_tel.value = fm.m_tel[2].value;
			  } else {			
				fm.con_agnt_nm.value 	= fm.client_nm[1].value;
				fm.con_agnt_o_tel.value = fm.o_tel[1].value;
				fm.con_agnt_m_tel.value = fm.m_tel[1].value;
				fm.con_agnt_fax.value   = fm.fax[1].value;
			  }			
		}else{
			fm.con_agnt_nm.value 		= '';
			fm.con_agnt_o_tel.value 	= '';
			fm.con_agnt_m_tel.value 	= '';
			fm.con_agnt_fax.value 		= '';
		}
	}	
	
	function set_print()
	{
		var fm = document.form1;
		
		if ( fm.print_st.value == '2') {		//거래처통합
			fm.print_car_st.value 	= '1';
		}else{
			fm.print_car_st.value 	= '';
		}
	}		
	
	function go_to_list()
	{
		var fm = document.form1;
		var auth_rw = fm.auth_rw.value;
		var s_kd 	= fm.s_kd.value;
		var t_wd 	= fm.t_wd.value;
		var asc 	= fm.asc.value;
		var from_page = fm.from_page.value;		
		location='/agent/client/client_s_frame.jsp?auth_rw='+auth_rw+'&s_kd='+s_kd+'&t_wd='+t_wd+'&asc='+asc+'&from_page='+from_page;
	}	
	
	
	//디스플레이--------------------------------------------------------------------
	function cng_input(arg){
		  	    
		if(arg == '1' || arg == '6'){ 		//법인
			tr_acct1.style.display		= '';
			tr_acct2.style.display		= 'none';
			tr_acct3.style.display		= 'none';										
		} else if(arg == '2'){ 		//개인
			tr_acct1.style.display		= 'none';
			tr_acct2.style.display		= 'none';
			tr_acct3.style.display		= '';					
				
		} else { 		//개인사업자
			tr_acct1.style.display		= 'none';
			tr_acct2.style.display		= '';
			tr_acct3.style.display		= 'none';							
		}
	}	
	
	//사업자번호 다음 넘어가기
	function set_next(idx, column, next_cd){
		var fm = document.form1;
		if(idx == '0' && column == 'enp_no'    && next_cd == '1' && get_length(fm.enp_no1[0].value) == 3)   { fm.enp_no2[0].focus();   }
		if(idx == '0' && column == 'enp_no'    && next_cd == '2' && get_length(fm.enp_no2[0].value) == 2)   { fm.enp_no3[0].focus();   }
		if(idx == '0' && column == 'enp_no'    && next_cd == '3' && get_length(fm.enp_no3[0].value) == 5)   { fm.ssn1[0].focus();      }
		if(idx == '0' && column == 'ssn'       && next_cd == '1' && get_length(fm.ssn1[0].value) == 6)      { fm.ssn2[0].focus();      }
		if(idx == '0' && column == 'repre_ssn' && next_cd == '1' && get_length(fm.repre_ssn1[0].value) == 6){ fm.repre_ssn2[0].focus();}
	}	

//사업자등록번호 체크
function CheckBizNo() {
	
	var fm = document.form1;
if ( fm.client_st.value == '1' || fm.client_st.value == '6' ) {//법인
	var strNumb1 = fm.enp_no1[0].value;
    var strNumb2 = fm.enp_no2[0].value;
    var strNumb3 = fm.enp_no3[0].value;
}else if( fm.client_st.value == '2'){//개인
	var strNumb1 = fm.enp_no1[2].value;
    var strNumb2 = fm.enp_no2[2].value;
    var strNumb3 = fm.enp_no3[2].value;
}else{//개인사업자
	var strNumb1 = fm.enp_no1[1].value;
    var strNumb2 = fm.enp_no2[1].value;
    var strNumb3 = fm.enp_no3[1].value;
}
    var strNumb = strNumb1+strNumb2+strNumb3;
    if (strNumb.length != 10) {
        alert("사업자등록번호가 잘못되었습니다.");
		
        return ;
    }
    
        sumMod  =   0;
        sumMod  +=  parseInt(strNumb.substring(0,1));
        sumMod  +=  parseInt(strNumb.substring(1,2)) * 3 % 10;
        sumMod  +=  parseInt(strNumb.substring(2,3)) * 7 % 10;
        sumMod  +=  parseInt(strNumb.substring(3,4)) * 1 % 10;
        sumMod  +=  parseInt(strNumb.substring(4,5)) * 3 % 10;
        sumMod  +=  parseInt(strNumb.substring(5,6)) * 7 % 10;
        sumMod  +=  parseInt(strNumb.substring(6,7)) * 1 % 10;
        sumMod  +=  parseInt(strNumb.substring(7,8)) * 3 % 10;
        sumMod  +=  Math.floor(parseInt(strNumb.substring(8,9)) * 5 / 10);
        sumMod  +=  parseInt(strNumb.substring(8,9)) * 5 % 10;
        sumMod  +=  parseInt(strNumb.substring(9,10));
    
    if (sumMod % 10  !=  0) {
        alert("잘못된 사업자 등록번호 입니다.");
		fm.enp_no1[0].value = '';
		fm.enp_no2[0].value = '';
		fm.enp_no3[0].value = '';
        return ;
    }
        alert("올바른 사업자 등록번호 입니다.");
    	return ;
}

//주민등록번호 체크

 var errfound = false;

function jumin_No(){
	var fm = document.form1;	
	if ( fm.client_st.value != '2') {//개인
	    if(!JuminCheck(document.getElementById("repre_ssn1").value,document.getElementById("repre_ssn2").value)){
                alert("잘못된 주민등록번호입니다.");
        } else  {
        		alert("올바른 주민등록번호입니다.");
		}
	}
}

function JuminCheck(jumin1, jumin2){
        check = false;
        total =0;
        temp = new Array(13);
        for(i=1; i<=6; i++)temp[i] = jumin1.charAt(i-1);
        for(i=7; i<=13; i++) temp[i] =jumin2.charAt(i-7);
        for(i=1; i<=12;i++){
                k = i + 1;
                if(k >= 10) k = k% 10 + 2;
                total = total + temp[i] *k;
        }
        mm = temp[3] + temp[4];
        dd =temp[5] + temp[6];
        totalmod = total % 11;
        chd = 11 -totalmod;
        if(chd == temp[13] && mm < 13 && dd< 32 && (temp[7]==1 ||temp[7]==2))
                check=true;
        return check;
}


//법인번호 체크
function Biz_ck(){

	var fm = document.form1;
	
if ( fm.client_st.value == '1' || fm.client_st.value == '6' ) {//법인
	var strBiz1 = fm.ssn1[0].value;
    var strBiz2 = fm.ssn2[0].value;
}else if( fm.client_st.value == '2'){//개인
	var strBiz1 = fm.ssn1[2].value;
    var strBiz2 = fm.ssn2[2].value;
}else{//개인사업자
	var strBiz1 = fm.ssn1[1].value;
    var strBiz2 = fm.ssn2[1].value;
}

    var str_len ;
    var str_no = strBiz1+strBiz2;

    str_len = str_no.length;
    
	if ( fm.client_st.value == '1' || fm.client_st.value == '6' ) {
		if (str_len == 13 ){		
	        no_ck = str_no.substring(0, 1) * 1;
	        no_ck = no_ck + str_no.substring( 1, 2) * 2;
	        no_ck = no_ck + str_no.substring( 2, 3) * 1;
	        no_ck = no_ck + str_no.substring( 3, 4) * 2;
	        no_ck = no_ck + str_no.substring( 4, 5) * 1;
	        no_ck = no_ck + str_no.substring( 5, 6) * 2;
	        no_ck = no_ck + str_no.substring( 6, 7) * 1;
	        no_ck = no_ck + str_no.substring( 7, 8) * 2;
	        no_ck = no_ck + str_no.substring( 8, 9) * 1;
	        no_ck = no_ck + str_no.substring( 9, 10) * 2;
	        no_ck = no_ck + str_no.substring( 10, 11) * 1;
	        no_list = no_ck + str_no.substring( 11, 12) * 2;
	        no_ck_no = no_list / 10;
	        ck_no = "'"+no_ck_no+"'";
	        namuji = ck_no.substring(3,4);
	        no = 10 - namuji; 
	        if (no > 9 ){
	            no = 0;
	        }
	        if (no == str_no.substring(12, 13)){
	            alert ("올바른 법인번호입니다.");
	        }else{
	            alert ("잘못된 법인번호입니다.");
	        }
		}else{
			alert( "법인번호를 정확히 입력해 주시기 바랍니다.");
		}
    }else if ( fm.client_st.value == '1' && fm.nationality.value !='2' && fm.nationality.value !='6') {
		var a1=str_no.substring(0,1);
		var a2=str_no.substring(1,2);
		var a3=str_no.substring(2,3);
		var a4=str_no.substring(3,4);
		var a5=str_no.substring(4,5);
		var a6=str_no.substring(5,6);

		var check_digit=a1*2+a2*3+a3*4+a4*5+a5*6+a6*7;

		var b1=str_no.substring(6,7);
		var b2=str_no.substring(7,8);
		var b3=str_no.substring(8,9);
		var b4=str_no.substring(9,10);
		var b5=str_no.substring(10,11);
		var b6=str_no.substring(11,12);
		var b7=str_no.substring(12,13);

		var check_digit=check_digit+b1*8+b2*9+b3*2+b4*3+b5*4+b6*5; 

		check_digit = check_digit%11;
		check_digit = 11 - check_digit;
		check_digit = check_digit%10;
			
		if (check_digit != b7){
			alert('잘못된 주민등록번호입니다.');
		}else{
			alert('올바른 주민등록 번호입니다.');
		}
		
	}

}


//-->
</script>
<script language="JavaScript">

function jumin_No2(){

  if (document.getElementById("repre_ssn1").value.length != 6){
    alert("올바른 주민등록번호를 입력해주세요.");
    document.form1.repre_ssn1.focus();
  }
  else if (document.getElementById("repre_ssn2").value.length != 7){
    alert("올바른 주민등록번호를 입력해주세요.");
    document.form1.repre_ssn2.focus();
  }
    else {
  var str_repre_ssn1 = document.getElementById("repre_ssn1").value;
  var str_repre_ssn2 = document.getElementById("repre_ssn2").value;
 
  var digit=0
  for (var i=0;i<str_repre_ssn1.length;i++){
   var str_dig=str_repre_ssn1.substring(i,i+1);
   if (str_dig<'0' || str_dig>'9'){ 
    digit=digit+1 
   }
  }

         if ((str_repre_ssn1 == '') || ( digit != 0 )){
   alert('잘못된 주민등록번호입니다.\n\n다시 확인하시고 입력해 주세요.');
   document.form1.repre_ssn1.focus();
   return false;   
         }

  var digit1=0
  for (var i=0;i<str_repre_ssn2.length;i++){
   var str_dig1=str_repre_ssn2.substring(i,i+1);
   if (str_dig1<'0' || str_dig1>'9'){ 
    digit1=digit1+1 
   }
  }

         if ((str_repre_ssn2 == '') || ( digit1 != 0 )){
   alert('잘못된 주민등록번호입니다.\n\n다시 확인하시고 입력해 주세요.');
   document.form1.repre_ssn2.focus();
   return false;   
         }

         if (str_repre_ssn1.substring(2,3) > 1){
   alert('잘못된 주민등록번호입니다.\n\n다시 확인하시고 입력해 주세요.');
   document.form1.repre_ssn1.focus();
   return false;   
         }

         if (str_repre_ssn1.substring(4,5) > 3){
   alert('잘못된 주민등록번호입니다.\n\n다시 확인하시고 입력해 주세요.');
   document.form1.repre_ssn1.focus();
   return false;   
         } 

         if (str_repre_ssn2.substring(0,1) > 4 || str_repre_ssn2.substring(0,1) == 0){
   alert('잘못된 주민등록번호입니다.\n\n다시 확인하시고 입력해 주세요.');
   document.form1.repre_ssn2.focus();
   return false;   
         }

         var a1=str_repre_ssn1.substring(0,1)
         var a2=str_repre_ssn1.substring(1,2)
         var a3=str_repre_ssn1.substring(2,3)
          var a4=str_repre_ssn1.substring(3,4)
         var a5=str_repre_ssn1.substring(4,5)
          var a6=str_repre_ssn1.substring(5,6)
         
          var check_digit=a1*2+a2*3+a3*4+a4*5+a5*6+a6*7

         var b1=str_repre_ssn2.substring(0,1)
         var b2=str_repre_ssn2.substring(1,2)
         var b3=str_repre_ssn2.substring(2,3)
         var b4=str_repre_ssn2.substring(3,4)
         var b5=str_repre_ssn2.substring(4,5)
         var b6=str_repre_ssn2.substring(5,6)
         var b7=str_repre_ssn2.substring(6,7)
         
         var check_digit=check_digit+b1*8+b2*9+b3*2+b4*3+b5*4+b6*5 
        
         check_digit = check_digit%11
         check_digit = 11 - check_digit
         check_digit = check_digit%10

         if (check_digit != b7){
   alert('잘못된 주민등록번호입니다.\n\n다시 확인하시고 입력해 주세요.');
   document.form1.repre_ssn2.focus();
   return false;   
         }
        
         else{
   alert('올바른 주민등록 번호입니다.');
  }
 }
}

</script>

<link rel=stylesheet type="text/css" href="/include/table_t.css">
</head>
<body>
<form name='form1' method='post' action='/agent/client/client_i_a.jsp'>
<input type='hidden' name='auth_rw' value='<%=auth_rw%>'>
<input type='hidden' name='br_id' value='<%=br_id%>'>
<input type='hidden' name='user_id' value='<%=user_id%>'>
<input type='hidden' name='s_kd' value='<%=s_kd%>'>
<input type='hidden' name='t_wd' value='<%=t_wd%>'>
<input type='hidden' name='asc' value='<%=asc%>'>
<input type='hidden' name='from_page' value='<%=from_page%>'> 
<input type='hidden' name='etax_not_cau' value=''>
<input type='hidden' name='badcust_chk_from' value='client_i.jsp'>    
 
<table border="0" cellspacing="0" cellpadding="0" width=100%>
    <tr>
    	<td>
    	    <table width=100% border=0 cellpadding=0 cellspacing=0>
                <tr>
                    <td width=7><img src=/acar/images/center/menu_bar_1.gif width=7 height=33></td>
                    <td class=bar>&nbsp;&nbsp;&nbsp;<img src=/acar/images/center/menu_bar_dot.gif width=4 height=5 align=absmiddle>&nbsp;<span class=style1>영업지원 > 고객관리 > <span class=style5>고객등록</span></span></td>
                    <td width=7><img src=/acar/images/center/menu_bar_2.gif width=7 height=33></td>
                </tr>
            </table>
    	</td>
    </tr>
    <tr>
        <td class=h></td>
    </tr>
	<tr>
	    <td align='right'>
		        &nbsp;&nbsp;<a href="javascript:go_to_list()" onMouseOver="window.status=''; return true"><img src=/acar/images/center/button_list.gif align=absmiddle border=0></a> 
	    </td>
	</tr>	
    <tr>
        <td class=line2></td>
    </tr>
	<tr>
	    <td class='line'>
    	    <table border="0" cellspacing="1" cellpadding="0" width=100%>
                <tr>
                    <td class='title' width='13%'><b>고객구분</b></td>
                    <td>&nbsp;
                        <select name='client_st' onChange="javascript:cng_input(this.value)">
                            <option value='1' > 법인 </option>
                            <option value='2' > 개인 </option>
                            <option value='3' > 개인사업자(일반과세) </option>
                            <option value='4' > 개인사업자(간이과세) </option>
                            <option value='5' > 개인사업자(면세사업자)</option>
            				<option value='6' > 경매장</option>
                        </select>
                    </td>
                </tr>
            </table>
        </td>
	</tr>
    <tr>
        <td><font color=red>※ 불량고객 확인하기</font>
        	&nbsp;&nbsp;&nbsp;        	
        	<input type="button" class="button" id="bad_cust" value='고객확인' onclick="javascript:view_badcust();">
        	<input name="badcust_chk" type="text" class="text"  readonly value="" size="1">        	
        </td>
    </tr>  		
	<tr>
	    <td class=h></td>
	</tr>
    <tr id=tr_acct1 style="display:''">
        <td>
    	    <table border="0" cellspacing="0" cellpadding="0" width=100%> 
    		    <tr>	
    			    <td><img src=/acar/images/center/icon_arrow.gif align=absmiddle> <span class=style2>법인</span></td>
    		    </tr>
    		    <tr>
                    <td class=line2></td>
                </tr>
    		    <tr>
    			    <td class=line>
    			        <table border="0" cellspacing="1" cellpadding="0" width=100%>
            		        <tr>
            		            <td colspan="2" class='title'>법인규모</td>
            		            <td>&nbsp;
                		            <select name='firm_st'>
                		              <option value="">선택</option>
                		              <option value="1">대기업</option>
                		              <option value="2">중기업</option>					  
                		              <option value="3">소기업</option>
                		              <option value="4">크레탑미등재</option>					  
                		            </select>
                					<input type='checkbox' name='enp_yn' value='Y'>
                					대기업
                					<input type='text' name='enp_nm' size='10' maxlength='20' class='text' style='IME-MODE: active'>
                					계열사</td>
            		            <td class='title'>법인형태</td>
            		            <td>&nbsp;
            		                <select name='firm_type'>
                		                <option value="">선택</option>
                		                <option value="1">유가증권시장</option>
                		                <option value="2">코스닥상장</option>
                		                <option value="3">외감법인</option>
                		                <option value="4">벤처기업</option>
                		                <option value="5">일반법인</option>
                		                <option value="6">국가</option>
                		                <option value="7">지방자치단체</option>
                		                <option value="8">정부투자기관</option>
                		                <option value="9">정부출연연구기관</option>
										<option value="10">비영리법인</option>
										<option value="11">면세법인</option>
            		                </select></td>
            		        </tr>
            		        <tr>
            		            <td colspan="2" class='title'>설립일자</td>
            		            <td>&nbsp;
            		                <input type='text' name='found_year' size='12' class='text' maxlength='12' onBlur='javascript:this.value=ChangeDate(this.value);document.form1.t_open_year[0].value=ChangeDate(this.value);' value=""></td>
            		            <td class='title'>개업일자</td>
            		            <td>&nbsp;
            		                <input type='text' name='t_open_year' size='12' class='text' maxlength='12' onBlur='javascript:this.value=ChangeDate(this.value)' value=""></td>
            		        </tr>
            		        <tr>
            		            <td width='3%' rowspan="5" class='title'>사<br>
                					업<br>
                					자<br>
                					등<br>
                					록<br>
                					증</td>
            		            <td width="10%" class='title'><b>상호</b></td>
            		            <td width="37%" align='left'>&nbsp;
            		              <input type='text' name='firm_nm' size='30' maxlength='40' class='text' style='IME-MODE: active' value='' OnBlur='checkSpecial();'>
            		            </td>
            		            <td class='title' width=13%><b>대표자</b></td>
            		            <td width="37%">&nbsp;
            		              <input type='text' size='30' name='client_nm' maxlength='40' class='text' value='' OnBlur="checkSpecial();">
            		            </td>
            		        </tr>
            		        <tr>
            		            <td class='title'><b>사업자번호</b></td>
            		            <td>&nbsp;
                		            <!--<input type='text' size='3' name='enp_no1' maxlength='3' class='text' value='' onkeyup="javascript:set_next('0','enp_no','1');">-->
                					<input type='text' size='3' name='enp_no1' maxlength='3' class='text' value='' onkeyup="javascript:if(get_length(this.value) == 3){ document.form1.enp_no2[0].focus(); }">
                					-
                					<input type='text' size='2' name='enp_no2' maxlength='2' class='text' value='' onkeyup="javascript:if(get_length(this.value) == 2){ document.form1.enp_no3[0].focus(); }">
                					-
                					<input type='text' size='5' name='enp_no3' maxlength='5' class='text' value='' onkeyup="javascript:if(get_length(this.value) == 5){ document.form1.ssn1[0].focus(); }"  OnBlur="CheckBizNo();">
									&nbsp;&nbsp;
									(종사업자번호 : <input type='text' size='3' name='taxregno' maxlength='4' class='text' value=''>)
                					</td>
            		            <td class='title'><b>법인번호</b></td>
            		            <td>&nbsp;
            		              <input type='text' name='ssn1' maxlength='6' size='6' class='text' value='' onkeyup="javascript:if(get_length(this.value) == 6){ document.form1.ssn2[0].focus(); }">
            					-
            					<input type='text' name='ssn2' maxlength='7' size='7' class='text' value=''  OnBlur="Biz_ck();">
            					</td>
            		        </tr>
							<script src="https://t1.daumcdn.net/mapjsapi/bundle/postcode/prod/postcode.v2.js"></script>
							<script>
								function openDaumPostcode() {
									new daum.Postcode({
										oncomplete: function(data) {
											document.getElementById('t_zip').value = data.zonecode;
											document.getElementById('t_addr').value = data.address;
											
										}
									}).open();
								}
							</script>			
							<tr>
							  <td class=title>사업장 주소</td>
							  <td colspan=5>&nbsp;
								<input type="text" name="t_zip" id="t_zip" size="7" maxlength='7' value="" readonly>
								<input type="button" onclick="openDaumPostcode()" value="우편번호 찾기"><br>
								&nbsp;&nbsp;<input type="text" name="t_addr" id="t_addr" size="60" value="" OnBlur="checkSpecial();"  readonly>
								&nbsp;상세주소 : <input type="text" name='t_addr_sub' size="40" >
							  </td>
							</tr>
							<script>
								function openDaumPostcode1() {
									new daum.Postcode({
										oncomplete: function(data) {
											document.getElementById('t_zip1').value = data.zonecode;
											document.getElementById('t_addr1').value = data.address;
											
										}
									}).open();
								}
							</script>			
							<tr>
							  <td class=title>본점소재지</td>
							  <td colspan=5>&nbsp;<input type='checkbox' name='c_ho' onClick='javascript:set_o_addr()'>
            			              상동
								<input type="text" name="t_zip" id="t_zip1" size="7" maxlength='7' value="" readonly>
								<input type="button" onclick="openDaumPostcode1()" value="우편번호 찾기"><br>
								&nbsp;&nbsp;<input type="text" name="t_addr" id="t_addr1" size="90" value="" OnBlur="checkSpecial();">
							  </td>
							</tr>
            		        <tr>
            		            <td class='title'>업태</td>
            		            <td>&nbsp;
            		              <input type='text' size='30' name='bus_cdt' maxlength='40' class='text' value='' OnBlur="checkSpecial();">
            		            </td>
            		            <td class='title'>종목</td>
            		            <td>&nbsp;
            		              <input type='text' size='30' name='bus_itm' value='' maxlength='40' class='text' value='' OnBlur="checkSpecial();">
            		            </td>
            		        </tr>
            		        <tr>
            		            <td rowspan="4" class='title'>대<br>
            					    표<br>
            					    자</td>
            		            <td class='title'>대표자구분</td>
            		            <td>&nbsp;
                		            <select name='repre_st'>
                		              <option value="">선택</option>
                		              <option value="1">지배주주</option>
                		              <option value="2">전문경영인</option>
                		            </select>&nbsp;
                		            이름 : <input type='text' size='10' name='repre_nm' value='' maxlength='50' class='text' value='' OnBlur="checkSpecial();">
                		            (공동대표로 다중일 경우 대표자 공동임차인)
                		            </td>
            		            <td class='title'>생년월일</td>
            		            <td>&nbsp;
                		            <input type='text' name='repre_ssn1' maxlength='6' size='6' class='text' value='' onkeyup="javascript:if(get_length(this.value) == 6){ document.form1.repre_ssn2[0].focus(); } removeChar(event);" onkeydown='return onlyNumber(event)'>
                					-*******
                					<input type='hidden' name='repre_ssn2' maxlength='7' size='7' class='text' value='*******' OnBlur="jumin_No2();">
                						</td>
            		        </tr>
							<script>
								function openDaumPostcode2() {
									new daum.Postcode({
										oncomplete: function(data) {
											document.getElementById('t_zip2').value = data.zonecode;
											document.getElementById('t_addr2').value = data.address;
											
										}
									}).open();
								}
							</script>			
							<tr>
							  <td class=title>주소</td>
							  <td colspan=5>&nbsp;
								<input type="text" name="t_zip" id="t_zip2" size="7" maxlength='7' value="" readonly>
								<input type="button" onclick="openDaumPostcode2()" value="우편번호 찾기"><br>
								&nbsp;&nbsp;<input type="text" name="t_addr" id="t_addr2" size="90" value="" OnBlur="checkSpecial();">
							  </td>
							</tr>
            		        <tr>
            		            <td class='title'>이메일주소</td>
            		            <td colspan='3'>&nbsp;
					<input type='text' size='35' name='repre_email_1' maxlength='100' class='text' style='IME-MODE: inactive'>@<input type='text' size='20' name='repre_email_2' maxlength='100' class='text' style='IME-MODE: inactive'>
					  <select id="repre_email_domain" onChange="javascript:document.form1.repre_email_2[0].value=this.value;" align="absmiddle">
						<option value="" selected>선택하세요</option>
						<option value="hanmail.net">hanmail.net</option>
						<option value="naver.com">naver.com</option>
						<option value="nate.com">nate.com</option>
						<option value="bill36524.com">bill36524.com</option>
						<option value="gmail.com">gmail.com</option>
						<option value="paran.com">paran.com</option>
						<option value="yahoo.com">yahoo.com</option>
						<option value="korea.com">korea.com</option>
						<option value="hotmail.com">hotmail.com</option>
						<option value="chol.com">chol.com</option>
						<option value="daum.net">daum.net</option>
						<option value="hanafos.com">hanafos.com</option>
						<option value="lycos.co.kr">lycos.co.kr</option>
						<option value="dreamwiz.com">dreamwiz.com</option>
						<option value="unitel.co.kr">unitel.co.kr</option>
						<option value="freechal.com">freechal.com</option>
                        			<option value="empal.com">empal.com</option>						
						<option value="">직접 입력</option>
						</select>
						<input type='hidden' name='repre_email' value=''>               		            
            				 </td>
            		        </tr>
            		        <tr>
            		            <td class='title'>휴대폰번호</td>
            		            <td>&nbsp;
            				        <input type='text' size='30' name='m_tel' maxlength='15' class='text' value=''></td>
            		            <td class='title'>자택번호</td>
            		            <td>&nbsp;
            		                <input type='text' size='30' name='h_tel' maxlength='15' class='text' value=''></td>
            		        </tr>
            		        <tr>
            		            <td colspan="2" class='title'><b>사무실번호</b></td>
            		            <td>&nbsp;
            		                <input type='text' size='30' name='o_tel' maxlength='30' class='text' value=''>
            					</td>
            		            <td class='title'><b>팩스번호</b></td>
            		            <td>&nbsp;
            		                <input type='text' size='30' name='fax' maxlength='15' class='text' value=''>
            					</td>
            		        </tr>
            		        <tr>
            		            <td colspan="2" class='title'>Homepage</td>
            		            <td colspan="3">&nbsp;
            		                <input type='text' size='50' name='homepage' value='' maxlength='70' class='text' style='IME-MODE: inactive'></td>
            		        </tr>
    		            </table>
    			    </td>
    		    </tr>
        	</table>
	    </td>  	
    </tr>	       
	<tr id=tr_acct2 style='display:none'>
	    <td>
    	    <table border="0" cellspacing="0" cellpadding="0" width=100%> 
    		    <tr>
    			    <td><img src=/acar/images/center/icon_arrow.gif align=absmiddle> <span class=style2>개인사업자</span></td>
    		    </tr>
    		    <tr>
                    <td class=line2></td>
                </tr>
    		    <tr>
    			    <td class=line>
    			        <table border="0" cellspacing="1" cellpadding="0" width=100%>
            		        <tr>
            		            <td width='3%' rowspan="5" class='title'>사<br>
            		      		  업<br>
            				      자<br>
            				      등<br>
            				      록<br>
            				      증</td>
            		            <td class='title' width='10%'>개업년월일 </td>
            		            <td colspan="3">&nbsp;
            		              <input type='text' name='t_open_year' size='12' class='text' maxlength='12' onBlur='javascript:this.value=ChangeDate(this.value)' value=""></td>
            		        </tr>
            		        <tr>
            		            <td class='title'><b>상호</b></td>
            		            <td width="37%" align='left'>&nbsp;
            		              <input type='text' name='firm_nm' size='30' maxlength='40' class='text' style='IME-MODE: active'>
            		            </td>
            		            <td class='title' width=13%><b>대표자</b></td>
            		            <td width="37%">&nbsp;
            		              <input type='text' size='30' name='client_nm' maxlength='40' class='text'>
            		            </td>
            		        </tr>
            		        <tr>
            		            <td class='title'><b>사업자번호</b></td>
            		            <td>&nbsp;
            		              <input type='text' size='3' name='enp_no1' maxlength='3' class='text' onkeyup="javascript:if(get_length(this.value) == 3){ document.form1.enp_no2[1].focus(); }">
            		      			-
            		      			<input type='text' size='2' name='enp_no2' maxlength='2' class='text' onkeyup="javascript:if(get_length(this.value) == 2){ document.form1.enp_no3[1].focus(); }">
            		      			-
            		      			<input type='text' size='5' name='enp_no3' maxlength='5' class='text' onkeyup="javascript:if(get_length(this.value) == 5){ document.form1.ssn1[1].focus(); }" OnBlur="CheckBizNo();">
            		            </td>
            		            <td width='15%' class='title'><b>생년월일</b></td>
            		            <td>&nbsp;
            		                <input type='text' name='ssn1' maxlength='6' size='6' class='text' onkeyup="javascript:if(get_length(this.value) == 6){ document.form1.ssn2[1].focus(); }">
            		      			-*******
            		      			<input type='hidden' name='ssn2' maxlength='7' size='7' class='text' value='*******' OnBlur="Biz_ck();">
            		            </td>
            		        </tr>
							<script>
								function openDaumPostcode3() {
									new daum.Postcode({
										oncomplete: function(data) {
											document.getElementById('t_zip3').value = data.zonecode;
											document.getElementById('t_addr3').value = data.address;
											
										}
									}).open();
								}
							</script>			
							<tr>
							  <td class=title>사업장 소재지</td>
							  <td colspan=5>&nbsp;
								<input type="text" name="t_zip" id="t_zip3" size="7" maxlength='7' value="" readonly>
								<input type="button" onclick="openDaumPostcode3()" value="우편번호 찾기"><br>
								&nbsp;&nbsp;<input type="text" name="t_addr" id="t_addr3" size="60" value="" readonly>
								&nbsp;상세주소 : <input type="text" name='t_addr_sub' size="40" >
							  </td>
							</tr>
	            		        <tr>
            		            <td class='title'>업태</td>
            		            <td>&nbsp;
            		              <input type='text' size='30' name='bus_cdt' maxlength='40' class='text'>
            		            </td>
            		            <td class='title'>종목</td>
            		            <td>&nbsp;
            		              <input type='text' size='30' name='bus_itm' value='' maxlength='40' class='text'>
            		            </td>
            		        </tr>
            		        <tr>
            		            <td rowspan="4" class='title'>대<br>
                					표<br>
                					자</td>
                					<td class='title'>대표자구분</td>
            		            <td>&nbsp;
                		            이름 : <input type='text' size='10' name='repre_nm' value='' maxlength='50' class='text' value='' OnBlur="checkSpecial();">
                		            (공동대표로 다중일 경우 대표자 공동임차인)
                		            </td>
            		            <td class='title'>생년월일</td>
            		            <td>&nbsp;
                		            <input type='text' name='repre_ssn1' maxlength='6' size='6' class='text' value='' onkeyup="javascript:if(get_length(this.value) == 6){ document.form1.repre_ssn2[0].focus(); }  removeChar(event);" onkeydown='return onlyNumber(event)'>
                					-*******
                					<input type='hidden' name='repre_ssn2' maxlength='7' size='7' class='text' value='*******' OnBlur="jumin_No2();"> <!--OnBlur="jumin_No();" -->
								</td>
							</tr>
								<script>
									function openDaumPostcode4() {
										new daum.Postcode({
											oncomplete: function(data) {
												document.getElementById('t_zip4').value = data.zonecode;
												document.getElementById('t_addr4').value = data.address;
												
											}
										}).open();
									}
								</script>		
								<tr>			
								  <td class=title>주소</td>
								  <td colspan=5>&nbsp;
									<input type="text" name="t_zip" id="t_zip4" size="7" maxlength='7' value="" readonly>
									<input type="button" onclick="openDaumPostcode4()" value="우편번호 찾기"><br>
									&nbsp;&nbsp;<input type="text" name="t_addr" id="t_addr4" size="90" value="">
								  </td>

            		        </tr>
            		        <tr>
            		            <td class='title'>이메일주소</td>
            		            <td colspan='3'>&nbsp;
					<input type='text' size='35' name='repre_email_1' maxlength='100' class='text' style='IME-MODE: inactive'>@<input type='text' size='20' name='repre_email_2' maxlength='100' class='text' style='IME-MODE: inactive'>
					  <select id="repre_email_domain" onChange="javascript:document.form1.repre_email_2[1].value=this.value;" align="absmiddle">
						<option value="" selected>선택하세요</option>
						<option value="hanmail.net">hanmail.net</option>
						<option value="naver.com">naver.com</option>
						<option value="nate.com">nate.com</option>
						<option value="bill36524.com">bill36524.com</option>
						<option value="gmail.com">gmail.com</option>
						<option value="paran.com">paran.com</option>
						<option value="yahoo.com">yahoo.com</option>
						<option value="korea.com">korea.com</option>
						<option value="hotmail.com">hotmail.com</option>
						<option value="chol.com">chol.com</option>
						<option value="daum.net">daum.net</option>
						<option value="hanafos.com">hanafos.com</option>
						<option value="lycos.co.kr">lycos.co.kr</option>
						<option value="dreamwiz.com">dreamwiz.com</option>
						<option value="unitel.co.kr">unitel.co.kr</option>
						<option value="freechal.com">freechal.com</option>
                        			<option value="empal.com">empal.com</option>						
						<option value="">직접 입력</option>
						</select>
						<input type='hidden' name='repre_email' value=''>               		            
            				 </td>
            		        </tr>
<!--             				<input type='hidden' name='repre_ssn1'> -->
<!--             				<input type='hidden' name='repre_ssn2'> -->

            		        <tr>
            		            <td class='title'>휴대폰번호</td>
            		            <td>&nbsp;
            				        <input type='text' size='30' name='m_tel' maxlength='15' class='text'></td>
            		            <td class='title'>자택번호</td>
            		            <td>&nbsp;
            		                <input type='text' size='30' name='h_tel' maxlength='15' class='text'></td>
            		        </tr>		    		    
            		        <tr>
            		            <td colspan="2" class='title'><b>사무실번호</b></td>
            		            <td>&nbsp;
            		              <input type='text' size='30' name='o_tel' maxlength='30' class='text'>
            		            </td>
            		            <td class='title'><b>팩스번호</b></td>
            		            <td>&nbsp;
            		              <input type='text' size='30' name='fax' maxlength='15' class='text'>
            		            </td>
            		        </tr>
            		        <tr>
            		            <td colspan="2" class='title'>Homepage</td>
            		            <td colspan="3">&nbsp;
            		              <input type='text' size='50' name='homepage' value='' maxlength='70' class='text' style='IME-MODE: inactive'></td>
            		        </tr>		     
    		            </table>
    				</td>
    		    </tr>
        	</table>
        </td>   	
    </tr>	    
    <tr id=tr_acct3 style='display:none'>
	    <td>
	        <table border="0" cellspacing="0" cellpadding="0" width=100%> 	  
    		    <tr>
    				 <td><img src=/acar/images/center/icon_arrow.gif align=absmiddle> <span class=style2>개인</span></td>
    		    </tr>
    		    <tr>
                    <td class=line2></td>
                </tr>
    			<tr>
    			    <td class=line>
    			        <table border="0" cellspacing="1" cellpadding="0" width=100%>
            		        <tr>
            		            <td colspan="2" class='title'><b>성명</b></td>
            		            <td align='left'>&nbsp;
            		              <input type='text' name='firm_nm' size='30' maxlength='40' class='text' style='IME-MODE: active'>
            		            </td>
            		            <td class='title'><b>주민번호</b></td>
            		            <td>&nbsp;
                		            <input type='text' name='ssn1' maxlength='6' size='6' class='text' onkeyup="javascript:if(get_length(this.value) == 6){ document.form1.ssn2[2].focus(); }">
                					-
                					<input type='text' name='ssn2' maxlength='7' size='7' class='text' OnBlur="Biz_ck();">
           						</td>
            		        </tr>
							<script>
								function openDaumPostcode5() {
									new daum.Postcode({
										oncomplete: function(data) {
											document.getElementById('t_zip5').value = data.zonecode;
											document.getElementById('t_addr5').value = data.address;
											
										}
									}).open();
								}
							</script>			
							<tr>
							  <td colspan=2 class=title>자택주소</td>
							  <td colspan=3>&nbsp;
								<input type="text" name="t_zip" id="t_zip5" size="7" maxlength='7' value="" readonly>
								<input type="button" onclick="openDaumPostcode5()" value="우편번호 찾기"><br>
								&nbsp;&nbsp;<input type="text" name="t_addr" id="t_addr5" size="60" value="" readonly>
								&nbsp;상세주소 : <input type="text" name='t_addr_sub' size="40" >
							  </td>
							</tr>

            		        <tr>
            		            <td colspan="2" class='title'><b>휴대폰</b></td>
            		            <td>&nbsp;
            		                <input type='text' size='30' name='m_tel' maxlength='15' class='text'></td>
            		            <td class='title'>자택전화번호</td>
            		            <td>&nbsp;
            		                <input type='text' size='30' name='h_tel' maxlength='15' class='text'></td>
            		        </tr>
            		        <tr>
            		            <td colspan="2" class='title'>국적</td>
            		            <td>&nbsp;
            		              <select name='nationality'>
                		            <option value="">선택</option>
                		            <option value="1">내국인</option>
                		            <option value="2">외국인</option>
                		          </select>
            		            </td>
            		            <td class='title'>Homepage</td>
            		            <td>&nbsp;
            		              <input type='text' size='50' name='homepage' value='' maxlength='70' class='text' style='IME-MODE: inactive'>
            		            </td>
            		        </tr>
            		        <tr>
            		            <td width="3%" rowspan="6" class='title'>소<br>
                		            득<br>정<br>
                		            보</td>
            		            <td width="10%" class='title'>직업</td>
            		            <td width="37%">&nbsp;
            		              <input type='text' size='30' name='job' maxlength='20' class='text'>
            		            </td>
            		            <td width="13%" class='title'>소득구분</td>
            		            <td width="37%">&nbsp; <select name='pay_st'>
                		            <option value="">선택</option>
                		            <option value="1">급여소득</option>
                		            <option value="2">사업소득</option>
                		            <option value="3">기타사업소득</option>
                		                    </select></td>
            		        </tr>
            		        <tr>
            		            <td class='title'>직장명</td>
            		            <td colspan="3">&nbsp;
            		              <input type='text' size='50' name='com_nm' maxlength='50' class='text'> </td>
            		        </tr>
            		        <tr>
            		            <td class='title'>부서명</td>
            		            <td>
            					&nbsp;
            					    <input type='text' size='30' name='dept' maxlength='10' class='text'>
            				    </td>
            		            <td class='title'>직위</td>
            		            <td>&nbsp;
            		                <input type='text' size='30' name='title' maxlength='15' class='text'></td>
            		        </tr>
            		        <tr>
            		            <td class='title'>전화번호</td>
            		            <td>&nbsp;
            		                <input type='text' size='30' name='o_tel' maxlength='15' class='text'></td>
            		            <td class='title'>FAX</td>
            		            <td>&nbsp;
            		              <input type='text' size='30' name='fax' maxlength='15' class='text'>
            		            </td>
            		        </tr>
							<script>
								function openDaumPostcode6() {
									new daum.Postcode({
										oncomplete: function(data) {
											document.getElementById('t_zip6').value = data.zonecode;
											document.getElementById('t_addr6').value = data.address;
											
										}
									}).open();
								}
							</script>			
							<tr>
							  <td class=title>직장주소</td>
							  <td colspan=5>&nbsp;
								<input type="text" name="t_zip" id="t_zip6" size="7" maxlength='7' value="" readonly>
								<input type="button" onclick="openDaumPostcode6()" value="우편번호 찾기"><br>
								&nbsp;&nbsp;<input type="text" name="t_addr" id="t_addr6" size="90" value="">
							  </td>
							</tr>

            		        <tr>
            		            <td class='title'>근속연수</td>
            		            <td>
            					    &nbsp;
            					    <input type='text' size='2'  name='wk_year' maxlength='2' class='text' value=''>&nbsp;년
            				    </td>
            		            <td class='title'>연소득</td>
            		            <td>&nbsp;
            		                <input type='text' size='7'  name='pay_type' maxlength='9' class='text' value=''>&nbsp;만원</td>
            		        </tr>	
            		        <tr>
            		            <td rowspan="4" class='title'>대<br>
            					    표<br>
            					    자</td>
            		            <td class='title'>대표자구분</td>
            		            <td>&nbsp;
                		            이름 : <input type='text' size='10' name='repre_nm' value='' maxlength='50' class='text' value='' OnBlur="checkSpecial();">
                		            (공동임차인)
                		            </td>
            		            <td class='title'>생년월일</td>
            		            <td>&nbsp;
                		            <input type='text' name='repre_ssn1' maxlength='6' size='6' class='text' value='' onkeyup="javascript:if(get_length(this.value) == 6){ document.form1.repre_ssn2[0].focus(); }  removeChar(event);" onkeydown='return onlyNumber(event)'>
                					-*******
                					<input type='hidden' name='repre_ssn2' maxlength='7' size='7' class='text' value='*******' OnBlur="jumin_No2();"> <!--OnBlur="jumin_No();" -->
								</td>
            		        </tr>
            		        <script>
								function openDaumPostcode7() {
									new daum.Postcode({
										oncomplete: function(data) {
											document.getElementById('t_zip7').value = data.zonecode;
											document.getElementById('t_addr7').value = data.address;
											
										}
									}).open();
								}
							</script>			
							<tr>
							  <td class=title>주소</td>
							  <td colspan=3>&nbsp;
								<input type="text" name='t_zip' id="t_zip7" size="7" maxlength='7' readonly>
								<input type="button" onclick="openDaumPostcode7()" value="우편번호 찾기"><br>
								&nbsp;&nbsp;<input type="text" name='t_addr' id="t_addr7" size="100" OnBlur="checkSpecial();">
							  </td>
							</tr>
            		       
            		        <tr>
            		            <td class='title'>이메일주소</td>
            		            <td colspan='3'>&nbsp;
					<input type='text' size='35' name='repre_email_1' maxlength='100' class='text' style='IME-MODE: inactive'>@<input type='text' size='20' name='repre_email_2' maxlength='100' class='text' style='IME-MODE: inactive'>
					  <select id="repre_email_domain" onChange="javascript:document.form1.repre_email_2[2].value=this.value;" align="absmiddle">
						<option value="" selected>선택하세요</option>
						<option value="hanmail.net">hanmail.net</option>
						<option value="naver.com">naver.com</option>
						<option value="nate.com">nate.com</option>
						<option value="bill36524.com">bill36524.com</option>
						<option value="gmail.com">gmail.com</option>
						<option value="paran.com">paran.com</option>
						<option value="yahoo.com">yahoo.com</option>
						<option value="korea.com">korea.com</option>
						<option value="hotmail.com">hotmail.com</option>
						<option value="chol.com">chol.com</option>
						<option value="daum.net">daum.net</option>
						<option value="hanafos.com">hanafos.com</option>
						<option value="lycos.co.kr">lycos.co.kr</option>
						<option value="dreamwiz.com">dreamwiz.com</option>
						<option value="unitel.co.kr">unitel.co.kr</option>
						<option value="freechal.com">freechal.com</option>
                        			<option value="empal.com">empal.com</option>						
						<option value="">직접 입력</option>
						</select>
						<input type='hidden' name='repre_email' value=''>               		            
            				 </td>
            		        </tr>			  
    		            </table>
    			    </td>
    		    </tr>
		    </table>
	    </td>    		
    </tr>  
    <tr>
	    <td class=h></td>
	</tr>  
	<tr>
	    <td><img src=/acar/images/center/icon_arrow.gif align=absmiddle> <span class=style2>공통</span></td>
    </tr>
    <tr>
        <td class=line2></td>
    </tr>
	<tr>
	    <td class=line>
	        <table border="0" cellspacing="1" cellpadding="0" width=100%>
                <tr>
                    <td class='title'> 운전면허번호 </td>
                    <td >&nbsp;
                      <input type='text' size='30' name='lic_no' maxlength='30' class='text' style='IME-MODE: active'>
                      &nbsp;(개인,개인사업자,일부 법인사업자)
                    </td>
                    <td colspan="2" style="border-left: none;">
                    	&nbsp;※ 계약자의 운전면허번호를 기재하고, 계약자가 운전면허가 없는 경우 차량이용자의 운전면허를 입력<br>
			            &nbsp;※ 법인번호가 없는 법인사업자도 운전면허번호를 입력(비영리법인 등)
			        </td>
                </tr>	        	
                <tr>
                    <td width="15%" rowspan='4' class='title'>세금계산서<br>
                        수신담당자</td>
                    <td colspan='3'><input type='checkbox' name='c_tax' onClick='javascript:set_tax();'>
        			    대표자와 동일</td>
                </tr>
                <tr>
                    <td colspan='3'>&nbsp;<img src=/acar/images/center/arrow.gif> 성명:&nbsp;&nbsp;&nbsp;
                        <input type='text' size='15' name='con_agnt_nm' maxlength='20' class='text'>
        				&nbsp;<img src=/acar/images/center/arrow.gif> 사무실:
        				<input type='text' size='30' name='con_agnt_o_tel' maxlength='30' class='text'>
        				&nbsp;<img src=/acar/images/center/arrow.gif> 이동전화:
        				<input type='text' size='15' name='con_agnt_
        				' maxlength='15' class='text'>
        				&nbsp;<img src=/acar/images/center/arrow.gif> FAX:
        				<input type='text' size='15' name='con_agnt_fax' maxlength='15' class='text'></td>
                </tr>
                <tr>
                    <td colspan='3'>&nbsp;<img src=/acar/images/center/arrow.gif> EMAIL:
                      <input type='text' size='15' name='email_1' maxlength='100' class='text' style='IME-MODE: inactive'>@<input type='text' size='20' name='email_2' maxlength='100' class='text' style='IME-MODE: inactive'>
					  <select id="email_domain" onChange="javascript:document.form1.email_2.value=this.value;" align="absmiddle">
						<option value="" selected>선택하세요</option>
						<option value="hanmail.net">hanmail.net</option>
						<option value="naver.com">naver.com</option>
						<option value="nate.com">nate.com</option>
						<option value="bill36524.com">bill36524.com</option>
						<option value="gmail.com">gmail.com</option>
						<option value="paran.com">paran.com</option>
						<option value="yahoo.co.kr">yahoo.co.kr</option>
						<option value="korea.com">korea.com</option>
						<option value="hotmail.com">hotmail.com</option>
						<option value="chol.com">chol.com</option>
						<option value="daum.net">daum.net</option>
						<option value="hanafos.com">hanafos.com</option>
						<option value="lycos.co.kr">lycos.co.kr</option>
						<option value="dreamwiz.com">dreamwiz.com</option>
						<option value="unitel.co.kr">unitel.co.kr</option>
						<option value="freechal.com">freechal.com</option>
                        <option value="empal.com">empal.com</option>
						<option value="">직접 입력</option>
						</select>
						<input type='hidden' name='con_agnt_email' value=''>
                </tr>
                <tr>
                    <td colspan='3'>&nbsp;<img src=/acar/images/center/arrow.gif> 근무부서:
        			  <input type='text' size='25' name='con_agnt_dept' maxlength='15' class='text' style='IME-MODE: inactive'>
        			  &nbsp;<img src=/acar/images/center/arrow.gif> 직위:
        			  <input type='text' size='15' name='con_agnt_title' maxlength='10' class='text'>
                    </td>
                </tr>
                <tr>
                    <td width="15%" rowspan='4' class='title'>세금계산서<br>
                        추가담당자</td>
                    <td colspan='3'></td>
                </tr>
                <tr>
                    <td colspan='3'>&nbsp;<img src=/acar/images/center/arrow.gif> 성명:&nbsp;&nbsp;&nbsp;
                        <input type='text' size='15' name='con_agnt_nm2' maxlength='20' class='text'>
        				&nbsp;<img src=/acar/images/center/arrow.gif> 사무실:
        				<input type='text' size='30' name='con_agnt_o_tel2' maxlength='30' class='text'>
        				&nbsp;<img src=/acar/images/center/arrow.gif> 이동전화:
        				<input type='text' size='15' name='con_agnt_m_tel2' maxlength='15' class='text'>
        				&nbsp;<img src=/acar/images/center/arrow.gif> FAX:
        				<input type='text' size='15' name='con_agnt_fax2' maxlength='15' class='text'></td>
                </tr>
                <tr>
                    <td colspan='3'>&nbsp;<img src=/acar/images/center/arrow.gif> EMAIL:
                      <input type='text' size='15' name='email_3' maxlength='100' class='text' style='IME-MODE: inactive'>@<input type='text' size='20' name='email_4' maxlength='100' class='text' style='IME-MODE: inactive'>
					  <select id="email_domain2" onChange="javascript:document.form1.email_4.value=this.value;" align="absmiddle">
						<option value="" selected>선택하세요</option>
						<option value="hanmail.net">hanmail.net</option>
						<option value="naver.com">naver.com</option>
						<option value="nate.com">nate.com</option>
						<option value="bill36524.com">bill36524.com</option>
						<option value="gmail.com">gmail.com</option>
						<option value="paran.com">paran.com</option>
						<option value="yahoo.co.kr">yahoo.co.kr</option>
						<option value="korea.com">korea.com</option>
						<option value="hotmail.com">hotmail.com</option>
						<option value="chol.com">chol.com</option>
						<option value="daum.net">daum.net</option>
						<option value="hanafos.com">hanafos.com</option>
						<option value="lycos.co.kr">lycos.co.kr</option>
						<option value="dreamwiz.com">dreamwiz.com</option>
						<option value="unitel.co.kr">unitel.co.kr</option>
						<option value="freechal.com">freechal.com</option>
                        <option value="empal.com">empal.com</option>
						<option value="">직접 입력</option>
						</select>
						<input type='hidden' name='con_agnt_email2' value=''>
                </tr>
                <tr>
                    <td colspan='3'>&nbsp;<img src=/acar/images/center/arrow.gif> 근무부서:
        			  <input type='text' size='25' name='con_agnt_dept2' maxlength='15' class='text' style='IME-MODE: inactive'>
        			  &nbsp;<img src=/acar/images/center/arrow.gif> 직위:
        			  <input type='text' size='15' name='con_agnt_title2' maxlength='10' class='text'>
                    </td>
                </tr>                
                <tr>
                    <td width="15%" class='title'> 거래명세서메일수신여부 </td>
                    <td width="35%">&nbsp;
                        <select name='item_mail_yn'>
                          <option value='Y' selected>승락</option>
                          <option value='N'>거부</option>
                        </select>
                    </td>
                    <td width="15%" class='title'> 세금계산서메일수신여부 </td>
                    <td width="35%">&nbsp;
                        <select name='tax_mail_yn'>
                          <option value='Y' selected>승락</option>
                          <option value='N'>거부</option>
                        </select>
                    </td>
                </tr>					
		
                <tr>
                    <td class='title'>계산서발행구분</td>
                    <td>&nbsp;
                        <select name='print_st' onClick='javascript:set_print();'>
                            <option value=''>선택</option>
                            <option value='1'>계약건별</option>
                            <option value='2'>거래처통합</option>
                            <option value='3'>지점통합</option>
                            <option value='4'>현장통합</option>
                            <option value='9'>타시스템발행</option>
                        </select></td>
                    <td class='title'> 계산서별도발행구분</td>
                    <td>&nbsp;
                        <select name='print_car_st'>
                          <option value=''>없음</option>
                          <option value='1' selected>승합/화물/9인승/경차</option>
                        </select>
                        (부가세환급관련)
                    </td>
                </tr>
                <tr>                    
                    <td class='title'> 계산서품목표시구분</td>
                    <td colspan='3'>&nbsp;
                        <select name='etax_item_st'>
                          <option value='1' selected>한줄만표시</option>
                          <option value='2'>모두표시</option>
                        </select>
                    </td>                    
                </tr>				
                <tr>                    
                    <td class='title'> 연체문자수신여부</td>
                    <td >&nbsp;
                        <select name='dly_sms'>
                        	<option value='' selected>--선택--</option>
                          <option value='Y' selected>승락</option>
                          <option value='N'>거부</option>
                        </select>
                    </td>
                    <td class='title'> CMS요청문자수신여부 </td>
                    <td >&nbsp;
                        <select name='cms_sms'>
                        	<option value='' >선택</option>
                          <option value='Y' >승락</option>
                          <option value='N'>거부</option>
                        </select>
                        (자동이체 결제예정 문자로 승락이면 이체 신청시에 발송)
                    </td>
                </tr>			                
                <tr>	   
                    <td class='title'> 면책금 CMS 청구 여부 </td>
                    <td>&nbsp;
                        <select name='etc_cms'>
                          <option value='' selected>--선택--</option>
                          <option value='Y'>승락</option>
                          <option value='N'>거부</option>                  
                        </select>
                        &nbsp;&nbsp;* CMS 거래고객에 한함.
                    <td class='title'> 선납과태료 청구 여부 </td>
                    <td>&nbsp;
                        <select name='fine_yn'>
                          <option value='' selected>--선택--</option>
                          <option value='Y'>승락</option>
                          <option value='N'>거부</option>                  
                        </select>
                        &nbsp;&nbsp;
                        
                    </td>
                </tr>                 			
                <tr>
                    <td class='title'> 특이사항 </td>
                    <td colspan='3'>&nbsp;
                      <textarea name='etc' rows='5' cols='100' maxlenght='500'></textarea>
                    </td>
                </tr>
            </table>
        </td>
    </tr>
<%	if(auth_rw.equals("2") || auth_rw.equals("4") || auth_rw.equals("6")){%>	
	<tr>
	    <td align='right'> <a href="javascript:save()"><img src=/acar/images/center/button_reg.gif align=absmiddle border=0></a>
	    </td>
	</tr>	
<%	}%>	
	<tr>
	    <td>&nbsp;</td>
    </tr>
	<tr>
	    <td>&nbsp;</td>
    </tr>
</table>
</form>
<iframe src="about:blank" name="i_no" width="0" height="0" frameborder="0" noresize>
</iframe>
</body>
</html>

