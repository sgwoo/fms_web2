<%@ page language="java" contentType="text/html;charset=euc-kr"%>
<%@ page import="java.util.*, acar.util.*, acar.accid.*"%>
<%@ include file="/acar/cookies.jsp"%>
<%
	
	String m_id = request.getParameter("m_id")==null?"":request.getParameter("m_id");//��������ȣ
	String l_cd = request.getParameter("l_cd")==null?"":request.getParameter("l_cd");//����ȣ
	String c_id = request.getParameter("c_id")==null?"":request.getParameter("c_id");//�ڵ���������ȣ
	String accid_id = request.getParameter("accid_id")==null?"":request.getParameter("accid_id");//��������ȣ
	String serv_id = request.getParameter("serv_id")==null?"":request.getParameter("serv_id");
	String mode = request.getParameter("mode")==null?"":request.getParameter("mode");		
	String rent_l_cd = request.getParameter("rent_l_cd")==null?"":request.getParameter("rent_l_cd");		//target
	String rent_mng_id = request.getParameter("rent_mng_id")==null?"":request.getParameter("rent_mng_id");			
	
	int flag = 0;
	
	AccidDatabase as_db = AccidDatabase.getInstance();
	//accident
	flag = as_db.updateAccidentRent(c_id, accid_id, rent_mng_id, rent_l_cd);
	
	//service	
	flag = as_db.updateServicetRent(c_id, accid_id, rent_mng_id, rent_l_cd);	
	
%>
<html>
<head><title>FMS</title>
<link rel=stylesheet type="text/css" href="/include/table.css">
</head>
<body>
<script language='javascript'>
<%	if(flag == 0)	{	%>
		alert('ó������ �ʾҽ��ϴ�');
<%	}else{	%>
		alert("ó���Ǿ����ϴ�");		
	<!--//	parent.close();  -->
<%	}	%>
</script>
</body>
</html>