<%@ page language="java" contentType="text/html; charset=euc-kr" %>
<%@ page import="java.util.*, acar.util.*, acar.off_anc.*" %>
<jsp:useBean id="bc_bean" class="acar.off_anc.BulCommentBean" scope="page"/>
<%@ include file="/acar/cookies.jsp" %>

<%
	//게시판 댓글 등록 페이지
	
	String auth_rw 	= request.getParameter("auth_rw")==null?"":request.getParameter("auth_rw");
	int b_id 		= request.getParameter("b_id")==null?0:Util.parseInt(request.getParameter("b_id"));
	
//	String acar_id 	= request.getParameter("acar_id")==null?"":request.getParameter("acar_id");
//	String acar_id 	= request.getParameter("user_id")==null?"":request.getParameter("user_id");
	String comment 	= request.getParameter("comment")==null?"":request.getParameter("comment");
	int count = 0;
	LoginBean login = LoginBean.getInstance();
	String acar_id = login.getCookieValue(request, "acar_id");
	
	OffBulDatabase oad = OffBulDatabase.getInstance();
	bc_bean.setB_id(b_id);
	bc_bean.setReg_id(acar_id);
	bc_bean.setContent(comment);
	count = oad.insertBulComment(bc_bean);
%>
<html>
<head><title>FMS</title>
<link rel=stylesheet type="text/css" href="/include/table_t.css">
</head>
<body>
<form name='form1' action='' method="POST">
  <input type="hidden" name="auth_rw" value="<%=auth_rw%>">  
  <input type="hidden" name="b_id" value="<%=b_id%>">
</form>
<script language="JavaScript">
<!--
	var fm = document.form1;
<%	if(count==1){%>
	alert("정상적으로 등록되었습니다.");
	fm.action='./bul_c.jsp?b_id=<%=b_id%>';
	fm.target='d_content';
	fm.submit();					
<%	}else{%>
	alert("등록 오류입니다.");
<%	}%>
//-->
</script>
</body>
</html>
