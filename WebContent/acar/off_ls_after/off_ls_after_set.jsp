<%@ page language="java" contentType="text/html;charset=euc-kr" %>
<jsp:useBean id="olfD" class="acar.offls_after.Offls_afterDatabase" scope="page"/>
<%@ include file="/acar/cookies.jsp" %>
<%
	String auth_rw = request.getParameter("auth_rw")==null?"":request.getParameter("auth_rw");
	String[] after = request.getParameterValues("pr");
	
	for(int i=0; i<after.length; i++){
		after[i] = after[i].substring(0,6);
	}

	int result = olfD.setOffls_after(after);
%>
<html>
<head><title>FMS</title>
<link rel=stylesheet type="text/css" href="/include/table.css">
</head>
<body>
<script language="JavaScript">
<!--
<%	if(result >= 1){%>
	alert("��ϵǾ����ϴ�.\n�ڵ��� ó�� ���İ��� ȭ�鿡�� Ȯ�� �Ͻñ� �ٶ��ϴ�.");
	window.top.frames["d_content"].location = parent.parent.parent.location.href = "/acar/off_ls_after/off_ls_after_frame.jsp?auth_rw=<%=auth_rw%>";
	//parent.parent.parent.location.href = "/acar/off_ls_after/off_ls_after_frame.jsp?auth_rw=<%=auth_rw%>";
<%}else{%>
	alert("�����ͺ��̽��� ������ �߻��Ͽ����ϴ�.\n �����ڴԲ� �����ϼ��� !");
	window.top.frames["d_content"].location = "/acar/off_ls_after/off_ls_after_frame.jsp?auth_rw=<%=auth_rw%>";
	//parent.location.href = "/acar/off_ls_after/off_ls_after_frame.jsp?auth_rw=<%=auth_rw%>";
<%}%>
//-->
</script>
</body>
</html>
