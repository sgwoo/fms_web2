<%@ page contentType="text/html; charset=euc-kr" %>
<%@ page language="java" %> 
<%@ page import="java.util.*" %>
<%@ page import="acar.util.*" %>
<%@ page import="acar.serv_off.*" %>
<%@ include file="/acar/cookies.jsp" %>
<%
	String auth_rw = "";
	String off_id = "";
	String gubun = "";
	String gubun_nm = "";
		
	if(request.getParameter("auth_rw") !=null) auth_rw = request.getParameter("auth_rw");
	if(request.getParameter("off_id") !=null) off_id = request.getParameter("off_id");
%>
<html>
<head>

<title>FMS</title>
<link rel="stylesheet" type="text/css" href="/include/table_t.css"></link>
<script language="JavaScript">
<!--
function EnterDown() 
{
	var keyValue = event.keyCode;
	if (keyValue =='13') SearchCar();
}
function CustServReg()
{
	var theForm = CustServList.document.CustServRegForm;
	theForm.target="i_no";
	theForm.submit();
}
function WinClose()
{
	opener.CustServList.CarListLoad();
	self.close();
	window.close();
}
function SearchCar()
{
	var theForm = document.CarSearchForm;
	theForm.target="CustServList";
	theForm.submit();
}
//-->
</script>
</head>
<body leftmargin="15" onLoad="self.focus()">
<table border=0 cellspacing=0 cellpadding=0 width=520>
	<form action="./serv_off_serv_car_i_in.jsp" name="CarSearchForm" method="post">
	<tr>
		<td align="left">
			<select name="gubun">
				<option value="car_no">차량번호</option>
				<option value="firm_nm">상호</option>
				<option value="client_nm">고객멍</option>
			</select>
			<input type="text" name="gubun_nm" value="" class=text onKeydown="javasript:EnterDown()">
			<input type="hidden" name="off_id" value="<%=off_id%>">
				<input type="hidden" name="auth_rw" value="<%=auth_rw%>">
			<a href="javascript:SearchCar()">검색</a>
		</td>
        <td align="right"><a href="javascript:CustServReg()">차량등록</a>&nbsp;|&nbsp;<a href="javascript:WinClose()">닫기</a>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;</td>
    </tr>
    </form>
    <tr>
		<td colspan=2>
			<table border="0" cellspacing="0" cellpadding="0" width=520>
				<tr>
					<td class='line' width="501">
						 <table  border=0 cellspacing=1 width="501">
			        		<tr>
			            		<td width=41 class=title></td>
			            		<td width=110 class=title>차량번호</td>
			            		<td width=200 class=title>상호</td>
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
		<td colspan=2>
			 <table border="0" cellspacing="1" cellpadding="0" width=520>
				<tr>
					<td colspan=2><iframe src="./serv_off_serv_car_i_in.jsp?auth_rw=<%=auth_rw%>&off_id=<%=off_id%>&gubun=<%=gubun%>&gubun_nm=<%=gubun_nm%>" name="CustServList" width="518" height="323" cellpadding="0" cellspacing="0" topmargin=0 marginwidth="0" border="0" frameborder="0"></iframe></td>
				</tr>							
	
			</table>
		</td>
	</tr>
</table>
<iframe src="about:blank" name="i_no" width="100" height="100" cellpadding="0" cellspacing="0" topmargin=0 marginwidth="0" border="0" frameborder="0"></iframe>

</body>
</html>