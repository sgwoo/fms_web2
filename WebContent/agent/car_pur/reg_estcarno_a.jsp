<%@ page language="java" contentType="text/html;charset=euc-kr" %>
<%@ page import="java.util.*, acar.util.*"%>
<jsp:useBean id="a_db" scope="page" class="acar.cont.AddContDatabase"/>
<%@ include file="/agent/cookies.jsp" %>

<html>
<head><title>FMS</title>
</head>
<meta http-equiv="Content-Type" content="text/html; charset=euc-kr">
<link rel=stylesheet type="text/css" href="/include/table.css">

<body leftmargin="15">
<%
	//희망차량번호 수정 처리 페이지
	
	String m_id 		= request.getParameter("m_id")==null?"":request.getParameter("m_id");
	String l_cd 		= request.getParameter("l_cd")==null?"":request.getParameter("l_cd");
	String est_car_no 	= request.getParameter("est_car_no")==null?"":request.getParameter("est_car_no");
	String est_car_num	= request.getParameter("est_car_num")==null?"":request.getParameter("est_car_num");
	String mode 	= request.getParameter("mode")==null?"":request.getParameter("mode");
	String query = "";
	int flag = 0;
	
	query = " UPDATE car_pur SET est_car_no =replace('"+est_car_no+"','-',''), car_num =replace('"+est_car_num+"','-','')   WHERE rent_mng_id='"+m_id+"' and rent_l_cd='"+l_cd+"'";
	flag = a_db.updateEstDt(query);
%>
<script language='javascript'>
<%	if(flag == 0){%>
		alert("처리되지 않았습니다");
		location='about:blank';		
<%	}else{		%>		
		alert("처리되었습니다");
		<%if(mode.equals("board")){%>	
			parent.window.close();
			parent.opener.location.reload();
		<%}%>
<%	}			%>
</script>