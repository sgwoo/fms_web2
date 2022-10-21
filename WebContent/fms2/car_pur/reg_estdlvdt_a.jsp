<%@ page language="java" contentType="text/html;charset=euc-kr" %>
<%@ page import="java.util.*, acar.common.*, acar.util.*"%>
<jsp:useBean id="a_db" scope="page" class="acar.cont.AddContDatabase"/>
<%@ include file="/acar/cookies.jsp" %>

<html>
<head><title>FMS</title>
</head>
<meta http-equiv="Content-Type" content="text/html; charset=euc-kr">
<link rel=stylesheet type="text/css" href="/include/table.css">


<body leftmargin="15">
<%
	//장기간 출고지연 사유 처리 페이지
	
	String m_id 		= request.getParameter("m_id")==null?"":request.getParameter("m_id");
	String l_cd 		= request.getParameter("l_cd")==null?"":request.getParameter("l_cd");
	String mode 		= request.getParameter("mode")==null?"":request.getParameter("mode");
	String car_tax_dt 	= request.getParameter("car_tax_dt")==null?"":request.getParameter("car_tax_dt");
	String car_amt_dt 	= request.getParameter("car_amt_dt")==null?"":request.getParameter("car_amt_dt");
	String query = "";
	int flag = 0;
	
	query = " UPDATE car_etc SET car_tax_dt =replace('"+car_tax_dt+"','-',''), car_amt_dt =replace('"+car_amt_dt+"','-','') WHERE rent_mng_id='"+m_id+"' and rent_l_cd='"+l_cd+"'";
	flag = a_db.updateEstDt(query);
%>
<script language='javascript'>
<%	if(flag == 0){%>
		alert("처리되지 않았습니다");
<%	}else{		%>		
		alert("처리되었습니다");
<%	}			%>
</script>