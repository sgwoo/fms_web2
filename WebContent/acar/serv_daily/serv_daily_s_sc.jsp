<%@ page contentType="text/html; charset=euc-kr" %>
<%@ page language="java" %> 
<%@ page import="java.util.*" %>
<%@ page import="acar.util.*" %>
<%@ page import="acar.serv_daily.*" %>
<%@ include file="/acar/cookies.jsp" %>
<%
	String auth_rw = "";
	String gubun_nm = "";
	String gubun = "";
	String ref_dt1 = "";
	String ref_dt2 = "";
	
	if(request.getParameter("auth_rw") !=null) auth_rw = request.getParameter("auth_rw");
	if(request.getParameter("gubun_nm") !=null) gubun_nm = request.getParameter("gubun_nm");
	if(request.getParameter("gubun") !=null) gubun = request.getParameter("gubun");
	if(request.getParameter("ref_dt1") !=null) ref_dt1 = request.getParameter("ref_dt1");
	if(request.getParameter("ref_dt2") !=null) ref_dt2 = request.getParameter("ref_dt2");
%>
<html>
<head>
<meta http-equiv="content-type" content="text/html; charset=euc-kr">
<title>FMS</title>
<link rel="stylesheet" type="text/css" href="/include/table_t.css"></link><script language="JavaScript">
<!--
function AccidAdd()
{
	var theForm = document.AccidRegMoveForm;
	theForm.target="d_content";
	theForm.submit();
}
//-->
</script>
</head>
<body>


<table border=0 cellspacing=0 cellpadding=0 width=820>

    <tr>
		<td>
			<table border="0" cellspacing="0" cellpadding="0" width=820>
				<tr>
					<td class='line' width="800">
						 <table  border=0 cellspacing=1 width="801">
						 	<td class=title width=50>번호</td>
						 	<td class=title width=90>차량번호</td>
		            		<td class=title width=80>등록일</td>
		            		<td class=title width=98>차종</td>
		            		<td class=title width=108>상호</td>
		            		<td class=title width=70>계약자</td>
		            		<td class=title width=50>3월</td>
		            		<td class=title width=50>4월</td>
		            		<td class=title width=50>5월</td>
		            		<td class=title width=50>6월</td>
		            		<td class=title width=50>7월</td>
		            		<td class=title width=50>8월</td>
			            </table>
					</td>
					<td width=19>&nbsp;
					</td>
				</tr>
			</table>
		</td>
	</tr>
    <tr>
		<td>
			 <table border="0" cellspacing="1" cellpadding="0" width=820>
				<tr>
					<td colspan=2><iframe src="./serv_daily_s_sc_in.jsp?auth_rw=<%=auth_rw%>&gubun_nm=<%=gubun_nm%>&gubun=<%=gubun%>&ref_dt1=<%=ref_dt1%>&ref_dt2=<%=ref_dt2%>" name="MaintList" width="818" height="463" cellpadding="0" cellspacing="0" topmargin=0 marginwidth="0" border="0" frameborder="0"></iframe></td>
				</tr>							
	
			</table>
		</td>
	</tr>

</table>
</body>
</html>