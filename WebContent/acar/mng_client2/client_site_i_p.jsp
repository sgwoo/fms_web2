<%@ page language="java" contentType="text/html;charset=euc-kr" %>
<%@ page import="java.util.*, acar.util.*, acar.client.*, acar.bill_mng.*"%>
<jsp:useBean id="rs_db" scope="page" class="acar.res_search.ResSearchDatabase"/>
<jsp:useBean id="al_db" scope="page" class="acar.client.AddClientDatabase"/>
<%@ include file="/acar/cookies.jsp" %>

<%
	//로그인ID&영업소ID
	LoginBean login = LoginBean.getInstance();
	String user_id = login.getCookieValue(request, "acar_id");
	String br_id = login.getCookieValue(request, "acar_br");
	String auth_rw = rs_db.getAuthRw(user_id, "01", "03", "07");
	
	String client_id = request.getParameter("client_id")==null?"":request.getParameter("client_id");
	String site_id = request.getParameter("site_id")==null?"":request.getParameter("site_id");
	String firm_nm = request.getParameter("firm_nm")==null?"":request.getParameter("firm_nm");
	String h_con = request.getParameter("h_con")==null?"":request.getParameter("h_con");
	String h_wd = request.getParameter("h_wd")==null?"":request.getParameter("h_wd");
	String from_page = request.getParameter("from_page")==null?"":request.getParameter("from_page");
	
	//고객정보
	ClientSiteBean c_site = al_db.getClientSite(client_id, site_id);
	
	NeoErpUDatabase neoe_db = NeoErpUDatabase.getInstance();
	
	Hashtable ven = new Hashtable();
	if(!c_site.getVen_code().equals("")){
		ven = neoe_db.getVendorCase(c_site.getVen_code());
	}
%>
<html>
<head>
<title>FMS</title>
<meta http-equiv="Content-Type" content="text/html; charset=euc-kr">
<link rel=stylesheet type="text/css" href="/include/table_t.css">
<script language='JavaScript' src='/include/common.js'></script>
<script language='javascript'>
<!--
	//우편번호 검색
	function search_zip(str){
		window.open("../car_rent/zip_s.jsp?idx="+str, "ZIP", "left=100, top=100, height=500, width=400, scrollbars=yes");
	}
		
	function save(){
		var fm = document.form1;	
		if(fm.site_st.value == '1'){
			if(fm.site_nm.value == '')			{	alert('상호를 입력하십시오');								return;	}		
			if(fm.enp_no.value == '')			{	alert('지점일 경우 사업자번호를 입력하여 주십시오.');		return;	}				
			if(fm.email_1.value != '' && fm.email_2.value != ''){
				fm.agnt_email.value = fm.email_1.value+'@'+fm.email_2.value;
			}			
		}else{
			if(fm.site_nm2.value == '')			{	alert('상호를 입력하십시오');								return;	}		
		}
		
		if(confirm('등록하시겠습니까?')){
			fm.target='i_no';
			fm.submit();
		}
	}
	
	//네오엠 조회하기
	function search(idx){
		var fm = document.form1;	
		window.open("../con_debt/vendor_list.jsp?idx="+idx+"&t_wd="+fm.ven_name.value, "VENDOR_LIST", "left=300, top=300, width=430, height=250, scrollbars=yes");		
	}	
	
	function cng_input(){
		var fm = document.form1;	
		if(fm.site_st.value == '1'){
			tr_site1.style.display	= '';
			tr_site2.style.display	= 'none';
		}else{
			tr_site1.style.display	= 'none';
			tr_site2.style.display	= '';			
		}
	}
//-->
</script>
</head>
<body leftmargin="15" onload="javascript:document.form1.site_nm.focus();">

