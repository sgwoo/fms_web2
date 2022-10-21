<%@ page language="java" contentType="text/html;charset=euc-kr" %>
<%@ page import="java.util.*, acar.common.*, acar.util.*"%> 
<%@ include file="/acar/cookies.jsp" %>

<%
	//시,도
	String[] sido = request.getParameterValues("sido");
	
	CommonDataBase c_db = CommonDataBase.getInstance();
	//시도
	Vector gugunList = c_db.getZip_gugun(sido);
	int gugun_size = gugunList.size();
		
%>

<html>
<head><title>FMS</title>
<script language='javascript'>
<!--
<%	
	if(gugun_size > 0){
		for(int i = 0 ; i < gugun_size ; i++){
			Hashtable gugun = (Hashtable)gugunList.elementAt(i);
%>			parent.add_gugun(0, '', '--전체--');
			parent.form1.gugun.options[0].selected = true;
			parent.add_gugun(<%=(i+1)%>, '<%=gugun.get("ZIP_CD")%>', '<%=gugun.get("GUGUN")%>');
<%
		}
	}else{
%>
			parent.add_gugun(0, '', '--전체--');
<%
	}
%>
-->
</script>
</head>
<link rel=stylesheet type="text/css" href="/include/table.css">
<body leftmargin="15">
</body>
</html>
