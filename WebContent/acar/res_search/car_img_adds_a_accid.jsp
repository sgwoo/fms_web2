<%@ page language="java" contentType="text/html;charset=euc-kr" %>
<%@ page import="java.io.*, java.util.*, acar.util.*, acar.accid.*"%>
<%@ include file="/acar/cookies.jsp" %>

<html>
<head>
<title>FMS</title>
</head>
<body>
<%
	/* multipart/form-data 로 FileUpload객체 생성 */ 
	ImgUpload file = new ImgUpload("C:\\Inetpub\\wwwroot\\images\\accidImg\\", request.getInputStream());
//	ImgUpload file = new ImgUpload("C:\\resin-2.1.4\\doc\\images\\accidImg\\", request.getInputStream());
	
	String filename[] = new String[10];
	
	filename[0] = file.getFilename1() == null ? "" : file.getFilename1();
	filename[1] = file.getFilename2() == null ? "" : file.getFilename2();
	filename[2] = file.getFilename3() == null ? "" : file.getFilename3();
	filename[3] = file.getFilename4() == null ? "" : file.getFilename4();
	filename[4] = file.getFilename5() == null ? "" : file.getFilename5();
	filename[5] = file.getFilename6() == null ? "" : file.getFilename6();
	filename[6] = file.getFilename7() == null ? "" : file.getFilename7();
	filename[7] = file.getFilename8() == null ? "" : file.getFilename8();
	filename[8] = file.getFilename9() == null ? "" : file.getFilename9();
	filename[9] = file.getFilename10() == null ? "" : file.getFilename10();
	
	String mode = file.getParameter("mode")==null?"i":file.getParameter("mode");
	int flag = 0;
	
	AccidDatabase ac_db = AccidDatabase.getInstance();
	
	for(int i=0; i<10; i++){
		
		PicAccidBean p_bean = new PicAccidBean();
		p_bean.setCar_mng_id(file.getParameter("c_id"));
		p_bean.setAccid_id(file.getParameter("accid_id"));
		p_bean.setFilename(filename[i]);
		p_bean.setReg_id(file.getParameter("user_id"));
		
		if(!filename[i].equals(""))		flag = ac_db.insertPicAccid(p_bean);
	}
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
