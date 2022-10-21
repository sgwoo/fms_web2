<%@ page language="java" contentType="text/html;charset=euc-kr" %>
<%@ page import="java.util.*, acar.util.*"%>
<%@ include file="/acar/cookies.jsp" %>

<html>
<head>
<title>고객등록</title>
<meta http-equiv="Content-Type" content="text/html; charset=euc-kr">
<link rel=stylesheet type="text/css" href="../include/table.css">
<script language='JavaScript' src='/include/common.js'></script>
<script language='javascript'>
<!--
	//우편번호 검색
	function search_zip(str){
		window.open("./s_zip.jsp?idx="+str, "ZIP", "left=300, top=300, height=300, width=350, scrollbars=yes");
	}
		
	//사업장주소 본점 상동	
	function set_o_addr(){
		var fm = document.form1;
		if(fm.c_ho.checked == true){
			fm.zip[2].value = fm.zip[1].value;
			fm.addr[2].value = fm.addr[1].value;
		}else{
			fm.zip[2].value = '';
			fm.addr[2].value = '';
		}
	}
	
	function save(){
		var fm = document.form1;	
		//NN check
		if	   (fm.firm_nm.value == '')			{	alert('상호를 입력하십시오');				return;	}
		else if(fm.client_nm.value == '')		{	alert('고객명을 입력하십시오');				return;	}			
		else if((fm.ssn1.value == '') || (fm.ssn2.value == '')){	
													alert('주민(법인)등록번호를 입력하십시오'); return; }
		else if(fm.client_st.value == '1'){//법인
			if((fm.enp_no1.value == '') || (fm.enp_no2.value == '') || (fm.enp_no3.value == '')){ 
													alert('사업자등록번호를 입력하십시오'); 	return; }
			else if(fm.addr[1].value == '')		{ 	alert('본점 소재지를 입력하십시오'); 		return; }
			else if(fm.addr[2].value == '')		{ 	alert('사업장 주소를 입력하십시오'); 		return; }
			else if(fm.bus_cdt.value == '')		{ 	alert('업태를 입력하십시오'); 				return; }
			else if(fm.bus_itm.value == '')		{ 	alert('종목를 입력하십시오'); 				return; }
			else if(fm.open_year.value == '')	{ 	alert('개업년월일을 입력하십시오'); 		return; }
		}		
			
		if(confirm('등록하시겠습니까?')){
			fm.target='i_no';
			fm.submit();
		}
	}
//-->
</script>
</head>
<body leftmargin="15" onload="javascript:document.form1.firm_nm.focus();">

