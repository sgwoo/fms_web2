<%@ page language="java" contentType="text/html;charset=euc-kr" %>
<%@ page import="java.util.*"%>
<%@ page import="acar.cont.*"%>
<%@ include file="/acar/cookies.jsp" %>

<html>
<head>
<title>FMS</title>
<meta http-equiv="content-type" content="text/html; charset=euc-kr">
<link rel=stylesheet type="text/css" href="/include/table_t.css">
<script language='javascript'>
<!--
	function select_car(emp_id, car_off_nm, emp_nm, emp_tel, emp_fax){
		var fm = opener.form1;
		fm.emp_id.value		= emp_id;
		fm.car_off_nm.value	= car_off_nm;
		fm.emp_nm.value		= emp_nm;
		fm.emp_tel.value	= emp_tel;
		fm.emp_fax.value	= emp_fax;
		window.close();		
	}	
	
	function search(){
		var fm = document.form1;	
		fm.mode.value = 'AFTER';
		fm.target='inner';
		fm.action='./search_emp_in.jsp';				
		fm.submit();
	}	
	function enter(){
		var keyValue = event.keyCode;
		if (keyValue =='13') search();
	}		
//-->
</script>
</head>

<body leftmargin="15" javascript="document.form1.t_wd.focus();">
<%
	String car_st =  request.getParameter("car_st")==null?"":request.getParameter("car_st");
	String car_cd =  request.getParameter("car_cd")==null?"":request.getParameter("car_cd");
	String s_kd =  request.getParameter("s_kd")==null?"":request.getParameter("s_kd");
	String t_wd = request.getParameter("t_wd")==null?"":request.getParameter("t_wd");
	String mode = request.getParameter("mode")==null?"":request.getParameter("mode");
	if(t_wd.equals("")) car_cd="";
%>
<form name='form1' action='./search_emp_in.jsp' method='post'>
<input type='hidden' name='mode' value='PRE'>
<input type='hidden' name='car_st' value='<%=car_st%>'>
<input type='hidden' name='car_cd' value='<%=car_cd%>'>
<table border="0" cellspacing="0" cellpadding="0" width=100%>
    <tr> 
        <td colspan=2>
            <table width=100% border=0 cellpadding=0 cellspacing=0>
                <tr>
                    <td width=7><img src=../images/center/menu_bar_1.gif width=7 height=33></td>
                    <td class=bar>&nbsp;&nbsp;&nbsp;<img src=../images/center/menu_bar_dot.gif width=4 height=5 align=absmiddle>&nbsp;<span class=style1><span class=style5>영업사원조회</span></span></td>
                    <td width=7><img src=../images/center/menu_bar_2.gif width=7 height=33></td>
                </tr>
            </table>            
        </td>
    </tr>	
    <tr> 
        <td class=h></td>
    </tr>
	<tr>
		<td colspan='2'>
			&nbsp;&nbsp;<select name='s_kd'>
				<option value='0' <%if(s_kd.equals("0")){%> selected <%}%>>전체</option>
				<option value='1' <%if(s_kd.equals("1") || s_kd.equals("")){%> selected <%}%>>영업사원명</option>
				<option value='2' <%if(s_kd.equals("2")){%> selected <%}%>>근무처</option>
			</select>
			<input type='text' name='t_wd' size='15' value='<%=t_wd%>' class='text' onKeyDown='javascript:enter()' style='IME-MODE: active'>
			<a href='javascript:search()' onMouseOver="window.status=''; return true"><img src=/acar/images/center/button_search.gif align=absmiddle border=0></a>
		</td>
	</tr>
	<tr> 
        <td class=h></td>
    </tr>
	<tr>
	    <td class=line2></td>
	</tr>
	<tr>
		<td class='line'>
			<table border="0" cellspacing="1" cellpadding="0" width=100%>
				<tr>
					<td class='title' width='10%'>&nbsp;연번&nbsp;</td>
					<td class='title' width='20%'>&nbsp;&nbsp;&nbsp;&nbsp;소속사&nbsp;&nbsp;&nbsp;&nbsp;</td>					
					<td class='title' width='50%'>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;근무처&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;</td>
					<td class='title' width='20%'>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;성명&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;</td>
				</tr>
			</table>
		</td>
		<td width='17'>&nbsp;</td>
	</tr>
	<tr>
		<td colspan='2'>
			<iframe src="./search_emp_in.jsp?s_kd=<%=s_kd%>&t_wd=<%=t_wd%>&mode=<%=mode%>&car_st=<%=car_st%>&car_cd=<%=car_cd%>" name="inner" width="100%" height="250" cellpadding="0" cellspacing="0" border="0" frameborder="0" noresize scrolling=yes, marginwidth=0, marginheight=0 >
			</iframe>
		</td>
	</tr>
</table>
</form>
<iframe src="about:blank" name="s_no" width="0" height="0" cellpadding="0" cellspacing="0" border="1" frameborder="0" noresize>
</body>
</html>

