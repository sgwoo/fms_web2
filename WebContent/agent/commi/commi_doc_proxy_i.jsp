<%@ page language="java" contentType="text/html;charset=euc-kr"%>
<%@ page import="java.util.*,acar.util.*,acar.common.*"%>
<%@ page import="acar.cont.*, acar.car_register.*"%>
<%@ page import="acar.car_office.*, acar.user_mng.*"%>
<jsp:useBean id="a_db" scope="page" class="acar.cont.AddContDatabase"/>
<%@ include file="/agent/cookies.jsp" %>

<%
	String auth_rw 	= request.getParameter("auth_rw")==null?""        :request.getParameter("auth_rw");
	String user_id 	= request.getParameter("user_id")==null?ck_acar_id:request.getParameter("user_id");
	String br_id 	= request.getParameter("br_id")  ==null?acar_br   :request.getParameter("br_id");
	
	String s_kd 	= request.getParameter("s_kd")==null? "":request.getParameter("s_kd");
	String t_wd 	= request.getParameter("t_wd")==null? "" :request.getParameter("t_wd");
	String andor 	= request.getParameter("andor")==null?"":request.getParameter("andor");
	String gubun1 	= request.getParameter("gubun1")==null?"":request.getParameter("gubun1");
	String gubun2 	= request.getParameter("gubun2")==null?"":request.getParameter("gubun2");
	String gubun3 	= request.getParameter("gubun3")==null?"":request.getParameter("gubun3");
	String from_page 	= request.getParameter("from_page")==null?"":request.getParameter("from_page");
	
	String rent_mng_id 	= request.getParameter("rent_mng_id")==null?"":request.getParameter("rent_mng_id");
	String rent_l_cd 	= request.getParameter("rent_l_cd")==null?"":request.getParameter("rent_l_cd");
	String doc_no	 	= request.getParameter("doc_no")==null?"":request.getParameter("doc_no");
	String mode		= request.getParameter("mode")==null?"":request.getParameter("mode");

	
	CommonDataBase c_db = CommonDataBase.getInstance();
	CarOfficeDatabase cod = CarOfficeDatabase.getInstance();
	
	
	//계약기본정보
	ContBaseBean base = a_db.getCont(rent_mng_id, rent_l_cd);
	
	//계약기타정보
	ContEtcBean cont_etc = a_db.getContEtc(rent_mng_id, rent_l_cd);
	
	//영업수당+영업소 담당자
	CommiBean emp1 	= a_db.getCommi(rent_mng_id, rent_l_cd, "1");
	
	//영업사원
	CarOffEmpBean coe_bean = cod.getCarOffEmpBean(emp1.getEmp_id());
	
	//에이전트관리 20131101
	CarOffBean a_co_bean = new CarOffBean();
	
	if(!coe_bean.getAgent_id().equals("")){
		a_co_bean = cod.getCarOffBean(coe_bean.getAgent_id());
	}else{
		a_co_bean = cod.getCarOffBean(coe_bean.getCar_off_id());
	}


	//영업소담당자 영업대리인(에이젼트)
	CommiBean emp4 	= a_db.getCommi(rent_mng_id, rent_l_cd, "4");

	if(emp4.getEmp_id().equals("")){
		emp4.setRent_mng_id	(rent_mng_id);
		emp4.setRent_l_cd	(rent_l_cd);
		emp4.setEmp_id		(emp1.getEmp_id());
		emp4.setAgnt_st		("4");
		//=====[commi] insert=====
		boolean flag4 = a_db.insertCommiNew(emp4);
	}

	CarOffEmpBean coe_bean4 = cod.getCarOffEmpBean(emp4.getEmp_id());
	
	
	//금융사리스트
	CodeBean[] banks = c_db.getCodeAllCms("0003");
	int bank_size = banks.length;
	
	//20150526 ACAR_ATTACH_FILE LIST---------------------------------------------------------
	
	String content_code = "COMMI";
	String content_seq  = "";

	Vector attach_vt = new Vector();
	int attach_vt_size = 0;
%>

