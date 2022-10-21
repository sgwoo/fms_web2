<%@ page language="java" contentType="text/html; charset=euc-kr" %>
<%@ page import="java.util.*, acar.util.*, acar.car_office.*" %>
<%@ include file="/agent/cookies.jsp" %>

<%
	String car_comp_id = request.getParameter("car_comp_id")==null?"":request.getParameter("car_comp_id");
	String gubun = "car_off_nm";
	String gubun_nm = request.getParameter("car_off_nm")==null?"":request.getParameter("car_off_nm");
	String gubun_st = request.getParameter("gubun_st")==null?"":request.getParameter("gubun_st");
%>

<html>
<head>
<title>FMS</title>
<meta http-equiv="content-type" content="text/html; charset=euc-kr">
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
	if(document.form1.gubun_st.value == 'BUS' || document.form1.gubun_st.value == 'DLV'){
		theForm.t_zip[1].value = car_off_post;
		theForm.t_addr[1].value = car_off_addr;
	}else{
		theForm.car_off_post.value = car_off_post;
		theForm.car_off_addr.value = car_off_addr;
	}
	theForm.emp_pos.focus();
		
	self.close();
	window.close();
}
	function search(){
		var fm = document.form1;
		fm.action='search_car_off_in.jsp';
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
<input type="hidden" name="gubun_st" value="<%=gubun_st%>">
<table border="0" cellspacing="0" cellpadding="0" width=100%>
    <tr>
    	<td>
    	    <table width=100% border=0 cellpadding=0 cellspacing=0>
                <tr>
                    <td width=7><img src=/acar/images/center/menu_bar_1.gif width=7 height=33></td>
                    <td class=bar>&nbsp;&nbsp;&nbsp;<img src=/acar/images/center/menu_bar_dot.gif width=4 height=5 align=absmiddle>&nbsp;<span class=style1>영업지원 > 계약관리 > <span class=style5>자동차영업소조회</span></span></td>
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
                    <td align='left'>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;<img src=/acar/images/center/arrow_yus.gif align=absmiddle>&nbsp;
                    <input type='text' name='gubun_nm' size='20' class='text' value='<%= gubun_nm %>' onKeyDown='javascript:enter()' style='IME-MODE: active'>
                    	<a href='javascript:search()' onMouseOver="window.status=''; return true"><img src=/acar/images/center/button_search.gif align=absmiddle border=0></a></td>					
                  	  
                    <td align='right'> <a href="./reg_office_i.jsp?gubun_st=<%= gubun_st %>&gubun_nm=<%= gubun_nm %>"><img src=/acar/images/center/button_reg_new.gif align=absmiddle border=0></a> 
                    </td>
				</tr>
			</table>
		</td>
		<td width='17'></td>
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
                    <td class='title' width='7%'>연번</td>
                    <td class='title' width='20%'>소속사</td>
                    <td class='title' width='16%'>구분</td>
                    <td class='title' width='35%'>지점(대리점)명</td>
                    <td width='22%' class='title'>전화</td>
                </tr>
            </table>
        </td>
		<td width='17'></td>
	</tr>
	<tr>
		<td colspan='2'>
			<iframe src="search_car_off_in.jsp?car_comp_id=<%=car_comp_id%>&gubun_nm=<%= gubun_nm %>&gubun_st=<%= gubun_st %>" name="inner" width="100%" height="300" cellpadding="0" cellspacing="0" border="1" frameborder="0" noresize scrolling=yes, marginwidth=0, marginheight=0 ></iframe>
		</td>
	</tr>
</table>
</form>
</center>
</body>
</html>
