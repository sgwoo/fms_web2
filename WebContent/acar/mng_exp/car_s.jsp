<%@ page language="java" contentType="text/html;charset=euc-kr" %>
<%@ include file="/acar/cookies.jsp" %>
<html>
<head><title>FMS</title>
<script language='javascript'>
<!--
	function select_car(car_mng_id, car_no, car_nm, firm_nm, client_nm)
	{
		var o_fm = opener.form1;
		o_fm.car_mng_id.value = car_mng_id;
		o_fm.car_no.value = car_no;
		o_fm.car_nm.value = car_nm;
		o_fm.firm_nm.value = firm_nm;
		o_fm.client_nm.value = client_nm;
		window.close();
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
<link rel=stylesheet type="text/css" href="/include/table_t.css">
<body leftmargin="15">
<form name='form1' action='/acar/mng_exp/car_s.jsp' method='post'>
<%
	String s_kd =  request.getParameter("s_kd")==null?"1":request.getParameter("s_kd");
	String t_wd = request.getParameter("t_wd")==null?"":request.getParameter("t_wd");
%>
<table border="0" cellspacing="0" cellpadding="0" width=100%>
    <tr>
	    <td style='height:5'></td>
	</tr>
	<tr>
		<td align='left'><img src=../images/center/icon_arrow.gif align=absmiddle> <span class=style2>차량검색</span></td>
	</tr>  
	<tr>
		<select name='s_kd'>
			<option value='0' <%if(s_kd.equals("0")){%>selected<%}%>>전체 </option>
			<option value='1' <%if(s_kd.equals("1")){%>selected<%}%>>차량번호 </option>
			<option value='2' <%if(s_kd.equals("2")){%>selected<%}%>>차종     </option>
		</select>
		<input type='text' name='t_wd' size='18' class='text' value='<%=t_wd%>' onKeyDown='javascript:enter()'>
		<a href='javascript:search()'><img src=/acar/images/center/button_search.gif border=0 align=absmiddle></a>
	</tr>

	<tr>
		<td>
			<table border="0" cellspacing="0" cellpadding="0" width=100%>
			    <tr>
	                <td class=line2></td>
	            </tr>
				<tr>
					<td class='line'>
						<table border="0" cellspacing="1" cellpadding="0" width=100%>
							<tr>
								<td class='title' width=20%>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;차량번호&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;</td>
								<td class='title' width=25%>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;차종&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;</td>
								<td class='title' width=40%>상호</td>
								<td class='title' width=15%>&nbsp;&nbsp;&nbsp;&nbsp;계약자&nbsp;&nbsp;&nbsp;&nbsp;</td>
							</tr>
						</table>
					</td>
					<td width='16'></td>
				</tr>
				<tr>
					<td colspan='2'>
						<iframe src="/acar/mng_exp/car_s_in.jsp?s_kd=<%=s_kd%>&t_wd=<%=t_wd%>" name="inner" width="100%" height="300" cellpadding="0" cellspacing="0" border="0" frameborder="0" noresize scrolling=yes, marginwidth=0, marginheight=0 >
						</iframe>
					</td>
				</tr>
			</table>
		<td>
	</tr>	
</table>
</form>
</body>
</html>

