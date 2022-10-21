<%@ page language="java" contentType="text/html;charset=euc-kr"%>
<%@ page import="java.io.*, java.util.*, acar.util.*, acar.user_mng.*"%>
<jsp:useBean id="user_bean" class="acar.user_mng.UsersBean" scope="page"/>
<%@ include file="/acar/cookies.jsp" %>

<html>
<head>
<title>FMS</title>
</head>
<body>
<%
	/* multipart/form-data 로 FileUpload객체 생성 */ 
	FileUpload file = new FileUpload("C:\\Inetpub\\wwwroot\\images\\charge\\", request.getInputStream());
	String filename = file.getFilename2() == null ? "" : file.getFilename2();
	
	String auth_rw = file.getParameter("auth_rw")==null?"":file.getParameter("auth_rw");
	String user_id = file.getParameter("user_id")==null?"":file.getParameter("user_id");
	String file_st = file.getParameter("file_st")==null?"":file.getParameter("file_st");
	int count = 0;
	
	UserMngDatabase umd = UserMngDatabase.getInstance();
	user_bean = umd.getUsersBean(user_id);
	
	if(file_st.equals("2")){
		user_bean.setFilename2(filename);
	}else{
		user_bean.setFilename(filename);
	}
	
	count = umd.updateUser(user_bean);
%>
<script language='javascript'>
<%	if(count == 0)	{	%>
		alert('처리되지 않았습니다');
<%	}else{	%>
		alert("처리되었습니다");
<%	}	%>
	parent.opener.location.href= "./info_u.jsp?user_id=<%=user_id%>&auth_rw=<%=auth_rw%>";	
	parent.window.close();
</script>
</body>
</html>
