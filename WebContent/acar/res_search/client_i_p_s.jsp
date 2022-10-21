<%@ page language="java" contentType="text/html;charset=euc-kr" %>
<%@ page import="java.util.*"%>
<%@ include file="/acar/cookies.jsp" %>

<%
	String auth_rw = request.getParameter("auth_rw")==null?"":request.getParameter("auth_rw");
	String br_id = request.getParameter("br_id")==null?"":request.getParameter("br_id");
	String user_id = request.getParameter("user_id")==null?"":request.getParameter("user_id");
	String rent_st = request.getParameter("rent_st")==null?"":request.getParameter("rent_st");
	String cust_st = request.getParameter("cust_st")==null?"":request.getParameter("cust_st");
	
	String h_con = request.getParameter("h_con")==null?"":request.getParameter("h_con");
	String h_wd = request.getParameter("h_wd")==null?"":request.getParameter("h_wd");
%>

<html>
<head>
<title>FMS</title>
<link rel=stylesheet type="text/css" href="../../include/table.css">
<script language='JavaScript' src='/include/common.js'></script>
<script language='javascript'>
<!--
	//우편번호 검색
	function search_zip(str){
		window.open("./zip_s.jsp?str="+str, "ZIP", "left=100, top=100, height=500, width=400, scrollbars=yes");
	}
		
	function save(){
		var fm = document.form1;	
		if(fm.cust_nm.value == ''){		alert('계약자를 입력하십시오');	fm.cust_nm.focus(); return;	}
		else if((fm.ssn.value == '')){	alert('주민등록번호를 입력하십시오'); fm.ssn.focus(); return; }		
		else if((fm.zip.value == '')){	alert('우편번호를 입력하십시오'); return; }		
		else if((fm.addr.value == '')){	alert('주소를 입력하십시오'); return; }						
		else if((fm.m_tel.value == '')){alert('휴대폰을 입력하십시오'); fm.m_tel.focus(); return; }
		
		//운전면허번호 자리수체크 및 formating 로직 추가(2018.02.07)
		if(fm.lic_no.value!=""){
			var chk_lic_no_res = CheckLic_no(fm.lic_no.value);
			if(chk_lic_no_res=='N'){	return false;	}
		}
		
		if(confirm('등록하시겠습니까?')){
			fm.target='i_no';
			fm.submit();
		}				
	}
-->
</script>
</head>
<body leftmargin="15" onload="javascript:document.form1.cust_nm.focus();">
<form name='form1' action='./client_i_a.jsp' method='post'>
<input type='hidden' name='h_con' value='<%=h_con%>'>
<input type='hidden' name='h_wd' value='<%=h_wd%>'>
<input type='hidden' name='rent_st' value='<%=rent_st%>'>
<input type='hidden' name='auth_rw' value='<%=auth_rw%>'>
<input type='hidden' name='user_id' value='<%=user_id%>'>
<input type='hidden' name='br_id' value='<%=br_id%>'>
  <table border=0 cellspacing=0 cellpadding=0 width='720'>
    <tr>
      <td><font color="navy">예약시스템 -> 영업지원</font><font color="red">단기거래처 등록 </font></td>
  </tr>
  <tr>
      <td class='line'> 
        <table border="0" cellspacing="1" cellpadding="1" width=720>
          <tr> 
            <td class=title width="100"><font color="#FF0000">*</font>구분</td>
            <td> 
              <select name="cust_st">
                <option value="1">법인</option>
                <option value="2" selected>개인</option>
                <option value="3">개인사업자(일반과세)</option>
                <option value="4">개인사업자(간이과세)</option>
                <option value="5">개인사업자(면세사업자)</option>
              </select>
            </td>
          </tr>
          <tr> 
            <td class=title width="100"><font color="#FF0000">*</font>성명</td>
            <td> 
              <input type="text" name="cust_nm" value="" size="30" class=text>
            </td>
          </tr>
          <tr> 
            <td class=title width="100">상호</td>
            <td> 
              <input type="text" name="firm_nm" value="" size="50" class=text>
            </td>
          </tr>
          <tr> 
            <td class=title width="100"><font color="#FF0000">*</font>주민등록번호</td>
            <td> 
              <input type="text" name="ssn" value="" size="20" class=text>
            </td>
          </tr>
          <tr> 
            <td class=title width="100">사업자등록번호</td>
            <td> 
              <input type="text" name="enp_no" value="" size="20" class=text>
            </td>
          </tr>
		  <script src="https://t1.daumcdn.net/mapjsapi/bundle/postcode/prod/postcode.v2.js"></script>
			<script>
				function openDaumPostcode() {
					new daum.Postcode({
						oncomplete: function(data) {
							document.getElementById('zip').value = data.zonecode;
							document.getElementById('addr').value = data.address;
							
						}
					}).open();
				}
			</script>
          <tr> 
            <td class=title width="100"><font color="#FF0000">*</font>주소</td>
            <td> 
				<input type="text" name='zip' id="zip" size="7" maxlength='7'>
				<input type="button" onclick="openDaumPostcode()" value="우편번호 찾기"><br>
				&nbsp;&nbsp;<input type="text" name='addr' id="addr" size="80">
            </td>
          </tr>
          <tr> 
            <td class=title width="100">운전면허번호</td>
            <td> 
              <input type="text" name="lic_no" value="" size="20" class=text onBlur='javscript:this.value = ChangeLic_no(this.value);'>
            </td>
          </tr>
          <tr> 
            <td class=title width="100">운전면허종류</td>
            <td> 
              <select name="lic_st">
                <option value="1">1종보통</option>
                <option value="2" selected>2종보통</option>
              </select>
            </td>
          </tr>
          <tr> 
            <td class=title width="100">전화번호</td>
            <td> 
              <input type="text" name="tel" value="" class=text size="20">
            </td>
          </tr>
          <tr> 
            <td class=title width="100"><font color="#FF0000">*</font>휴대폰</td>
            <td> 
              <input type="text" name="m_tel" value="" size="20" class=text>
            </td>
          </tr>
          <tr> 
            <td class=title width="100">이메일주소</td>
            <td> 
              <input type="text" name="email" value="" size="50" class=text>
            </td>
          </tr>
          <tr> 
            <td class=title width="100">특이사항</td>
            <td> 
              <textarea name="etc" cols="90" class="text" rows="3"></textarea>
            </td>
          </tr>
        </table>
      </td>
  </tr>  
  <tr height="30">
	  <td align='right'>
	  <%if(auth_rw.equals("2") || auth_rw.equals("4") || auth_rw.equals("6")){%>
	    <a href='javascript:save()' onMouseOver="window.status=''; return true"><img src="/images/confirm.gif" width="50" height="18" aligh="absmiddle" border="0"></a>
      <%}%>
        &nbsp;&nbsp;<a href='javascript:history.go(-1);'><img src="/images/list.gif" width="50" height="18" aligh="absmiddle" border="0"></a> 
      </td>
  </tr>
</table>
</form>
<iframe src="about:blank" name="i_no" width="0" height="0" frameborder="0" noresize></iframe>
</body>
</html>