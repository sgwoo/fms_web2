<%@ page language="java" contentType="text/html;charset=euc-kr" %>
<%@ page import="java.io.*, java.util.*, acar.util.*, acar.credit.*"%>
<jsp:useBean id="ac_db" scope="page" class="acar.credit.AccuDatabase"/>
<%@ include file="/acar/cookies.jsp" %>

<%
	//스캔관리 등록/삭제 처리 페이지
	
	String seq = "";
	int result = 0;
	
	String auth_rw 		= request.getParameter("auth_rw")==null?"":request.getParameter("auth_rw");
	String user_id 		= request.getParameter("user_id")==null?"":request.getParameter("user_id");
	String br_id 		= request.getParameter("br_id")==null?"":request.getParameter("br_id");
	String rent_mng_id 	= request.getParameter("rent_mng_id")==null?"":request.getParameter("rent_mng_id");
	String rent_l_cd 	= request.getParameter("rent_l_cd")==null?"":request.getParameter("rent_l_cd");
	String remove_seq 	= request.getParameter("remove_seq")==null?"":request.getParameter("remove_seq");//삭제여부
	String gubun 	= request.getParameter("gubun")==null?"":request.getParameter("gubun");
	
//	System.out.println("updateClsEtcScanDelete gubun=" + gubun);
		
	result = ac_db.updateClsEtcScan(rent_mng_id, rent_l_cd, "", gubun);
	
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
  <input type="hidden" name="rent_mng_id" 			value="<%=rent_mng_id%>">
  <input type="hidden" name="rent_l_cd" 			value="<%=rent_l_cd%>">
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