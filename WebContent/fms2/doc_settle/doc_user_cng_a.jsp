<%@ page language="java" contentType="text/html;charset=euc-kr"%>
<%@ page import="java.util.*,acar.util.*, acar.user_mng.*"%>
<%@ page import="acar.doc_settle.*, acar.car_register.*, acar.cont.*"%>
<jsp:useBean id="d_db" scope="page" class="acar.doc_settle.DocSettleDatabase"/>
<%@ include file="/acar/cookies.jsp" %> 

<%
	String auth_rw 	= request.getParameter("auth_rw")==null?"":request.getParameter("auth_rw");
	String user_id 	= request.getParameter("user_id")==null?"":request.getParameter("user_id");
	String br_id 	= request.getParameter("br_id")==null?"":request.getParameter("br_id");
	
	String s_kd 	= request.getParameter("s_kd")==null? "3":request.getParameter("s_kd");
	String t_wd 	= request.getParameter("t_wd")==null? "" :request.getParameter("t_wd");
	String andor 	= request.getParameter("andor")==null?"1":request.getParameter("andor");
	String gubun1 	= request.getParameter("gubun1")==null?"":request.getParameter("gubun1");
	String gubun2 	= request.getParameter("gubun2")==null?"":request.getParameter("gubun2");
	String gubun3 	= request.getParameter("gubun3")==null?"":request.getParameter("gubun3");
	String start_dt = request.getParameter("start_dt")==null?"":request.getParameter("start_dt");
	String end_dt 	= request.getParameter("end_dt")==null?"":request.getParameter("end_dt");
	
	int sh_height = request.getParameter("sh_height")==null?0:Util.parseInt(request.getParameter("sh_height"));//상단길이
	
	String doc_no 	= request.getParameter("doc_no")==null?"":request.getParameter("doc_no");
	String doc_bit 	= request.getParameter("doc_bit")==null?"":request.getParameter("doc_bit");
	String doc_user	= request.getParameter("doc_user")==null?"":request.getParameter("doc_user");
	String cng_id	= request.getParameter("cng_id")==null?"":request.getParameter("cng_id");
	
	
	
	DocSettleBean doc 		= d_db.getDocSettle(doc_no);
	
	boolean flag = true;
	
	flag = d_db.updateDocSettleUserCng(doc_no, doc_bit, cng_id);
	
	
%>

<html>
<head><title>FMS</title>
</head>
<meta http-equiv="Content-Type" content="text/html; charset=euc-kr">
<link rel=stylesheet type="text/css" href="/include/table.css">

<body leftmargin="15">
<script language='javascript'>
<%	if(!flag){	%>		
		alert("처리되지 않았습니다");
		location='about:blank';		
<%	}else{		%>		
		alert("처리되었습니다");
		parent.window.close();
		parent.opener.location.reload();
<%	}			%>
</script>