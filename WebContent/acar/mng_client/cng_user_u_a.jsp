<%@ page language="java" contentType="text/html;charset=euc-kr" %>
<%@ page import="acar.client.*"%>
<jsp:useBean id="l_db" scope="page" class="acar.client.ClientDatabase"/>
<html>
<head><title>FMS</title>
<script language='javascript'>
<!--
-->
</script>
<link rel=stylesheet type="text/css" href="/index/table.css">
</head>
<body>
<%
	boolean flag = false;
	String c_id = request.getParameter("c_id")==null?"":request.getParameter("c_id");
	String page_mode = request.getParameter("page_mode")==null?"":request.getParameter("page_mode");
	if(page_mode.equals("0"))	//���
	{
		ClientUserBean c_user = new ClientUserBean();
		c_user.setUser_id(request.getParameter("user_id")==null?"":request.getParameter("user_id"));
		c_user.setUser_psd(request.getParameter("user_psd1")==null?"":request.getParameter("user_psd1"));
		c_user.setClient_id(c_id);
		flag = l_db.insertClientUser(c_user);
	}
	else if(page_mode.equals("1"))	//����
	{
		ClientUserBean c_user = l_db.getClientUser(c_id);
		c_user.setUser_id(request.getParameter("user_id")==null?"":request.getParameter("user_id"));
		c_user.setUser_psd(request.getParameter("user_psd1")==null?"":request.getParameter("user_psd1"));
		c_user.setClient_id(c_id);
		flag = l_db.updateClientUser(c_user);
	}
	else if(page_mode.equals("2"))	//����
	{
		flag = l_db.deleteClientUser(c_id);
	}
%>
<script language='javascript'>
<%	
	if(flag)
	{
		if(page_mode.equals("2"))	//����
		{
%>
			alert('ó���Ǿ����ϴ�');
			parent.refresh();
<%
		}
		else
		{
%>
			alert('ó���Ǿ����ϴ�');
			parent.opener.refresh();
			parent.window.close();
<%
		}
%>

<%
	}
	else
	{
%>
			alert('�����߻�');
<%
	}
%>

</script>
</body>
</html>
