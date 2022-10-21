<%@ page contentType="text/html; charset=euc-kr" %>
<%@ page language="java" %> 
<%@ page import="java.util.*" %>
<%@ page import="acar.util.*" %>
<%@ page import="acar.serv_off.*" %>
<%@ include file="/acar/cookies.jsp" %>
<%
	String auth_rw = "";
	String gubun_nm = "";
	
	if(request.getParameter("auth_rw") !=null) auth_rw = request.getParameter("auth_rw");
	if(request.getParameter("gubun_nm") !=null) gubun_nm = request.getParameter("gubun_nm");
	
%>
<html>
<head>
<meta http-equiv="content-type" content="text/html; charset=euc-kr">
<title>FMS</title>
<link rel="stylesheet" type="text/css" href="/include/table_t.css"></link><script language="JavaScript">
<!--
function ServOffAdd()
{
	var theForm = document.ServOffRegMoveForm;
	theForm.target="d_content";
	theForm.submit();
}
//-->
</script>
</head>
<body>


<table border=0 cellspacing=0 cellpadding=0 width=820>
<%
	if(auth_rw.equals("3") || auth_rw.equals("4") || auth_rw.equals("6"))
	{
%>	
	<tr>
        <td align="right">
        <a href="javascript:ServOffAdd()" onMouseOver="window.status=''; return true">정비업소등록</a>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;
        </td>
    </tr>
<%
	}
%>
    <tr>
		<td>
			<table border="0" cellspacing="0" cellpadding="0" width=820>
				<tr>
					<td class='line' width="801">
						 <table  border=0 cellspacing=1 width="801">
			        		<tr>
			            		<td width=100 class=title>정비업소명</td>
			            		
                <td width=100 class=title>등급</td>
			            		<td width=100 class=title>대표자</td>
			            		<td width=100 class=title>주소</td>
			            		<td width=100 class=title>사무실전화</td>
			            		<td width=100 class=title>팩스</td>
			            		
                <td width=100 class=title>업종</td>
			            		<td width=100 class=title>비고</td>
			            	</tr>
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
					<td colspan=2><iframe src="./serv_off_sc_in.jsp?auth_rw=<%=auth_rw%>&gubun_nm=<%=gubun_nm%>" name="ServOffList" width="818" height="450" cellpadding="0" cellspacing="0" topmargin=0 marginwidth="0" border="0" frameborder="0"></iframe></td>
				</tr>							
	
			</table>
		</td>
	</tr>

</table>
<form action="./serv_off_i_frame.jsp" name="ServOffRegMoveForm" method="post">
</form>
</body>
</html>