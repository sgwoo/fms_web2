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
	
	//��� ��������� ����ó��
	String  d_flag3 =  ad_db.call_sp_rent_cont_copy(rent_mng_id, rent_l_cd, copy_cnt);
%>
<script language='javascript'>
<%	if(!d_flag3.equals("")){%>
		alert("ó������ �ʾҽ��ϴ�");
		location='about:blank';		
<%	}else{		%>		
		alert("ó���Ǿ����ϴ�. �̰�������� Ȯ���Ͻʽÿ�.");
		parent.window.close();
<%	}			%>
</script>