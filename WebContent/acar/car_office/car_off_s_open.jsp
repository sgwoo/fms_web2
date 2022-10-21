<%@ page language="java" contentType="text/html; charset=euc-kr" %>
<%@ page import="java.util.*, acar.util.*, acar.car_office.*" %>
<%@ include file="/acar/cookies.jsp" %>

<%
	String car_comp_id = request.getParameter("car_comp_id")==null?"":request.getParameter("car_comp_id");
	String gubun = "car_off_nm";
	String gubun_nm = request.getParameter("car_off_nm")==null?"":request.getParameter("car_off_nm");
%>

<html>
<head>
<title>FMS</title>
<meta http-equiv="content-type" content="text/html; charset=euc-kr">
<%@ include file="/acar/getNaviCookies.jsp" %>
<link rel=stylesheet type="text/css" href="/include/table_t.css">
<script language='javascript'>
<!--
function SetCarOff(car_comp_id,car_off_id, car_off_nm,car_off_st,car_off_tel,car_off_fax,car_off_post,car_off_addr){
	var theForm = opener.document.form1;	
	theForm.car_comp_id.value = car_comp_id;
	theForm.car_off_id.value = car_off_id;
	theForm.car_off_nm.value = car_off_nm;
	if(car_off_st=="1")		theForm.car_off_st[0].checked = true;
	else					theForm.car_off_st[1].checked = true;
	theForm.car_off_tel.value = car_off_tel;
	theForm.car_off_fax.value = car_off_fax;
	theForm.car_off_post.value = car_off_post;
	theForm.car_off_addr.value = car_off_addr;
	theForm.emp_pos.focus();
		
	self.close();
	window.close();
}
	function search(){
		var fm = document.form1;
		fm.action='./car_off_s_open_in.jsp';
		fm.target='inner';
		fm.submit();
	}
	
	function enter(){
		var keyValue = event.keyCode;
		if (keyValue =='13') search();
	}	
//-->
</script>
</head>

<body onLoad="document.form1.gubun_nm.focus();">
<center>
<form name='form1' action='' method='post'>
<table border="0" cellspacing="0" cellpadding="0" width=100%>
    <tr>
    	<td colspan=2>
    	    <table width=100% border=0 cellpadding=0 cellspacing=0>
                <tr>
                    <td width=7><img src=/acar/images/center/menu_bar_1.gif width=7 height=33></td>
                    <td class=bar>&nbsp;&nbsp;&nbsp;<img src=/acar/images/center/menu_bar_dot.gif width=4 height=5 align=absmiddle>&nbsp;<span class=style1>영업관리 > 영업사원관리 > <span class=style5>영업소조회</span></span></td>
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
			<table border="0" cellspacing="0" cellpadding="0" width=100%>
				<tr>					
                    <td align='left'>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;<img src=/acar/images/center/arrow_yusm.gif align=absmiddle>&nbsp;
                    <input type='text' name='gubun_nm' size='20' class='text' value='<%= gubun_nm %>' onKeyDown='javascript:enter()' style='IME-MODE: active'>
                	<a href='javascript:search()' onMouseOver="window.status=''; return true"><img src=/acar/images/center/button_search.gif align=absmiddle border=0></a></td>					              	  
                    <td align='right'> <a href="./car_office_i_pop.jsp" target="CarOffList"><img src=/acar/images/center/button_reg_new.gif align=absmiddle border=0></a> 
                    </td>
				</tr>
			</table>
		</td>
		<td width='17'></td>
	</tr>
	<tr>
	    <td class=line2></td>
	</tr>
	<tr>
		<td class='line'> 
		    <table border="0" cellspacing="1" cellpadding="0" width=100%>
                <tr> 
                    <td class='title' width='8%'>연번</td>
                    <td class='title' width='19%'>소속사</td>
                    <td class='title' width='14%'>구분</td>
                    <td class='title' width='37%'>지점(대리점)명</td>
                    <td width='22%' class='title'>전화</td>
                </tr>
            </table>
        </td>
		<td width='17'></td>
	</tr>
	<tr>
		<td colspan='2'>
			<iframe src="./car_off_s_open_in.jsp?car_comp_id=<%=car_comp_id%>&gubun_nm=<%= gubun_nm %>" name="inner" width="100%" height="275" cellpadding="0" cellspacing="0" border="1" frameborder="0" noresize scrolling=yes, marginwidth=0, marginheight=0 ></iframe>
		</td>
	</tr>
</table>
</form>
</center>
</body>
</html>
