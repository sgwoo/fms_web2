<%@ page language="java" contentType="text/html;charset=euc-kr"%>
<%@ page import="acar.day_sche.*"%>

<jsp:useBean id="dsch_db" scope="page" class="acar.day_sche.DScheDatabase"/>
<html>
<head><title>FMS</title></head>
<body>
<%
	String[] seq = request.getParameterValues("pr");
	boolean flag = dsch_db.delete(seq);
%>
<script language='javascript'>
<%
	if(!flag)
	{
%>		alert('�����߻�!');
		location='about:blank';
<%
	}
	else
	{
%>		alert('�����Ǿ����ϴ�');
		parent.parent.c_head.search();
		parent.close();
<%
	}
%>
</script>
</body>
</html>
