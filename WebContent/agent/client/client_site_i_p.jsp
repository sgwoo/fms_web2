<%@ page language="java" contentType="text/html;charset=euc-kr" %>
<%@ page import="java.util.*, acar.util.*, acar.client.*"%>
<jsp:useBean id="rs_db" scope="page" class="acar.res_search.ResSearchDatabase"/>
<jsp:useBean id="al_db" scope="page" class="acar.client.AddClientDatabase"/>
<%@ include file="/agent/cookies.jsp" %>

<%
	String auth_rw 	= request.getParameter("auth_rw")==null?"":request.getParameter("auth_rw");
	String br_id 	= request.getParameter("br_id")==null?"":request.getParameter("br_id");
	String user_id 	= request.getParameter("user_id")==null?"":request.getParameter("user_id");

	//로그인ID&영업소ID
	LoginBean login = LoginBean.getInstance();
	if(user_id.equals("")) 	user_id = login.getCookieValue(request, "acar_id");
	if(br_id.equals(""))	br_id 	= login.getCookieValue(request, "acar_br");
	if(auth_rw.equals(""))	auth_rw = rs_db.getAuthRw(user_id, "22", "01", "01");
	
	
	String client_id = request.getParameter("client_id")==null?"":request.getParameter("client_id");
	String site_id = request.getParameter("site_id")==null?"":request.getParameter("site_id");
	String firm_nm = request.getParameter("firm_nm")==null?"":request.getParameter("firm_nm");
	String h_con = request.getParameter("h_con")==null?"":request.getParameter("h_con");
	String h_wd = request.getParameter("h_wd")==null?"":request.getParameter("h_wd");
	String from_page = request.getParameter("from_page")==null?"":request.getParameter("from_page");  //popup 요청한 페이지
	
	String cmd = request.getParameter("cmd")==null?"":request.getParameter("cmd");
	
	//고객정보
	ClientSiteBean c_site = al_db.getClientSite(client_id, site_id);

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
		window.open("/agent/lc_rent/zip_s.jsp?idx="+str, "ZIP", "left=100, top=100, height=500, width=400, resizable=yes, scrollbars=yes, status=yes");
	}
		
	function save(){
		var fm = document.form1;	
		if(fm.site_nm.value == '')			{	alert('상호를 입력하십시오');		return;	}
		if(fm.site_st.value == '1' && fm.enp_no.value == '')			{	alert('지점일 경우 사업자번호를 입력하여 주십시오.');		return;	}		
		if(confirm('등록하시겠습니까?')){
			fm.target='i_no';
			fm.submit();
		}
	}
	
	//네오엠 조회하기
	function search(idx){
		var fm = document.form1;	
		window.open("vendor_list.jsp?idx="+idx+"&t_wd="+fm.ven_name.value, "VENDOR_LIST", "left=300, top=300, width=430, height=250, resizable=yes, scrollbars=yes, status=yes");		
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
<input type='hidden' name='from_page' value='<%=from_page%>'> 
<table border=0 cellspacing=0 cellpadding=0 width='100%'>
    <tr>
    	<td>
    	    <table width=100% border=0 cellpadding=0 cellspacing=0>
                <tr>
                    <td width=7><img src=/acar/images/center/menu_bar_1.gif width=7 height=33></td>
                    <td class=bar>&nbsp;&nbsp;&nbsp;<img src=/acar/images/center/menu_bar_dot.gif width=4 height=5 align=absmiddle>&nbsp;<span class=style1>Agent > 거래처 관리 > <span class=style5>지점/현장 <%if(site_id.equals("")){%>등록<%}else{%>수정<%}%></span></span></td>
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
            <table border="0" cellspacing="1" cellpadding='0' width=100%>
                <tr> 
                    <td class='title'> 구분</td>
                    <td colspan='3' align='left'>&nbsp; 
                      <select name='site_st'>
                        <option value='1' <%if(c_site.getSite_st().equals("1")) out.println("selected");%>>지점</option>
                        <option value='2' <%if(c_site.getSite_st().equals("2")) out.println("selected");%>>현장</option>
                      </select>
                    </td>
                </tr>
                <tr> 
                    <td class='title'>상호</td>
                    <td colspan='3'>&nbsp; 
                      <input type='text' name='site_nm' size="60" maxlength='30' class='text' value='<%=c_site.getR_site()%>'>
                    </td>
                </tr>
                <tr> 
                    <td class='title'>이름/대표</td>
                    <td colspan='3'>&nbsp; 
                      <input type='text' name='site_jang' value='<%=c_site.getSite_jang()%>' size='20' maxlength='20' class='text' style='IME-MODE: active'>
                    </td>
                </tr>
                <tr> 
                    <td height="2"  class='title'>사업자번호</td>
                    <td colspan='3'>&nbsp; 
                      <input type='text' name='enp_no' value='<%=c_site.getEnp_no()%>' size='15' class='text' maxlength='15'> ('-'빼고)
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
				  <td class=title>주소</td>
				  <td colspan=3>&nbsp;
					<input type="text" name="t_zip" id="t_zip" size="7" maxlength='7' value="<%=c_site.getZip()%>">
					<input type="button" onclick="openDaumPostcode()" value="우편번호 찾기"><br>
					&nbsp;&nbsp;<input type="text" name="t_addr" id="t_addr" size="65" value="<%=c_site.getAddr()%>">
				  </td>
				</tr>	
				<!--
                <tr> 
                    <td colspan="2" class='title'>주소</td>
                    <td colspan="3">&nbsp; 
                      <input type='text' name="t_zip" value='<%=c_site.getZip()%>' size="6" class='text' maxlength='7' readonly onClick="javascript:search_zip('')">
                      &nbsp; 
                      <input type='text' name="t_addr" value='<%=c_site.getAddr()%>' size="50" class='text' maxlength='100' style='IME-MODE: active'>
                    </td>
                </tr>		  
				-->
                <tr> 
                    <td  class='title'>업태</td>
                    <td colspan='3'>&nbsp; 
                      <input type='text' name='bus_cdt' size='40' class='text' maxlength='40' value="<%=c_site.getBus_cdt()%>" style='IME-MODE: active'>
                    </td>
                </tr>
                <tr> 
                    <td  class='title'>종목</td>
                    <td colspan='3'>&nbsp; 
                      <input type='text' name='bus_itm' size='40' class='text' maxlength='40' value="<%=c_site.getBus_itm()%>">
                    </td>
                </tr>		  
                <tr> 
                    <td  class='title'>개업년월일</td>
                    <td colspan='3'>&nbsp; 
                      <input type='text' name='open_year' size='12' value="<%=c_site.getOpen_year()%>" class='text' maxlength='12' onBlur='javascript:this.value=ChangeDate(this.value)'>
                    </td>
                </tr>		  
                <tr> 
                    <td width="100" class='title'>TEL</td>
                    <td width="230">&nbsp; 
                      <input type='text' name='tel' value='<%=c_site.getTel()%>' size='20' maxlength='20' class='text'>
                    </td>
                    <td class='title' width="70">FAX</td>
                    <td width="200">&nbsp; 
                      <input type='text' name='fax' value='<%=c_site.getFax()%>' size='15' maxlength='15' class='text'>
                    </td>
                </tr>
                <tr> 
                    <td rowspan="2" class='title'>네오엠코드</td>
                    <td colspan='3'>&nbsp; 
        			  <input type='text' name='ven_name' size='30' value='<%=firm_nm%>' class='text' style='IME-MODE: active'>
        			  &nbsp;&nbsp;<a href="javascript:search('')" onMouseOver="window.status=''; return true"><img src=/acar/images/center/button_in_search1.gif align=absmiddle border=0></a> 
                    </td>
                </tr>		  
                <tr> 
                    <td colspan='3'>&nbsp; 
        			  <input type='text' name='ven_code' size='10' value='<%=c_site.getVen_code()%>' class='text'> 				
                    </td>
                </tr>		  		                  
                <tr> 
                    <td rowspan="3" class='title'>세금계산서<br>
                        수신담당자</td>
                    <td colspan='3'>&nbsp;이름 : 
                      <input type='text' name='agnt_nm' value='<%=c_site.getAgnt_nm()%>' size='15' maxlength='15' class='text'>
											&nbsp;직위 : 
                      <input type='text' name='agnt_title' value='<%=c_site.getAgnt_title()%>' size='15' maxlength='15' class='text'>
                      &nbsp;부서 : 
                      <input type='text' name='agnt_dept' value='<%=c_site.getAgnt_dept()%>' size='15' maxlength='15' class='text'></td>
                    </td>
                </tr>
                <tr> 
                    <td colspan='3'>&nbsp;핸드폰 : 
                    	<input type='text' name='agnt_m_tel' value='<%=c_site.getAgnt_m_tel()%>' size='15' maxlength='15' class='text'>
                    	&nbsp;사무실전화 :  
                      <input type='text' name='agnt_tel' value='<%=c_site.getAgnt_tel()%>' size='30' maxlength='30' class='text'>
                      &nbsp;팩스번호 : 
                      <input type='text' name='agnt_fax' value='<%=c_site.getAgnt_fax()%>' size='15' maxlength='15' class='text'>
                    </td>
                </tr>
                <tr> 
                    <td colspan="3">&nbsp;이메일 :  
                      <input type='text' name='agnt_email' value='<%=c_site.getAgnt_email()%>' size='40' class='text' style='IME-MODE: inactive'>
                    </td>
                </tr>
                <tr> 
                    <td rowspan="3" class='title'>세금계산서<br>
                        추가담당자</td>
                    <td colspan='3'>&nbsp;이름 : 
                      <input type='text' name='agnt_nm2' value='<%=c_site.getAgnt_nm2()%>' size='15' maxlength='15' class='text'>
											&nbsp;직위 : 
                      <input type='text' name='agnt_title2' value='<%=c_site.getAgnt_title2()%>' size='15' maxlength='15' class='text'>
                      &nbsp;부서 : 
                      <input type='text' name='agnt_dept2' value='<%=c_site.getAgnt_dept2()%>' size='15' maxlength='15' class='text'></td>
                    </td>
                </tr>
                <tr> 
                    <td colspan='3'>&nbsp;핸드폰 : 
                    	<input type='text' name='agnt_m_tel2' value='<%=c_site.getAgnt_m_tel2()%>' size='15' maxlength='15' class='text'>
                    	&nbsp;사무실전화 :  
                      <input type='text' name='agnt_tel2' value='<%=c_site.getAgnt_tel2()%>' size='30' maxlength='30' class='text'>
                      &nbsp;팩스번호 : 
                      <input type='text' name='agnt_fax2' value='<%=c_site.getAgnt_fax2()%>' size='15' maxlength='15' class='text'>
                    </td>
                </tr>
                <tr> 
                    <td colspan="3">&nbsp;이메일 : 
                      <input type='text' name='agnt_email2' value='<%=c_site.getAgnt_email2()%>' size='40' class='text'>
                    </td>
                </tr>      

            </table>
	    </td>
    </tr>
    <tr height="30">
	    <td align='right'>&nbsp;</td>
    </tr>
	<%if(!cmd.equals("view")){%>
    <tr height="30">
        <td align='right'><a href='javascript:save()' onMouseOver="window.status=''; return true"><img src=/acar/images/center/button_conf.gif align=absmiddle border=0></a> &nbsp;&nbsp;<a href='javascript:history.go(-1);'><img src=/acar/images/center/button_list.gif align=absmiddle border=0></a></td>
    </tr>
	<%}%>
</table>
</form>
<iframe src="about:blank" name="i_no" width="0" height="0" frameborder="0" noresize></iframe>
</body>
</html>