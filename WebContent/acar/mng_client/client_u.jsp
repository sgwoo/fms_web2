<%@ page language="java" contentType="text/html;charset=euc-kr" %>
<%@ page import="java.util.*, acar.client.*, acar.util.*"%>
<jsp:useBean id="al_db" scope="page" class="acar.client.AddClientDatabase"/>
<%@ include file="/acar/cookies.jsp" %>

<html>
<head><title>FMS</title>
<script language='javascript' src='/include/common.js'></script>
<script language='javascript'>
<!--
	function search_zip(str){
		window.open("/acar/common/zip_s.jsp?idx="+str, "ZIP", "left=100, top=200, height=500, width=400, scrollbars=yes");
	}	

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
	
	function modify(){
		var fm = document.form1;
		if(confirm('수정하시겠습니까?'))
		{
			if(!isNum(fm.t_ssn1.value))			{	alert('주민(법인)등록번호를 확인하십시오');	return;	}
			else if(!isNum(fm.t_ssn2.value))	{	alert('주민(법인)등록번호를 확인하십시오');	return;	}
			else if(!isNum(fm.t_enp_no1.value))	{	alert('사업자등록번호를 확인하십시오');	return;	}
			else if(!isNum(fm.t_enp_no2.value))	{	alert('사업자등록번호를 확인하십시오');	return;	}
			else if(!isNum(fm.t_enp_no3.value))	{	alert('사업자등록번호를 확인하십시오');	return;	}
			else if(!isTel(fm.t_h_tel.value))	{	alert('자택전화번호를 확인하십시오');	return;	}
			else if(!isTel(fm.t_o_tel.value))	{	alert('사무실전화번호를 확인하십시오');	return;	}
			else if(!isTel(fm.t_m_tel.value))	{	alert('이동전화번호를 확인하십시오');	return;	}
			else if(!isTel(fm.t_fax.value))		{	alert('팩스번호를 확인하십시오');	return;	}
			
			else if(!isTel(fm.mgr_tel1.value))		{	alert('차량관리자 전화번호를 확인하십시오');	return;	}
			else if(!isTel(fm.mgr_mobile1.value))	{	alert('차량관리자 휴대폰번호를 확인하십시오');	return;	}
			else if(!isTel(fm.mgr_tel2.value))		{	alert('차량관리자 전화번호를 확인하십시오');	return;	}
			else if(!isTel(fm.mgr_mobile2.value))	{	alert('차량관리자 휴대폰번호를 확인하십시오');	return;	}
			else if(!isTel(fm.mgr_tel3.value))		{	alert('차량관리자 전화번호를 확인하십시오');	return;	}
			else if(!isTel(fm.mgr_mobile3.value))	{	alert('차량관리자 휴대폰번호를 확인하십시오');	return;	}
			
			fm.target = 'i_no';
			fm.submit();
		}
	}
-->
</script>
<link rel=stylesheet type="text/css" href="../../include/table.css">
</head>
<body>
<%
	String auth_rw = request.getParameter("auth_rw")==null?"":request.getParameter("auth_rw");
	String br_id = request.getParameter("br_id")==null?"":request.getParameter("br_id");
	String user_id = request.getParameter("user_id")==null?"":request.getParameter("user_id");
	String s_kd = request.getParameter("s_kd")==null?"1":request.getParameter("s_kd");
	String t_wd = request.getParameter("t_wd")==null?"":request.getParameter("t_wd");
	String asc = request.getParameter("asc")==null?"0":request.getParameter("asc");
	
	String c_id = request.getParameter("c_id")==null?"":request.getParameter("c_id");
	
	ClientBean client = al_db.getClient(c_id);
