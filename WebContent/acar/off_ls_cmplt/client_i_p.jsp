<%@ page language="java" contentType="text/html;charset=euc-kr" %>
<%@ page import="java.util.*"%>
<%@ include file="/acar/cookies.jsp" %>

<html>
<head>
<title>FMS</title>
<link rel=stylesheet type="text/css" href="/include/table_t.css">
<script language='JavaScript' src='/include/common.js'></script>
<script language='javascript'>
<!--
	//우편번호 검색
	function search_zip(str){
		window.open("/acar/car_rent/zip_s.jsp?idx="+str, "ZIP", "left=100, top=100, height=500, width=400, scrollbars=yes");
	}
		
	//사업장주소 본점 상동	
	function set_o_addr(){
		var fm = document.form1;
		if(fm.c_ho.checked == true){
			fm.t_zip[1].value = fm.t_zip[0].value;
			fm.t_addr[1].value = fm.t_addr[0].value;
		}else{
			fm.t_zip[1].value = '';
			fm.t_addr[1].value = '';
		}
	}
	
	function save(){
		var fm = document.form1;	
		//NN check
		if(fm.t_firm_nm.value == '')		{	alert('상호를 입력하십시오');		return;	}
		if(fm.t_client_nm.value == '')		{	alert('고객명을 입력하십시오');		return;	}	
				
		if(fm.s_cl_gbn.value == '1'){//법인
			if((fm.t_enp_no1.value == '') || (fm.t_enp_no2.value == '') || (fm.t_enp_no3.value == '')){ alert('사업자등록번호를 입력하십시오'); return; }
			else if(fm.t_addr[0].value == '')	{ alert('본점 소재지를 입력하십시오'); 	return; }
			else if(fm.t_addr[1].value == '')	{ alert('사업장 주소를 입력하십시오'); 	return; }
			else if(fm.t_cdt.value == '')		{ alert('업태를 입력하십시오'); 		return; }
			else if(fm.t_itm.value == '')		{ alert('종목를 입력하십시오'); 		return; }			
		}else if(fm.s_cl_gbn.value == '2'){//개인
			if((fm.t_ssn1.value == '') || (fm.t_ssn2.value == '')){	alert('주민등록번호를 입력하십시오'); return; }
		}else{
			if(fm.t_ssn1.value == '')			{	alert('생년월일을 입력하십시오');			return;	}	
		}		
			
		if(fm.email_1.value != '' && fm.email_2.value != ''){
			fm.con_agnt_email.value = fm.email_1.value+'@'+fm.email_2.value;
		}
		
		if(confirm('등록하시겠습니까?')){
			fm.target='i_no';
			fm.submit();
		}
	}

//-->
</script>
</head>

