<%@ page language="java" contentType="text/html;charset=euc-kr"%>
<%@ page import="java.util.*, acar.util.*"%>
<%@ page import="acar.common.*"%>
<%@ include file="/acar/cookies.jsp" %>
<%
	CommonDataBase c_db = CommonDataBase.getInstance();
	CodeBean[] banks = c_db.getCodeAll("0003"); /* 코드 구분:은행명 */	
	int bank_size = banks.length;
%>
<%
	//height
	int sh_height = request.getParameter("sh_height")==null?0:Util.parseInt(request.getParameter("sh_height"));//상단길이
%>
<html>
<head>
<meta http-equiv="content-type" content="text/html; charset=euc-kr">
<%@ include file="/acar/getNaviCookies.jsp" %>
<title>FMS</title>
<link rel='stylesheet' type='text/css' href='/include/table_t.css'>
<script language="JavaScript">
<!--
	function cng_input()
	{
		var fm = document.form1;
		if(fm.s_kd.options[fm.s_kd.selectedIndex].value == '2')
		{
			td_input.style.display	= 'none';
			td_slt.style.display 	= '';
		}
		else
		{
			td_input.style.display	= '';
			td_slt.style.display 	= 'none';
		}
	}
	
	function search()
	{
		document.form1.submit();
	}
	
	function enter() 
	{
		var keyValue = event.keyCode;
		if (keyValue =='13') search();
	}		
//-->
</script>
</head>
<body>
<form name='form1' method='post' action='/acar/condition/debt_condition_sc.jsp' target='c_body'>
<input type='hidden' name='sh_height' value='<%=sh_height%>'> 
<table border=0 cellspacing=0 cellpadding=0 width='100%'>
  		<tr>
    	<td colspan=10>
    	    <table width=100% border=0 cellpadding=0 cellspacing=0>
                <tr>
                    <td width=7><img src=/acar/images/center/menu_bar_1.gif width=7 height=33></td>
                    <td class=bar>&nbsp;&nbsp;&nbsp;<img src=/acar/images/center/menu_bar_dot.gif width=4 height=5 align=absmiddle>&nbsp;<span class=style1>재무회계 > 구매자금관리 > <span class=style5>할부현황</span></span></td>
        
                    <td width=7><img src=/acar/images/center/menu_bar_2.gif width=7 height=33></td>
                </tr>
            </table>
    	</td>
    </tr>
    <tr>
        <td class=h></td>
    </tr>
    <tr>
        <td>
            <table border='0' cellspacing='1' cellpadding='0' width='100%'>
            	<tr>
            		<td width='17%'>
            			&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;<img src=/acar/images/center/arrow_gsjg.gif  align=absmiddle> &nbsp;  
            			<select name='s_kd' onChange='javascript:cng_input()'>
            				<option value='0'>전체</option>
            				<option value='1'>상호</option>
            				<option value='2'>금융사명</option>
            				<option value='3'>차종</option>
            			</select>
            		</td>
					<td width='650' id='td_input' align='left'>
						<input type='text' name='t_wd' size='15' class='text' value='' onKeyDown='javascript:enter()'>&nbsp;&nbsp;
						<a href='javascript:search()' onMouseOver="window.status=''; return true"><img src=/acar/images/center/button_search.gif  align=absmiddle border="0"></a>
					</td>
					<td width='650' id='td_slt' align='left' style='display:none'>
						<select name='s_bank'>
<%
	if(bank_size > 0)
	{
		for(int i = 0 ; i < bank_size ; i++)
		{
			CodeBean bank = banks[i];
%>
								<option value='<%= bank.getCode()%>'> <%= bank.getNm()%> </option>
<%		}
	}
%>							</select>&nbsp;&nbsp;
						<a href='javascript:search()' onMouseOver="window.status=''; return true"><img src="/acar/images/center/button_search.gif" align="absmiddle" border="0"></a>
					</td>	
				</tr>
            </table>
        </td>
    </tr>
</table>
</form>
</body>
</html>