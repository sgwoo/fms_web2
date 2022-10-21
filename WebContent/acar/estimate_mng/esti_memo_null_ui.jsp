<%@ page contentType="text/html; charset=euc-kr" %>
<%@ page language="java" %> 
<%@ page import="java.util.*" %>
<%@ page import="acar.util.*" %>
<%@ page import="acar.estimate_mng.*" %>
<jsp:useBean id="em_bean" class="acar.estimate_mng.EstiMBean" scope="page"/>
<%@ include file="/acar/cookies.jsp" %>

<%
	EstiDatabase e_db = EstiDatabase.getInstance();
	
	String auth_rw = request.getParameter("auth_rw")==null?"":request.getParameter("auth_rw");
	String br_id = request.getParameter("br_id")==null?"":request.getParameter("br_id");
	String user_id = request.getParameter("user_id")==null?"":request.getParameter("user_id");
	String gubun1 = request.getParameter("gubun1")==null?"":request.getParameter("gubun1");
	String gubun2 = request.getParameter("gubun2")==null?"":request.getParameter("gubun2");
	String gubun3 = request.getParameter("gubun3")==null?"":request.getParameter("gubun3");
	String gubun4 = request.getParameter("gubun4")==null?"1":request.getParameter("gubun4");
	String s_dt = request.getParameter("s_dt")==null?"":request.getParameter("s_dt");
	String e_dt = request.getParameter("e_dt")==null?"":request.getParameter("e_dt");
		
	String est_id = request.getParameter("est_id")==null?"":request.getParameter("est_id");	
	String sub = request.getParameter("sub")==null?"":request.getParameter("sub");
	String note = request.getParameter("note")==null?"":request.getParameter("note");
	String gubun = request.getParameter("gubun")==null?"":request.getParameter("gubun");
	String from_page = request.getParameter("from_page")==null?"":request.getParameter("from_page");
	
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
		<%if(from_page.equals("")){%>
			parent.location.href = 'esti_memo_spe_i.jsp?est_id=<%=est_id%>&user_id=<%=user_id%>';
		<%}else if (from_page.equals("esti_mng_sc_in.jsp")) {%>
			parent.location.href = 'esti_memo_i.jsp?est_id=<%=est_id%>&user_id=<%=user_id%>&from_page=<%=from_page%>';
		<%}else if (from_page.equals("esti_sh_sc_in.jsp")) {%>
			parent.location.href = 'esti_memo_i.jsp?est_id=<%=est_id%>&user_id=<%=user_id%>&from_page=<%=from_page%>';
		<%}else if (from_page.equals("esti_ext_sc_in.jsp")) {%>
			parent.location.href = 'esti_memo_i.jsp?est_id=<%=est_id%>&user_id=<%=user_id%>&from_page=<%=from_page%>';
		<%}else{%>
			parent.location.href = '<%=from_page%>?auth_rw=<%=auth_rw%>&br_id=<%=br_id%>&user_id=<%=user_id%>&gubun1=<%=gubun1%>&gubun2=<%=gubun2%>&gubun3=<%=gubun3%>&gubun4=<%=gubun4%>&s_dt=<%=s_dt%>&e_dt=<%=e_dt%>&est_id=<%=est_id%>';
		<%}%>
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
