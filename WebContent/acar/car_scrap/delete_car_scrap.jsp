<%@ page language="java" contentType="text/html; charset=euc-kr" %>
<%@ page import="java.util.*, acar.util.*, acar.car_scrap.*"%>
<jsp:useBean id="sc_db" scope="page" class="acar.car_scrap.ScrapDatabase"/>
<%@ include file="/acar/cookies.jsp" %>

<%
	String auth_rw = request.getParameter("auth_rw")==null?"":request.getParameter("auth_rw");
	String s_kd = request.getParameter("s_kd")==null?"":request.getParameter("s_kd");
	String t_wd = request.getParameter("t_wd")==null?"":request.getParameter("t_wd");
	String gubun = request.getParameter("gubun")==null?"서울":request.getParameter("gubun");
	String cmd = request.getParameter("cmd")==null?"":request.getParameter("cmd");
	
	String seq[] 	= request.getParameterValues("ch_cd");
	int cnt = 0;
	int result = 0;
	boolean flag = false;
	
	for(int i=0;i < seq.length;i++){
		result = sc_db.car_scrap_d(seq[i]);
		if(result == 1){	cnt++;		}
	}
	if(cnt == seq.length){		flag = true;	}
%>

<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN">
<html>
<head>
<title>FMS</title>
<meta http-equiv="Content-Type" content="text/html; charset=euc-kr">
</head>

<body>
<script language="JavaScript">
<!--
var flag = '<%=flag%>';
if(flag=='true'){
		alert("삭제되었습니다.");
		parent.location.reload();
}else{
	alert("삭제 중 오류발생!");
}
//-->
</script>
</body>
</html>