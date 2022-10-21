<%@ page contentType="text/html; charset=euc-kr" %>
<%@ page language="java" %> 
<%@ include file="/acar/cookies.jsp" %>

<%
	String user_id = request.getParameter("user_id")==null?"":request.getParameter("user_id");
	String user_pos = request.getParameter("user_pos")==null?"":request.getParameter("user_pos");
%>
<html>
<head>
<meta http-equiv="content-type" content="text/html; charset=euc-kr">
<title>FMS</title>
<link rel="stylesheet" type="text/css" href="/include/table_t.css">
<script language="JavaScript">
<!--
function SearchBbs()
{
	var theForm = document.BbsSearchForm;
	theForm.target = "c_foot";
	theForm.submit();
}
//-->
</script>
</head>
<body>
<table border=0 cellspacing=0 cellpadding=0 width=100%>
	<form action="./anc_s_sc.jsp" name="BbsSearchForm" method="POST" target="c_foot">
    <tr>		
      <td align="right"> 
        <font color="navy">
		  <a href="memo_f_i.jsp?user_id=<%=user_id%>&user_pos=<%=user_pos%>" target="c_body"><img src=../images/center/button_memo_w.gif align=absmiddle border=0></a>
		  <a href="memo_t_sc.jsp?user_id=<%=user_id%>&user_pos=<%=user_pos%>" target="c_body"><img src=../images/center/button_memo_r.gif align=absmiddle border=0></a>
		  <a href="memo_f_sc.jsp?user_id=<%=user_id%>&user_pos=<%=user_pos%>" target="c_body"><img src=../images/center/button_memo_s.gif align=absmiddle border=0></a></font>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;
        </td>
	</tr>
</form>
</table>
</body>
</html>