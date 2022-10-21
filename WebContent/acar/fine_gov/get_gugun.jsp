<%@ page language="java" contentType="text/html;charset=euc-kr" %>
<%@ page import="java.util.*"%>
<jsp:useBean id="FineDocDb" scope="page" class="acar.forfeit_mng.FineDocDatabase"/>
<%@ include file="/off/cookies.jsp" %>

<%
	String gubun1 = request.getParameter("gubun1")==null?"":request.getParameter("gubun1");
	
	Vector CodeList = FineDocDb.getZipGugun(gubun1);
%>
<html>
<head>
<title>FMS</title>
<script language='JavaScript' src='/include/common.js'></script>
</head>
<body>
	<script language='javascript'>
<!--
	var te = parent.form1.gubun2;

<%	if(CodeList.size() > 0){%>
				te.length = <%= CodeList.size()+1 %>;
				te.options[0].value = '';
				te.options[0].text = '시/구/군';
<%		for(int i = 0 ; i < CodeList.size() ; i++){
			Hashtable ht = (Hashtable)CodeList.elementAt(i);	%>
				te.options[<%=i+1%>].value = '<%= ht.get("GUGUN") %>';
				te.options[<%=i+1%>].text = '<%= ht.get("GUGUN") %>';
<%		}
	}else{	%>	
				te.length = 1;
				te.options[0].value = '';
				te.options[0].text = '시/구/군';
<%	}	%>	
//-->
</script>
</body>
</html>
