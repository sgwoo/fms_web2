<%@ page contentType="text/html; charset=euc-kr" %>
<%@ page language="java" %> 
<%@ page import="java.util.*" %>
<%@ page import="acar.util.*" %>
<%@ page import="acar.estimate_mng.*" %>
<jsp:useBean id="em_bean" class="acar.estimate_mng.EstiMBean" scope="page"/>
<%@ include file="/acar/cookies.jsp" %>

<%
	EstiDatabase e_db = EstiDatabase.getInstance();
	
	String est_id = request.getParameter("est_id")==null?"":request.getParameter("est_id");
	String user_id = request.getParameter("user_id")==null?"":request.getParameter("user_id");
	String sub = request.getParameter("sub")==null?"":request.getParameter("sub");
	String note = request.getParameter("note")==null?"":request.getParameter("note");
	String gubun = request.getParameter("gubun")==null?"":request.getParameter("gubun");
	int count = 0;
	
	if (!note.equals("") ) {
		note = note.trim();
	}
		
	//������ ��� ���ڷ�
   if ( note.equals("03") ) {
       note = "���׳�";       
   } else if ( note.equals("04") ) {
   	   note = "����ڹ�Ȯ��";     
   } else if ( note.equals("05") ) {
   	   note = "�������"; 
   } else if ( note.equals("06") ) {
   	   note = "������ü"; 
   } else if ( note.equals("07") ) {
   	   note = "�ܱ�뿩"; 
   } else if ( note.equals("08") ) {
   	   note = "�񱳰�����"; 
   } else if ( note.equals("09") ) {
   	   note = "����������ȸ"; 
   } else if ( note.equals("10") ) {
   	   note = "�����ü����������"; 
   } else if ( note.equals("11") ) {
   	   note = "Ÿ�緻Ʈ(����)�ΰ����"; 
   } else if ( note.equals("12") ) {
   	   note = "�Һα�����"; 
   } else if ( note.equals("13") ) {
       note = "��Ⱓ����"; 
   } else if ( note.equals("14") ) {
   	   note = "�̸�������"; 
   } else if ( note.equals("15") ) {
   	   note = "��������"; 
   } else if ( note.equals("16") ) {
   	   note = "���ü��"; 
   } else if ( note.equals("17") ) {
   	   note = "������"; 
   } else if ( note.equals("18") ) {
   	   note = "��Ÿ"; 
   } else if ( note.equals("19") ) {
   	   note = "�����߹��ڹ߼�"; 
   } 	   	   
   	   	
	em_bean.setUser_id(user_id);
	em_bean.setEst_id(est_id);
	em_bean.setSub(sub);
	em_bean.setNote(note);
	em_bean.setGubun(gubun);
/*
System.out.println("user_id: "+user_id);	
System.out.println("est_id: "+est_id);	
System.out.println("sub: "+sub);	
System.out.println("note: "+note);	
System.out.println("gubun: "+gubun);	
*/
	count = e_db.insertEstiM(em_bean);
	
%>

<html>
<head>

<title>FMS</title>
<meta http-equiv="content-type" content="text/html; charset=euc-kr">
<link rel="stylesheet" type="text/css" href="/include/table_t.css"></link>
<script language="JavaScript">
<!--
	function NullAction(){
	<%if(count==1){%>
		alert("���������� ��ϵǾ����ϴ�.");
		parent.document.form1.note.value = '';	
		parent.location.href = 'guest_memo_spe_i.jsp?est_id=<%=est_id%>&user_id=<%=user_id%>';
	<%}else{%>
		alert("�����߻�!!");
	<%}%>
	}
//-->
</script>
</head>
<body onLoad="javascript:NullAction()">

</body>
</html>
