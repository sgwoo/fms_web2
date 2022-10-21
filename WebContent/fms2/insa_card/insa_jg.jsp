<%@ page language="java" contentType="text/html;charset=euc-kr" %>
<%@ page import="java.util.*, acar.cont.*, acar.util.*, acar.user_mng.*, acar.insa_card.*"%>

<%@ include file="/acar/cookies.jsp" %>
<%
	String user_id = request.getParameter("user_id")==null?"":request.getParameter("user_id");
	int seq = request.getParameter("seq")==null?1:Util.parseInt(request.getParameter("seq"));
	String jg_dt = request.getParameter("jg_dt")==null?"":request.getParameter("jg_dt");
	String br_dt = request.getParameter("br_dt")==null?"":request.getParameter("br_dt");
	String pos = request.getParameter("pos")==null?"":request.getParameter("pos");
	String auth_rw 	= request.getParameter("auth_rw")==null?"":request.getParameter("auth_rw");
	String cmd = request.getParameter("cmd")==null?"":request.getParameter("cmd");
	
%>
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=euc-kr">
<link rel=stylesheet type="text/css" href="/include/table_t.css">
<title>상벌사항 입력</title>
<script language='javascript' src='/include/common.js'></script>
<script language='javascript'>
<!--
	
function reg(){
	var fm = document.form1;
	
	fm.cmd.value = "jg";	
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
<input type="hidden" name="auth_rw" value="<%=auth_rw%>"> 
<input type="hidden" name="cmd" value="">	
<table width="100%" border="0" cellpadding="0" cellspacing="0">
	<tr> 
        <td colspan=100>
            <table width=100% border=0 cellpadding=0 cellspacing=0>
                <tr>
                    <td width=7><img src=/acar/images/center/menu_bar_1.gif width=7 height=33></td>
                    <td class=bar>&nbsp;&nbsp;&nbsp;<img src=/acar/images/center/menu_bar_dot.gif width=4 height=5 align=absmiddle>&nbsp;<span class=style1>인사관리 > 조직관리 > 인사기록카드 > <span class=style5> 진급 입력</span></span></td>
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
					<td class=title width="10%">구분</td>
					<td width="10%" colspan="3">&nbsp;
						<SELECT NAME="pos">
							<OPTION VALUE="대리">대리</OPTION>
							<OPTION VALUE="과장">과장</OPTION>
							<OPTION VALUE="차장">차장</OPTION>
							<OPTION VALUE="부장">부장</OPTION>
							<OPTION VALUE="이사">이사</OPTION>
						</SELECT>
					</td>
				</tr>
				<tr>
					<td class=title width="10%">진급일자</td>
					<td width="10%">&nbsp;<input type='text' name="jg_dt" value='' size='25' class='text'></td>
					<td class=title width="10%">발령일자</td>
					<td width="10%">&nbsp;<input type='text' name="br_dt" value='' size='25' class='text'></td>
				</tr>
				<tr>
					<td class=title width="10%">적요</td>
					<td width="" colspan="3">&nbsp;<input type='text' name="note" value='' size='90' class='text'></td>
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
<iframe src="about:blank" name="i_no" width="100" height="100" cellpadding="0" cellspacing="0" border="1" frameborder="0" noresize>
</body>
</html>
