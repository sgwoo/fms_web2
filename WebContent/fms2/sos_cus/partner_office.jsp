<%@ page language="java" contentType="text/html;charset=euc-kr" %>
<%@ page import="java.util.*, acar.cont.*, acar.util.*, acar.user_mng.*, acar.partner.*"%>
<jsp:useBean id="u_bean" class="acar.user_mng.UsersBean" scope="page" />
<%@ include file="/acar/cookies.jsp" %>

<%
	LoginBean login = LoginBean.getInstance();
	UserMngDatabase umd = UserMngDatabase.getInstance();
	
	String po_id = request.getParameter("po_id")==null?"":request.getParameter("po_id");
	String br_id = request.getParameter("br_id")==null?"":request.getParameter("br_id");
	String reg_dt = request.getParameter("reg_dt")==null?"":request.getParameter("reg_dt");
	String user_id = request.getParameter("user_id")==null?"":request.getParameter("user_id");
	String upd_dt = request.getParameter("upd_dt")==null?"":request.getParameter("upd_dt");
	String upd_id = request.getParameter("upd_id")==null?"":request.getParameter("upd_id");
	String po_gubun = request.getParameter("po_gubun")==null?"":request.getParameter("po_gubun");
	String po_nm = request.getParameter("po_nm")==null?"":request.getParameter("po_nm");
	String po_own = request.getParameter("po_own")==null?"":request.getParameter("po_own");
	String po_no = request.getParameter("po_no")==null?"":request.getParameter("po_no");
	String po_sta = request.getParameter("po_sta")==null?"":request.getParameter("po_sta");
	String po_item = request.getParameter("po_item")==null?"":request.getParameter("po_item");
	String po_o_tel = request.getParameter("po_o_tel")==null?"":request.getParameter("po_o_tel");
	String po_m_tel = request.getParameter("po_m_tel")==null?"":request.getParameter("po_m_tel");
	String po_fax = request.getParameter("po_fax")==null?"":request.getParameter("po_fax");
	String po_post = request.getParameter("po_post")==null?"":request.getParameter("po_post");
	String po_addr = request.getParameter("po_addr")==null?"":request.getParameter("po_addr");
	String po_web = request.getParameter("po_web")==null?"":request.getParameter("po_web");
	String po_note = request.getParameter("po_note")==null?"":request.getParameter("po_note");
	
	
	
	int count = 0;
	
	
	reg_dt = Util.getDate();
	user_id = login.getCookieValue(request, "acar_id");
	u_bean = umd.getUsersBean(user_id);
	u_bean = umd.getUsersBean(br_id);

%>
<html>
<head>

<title>FMS</title>
<link rel="stylesheet" type="text/css" href="/include/table_t.css"></link>
<script language="JavaScript">
<!--

