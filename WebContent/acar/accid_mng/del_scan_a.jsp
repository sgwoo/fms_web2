<%@ page language="java" contentType="text/html;charset=euc-kr" %>
<%@ page import="java.io.*, java.util.*, acar.util.*, acar.car_service.*"%>
<%@ include file="/acar/cookies.jsp" %>

<%
	//��ĵ���� ���/���� ó�� ������
	
	boolean flag1 = true;
	
	String auth_rw 		= request.getParameter("auth_rw")==null?"":request.getParameter("auth_rw");
	String user_id 		= request.getParameter("user_id")==null?"":request.getParameter("user_id");
	String br_id 		= request.getParameter("br_id")==null?"":request.getParameter("br_id");
	String c_id	 		= request.getParameter("c_id")==null?"":request.getParameter("c_id");
	String serv_id	 	= request.getParameter("serv_id")==null?"":request.getParameter("serv_id");
	
	
	AddCarServDatabase a_csd = AddCarServDatabase.getInstance();
	
	flag1 = a_csd.deleteScanFile(c_id, serv_id);
	
	out.println("������� ��ĵ���� ����<br>");
%>
<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=euc-kr">
<title></title>
</head>
<form name='form1' method='post'>
  <input type="hidden" name="auth_rw" 			value="<%=auth_rw%>">
  <input type="hidden" name="user_id" 			value="<%=user_id%>">
  <input type="hidden" name="br_id" 			value="<%=br_id%>">    
</form>
<script language='javascript'>
<%	if(flag1){	%>		
		alert('�ش� ������ �����Ǿ����ϴ�.');
<%	}else{	%>
		alert('�����ͺ��̽� �����Դϴ�.\n\n��ϵ��� �ʾҽ��ϴ�');		
<%	}	%>

	parent.location.reload();

</script>
<body>
</body>
</html>