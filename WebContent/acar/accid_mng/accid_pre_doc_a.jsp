<%@ page language="java" contentType="text/html;charset=euc-kr" %>
<%@ page import="java.util.*, acar.util.*, acar.accid.*"%>
<%@ include file="/acar/cookies.jsp" %>

<html>
<head>
<title>FMS</title>
<link rel=stylesheet type="text/css" href="/include/table_t.css">
<script language='JavaScript' src='../../include/common.js'></script>
</head>
<body leftmargin="15">
<%
	String auth_rw = request.getParameter("auth_rw")==null?"":request.getParameter("auth_rw");
	String user_id = request.getParameter("user_id")==null?"":request.getParameter("user_id");
	String br_id = request.getParameter("br_id")==null?"":request.getParameter("br_id");
	
	String c_id = request.getParameter("c_id")==null?"":request.getParameter("c_id");//�ڵ���������ȣ
	String accid_id = request.getParameter("accid_id")==null?"":request.getParameter("accid_id");//��������ȣ
	
	
	String our_fault_per = request.getParameter("our_fault_per")==null?"":request.getParameter("our_fault_per");
	String p_ip_dt = request.getParameter("p_ip_dt")==null?"":request.getParameter("p_ip_dt");
	String p_ip_amt 	=  request.getParameter("p_ip_amt")==null?"":request.getParameter("p_ip_amt");  //�Աݾ�
	String p_desc = request.getParameter("p_desc")==null?"":request.getParameter("p_desc");
	
	String p_doc_desc = "���������� ����Ȯ�� ����: ��� ->" + our_fault_per + " %" + " �Ա���: " + p_ip_dt + "  �Աݾ�: " + p_ip_amt + " Ư�̻���: " + p_desc; 
	
	
	AccidDatabase as_db = AccidDatabase.getInstance();
	
	int count = 1;
	
	count = as_db.updatePredocDesc(c_id, accid_id,p_doc_desc, p_ip_dt, AddUtil.parseDigit(p_ip_amt) );
%>
<script language='javascript'>
<%	if(count == 1){%>
		alert('���������� ó���Ǿ����ϴ�');
		parent.window.close();
		parent.opener.location.reload();
<%	}else{ //����%>
		alert('ó������ �ʾҽ��ϴ�\n\n�����߻�!');
<%	}%>
</script>
</body>
</html>
