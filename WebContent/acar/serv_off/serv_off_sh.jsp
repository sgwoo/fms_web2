<%@ page contentType="text/html; charset=euc-kr" %>
<%@ page language="java" %> 
<%@ page import="java.util.*" %>
<%@ page import="acar.util.*" %>
<%@ page import="acar.serv_off.*" %>
<%@ include file="/acar/cookies.jsp" %>
<%
	String auth_rw = "";
	
	if(request.getParameter("auth_rw") !=null) auth_rw = request.getParameter("auth_rw");

%>
<html>
<head>
<meta http-equiv="content-type" content="text/html; charset=euc-kr">
<title>FMS</title>
<link rel="stylesheet" type="text/css" href="/include/table_t.css"></link>
<script language="JavaScript">
<!--
function SearchServOff()
{
	var theForm = document.ServOffSearchForm;
	theForm.target = "c_foot";
	theForm.submit();
}

function DispatchSearch()
{
	var theForm = document.DispatchSearchFrom;
	theForm.submit();
}
function ContractContent(id)
{
	var theForm = document.ContractContentFrom;
	theForm.h_cont_id.value = id;
	theForm.submit();
}
function CompanyAdd()
{
	
	var SUBWIN="./car_company_i.html";	
	window.open(SUBWIN, "CompanyList", "left=100, top=100, width=300, height=300, scrollbars=yes");
}
function OfficeAdd()
{
	
	var SUBWIN="./car_office_i.html";	
	window.open(SUBWIN, "OfficeList", "left=100, top=100, width=350, height=330, scrollbars=yes");
}
function OpenMemo()
{
	var SUBWIN="./office_memo_i.html";	
	window.open(SUBWIN, "Memo", "left=100, top=100, width=580, height=400, scrollbars=yes");
}
function Alert()
{
}
//-->
</script>
</head>
<body>


<table border=0 cellspacing=0 cellpadding=0 width=100%>
	<tr>
    	<td ><font color="navy">고객지원 -> </font><font color="red">자동차 정비 거래처 관리</font></td>
    </tr>
	<form action="./serv_off_sc.jsp" name="ServOffSearchForm" method="POST" target="c_foot">
    <tr>
        <td>
            <table border=0 cellspacing=1>
            	<tr>
            		<td>정비업소 : </td>
            		
            		<td><input type="text" name="gubun_nm" size="10" value="" class=text></td>
					<td><a href="javascript:SearchServOff()">검색</a></td>
            	</tr>
            </table>
            <input type="hidden" name="auth_rw" value="<%=auth_rw%>">
        </td>
    </tr>
	</form>
</table>
</body>
</html>