<%@ page language="java" contentType="text/html;charset=euc-kr" %>
<%@ page import="java.util.*, acar.cont.*, acar.util.*, acar.user_mng.*, acar.insa_card.*"%>

<%@ include file="/acar/cookies.jsp" %>
<%
	String user_id = request.getParameter("user_id")==null?"":request.getParameter("user_id");
	int seq = request.getParameter("seq")==null?1:Util.parseInt(request.getParameter("seq"));
	String sb_dt = request.getParameter("sb_dt")==null?"":request.getParameter("sb_dt");
	String sb_gubun = request.getParameter("sb_gubun")==null?"":request.getParameter("sb_gubun");
	String sb_content = request.getParameter("sb_content")==null?"":request.getParameter("sb_content");
	String sb_js_dt = request.getParameter("sb_js_dt")==null?"":request.getParameter("sb_js_dt");
	String sb_je_dt = request.getParameter("sb_je_dt")==null?"":request.getParameter("sb_je_dt");
	
	String cmd = request.getParameter("cmd")==null?"":request.getParameter("cmd");
	
%>
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=euc-kr">
<link rel=stylesheet type="text/css" href="/include/table_t.css">
<title>������� �Է�</title>
<script language='javascript' src='/include/common.js'></script>
<script language='javascript'>
<!--
	
function reg(){
	var fm = document.form1;
	
	fm.cmd.value = "sb";	
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
                    <td class=bar>&nbsp;&nbsp;&nbsp;<img src=/acar/images/center/menu_bar_dot.gif width=4 height=5 align=absmiddle>&nbsp;<span class=style1>�λ���� > �������� > �λ���ī�� > <span class=style5> ������� �Է�</span></span></td>
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
					<td class=title width="10%">����</td>
					<td width="10%">&nbsp;
						����<INPUT TYPE="radio" NAME="sb_gubun" value='1' > &nbsp;&nbsp;
						¡�� <SELECT NAME="sb_gubun">
							<OPTION VALUE="2">�ø�������</OPTION>
							<OPTION VALUE="3">����</OPTION>
							<OPTION VALUE="4">���߷�</OPTION>
							<OPTION VALUE="5">�ذ�</OPTION>
						</SELECT>
					</td>
					<td class=title width="10%">��¥</td>
					<td width="10%">&nbsp;<input type='text' name="sb_dt" value='' size='30' class='text'></td>
				</tr>
				<tr>
					<td class=title width="10%">��������</td>
					<td width="10%">&nbsp;<input type='text' name="sb_js_dt" value='' size='30' class='text'></td>
					<td class=title width="10%">��������</td>
					<td width="10%">&nbsp;<input type='text' name="sb_je_dt" value='' size='30' class='text'></td>
				</tr>
				<tr>
					<td class=title width="10%">����</td>
					<td colspan="3">&nbsp;<input type='text' name="sb_content" value='' size='100' class='text'></td>
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
