<%@ page language="java" contentType="text/html;charset=euc-kr" %>
<%@ page import="java.util.*, acar.cont.*, acar.util.*, acar.user_mng.*, acar.insa_card.*"%>

<%@ include file="/acar/cookies.jsp" %>
<%
	String user_id = request.getParameter("user_id")==null?"":request.getParameter("user_id");
	int seq = request.getParameter("seq")==null?1:Util.parseInt(request.getParameter("seq"));
	String wk_st_dt = request.getParameter("wk_st_dt")==null?"":request.getParameter("wk_st_dt");
	String wk_ed_dt = request.getParameter("wk_ed_dt")==null?"":request.getParameter("wk_ed_dt");
	String wk_name = request.getParameter("wk_name")==null?"":request.getParameter("wk_name");
	String wk_pos = request.getParameter("wk_pos")==null?"":request.getParameter("wk_pos");
	String wk_work = request.getParameter("wk_work")==null?"":request.getParameter("wk_work");
	String wk_emp = request.getParameter("wk_emp")==null?"":request.getParameter("wk_emp");
	String cmd = request.getParameter("cmd")==null?"":request.getParameter("cmd");
	
%>
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=euc-kr">
<link rel=stylesheet type="text/css" href="/include/table_t.css">
<title>전직경력사항 입력</title>
<script language='javascript' src='/include/common.js'></script>
<script language='javascript'>
<!--
	
function reg(){
	var fm = document.form1;
	
	if(get_length(fm.wk_st_dt.value) != 8 || get_length(fm.wk_ed_dt.value) != 8){		
		alert("근무기간을 다시 확인하세요.!!");		return;		}
		
	fm.cmd.value = "wk";	
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
                    <td class=bar>&nbsp;&nbsp;&nbsp;<img src=/acar/images/center/menu_bar_dot.gif width=4 height=5 align=absmiddle>&nbsp;<span class=style1>인사관리 > 조직관리 > 인사기록카드 > <span class=style5> 전직경력사항 입력</span></span></td>
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
				<TR>
					<td class=title width="10%">고용형태</td>
					<td>&nbsp;&nbsp;
						<SELECT NAME="wk_emp">
							<OPTION VALUE="1">상용직</OPTION>
							<OPTION VALUE="2">계약직</OPTION>
							<OPTION VALUE="3">임시직</OPTION>
						</SELECT>
					</td>
					<td class=title width="10%">직위</td>
					<td>&nbsp;<input type='text' name="wk_pos" value='' size='20' class='text'></td>						
				</tr>
				<tr>
					<td class=title width="10%">근무기간</td>
					<td>&nbsp;<input type='text' name="wk_st_dt" value='' size='15' class='text'>~<input type='text' name="wk_ed_dt" value='' size='15' class='text'></td>
					<td class=title width="10%">근무처</td>
					<td>&nbsp;<input type='text' name="wk_title" value='' size='30' class='text'></td>
				</TR>
				<tr>
					<td class=title width="10%">근무부서</td>
					<td COLSPAN="">&nbsp;<input type='text' name="wk_name" value='' size='30' class='text'></td>
					<td class=title width="10%">담당업무</td>
					<td COLSPAN="">&nbsp;<input type='text' name="wk_work" value='' size='40' class='text'></td>
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
