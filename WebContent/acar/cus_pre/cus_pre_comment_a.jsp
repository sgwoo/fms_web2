<%@ page language="java" contentType="text/html; charset=euc-kr" %>
<%@ page import="java.util.*, acar.util.*, acar.cus_pre.*" %>

<%@ include file="/acar/cookies.jsp" %>

<%
	//공지사항 댓글 등록 페이지
		
	String auth_rw 	= request.getParameter("auth_rw")==null?"":request.getParameter("auth_rw");
	String car_mng_id	= request.getParameter("car_mng_id")==null?"":request.getParameter("car_mng_id");
	String car_no = request.getParameter("car_no")==null?"":request.getParameter("car_no");
	String comment 	= request.getParameter("comment")==null?"":request.getParameter("comment");
	String user_id	= request.getParameter("user_id")==null?ck_acar_id:request.getParameter("user_id");
	String rent_mng_id = request.getParameter("rent_mng_id")==null?"":request.getParameter("rent_mng_id");
	String rent_l_cd = request.getParameter("rent_l_cd")==null?"":request.getParameter("rent_l_cd");
		
	int count = 0;
			
	CusPre_Database cp_db = CusPre_Database.getInstance();
	count = cp_db.insertCusPreComment(car_mng_id ,user_id,  comment, rent_mng_id, rent_l_cd);
%>

<html>
<head><title>FMS</title>
<link rel=stylesheet type="text/css" href="/include/table_t.css">
</head>
<body>
<form name='form1' action='' method="POST">
	<input type="hidden" name="auth_rw" value="<%=auth_rw%>">  
	<input type="hidden" name="c_id" value="<%=car_mng_id%>">
	<input type="hidden" name="user_id" value="<%=user_id%>">
	<input type="hidden" name="m_id" value="<%=rent_mng_id%>">
	<input type="hidden" name="car_no" value="<%=car_no%>">
  	<input type="hidden" name="l_cd" value="<%=rent_l_cd%>">
</form>

<script language="JavaScript">
<!--
	var fm = document.form1;
<%	if(count==1){%>
	alert("정상적으로 등록되었습니다.");	
//	top.window.close();
	fm.action='./cus_pre_c.jsp';
	fm.target='AncDisp';
	fm.submit();					
<%	}else{%>
	alert("등록 오류입니다.");
<%	}%>
//-->
</script>
</body>
</html>
