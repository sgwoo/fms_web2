<%@ page language="java" contentType="text/html;charset=euc-kr" %>
<%@ page import="java.util.*, acar.util.*,  acar.cus_reg.*, acar.res_search.*"%>
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
	
	String m_id = request.getParameter("m_id")==null?"":request.getParameter("m_id");//��������ȣ
	String l_cd = request.getParameter("l_cd")==null?"":request.getParameter("l_cd");//����ȣ
	String c_id = request.getParameter("c_id")==null?"":request.getParameter("c_id");//�ڵ���������ȣ
	String accid_id = request.getParameter("accid_id")==null?"":request.getParameter("accid_id");//��������ȣ
	String serv_id = request.getParameter("serv_id")==null?"":request.getParameter("serv_id");
	
	String call_t_nm = request.getParameter("call_t_nm")==null?"":request.getParameter("call_t_nm");
	String call_t_tel = request.getParameter("call_t_tel")==null?"":request.getParameter("call_t_tel");
	
	CusReg_Database cr_db = CusReg_Database.getInstance();
	
	int count = 1;
	
	count = cr_db.updateServCallInfo(c_id, serv_id, call_t_nm, call_t_tel);
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
