<%@ page language="java" contentType="text/html; charset=euc-kr" %>
<%@ page import="java.util.*, acar.util.*, acar.off_anc.*" %>
<%@ include file="/acar/cookies.jsp" %>
<script type="text/javascript" src="https://code.jquery.com/jquery-1.12.4.min.js"></script>
<%
	//�������� ��� ���� ������
	String  bbs_id = request.getParameter("bbs_id")==null?"":request.getParameter("bbs_id");	
	int     bbs_comment_seq		= request.getParameter("bbs_comment_seq")==null?0:Util.parseInt(request.getParameter("bbs_comment_seq"));
	
	int count = 0;
	
		
	OffAncDatabase oad = OffAncDatabase.getInstance();
	
	count = oad.deleteAncComment(bbs_id, bbs_comment_seq);  
%>

<html>
<head><title>FMS</title>
<link rel=stylesheet type="text/css" href="/include/table_t.css">
<script type="text/javascript">
$(document).ready(function(){
	var count = <%=count%>;	
	if(count==1){
		alert("�����Ǿ����ϴ�.");
		window.opener.document.location.reload();
		window.close();
	}else{
		alert("������ �����߻�!");
		window.close();
	}
});
</script>
</head>
<body>
</body>
</html>