<body leftmargin="15" onload="javascript:document.form1.t_firm_nm.focus();">
<form name='form1' action='client_i_a.jsp' method='post'>
<input type='hidden' name='h_map' value=''>
<input type='hidden' name='h_page_gubun' value='NEW'><!--새로운 고객을 세팅한다는 의미-->
<table border=0 cellspacing=0 cellpadding=0 width='100%'>
    <tr> 
        <td colspan=2>
            <table width=100% border=0 cellpadding=0 cellspacing=0>
                <tr>
                    <td width=7><img src=../images/center/menu_bar_1.gif width=7 height=33></td>
                    <td class=bar>&nbsp;&nbsp;&nbsp;<img src=../images/center/menu_bar_dot.gif width=4 height=5 align=absmiddle>&nbsp;<span class=style1>기초정보관리 > 계약관리 > 계약등록 > <span class=style5>고객등록</span></span></td>
                    <td width=7><img src=../images/center/menu_bar_2.gif width=7 height=33></td>
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
            <table border="0" cellspacing="1" cellpadding='0' width=100%>
                <tr> 
                    <td class='title'> 고객구분</td>
                    <td colspan='3' align='left'>&nbsp; 
                      <select name='s_cl_gbn'>
                        <option value='1'>법인</option>
                        <option value='2'>개인</option>
                        <option value='3'>개인사업자(일반과세)</option>
                        <option value='4'>개인사업자(간이과세)</option>
                        <option value='5'>개인사업자(면세사업자)</option>
        				<option value='7'>경매매각</option>
                      </select>
                    </td>
                </tr>
                <tr> 
                    <td class='title'>상호</td>
                    <td colspan='3'>&nbsp; 
                      <input type='text' name='t_firm_nm' size="30" maxlength='80' class='text' value=''>
                    </td>
                </tr>
                <tr> 
                    <td class='title'>이름/대표</td>
                    <td>&nbsp; 
                      <input type='text' name='t_client_nm' value='' size='20' maxlength='80' class='text' style='IME-MODE: active'>
                    </td>
                    <td class='title'>국적</td>
                    <td>&nbsp; 
                      <select name='nationality'>
                		            <option value="">선택</option>
                		            <option value="1">내국인</option>
                		            <option value="2">외국인</option>
                		          </select>
                		          (개인일때)
                    </td>
                </tr>
                <tr> 
                    <td class='title' >주민(법인)등록번호</td>
                    <td colspan='3'>&nbsp; 
                      <input type='text' name='t_ssn1' value='' size="6" class='text' maxlength='6'>
                      - 
                      <input type='text' name='t_ssn2' size="7" class='text' maxlength='7' value=''>
                    </td>
                </tr>
                <tr> 
                    <td class='title' height="2">사업자등록번호</td>
                    <td colspan='3' height="2">&nbsp; 
                      <input type='text' name='t_enp_no1' value='' size='3' class='text' maxlength='3'>
                      - 
                      <input type='text' name='t_enp_no2' value='' size='2' class='text' maxlength='2'>
                      - 
                      <input type='text' name='t_enp_no3' value='' size='5' class='text' maxlength='5'>
                    </td>
                </tr>
                <tr> 
                    <td class='title' width=22%>TEL(자택)</td>
                    <td width=28%>&nbsp; 
                      <input type='text' name='t_h_tel' value='' size='15' maxlength='15' class='text'>
                    </td>
                    <td class='title' width=22%>TEL(사무실)</td>
                    <td width=28%>&nbsp; 
                      <input type='text' name='t_o_tel' value='' size='15' maxlength='15' class='text'>
                    </td>
                </tr>
                <tr> 
                    <td class='title'>휴대폰</td>
                    <td>&nbsp; 
                      <input type='text' name='t_m_tel' value='' size='15' maxlength='15' class='text'>
                    </td>
                    <td class='title'>FAX</td>
                    <td>&nbsp; 
                      <input type='text' name='t_fax' value='' size='15' maxlength='15' class='text'>
                    </td>
                </tr>
                <tr> 
                    <td class='title'>Homepage</td>
                    <td colspan='3'>&nbsp; 
                      <input type='text' name='t_homepage' value='http://' size='30' maxlength='30' class='text' style='IME-MODE: inactive'>
                    </td>
                </tr>
                <tr> 
                    <td class='title'>E-mail</td>
                    <td colspan='3'>&nbsp; 
                      <input type='text' size='15' name='email_1' value='' maxlength='100' class='text' style='IME-MODE: inactive'>@<input type='text' size='20' name='email_2' value='' maxlength='100' class='text' style='IME-MODE: inactive'>
					  <select id="email_domain" align="absmiddle" onChange="javascript:document.form1.email_2.value=this.value;">
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
						<input type='hidden' name='con_agnt_email' value=''>
                    </td>
                </tr>
				<script src="https://t1.daumcdn.net/mapjsapi/bundle/postcode/prod/postcode.v2.js"></script>
				<script>
					function openDaumPostcode() {
						new daum.Postcode({
							oncomplete: function(data) {
								document.getElementById('t_zip').value = data.zonecode;
								document.getElementById('t_addr').value = data.address +" (" + data.buildingName +")" ;
								
							}
						}).open();
					}
				</script>
				<tr>
				  <td class=title>본점소재지</td>
				  <td colspan=5>&nbsp;
					<input type="text" name="t_zip" id="t_zip" size="7" maxlength='7' value="">
					<input type="button" onclick="openDaumPostcode()" value="우편번호 찾기"><br>
					&nbsp;&nbsp;<input type="text" name="t_addr" id="t_addr" size="70" value="">
				  </td>
				</tr>

				<script>
					function openDaumPostcode1() {
						new daum.Postcode({
							oncomplete: function(data) {
								document.getElementById('t_zip1').value = data.zonecode;
								document.getElementById('t_addr1').value = data.address +" (" + data.buildingName +")" ;
								
							}
						}).open();
					}
				</script>			
				<tr>
				  <td class=title>사업장주소</td>
				  <td colspan=5>&nbsp;<input type='checkbox' name='c_ho' onClick='javascript:set_o_addr()'>
                      본점상동
					<input type="text" name="t_zip" id="t_zip1" size="7" maxlength='7' value="">
					<input type="button" onclick="openDaumPostcode1()" value="우편번호 찾기"><br>
					&nbsp;&nbsp;<input type="text" name="t_addr" id="t_addr1" size="70" value="">
				  </td>
				</tr>
                <tr> 
                    <td class='title'>업태</td>
                    <td colspan='3'>&nbsp; 
                      <input type='text' name='t_cdt' size='20' class='text' maxlength='40' value="" style='IME-MODE: active'>
                    </td>
                </tr>
                <tr> 
                    <td class='title'>종목</td>
                    <td colspan='3'>&nbsp; 
                      <input type='text' name='t_itm' size='20' class='text' maxlength='40' value="">
                    </td>
                </tr>
                <tr> 
                    <td class='title'>개업년월일</td>
                    <td colspan='3'>&nbsp; 
                      <input type='text' name='t_open_year' size='12' class='text' maxlength='10' onBlur='javascript:this.value=ChangeDate(this.value)' value="">
                    </td>
                </tr>
                
            </table>
	    </td>
    </tr>
    <tr height="30">
	    <td align='right'><a href='javascript:save()' onMouseOver="window.status=''; return true"><img src=../images/center/button_conf.gif align=absmiddle border=0></a> 
        &nbsp;<a href='javascript:history.go(-1);'><img src=../images/center/button_list.gif align=absmiddle border=0></a> 
        </td>
    </tr>
</table>
</form>
<iframe src="about:blank" name="i_no" width="0" height="0" frameborder="0" noresize></iframe>
</body>
</html>