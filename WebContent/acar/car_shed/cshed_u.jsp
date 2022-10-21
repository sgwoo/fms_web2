<%@ page language="java" contentType="text/html;charset=euc-kr" %>
<%@ page import="java.util.*"%>
<%@ page import="acar.common.*, acar.util.*"%>
<%@ page import="acar.car_shed.*"%>
<jsp:useBean id="cs_db" scope="page" class="acar.car_shed.CarShedDatabase"/>
<%@ include file="/acar/cookies.jsp" %>

<%
	String auth_rw 	= request.getParameter("auth_rw")==null?"":request.getParameter("auth_rw"); //권한
	String user_id 	= request.getParameter("user_id")==null?"":request.getParameter("user_id");
	String br_id 	= request.getParameter("br_id")==null?"":request.getParameter("br_id");
	
	String brch 	= request.getParameter("brch")==null?"":request.getParameter("brch");
	
	String shed_id = request.getParameter("shed_id")==null?"":request.getParameter("shed_id");
	
	CommonDataBase c_db = CommonDataBase.getInstance();
	Vector branches = c_db.getBranchList();	/* 영업소 조회 */
	int brch_size = branches.size();
	
	CarShedBean shed = cs_db.getCarShed(shed_id);
%>

<html>
<head>
<title>FMS</title>
<link rel="stylesheet" type="text/css" href="/include/table_t.css"></link>
<%@ include file="/acar/getNaviCookies.jsp" %>
<script language="JavaScript" src='/include/common.js'></script>
<script language="JavaScript">
<!--

	function modify()
	{
		if(confirm('수정하시겠습니까?'))
		{
			var fm = document.form1;
			if(!isNum(fm.lea_ssn.value))	{	alert('임대/중개인 법인등록번호(생년월일)를 확인하십시오');	return;	}
			else if(!isNum(fm.lea_ent_no.value))	{	alert('임대/중개인 사업자등록번호를 확인하십시오');	return;	}
			else if(!isNum(fm.lend_ssn.value))		{	alert('토지소유자 법인등록번호(생년월일)를 확인하십시오');	return;	}
			else if(!isNum(fm.lend_ent_no.value))	{	alert('토지소유자 사업자등록번호를 확인하십시오');	return;	}
			else if(!isDate(fm.lea_st_dt.value))		{	alert('임대기간을 확인하십시오');	return;	}
			else if(!isDate(fm.lea_end_dt.value))	{	alert('임대기간을 확인하십시오');	return;	}
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
<style type=text/css>

<!--
.style1 {color: #666666}
.style2 {color: #515150; font-weight: bold;}
.style3 {color: #b3b3b3; font-size: 11px;}
.style4 {color: #737373; font-size: 11px;}
.style5 {color: #ef620c; font-weight: bold;}
.style6 {color: #4ca8c2; font-weight: bold;}
.style7 {color: #666666; font-size: 11px;}
-->

</style>
</head>
<body leftmargin="15">
<form action="/acar/car_shed/cshed_u_a.jsp" name="form1" method="POST">
<input type='hidden' name='auth_rw' value='<%=auth_rw%>'>
<input type='hidden' name='user_id' value='<%=user_id%>'>
<input type='hidden' name='br_id' value='<%=br_id%>'>
<input type='hidden' name='brch' value='<%=brch%>'>
<input type='hidden' name='shed_id' value='<%=shed_id%>'>
<input type='hidden' name='shed_st' value='1'>
<table border=0 cellspacing=0 cellpadding=0 width=100%>
	<tr>
    	<td>
    	    <table width=100% border=0 cellpadding=0 cellspacing=0 background=../images/center/menu_bar_bg.gif>
                <tr>
                    <td width=7><img src=../images/center/menu_bar_1.gif width=7 height=33></td>
                    <td class=bar>&nbsp;&nbsp;&nbsp;<img src=../images/center/menu_bar_dot.gif width=4 height=5 align=absmiddle>&nbsp;<span class=style1>Master > 차고지관리 > <span class=style5>차고지수정</span></span></td>
                    <td width=7><img src=../images/center/menu_bar_2.gif width=7 height=33></td>
                </tr>
            </table>
    	</td>
    </tr>
    <tr>
        <td></td>
    </tr>    
	<tr>
    	<td align=right>
    		<a href="javascript:modify()" onMouseOver="window.status=''; return true"><img src=../images/center/button_modify.gif border=0></a>
    		<a href="javascript:go_to_list()" onMouseOver="window.status=''; return true"><img src=../images/center/button_list.gif border=0></a>
    	</td>
    </tr>
    <tr>
        <td class=line2></td>
    </tr>
    <tr>
    	<td class=line>
            <table border="0" cellspacing="1" width=100%>
                <tr>
                    <td class=title width=8%>차고지명칭</td>
                    <td width=17%>&nbsp;<input type="text" name="shed_nm" value="<%=shed.getShed_nm()%>" size="40" maxlength='120' class=text></td>
                    <td class=title width=8%>관리영업소</td>
                    <td width=17%>
                    	&nbsp;<select name='mng_off'>
						<%	if(brch_size > 0){
								for (int i = 0 ; i < brch_size ; i++){
									Hashtable branch = (Hashtable)branches.elementAt(i);%>
			         	 	<option value='<%=branch.get("BR_ID")%>' <%if(shed.getMng_off().equals(branch.get("BR_ID"))){%>selected<%}%>><%=branch.get("BR_NM")%></option>
						<%		}
							}%>			
						</select>
                    </td>
                    <td class=title width=8%>관리담당자</td>
                    <td width=17%>&nbsp;<input type="text" name="mng_agnt" value="<%=shed.getMng_agnt()%>" size="20" maxlength='20' class=text></td>
                    <td class=title width=8%>계약여부</td>
                    <td width=17%>&nbsp;
                    	<select name="use_yn">
                    		<option value="Y" <%if(shed.getUse_yn().equals("Y")){%>selected<%}%>>진행중</option>
                    		<option value="N" <%if(shed.getUse_yn().equals("N")){%>selected<%}%>>계약만료</option>	
                    	</select>
                    </td>
                </tr>
            </table>
        </td>
    </tr>
    <tr>
        <td></td>
    </tr>
    <tr>
    	<td><img src=../images/center/icon_arrow.gif align=absmiddle>&nbsp;<a name="car"><b>임대/중개인사항</b></a>&nbsp;&nbsp;&nbsp;&nbsp;<font size='1'>(* 사업자등록번호는 '-' 없이 숫자만 입력하세요)</font></td>
    </tr>
    <tR>
        <td class=line2></td>
    </tr>
    <tr>
    	<td class=line>
    		<table border="0" cellspacing="1" width=100%>
                <tr>
                    <td class=title width=13%>성명</td>
               		<td width=21%>&nbsp;<input type="text" name="lea_nm" value="<%=shed.getLea_nm()%>" size="15" maxlength='20' class=text></td>
               		<td class=title width=12%>상호</td>
               		<td width=21%>&nbsp;<input type="text" name="lea_comp_nm" value="<%=shed.getLea_comp_nm()%>" size="20" maxlength='30' class=text></td>
               		<td class=title width=12%>업태</td>
               		<td width=21%>&nbsp;<input type="text" name="lea_sta" value="<%=shed.getLea_sta()%>" size="25" maxlength='30' class=text></td>
                </tr>
                <tr>
                    <td class=title>법인등록번호(생년월일)</td>
               		<td>&nbsp;<input type="text" name="lea_ssn" value="<%if(!shed.getLea_ssn().equals("")){%><%=shed.getLea_ssn().substring(0,6)%><%}%>" size="20" maxlength='13' class=text></td>
               		<td class=title>사업자등록번호</td>
               		<td>&nbsp;<input type="text" name="lea_ent_no" value="<%=shed.getLea_ent_no()%>" size="20" maxlength='10' class=text></td>
               		<td class=title>종목</td>
               		<td>&nbsp;<input type="text" name="lea_item" value="<%=shed.getLea_item()%>" size="25" maxlength='30' class=text></td>
                </tr>
                <tr>
                    <td class=title>임대기간</td>
               		<td colspan=3>&nbsp;<input type="text" name="lea_st_dt" value="<%=shed.getLea_st_dt()%>" size=12 maxlength='12' onBlur='javascript:this.value=ChangeDate(this.value)' class='text'> - <input type="text" name="lea_end_dt" value="<%=shed.getLea_end_dt()%>" size=10 maxlength='10' onBlur='javascript:this.value=ChangeDate(this.value)' class='text'></td>
                    <td class=title>임대구분</td>
               		<td>
               			&nbsp;	<input type="radio" name="lea_st" value="0" <%if(shed.getLea_st().equals("0")){%>checked<%}%>> 자가임대 
               					<input type="radio" name="lea_st" value="1" <%if(shed.getLea_st().equals("1")){%>checked<%}%>> 재임대
								<input type="radio" name="lea_st" value="2" <%if(shed.getLea_st().equals("1")){%>checked<%}%>> 임대
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
						&nbsp;<input type="text" name='lea_h_post' id="lea_h_post" size="7" maxlength='7' value="<%=shed.getLea_h_post()%>">
						<input type="button" onclick="openDaumPostcode()" value="우편번호 찾기"><br>
						&nbsp;<input type="text" name='lea_h_addr' id="lea_h_addr" size="100" value="<%=shed.getLea_h_addr()%>">
					</td>
               		<td class=title>전화번호(자택)</td>
               		<td>&nbsp;<input type="text" name="lea_h_tel" value="<%=shed.getLea_h_tel()%>" size="30" class=text></td>
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
						&nbsp;<input type="text" name='lea_o_post' id="lea_o_post" size="7" maxlength='7' value="<%=shed.getLea_o_post()%>">
						<input type="button" onclick="openDaumPostcode1()" value="우편번호 찾기"><br>
						&nbsp;<input type="text" name='lea_o_addr' id="lea_o_addr" size="100" value="<%=shed.getLea_o_addr()%>">
						&nbsp;<input type='checkbox' name='lea_o_addr_copy' onClick='javascript:set_lea_o_addr()'>상동
					</td>
               		<td class=title>전화번호(사무실)</td>
               		<td>&nbsp;<input type="text" name="lea_h_tel" value="<%=shed.getLea_h_tel()%>" size="15" maxlength='15' class=text></td>
                </tr>
                <tr>
                    <td class=title>과세구분</td>
               		<td>
               			&nbsp;<input type="radio" name="lea_tax_st" value="0"  <%if(shed.getLea_tax_st().equals("0")){%>checked<%}%>> 과세
               			<input type="radio" name="lea_tax_st" value="1"  <%if(shed.getLea_tax_st().equals("1")){%>checked<%}%>> 면세
               		</td>
               		<td class=title>FAX</td>
               		<td>&nbsp;<input type="text" name="lea_fax" value="<%=shed.getLea_fax()%>" size="15" maxlength='15' class=text></td>
               		<td class=title>전화번호(휴대폰)</td>
               		<td>&nbsp;<input type="text" name="lea_m_tel" value="<%=shed.getLea_m_tel()%>" size="15" maxlength='15' class=text></td>
                </tr>
            </table>
        </td>
    </tr>
    <tr>
        <td></td>
    </tr>
    <tr>
    	<td><img src=../images/center/icon_arrow.gif align=absmiddle>&nbsp;<a name="car"><b>토지사항</b></td>
    </tr>
    <tr>
        <td class=line2></td>
    </tr>
    </tr>
    	<td class=line>
    		<table border="0" cellspacing="1" width=100%>
                <tr>
                    <td class=title width=13%>토지소유자명</td>
               		<td width=21%>&nbsp;<input type="text" name="lend_own_nm" value="<%=shed.getLend_own_nm()%>" size="15" maxlength='20' class=text></td>
               		<td class=title width=12%>상호</td>
               		<td width=21%>&nbsp;<input type="text" name="lend_comp_nm" value="<%=shed.getLend_comp_nm()%>" size="20" maxlength='30' class=text></td>
               		<td class=title width=12%>업태</td>
               		<td width=21%>&nbsp;<input type="text" name="lend_sta" value="<%=shed.getLend_sta()%>" size="25" maxlength='30' class=text></td>
                </tr>
                <tr>
                    <td class=title>법인등록번호(생년월일)</td>
               		<td>&nbsp;<input type="text" name="lend_ssn" value="<%if(!shed.getLend_ssn().equals("")){%><%=shed.getLend_ssn().substring(0,6)%><%}%>" size="20" maxlength='13' class=text></td>
               		<td class=title>사업자등록번호</td>
               		<td>&nbsp;<input type="text" name="lend_ent_no" value="<%=shed.getLend_ent_no()%>" size="20" maxlength='10' class=text></td>
               		<td class=title>종목</td>
               		<td>&nbsp;<input type="text" name="lend_item" value="<%=shed.getLend_item()%>" size="25" maxlength='30' class=text></td>
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
						&nbsp;<input type="text" name='lend_h_post' id="lend_h_post" size="7" maxlength='7' value="<%=shed.getLend_h_post()%>">
						<input type="button" onclick="openDaumPostcode2()" value="우편번호 찾기"><br>
						&nbsp;<input type="text" name='lend_h_addr' id="lend_h_addr" size="100" value="<%=shed.getLend_h_addr()%>">
					</td>
               		<td class=title>전화번호(자택)</td>
               		<td>&nbsp;<input type="text" name="lend_h_tel" value="<%=shed.getLend_h_tel()%>" size="15" maxlength='15' class=text></td>
                </tr>
				<script>
					function openDaumPostcode3() {
						new daum.Postcode({
							oncomplete: function(data) {
								document.getElementById('lend_o_post').value = data.zonecode;
								document.getElementById('lend_o_addr').value = data.address+ " ( "+ data.buildingName +" )";
								
							}
						}).open();
					}
				</script>
                <tr>
                    <td class=title>사업장주소</td>
               		<td colspan=3>
						&nbsp;<input type="text" name='lend_o_post' id="lend_o_post" size="7" maxlength='7' value="<%=shed.getLend_o_post()%>">
						<input type="button" onclick="openDaumPostcode3()" value="우편번호 찾기"><br>
						&nbsp;<input type="text" name='lend_o_addr' id="lend_o_addr" size="100" value="<%=shed.getLend_o_addr()%>">
						&nbsp;<input type='checkbox' name='lend_o_addr_copy' onClick='javascript:set_lend_o_addr()'>상동
					</td>
               		<td class=title>전화번호(사무실)</td>
               		<td>&nbsp;<input type="text" name="lend_o_tel" value="<%=shed.getLend_o_tel()%>" size="15" maxlength='15' class=text></td>
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
						&nbsp;<input type="text" name='lend_post' id="lend_post" size="7" maxlength='7' value="<%=shed.getLend_post()%>">
						<input type="button" onclick="openDaumPostcode4()" value="우편번호 찾기"><br>
						&nbsp;<input type="text" name='lend_addr' id="lend_addr" size="100" value="<%=shed.getLend_addr()%>">
					</td>
               		<td class=title>전화번호(휴대폰)</td>
               		<td>&nbsp;<input type="text" name="lend_m_tel" value="<%=shed.getLend_m_tel()%>" maxlength='15' size="15" class=text></td>
                </tr>
               	<tr>
                    <td class=title>과세구분</td>
               		<td>
               			&nbsp;<input type="radio" name="lend_tax" value="0"  <%if(shed.getLend_tax().equals("0")){%>checked<%}%>> 과세
               			<input type="radio" name="lend_tax" value="1" <%if(shed.getLend_tax().equals("1")){%>checked<%}%>> 면세
               		</td>
               		<td class=title>FAX</td>
               		<td colspan='3'>&nbsp;<input type="text" name="lend_fax" value="<%=shed.getLend_fax()%>" size="15" maxlength='15' class=text></td>
                </tr>
                <tr>
                    <td class=title>총면적</td>
               		<td>&nbsp;<input type="text" name="lend_tot_ar" value="<%=shed.getLend_tot_ar()%>" size="6" maxlength='10' class=text></td>
               		<td class=title>관리담당자</td>
               		<td>&nbsp;<input type="text" name="lend_mng_agnt" value="<%=shed.getLend_mng_agnt()%>" size="20" maxlength='20' class=text></td>
               		<td class=title>용도지역</td>
               		<td>&nbsp;<input type="text" name="lend_region" value="<%=shed.getLend_region()%>" size="20" maxlength='20' class=text></td>
                </tr>
                <tr>
                    <td class=title>수용면적</td>
               		<td>&nbsp;<input type="text" name="lend_cap_ar" value="<%=shed.getLend_cap_ar()%>" size="6" maxlength='10' class=text></td>
               		<td class=title>관할관청</td>
               		<td>&nbsp;<input type="text" name="lend_gov" value="<%=shed.getLend_gov()%>" size="20" maxlength='20' class=text></td>
               		<td class=title>토지의지목</td>
               		<td>&nbsp;<input type="text" name="lend_cla" value="<%=shed.getLend_cla()%>" size="20" maxlength='20' class=text></td>
                </tr>
                <tr>
                    <td class=title>수용대수</td>
               		<td>&nbsp;<input type="text" name="lend_cap_car" value="<%=shed.getLend_cap_car()%>" size="6" maxlength='10' class=text> 대</td>
               		<td class=title>계약금액</td>
               		<td>&nbsp;<input type="text" name="cont_amt" value="<%=AddUtil.parseDecimal(shed.getCont_amt())%>" size="20" maxlength='20' class=text onblur="javascript:this.value=parseDecimal(this.value);"> 원</td>
               		<td class=title>&nbsp;</td>
               		<td>&nbsp;</td>
                </tr>
            </table>
        </td>
    </tr>
</table>
</form>
<iframe src="about:blank" name="i_no" width="200" height="100" cellpadding="0" cellspacing="0" border="1" frameborder="0" noresize>
</iframe>
</body>
</html>
