<%@ page language="java" contentType="text/html;charset=euc-kr" %>
<%@ page import="java.io.*, java.util.*, acar.util.*, acar.accid.*"%>
<%@ include file="/acar/cookies.jsp" %>

<html>
<head>
<title>FMS</title>
</head>
<body>
<%
	/* multipart/form-data �� FileUpload��ü ���� */ 
	FileUpload file = new FileUpload("C:\\Inetpub\\wwwroot\\images\\accidImg\\", request.getInputStream());
	String filename = file.getFilename2() == null ? "" : file.getFilename2();
	
	String mode = file.getParameter("mode")==null?"i":file.getParameter("mode");
	int flag = 0;
	
	AccidDatabase ac_db = AccidDatabase.getInstance();
	
	PicAccidBean p_bean = new PicAccidBean();
	p_bean.setCar_mng_id(file.getParameter("c_id"));
	p_bean.setAccid_id(file.getParameter("accid_id"));
	p_bean.setFilename(filename);
	p_bean.setReg_id(file.getParameter("user_id"));
	
	flag = ac_db.insertPicAccid(p_bean);
%>
<script language='javascript'>
<%	if(flag == 0)	{	%>
		alert('ó������ �ʾҽ��ϴ�');
<%	}else{	%>
		alert("ó���Ǿ����ϴ�");		
		parent.opener.location.reload();
		parent.close();
<%	}	%>
</script>
</body>
</html>
