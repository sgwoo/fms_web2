<%@ page language="java" contentType="text/html;charset=euc-kr"%>
<%@ page import="acar.util.*"%>
<%@ include file="/acar/cookies.jsp" %>

<html>
<head><title>FMS</title>
<script language='JavaScript' src='/include/common.js'></script>
<script language='javascript'>
<!--
-->
</script>
<meta http-equiv="content-type" content="text/html; charset=euc-kr">
<link rel=stylesheet type="text/css" href="/include/table_t.css">
</head>
<body>
<%
	String dt 	= request.getParameter("dt")==null?"":request.getParameter("dt");
	String msg 	= request.getParameter("msg")==null?"":request.getParameter("msg");
%>
<table border="0" cellspacing="0" cellpadding="0" width=200>
	<tr>
		<td align='left'><<입금예정일변경내역>></td>
	</tr>
	<tr>
		<td class='line'>
			 <table border="0" cellspacing="1" cellpadding="0" width=200>
			 	<tr><td class=line2></td></tr>
				<tr>
					<td class='title' width='80'>변경일</td>
					<td width='120'>&nbsp;<%=dt%></td>
				</tr>
				<tr>
					<td height='80' class='title' rowspan='3'>변경사유</td>
					<td height='120' rowspan='5'>&nbsp;<%=Util.htmlBR(msg)%></td>
				</tr>
			</table>
		</td>
	</tr>
	<tr>
		<td align='right'><a href="javascript:window.close()"><img src="/acar/images/center/button_close.gif" align="absmiddle" border="0"></a></td>
	</tr>
</table>
</body>
</html>
