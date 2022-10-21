<%@ page language="java" contentType="text/html; charset=euc-kr" %>
<%@ page import="java.util.*, acar.util.*" %>
<%@ include file="/acar/cookies.jsp" %>
<%
	String auth_rw = request.getParameter("auth_rw")==null?"":request.getParameter("auth_rw");
	String user_id = request.getParameter("user_id")==null?"":request.getParameter("user_id");
	String br_id = request.getParameter("br_id")==null?"":request.getParameter("br_id");
	String s_brch_id = request.getParameter("s_brch_id")==null?br_id:request.getParameter("s_brch_id");
	String s_dept_id = request.getParameter("s_dept_id")==null?"":request.getParameter("s_dept_id");
	String s_user_id = request.getParameter("s_user_id")==null?"":request.getParameter("s_user_id");
	String s_year = request.getParameter("s_year")==null?"":request.getParameter("s_year");
	String s_month = request.getParameter("s_month")==null?"":request.getParameter("s_month");
	String s_day = request.getParameter("s_day")==null?"":request.getParameter("s_day");
	String seq = request.getParameter("seq")==null?"":request.getParameter("seq");	
%>
<html>
<head>
<meta http-equiv="content-type" content="text/html; charset=euc-kr">
<title>FMS</title>
<link rel="stylesheet" type="text/css" href="/include/table_t.css">
<script language="JavaScript" src="/include/common.js"></script>
</head>
<body topmargin=0>
  <table border=0 cellspacing=0 cellpadding=0 width=100%>
    <tr> 
      <td><iframe src="./busi_di_cont_in.jsp?auth_rw=<%=auth_rw%>&user_id=<%=user_id%>&br_id=<%=br_id%>&s_brch_id=<%=s_brch_id%>&s_dept_id=<%=s_dept_id%>&s_user_id=<%=s_user_id%>&s_year=<%=s_year%>&s_month=<%=s_month%>&s_day=<%=s_day%>&seq=<%= seq %>" name="i_in" width="100%" height="400" cellpadding="0" cellspacing="0" topmargin=0 marginwidth="0" border="0" frameborder="0"></iframe></td>
    </tr>
  </table>
</body>
</html>