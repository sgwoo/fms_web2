<%@ page contentType="text/html; charset=euc-kr" %>
<%@ page language="java" %> 
<%@ page import="java.util.*" %>
<%@ page import="acar.util.*" %>
<%@ page import="acar.serv_off.*" %>
<%@ page import="acar.car_service.*" %>
<%@ include file="/acar/cookies.jsp" %>

<%
	ServOffDatabase csd = ServOffDatabase.getInstance();
	
	String auth_rw = "";
	String off_id = "";
		
	if(request.getParameter("auth_rw") != null)	auth_rw = request.getParameter("auth_rw");
	if(request.getParameter("off_id") != null)	off_id = request.getParameter("off_id");
	
	ServiceBean sb_r [] = csd.getServiceAll(off_id);
	
%>
<html>
<head>

<title>FMS</title>
<link rel="stylesheet" type="text/css" href="/include/table_t.css"></link>
<script language="JavaScript">
<!--
function PersonRegister()
{
	alert("정상적으로 등록되었습니다.");
	location = "./enterprise_mng_s.html";

}
function PersonUpdate()
{
	alert("정상적으로 수정되었습니다.");
	location = "./enterprise_mng_s.html";

}
//-->
</script>
</head>
<body leftmargin="15">
<table border=0 cellspacing=0 cellpadding=0 width=820>
    <tr>
		<td>
			<table border="0" cellspacing="0" cellpadding="0" width=820>
				<tr>
					<td class='line' width="801">
						 <table  border=0 cellspacing=1 width="801">
			        		<tr>
			            		<td width=100 class=title>정비일자</td>
			            		<td width=200 class=title>점검품목</td>
			            		<td width=300 class=title>점검내용</td>
			            		<td width=100 class=title>정비비</td>
			            		<td width=100 class=title>지급일자</td>
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
					<td colspan=2><iframe src="./serv_off_serv_list_sd_in.jsp?auth_rw=<%=auth_rw%>&off_id=<%=off_id%>" name="ServiceList" width="818" height="200" cellpadding="0" cellspacing="0" topmargin=0 marginwidth="0" border="0" frameborder="0" scrolling="yes"></iframe></td>
				</tr>							
	
			</table>
		</td>
	</tr>

</table>

</body>
</html>