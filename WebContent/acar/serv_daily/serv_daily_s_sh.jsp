<%@ page contentType="text/html; charset=euc-kr" %>
<%@ page language="java" %> 
<%@ include file="/acar/cookies.jsp" %>
<%
	
	String auth_rw = "";
	if(request.getParameter("auth_rw") != null)	auth_rw= request.getParameter("auth_rw");
%>
<html>
<head>
<meta http-equiv="content-type" content="text/html; charset=euc-kr">
<title>FMS</title>
<link rel="stylesheet" type="text/css" href="/include/table_t.css"></link>
<script language="JavaScript">
<!--
function EnterDown() 
{
	var keyValue = event.keyCode;
	if (keyValue =='13') SearchMaint();
}
function SearchMaint()
{
	var theForm = document.MaintSearchForm;
	theForm.target = "c_foot";
	theForm.submit();
}
function ChangeFocus()
{
	var theForm = document.MaintSearchForm;
	if(theForm.gubun.value=="ref_dt")
	{
		nm.style.display = 'none';
		dt.style.display = '';
		theForm.ref_dt1.value = "";
		theForm.ref_dt2.value = "";
		theForm.ref_dt1.focus();
		
	}else{
		nm.style.display = '';
		dt.style.display = 'none';
		theForm.gubun_nm.value = "";
		theForm.gubun_nm.focus();
	}
}
function ChangeDT(arg)
{
	var theForm = document.MaintSearchForm;
	if(arg=="ref_dt1")
	{
	theForm.ref_dt1.value = ChangeDate(theForm.ref_dt1.value);
	}else if(arg=="ref_dt2"){
	theForm.ref_dt2.value = ChangeDate(theForm.ref_dt2.value);
	}

}
//-->
</script>
<script language="JavaScript" src="/include/common.js"></script>
</head>
<body>


<table border=0 cellspacing=0 cellpadding=0 width=100%>
	<tr>
    	<td ><font color="navy">������ -> </font><font color="red">����˻�����</font></td>
    </tr>
	<form action="./serv_daily_s_sc.jsp" name="MaintSearchForm" method="POST" >
    <tr>
        <td>
            <table border=0 cellspacing=1>
            	<tr>
            		<td>�˻� : </td>
            		<td>
            			<select name="gubun" onChange="jvascript:ChangeFocus()">
            				<option value="car_no">������ȣ</option>
            				<option value="firm_nm">��ȣ</option>
            				<option value="client_nm">����</option>
            				<option value="user_nm">�������</option>
            				<option value="car_no">����</option>
            				<option value="dt">�⵵</option>
            			</select>
            		</td>
            		<td id="nm"><input type="text" name="gubun_nm" size="10" value="" class=text onKeydown="javasript:EnterDown()"></td>
            		<td id="dt" style='display:none'><input type="text" name="ref_dt1" size="11" value="" class=text onBlur="javascript:ChangeDT('ref_dt1')"> ~ <input type="text" name="ref_dt2" size="11" value="" class=text onBlur="javascript:ChangeDT('ref_dt2')" onKeydown="javascript:EnterDown()"></td>
					
            		<td><input type="hidden" name="auth_rw" value="<%=auth_rw%>"><a href="javascript:SearchMaint()">�˻�</a></td>
            	</tr>
            </table>
        </td>
    </tr>
    </form>
</table>
</body>
</html>