%>
<form name='form1' action='/acar/mng_client/client_u_a.jsp' method='post'>
<input type='hidden' name='auth_rw' value='<%=auth_rw%>'>
<input type='hidden' name='br_id' value='<%=br_id%>'>
<input type='hidden' name='user_id' value='<%=user_id%>'>
<input type='hidden' name='s_kd' value='<%=s_kd%>'>
<input type='hidden' name='t_wd' value='<%=t_wd%>'>
<input type='hidden' name='asc' value='<%=asc%>'>
<input type='hidden' name='c_id' value='<%=c_id%>'>
<table border=0 cellspacing=0 cellpadding=0 width='800'>
	<tr>
		<td>
			<font color="navy">영업관리  -> </font><font color="navy">거래처 관리 -> </font><font color="red"> 거래처정보 수정</font>
		</td>
	</tr>
	<tr>
		<td align='right'><%if(auth_rw.equals("3") || auth_rw.equals("4") || auth_rw.equals("6")){%><a href='javascript:modify()'> 수정 </a><% } %></td>
	</tr>
    <tr>
        <td class='line'>
            
        <table border="0" cellspacing="1" cellpadding='0' width=800>
          <tr> 
            <td class='title' width='100'> 고객구분</td>
            <td width="170"> &nbsp; 
              <select name='s_cl_gbn'>
                <option value='1' <%if(client.getClient_st().equals("1")){%>selected<%}%>> 
                법인 </option>
                <option value='2' <%if(client.getClient_st().equals("2")){%>selected<%}%>> 
                개인 </option>
                <option value='3' <%if(client.getClient_st().equals("3")){%>selected<%}%>> 
                개인사업자(일반과세) </option>
                <option value='4' <%if(client.getClient_st().equals("4")){%>selected<%}%>> 
                개인사업자(간이과세) </option>
                <option value='5' <%if(client.getClient_st().equals("5")){%>selected<%}%>> 
                개인사업자(면세사업자)</option>
              </select>
            </td>
            <td class='title' width="90">사업자등록번호</td>
            <td width="175">&nbsp; 
              <input type='text' name='t_enp_no1' value='<%=client.getEnp_no1()%>' maxlength='3' size='3' class='text'>
              - 
              <input type='text' name='t_enp_no2' value='<%=client.getEnp_no2()%>' maxlength='2' size='2' class='text'>
              - 
              <input type='text' name='t_enp_no3' value='<%=client.getEnp_no3()%>' maxlength='5' size='5' class='text'>
            </td>
            <td class='title' width="90">생년월일<br>
              (법인번호)</td>
            <td width="175">&nbsp; 
              <input type='text' name='t_ssn1' value='<%=client.getSsn1()%>' size="6" maxlength='6' class='text'>
              - 
              <input type='text' name='t_ssn2' value='<%=client.getSsn2()%>' size="7" maxlength='7' class='text'>
            </td>
          </tr>
          <tr> 
            <td class='title'>상호</td>
            <td colspan='3'>&nbsp; 
              <input type='text' name='t_firm_nm' value='<%=client.getFirm_nm()%>' maxlength='30' size="30" class='text'>
            </td>
            <td class='title'>이름/대표</td>
            <td>&nbsp; 
              <input type='text' name='t_client_nm' value='<%=client.getClient_nm()%>' maxlength='20' size='10' class='text'>
            </td>
          </tr>
          <tr> 
            <td class='title'>자택전화번호</td>
            <td>&nbsp; 
              <input type='text' name='t_h_tel' value='<%=client.getH_tel()%>' size='15' maxlength='15' class='text'>
            </td>
            <td class='title'>사무실전화번호</td>
            <td>&nbsp; 
              <input type='text' name='t_o_tel' value='<%=client.getO_tel()%>' size='15' maxlength='15' class='text'>
            </td>
            <td class='title'>휴대폰</td>
            <td>&nbsp; 
              <input type='text' name='t_m_tel' value='<%=client.getM_tel()%>' size='15' maxlength='15' class='text'>
            </td>
          </tr>
          <tr> 
            <td class='title'>FAX</td>
            <td>&nbsp; 
              <input type='text' name='t_fax' value='<%=client.getFax()%>' size='15' maxlength='15' class='text'>
            </td>
            <td class='title'>Homepage</td>
            <td colspan='3'>&nbsp; 
              <input type='text' name='t_homepage' value='<%=client.getHomepage()%>' size='30' maxlength='30' class='text'>
            </td>
          </tr>
		  <script src="https://t1.daumcdn.net/mapjsapi/bundle/postcode/prod/postcode.v2.js"></script>
			<script>
				function openDaumPostcode() {
					new daum.Postcode({
						oncomplete: function(data) {
							document.getElementById('t_zip').value = data.zonecode;
							document.getElementById('t_addr').value = data.address +" ("+ data.buildingName+")";
							
						}
					}).open();
				}
			</script>			
			<tr>
			  <td class=title>본점소재지 주소</td>
			  <td colspan=3>&nbsp;
				<input type="text" name='t_zip' id="t_zip" size="7" value='<%=client.getHo_zip()%>' maxlength='7'>
				<input type="button" onclick="openDaumPostcode()" value="우편번호 찾기"><br>
				&nbsp;&nbsp;<input type="text" name='t_addr' id="t_addr" value='<%=client.getHo_addr()%>' size="100">
			  </td>
			</tr>
         <script>
				function openDaumPostcode1() {
					new daum.Postcode({
						oncomplete: function(data) {
							document.getElementById('t_zip1').value = data.zonecode;
							document.getElementById('t_addr1').value = data.address +" ("+ data.buildingName+")";
							
						}
					}).open();
				}
			</script>			
			<tr>
			  <td class=title>사업장 주소</td>
			  <td colspan=3>&nbsp;
				<input type="text" name='t_zip' id="t_zip1" size="7" value='<%=client.getO_zip()%>' maxlength='7'>
				<input type="button" onclick="openDaumPostcode1()" value="우편번호 찾기"><br>
				&nbsp;&nbsp;<input type="text" name='t_addr' id="t_addr1" value='<%=client.getO_addr()%>' size="100">
				<input type='checkbox' name='c_ho' onClick='javascript:set_o_addr()'>상동
			  </td>
			</tr>
          <tr> 
            <td class='title'>업태</td>
            <td>&nbsp; 
              <input type='text' name='t_cdt' size='20' maxlength='40' class='text' value='<%=client.getBus_cdt()%>'>
            </td>
            <td class='title'>종목</td>
            <td colspan='3'>&nbsp; 
              <input type='text' name='t_itm' size='40' maxlength='40' class='text' value='<%=client.getBus_itm()%>'>
            </td>
          </tr>
          <tr> 
            <td class='title'>개업년월일</td>
            <td>&nbsp; 
              <input type='text' name="t_open_year" value='<%= client.getOpen_year()%>' size='12' class='text' onBlur='javascript:this.value=ChangeDate(this.value)'>
            </td>
            <td class='title'>자본금/기준일</td>
            <td>&nbsp; 
              <input type='text' name='t_firm_price' size='5' class='num' maxlength='20' onBlur='javascript:this.value=parseDecimal2(this.value);' value="<%=AddUtil.parseDecimal(client.getFirm_price())%>">
              백만원 
              <input type='text' name='t_firm_day' size='12' class='text' maxlength='12' onBlur='javascript:this.value=ChangeDate(this.value)' value="<%=client.getFirm_day()%>">
            </td>
            <td class='title'>연매출/기준일</td>
            <td>&nbsp; 
              <input type='text' name='t_firm_price_y' size='5' class='num' maxlength='40' onBlur='javascript:this.value=parseDecimal2(this.value);' value="<%=AddUtil.parseDecimal(client.getFirm_price_y())%>">
              백만원 
              <input type='text' name='t_firm_day_y' size='12' class='text' maxlength='12' onBlur='javascript:this.value=ChangeDate(this.value)' value="<%=client.getFirm_day_y()%>">
            </td>
          </tr>		  
        </table>
		</td>
	</tr>
	<tr>
		<td>*차량관리자(해당업체 관련 모든 계약을 수정합니다)</td>
	</tr>
	<tr>
		<td class='line'>
            <table border="0" cellspacing="1" cellpadding='0' width=800>
				<tr>
                    <td class=title>구분</td>
                    <td class=title>근무부서</td>
                    <td class=title>성명</td>
                    <td class=title>직위</td>
                    <td class=title>전화번호</td>
                    <td class=title>휴대폰</td>
                    <td class=title>E-MAIL</td>
                </tr>
	            <tr>
                    <td align='center'><input type='text' name='mgr_st1'    size='9' value='차량이용자' class='white' readonly></td>
                    <td align='center'><input type='text' name='mgr_dept1'  size='10' maxlength='15' class='text'></td>
                    <td align='center'><input type='text' name='mgr_nm1'    size='10' maxlength='20' class='text'></td>
                    <td align='center'><input type='text' name='mgr_title1' size='10' maxlength='10' class='text'></td>
                    <td align='center'><input type='text' name='mgr_tel1'   size='15' maxlength='15' class='text'></td>
                    <td align='center'><input type='text' name='mgr_mobile1' size='15' maxlength='15' class='text'></td>
                    <td align='center'><input type='text' name='mgr_email1' size='20' maxlength='30' class='text'></td>
				</tr>
                <tr>
                    <td align='center'><input type='text' name='mgr_st2'    size='9'  value='차량관리자' class='white' readonly></td>
                    <td align='center'><input type='text' name='mgr_dept2'  size='10' maxlength='15' class='text'></td>
                    <td align='center'><input type='text' name='mgr_nm2'    size='10' maxlength='20' class='text'></td>
                    <td align='center'><input type='text' name='mgr_title2' size='10' maxlength='10' class='text'></td>
                    <td align='center'><input type='text' name='mgr_tel2'   size='15' maxlength='15' class='text'></td>
                    <td align='center'><input type='text' name='mgr_mobile2'size='15' maxlength='15' class='text'></td>
                    <td align='center'><input type='text' name='mgr_email2' size='20' maxlength='30' class='text'></td>
                </tr>
                <tr>
                    <td align='center'><input type='text' name='mgr_st3'    size='9'  value='회계관리자' class='white' readonly></td>
                    <td align='center'><input type='text' name='mgr_dept3'  size='10' maxlength='15' class='text'></td>
                    <td align='center'><input type='text' name='mgr_nm3'    size='10' maxlength='20' class='text'></td>
                    <td align='center'><input type='text' name='mgr_title3' size='10' maxlength='10' class='text'></td>
                    <td align='center'><input type='text' name='mgr_tel3'   size='15' maxlength='15' class='text'></td>
                    <td align='center'><input type='text' name='mgr_mobile3'size='15' maxlength='15' class='text'></td>
                    <td align='center'><input type='text' name='mgr_email3' size='20' maxlength='30' class='text'></td>
                </tr>
            </table>
		</td>
	</tr>
</table>
</form>
<iframe src="about:blank" name="i_no" width="500" height="100" cellpadding="0" cellspacing="0" border="1" frameborder="0" noresize>
</body>
</html>
