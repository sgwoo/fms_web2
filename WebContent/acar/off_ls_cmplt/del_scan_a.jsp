<%@ page language="java" contentType="text/html;charset=euc-kr" %>
<%@ page import="java.io.*, java.util.*, acar.util.*, acar.asset.*"%>

<%@ include file="/acar/cookies.jsp" %>

<%
	//스캔관리 등록/삭제 처리 페이지
	
	String seq = "";
	int result = 0;
	
	String auth_rw 		= request.getParameter("auth_rw")==null?"":request.getParameter("auth_rw");
	String user_id 		= request.getParameter("user_id")==null?"":request.getParameter("user_id");

	String car_mng_id 	= request.getParameter("car_mng_id")==null?"":request.getParameter("car_mng_id");

	String remove_seq 	= request.getParameter("remove_seq")==null?"":request.getParameter("remove_seq");//삭제여부
	
	AssetDatabase as_db = AssetDatabase.getInstance();
			
	result = as_db.updateSuiCommScan(car_mng_id,  "");
%>
<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=euc-kr">
<title></title>
</head>
<form name='form1' method='post'>
  <input type="hidden" name="auth_rw" 			value="<%=auth_rw%>">
  <input type="hidden" name="user_id" 			value="<%=user_id%>">
  
  <input type="hidden" name="car_mng_id" 			value="<%=car_mng_id%>">

</form>
<script language='javascript'>
<%	if(result > 0){	%>		
		alert('해당 파일이 삭제되었습니다.');
<%	}else{	%>
		alert('데이터베이스 에러입니다.\n\n등록되지 않았습니다');		
<%	}	%>

	parent.location.reload();

</script>
<body>
</body>
</html>