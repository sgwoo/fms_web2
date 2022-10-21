<%@ page contentType="text/html; charset=euc-kr" %>
<%@ page language="java" %> 
<%@ include file="/acar/cookies.jsp" %>
<%
	String auth_rw = request.getParameter("auth_rw")==null?"":request.getParameter("auth_rw");
	String s_kd = request.getParameter("s_kd")==null?"":request.getParameter("s_kd");
	String t_wd = request.getParameter("t_wd")==null?"":request.getParameter("t_wd");
	String sort_gubun = request.getParameter("sort_gubun")==null?"":request.getParameter("sort_gubun");
	String sort = request.getParameter("sort")==null?"":request.getParameter("sort");
	String off_id = request.getParameter("off_id")==null?"":request.getParameter("off_id");
	String gubun1 = request.getParameter("gubun1")==null?"":request.getParameter("gubun1");	
	String gubun2 = request.getParameter("gubun2")==null?"":request.getParameter("gubun2");	
	String cpt_cd = request.getParameter("cpt_cd")==null?"":request.getParameter("cpt_cd");
%>
<html>
<head>
<meta http-equiv="content-type" content="text/html; charset=euc-kr">
<title>FMS</title>
<link rel="stylesheet" type="text/css" href="/include/table_t.css"></link>
<link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/4.7.0/css/font-awesome.min.css">
<script language="JavaScript">
<!--
function go_to_list()
{
	var fm = document.form1;
	<%if(gubun1.equals("0001")){%>
	fm.action = "serv_emp_bank_frame.jsp?gubun1=<%=gubun1%>&gubun2=<%=gubun2%>";
	<%}else{%>
	fm.action = "serv_emp_frame.jsp?gubun1=<%=gubun1%>&gubun2=<%=gubun2%>";
	<%}%>
	fm.target = 'd_content';
	fm.submit();
}
//-->
</script>
</head>
<body>

<form name="form1" method="post" target="d_content">
<input type="hidden" name="auth_rw" value="<%=auth_rw%>"> 
<input type="hidden" name="s_kd" value="<%=s_kd%>">
<input type="hidden" name="t_wd" value="<%=t_wd%>">
<input type="hidden" name="sort_gubun" value="<%=sort_gubun%>">
<input type="hidden" name="sort" value="<%=sort%>">
<input type="hidden" name="off_id" value="<%=off_id%>">
<div class="navigation">
	<span class=style1>업체정보관리 ></span><span class=style5>업체명함관리</span>
</div>
<table border=0 cellspacing=0 cellpadding=0 width=100%>

    <tr>
        <td class=h></td>
    </tr>
    <tr>
        <td align=right>
		<!--<a href='javascript:go_to_list()' onMouseOver="window.status=''; return true" class="ml-btn-4" style="text-decoration: none;">목록</a>&nbsp;&nbsp;&nbsp;&nbsp;-->
		<input type="button" class="button" value="목록" onclick="go_to_list()"/>
		</td>
    </tr>
</form>
</table>
</body>
</html>