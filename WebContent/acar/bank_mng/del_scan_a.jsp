<%@ page language="java" contentType="text/html;charset=euc-kr" %>
<%@ page import="java.io.*, java.util.*, acar.util.*, acar.forfeit_mng.*"%>
<%@ include file="/acar/cookies.jsp" %>

<%
	//��ĵ���� ���/���� ó�� ������
	
	String seq = "";
	int result = 0;
	boolean flag1 = true;
	
	String alt_st 	= request.getParameter("alt_st")==null?"":request.getParameter("alt_st");
	String lend_id 	= request.getParameter("lend_id")==null?"":request.getParameter("lend_id");
	
	
	AddForfeitDatabase a_fdb = AddForfeitDatabase.getInstance();
	
	result = a_fdb.updateLendBankFileName(alt_st, lend_id, "", "");
%>
<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=euc-kr">
<title></title>
</head>
<form name='form1' method='post'>
  <input type="hidden" name="lend_id" 	value="<%=lend_id%>">
</form>
<script language='javascript'>
<%	if(result==1){%>		
		alert('�ش� ������ �����Ǿ����ϴ�.');
<%	}else{	%>
		alert('�����ͺ��̽� �����Դϴ�.\n\n��ϵ��� �ʾҽ��ϴ�');		
<%	}	%>

	parent.location.reload();

</script>
<body>
</body>
</html>