<%@ page language="java" contentType="text/html;charset=euc-kr" %>
<%@ page import="java.util.*, acar.util.*, acar.forfeit_mng.*, acar.user_mng.*, acar.estimate_mng.*"%>
<jsp:useBean id="FineDocDb" scope="page" class="acar.forfeit_mng.FineDocDatabase"/>
<%@ include file="/acar/cookies.jsp" %>

<%

	String auth_rw 	= request.getParameter("auth_rw")==null?"":request.getParameter("auth_rw");
	String doc_id 	= request.getParameter("doc_id")==null?"":request.getParameter("doc_id");
	String ip_dt 	= request.getParameter("ip_dt")==null?"":request.getParameter("ip_dt");
	String cmd 		= request.getParameter("cmd")==null?"":request.getParameter("cmd");	
	int count = 0;
	String nm = "";
	
	if(cmd.equals("i")||cmd.equals("m")){//��� �� ����
		count = FineDocDb.updateIp_dt(doc_id, ip_dt);
	}
	
	//ctrl 
	if(cmd.equals("i")){//��������					
		if(!FineDocDb.updateCtrl(doc_id))	count += 1;			
	}
%>
<html>
<head>

<title>FMS</title>
<meta http-equiv="content-type" content="text/html; charset=euc-kr">
<link rel="stylesheet" type="text/css" href="/include/table.css"></link>
</head>
<body>
<script language="JavaScript">
<!--
	<%if(cmd.equals("i") && count==1){%>
		alert("���������� ��ϵǾ����ϴ�.");
		parent.location.reload();
		parent.window.close();
	<%}else if(cmd.equals("m") && count==1){%>
		alert("���������� �����Ǿ����ϴ�.");
		parent.location.reload();
		parent.window.close();
	<%}else{%>
		alert("Error !!!!!!!!!!!!!!!!!!!!");	
	<%}%>
	


//-->
</script>
</body>
</html>