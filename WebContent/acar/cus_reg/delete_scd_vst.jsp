<%@ page language="java" contentType="text/html;charset=euc-kr" %>
<%@ page import="java.util.*, acar.util.*, acar.cus_reg.*"%>
<%@ include file="/acar/cookies.jsp" %>
<%
	String client_id = request.getParameter("client_id")==null?"":request.getParameter("client_id");
	String seq = request.getParameter("seq")==null?"":request.getParameter("seq");

	/* ������ ���� */
	CusReg_Database cr_db = CusReg_Database.getInstance();
	int result = cr_db.deleteScdVst(client_id,seq);
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
		alert("�ش� �������� �������� �ʾҽ��ϴ�");
		location='about:blank';
		
<%	}else{		%>		
		alert("�ش� �������� �����Ǿ����ϴ�");
		parent.scd_vst.location.href="cus_reg_visit_in.jsp?client_id=<%=client_id%>";
<%	}			%>
</script>
</body>
</html>