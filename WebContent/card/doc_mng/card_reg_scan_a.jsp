<%@ page language="java" contentType="text/html;charset=euc-kr" %>
<%@ page import="java.io.*, java.util.*, acar.util.*, card.*"%>
<jsp:useBean id="CardDb" scope="page" class="card.CardDatabase"/>

<%
	//��ĵ���� ���
    
	int result = 0;
	
	/* multipart/form-data �� FileUpload��ü ���� */ 
	
	String savePath="D:\\Inetpub\\wwwroot\\data\\card"; // ������ ���丮 (������)

 	int sizeLimit = 10 * 1024 * 1024 ; // 10�ް����� ���� �Ѿ�� ���ܹ߻�
 	
	/* multipart/form-data �� FileUpload��ü ���� */ 
	MultipartRequest multi=new MultipartRequest(request, savePath, sizeLimit);
	
	String auth_rw 		= multi.getParameter("auth_rw")==null?"":multi.getParameter("auth_rw");
	String user_id 		= multi.getParameter("user_id")==null?"":multi.getParameter("user_id");
	
	String cardno 	= multi.getParameter("cardno")==null?"":multi.getParameter("cardno");
	String buy_id 	= multi.getParameter("buy_id")==null?"":multi.getParameter("buy_id");
	
	String file1 = multi.getParameter("file1")==null?"":multi.getParameter("file1");
	String filename="";

	//�ѱ��� ������ ���� -MultipartRequest
 	file1=new String(file1.getBytes("8859_1"),"euc-kr");  
	String card_file = "";
		
	String formName ="";	
	Enumeration formNames=multi.getFileNames();  // ���� �̸� ��ȯ
	
	formName = (String)formNames.nextElement();   // ������ type�� file�ΰ��� �̸�(name)�� ��ȯ(�� : upload1)
	filename = multi.getFilesystemName(formName); // ������ �̸� ���
	
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
		alert('�ش� ������ ��ϵǾ����ϴ�.\n\n��ϵ� ������ Ȯ���Ͻ÷��� ���ΰ�ħ�� �ϼ���.');
	
<%	}else{	%>
		alert('�����ͺ��̽� �����Դϴ�.\n\n��ϵ��� �ʾҽ��ϴ�');	
		
<%	}	%>
		self.window.close();

</script>
<body>
</body>
</html>