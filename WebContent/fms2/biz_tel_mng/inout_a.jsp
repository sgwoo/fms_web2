<%@ page language="java" contentType="text/html;charset=euc-kr" %>
<%@ page import="java.util.*, acar.util.*, acar.biz_tel_mng.*"%>

<%@ include file="/acar/cookies.jsp" %>
<%

	String user_id = request.getParameter("user_id")==null?"":request.getParameter("user_id");
	String cmd = request.getParameter("cmd")==null?"":request.getParameter("cmd");
	String del_id = request.getParameter("del_id")==null?"":request.getParameter("del_id"); //������ ���̵� �Ѱܹޱ�
	int count = 0;
	
	BiztelDatabase biz_db = BiztelDatabase.getInstance();

	if(cmd.equals("i")){
	count = biz_db.insertM_io("Y", user_id);
	}else if(cmd.equals("d")){
	count = biz_db.deleteM_io("", del_id);
	}


%>
<html>
<head>
<title>FMS</title>
</head>
<body leftmargin="15" >
<form name='form1' action='' method="POST" enctype="">
<input type='hidden' name='user_id' value='<%=user_id%>'>
<input type='hidden' name='cmd' value=''>
</form>
<script language='javascript'>
<!--
	var fm = document.form1;

<%	if(cmd.equals("i")){
if(count==1){	%>
		alert("���������� ��ϵǾ����ϴ�.");
		fm.action='./inout.jsp';
		fm.target='d_content';
		fm.submit();		
		
<%}
}else if(cmd.equals("d")){
	if(count==1){	%>
		alert("���������� �����Ǿ����ϴ�.");
		fm.action='./inout.jsp';
		fm.target='d_content';
		fm.submit();		
<%}
}else{%>
	alert("�����Դϴ�.");
<%}%>
//-->

</script>
</body>
</html>
