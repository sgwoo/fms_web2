<%@ page language="java" contentType="text/html;charset=euc-kr" %>
<%@ page import="java.util.*, acar.util.*, tax.*"%>
<%@ page import="acar.accid.*, acar.car_service.*, acar.user_mng.*, acar.ext.*"%>
<%@ include file="/acar/cookies.jsp" %>


<html>
<head><title>FMS</title></head>
<body>

<%
	String auth_rw = request.getParameter("auth_rw")==null?"":request.getParameter("auth_rw");//권한
	String user_id = request.getParameter("user_id")==null?"":request.getParameter("user_id");//사용자 관리번호
	String br_id = request.getParameter("br_id")==null?"":request.getParameter("br_id");//사용자 소속영업소
	
	String c_id = request.getParameter("c_id")==null?"":request.getParameter("c_id");//자동차관리번호
	String accid_id = request.getParameter("accid_id")==null?"":request.getParameter("accid_id");//사고관리번호
	String seq = request.getParameter("seq")==null?"0":request.getParameter("seq");
	
	
	AccidDatabase as_db = AccidDatabase.getInstance();
	
	boolean flag = true;
	

	
	flag = as_db.updateIns_req_st(c_id, accid_id, seq);
	

%>
<form name='form1' action='' method="POST">
<input type='hidden' name='auth_rw' value='<%=auth_rw%>'>
<input type='hidden' name='accid_id' value='<%=accid_id%>'>
<input type='hidden' name='seq' value='<%=seq%>'>
<input type='hidden' name='c_id' value='<%=c_id%>'>
</form>

<script language='javascript'>
<%	if(!flag){%>
		alert('오류발생!');
		location='about:blank';
<%	}else{%>
		alert('변경되었습니다');
		document.form1..close();
<%	}%>
</script>
</body>
</html>
