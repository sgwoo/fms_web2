<%@ page language="java" contentType="text/html;charset=euc-kr"%>
<%@ page import="acar.day_sche.*"%>
<%@ page import="acar.util.*"%>

<jsp:useBean id="dsch_db" scope="page" class="acar.day_sche.DScheDatabase"/>
<html>
<head><title>FMS</title></head>
<body>
<%
	LoginBean login = LoginBean.getInstance();
	String user_id = login.getCookieValue(request, "acar_id");
	String[] seq = request.getParameterValues("pr"); 
	//System.out.println(seq.toString());
	boolean flag = dsch_db.update(user_id, seq);
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
%>		alert('처리되었습니다');
		parent.parent.c_head.search();
		parent.close();
<%
	}
%>
</script>
</body>
</html>
