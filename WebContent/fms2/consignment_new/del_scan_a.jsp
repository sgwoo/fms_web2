<%@ page language="java" contentType="text/html;charset=euc-kr" %>
<%@ page import="java.io.*, java.util.*, acar.util.*, acar.consignment.*"%>
<jsp:useBean id="cs_db" scope="page" class="acar.consignment.ConsignmentDatabase"/>
<%@ include file="/acar/cookies.jsp" %>

<%
	//스캔관리 등록/삭제 처리 페이지

	int result = 0;
	
	String auth_rw 		= request.getParameter("auth_rw")==null?"":request.getParameter("auth_rw");
	String user_id 		= request.getParameter("user_id")==null?"":request.getParameter("user_id");
	String br_id 		= request.getParameter("br_id")==null?"":request.getParameter("br_id");
	String seq 	= request.getParameter("seq")==null?"":request.getParameter("seq");	//순번
	String cons_no 	= request.getParameter("cons_no")  ==null?"":request.getParameter("cons_no");  //탁송번호
	String gubun 	= request.getParameter("gubun")  ==null?"":request.getParameter("gubun");  //구분	
	
	result = cs_db.updateConsignmentParkingScan(seq, "", cons_no, gubun);
	
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
  <input type="hidden" name="br_id" 			value="<%=br_id%>">    
  <input type="hidden" name="seq" 			value="<%=seq%>">

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