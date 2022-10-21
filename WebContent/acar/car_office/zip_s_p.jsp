<%@ page language="java" import="java.util.*, acar.common.*" contentType="text/html;charset=euc-kr" %>
<%@ include file="/acar/cookies.jsp" %>

<html>
<head><title>FMS</title>
<script language='javascript'>
<!--
	function save()
	{
		document.form1.mode.value = 'AFTER';
		document.form1.submit();
	}
	
	function set_zip(zip_str, addr_str)
	{
		var fm = document.form1;
		var idx = fm.idx.value
		
		opener.CarOffEmpForm.emp_post.value = zip_str;
		opener.CarOffEmpForm.emp_addr.value = addr_str;
		opener.CarOffEmpForm.emp_addr.focus();
		
		window.close();
	}
	function enter() 
	{
		var keyValue = event.keyCode;
		if (keyValue =='13') save();
	}
-->
</script>
<meta http-equiv="Content-Type" content="text/html; charset=euc-kr">
<link rel=stylesheet type="text/css" href="/include/table_t.css">
</head>
<body onLoad="javascript:self.focus(); document.form1.swd.focus();">
<p>
<%
	CommonDataBase c_db = CommonDataBase.getInstance();

	String mode = request.getParameter("mode")==null?"":request.getParameter("mode");
	String swd = request.getParameter("swd")==null?"":request.getParameter("swd");
	String idx = request.getParameter("idx")==null?"":request.getParameter("idx");
%>
<form name='form1' action='./zip_s_p.jsp' method='post'>
<input type='hidden' name='mode' value=''>
<input type='hidden' name='idx' value='<%=idx%>'>
<table border="0" cellspacing="0" cellpadding="0" width=100%>
	<tr>
		<td align='left'><img src=/acar/images/center/icon_arrow.gif align=absmiddle> <span class=style2>우편번호검색</span></td>
	</tr>
	<tr>
	    <td class=line2></td>
	</tr>
	<tr>
		<td class='line'>
			<table border="0" cellspacing="1" cellpadding="0" width=100%>
				<tr>
					<td class='title' width=20%>동이름</td>
					<td width=80%>&nbsp;<input type='text' name='swd' size='13' class='text' value='<%=swd%>' onKeyDown='javascript:enter()' style="IME-MODE: active"> (예:공덕1)
					<a href="javascript:save()" onMouseOver="window.status=''; return true"><img src=/acar/images/center/button_in_search1.gif border=0 align=absmiddle></a></td>
				</tr>
			</table>
		</td>
	</tr>
	<tr>
		<td></td>
	</tr>
<%
	if(mode.equals("AFTER"))
	{
		Vector rt = c_db.getZip(swd);	
		int rtSize = rt.size();
%>
<%
		if(rtSize > 0)
		{
%>
	<tr>
	    <td class=line2></td>
	</tr>
	<tr>
		<td class='line'>
			<table border="0" cellspacing="1" cellpadding="0" width=100%>
				<tr>
					<td class='title' width=20%> 우편번호 </td>
					<td class='title' width=80%> 주소 </td>
				</tr>
<%
			for(int i = 0 ; i < rtSize ; i++)
			{
				Hashtable aRow = (Hashtable)rt.elementAt(i);
%>
				<tr>
					<td align='center'>
						<a href="javascript:set_zip('<%=aRow.get("ZIP_CD")%>', '<%=aRow.get("SIDO")%> <%=aRow.get("GUGUN")%> <%=aRow.get("DONG")%> ')"><%=aRow.get("ZIP_CD")%>	</a></td>
					<td>&nbsp;<%=aRow.get("SIDO")%> <%=aRow.get("GUGUN")%> <%=aRow.get("DONG")%>  <%=aRow.get("BUNJI")%> </td>
				</tr>
<%
			}
		}
		else
		{
%>
				<tr>
					<td colspan='2'> 검색된 결과가 없습니다 </td>
				</tr>
<%
		}
	}
%>
			</table>
		</td>
	</tr>
</table>
		

</body>
</html>