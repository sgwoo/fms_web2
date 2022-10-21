<%@ page language="java" contentType="text/html;charset=euc-kr" %>
<%@ page import="java.io.*, java.util.*, acar.util.*, card.*"%>
<jsp:useBean id="CardDb" scope="page" class="card.CardDatabase"/>

<%
	//스캔관리 등록
    
	int result = 0;
	
	/* multipart/form-data 로 FileUpload객체 생성 */ 
	
	String savePath="D:\\Inetpub\\wwwroot\\data\\card"; // 저장할 디렉토리 (절대경로)

 	int sizeLimit = 10 * 1024 * 1024 ; // 10메가까지 제한 넘어서면 예외발생
 	
	/* multipart/form-data 로 FileUpload객체 생성 */ 
	MultipartRequest multi=new MultipartRequest(request, savePath, sizeLimit);
	
	String auth_rw 		= multi.getParameter("auth_rw")==null?"":multi.getParameter("auth_rw");
	String user_id 		= multi.getParameter("user_id")==null?"":multi.getParameter("user_id");
	
	String cardno 	= multi.getParameter("cardno")==null?"":multi.getParameter("cardno");
	String buy_id 	= multi.getParameter("buy_id")==null?"":multi.getParameter("buy_id");
	
	String file1 = multi.getParameter("file1")==null?"":multi.getParameter("file1");
	String filename="";

	//한글이 깨지는 문제 -MultipartRequest
 	file1=new String(file1.getBytes("8859_1"),"euc-kr");  
	String card_file = "";
		
	String formName ="";	
	Enumeration formNames=multi.getFileNames();  // 폼의 이름 반환
	
	formName = (String)formNames.nextElement();   // 폼에서 type이 file인것의 이름(name)을 반환(예 : upload1)
	filename = multi.getFilesystemName(formName); // 파일의 이름 얻기
	
	if(filename == null) {
			  card_file = file1;
	}
		else {
			  card_file = filename;
	}
		
	result = CardDb.updateCardScan2(cardno, buy_id, card_file);
%>
<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=euc-kr">
<title></title>
</head>
<script language="JavaScript">
<!--

//-->
</script>
<form name='form1' method='post'>
  <input type="hidden" name="auth_rw" 			value="<%=auth_rw%>">
  <input type="hidden" name="user_id" 			value="<%=user_id%>">
</form>
<script language='javascript'>
<%	if(result > 0){	%>
		alert('해당 파일이 등록되었습니다.\n\n등록된 파일을 확인하시려면 새로고침을 하세요.');
	
<%	}else{	%>
		alert('데이터베이스 에러입니다.\n\n등록되지 않았습니다');	
		
<%	}	%>
		self.window.close();

</script>
<body>
</body>
</html>