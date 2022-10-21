<%@ page language="java" contentType="text/html;charset=euc-kr" %>
<%@ page import="java.util.*, acar.cont.*, acar.util.*, acar.user_mng.*, acar.insa_card.*"%>
<%@ include file="/acar/cookies.jsp" %>
<%
	String user_id = request.getParameter("user_id")==null?"":request.getParameter("user_id");
	int seq = request.getParameter("seq")==null?1:Util.parseInt(request.getParameter("seq"));
	String ls_dt = request.getParameter("ls_dt")==null?"":request.getParameter("ls_dt");
	String ls_name = request.getParameter("ls_name")==null?"":request.getParameter("ls_name");
	String ls_bmng = request.getParameter("ls_bmng")==null?"":request.getParameter("ls_bmng");
	String ls_num = request.getParameter("ls_num")==null?"":request.getParameter("ls_num");
	String cmd = request.getParameter("cmd")==null?"":request.getParameter("cmd");
	
%>
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=euc-kr">
<link rel=stylesheet type="text/css" href="/include/table_t.css">
<title>자격/면허 입력</title>
<script language='javascript' src='/include/common.js'></script>
<script language='javascript'>
<!--
	
function reg(){
	var fm = document.form1;
	
	fm.cmd.value = "ls";	
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
                    <td class=bar>&nbsp;&nbsp;&nbsp;<img src=/acar/images/center/menu_bar_dot.gif width=4 height=5 align=absmiddle>&nbsp;<span class=style1>인사관리 > 조직관리 > 인사기록카드 > <span class=style5> 자격/면허 입력</span></span></td>
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
					<td class=title width="15%">자격/면허명</td>
					<td>&nbsp;<input type='text' name="ls_name" value='' size='30' class='text'></td>
					<td class=title width="15%">자격/면허번호</td>
					<td>&nbsp;<input type='text' name="ls_num" value='' size='30' class='text'></td>
				</tr>
				<tr>
					<td class=title width="15%">취득년월일</td>
					<td>&nbsp;<input type='text' name="ls_dt" value='' size='30' class='text'>&nbsp;(예:20130909)</td>
					<td class=title width="15%">발행기관</td>
					<td>&nbsp;<input type='text' name="ls_bmng" value='' size='30' class='text'></td>
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

</body>
</html>
