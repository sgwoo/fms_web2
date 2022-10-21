<%@ page language="java" contentType="text/html;charset=euc-kr"%>
<%@ page import="java.util.*, acar.util.*"%>
<%@ include file="/acar/cookies.jsp" %>
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
<form name='form1' method='post' action='/fms2/condition/auc_dlv_sc.jsp' target='c_body'>
<input type='hidden' name='sh_height' value='<%=sh_height%>'> 
<table border=0 cellspacing=0 cellpadding=0 width='100%'>
	<tr>
    	<td>
    	    <table width=100% border=0 cellpadding=0 cellspacing=0>
                <tr>
                    <td width=7><img src=/acar/images/center/menu_bar_1.gif width=7 height=33></td>
                    <td class=bar>&nbsp;&nbsp;&nbsp;<img src=/acar/images/center/menu_bar_dot.gif width=4 height=5 align=absmiddle>&nbsp;<span class=style1>영업지원 > 계출관리 > <span class=style5>경매출고현황</span></span></td>
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
            		<td width=300>
            			&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;<img src=/acar/images/center/arrow_gsjg.gif align=absmiddle>&nbsp;
            			<select name='s_kd'>
            				<option value='0'>전체</option>
            				<option value='5'>출고지점</option>
            			</select>
						<input type='text' name='t_wd' size='15' class='text' value='' onKeyDown='javascript:enter()'>
					</td>
					<td>
						<input type="radio" name="dt" value="1" > 전월
            			<input type="radio" name="dt" value="2" checked > 당월
            			<input type="radio" name="dt" value="3"> 조회기간
						<input type='text' name='t_st_dt' size='11' class='text' value='' onClick='javascript:document.form1.dt[2].checked=true;'> ~
						<input type='text' name='t_end_dt' size='11' class='text' value='' onClick='javascript:document.form1.dt[2].checked=true;'>
						&nbsp;
						<a href='javascript:search()'><img src=/acar/images/center/button_search.gif border=0 align=absmiddle></a>
					</td>
						
				</tr>
            </table>
        </td>
    </tr>
</table>
</form>
</body>
</html>