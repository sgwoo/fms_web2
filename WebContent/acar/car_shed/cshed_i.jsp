<%@ page language="java" contentType="text/html;charset=euc-kr" %>
<%@ page import="java.util.*"%>
<%@ page import="acar.common.*"%>
<%@ include file="/acar/cookies.jsp" %>

<%
	String auth_rw 	= request.getParameter("auth_rw")==null?"":request.getParameter("auth_rw"); //권한
	String user_id 	= request.getParameter("user_id")==null?"":request.getParameter("user_id");
	String br_id 	= request.getParameter("br_id")==null?"":request.getParameter("br_id");
	
	String brch 	= request.getParameter("brch")==null?"":request.getParameter("brch");
	
	CommonDataBase c_db = CommonDataBase.getInstance();
	Vector branches = c_db.getBranchList();	/* 영업소 조회 */
	int brch_size = branches.size();
%>

<html>
<head>
<title>FMS</title>
<link rel="stylesheet" type="text/css" href="/include/table_t.css"></link>
<%@ include file="/acar/getNaviCookies.jsp" %>
<script language="JavaScript" src='/include/common.js'></script>
<script language="JavaScript">
<!--

	function save()
	{
		if(confirm('등록하시겠습니까?'))
		{
			var fm = document.form1;
			if(!isNum(fm.lea_ssn.value))		{	alert('임대/중개인 법인등록번호(생년월일)를 확인하십시오');	return;	}
			else if((!isNum(fm.lea_ent_no.value)) || ((fm.lea_ent_no.value.length != 10)&&(fm.lea_ent_no.value.length != 0)))	{	alert('임대/중개인 사업자등록번호를 확인하십시오');	return;	}
			else if(!isNum(fm.lend_ssn.value))		{	alert('토지소유자 법인등록번호(생년월일)를 확인하십시오');	return;	}
			else if((!isNum(fm.lend_ent_no.value)) || ((fm.lend_ent_no.value.length != 10)&&(fm.lend_ent_no.value.length != 0)))	{	alert('토지소유자 사업자등록번호를 확인하십시오');	return;	}
			else if(!isDate(fm.lea_st_dt.value))		{	alert('임대기간을 확인하십시오');	return;	}
			else if(!isDate(fm.lea_end_dt.value))		{	alert('임대기간을 확인하십시오');	return;	}
			fm.target='i_no';
			fm.submit();
		}
	}
	
	function go_to_list()
	{
		location = '/acar/car_shed/cshed_frame_s.jsp?auth_rw=<%=auth_rw%>&user_id=<%=user_id%>&br_id=<%=br_id%>&brch=<%=brch%>';
	}
	
	

	
	//임대/중개인사항 사업장주소
	function set_lea_o_addr()
	{
		var fm = document.form1;
		if(fm.lea_o_addr_copy.checked == true)
		{
			fm.lea_o_post.value = fm.lea_h_post.value;
			fm.lea_o_addr.value = fm.lea_h_addr.value;
		}
		else
		{
			fm.lea_o_post.value = '';
			fm.lea_o_addr.value = '';
		}
	}		
	
	//토지사항 사업장주소
	function set_lend_o_addr()
	{
		var fm = document.form1;
		if(fm.lend_o_addr_copy.checked == true)
		{
			fm.lend_o_post.value = fm.lend_h_post.value;
			fm.lend_o_addr.value = fm.lend_h_addr.value;
		}
		else
		{
			fm.lend_o_post.value = '';
			fm.lend_o_addr.value = '';
		}
	}				
