<%@ page language="java" contentType="text/html;charset=euc-kr"%>
<%@ page import="java.io.*, java.util.*, acar.util.*, acar.res_search.*, acar.car_register.*"%>
<jsp:useBean id="rs_db" scope="page" class="acar.res_search.ResSearchDatabase"/>
<jsp:useBean id="olyD" class="acar.offls_yb.Offls_ybDatabase" scope="page"/>

<html>
<head>
<title>FMS</title>
</head>
<body>
<%
	/* multipart/form-data 로 FileUpload객체 생성 */ 
	FileUpload file = new FileUpload("C:\\Inetpub\\wwwroot\\images\\carImg\\", request.getInputStream());
	String filename = file.getFilename2() == null ? "" : file.getFilename2();
	
	String c_id = file.getParameter("c_id")==null?"":file.getParameter("c_id");
	String o_img = file.getParameter("o_img")==null?"":file.getParameter("o_img");
	String idx = file.getParameter("idx")==null?"":file.getParameter("idx");
	String mode = file.getParameter("mode")==null?"":file.getParameter("mode");
	String imgfile1 = "";
	String imgfile2 = "";
	String imgfile3 = "";
	String imgfile4 = "";
	String imgfile5 = "";
	String imgfile6 = "";
	if(idx.equals("1")) imgfile1 = filename;
	if(idx.equals("2")) imgfile2 = filename;
	if(idx.equals("3")) imgfile3 = filename;
	if(idx.equals("4")) imgfile4 = filename;
	if(idx.equals("5")) imgfile5 = filename;
	if(idx.equals("6")) imgfile6 = filename;
	int count = 0;
	int a_yn = rs_db.getApprslChk(c_id);
	if(a_yn == 0){//apprsl 레코드가 없으면 생성
		count = olyD.inApprsl_img(c_id, "", imgfile1, imgfile2, imgfile3, imgfile4, imgfile5, imgfile6);
	}
	
	if(mode.equals("i")){//등록
		count = rs_db.insertApprsl(c_id, filename, idx);
	}else if(mode.equals("i")){//수정
		count = rs_db.updateCarImg(c_id, filename, idx);
	}else if(mode.equals("d")){//삭제
		File drop_file = new File("C:\\Inetpub\\wwwroot\\images\\carImg\\"+o_img+".gif");
		drop_file.delete();
		count = rs_db.updateCarImg(c_id, "", idx);
	}
%>
<script language='javascript'>
<%	if(count == 0)	{	%>
		alert('처리되지 않았습니다');
<%	}else{	%>
		alert("처리되었습니다");
<%	}	%>
	parent.location.href = "car_img_add_in.jsp?c_id=<%=c_id%>&idx=<%=idx%>"
</script>
</body>
</html>
