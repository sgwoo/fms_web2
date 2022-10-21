<%@ page language="java" contentType="text/html;charset=euc-kr" %>
<%@ page import="java.util.*, acar.util.*, acar.end_cont.*, acar.user_mng.*"%>

<jsp:useBean id="u_bean" class="acar.user_mng.UsersBean" scope="page" />
<%@ include file="/acar/cookies.jsp" %>
<%
	End_ContDatabase ec_db = End_ContDatabase.getInstance();

	String auth_rw = request.getParameter("auth_rw")==null?"":request.getParameter("auth_rw");
	String user_id = request.getParameter("user_id")==null?"":request.getParameter("user_id");
	String br_id = request.getParameter("br_id")==null?"":request.getParameter("br_id");
	String s_cd = request.getParameter("s_cd")==null?"":request.getParameter("s_cd");
	
	String rent_mng_id = request.getParameter("rent_mng_id")==null?"":request.getParameter("rent_mng_id");
	String rent_l_cd = request.getParameter("rent_l_cd")==null?"":request.getParameter("rent_l_cd");
	String re_bus_id = request.getParameter("re_bus_id")==null?"":request.getParameter("re_bus_id");
	String content = request.getParameter("content")==null?"":request.getParameter("content");
	String cmd = request.getParameter("cmd")==null?"":request.getParameter("cmd");
	int count = 0;
	
	
	UserMngDatabase umd = UserMngDatabase.getInstance();
	u_bean = umd.getUsersBean(user_id);

    int cnt = ec_db.getCntEnd_Cont(rent_mng_id, rent_l_cd);
	
	if(cnt < 1){
		count = ec_db.insertEnd_Cont(rent_mng_id, rent_l_cd, user_id, re_bus_id, content);
	}else {
		count = ec_db.updateEnd_Cont(rent_mng_id, rent_l_cd, user_id, re_bus_id, content);	
	}
%>

<html>
<head>
<title>FMS</title>
<link rel=stylesheet type="text/css" href="/include/table_t.css">
<script language='JavaScript' src='../../include/common.js'></script>
</head>
<body leftmargin="15">
<script language='javascript'>
<%	
	if(count == 1){%>
		alert('정상적으로 등록되었습니다');
		parent.window.close();
		parent.opener.location.reload();
<%	}else{ //에러%>
		alert('처리되지 않았습니다\n\n에러발생!');
<%	}%>
</script>
</body>
</html>