<form name='form1' action='./s_client_i_a.jsp' method='post'>
<input type='hidden' name='h_page_gubun' value='NEW'><!--새로운 고객을 세팅한다는 의미-->
<table border=0 cellspacing=0 cellpadding=0 width='600'>
  <tr>
    <td><font color="navy">[ 고객 등록 ]</font></td>
  </tr>
  <tr>
    <td class='line'>            
        <table border="0" cellspacing="1" cellpadding='0' width=600>
          <tr> 
            <td colspan="2" class='title'> 고객구분</td>
            <td colspan='3' align='left'>&nbsp; 
              <select name='client_st'>
                <option value='1'>법인</option>
                <option value='2'>개인</option>
                <option value='3'>개인사업자(일반과세)</option>
                <option value='4'>개인사업자(간이과세)</option>
                <option value='5'>개인사업자(면세사업자)</option>
              </select>
            </td>
          </tr>
          <tr> 
            <td colspan="2" class='title'>상호</td>
            <td colspan='3'>&nbsp; 
              <input type='text' name='firm_nm' size="50" maxlength='50' class='text' value='' style='IME-MODE: active'>
            </td>
          </tr>
          <tr> 
            <td colspan="2" class='title'>법인등록번호</td>
            <td>&nbsp; 
              <input type='text' name='ssn1' value='' size="6" class='text' maxlength='6'>
              - 
              <input type='text' name='ssn2' size="7" class='text' maxlength='7' value=''>
            </td>
            <td class="title">사업자등록번호</td>
            <td>&nbsp; 
              <input type='text' name='enp_no1' value='' size='3' class='text' maxlength='3'>
              - 
              <input type='text' name='enp_no2' value='' size='2' class='text' maxlength='2'>
              - 
              <input type='text' name='enp_no3' value='' size='5' class='text' maxlength='5'>
            </td>
          </tr>
          <tr> 
            <td rowspan="3" class='title'>대표<br>
              이사 </td>
            <td width='100' class='title'>성명</td>
            <td width='179'>&nbsp; 
              <input type='text' name='client_nm' value='' size='20' maxlength='30' class='text' style='IME-MODE: active'>
            </td>
            <td width='126' class="title">주민번호</td>
            <td width='148'>&nbsp;  
              <input type='text' name="c_ssn1" value='' size="6" class='text' maxlength='6'>
              - 
              <input type='text' name='c_ssn2' size="7" class='text' maxlength='7' value=''>
            </td>
          </tr>
          <tr> 
            <td class='title'>자택전화번호</td>
            <td>&nbsp;  
              <input type='text' name='h_tel' value='' size='15' maxlength='15' class='text'>
              </td>
            <td class="title">핸드폰</td>
            <td>&nbsp;  
              <input type='text' name='m_tel' value='' size='15' maxlength='15' class='text'>
            </td>
          </tr>
		  <script src="https://t1.daumcdn.net/mapjsapi/bundle/postcode/prod/postcode.v2.js"></script>
				<script>
					function openDaumPostcode() {
						new daum.Postcode({
							oncomplete: function(data) {
								document.getElementById('zip').value = data.zonecode;
								document.getElementById('addr').value = data.roadAddress;
								
							}
						}).open();
					}
				</script>
          <tr> 
            <td class='title'>주소</td>
            <td colspan='3'>&nbsp; 
			<input type="text" name='zip' id="zip" size="7" maxlength='7'>
			<input type="button" onclick="openDaumPostcode()" value="우편번호 찾기"><br>
			&nbsp;&nbsp;<input type="text" name='addr' id="addr" size="50">
            </td>
          </tr>
          <tr> 
            <td colspan="2" class='title'>사무실전화번호</td>
            <td width="179">&nbsp; 
              <input type='text' name='o_tel' value='' size='15' maxlength='15' class='text'>
            </td>
            <td class='title' width="126">팩스번호</td>
            <td width="148">&nbsp; 
              <input type='text' name='fax' value='' size='15' maxlength='15' class='text'>
            </td>
          </tr>
          <tr> 
            <td colspan="2" class='title'>홈페이지</td>
            <td colspan='3'>&nbsp; 
              <input type='text' name='homepage' value='http://' size='58' maxlength='60' class='text' style='IME-MODE: inactive'>
            </td>
          </tr>
		  <script>
			function openDaumPostcode1() {
				new daum.Postcode({
					oncomplete: function(data) {
						document.getElementById('zip1').value = data.zonecode;
						document.getElementById('addr1').value = data.roadAddress;
						
					}
				}).open();
			}
		</script>
          <tr> 
            <td colspan="2" class='title'>본점소재지</td>
            <td colspan="3">&nbsp; 
              <input type="text" name='zip' id="zip1" size="7" maxlength='7'>
			<input type="button" onclick="openDaumPostcode1()" value="우편번호 찾기"><br>
			&nbsp;&nbsp;<input type="text" name='addr' id="addr1" size="50">
            </td>
          </tr>
		  <script>
			function openDaumPostcode2() {
				new daum.Postcode({
					oncomplete: function(data) {
						document.getElementById('zip2').value = data.zonecode;
						document.getElementById('addr2').value = data.roadAddress;
						
					}
				}).open();
			}
		</script>
          <tr> 
            <td height="26" colspan="2" class='title'>사업장주소</td>
            <td colspan="3" height="26">&nbsp; 
              <input type="text" name='zip' id="zip2" size="7" maxlength='7'>
			<input type="button" onclick="openDaumPostcode2()" value="우편번호 찾기"><br>
			&nbsp;&nbsp;<input type="text" name='addr' id="addr2" size="50">
              <input type='checkbox' name='c_ho' onClick='javascript:set_o_addr()'>
              본점상동</td>
          </tr>
          <tr> 
            <td colspan="2" class='title'>업태</td>
            <td colspan='3'>&nbsp; 
              <input type='text' name='bus_cdt' size='40' class='text' maxlength='40' value="" style='IME-MODE: active'>
            </td>
          </tr>
          <tr> 
            <td colspan="2" class='title'>종목</td>
            <td colspan='3'>&nbsp; 
              <input type='text' name='bus_itm' size='40' class='text' maxlength='40' value="">
            </td>
          </tr>
          <tr> 
            <td colspan="2" class='title'>개업년월일</td>
            <td colspan='3'>&nbsp; 
              <input type='text' name='open_year' size='12' class='text' maxlength='12' onBlur='javascript:this.value=ChangeDate(this.value)' value="">
            </td>
          </tr>
          <tr> 
            <td colspan="2" class='title'>자본금/기준일</td>
            <td colspan='3'>&nbsp; 
              <input type='text' name='firm_price' size='10' class='num' maxlength='20' onBlur='javascript:this.value=parseDecimal2(this.value);' value="">
              백만원 &nbsp;/ 
              <input type='text' name='firm_day' size='12' class='text' maxlength='12' onBlur='javascript:this.value=ChangeDate(this.value)' value="">
            </td>
          </tr>
          <tr> 
            <td colspan="2" class='title'>연매출/기준일</td>
            <td colspan='3'>&nbsp; 
              <input type='text' name='firm_price_y' size='10' class='num' maxlength='40' onBlur='javascript:this.value=parseDecimal2(this.value);' value="">
              백만원 /&nbsp; 
              <input type='text' name='firm_day_y' size='12' class='text' maxlength='12' onBlur='javascript:this.value=ChangeDate(this.value)' value="">
            </td>
          </tr>
        </table>
	</td>
  </tr>
  <tr height="30">
	  <td align='right'><a href='javascript:save()' onMouseOver="window.status=''; return true"><img src="../images/bbs/but_in.gif" width="50" height="18" aligh="absmiddle" border="0"></a> 
        &nbsp;&nbsp;<a href='javascript:history.go(-1);'><img src="../images/bbs/but_backgo.gif" width="70" height="18" aligh="absmiddle" border="0"></a> 
      </td>
  </tr>
</table>
</form>
<iframe src="about:blank" name="i_no" width="110" height="110" cellpadding="0" cellspacing="0" border="1" frameborder="0" noresize></iframe>
</body>
</html>