<%@ page language="java" contentType="text/html;charset=euc-kr" %>
<%@ page import="java.util.*, acar.util.*, acar.cus_reg.*"%>
<%@ include file="/acar/cookies.jsp" %>
<%
	String client_id = request.getParameter("client_id")==null?"":request.getParameter("client_id");

	

	/* ������ �߰� */
	CusReg_Database cr_db = CusReg_Database.getInstance();
	int result = cr_db.extendScdVst(client_id);
%>

<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN">
<html>
<head>
<title>FMS</title>
<meta http-equiv="Content-Type" content="text/html; charset=euc-kr">
</head>

<body>
<script language='javascript'>
<%	if(result <= 0){%>
		alert("�������� �߰����� �ʾҽ��ϴ�");
		location='about:blank';
		
<%	}else{		%>		
		alert("�������� �߰��Ǿ����ϴ�");
		parent.scd_vst.location.href="cus_reg_visit_in.jsp?client_id=<%=client_id%>";
<%	}			%>
</script>
</body>
</html>