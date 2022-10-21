<%@ page language="java" contentType="text/html;charset=euc-kr"%>
<%@ page import="acar.day_sche.*"%>

<jsp:useBean id="dsch_db" scope="page" class="acar.day_sche.DScheDatabase"/>
<html>
<head><title>FMS</title></head>
<body>
<%
	String seq = request.getParameter("s_seq");
	boolean flag = dsch_db.del(seq);
%>
<script language='javascript'>
<%
	if(!flag)
	{
%>		alert('오류발생!');
		location='about:blank';
<%
	}
	else
	{
%>		alert('삭제되었습니다');
		parent.opener.parent.c_head.search();
		parent.close();
<%
	}
%>
</script>
</body>
</html>