<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN">
<html>
<head>
<title>FMS</title>
<meta http-equiv="Content-Type" content="text/html; charset=euc-kr">
<link rel="stylesheet" type="text/css" href="/include/table_t.css"></link>
<script language='JavaScript' src='/include/common.js'></script>
<script language="JavaScript">
<!--
	var popObj = null;
	
	//팝업윈도우 열기
	function ScanOpen(theURL,file_path,file_type) { //v2.0
		if( popObj != null ){
			popObj.close();
			popObj = null;
		}
		theURL = "https://fms3.amazoncar.co.kr/data/"+file_path+""+theURL+""+file_type;
		if(file_type == '.jpg'){
			theURL = '/agent/lc_rent/img_scan_view.jsp?img_url='+theURL;
			popObj = window.open('','popwin_in1','scrollbars=yes,status=yes,resizable=yes,width=<%=(2100*0.378)+50%>,height=<%=s_height%>,left=0, top=0');
		}else{
			popObj = window.open('','popwin_in1','scrollbars=no,status=yes,resizable=yes,width=820,height=600,left=50, top=50');
		}
		popObj.location = theURL;
		popObj.focus();
	}
	
	//팝업윈도우 열기
	function MM_openBrWindow(theURL,winName,features) { //v2.0
		if( popObj != null ){
			popObj.close();
			popObj = null;
		}
		theURL = "https://fms3.amazoncar.co.kr/data/"+theURL+".pdf";
		popObj = window.open('',winName,features);
		popObj.location = theURL;
		popObj.focus();	
	}
		

	
	//스캔등록
	function scan_reg(file_st){
		window.open("reg_scan.jsp?auth_rw=<%=auth_rw%>&user_id=<%=user_id%>&br_id=<%=br_id%>&rent_mng_id=<%=rent_mng_id%>&rent_l_cd=<%=rent_l_cd%>&emp_id=<%=emp1.getEmp_id()%>&agnt_st=4&from_page=/fms2/commi/commi_doc_proxy_i.jsp&file_st="+file_st, "SCAN", "left=10, top=10, width=620, height=250, scrollbars=yes, status=yes, resizable=yes");
	}
	
	//스캔삭제
	function scan_del(file_st){
		var fm = document.form1;
		if(!confirm('삭제하시겠습니까?')){		return;	}
		fm.file_st.value = file_st;
		fm.target = "i_no"
		fm.action = "del_scan_a.jsp";
		fm.submit();
	}	
	
	//실수령인 조회
	function search_bank_acc(){
		var fm = document.form1;
		window.open("s_emp_bank_acc.jsp?from_page=/fms2/commi/commi_doc_u.jsp&emp_id=<%=emp1.getEmp_id()%>", "SEARCH_EMP_ACC", "left=50, top=50, width=950, height=600, scrollbars=yes");		
	}	
	

	
	//영업수당계산
	function set_amt(){
		var fm = document.form1;
		var per = 1;
		
		if(toInt(parseDigit(fm.add_amt1.value)) != 0 && fm.add_st1.value == ''){
			alert('가감1 구분을 선택하십시오.'); return;
		}
		
		if(toInt(parseDigit(fm.add_amt2.value)) != 0 && fm.add_st2.value == ''){
			alert('가감2 구분을 선택하십시오.'); return;
		}
		
		if(toInt(parseDigit(fm.add_amt3.value)) != 0 && fm.add_st3.value == ''){
			alert('가감3 구분을 선택하십시오.'); return;
		}				
		
		<%if(a_co_bean.getDoc_st().equals("2")){%>
			
			per = 0.1;
			
			fm.inc_per.value = 0;
			fm.res_per.value = 0;
			fm.vat_per.value = per*100;
			fm.tot_per.value = per*100;

			var tot_add1 = 0;//세전가감액
			var tot_add2 = 0;//세후가감액
			if(toInt(parseDigit(fm.add_amt1.value)) != 0 && fm.add_st1.value == '1')	tot_add1 = tot_add1 + toInt(parseDigit(fm.add_amt1.value));
			if(toInt(parseDigit(fm.add_amt1.value)) != 0 && fm.add_st1.value == '2')	tot_add2 = tot_add2 + toInt(parseDigit(fm.add_amt1.value));
			if(toInt(parseDigit(fm.add_amt2.value)) != 0 && fm.add_st2.value == '1')	tot_add1 = tot_add1 + toInt(parseDigit(fm.add_amt2.value));
			if(toInt(parseDigit(fm.add_amt2.value)) != 0 && fm.add_st2.value == '2')	tot_add2 = tot_add2 + toInt(parseDigit(fm.add_amt2.value));
			if(toInt(parseDigit(fm.add_amt3.value)) != 0 && fm.add_st3.value == '1')	tot_add1 = tot_add1 + toInt(parseDigit(fm.add_amt3.value));
			if(toInt(parseDigit(fm.add_amt3.value)) != 0 && fm.add_st3.value == '2')	tot_add2 = tot_add2 + toInt(parseDigit(fm.add_amt3.value));
			
			fm.add_tot_amt.value = parseDecimal(toInt(parseDigit(fm.add_amt1.value)) + toInt(parseDigit(fm.add_amt2.value)) + toInt(parseDigit(fm.add_amt3.value))); 										
			fm.a_amt.value = parseDecimal(tot_add1);
			fm.b_amt.value = parseDecimal(toInt(parseDigit(fm.commi.value)) + toInt(parseDigit(fm.a_amt.value))); 
			
			fm.inc_amt.value = 0; 
			fm.res_amt.value = 0; 			

			fm.vat_amt.value = parseDecimal(th_rnd((toInt(parseDigit(fm.b_amt.value))) * per )); 			

			fm.c_amt.value = fm.vat_amt.value; 
						
			fm.e_amt.value = parseDecimal(tot_add2);
			fm.d_amt.value = parseDecimal(toInt(parseDigit(fm.b_amt.value)) + toInt(parseDigit(fm.c_amt.value)) + toInt(parseDigit(fm.e_amt.value))); 		
			
		<%}else{%>					
			
		if(fm.rec_incom_st.value == ''){			alert('소득구분을 선택하십시오.'); return;		}
		
		if(fm.rec_incom_st.value != ''){
			
			if(fm.rec_incom_st.value == '2'){
				per = 0.03;
			}else if(fm.rec_incom_st.value == '3'){
				per = 0.06;		//20180401부터 0.04->0.06 변경
				if(<%=AddUtil.getDate(4)%> > 20181231){
					per = 0.06;		//20190101부터 0.06->0.08 변경 -> 20190404 영업수당은 2019년 필요경비 70% 유지되는 경우라함 [0.06]
				}				
			}	
			
			fm.inc_per.value = per*100;
			fm.res_per.value = per*10;
			fm.tot_per.value = per*110;

			var tot_add1 = 0;//세전가감액
			var tot_add2 = 0;//세후가감액
			if(toInt(parseDigit(fm.add_amt1.value)) != 0 && fm.add_st1.value == '1')	tot_add1 = tot_add1 + toInt(parseDigit(fm.add_amt1.value));
			if(toInt(parseDigit(fm.add_amt1.value)) != 0 && fm.add_st1.value == '2')	tot_add2 = tot_add2 + toInt(parseDigit(fm.add_amt1.value));
			if(toInt(parseDigit(fm.add_amt2.value)) != 0 && fm.add_st2.value == '1')	tot_add1 = tot_add1 + toInt(parseDigit(fm.add_amt2.value));
			if(toInt(parseDigit(fm.add_amt2.value)) != 0 && fm.add_st2.value == '2')	tot_add2 = tot_add2 + toInt(parseDigit(fm.add_amt2.value));
			if(toInt(parseDigit(fm.add_amt3.value)) != 0 && fm.add_st3.value == '1')	tot_add1 = tot_add1 + toInt(parseDigit(fm.add_amt3.value));
			if(toInt(parseDigit(fm.add_amt3.value)) != 0 && fm.add_st3.value == '2')	tot_add2 = tot_add2 + toInt(parseDigit(fm.add_amt3.value));
			
			
			fm.add_tot_amt.value = parseDecimal(toInt(parseDigit(fm.add_amt1.value)) + toInt(parseDigit(fm.add_amt2.value)) + toInt(parseDigit(fm.add_amt3.value))); 										
			fm.a_amt.value = parseDecimal(tot_add1);
			fm.b_amt.value = parseDecimal(toInt(parseDigit(fm.commi.value)) + toInt(parseDigit(fm.a_amt.value))); 							
			
			fm.inc_amt.value = parseDecimal(th_rnd((toInt(parseDigit(fm.b_amt.value))) * per )); 
			fm.res_amt.value = parseDecimal(th_rnd(toInt(parseDigit(fm.inc_amt.value)) * 0.1 )); 			
			fm.c_amt.value = parseDecimal(toInt(parseDigit(fm.inc_amt.value)) + toInt(parseDigit(fm.res_amt.value))); 
						
			fm.e_amt.value = parseDecimal(tot_add2);
			fm.d_amt.value = parseDecimal(toInt(parseDigit(fm.b_amt.value)) - toInt(parseDigit(fm.c_amt.value)) + toInt(parseDigit(fm.e_amt.value))); 
			
		}
		<%}%>
	}
	
	function save(){
		var fm = document.form1;
		
		<%if(a_co_bean.getDoc_st().equals("2")){%>
		
		<%}else{%>			
	
		if(fm.emp_acc_nm.value == '')		{	alert('실수령인 이름을 입력하여 주십시오.'); 				return;		}
		if(fm.rel.value == '')			{	alert('실수령인의 영업사원과의 관계를 입력하여 주십시오.'); 		return;		}
		if(fm.rec_incom_yn.value == '')		{	alert('실수령인의 타소득여부를 입력하여 주십시오.'); 			return;		}
		if(fm.rec_incom_st.value == '')		{	alert('실수령인의 소득구분를 입력하여 주십시오.'); 			return;		}
		if(fm.emp_bank_cd.value == '')		{	alert('실수령 은행을 입력하여 주십시오.'); 				return;		}
		if(fm.emp_acc_no.value == '')		{	alert('실수령 계좌번호를 입력하여 주십시오.'); 				return;		}
		if(fm.rec_ssn.value == '')		{	alert('실수령인의 주민번호를 입력하여 주십시오.'); 			return;		}
		if(fm.t_zip.value == '')		{	alert('실수령인의 우편번호를 입력하여 주십시오.'); 			return;		}
		if(fm.t_addr.value == '')		{	alert('실수령인의 주소를 입력하여 주십시오.'); 				return;		}
		
		//주민번호 세부 확인
		if(!jumin_No()){
			return;
		}
		
		<%}%>
		
		if(fm.b_amt.value == '0')		{	alert('소득금액을 확인하십시오.'); 					return;		}
		if(fm.c_amt.value == '0')		{	alert('공제금액을 확인하십시오.'); 					return;		}		
		if(fm.d_amt.value == '0')		{	alert('세후지급액을 확인하십시오.'); 					return;		}		
				
		set_amt();

		if(confirm('등록 하시겠습니까?')){	
			
			var link = document.getElementById("submitLink");
			var originFunc = link.getAttribute("href");
			link.setAttribute('href',"javascript:alert('처리 중입니다. 잠시만 기다려주세요');");
		
			fm.action='commi_doc_proxy_i_a.jsp';		
			fm.target='d_content';			
			fm.submit();
			
			link.getAttribute('href',originFunc);
		}							
	}		
	
	//주민등록번호 체크

 	var errfound = false;

	function jumin_No(){
		var fm = document.form1;
		
		var ssn = '';
		var ssn1 = '';
		var ssn2 = '';
		
		ssn = replaceString('-','',fm.rec_ssn.value);
		
		ssn1 = ssn.substr(0, 6);
		ssn2 = ssn.substr(6);
		
		var str_len ;
    		var str_no = ssn1+ssn2;

    		str_len = str_no.length;
    		
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
			errfound = false;          
		}else{
			//alert('올바른 주민등록 번호입니다.');
			errfound = true;
		}    				
		
		return errfound;	
	}	
	

