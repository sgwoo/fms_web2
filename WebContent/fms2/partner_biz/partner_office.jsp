<%@ page language="java" contentType="text/html;charset=euc-kr" %>
<%@ page import="java.util.*, acar.cont.*, acar.util.*, acar.user_mng.*, acar.partner.*"%>
<jsp:useBean id="u_bean" class="acar.user_mng.UsersBean" scope="page" />
<%@ include file="/acar/cookies.jsp" %>

<%
	LoginBean login = LoginBean.getInstance();
	UserMngDatabase umd = UserMngDatabase.getInstance();
	String br_id = request.getParameter("br_id")==null?"":request.getParameter("br_id");
	String reg_dt = request.getParameter("reg_dt")==null?"":request.getParameter("reg_dt");
	String user_id = request.getParameter("user_id")==null?"":request.getParameter("user_id");

	
	
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

function search_zip()
{
		window.open("./partner_zip.jsp", "우편번호검색", "left=100, height=200, width=350, height=300, scrollbars=yes");
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
	
<table border=0 cellspacing=0 cellpadding=0 width="700">
    <tr>
    	<td>
    	    <table width=100% border=0 cellpadding=0 cellspacing=0>
                <tr>
                    <td width=7><img src=/acar/images/center/menu_bar_1.gif width=7 height=33></td>
                    <td class=bar>&nbsp;&nbsp;&nbsp;<img src=/acar/images/center/menu_bar_dot.gif width=4 height=5 align=absmiddle>&nbsp;<span class=style1> 협력업체 > 외부업체로그인 > <span class=style5>아이디관리</span></span></td>
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
			    	<td width=10% class=title>구분</td>
			    	<td width=15% align="center">
			    		<SELECT NAME="po_gubun">
							<OPTION VALUE="9">협력업체</OPTION>
						</SELECT></td>
			    	<td width=10% class=title>상호</td>
			    	<td width=23% align="center"><input type="text" name="po_nm" value="" size="25" class=text ></td>
			    	<td width=10% class=title>사업자번호</td>
			    	<td width=23% align="center" ><input type="text" name="po_no" value="" size="25" class=text  ></td>
			    </tr>
			    <tr>
			    	<td width=10% class=title>담당자</td>
			    	<td width=15% align="center"><input type="text" name="po_own" value="" size="15" class=text></td>
			    	<td width=10% class=title>직급</td>
			    	<td width=23% align="center"><input type="text" name="po_item" value="" size="25" class=text></td>
			    	<td width=10% class=title>E_mail</td>
			    	<td width=23% align="center"><input type="text" name="po_sta" value="" size="25" class=text></td>
			    </tr>
			    <tr>
			    	<td width=10% class=title>담당자휴대폰</td>
			    	<td width=15% align="center"><input type="text" name="po_m_tel" value="" size="15" class=text></td>
			    	<td width=10% class=title>담당자전화</td>
			    	<td width=23% align="center"><input type="text" name="po_o_tel" value="" size="25" class=text></td>
			    	<td width=10% class=title>담당자팩스</td>
			    	<td width=23% align="center"><input type="text" name="po_fax" value="" size="25" class=text></td>
			    </tr>
   			    <tr>
			    	<td width=10% class=title>사업장주소</td>
			    	<td colspan="5" >&nbsp;<input type="text" name="po_post" value="" size="6" class=text onClick="javascript:search_zip()" readonly> <input type="text" name="po_addr" value="" size="91" class=text></td>
		    	</tr>
			    <tr>
			    	<td width=10% class=title>특이사항</td>
			    	<td colspan="5" width=40%>&nbsp;<input type="text" name="po_note" value="" size="100" class=text></td>
				</tr>
			    <tr>	
			    	<td width=10% class=title>홈페이지</td>
			    	<td colspan="5" width=40%>&nbsp;<input type="text" name="po_web" value="" size="100" class=text></td>
		    	</tr>
				<tr>
			    	<td width=10% class=title>아이디</td>
			    	<td colspan="2" width=40%>&nbsp;<input type="text" name="po_login_id" value="" size="30" class=text></td>
			    	<td width=10% class=title>패스워드</td>
			    	<td colspan="2" width=40%>&nbsp;<input type="text" name="po_login_ps" value="" size="35" class=text></td>
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