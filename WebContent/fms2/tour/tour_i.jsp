<%@ page language="java" contentType="text/html;charset=euc-kr" %>
<%@ page import="java.util.*, acar.util.*, acar.user_mng.*, acar.tour.*"%>

<%@ include file="/acar/cookies.jsp" %>
<%
	String user_id = request.getParameter("user_id")==null?"":request.getParameter("user_id");
	int seq = request.getParameter("seq")==null?1:Util.parseInt(request.getParameter("seq"));
	String ps_dt = request.getParameter("ps_dt")==null?"":request.getParameter("ps_dt");
	String ps_content = request.getParameter("ps_content")==null?"":request.getParameter("ps_content");
	String ps_str_dt = request.getParameter("ps_str_dt")==null?"":request.getParameter("ps_str_dt");
	String ps_end_dt = request.getParameter("ps_end_dt")==null?"":request.getParameter("ps_end_dt");
	String ps_amt = request.getParameter("ps_amt")==null?"":request.getParameter("ps_amt");
	String cmd = request.getParameter("cmd")==null?"":request.getParameter("cmd");
	
%>
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=euc-kr">
<link rel=stylesheet type="text/css" href="/include/table_t.css">
<title>포상 입력</title>
<script language='javascript' src='/include/common.js'></script>
<script language='javascript'>
<!--
	
function reg(){
	var fm = document.form1;
	
	fm.cmd.value = "i";	
	fm.target="i_no";
	fm.action="./tour_a.jsp";		
	fm.submit();
}

function ChangeDT()
{
	var theForm = document.form1;
	theForm.exp_dt.value = ChangeDate(theForm.exp_dt.value);
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
                    <td class=bar>&nbsp;&nbsp;&nbsp;<img src=/acar/images/center/menu_bar_dot.gif width=4 height=5 align=absmiddle>&nbsp;<span class=style1><span class=style5> 포상 입력</span></span></td>
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
					<td class=title width="20%">포상구분</td>
					<td width="30%" align='center'>장기근속사원포상</td>
					<td class=title width="10%">포상일자</td>
					<td width="15%">&nbsp;<input type='text' name="ps_dt" value='' size='15' class='text' ></td>
					<td class=title width="10%">포상년차</td>
					<td width="15%">&nbsp;<SELECT NAME="ps_count">
											<OPTION VALUE="5" SELECTED>5년차
											<OPTION VALUE="11" >11년차
											<OPTION VALUE="18" >18년차
											<OPTION VALUE="25" >25년차
											</SELECT>
											<SELECT NAME="jigub">
											<OPTION VALUE="" SELECTED>선택
											<OPTION VALUE="Y" >지급		
											</SELECT>
					</td>
				</tr>
				<tr>
					<td class=title width="50%" colspan="2">포상휴가일정</td>
					<td class=title width="10%">일정시작일자</td>
					<td width="15%">&nbsp;<input type='text' name="ps_str_dt" value='' size='15' class='text' ></td>
					<td class=title width="10%">일정종료일자</td>
					<td width="15%">&nbsp;<input type='text' name="ps_end_dt" value='' size='15' class='text' ></td>
				</tr>
				<tr>
					<td class=title width="50%" colspan="2">내용(휴가지)</td>
					<td colspan="4">&nbsp;<input type='text' name="ps_content" value='' size='70' class='text'></td>
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
<iframe src="about:blank" name="i_no" width="0" height="0" frameborder="0" noresize></iframe>
</body>
</html>
