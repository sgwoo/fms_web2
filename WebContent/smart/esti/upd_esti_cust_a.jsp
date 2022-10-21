<%@ page language="java" contentType="text/html; charset=euc-kr" %>
<%@ page import="java.util.*, acar.util.*, acar.estimate_mng.*" %>
<jsp:useBean id="bean" class="acar.estimate_mng.EstimateBean" scope="page"/>
<%@ include file="/smart/cookies.jsp" %>

<%
	int count = 0;
	
	String est_id = request.getParameter("est_id")==null?"":request.getParameter("est_id");
	String from_page = request.getParameter("from_page")==null?"":request.getParameter("from_page");
	
	EstiDatabase e_db = EstiDatabase.getInstance();
	bean = e_db.getEstimateCase(est_id);
	
	bean.setEst_nm		(request.getParameter("est_nm")==null?"":request.getParameter("est_nm"));
	bean.setEst_ssn		(request.getParameter("est_ssn")==null?"":request.getParameter("est_ssn"));
	bean.setEst_tel		(request.getParameter("est_tel")==null?"":request.getParameter("est_tel"));
	bean.setEst_fax		(request.getParameter("est_fax")==null?"":request.getParameter("est_fax"));
	bean.setVali_type	(request.getParameter("vali_type")==null?"":request.getParameter("vali_type"));
	bean.setDoc_type	(request.getParameter("doc_type")==null?"":request.getParameter("doc_type"));
	bean.setReg_id		(request.getParameter("damdang_id")==null?"":request.getParameter("damdang_id"));
	bean.setCaroff_emp_yn	(request.getParameter("caroff_emp_yn")==null?"":request.getParameter("caroff_emp_yn"));
	bean.setGi_grade	(request.getParameter("gi_grade")==null?"":request.getParameter("gi_grade"));
	
	count = e_db.updateEstimate(bean);
	
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
<form action="" name="form1" method="POST">
<%@ include file="/include/search_hidden.jsp" %>
  <input type="hidden" name="est_id" value="<%=est_id%>">          
</form>
<script>
<%	if(count==1){%>		
		alert("수정되었습니다.");
		<%if(!from_page.equals("")){%>
		document.form1.action = "<%=from_page%>";
		<%}else{%>
		document.form1.action = "new_car_esti_u.jsp";
		<%}%>
		document.form1.target = '_parent';
		document.form1.submit();		
<%	}else{%>
		alert("에러발생!");
<%	}%>
</script>
</body>
</html>