function PartherReg()
{
	var theForm = document.form1;
	theForm.cmd.value = "i";
	theForm.submit();
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
<body leftmargin="15" onLoad="self.focus()">

<form action="./partner_a.jsp" name="form1" method="POST" >
	<input type='hidden' name='user_id' value='<%=user_id%>'>
	<input type='hidden' name='br_id' value='<%=br_id%>'>
	
<table border=0 cellspacing=0 cellpadding=0 width="800">
    <tr>
    	<td>
    	    <table width=100% border=0 cellpadding=0 cellspacing=0>
                <tr>
                    <td width=7><img src=/acar/images/center/menu_bar_1.gif width=7 height=33></td>
                    <td class=bar>&nbsp;&nbsp;&nbsp;<img src=/acar/images/center/menu_bar_dot.gif width=4 height=5 align=absmiddle>&nbsp;<span class=style1> 인사관리 > 조직관리 > 비상연락망 > <span class=style5>협력업체등록</span></span></td>
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
	    	<table border="0" cellspacing="1" cellpadding="0" width="100%">
	    		<tr>
			    	<td class=title>구분</td>
			    	<td colspan='3'>&nbsp;
			    		<SELECT NAME="po_gubun">
							<OPTION VALUE="1">자동차 구매</OPTION>
							<OPTION VALUE="2">정비업체</OPTION>
							<OPTION VALUE="8">검사업체</OPTION>
							<OPTION VALUE="3">탁송업체</OPTION>
							<OPTION VALUE="6">용품업체</OPTION>
							<OPTION VALUE="4">보험사</OPTION>
							<OPTION VALUE="7">긴급출동</OPTION>
							<OPTION VALUE="5">기타</OPTION>
						</SELECT></td>
					<td class=title>이용지점</td>
					<td colspan=''>&nbsp;
			    		<SELECT NAME="br_id">
							<OPTION VALUE="S1">본사</OPTION>
							<OPTION VALUE="B1">부산지점</OPTION>
							<OPTION VALUE="D1">대전지점</OPTION>
							<OPTION VALUE="J1">광주지점</OPTION>
							<OPTION VALUE="G1">대구지점</OPTION>
						</SELECT></td>
			    </tr>
	    		<tr>
			    	<td width=10% class=title>상호</td>
			    	<td width=25%>&nbsp;
					  <input type="text" name="po_nm" value="" size="25" class=text ></td>
			    	<td width=10% class=title>성명</td>
			    	<td width=25%>&nbsp;
					  <input type="text" name="po_own" value="" size="25" class=text></td>					
			    	<td width=10% class=title>사업자번호</td>
			    	<td width=20%>&nbsp;
					  <input type="text" name="po_no" value="" size="20" class=text></td>
			    </tr>
			    <tr>
			    	<td class=title>핸드폰</td>
			    	<td>&nbsp;
					  <input type="text" name="po_m_tel" value="" size="20" class=text></td>
			    	<td class=title>전화</td>
			    	<td>&nbsp;
					  <input type="text" name="po_o_tel" value="" size="20" class=text></td>
			    	<td class=title>팩스</td>
			    	<td>&nbsp;
					  <input type="text" name="po_fax" value="" size="20" class=text></td>
			    </tr>
			    <tr>
			    	<td class=title>담당자</td>
			    	<td>&nbsp;
					  <input type="text" name="po_agnt_nm" value="" size="20" class=text></td>
			    	<td class=title>핸드폰</td>
			    	<td>&nbsp;
					  <input type="text" name="po_agnt_m_tel" value="" size="20" class=text></td>
			    	<td class=title>직통전화</td>
			    	<td>&nbsp;
					  <input type="text" name="po_agnt_o_tel" value="" size="20" class=text></td>
			    </tr>
			    <tr>
			    	<td class=title>구분2</td>
			    	<td>&nbsp;
					  <input type="text" name="po_item" value="" size="20" class=text></td>
			    	<td class=title>키워드</td>
			    	<td colspan='3'>&nbsp;
					  <input type="text" name="po_sta" value="" size="50" class=text></td>
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
				  <td class=title>사업장주소</td>
				  <td colspan=5>&nbsp;
					<input type="text" name="po_post" id="t_zip" size="7" maxlength='7' value="">
					<input type="button" onclick="openDaumPostcode()" value="우편번호 찾기"><br>
					&nbsp;&nbsp;<input type="text" name="po_addr" id="t_addr" size="90" value="">
				  </td>
				</tr>		
		
   			    <tr>
			    	<td class=title>이메일</td>
			    	<td>&nbsp;
					  <input type="text" name="po_email" value="" size="25" class=text></td>
			    	<td class=title>홈페이지</td>
			    	<td colspan="3" >&nbsp;
					  <input type="text" name="po_web" value="" size="50" class=text></td>
		    	</tr>				
			    <tr>
			    	<td class=title>특이사항</td>
			    	<td colspan="5">&nbsp;
					  <input type="text" name="po_note" value="" size="50" class=text></td>
		    	</tr>
			</table>
    	</td>
    </tr>
	<tr>
    	<td align="right" height=25><a href="javascript:PartherReg()"><img src=/acar/images/center/button_reg.gif border=0 align=absmiddle></a>&nbsp;<a href="javascript:window.close()"><img src=/acar/images/center/button_close.gif border=0 align=absmiddle></a></td>
    </tr>
</table>
<input type="hidden" name="cmd" vlaue="">
</form>

</body>
</html>