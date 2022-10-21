<%@ page language="java" contentType="text/html;charset=euc-kr" %>
<%@ include file="/acar/cookies.jsp" %>

<html>
<head>
<meta http-equiv="content-type" content="text/html; charset=euc-kr">
<title>FMS</title>
<link rel="stylesheet" type="text/css" href="/include/table_t.css"></link><script language="JavaScript">
<!--
	function view_mapping(car_mng_id)
	{
		location='/acar/bank_mng/bank_mapping_c.jsp?auth_rw='+document.form1.auth_rw.value+'&lend_id='+document.form1.lend_id.value+'&car_mng_id='+car_mng_id;
	}
//-->
</script>
</head>
<%
	String lend_id = request.getParameter("lend_id")==null?"":request.getParameter("lend_id");
	String auth_rw = request.getParameter("auth_rw")==null?"":request.getParameter("auth_rw");
%>
<body>
<form name='form1' method='post'>
<input type='hidden' name='lend_id' value='<%=lend_id%>'>
<input type='hidden' name='auth_rw' value='<%=auth_rw%>'>
<table border=0 cellspacing=0 cellpadding=0 width=680>
	<tr>
    	<td ><font color="navy">재무관리 -> 은행대출관리 -> </font><font color="red">계약리스트</font></td>
    </tr>
    <tr>
        <td>
        	<iframe src="/acar/bank_mng/bank_con_c_in.jsp?lend_id=<%=lend_id%>" name="inner" width="680" height="320" cellpadding="0" cellspacing="0" border="0" frameborder="0" noresize scrolling=yes, marginwidth=0, marginheight=0 >
			</iframe>
		</td>
    </tr>
    <tr>
    	<td align='right'><a href='javascript:window.close()' onMouseOver="window.status=''; return true">닫기</a></td>
    </tr>
</table>
</form>
</body>
</html>