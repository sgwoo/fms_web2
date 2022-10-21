<%@ page language="java" contentType="text/html;charset=euc-kr" %>
<jsp:useBean id="olcD" class="acar.offls_cmplt.Offls_cmpltDatabase" scope="page"/>
<%@ include file="/acar/cookies.jsp" %>
<%
	String auth_rw = request.getParameter("auth_rw")==null?"":request.getParameter("auth_rw");
	String s_au = request.getParameter("s_au")==null?"":request.getParameter("s_au");
	System.out.println("s_au="+s_au);
	String[] cmplt = request.getParameterValues("pr");
	
	for(int i=0; i<cmplt.length; i++){
		cmplt[i] = cmplt[i].substring(0,6);
	}
	
	int result = olcD.setOffls_cmplt(cmplt);
%>
<html>
<head><title>FMS</title>
<link rel=stylesheet type="text/css" href="/include/table.css">
</head>
<body>
<script language="JavaScript">
<!--
<%	if(result >= 1){%>
	alert("등록되었습니다.\n자동차 처분현황 화면에서 확인 하시기 바랍니다.");
	window.top.frames["d_content"].location = "/acar/off_ls_jh/off_ls_jh_frame.jsp?auth_rw=<%=auth_rw%>";
//	parent.parent.location.href = "/acar/off_ls_jh/off_ls_jh_frame.jsp?auth_rw=<%=auth_rw%>";
<%}else{%>
	alert("데이터베이스에 문제가 발생하였습니다.\n 관리자님께 문의하세요 !");
	window.top.frames["d_content"].location = "/acar/off_ls_jh/off_ls_jh_frame.jsp?auth_rw=<%=auth_rw%>";
//	parent.parent.location.href = "/acar/off_ls_jh/off_ls_jh_frame.jsp?auth_rw=<%=auth_rw%>";
<%}%>
//-->
</script>
</body>
</html>
