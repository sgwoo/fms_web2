<%@ page language="java" contentType="text/html;charset=euc-kr"%>
<%@ page import="java.util.*, acar.util.*" %>
<%@ page import="acar.memo.*" %>
<jsp:useBean id="memo_db" scope="page" class="acar.memo.Memo_Database"/>
<html>
<head><title>FMS</title>
<meta http-equiv="Content-Type" content="text/html; charset=euc-kr">
</head>
<body>
<%
	String user_id = request.getParameter("user_id")==null?"":request.getParameter("user_id");
	String user_pos = request.getParameter("user_pos")==null?"":request.getParameter("user_pos");
	String memo_id = request.getParameter("memo_id")==null?"":request.getParameter("memo_id");
	
%>
<script language='javascript'>
<%
	if(!memo_db.rece_yn(memo_id,user_id))
	{
%>		alert('오류발생!');
		parent.location='about:blank';
<%
	}
	else
	{
%>		alert('수신확인 되었읍니다.');
		parent.location='memo_t_sc.jsp?user_id=<%=user_id%>&user_pos=<%=user_pos%>&memo_id=<%=memo_id%>';
<%
	}
%>
</script>
</body>
</html>
