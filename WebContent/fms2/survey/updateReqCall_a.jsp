<%@ page language="java" contentType="text/html;charset=euc-kr"%>
<%@ page import="java.util.*, acar.util.*, acar.call.*,  acar.user_mng.*"%>

<%@ include file="/acar/cookies.jsp" %>

<html><head><title>FMS</title>
</head>
<body>
<%

	String user_id 		= request.getParameter("user_id")		==null?ck_acar_id:request.getParameter("user_id");
	String br_id 		= request.getParameter("br_id")			==null?"":request.getParameter("br_id");
			
	String m_id 	= request.getParameter("m_id")	==null?"":request.getParameter("m_id");
	String l_cd 	= request.getParameter("l_cd")	==null?"":request.getParameter("l_cd");		
	
	int flag = 0;	
	
	PollDatabase p_db = PollDatabase.getInstance();
				
	String from_page 	= "call_cond_frame.jsp";	
	
	//Ȯ�ΰ�
	if(!p_db.updateContCallReq(m_id, l_cd ))	flag += 1;		
	
%>
<form name='form1' method="POST">


</form>

<script language='javascript'>
	var fm = document.form1;

<%	if(flag != 0){ 	//�������̺� ���� ����%>

	alert('��� �����߻�!');

<%	}else{ 			//�������̺� ���� ����.. %>
	
    alert('ó���Ǿ����ϴ�');
    fm.action ='<%=from_page%>';				
    fm.target='d_content';		
    fm.submit();
<%	
	} %>
</script>
</body>
</html>
