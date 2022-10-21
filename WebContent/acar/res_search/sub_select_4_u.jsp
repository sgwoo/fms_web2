<%@ page language="java" contentType="text/html;charset=euc-kr" %>
<%@ page import="java.util.*, acar.res_search.*, acar.util.*"%>
<jsp:useBean id="rs_db" scope="page" class="acar.res_search.ResSearchDatabase"/>
<%@ include file="/acar/cookies.jsp" %>

<html>
<head>
<title>FMS</title>
<link rel=stylesheet type="text/css" href="/include/table.css">
<script language='JavaScript' src='../../include/common.js'></script>
</head>
<body leftmargin="15">
<%
	String user_id = request.getParameter("user_id")==null?"":request.getParameter("user_id");
	Hashtable client = rs_db.getUserList(user_id);
%>
<script language='javascript'>
	var fm = parent.form1;
	fm.c_cust_id.value = '<%=user_id%>';
	fm.c_brch_nm.value = '<%=client.get("BRCH_NM")%>';	
	fm.c_dept_nm.value = '<%=client.get("DEPT_NM")%>';
	fm.c_lic_no.value = '<%=client.get("LIC_NO")%>';		
	fm.c_lic_st.value = '<%=client.get("LIC_ST")%>';
	fm.c_tel.value = '<%=client.get("TEL")%>';
	fm.c_m_tel.value = '<%=client.get("M_TEL")%>';
	fm.rent_dt.focus();
</script>
</body>
</html>
