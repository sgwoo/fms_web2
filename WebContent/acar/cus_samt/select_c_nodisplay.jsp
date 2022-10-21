<%@ page language="java" contentType="text/html;charset=euc-kr"%>
<%@ page import="java.util.*, acar.util.*, acar.cus_samt.*"%>

<%@ include file="/acar/cookies.jsp" %>

<html>
<head>
<title>FMS</title>
</head>
<meta http-equiv="content-type" content="text/html; charset=euc-kr">
<link rel=stylesheet type="text/css" href="/include/table.css">
<body leftmargin="15">
<script language='JavaScript' src='/include/common.js'></script>
<script language='javascript'>
<%
	String auth_rw = request.getParameter("auth_rw")==null?"":request.getParameter("auth_rw");
	String user_id = request.getParameter("user_id")==null?"":request.getParameter("user_id");
	String br_id = request.getParameter("br_id")==null?"":request.getParameter("br_id");
	String gubun1 = request.getParameter("gubun1")==null?"4":request.getParameter("gubun1");
	String s_year = request.getParameter("s_year")==null?"":request.getParameter("s_year");
	String s_mon = request.getParameter("s_mon")==null?"":request.getParameter("s_mon");
	String st_dt = s_year + s_mon + "01";
	String end_dt = s_year + s_mon + "31";
	String s_kd = request.getParameter("s_kd")==null?"":request.getParameter("s_kd");
	String t_wd = request.getParameter("t_wd")==null?"":request.getParameter("t_wd");
	String sort = request.getParameter("sort")==null?"5":request.getParameter("sort");
	String asc = request.getParameter("asc")==null?"0":request.getParameter("asc");
	String acct = request.getParameter("acct")==null?"":request.getParameter("acct");
	
	String set_dt =  request.getParameter("set_dt")==null?"":request.getParameter("set_dt");

	CusSamt_Database cs_db = CusSamt_Database.getInstance();

    String jung_st =  cs_db.getAcctJung_st(acct, set_dt);  //정산회차구하기
			
%>
	t_fm = parent.form1;
		
	t_fm.jung_st.value 	= '<%=jung_st%>';
			
</script>
</body>
</html>
