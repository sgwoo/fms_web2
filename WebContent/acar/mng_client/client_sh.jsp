<%@ page language="java" contentType="text/html;charset=euc-kr" %>
<%@ include file="/acar/cookies.jsp" %>

<html>
<head><title>FMS</title>
<script language='javascript'>
<!--
	function search(){
		document.form1.submit();
	}
	
	function enter(){
		var keyValue = event.keyCode;
		if (keyValue =='13') search();
	}
-->
</script>
<link rel=stylesheet type="text/css" href="/include/table.css">
</head>
<body onload="javascript:document.form1.t_wd.focus();">
<%
	String auth_rw = request.getParameter("auth_rw")==null?"":request.getParameter("auth_rw");
	String br_id = request.getParameter("br_id")==null?"":request.getParameter("br_id");
	String user_id = request.getParameter("user_id")==null?"":request.getParameter("user_id");
	String s_kd = request.getParameter("s_kd")==null?"1":request.getParameter("s_kd");
	String t_wd = request.getParameter("t_wd")==null?"":request.getParameter("t_wd");
	String asc = request.getParameter("asc")==null?"0":request.getParameter("asc");
%>
<form name='form1' action='/acar/mng_client/client_sc.jsp' target='c_foot' method="POST">
<input type='hidden' name='auth_rw' value='<%=auth_rw%>'>
<input type='hidden' name='br_id' value='<%=br_id%>'>
<input type='hidden' name='user_id' value='<%=user_id%>'>
<input type='hidden' name='asc' value='<%=asc%>'>

<table border="0" cellspacing="0" cellpadding="0" width=98%>
	<tr>
		<td>
			<font color="navy">MASTER  -> </font><font color="red">고객 관리 </font>
		</td>
	</tr>
	<tr>
		<td>
			<table border="0" cellspacing="1" cellpadding="0" width=98%>
				<tr>
					<td>검색:
						<select name='s_kd'>
							<option value='0' <%if(s_kd.equals("0"))%> selected<%%>>전체</option>
							<option value='1' <%if(s_kd.equals("1"))%> selected<%%>> 상호</option>
							<option value='2' <%if(s_kd.equals("2"))%> selected<%%>> 계약자</option>
							<option value='3' <%if(s_kd.equals("3"))%> selected<%%>> 전화번호</option>
							<option value='4' <%if(s_kd.equals("4"))%> selected<%%>> 휴대폰</option>
							<option value='5' <%if(s_kd.equals("5"))%> selected<%%>> 주소</option>
						</select>
						<input type='text' size='15' class='text' name='t_wd' onKeyDown='javascript:enter()' value='<%=t_wd%>'>
						<a href='javascript:search()' onMouseOver="window.status=''; return true"><img src="/images/search.gif" width="50" height="18" border="0"></a>
					</td>
				</tr>
			</table>
		</td>
	</tr>
</table>
</form>
</body>
</html>
