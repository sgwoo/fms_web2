<%@ page language="java" contentType="text/html;charset=euc-kr" %>
<%@ page import="java.util.*, acar.cont.*, acar.util.*, acar.user_mng.*, acar.insa_card.*"%>
<%@ include file="/acar/cookies.jsp" %>
<%
	String user_id = request.getParameter("user_id")==null?"":request.getParameter("user_id");
	int seq = request.getParameter("seq")==null?1:Util.parseInt(request.getParameter("seq"));
	String sc_gubun = request.getParameter("sc_gubun")==null?"":request.getParameter("sc_gubun");
	String sc_ed_dt = request.getParameter("sc_ed_dt")==null?"":request.getParameter("sc_ed_dt");
	String sc_name = request.getParameter("sc_name")==null?"":request.getParameter("sc_name");
	String sc_study = request.getParameter("sc_study")==null?"":request.getParameter("sc_study");
	String sc_st = request.getParameter("sc_st")==null?"":request.getParameter("sc_st");
	String cmd = request.getParameter("cmd")==null?"":request.getParameter("cmd");
	
%>
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=euc-kr">
<link rel=stylesheet type="text/css" href="/include/table_t.css">
<title>학력 입력</title>
<script language='javascript' src='/include/common.js'></script>
<script language='javascript'>
<!--
	
function reg(){
	var fm = document.form1;
	
	fm.cmd.value = "sc";	
	fm.target="i_no";
	fm.action="./insa_card_null.jsp";		
	fm.submit();
}

//-->
</script>
</head>

<body>
<form name='form1'  method='post'>
<input type="hidden" name="user_id" value="<%=user_id%>"> 
<input type="hidden" name="cmd" value="">
<table width="100%" border="0" cellpadding="0" cellspacing="0">
	<tr> 
        <td colspan=100>
            <table width=100% border=0 cellpadding=0 cellspacing=0>
                <tr>
                    <td width=7><img src=/acar/images/center/menu_bar_1.gif width=7 height=33></td>
                    <td class=bar>&nbsp;&nbsp;&nbsp;<img src=/acar/images/center/menu_bar_dot.gif width=4 height=5 align=absmiddle>&nbsp;<span class=style1>인사관리 > 조직관리 > 인사기록카드 > <span class=style5> 학력입력</span></span></td>
                    <td width=7><img src=/acar/images/center/menu_bar_2.gif width=7 height=33></td>
                </tr>
            </table>            
        </td>
    </tr>
    <tr> 
        <td class=h></td>
    </tr>
    <tr> 
        <td class=h></td>
    </tr>
	<TR>
		<td class=line>
			<table border=0 cellspacing=1 width=100%>
				<tr>
					<td width="20%" class=title>구분</td>
					<td> 
						<SELECT NAME="sc_gubun">
							<OPTION VALUE="1">고등학교</OPTION>
							<OPTION VALUE="2">대학교</OPTION>
							<OPTION VALUE="3">대학원</OPTION>
							<OPTION VALUE="4">기타</OPTION>
						</SELECT>
				  </td>
					<td width="20%" class=title>년월일</td>
					<td>&nbsp;<input type='text' name="sc_ed_dt" value='' size='20' class='text'">&nbsp;(예:20130909)</td>
					<td width="20%" class=title>상태</td>
					<td>
						<SELECT NAME="sc_st">
							<OPTION VALUE="1">입학</OPTION>
							<OPTION VALUE="2">졸업</OPTION>
							<OPTION VALUE="3">편입</OPTION>
							<OPTION VALUE="4">졸예</OPTION>
							<OPTION VALUE="5">수료</OPTION>
							<OPTION VALUE="6">재학</OPTION>
							<OPTION VALUE="7">휴학</OPTION>
						</SELECT>
					</td>
				</tr>
				<tr>
					<td width="20%" class=title>학교명</td>
					<td colspan = "2">&nbsp;<input type='text' name="sc_name" value='' size='40' class='text'"></td>
					<td width="20%" class=title>전공명</td>
					<td colspan = "2">&nbsp;<input type='text' name="sc_study" value='' size='25' class='text'"></td>
				</tr>
			</table>
		</td>
	</tr>
	<tr> 
        <td class=h align="right">  </td>
	<tr> 
        <td class=h align="right">
        	<a href="javascript:reg()"><img src="/acar/images/center/button_reg.gif" border="0" align="absmiddle"></a>
			<a href="javascript:window.close()"><img src="/acar/images/center/button_close.gif" border="0" align="absmiddle"></a>        	
        	</td>
    </tr>
</table>
</from>
</body>
</html>
