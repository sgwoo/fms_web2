<%@ page language="java" contentType="text/html;charset=euc-kr" %>
<%@ page import="java.util.*, acar.fee.*, acar.util.*,acar.fee.*, acar.cont.*, acar.insur.*"%>
<jsp:useBean id="af_db" scope="page" class="acar.fee.AddFeeDatabase"/>
<%@ include file="/acar/cookies.jsp" %>

<html>
<head><title>FMS</title>
</head>
<meta http-equiv="content-type" content="text/html; charset=euc-kr">
<link rel=stylesheet type="text/css" href="/include/table.css">
<body leftmargin="15">

<%
	
	
	String auth_rw = request.getParameter("auth_rw")==null?"":request.getParameter("auth_rw");
	String user_id = request.getParameter("user_id")==null?"":request.getParameter("user_id");//로그인-ID
	String br_id = request.getParameter("br_id")==null?"":request.getParameter("br_id");//로그인-영업소
	
	String m_id 	= request.getParameter("m_id")==null?"":request.getParameter("m_id");
	String l_cd 	= request.getParameter("l_cd")==null?"":request.getParameter("l_cd");
	String cng_dt 	= request.getParameter("cng_dt")==null?"":request.getParameter("cng_dt");
	String cng_cau 	= request.getParameter("cng_cau")==null?"":request.getParameter("cng_cau");
	String cmd 		= request.getParameter("cmd")==null?"":request.getParameter("cmd");
	
	int flag = 0;
	
	//대여변경이력
	FeeScdCngBean fee_scd = af_db.getFeeScdCngCase(m_id, l_cd, cng_dt);
	
	if(cmd.equals("d")){
		//삭제
		if(!af_db.dropFeeScdCngCase(m_id, l_cd, cng_dt)) flag += 1;
	}else{
		//수정
		fee_scd.setCng_cau		(cng_cau);
		if(!af_db.updateFeeScdCngCase(fee_scd)) flag += 1;
	}
%>
<form name='form1' method='post'>
<input type='hidden' name='m_id' value='<%=m_id%>'>
<input type='hidden' name='l_cd' value='<%=l_cd%>'>
<input type='hidden' name='auth_rw' value='<%=auth_rw%>'>
<input type='hidden' name='user_id' value='<%=user_id%>'>
<input type='hidden' name='br_id' value='<%=br_id%>'>
</form>
<script language='javascript'>
<%	if(flag != 0){%>
		alert("변경내용이 처리 되지 않았습니다");
<%	}else{		%>		
		alert("변경내용이 처리되었습니다");
		parent.window.close();
<%	}			%>
</script>