<%@ page language="java" contentType="text/html;charset=euc-kr" %>
<%@ page import="java.util.*,acar.util.*"%>
<%@ include file="/acar/cookies.jsp" %>

<html>
<head><title>FMS</title>
<script language='javascript'>
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
<meta http-equiv="content-type" content="text/html; charset=euc-kr">
<link rel=stylesheet type="text/css" href="/include/table_t.css">
</head>
<body onload="javascript:document.form1.t_wd.focus();">
<%
	String auth_rw = request.getParameter("auth_rw")==null?"":request.getParameter("auth_rw");
	String br_id = request.getParameter("br_id")==null?"":request.getParameter("br_id");
	String user_id = request.getParameter("user_id")==null?"":request.getParameter("user_id");
	String s_kd = request.getParameter("s_kd")==null?"":request.getParameter("s_kd");
	String t_wd = request.getParameter("t_wd")==null?"":request.getParameter("t_wd");
	String asc = request.getParameter("asc")==null?"0":request.getParameter("asc");
	
	//height
	int sh_height = request.getParameter("sh_height")==null?0:Util.parseInt(request.getParameter("sh_height"));//상단길이
	
%>
<form name='form1' action='/acar/mng_client2/client_sc.jsp' target='c_foot' method='post'>
<input type='hidden' name='auth_rw' value='<%=auth_rw%>'>
<input type='hidden' name='br_id' value='<%=br_id%>'>
<input type='hidden' name='user_id' value='<%=user_id%>'>
<input type='hidden' name='sh_height' value='<%=sh_height%>'> 
<table border="0" cellspacing="0" cellpadding="0" width=100%>
    <tr>
    	<td colspan=10>
    	    <table width=100% border=0 cellpadding=0 cellspacing=0>
                <tr>
                    <td width=7><img src=/acar/images/center/menu_bar_1.gif width=7 height=33></td>
                    <td class=bar>&nbsp;&nbsp;&nbsp;<img src=/acar/images/center/menu_bar_dot.gif width=4 height=5 align=absmiddle>&nbsp;<span class=style1>예약시스템 > 고객관리 > <span class=style5>고객 관리</span></span></td>
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
			<table border="0" cellspacing="1" cellpadding="0" width=100%>
				<tr>
					<td>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;<img src=/acar/images/center/arrow_gshm.gif align=absmiddle>&nbsp;
						<select name='s_kd'>
							<option value='1' <%if(s_kd.equals("1")){%> selected <%}%>>상호</option>
							<option value='2' <%if(s_kd.equals("2")){%> selected <%}%>>계약자</option>
							<option value='3' <%if(s_kd.equals("3")){%> selected <%}%>>담당자</option>
							<option value='4' <%if(s_kd.equals("4")){%> selected <%}%>>전화번호</option>
							<option value='5' <%if(s_kd.equals("5")){%> selected <%}%>>휴대폰</option>
							<option value='6' <%if(s_kd.equals("6")){%> selected <%}%>>주소</option>
						</select>
						<input type='text' size='15' class='text' name='t_wd' value='<%=t_wd%>' onKeyDown='javascript:enter()' style='IME-MODE: active'>
						&nbsp;&nbsp;&nbsp;&nbsp;
						<img src=/acar/images/center/arrow_jr.gif align=absmiddle>&nbsp;<input type='radio' name='asc' value='0' <%if(asc.equals("0")){%>checked<%}%> onClick='javascript:search()'>오름차순
						<input type='radio' name='asc' value='1' <%if(asc.equals("1")){%>checked<%}%> onClick='javascript:search()'>내림차순
						&nbsp;&nbsp;&nbsp;&nbsp;
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
