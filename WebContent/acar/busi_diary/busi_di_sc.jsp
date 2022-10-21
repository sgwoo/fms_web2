<%@ page language="java" contentType="text/html; charset=euc-kr" %>
<%@ page import="java.util.*, acar.util.*" %>
<%@ include file="/acar/cookies.jsp" %>

<html>
<head>
<meta http-equiv="content-type" content="text/html; charset=euc-kr">
<title>FMS</title>
<link rel="stylesheet" type="text/css" href="/include/table_t.css">
<script language="JavaScript" src="/include/common.js"></script>
<script language="JavaScript">
<!--
	function view_content(user_id, seq){
		var fm = document.form1;
		fm.s_user_id.value = user_id;
		fm.target = "c_cont";
		fm.action = "busi_di_cont.jsp?seq="+seq;
		fm.submit();				
	}
//-->
</script>
</head>
<body>
<%
	String auth_rw = request.getParameter("auth_rw")==null?"":request.getParameter("auth_rw");
	String user_id = request.getParameter("user_id")==null?"":request.getParameter("user_id");
	String br_id = request.getParameter("br_id")==null?"":request.getParameter("br_id");
	String s_brch_id = request.getParameter("s_brch_id")==null?"":request.getParameter("s_brch_id");
	String s_dept_id = request.getParameter("s_dept_id")==null?"":request.getParameter("s_dept_id");
	String s_user_id = request.getParameter("s_user_id")==null?"":request.getParameter("s_user_id");
	String s_year = request.getParameter("s_year")==null?"":request.getParameter("s_year");
	String s_month = request.getParameter("s_month")==null?"":request.getParameter("s_month");
	String s_day = request.getParameter("s_day")==null?"":request.getParameter("s_day");
%>
<form action="busi_di_sc.jsp" name="form1" method="POST">
  <input type="hidden" name="auth_rw" value="<%=auth_rw%>">
  <input type="hidden" name="br_id" value="<%=br_id%>">  
  <input type="hidden" name="user_id" value="<%=user_id%>"> 
  <input type="hidden" name="s_brch_id" value="<%=s_brch_id%>">
  <input type="hidden" name="s_dept_id" value="<%=s_dept_id%>">  
  <input type="hidden" name="s_user_id" value="<%=s_user_id%>">    
  <input type="hidden" name="s_year" value="<%=s_year%>">
  <input type="hidden" name="s_month" value="<%=s_month%>">  
  <input type="hidden" name="s_day" value="<%=s_day%>">     
<table border=0 cellspacing=0 cellpadding=0 width=100%>
    <tr>
        <td class=line2></td>
    </tr>
    <tr>
        <td>
            <table width=100% border=0 cellpadding=0 cellspacing=0>
                <tr>                 
                    <td class=line>
                        <table border=0 cellspacing=1 cellpadding=0 width=100%>
                            <tr> 
                                <td class='title' width='5%'>연번</td>
                                <td class='title' width='10%'>부서</td>
                                <td class='title' width='10%'>성명</td>
                                <td class='title' width='10%'>업무일자</td>
                                <td class='title' width="65%">제목</td>
                            </tr>
                        </table>
                    </td>
                </tr>
            </table>
        </td>
        <td width="16">&nbsp;</td>
    <tr> 
        <td colspan="2"><iframe src="./busi_di_sc_in.jsp?auth_rw=<%=auth_rw%>&user_id=<%=user_id%>&br_id=<%=br_id%>&s_brch_id=<%=s_brch_id%>&s_dept_id=<%=s_dept_id%>&s_user_id=<%=s_user_id%>&s_year=<%=s_year%>&s_month=<%=s_month%>&s_day=<%=s_day%>" name="i_in" width="100%" height="200" cellpadding="0" cellspacing="0" topmargin=0 marginwidth="0" border="0" frameborder="0"></iframe></td>
    </tr>
</table>
</form>
</body>
</html>