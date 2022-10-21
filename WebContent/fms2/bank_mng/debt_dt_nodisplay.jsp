<%@ page language="java" contentType="text/html;charset=euc-kr" %>
<%@ page import="java.util.*, acar.util.*, acar.common.*"%>
<%@ include file="/acar/cookies.jsp" %>

<html>
<head>
<title>FMS</title>
</head>
<body>
<script language='javascript'>
<%
	String alt_start_dt =  request.getParameter("alt_start_dt")==null?"":request.getParameter("alt_start_dt");
	int tot_alt_tm =  request.getParameter("tot_alt_tm")==null?0:Integer.parseInt(request.getParameter("tot_alt_tm"));
	String alt_end_dt="";
	
	// 상환기간(상환종료일 = 상환시작일+할부횟수-1일)
	CommonDataBase c_db = CommonDataBase.getInstance();
	alt_end_dt = c_db.addMonth(alt_start_dt, tot_alt_tm-1);

%>
	t_fm = parent.document.form1;
	t_fm.alt_end_dt.value	= '<%=alt_end_dt%>';
</script>
</body>
</html>
