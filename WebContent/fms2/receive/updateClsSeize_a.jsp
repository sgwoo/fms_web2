<%@ page language="java" contentType="text/html;charset=euc-kr" %>
<%@ page import="java.util.*, acar.util.*,  acar.receive.*, acar.doc_settle.*"%>
<jsp:useBean id="re_db" scope="page" class="acar.receive.ReceiveDatabase"/>
<jsp:useBean id="d_db" scope="page" class="acar.doc_settle.DocSettleDatabase"/>
<%@ include file="/acar/cookies.jsp" %>

<%
		
	String auth_rw 	= request.getParameter("auth_rw")==null?"":request.getParameter("auth_rw");
	String user_id	= request.getParameter("user_id")==null?"":request.getParameter("user_id");//�α���-ID
	String br_id 	= request.getParameter("br_id")==null?"":request.getParameter("br_id");//�α���-������
	
	String rent_mng_id = request.getParameter("rent_mng_id")==null?"":request.getParameter("rent_mng_id");
	String rent_l_cd = request.getParameter("rent_l_cd")==null?"":request.getParameter("rent_l_cd");
	
	String seize_dt	 	= request.getParameter("seize_dt")==null?"":request.getParameter("seize_dt"); //�з��� 
	int  seize_amt =      request.getParameter("seize_amt")==null?0:AddUtil.parseDigit(request.getParameter("seize_amt")); //�з���� 
	
	String cmd	 	= request.getParameter("cmd")==null?"":request.getParameter("cmd"); //1:���� (�ʱ�ȭ), 2:����
	
	
	int count = 0;
	int flag = 0;
	
	boolean flag1 = true;	
	int result = 0;
		
	if (cmd.equals("1"))  {
		seize_amt =  0;
		seize_dt =  "";
	}
	
	if(!re_db.updateClsSeize(rent_mng_id, rent_l_cd , seize_dt , seize_amt))	flag += 1;	
	
%>
<html>
<head>
<title>FMS</title>
<meta http-equiv="content-type" content="text/html; charset=euc-kr">
<link rel="stylesheet" type="text/css" href="/include/table_t.css"></link>
<script language="JavaScript">
<!--
//-->
</script>
</head>
<body>
<script>

<%	if(flag != 0){ 	//ä���߽����̺� ���� ����%>

	alert('��� �����߻�!');

<%	}else{ 			//ä���߽����̺� ���� ����.. %>
	
   	 alert('ó���Ǿ����ϴ�');		
   	 parent.opener.location.reload();
     parent.window.close();			
<%	
	} %>

</script>
</body>
</html>

