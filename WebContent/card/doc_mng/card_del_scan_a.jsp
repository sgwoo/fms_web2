<%@ page language="java" contentType="text/html;charset=euc-kr" %>
<%@ page import="java.io.*, java.util.*, acar.util.*, card.*"%>
<jsp:useBean id="CardDb" scope="page" class="card.CardDatabase"/>
<%
	//��ĵ���� ���/���� ó�� ������
	String auth_rw 		= request.getParameter("auth_rw")==null?"":request.getParameter("auth_rw");
	String user_id 		= request.getParameter("user_id")==null?"":request.getParameter("user_id");

	String cardno 	= request.getParameter("cardno")==null?"":request.getParameter("cardno");
	String buy_id 	= request.getParameter("buy_id")==null?"":request.getParameter("buy_id");

	int count = 0;
	
	//ī������
	CardDocBean cd_bean = CardDb.getCardDoc(cardno, buy_id);

	String file_name 	= "";
	String re_file_name = cd_bean.getCard_file();	
	
	file_name = "";
				
	File drop_file = new File("D:\\Inetpub\\wwwroot\\data\\card\\"+re_file_name);
			//���� ���� ����
	drop_file.delete();		
		
				
	count = CardDb.updateCardScan(cardno, buy_id);
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
   <input type="hidden" name="cardno" 			value="<%=cardno%>">
  <input type="hidden" name="buy_id" 			value="<%=buy_id%>">
</form>
<script language='javascript'>
<%	if(count > 0){	%>		
		alert('�ش� ������ �����Ǿ����ϴ�. Ȯ���Ͻ÷��� ���ΰ�ħ�� �ϼ���.');
<%	}else{	%>
		alert('�����ͺ��̽� �����Դϴ�.\n\n��ϵ��� �ʾҽ��ϴ�');		
<%	}	%>

</script>
<body>
</body>
</html>