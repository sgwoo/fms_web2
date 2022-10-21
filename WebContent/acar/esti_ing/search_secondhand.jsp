<%@ page language="java" contentType="text/html;charset=euc-kr" %>
<%@ page import="java.util.*"%>
<%@ page import="acar.cont.*"%>
<%@ include file="/acar/cookies.jsp" %>

<html>
<head>
<title>FMS</title>
<meta http-equiv="content-type" content="text/html; charset=euc-kr">
<link rel=stylesheet type="text/css" href="../../include/table.css">
<script language='javascript'>
<!--
	function select_car(rent_mng_id, rent_l_cd, car_comp_id, car_mng_id, car_no, off_ls, car_nm, car_name){
		var fm = document.form1;
		if(off_ls != '0'){
			alert("매각 진행중인 차량입니다.\n\n오프리스에서 매각취소 하십시오.");
		}
		fm.target='s_no';
		fm.action='./set_secondhand.jsp?rent_mng_id='+rent_mng_id+'&rent_l_cd='+rent_l_cd+'&car_comp_id='+car_comp_id+'&car_mng_id='+car_mng_id+'&car_no='+car_no+'&car_nm='+car_nm+'&car_name='+car_name;
		fm.submit();
	}	
	function search(){
		var fm = document.form1;	
		fm.mode.value = 'AFTER';
		fm.target='inner';
		fm.action='./search_secondhand_in.jsp';				
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
<form name='form1' action='./search_secondhand_in.jsp' method='post'>
<input type='hidden' name='mode' value='PRE'>
<input type='hidden' name='car_st' value='<%=car_st%>'>
<input type='hidden' name='car_cd' value='<%=car_cd%>'>
<table border="0" cellspacing="0" cellpadding="0" width=470>
	<tr>
		<td align='left' colspan='2'><<기존차량 리스트>></td>
	</tr>
	<tr>
		<td colspan='2'>
			<select name='s_kd'>
				<option value='0' <%if(s_kd.equals("0")){%> selected <%}%>>전체</option>
				<option value='1' <%if(s_kd.equals("1") || s_kd.equals("")){%> selected <%}%>>차량번호</option>
				<option value='2' <%if(s_kd.equals("2")){%> selected <%}%>>차명</option>
			</select>
			<input type='text' name='t_wd' size='15' value='<%=t_wd%>' class='text' onKeyDown='javascript:enter()'>
			<a href='javascript:search()' onMouseOver="window.status=''; return true"><img src="/images/search.gif" width="50" height="18" aligh="bottom" border="0"></a>
		</td>
	</tr>
	<tr>
		<td class='line' width='450'>
			<table border="0" cellspacing="1" cellpadding="0" width=450>
				<tr>
					<td class='title' width='30'>연번</td>
					<td class='title' width='100'>계약번호</td>					
					<td class='title' width='100'>차량번호</td>
					<td class='title' width='220'>차명</td>
				</tr>
			</table>
		</td>
		<td width='20'>&nbsp;</td>
	</tr>
	<tr>
		<td colspan='2'>
			<iframe src="./search_secondhand_in.jsp?s_kd=<%=s_kd%>&t_wd=<%=t_wd%>&mode=<%=mode%>&car_st=<%=car_st%>&car_cd=<%=car_cd%>" name="inner" width="470" height="300" cellpadding="0" cellspacing="0" border="0" frameborder="0" noresize scrolling=yes, marginwidth=0, marginheight=0 >
			</iframe>
		</td>
	</tr>
</table>
</form>
<iframe src="about:blank" name="s_no" width="0" height="0" cellpadding="0" cellspacing="0" border="1" frameborder="0" noresize>
</body>
</html>

