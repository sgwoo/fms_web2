<%@ page language="java" contentType="text/html;charset=euc-kr" %>
<%@ page import="java.util.*, acar.util.*"%>
<jsp:useBean id="ad_db" scope="page" class="acar.admin.AdminDatabase"/>
<%@ include file="/acar/cookies.jsp" %>

<html>
<head><title>FMS</title>
</head>
<meta http-equiv="Content-Type" content="text/html; charset=euc-kr">
<link rel=stylesheet type="text/css" href="/include/table.css">

<body leftmargin="15">
<%
	String rent_mng_id 	= request.getParameter("rent_mng_id")==null?"":request.getParameter("rent_mng_id");
	String rent_l_cd 	= request.getParameter("rent_l_cd")==null?"":request.getParameter("rent_l_cd");
	String copy_cnt 	= request.getParameter("copy_cnt")==null?"":request.getParameter("copy_cnt");
	
	//계약 영업담당자 배정처리
	String  d_flag3 =  ad_db.call_sp_rent_cont_copy(rent_mng_id, rent_l_cd, copy_cnt);
%>
<script language='javascript'>
<%	if(!d_flag3.equals("")){%>
		alert("처리되지 않았습니다");
		location='about:blank';		
<%	}else{		%>		
		alert("처리되었습니다. 미결관리에서 확인하십시오.");
		parent.window.close();
<%	}			%>
</script>