//-->
</script>
</head>
<body leftmargin="15">
<form action="/acar/car_shed/cshed_i_a.jsp" name="form1" method="POST">
<input type='hidden' name='auth_rw' value='<%=auth_rw%>'>
<input type='hidden' name='user_id' value='<%=user_id%>'>
<input type='hidden' name='br_id' value='<%=br_id%>'>
<input type='hidden' name='brch' value='<%=brch%>'>
<input type='hidden' name='shed_st' value='1'>
<table border=0 cellspacing=0 cellpadding=0 width=100%>
	<tr>
    	<td>
    	    <table width=100% border=0 cellpadding=0 cellspacing=0 background=../images/center/menu_bar_bg.gif>
                <tr>
                    <td width=7><img src=../images/center/menu_bar_1.gif width=7 height=33></td>
                    <td class=bar>&nbsp;&nbsp;&nbsp;<img src=../images/center/menu_bar_dot.gif width=4 height=5 align=absmiddle>&nbsp;<span class=style1>Master > 코드관리 > <span class=style5>차고지등록</span></span></td>
                    <td width=7><img src=../images/center/menu_bar_2.gif width=7 height=33></td>
                </tr>
            </table>
    	</td>
    </tr>
    <tr>
        <td class=h></td>
    </tr>
	<tr>
    	<td align=right>
    		<a href="javascript:save()" onMouseOver="window.status=''; return true"><img src=../images/center/button_reg.gif border=0 align=absmiddle></a>
    		<a href="javascript:go_to_list()" onMouseOver="window.status=''; return true"><img src=../images/center/button_list.gif border=0 align=absmiddle></a>
    	</td>
    </tr>
    <tr>
        <td class=line2></td>
    </tr>
    <tr>
    	<td class=line>
            <table border="0" cellspacing="1" width=100%>
                <tr>
                    <td class=title width=12%>차고지명칭</td>
                    <td width=21%>&nbsp;<input type="text" name="shed_nm" value="" size="40" maxlength='120' class=text></td>
                    <td class=title width=12%>관리영업소</td>
                    <td width=20%>
                    	&nbsp;<select name='mng_off'>
						<%	if(brch_size > 0){
								for (int i = 0 ; i < brch_size ; i++){
									Hashtable branch = (Hashtable)branches.elementAt(i);%>
			         	 	<option value='<%=branch.get("BR_ID")%>'><%= branch.get("BR_NM")%></option>
						<%		}
							}%>			
						</select>
                    </td>
                    <td class=title width=12%>관리담당자</td>
                    <td width=23%>&nbsp;<input type="text" name="mng_agnt" value="" size="20" maxlength='20' class=text></td>
                </tr>
            </table>
        </td>
    </tr>
    <tr>
        <td></td>
    </tr>
    <tr>
    	<td><img src=../images/center/icon_arrow.gif align=absmiddle> <span class=style2>임대/중개인사항</span>&nbsp;&nbsp;&nbsp;&nbsp;<font size='1'>(* 사업자등록번호는 '-' 없이 숫자만 입력하세요)</font></td>
    </tr>
    <tr>
        <td class=line2></td>
    </tr>
    <tr>
    	<td class=line>
    		<table border="0" cellspacing="1" width=100%>
                <tr>
                    <td class=title width=12%>성명</td>
               		<td width=21%>&nbsp;<input type="text" name="lea_nm" value="" size="15" maxlength='20' class=text></td>
               		<td class=title width=12%>상호</td>
               		<td width=20%>&nbsp;<input type="text" name="lea_comp_nm" value="" size="26" maxlength='30' class=text></td>
               		<td class=title width=12%>업태</td>
               		<td width=23%>&nbsp;<input type="text" name="lea_sta" value="" size="25" maxlength='30' class=text></td>
                </tr>
                <tr>
                    <td class=title>법인등록번호(생년월일)</td>
               		<td>&nbsp;<input type="text" name="lea_ssn" value="" size="20" maxlength='13' class=text></td>
               		<td class=title>사업자등록번호</td>
               		<td>&nbsp;<input type="text" name="lea_ent_no" value="" size="20" maxlength='10' class=text></td>
               		<td class=title>종목</td>
               		<td>&nbsp;<input type="text" name="lea_item" value="" size="25" maxlength='30' class=text></td>
                </tr>
                <tr>
                    <td class=title>임대기간</td>
               		<td colspan=3>&nbsp;<input type="text" name="lea_st_dt" value="" size=12 maxlength='12' onBlur='javascript:this.value=ChangeDate(this.value)' class='text'> - <input type="text" name="lea_end_dt" value="" size=12 maxlength='12' onBlur='javascript:this.value=ChangeDate(this.value)' class='text'></td>
                    <td class=title>임대구분</td>
               		<td>
               			&nbsp;<input type="radio" name="lea_st" value="0"> 자가임대 
               			<input type="radio" name="lea_st" value="1"> 재임대
						<input type="radio" name="lea_st" value="2"> 임대
               		</td>
                </tr>
				<script src="https://t1.daumcdn.net/mapjsapi/bundle/postcode/prod/postcode.v2.js"></script>
				<script>
					function openDaumPostcode() {
						new daum.Postcode({
							oncomplete: function(data) {
								document.getElementById('lea_h_post').value = data.zonecode;
								document.getElementById('lea_h_addr').value = data.address+ " ( "+ data.buildingName +" )";
								
							}
						}).open();
					}
				</script>
				<tr>
                    <td class=title>등록지주소</td>
               		<td colspan=3>
						&nbsp;<input type="text" name='lea_h_post' id="lea_h_post" size="7" maxlength='7'>
						<input type="button" onclick="openDaumPostcode()" value="우편번호 찾기"><br>
						&nbsp;<input type="text" name='lea_h_addr' id="lea_h_addr" size="100">
					</td>
               		<td class=title>전화번호(자택)</td>
               		<td>&nbsp;<input type="text" name="lea_h_tel" value="" size="15" class=text></td>
                </tr>
				<script>
					function openDaumPostcode1() {
						new daum.Postcode({
							oncomplete: function(data) {
								document.getElementById('lea_o_post').value = data.zonecode;
								document.getElementById('lea_o_addr').value = data.address+ " ( "+ data.buildingName +" )";
								
							}
						}).open();
					}
				</script>
                <tr>
                    <td class=title>사업장주소</td>
               		<td colspan=3>
					&nbsp;<input type="text" name='lea_o_post' id="lea_o_post" size="7" maxlength='7'>
						<input type="button" onclick="openDaumPostcode1()" value="우편번호 찾기"><br>
						&nbsp;<input type="text" name='lea_o_addr' id="lea_o_addr" size="100">
						&nbsp;<input type='checkbox' name='lea_o_addr_copy' onClick='javascript:set_lea_o_addr()'>상동
					</td>
               		<td class=title>전화번호(사무실)</td>
               		<td>&nbsp;<input type="text" name="lea_h_tel" value="" size="15" maxlength='15' class=text></td>
                </tr>
                <tr>
                    <td class=title>과세구분</td>
               		<td>
               			&nbsp;<input type="radio" name="lea_tax_st" value="0" > 과세
               			<input type="radio" name="lea_tax_st" value="1"> 면세
               		</td>
               		<td class=title>FAX</td>
               		<td>&nbsp;<input type="text" name="lea_fax" value="" size="15" maxlength='15' class=text></td>
               		<td class=title>전화번호(휴대폰)</td>
               		<td>&nbsp;<input type="text" name="lea_m_tel" value="" size="15" maxlength='15' class=text></td>
                </tr>
            </table>
        </td>
    </tr>
    <tr>
        <td></td>
    </tr>
    <tr>
    	<td><img src=../images/center/icon_arrow.gif align=absmiddle> <span class=style2>토지사항</span></td>
    </tr>
    <tr>
        <td class=line2></td>
    </tr>
    </tr>
    	<td class=line>
    		<table border="0" cellspacing="1" width=100%>
                <tr>
                    <td class=title width=12%>토지소유자명</td>
               		<td width=21%>&nbsp;<input type="text" name="lend_own_nm" value="" size="15" maxlength='20' class=text></td>
               		<td class=title width=12%>상호</td>
               		<td width=20%>&nbsp;<input type="text" name="lend_comp_nm" value="" size="26" maxlength='30' class=text></td>
               		<td class=title width=12%>업태</td>
               		<td width=23%>&nbsp;<input type="text" name="lend_sta" value="" size="25" maxlength='30' class=text></td>
                </tr>
                <tr>
                    <td class=title>법인등록번호(생년월일)</td>
               		<td>&nbsp;<input type="text" name="lend_ssn" value="" size="20" maxlength='13' class=text></td>
               		<td class=title>사업자등록번호</td>
               		<td>&nbsp;<input type="text" name="lend_ent_no" value="" size="20" maxlength='10' class=text></td>
               		<td class=title>종목</td>
               		<td>&nbsp;<input type="text" name="lend_item" value="" size="25" maxlength='30' class=text></td>
                </tr>
				<script>
					function openDaumPostcode2() {
						new daum.Postcode({
							oncomplete: function(data) {
								document.getElementById('lend_h_post').value = data.zonecode;
								document.getElementById('lend_h_addr').value = data.address+ " ( "+ data.buildingName +" )";
								
							}
						}).open();
					}
				</script>
				<tr>
                    <td class=title>등록지주소</td>
               		<td colspan=3>
						&nbsp;<input type="text" name='lend_h_post' id="lend_h_post" size="7" maxlength='7'>
						<input type="button" onclick="openDaumPostcode2()" value="우편번호 찾기"><br>
						&nbsp;<input type="text" name='lend_h_addr' id="lend_h_addr" size="100">
					</td>
               		<td class=title>전화번호(자택)</td>
               		<td>&nbsp;<input type="text" name="lend_h_tel" value="" size="15" maxlength='15' class=text></td>
                </tr>
				<script>
					function openDaumPostcode3() {
						new daum.Postcode({
							oncomplete: function(data) {
								document.getElementById('lend_o_post').value = data.zonecode;
								document.getElementById('lend_h_addr').value = data.address+ " ( "+ data.buildingName +" )";
								
							}
						}).open();
					}
				</script>
                <tr>
                    <td class=title>사업장주소</td>
               		<td colspan=3>
						&nbsp;<input type="text" name='lend_o_post' id="lend_o_post" size="7" maxlength='7'>
						<input type="button" onclick="openDaumPostcode3()" value="우편번호 찾기"><br>
						&nbsp;<input type="text" name='lend_o_addr' id="lend_o_addr" size="100">
						&nbsp;<input type='checkbox' name='lend_o_addr_copy' onClick='javascript:set_lend_o_addr()'>상동
					</td>
               		<td class=title>전화번호(사무실)</td>
               		<td>&nbsp;<input type="text" name="lend_o_tel" value="" size="15" maxlength='15' class=text></td>
                </tr>
				<script>
					function openDaumPostcode4() {
						new daum.Postcode({
							oncomplete: function(data) {
								document.getElementById('lend_post').value = data.zonecode;
								document.getElementById('lend_addr').value = data.address+ " ( "+ data.buildingName +" )";
								
							}
						}).open();
					}
				</script>
                <tr>
                    <td class=title>토지의 소재지</td>
               		<td colspan=3>
						&nbsp;<input type="text" name='lend_post' id="lend_post" size="7" maxlength='7'>
						<input type="button" onclick="openDaumPostcode4()" value="우편번호 찾기"><br>
						&nbsp;<input type="text" name='lend_addr' id="lend_addr" size="100">
					</td>
               		<td class=title>전화번호(휴대폰)</td>
               		<td>&nbsp;<input type="text" name="lend_m_tel" value="" maxlength='15' size="15" class=text></td>
                </tr>
               	<tr>
                    <td class=title>과세구분</td>
               		<td>
               			&nbsp;<input type="radio" name="lend_tax" value="0" > 과세
               			<input type="radio" name="lend_tax" value="1" > 면세
               		</td>
               		<td class=title>FAX</td>
               		<td colspan='3'>&nbsp;<input type="text" name="lend_fax" value="" size="15" maxlength='15' class=text></td>
                </tr>
                <tr>
                    <td class=title>총면적</td>
               		<td>&nbsp;<input type="text" name="lend_tot_ar" value="" size="6" maxlength='10' class=text></td>
               		<td class=title>관리담당자</td>
               		<td>&nbsp;<input type="text" name="lend_mng_agnt" value="" size="20" maxlength='20' class=text></td>
               		<td class=title>용도지역</td>
               		<td>&nbsp;<input type="text" name="lend_region" value="" size="20" maxlength='20' class=text></td>
                </tr>
                <tr>
                    <td class=title>수용면적</td>
               		<td>&nbsp;<input type="text" name="lend_cap_ar" value="" size="6" maxlength='10' class=text></td>
               		<td class=title>관할관청</td>
               		<td>&nbsp;<input type="text" name="lend_gov" value="" size="20" maxlength='20' class=text></td>
               		<td class=title>토지의지목</td>
               		<td>&nbsp;<input type="text" name="lend_cla" value="" size="20" maxlength='20' class=text></td>
                </tr>
                <tr>
                    <td class=title>수용대수</td>
               		<td>&nbsp;<input type="text" name="lend_cap_car" value="" size="6" maxlength='10' class=text> 대</td>
               		<td class=title>계약금액</td>
               		<td>&nbsp;<input type="text" name="cont_amt" value="" size="20" maxlength='20' class=text onblur="javascript:this.value=parseDecimal(this.value);"> 원</td>
               		<td class=title>&nbsp;</td>
               		<td>&nbsp;</td>
                </tr>
            </table>
        </td>
    </tr>
</table>
</form>
<iframe src="about:blank" name="i_no" width="0" height="0" frameborder="0" noresize>
</iframe>
</body>
</html>
