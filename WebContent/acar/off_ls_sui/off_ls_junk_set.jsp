<%@ page language="java" contentType="text/html;charset=euc-kr" %>
<jsp:useBean id="olsD" class="acar.offls_sui.Offls_suiDatabase" scope="page"/>
<%@ include file="/acar/cookies.jsp" %>
<%
	String auth_rw = request.getParameter("auth_rw")==null?"":request.getParameter("auth_rw");
	String[] sui = request.getParameterValues("pr");
	
	for(int i=0; i<sui.length; i++){
		sui[i] = sui[i].substring(0,6);
	}

	int result = olsD.setOffls_junk(sui);
%>
<html>
<head><title>FMS</title>
<link rel=stylesheet type="text/css" href="/include/table.css">
</head>
<body>
<script language="JavaScript">
<!--
<%	if(result >= 1){%>
	alert("��ϵǾ����ϴ�.");
	window.top.frames["d_content"].location = "/acar/off_ls_pre/off_ls_pre_frame.jsp?auth_rw=<%=auth_rw%>";
	//parent.parent.location.href = "/acar/off_ls_pre/off_ls_pre_frame.jsp?auth_rw=<%=auth_rw%>";
<%}else{%>
	alert("�����ͺ��̽��� ������ �߻��Ͽ����ϴ�.\n �����ڴԲ� �����ϼ��� !");
	//parent.parent.location.href = "/acar/off_ls_pre/off_ls_pre_frame.jsp?auth_rw=<%=auth_rw%>";
<%}%>
//-->
</script>
</body>
</html>
