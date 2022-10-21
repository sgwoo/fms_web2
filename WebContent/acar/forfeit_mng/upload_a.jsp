<%@ page language="java" contentType="text/html;charset=euc-kr" %>
<%@ page import="java.io.*, java.util.*, acar.util.*"%>
<jsp:useBean id="a_db" scope="page" class="acar.cont.AddContDatabase"/>
<%@ include file="/acar/cookies.jsp" %>

<html>
<head>
<title>FMS</title>
</head>
<body>
<%
	/* multipart/form-data 로 FileUpload객체 생성 */ 
	FileUpload file = new FileUpload("C:\\Inetpub\\wwwroot\\data\\", request.getInputStream());
	String filename = file.getFilename() == null ? "" : file.getFilename();//견적서스캔-pdf파일
	
	String m_id = file.getParameter("m_id")==null?"":file.getParameter("m_id");
	String l_cd = file.getParameter("l_cd")==null?"":file.getParameter("l_cd");
	String c_id = file.getParameter("c_id")==null?"":file.getParameter("c_id");
	String seq_no = file.getParameter("seq_no")==null?"1":file.getParameter("seq_no");
	String mode = file.getParameter("mode")==null?"":file.getParameter("mode");
	int flag = 0;
	
	flag = a_db.scanUpLoad(m_id, l_cd, filename);
%>
<script language='javascript'>
<%	if(flag == 0)	{	%>
		alert('처리되지 않았습니다');
<%	}else{	%>
		alert("처리되었습니다");		
		parent.opener.location.reload();
		parent.close();
<%	}	%>
</script>
</body>
</html>
