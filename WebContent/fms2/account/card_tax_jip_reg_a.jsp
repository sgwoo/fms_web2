<%@ page language="java" contentType="text/html;charset=euc-kr"%>
<%@ page import="java.util.*, acar.util.*, acar.user_mng.*"%>
<jsp:useBean id="ic_db" scope="page" class="acar.incom.IncomDatabase" />
<%@ include file="/acar/cookies.jsp" %>

<html>
<head><title>FMS</title></head>
<body style="font-size:12">

<%

	String auth_rw 	= request.getParameter("auth_rw")==null?"":request.getParameter("auth_rw");
	String user_id 	= request.getParameter("user_id")==null?"":request.getParameter("user_id");//로그인-ID
	
	String gubun0 	= request.getParameter("gubun0")==null?"":request.getParameter("gubun0"); //년도  
	String gubun2 	= request.getParameter("gubun2")==null?"":request.getParameter("gubun2"); // 분기
	String st_mon 	= request.getParameter("st_mon")==null?"":request.getParameter("st_mon"); // 월
					
	String  flag =  ic_db.call_sp_car_jip_tax(gubun0, st_mon);
	
	System.out.println("신용카드 매출집계 ="+flag);
	
%>

<form name='form1' method="POST">
<input type='hidden' name='auth_rw' value='<%=auth_rw%>'>
<input type='hidden' name='user_id' value='<%=user_id%>'>
<input type='hidden' name='gubun0' value='<%=gubun0%>'>
<input type='hidden' name='gubun2' value='<%=gubun2%>'>

</form>
<script language='javascript'>
<%	if(flag.equals("1")){%>
		alert('오류발생!');

<%	}else{%>
		alert('처리되었습니다');
<%	}%>
</script>
</body>
</html>

