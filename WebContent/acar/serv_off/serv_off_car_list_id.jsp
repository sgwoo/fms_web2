<%@ page contentType="text/html; charset=euc-kr" %>
<%@ page language="java" %> 
<%@ page import="java.util.*" %>
<%@ page import="acar.util.*" %>
<%@ page import="acar.serv_off.*" %>
<%@ include file="/acar/cookies.jsp" %>
<%
	String auth_rw = "";
	String off_id = "";
		
	if(request.getParameter("auth_rw") !=null) auth_rw = request.getParameter("auth_rw");
	if(request.getParameter("off_id") !=null) off_id = request.getParameter("off_id");
	
	

%>
<html>
<head>

<title>FMS</title>
<link rel="stylesheet" type="text/css" href="/include/table_t.css"></link>
<script language="JavaScript">
<!--
function CustServDel()
{
	var theForm = CustServList.document.CustServDelForm;
	if(!confirm("삭제하시겠습니까?"))
	{
		return;
	}
	theForm.target="i_no";
	theForm.submit();
}
function CarList()
{
	var SUBWIN="./serv_off_serv_car_i.jsp?auth_rw=<%=auth_rw%>&off_id=<%=off_id%>";	
	window.open(SUBWIN, "ServCarList", "left=100, top=100, width=550, height=400, scrollbars=no");
}
//-->
</script>
</head>
<body leftmargin="15">
<table border=0 cellspacing=0 cellpadding=0 width=820>
	<tr>
        <td align="right"><a href="javascript:CarList()">차량등록</a>&nbsp;|&nbsp;<a href="javascript:CustServDel()">삭제</a>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;</td>
    </tr>
    <tr>
		<td>
			<table border="0" cellspacing="0" cellpadding="0" width=820>
				<tr>
					<td class='line' width="801">
						 <table  border=0 cellspacing=1 width="801">
			        		<tr>
			            		<td width=51 class=title></td>
			            		<td width=100 class=title>차량번호</td>
			            		<td width=100 class=title>차명</td>
			            		<td width=100 class=title>등록일</td>
			            		<td width=250 class=title>상호</td>
			            		<td width=100 class=title>계약자</td>
			            		<td width=100 class=title>차량담당자</td>
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
					<td colspan=2><iframe src="./serv_off_car_list_id_in.jsp?auth_rw=<%=auth_rw%>&off_id=<%=off_id%>" name="CustServList" width="818" height="200" cellpadding="0" cellspacing="0" topmargin=0 marginwidth="0" border="0" frameborder="0"></iframe></td>
				</tr>							
	
			</table>
		</td>
	</tr>

</table>

<iframe src="about:blank" name="i_no" width="100" height="100" cellpadding="0" cellspacing="0" topmargin=0 marginwidth="0" border="0" frameborder="0"></iframe>

</body>
</html>