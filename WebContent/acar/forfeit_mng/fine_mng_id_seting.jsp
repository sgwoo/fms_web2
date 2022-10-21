<%@ page language="java" contentType="text/html; charset=euc-kr" %>
<%@ page import="java.util.*, acar.util.*, acar.forfeit_mng.*" %>
<%@ include file="/acar/cookies.jsp" %>

<%
	int count = 0;
	
	AddForfeitDatabase afdb = AddForfeitDatabase.getInstance();
	
/*	
	afdb.getFineMngIdNullList("between '200301' and '200302'");
	afdb.getFineMngIdNullList("between '200303' and '200304'");
	afdb.getFineMngIdNullList("between '200305' and '200306'");
	afdb.getFineMngIdNullList("between '200307' and '200308'");
	afdb.getFineMngIdNullList("between '200309' and '200310'");
	afdb.getFineMngIdNullList("between '200311' and '200312'");
*/
	
/*
	String year = "2008";
	afdb.getFineMngIdNullList(year+"01");
	afdb.getFineMngIdNullList(year+"02");
	afdb.getFineMngIdNullList(year+"03");
	afdb.getFineMngIdNullList(year+"04");
	afdb.getFineMngIdNullList(year+"05");
	afdb.getFineMngIdNullList(year+"06");
	afdb.getFineMngIdNullList(year+"07");
	afdb.getFineMngIdNullList(year+"08");
	afdb.getFineMngIdNullList(year+"09");
	afdb.getFineMngIdNullList(year+"10");
	afdb.getFineMngIdNullList(year+"11");
	afdb.getFineMngIdNullList(year+"12");
*/
	
	afdb.getFineMngIdNullList("");
%>
<html>
<head>
<meta http-equiv="content-type" content="text/html; charset=euc-kr">
<title>FMS</title>
<link rel="stylesheet" type="text/css" href="/include/table_t.css"></link>
<script language="JavaScript">
<!--
	alert('ok');
//-->
</script>
</head>
<body>
</body>
</html>