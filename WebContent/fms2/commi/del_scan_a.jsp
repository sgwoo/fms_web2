<%@ page language="java" contentType="text/html;charset=euc-kr" %>
<%@ page import="java.io.*, java.util.*, acar.util.*, acar.car_office.*"%>
<%@ include file="/acar/cookies.jsp" %>

<%
	//스캔관리 등록/삭제 처리 페이지
	
	String seq = "";
	boolean flag1 = true;
	
	String auth_rw 		= request.getParameter("auth_rw")==null?"":request.getParameter("auth_rw");
	String user_id 		= request.getParameter("user_id")==null?"":request.getParameter("user_id");
	String br_id 		= request.getParameter("br_id")==null?"":request.getParameter("br_id");
	String emp_id	 	= request.getParameter("emp_id")==null?"":request.getParameter("emp_id");
	String file_st 		= request.getParameter("file_st")==null?"":request.getParameter("file_st");
	String remove_seq 	= request.getParameter("remove_seq")==null?"":request.getParameter("remove_seq");//삭제여부
	
	
	//1. 영업수당정보 commi-------------------------------------------------------------------------------------------
	
	//commi
	CommiBean emp1 	= a_db.getCommi(rent_mng_id, rent_l_cd, "1");
	if(file_st.equals("1")){
		emp1.setFile_name1("");
	}else{
		emp1.setFile_name2("");
	}
	//=====[commi] update=====
	flag1 = a_db.updateCommiNew(emp1);
	out.println("영업수당정보 수정<br>");
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
  <input type="hidden" name="emp_id" 			value="<%=emp_id%>">
</form>
<script language='javascript'>
<%	if(flag1){	%>		
		alert('해당 파일이 삭제되었습니다.');
<%	}else{	%>
		alert('데이터베이스 에러입니다.\n\n등록되지 않았습니다');		
<%	}	%>

//	parent.location.reload();

</script>
<body>
</body>
</html>