<form name='form1' action='./client_site_i_a.jsp' method='post'>
<input type='hidden' name='auth_rw' value='<%=auth_rw%>'>
<input type='hidden' name='br_id' value='<%=br_id%>'>
<input type='hidden' name='user_id' value='<%=user_id%>'>
<input type='hidden' name='client_id' value='<%=client_id%>'>
<input type='hidden' name='site_id' value='<%=site_id%>'>
<input type='hidden' name='firm_nm' value='<%=firm_nm%>'>
<input type='hidden' name='h_con' value='<%=h_con%>'>
<input type='hidden' name='h_wd' value='<%=h_wd%>'>
<table border=0 cellspacing=0 cellpadding=0 width=100%>
    <tr>
    	<td>
    	    <table width=100% border=0 cellpadding=0 cellspacing=0>
                <tr>
                    <td width=7><img src=/acar/images/center/menu_bar_1.gif width=7 height=33></td>
                    <td class=bar>&nbsp;&nbsp;&nbsp;<img src=/acar/images/center/menu_bar_dot.gif width=4 height=5 align=absmiddle>&nbsp;<span class=style1>영업지원 > 거래처관리 > <span class=style5>지점/현장 <%if(site_id.equals("")) {%>등록 <%}else{%>수정 <%}%></span></span></td>
                    <td width=7><img src=/acar/images/center/menu_bar_2.gif width=7 height=33></td>
                </tr>
            </table>
    	</td>
    </tr>
    <tr>
        <td class=h></td>
    </tr>
	<%if(!from_page.equals("/tax/tax_mng/tax_mng_u_m.jsp")){%>
    <tr height="30">
        <td align='right'><a href='javascript:history.go(-1);'><img src=/acar/images/center/button_list.gif align=absmiddle border="0"></a></td>
    </tr>	
	<%}%>
    <tr>
        <td class=line2></td>
    </tr>
    <tr>
        <td class='line'>            
            <table border="0" cellspacing="1" cellpadding='0' width=100%>
                <tr> 
                    <td class='title' width=15%>구분</td>
                    <td align='left'>&nbsp; 
                      <select name='site_st' onChange="javascript:cng_input()">
                        <option value='1' <%if(c_site.getSite_st().equals("1")) out.println("selected");%>>지점</option>
                        <option value='2' <%if(c_site.getSite_st().equals("2")) out.println("selected");%>>현장</option>
                      </select>
                    </td>
                </tr>	
            </table>
    	</td>
    </tr>
    <tr>
        <td>* 지점 : 차량 실사용지가 사업자등록된 지점인 경우 </td>
    </tr>
    <tr>
        <td>* 현장 : 차량 실사용지가 사업자등록이 없는 현장이거나 특정 지역(장소)인 경우</td>
    </tr>
    <tr id=tr_site1 style="display:<%if(c_site.getSite_st().equals("1")||c_site.getSite_st().equals("")) {%>''<%}else{%>none<%}%>"'>
        <td class='line'>            
            <table border="0" cellspacing="1" cellpadding='0' width=100%>
                <tr> 
                    <td colspan="2" class='title' width=15%>상호</td>
                    <td colspan='3'>&nbsp; 
                      <input type='text' name='site_nm' size="60" maxlength='30' class='text' value='<%=c_site.getR_site()%>'>
                    </td>
                </tr>
                <tr> 
                    <td colspan="2" class='title'>이름/대표</td>
                    <td colspan='3'>&nbsp; 
                      <input type='text' name='site_jang' value='<%=c_site.getSite_jang()%>' size='20' maxlength='20' class='text' style='IME-MODE: active'>
                    </td>
                </tr>
                <tr> 
                    <td height="2" colspan="2" class='title'>사업자번호</td>
                    <td colspan='3'>&nbsp; 
                      <input type='text' name='enp_no' value='<%=c_site.getEnp_no()%>' size='15' class='text' maxlength='15'> ('-'빼고)
					  &nbsp;&nbsp;
					  (종사업자번호 : <input type='text' size='3' name='taxregno' maxlength='4' class='text' value='<%=c_site.getTaxregno()%>'>)					  
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
				  <td  colspan="2" class=title>주소</td>
				  <td colspan=3>&nbsp;
					<input type="text" name="t_zip"  id="t_zip" size="7" maxlength='7' value="<%=c_site.getZip()%>">
					<input type="button" onclick="openDaumPostcode()" value="우편번호 찾기"><br>
					&nbsp;&nbsp;<input type="text" name="t_addr"  id="t_addr" size="50" value="<%=c_site.getAddr()%>">
				  </td>
				</tr>
                <tr> 
                    <td colspan="2" class='title'>업태</td>
                    <td colspan='3'>&nbsp; 
                      <input type='text' name='bus_cdt' size='40' class='text' maxlength='40' value="<%=c_site.getBus_cdt()%>" style='IME-MODE: active'>
                    </td>
                </tr>
                <tr> 
                    <td colspan="2" class='title'>종목</td>
                    <td colspan='3'>&nbsp; 
                      <input type='text' name='bus_itm' size='40' class='text' maxlength='40' value="<%=c_site.getBus_itm()%>">
                    </td>
                </tr>		  
                <tr> 
                    <td colspan="2" class='title'>개업년월일</td>
                    <td colspan='3'>&nbsp; 
                      <input type='text' name='open_year' size='12' value="<%=c_site.getOpen_year()%>" class='text' maxlength='12' onBlur='javascript:this.value=ChangeDate(this.value)'>
                    </td>
                </tr>		  
                <tr> 
                    <td colspan="2" class='title'>TEL</td>
                    <td width=35%>&nbsp; 
                      <input type='text' name='tel' value='<%=c_site.getTel()%>' size='20' maxlength='20' class='text'>
                    </td>
                    <td class='title' width=15%>FAX</td>
                    <td width=35%>&nbsp; 
                      <input type='text' name='fax' value='<%=c_site.getFax()%>' size='15' maxlength='15' class='text'>
                    </td>
                </tr>
                <tr> 
                    <td rowspan="4" class='title'>세<br>
                    금<br>
                    계<br>산<br>서<br>담<br>당<br>자</td>
                    <td class='title'>이름</td>
                    <td>&nbsp; 
                      <input type='text' name='agnt_nm' value='<%=c_site.getAgnt_nm()%>' size='15' maxlength='15' class='text'>
                    </td>
                    <td class='title'>직위</td>
                    <td>&nbsp; 
                      <input type='text' name='agnt_title' value='<%=c_site.getAgnt_title()%>' size='15' maxlength='15' class='text'>
                    </td>
                </tr>
                <tr> 
                    <td class='title'>부서</td>
                    <td>&nbsp;
                      <input type='text' name='agnt_dept' value='<%=c_site.getAgnt_dept()%>' size='15' maxlength='15' class='text'></td>
                    <td class='title'>핸드폰</td>
                    <td>&nbsp; 
                      <input type='text' name='agnt_m_tel' value='<%=c_site.getAgnt_m_tel()%>' size='15' maxlength='15' class='text'>
                    </td>
                </tr>
                <tr> 
                    <td class='title'>사무실전화</td>
                    <td>&nbsp; 
                      <input type='text' name='agnt_tel' value='<%=c_site.getAgnt_tel()%>' size='30' maxlength='30' class='text'>
                    </td>
                    <td class='title'>팩스번호</td>
                    <td>&nbsp;
                      <input type='text' name='agnt_fax' value='<%=c_site.getAgnt_fax()%>' size='15' maxlength='15' class='text'>
                    </td>
                </tr>
				<%	String email_1 = "";
					String email_2 = "";
					if(!c_site.getAgnt_email().equals("")){
						int mail_len = c_site.getAgnt_email().indexOf("@");
						if(mail_len > 0){
							email_1 = c_site.getAgnt_email().substring(0,mail_len);
							email_2 = c_site.getAgnt_email().substring(mail_len+1);
						}
					}
				%>				
                <tr> 
                    <td class='title'>이메일</td>
                    <td colspan="3">&nbsp; 
					  <input type='text' size='15' name='email_1' value='<%=email_1%>' maxlength='100' class='text' style='IME-MODE: inactive'>@<input type='text' size='20' name='email_2' value='<%=email_2%>'maxlength='100' class='text' style='IME-MODE: inactive'>
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
					  <input type='hidden' name='agnt_email' value='<%=c_site.getAgnt_email()%>'>
                      <!--<input type='text' name='agnt_email' value='<%=c_site.getAgnt_email()%>' size='40' class='text'>-->
                    </td>
                </tr>
                <tr> 
                    <td colspan="2" rowspan="3" class='title'>네오엠코드</td>
                    <td colspan='3'>&nbsp; 
        			  <input type='text' name='ven_name' size='30' value='<%=ven.get("VEN_NAME")==null?"":ven.get("VEN_NAME")%>' class='text' style='IME-MODE: active'>
        			  &nbsp;&nbsp;<a href="javascript:search('')" onMouseOver="window.status=''; return true"><img src=/acar/images/center/button_in_search1.gif align=absmiddle border="0"></a> 
                    </td>
                </tr>		  
                <tr> 
                    <td colspan='3'>&nbsp; 
        			  <input type='text' name='ven_code' size='10' value='<%=c_site.getVen_code()%>' class='text'> 				
                    </td>
                </tr>		 
                <tr> 
                    <td colspan='3'>&nbsp; 
					  <%if(c_site.getVen_code().equals("")){%>
					  <input type='checkbox' name="auto_ven_reg" value='Y' checked>
        				자동등록
					  <%}%>
					  <%if(!c_site.getVen_code().equals("")){%>
					  <input type='checkbox' name="auto_ven_upd" value='Y' checked>
        				자동변경
					  <%}%>					  
                    </td>
                </tr>	
                <tr> 
                    <td colspan="2" class='title'>계산서비고표시</td>
                    <td colspan='3'>&nbsp; 
                      <input type='text' name='bigo_value' size='60' value="<%=c_site.getBigo_value()%>" class='text'>
                    </td>
                </tr>		                  					 		  
            </table>
	    </td>
    </tr>
    <tr id=tr_site2 style="display:<%if(c_site.getSite_st().equals("2"))  {%>''<%} else{ %>none<%}%>"'>
        <td class='line'>            
            <table border="0" cellspacing="1" cellpadding='0' width=100%>
                <tr> 
                    <td class='title' width=15%>현장명</td>
                    <td colspan='3'>&nbsp; 
                      <input type='text' name='site_nm2' size="60" maxlength='30' class='text' value='<%=c_site.getR_site()%>'>
                    </td>
                </tr>
                <tr> 
                    <td class='title'>담당자</td>
                    <td colspan='3'>&nbsp; 
                      <input type='text' name='site_jang2' value='<%=c_site.getSite_jang()%>' size='20' maxlength='20' class='text' style='IME-MODE: active'>
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
				  <td  colspan="2" class=title>주소</td>
				  <td colspan=3>&nbsp;
					<input type="text" name="t_zip"  id="t_zip1" size="7" maxlength='7' value="<%=c_site.getZip()%>">
					<input type="button" onclick="openDaumPostcode1()" value="우편번호 찾기"><br>
					&nbsp;&nbsp;<input type="text" name="t_addr"  id="t_addr1" size="50" value="<%=c_site.getAddr()%>">
				  </td>
				</tr>
                <tr>		  
                    <td class='title'>TEL</td>
                    <td width=35%>&nbsp; 
                      <input type='text' name='tel2' value='<%=c_site.getTel()%>' size='20' maxlength='20' class='text'>
                    </td>
                    <td class='title' width=15%>FAX</td>
                    <td width=35%>&nbsp; 
                      <input type='text' name='fax2' value='<%=c_site.getFax()%>' size='15' maxlength='15' class='text'>
                    </td>
                </tr>
            </table>
	    </td>
    </tr>	
	<%if(!from_page.equals("/tax/tax_mng/tax_mng_u_m.jsp")){%>	
    <tr height="30">	
        <td align='right'><a href='javascript:save()' onMouseOver="window.status=''; return true"><img src=/acar/images/center/button_<%if(c_site.getSeq().equals("")){%>reg<%}else{%>modify<%}%>.gif align=absmiddle border="0"></a></td>
    </tr>
	<%}%>
</table>
</form>
<iframe src="about:blank" name="i_no" width="0" height="0" frameborder="0" noresize></iframe>
</body>
</html>