//-->
</script>
</head>

<body leftmargin="15">
<form action="" name="form1" method="POST">
  <input type='hidden' name="rent_mng_id" 	value="<%=rent_mng_id%>">
  <input type='hidden' name="rent_l_cd" 	value="<%=rent_l_cd%>">
  <input type='hidden' name="from_page" 	value="<%=from_page%>">
  <input type='hidden' name="emp_id" 		value="<%=emp1.getEmp_id()%>">
  <input type='hidden' name='gubun1'  			value='<%=gubun1%>'>    
  <input type='hidden' name="agnt_st" 		value="4">    
  <input type='hidden' name="file_st" 		value="">    
  <input type='hidden' name="s_file_name1"	value="">      
  <input type='hidden' name="s_file_name2"	value="">      
  <input type='hidden' name="s_file_gubun1"	value="">      
  <input type='hidden' name="s_file_gubun2"	value="">          
  <input type='hidden' name="agent_doc_st"	value="<%=a_co_bean.getDoc_st()%>">

	
    
  
<table width="100%" border="0" cellspacing="0" cellpadding="0">
    <tr> 
        <td>
            <table width=100% border=0 cellpadding=0 cellspacing=0>
                <tr>
                    <td width=7><img src=/acar/images/center/menu_bar_1.gif width=7 height=33></td>
                    <td class=bar>&nbsp;&nbsp;&nbsp;<img src=/acar/images/center/menu_bar_dot.gif width=4 height=5 align=absmiddle>&nbsp;영업지원 > 계출관리 > 영업수당지급요청 > <span class=style1><span class=style5>영업대리인 등록 </span></span></td>
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
                <tr> 
                    <td class=title width=10%>계약번호</td>
                    <td >&nbsp;<%=rent_l_cd%></td>
		        </tr>		
		    </table>
	    </td>
	</tr> 
	<tr>
	    <td align="right"></td>
	</tr> 
	<tr> 
        <td class=line2></td>
    </tr> 
    <%if(a_co_bean.getDoc_st().equals("2")){ //에이전트-세금계산서 발행분%>
    <input type="hidden" name="rel" value="에이전트">
    <input type="hidden" name="rec_incom_yn" value="">
    <input type="hidden" name="rec_incom_st" value="">
    <input type="hidden" name="rec_ssn" value="<%=a_co_bean.getEnp_no()%>">
    <input type="hidden" name="emp_bank" value="<%=a_co_bean.getBank()%>">
    <input type="hidden" name="emp_bank_cd" value="<%=a_co_bean.getBank_cd()%>">
    <input type="hidden" name="emp_acc_no" value="<%=a_co_bean.getAcc_no()%>">
    <input type="hidden" name="emp_acc_nm" value="<%=a_co_bean.getAcc_nm()%>">
    <input type="hidden" name="t_zip" value="<%=a_co_bean.getCar_off_post()%>">
    <input type="hidden" name="t_addr" value="<%=a_co_bean.getCar_off_addr()%>">
    <tr> 
        <td class=line> 
            <table border="0" cellspacing="1" cellpadding='0' width=100%>
                <tr> 
                    <td width=3% rowspan="3" class=title>영<br>업<br>담<br>당</td>
                    <td class=title width=7%>상호/성명</td>
                    <td width=15%>&nbsp;<%=a_co_bean.getCar_off_nm()%></td>
                    <td class=title width=10%>구분</td>
                    <td width=15%>&nbsp;
                        <%if(a_co_bean.getCar_off_st().equals("3")){%>법인<%}%>
                    	<%if(a_co_bean.getCar_off_st().equals("4")){%>개인사업자<%}%>
                    </td>
                    <td class=title width=10%>사업자/생년월일</td>
                    <td width=15%>&nbsp;<%=AddUtil.ChangeEnpH(a_co_bean.getEnp_no())%></td>
                    <td class=title width=10%>거래증빙</td>
                    <td width=15%>&nbsp;
        		<%if(a_co_bean.getDoc_st().equals("1")){%>원천징수<%}%>
                    	<%if(a_co_bean.getDoc_st().equals("2")){%>세금계산서<%}%>
                    </td>
		        </tr>	
                <tr> 
                    <td class=title>거래은행</td>
                    <td width=15%>&nbsp;<%=a_co_bean.getBank()%></td>
                    <td class=title width=10%>계좌번호</td>
                    <td>&nbsp;<%=a_co_bean.getAcc_no()%></td>
                    <td class=title width=10%>예금주</td>
                    <td colspan="3">&nbsp;<%=a_co_bean.getAcc_nm()%></td>                    
		</tr>	
                <tr> 
                    <td class=title>주소</td>
                    <td colspan="7">&nbsp;<%=a_co_bean.getCar_off_post()%>
        			   &nbsp;<%=a_co_bean.getCar_off_addr()%></td>
		        </tr>	
		    </table>
	    </td>
	</tr> 
    <tr> 
        <td class=h></td>
    </tr>	 				 	 	    
    <%}else{%>       
    <tr> 
        <td class=line> 
            <table border="0" cellspacing="1" cellpadding='0' width=100%>
                <tr> 
                    <td width=3% rowspan="3" class=title>영<br>업<br>담<br>당</td>
                    <td class=title width=7%>실수령인</td>
                    <td width=15%>&nbsp;<input type='text' name="emp_acc_nm" value='<%//=emp1.getEmp_acc_nm()%>' size="12" class='text' readonly>					  
					  <a href="javascript:search_bank_acc()"><span title="<%//=emp1.getEmp_nm()%> 영업사원의 실수령인을 조회합니다."><img src=/acar/images/center/button_in_search.gif align=absmiddle border=0></span></a>					  
					</td>
                    <td class=title width=10%>관계</td>
                    <td width=15%>&nbsp;<input type='text' name="rel" value='<%//=emp1.getRel()%>' size="16" class='text' readonly></td>
                    <td class=title width=10%>타소득</td>
                    <td width=15%>&nbsp;
        			  <select name="rec_incom_yn">
                        <option value="">==선택==</option>
        				<option value="1">유</option>
        				<option value="2" selected>무</option>							
        			  </select>
        			</td>
                    <td class=title width=10%>소득구분</td>
                    <td width=15%>&nbsp;
        			  <select name="rec_incom_st" onChange="javascript:set_amt()">
                        <option value="">==선택==</option>
        				<option value="2" >사업소득</option>
        				<option value="3" >기타사업소득</option>							
        			  </select>
                    </td>
		        </tr>	
                <tr> 
                    <td class=title>거래은행</td>
                    <td width=15%>&nbsp;
                    	<input type='hidden' name="emp_bank" 			value="<%//=emp1.getEmp_bank()%>">
                    	<select name='emp_bank_cd'>
                        <option value=''>선택</option>
                        <%	if(bank_size > 0){
        											for(int i = 0 ; i < bank_size ; i++){
        												CodeBean bank = banks[i];
        												//신규인경우 미사용은행 제외
																if(bank.getUse_yn().equals("N"))	 continue;
        								%>
                        <option value='<%= bank.getCode()%>' ><%=bank.getNm()%></option><!-- <%if(emp1.getEmp_bank().equals(bank.getNm())||emp1.getBank_cd().equals(bank.getCode())){%> selected <%}%> -->
                        <%		}
        					}%>
                      </select></td>
                    <td class=title width=10%>계좌번호</td>
                    <td colspan="3">&nbsp;<input type='text' name="emp_acc_no" value='<%//=emp1.getEmp_acc_no()%>' size="31" class='text' readonly></td>
                    <td class=title width=10%>주민번호</td>
                    <td width=15%>&nbsp;<input type='text' name="rec_ssn" value='' size="16" class='text' readonly></td>
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
                    <td class=title>주소</td>
                    <td colspan="3">&nbsp;
					<input type="text" name="t_zip"  id="t_zip" size="7" maxlength='7' value="" readonly>
					<input type="button" onclick="openDaumPostcode()" value="우편번호 찾기"><br>
					&nbsp;<input type="text" name="t_addr" id="t_addr" size="65" value="" readonly>
					</td>
                    <td class=title width=10%>신분증사본</td>
                    <td width=15%>&nbsp;
                    	<%
				content_seq  = rent_mng_id+""+rent_l_cd+"4"+"1";

				attach_vt = c_db.getAcarAttachFileList(content_code, content_seq, 0);		
				attach_vt_size = attach_vt.size();		                    	
                    	%>
                    	
						<%if(attach_vt_size > 0){%>
			    			<%	for (int j = 0 ; j < attach_vt_size ; j++){
    								Hashtable ht = (Hashtable)attach_vt.elementAt(j);    						
    						%>
    							&nbsp;<a href="javascript:openPopP('<%=ht.get("FILE_TYPE")%>','<%=ht.get("SEQ")%>');" title='보기' ><%=ht.get("FILE_NAME")%></a>
    							&nbsp;<a href="https://fms3.amazoncar.co.kr/fms2/attach/delete.jsp?SEQ=<%=ht.get("SEQ")%>" target='_blank'><img src="/acar/images/center/button_in_delete.gif" align="absmiddle" border="0"></a>    						
    						<%	}%>		
    						<%}else{%>   
    						<a href="javascript:scan_reg('1')"><img src=/acar/images/center/button_in_reg.gif border=0 align=absmiddle></a>&nbsp;&nbsp;                                                                    
    						<%}%>                                            
                    </td>
                    <td class=title width=10%>통장사본</td>
                    <td width=15%>&nbsp;
                    	<%
				content_seq  = rent_mng_id+""+rent_l_cd+"4"+"2";

				attach_vt = c_db.getAcarAttachFileList(content_code, content_seq, 0);		
				attach_vt_size = attach_vt.size();		                    	
                    	%>
                    	
						<%if(attach_vt_size > 0){%>
			    			<%	for (int j = 0 ; j < attach_vt_size ; j++){
    								Hashtable ht = (Hashtable)attach_vt.elementAt(j);    						
    						%>
    							&nbsp;<a href="javascript:openPopP('<%=ht.get("FILE_TYPE")%>','<%=ht.get("SEQ")%>');" title='보기' ><%=ht.get("FILE_NAME")%></a>
    							&nbsp;<a href="https://fms3.amazoncar.co.kr/fms2/attach/delete.jsp?SEQ=<%=ht.get("SEQ")%>" target='_blank'><img src="/acar/images/center/button_in_delete.gif" align="absmiddle" border="0"></a>    						
    						<%	}%>		
    						<%}else{%>   
    						<a href="javascript:scan_reg('2')"><img src=/acar/images/center/button_in_reg.gif border=0 align=absmiddle></a>&nbsp;&nbsp;                                                                    
    						<%}%>                                              
                    </td>
		</tr>	
            </table>
	</td>
    </tr>  	 
    <tr>
	<td style='height:18'><span class=style4>&nbsp;<font color=red>* 실수령인은 꼭 조회해서 등록하십시오. 실수령인에 조회 데이타가 없거나 내용변경이 있으면 영업관리-영업사원관리-영업사원관리에서 실수령인을 등록(수정)하십시오.</font></span> </td>
    </tr>
	<tr>
	    <td style='height:18'><span class=style4>&nbsp;* 영업사원과 실수령인 이름이 같고 영업사원에 <b>신분증,통장 사본</b>이 있으면 별도 등록하지 않아도 등록처리시 끌어옵니다.</span> </td>
	</tr>			  	
	<tr>
	    <td style='height:18'><span class=style4>&nbsp;* 은행 : 계약관리에 입력한 정보이며, 계약관리에서 입력한 정보가 없을 때에는 영업사원에 있는 은행정보를 가져옵니다.</span> </td>
	</tr>			  	
	<%}%>
	<tr>
	    <td align="right">&nbsp;</td>
	</tr>
	<tr> 
        <td class=line2></td>
    </tr> 
    <tr>
        <td class=line> 
            <table border="0" cellspacing="1" cellpadding='0' width=100%>
                <tr> 
                    <td colspan="2" class=title>구분</td>
                    <td class=title width=12%>금액</td>
                    <td class=title width=10%>세율</td>
                    <td width=3% rowspan="<%if(a_co_bean.getDoc_st().equals("2")){%>4<%}else{%>6<%}%>" class=title>가<br>감<br></td>
                    <td class=title width=12%>구분</td>
                    <td class=title width=10%>금액</td>			
                    <td class=title width=40%>적요</td>
                </tr>	
                <tr> 
                    <td width="3%" rowspan="3" class=title><%if(a_co_bean.getDoc_st().equals("2")){%>지<br>급<br>수<br>수<br>료<br><%}else{%>과<br>
                      세<br>기<br>준<br><%}%></td>
                    <td width="10%" class=title>영업대리수당</td>
                    <td align="center"><input type='text' name='commi' maxlength='10' value='<%if(base.getBus_st().equals("7") && cont_etc.getBus_agnt_id().equals("")){%>100,000<%}%>' class='whitenum' size='10' onBlur='javascript:this.value=parseDecimal(this.value); set_amt();'></td>
                    <td align="center">&nbsp;</td>
                    <td align="center">&nbsp;
        			  <select name="add_st1" onchange="javascript:set_amt()">
                        <option value="">==선택==</option>
        				<option value="1">세전</option>
        				<%if(!a_co_bean.getDoc_st().equals("2")){%><option value="2">세후</option><%}%>
        			  </select>
        			</td>			
                    <td align="center"><input type='text' name='add_amt1' maxlength='8' value='' class='num' size='8' onBlur='javascript:this.value=parseDecimal(this.value); set_amt();'></td>
                    <td>&nbsp;
                      <input name="add_cau1" type="text" class="num" id="add_cau1" value="<%=emp4.getAdd_cau1()%>" size="50"></td>
                </tr>
                <tr>
                  <td class=title style="font-size : 8pt;">세전가감액</td>
                    <td align="center"><input type='text' name='a_amt' maxlength='8' value='' class='num' size='10' onBlur='javascript:this.value=parseDecimal(this.value);'></td>
                    <td align="center">&nbsp;</td>
                    <td align="center">&nbsp;
        			  <select name="add_st2" onchange="javascript:set_amt()">
                        <option value="">==선택==</option>
        				<option value="1" <%if(emp4.getAdd_st2().equals("1"))%>selected<%%>>세전</option>
        				<%if(!a_co_bean.getDoc_st().equals("2")){%><option value="2" <%if(emp4.getAdd_st2().equals("2"))%>selected<%%>>세후</option><%}%>
        			  </select>
        			</td>			
                    <td align="center"><input type='text' name='add_amt2' maxlength='8' value='<%=Util.parseDecimal(emp4.getAdd_amt2())%>' class='num' size='8' onBlur='javascript:this.value=parseDecimal(this.value); set_amt();'></td>
                    <td>&nbsp;
                    <input name="add_cau2" type="text" class="text" value="<%=emp4.getAdd_cau2()%>" size="50"></td>
                </tr>
                <tr>
                  <td class=title style="font-size : 8pt;">소계</td>
                    <td align="center"><input type='text' name='b_amt' maxlength='8' value='' class='num' size='10' onBlur='javascript:this.value=parseDecimal(this.value);'></td>
                    <td align="center">&nbsp;</td>
                    <td align="center">&nbsp;
        			  <select name="add_st3" onchange="javascript:set_amt()">
                        <option value="">==선택==</option>
        				<option value="1" <%if(emp4.getAdd_st3().equals("1"))%>selected<%%>>세전</option>
        				<%if(!a_co_bean.getDoc_st().equals("2")){%><option value="2" <%if(emp4.getAdd_st3().equals("2"))%>selected<%%>>세후</option><%}%>
        			  </select>
        			</td>			
                    <td align="center"><input type='text' name='add_amt3' maxlength='8' value='<%=Util.parseDecimal(emp4.getAdd_amt3())%>' class='num' size='8' onBlur='javascript:this.value=parseDecimal(this.value); set_amt();'></td>
                    <td>&nbsp;
                    <input name="add_cau3" type="text" class="text" value="<%=emp4.getAdd_cau3()%>" size="50"></td>
                </tr>
                <%if(a_co_bean.getDoc_st().equals("2")){%>
                <tr>
                    <td colspan="2" class=title>VAT</td>
                    <td align="center"><input type='text' name='vat_amt' maxlength='8' value='' class='num' size='10' onBlur='javascript:this.value=parseDecimal(this.value);'>
                    </td>
                    <td align="center"><input type='text' name='vat_per' maxlength='3' value='' class='num' size='3' onBlur='javascript:this.value=parseDecimal(this.value); set_amt();'>%</td>
                    <td width=3% class=title>소계</td>
                    <td>&nbsp;</td>
                    <td align="center"><input type='text' name='add_tot_amt' maxlength='8' value='' class='num' size='8' onBlur='javascript:this.value=parseDecimal(this.value); set_amt();'></td>
                    <td>&nbsp;</td>                    
                </tr> 
                <input type="hidden" name="inc_amt" value="<%=Util.parseDecimal(emp4.getInc_amt())%>">
                <input type="hidden" name="inc_per" value="">
                <input type="hidden" name="res_amt" value="<%=Util.parseDecimal(emp4.getRes_amt())%>">
                <input type="hidden" name="res_per" value="">
                <input type="hidden" name="c_amt" value="<%=Util.parseDecimal(emp4.getTot_amt())%>">
                <input type="hidden" name="tot_per" value="">
                <input type="hidden" name="e_amt" value="">
                <%}else{%>      
                <tr>
                    <td rowspan="3" class=title>원<br>천<br>징<br>수</td>
                    <td class=title>소득세</td>
                    <td align="center"><input type='text' name='inc_amt' maxlength='8' value='<%=Util.parseDecimal(emp4.getInc_amt())%>' class='num' size='10' onBlur='javascript:this.value=parseDecimal(this.value);'></td>
                    <td align="center"><input type='text' name='inc_per' maxlength='3' value='' class='num' size='3' onBlur='javascript:this.value=parseDecimal(this.value); set_amt();'>%</td>
                    <td align="center">-</td>
                    <td align="center">-</td>
                    <td>&nbsp;</td>
                </tr>
                <tr>
                    <td class=title>지방세</td>
                    <td align="center"><input type='text' name='res_amt' maxlength='8' value='<%=Util.parseDecimal(emp4.getRes_amt())%>' class='num' size='10' onBlur='javascript:this.value=parseDecimal(this.value);'></td>
                    <td align="center"><input type='text' name='res_per' maxlength='3' value='' class='num' size='3' onBlur='javascript:this.value=parseDecimal(this.value); set_amt();'>%</td>
                    <td align="center">-</td>
                    <td align="center">-</td>
                    <td>&nbsp;</td>
                </tr>
                <tr>
                    <td class=title>소계</td>
                    <td align="center"><input type='text' name='c_amt' maxlength='8' value='<%=Util.parseDecimal(emp4.getTot_amt())%>' class='num' size='10' onBlur='javascript:this.value=parseDecimal(this.value);'></td>
                    <td align="center"><input type='text' name='tot_per' maxlength='3' value='' class='num' size='3' onBlur='javascript:this.value=parseDecimal(this.value);'>%</td>
                    <td width=3% class=title>소계</td>
                    <td>&nbsp;</td>
                    <td align="center"><input type='text' name='add_tot_amt' maxlength='8' value='' class='num' size='8' onBlur='javascript:this.value=parseDecimal(this.value); set_amt();'></td>
                    <td>&nbsp;</td>
                </tr>
                <tr>
                    <td colspan="2" class=title>세후가감액</td>
                    <td align="center"><input type='text' name='e_amt' maxlength='8' value='' class='num' size='10' onBlur='javascript:this.value=parseDecimal(this.value);'>
                    </td>
                    <td colspan="5">&nbsp;  </td>
                </tr>
                <%}%>
                <tr>
                  <td colspan="2" class=title>실지급액</td>
                  <td align="center"><input type='text' name='d_amt' maxlength='8' value='' class='num' size='10' onBlur='javascript:this.value=parseDecimal(this.value);'></td>
                  <td colspan="5">&nbsp;실지급액  = 과세기준액 -  원천징수세액 + 세후가감액</td>
                </tr>	
		    </table>
	    </td>
	</tr>  
	<tr>
	    <td style='height:18'><span class=style4>&nbsp;* 가감 : 영업대리수당외에 추가로 지급되는 것 또는 공제해야 되는 것에 대한 내용입니다.</span> </td>
	</tr>			  	

    <tr>
	    <td align='center'>
	    <a id="submitLink" href="javascript:save();"><img src=/acar/images/center/button_reg.gif align=absmiddle border=0></a>
	    </td>
	</tr>	

    <tr>
	    <td align='center'>&nbsp;</td>
	</tr>		
</table>
</form>
<script language="JavaScript">
<!--	
 	var fm = document.form1;
	<%if(coe_bean.getCust_st().equals("")){%>
		fm.rec_incom_st.value = '2';
	<%}%>
	
	set_amt();
	
//-->
</script>
</body>
</html>
<iframe src="about:blank" name="i_no" width="0" height="0" frameborder="0" noresize></iframe>

