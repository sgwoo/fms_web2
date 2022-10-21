<%@ page language="java" contentType="text/html;charset=euc-kr"%>
<%@ page import="java.util.*, acar.util.*"%>
<jsp:useBean id="ac_db" scope="page" class="acar.cost.CostDatabase"/>
<%@ include file="/acar/cookies.jsp"%>
<%@ include file="/acar/access_log.jsp" %>

<%
	String auth_rw 	= request.getParameter("auth_rw")==null?"":request.getParameter("auth_rw"); 		//권한
	String user_id 	= request.getParameter("user_id")==null?ck_acar_id:request.getParameter("user_id");	//로그인-ID

	String from_page = request.getParameter("from_page")==null?"":request.getParameter("from_page");
	String today = AddUtil.getDate(4);
	String save_dt = today;
	
	int flag2 = 0;
	
	//stord procedure call
	String  d_flag0 =  ac_db.call_sp_cost_accident_magam(today, user_id);	
	if (!d_flag0.equals("0")) flag2 = 1;	
	System.out.println("관리비용 사고마감 등록");
		
	String  d_flag1 =  ac_db.call_sp_cost_base_magam(today, user_id);	
	if (!d_flag1.equals("0")) flag2 = 1;	
	System.out.println("관리비용 기초마감 등록");
	
	String  d_flag2 =  ac_db.call_sp_cost_pre_base_magam(today, user_id);	
	if (!d_flag2.equals("0")) flag2 = 1;	
	System.out.println("관리비용 예비차 기초마감 등록");
	
	String  d_flag3 =  ac_db.call_sp_man_cost_magam(today, user_id);
	if (!d_flag3.equals("0")) flag2 = 1;
	    System.out.println("고객지원팀 관리비용마감 등록");
	    
	String  d_flag4 =  ac_db.call_sp_man_cost3_magam(today, user_id);
	if (!d_flag4.equals("0")) flag2 = 1;
	    System.out.println("영업팀 관리비용마감 등록");

//	String  d_flag5 =  ac_db.call_sp_man_cost4_magam(today, user_id);
//	if (!d_flag5.equals("0")) flag2 = 1;
//	    System.out.println("영업팀- II  관리비용마감 등록");
	    
%>

<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN">
<html>
<head>
<title>비용캠페인</title>
<meta http-equiv="Content-Type" content="text/html; charset=euc-kr">
<link rel="stylesheet" type="text/css" href="../../include/table.css">
<script language='JavaScript' src='/include/common.js'></script>
<script language='javascript'>
<!--
//-->
</script>
</head>
<body>
<form name='form1' action='/acar/admin/stat_end_sc.jsp' target='d_content' method="POST">
<input type='hidden' name='auth_rw' value='<%=auth_rw%>'>
<input type='hidden' name='user_id' value='<%=user_id%>'>
<input type='hidden' name='save_dt' value='<%=today%>'>
<input type='hidden' name='from_page' value='<%=from_page%>'>

</form>
<script language='javascript'>
		
	var fm = document.form1;
<%	if(flag2 != 0){%>
	alert('비용캠페인 마감등록 오류 발생!');
<%	}else{%>
	alert('등록되었습니다.');
	if(fm.from_page.value == ''){
		fm.action = '/acar/admin/stat_end_sc.jsp';
	}else{
		fm.action =fm.from_page.value;
	}
	fm.submit();						
<%	}%>
</script>
</body>
</html>


