<%@ page language="java" contentType="text/html;charset=euc-kr" %>
<%@ page import="java.io.*, java.util.*, acar.util.*, acar.forfeit_mng.*"%>
<%@ include file="/acar/cookies.jsp" %>

<%
	//스캔관리 등록/삭제 처리 페이지
	
	String seq = "";
	int result = 0;
	boolean flag1 = true;
	
	String auth_rw 		= request.getParameter("auth_rw")	==null?"":request.getParameter("auth_rw");
	String user_id 		= request.getParameter("user_id")	==null?"":request.getParameter("user_id");
	String br_id 		= request.getParameter("br_id")		==null?"":request.getParameter("br_id");
	String m_id 		= request.getParameter("m_id")		==null?"":request.getParameter("m_id");
	String l_cd 		= request.getParameter("l_cd")		==null?"":request.getParameter("l_cd");
	String c_id 		= request.getParameter("c_id")		==null?"":request.getParameter("c_id");
	String seq_no 		= request.getParameter("seq_no")	==null?"":request.getParameter("seq_no");
	String file_st 		= request.getParameter("file_st")	==null?"":request.getParameter("file_st");
	
	
	AddForfeitDatabase a_fdb = AddForfeitDatabase.getInstance();
	
	result = a_fdb.updateForfeitFileName(c_id, m_id, l_cd, AddUtil.parseInt(seq_no), "", "", file_st);
%>
<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=euc-kr">
<title></title>
</head>
<form name='form1' method='post'>
  <input type="hidden" name="auth_rw" 	value="<%=auth_rw%>">
  <input type="hidden" name="user_id" 	value="<%=user_id%>">
  <input type="hidden" name="br_id" 	value="<%=br_id%>">    
  <input type="hidden" name="m_id" 		value="<%=m_id%>">
  <input type='hidden' name='c_id' 		value='<%=c_id%>'>
  <input type='hidden' name='l_cd' 		value='<%=l_cd%>'>
  <input type="hidden" name="seq_no" 	value="<%=seq_no%>">
</form>
<script language='javascript'>
<%	if(result==1){%>		
		alert('해당 파일이 삭제되었습니다.');
<%	}else{	%>
		alert('데이터베이스 에러입니다.\n\n등록되지 않았습니다');		
<%	}	%>

	parent.location.reload();

</script>
<body>
</body>
</html>