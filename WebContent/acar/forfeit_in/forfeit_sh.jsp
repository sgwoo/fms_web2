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
	if (keyValue =='13') SearchForfeit();
}
function SearchForfeit()
{
	var theForm = document.ForfeitSearchForm;
	theForm.target = "c_foot";
	theForm.submit();
}
function BlankGubun()
{
	var theForm = document.ForfeitSearchForm;
	theForm.gubun_nm.value = "";
	theForm.gubun_nm.focus();
}
//-->
</script>
<script language="JavaScript" src="/include/common.js"></script>
</head>
<body>


<table border=0 cellspacing=0 cellpadding=0 width=100%>
	<tr>
    	<td ><font color="navy">������ -> </font><font color="red">���±�/��Ģ��</font></td>
    </tr>
	<form action="./forfeit_sc.jsp" name="ForfeitSearchForm" method="POST" >
    <tr>
        <td>
            <table border=0 cellspacing=1>
            	<tr>
            		<td>
            			<input type="radio" name="st" value="0" checked> ��ü
            			<input type="radio" name="st" value="1"> ����
            			<input type="radio" name="st" value="2"> �̼���
            		</td>
            		<td><script language="JavaScript">init(5); init_display3("yr");</script></td>
            		<td>
            			<input type="radio" name="f_st" value="1" checked> ������
            			<input type="radio" name="f_st" value="2"> ���������
            		</td>
            		<td>�˻� : </td>
            		<td>
            			<select name="gubun" onChange="javascript:BlankGubun()">
            				<option value="car_no">������ȣ</option>
            				<option value="firm_nm">��ȣ</option>
            				<option value="rent_l_cd">����ȣ</option>
            				<option value="paid_no">��������ȣ</option>
            				<option value="car_name">����</option>
            				<option value="vio_dt">��������</option>
            				<option value="vio_pla">�������</option>
            			</select>
            		</td>
            		
            		<td>
            			<input type="text" name="gubun_nm" size="10" value="" class="text" onKeydown="javasript:EnterDown()">
            			<input type="hidden" name="auth_rw" value="<%=auth_rw%>">
            		</td>
					<td><a href="forfeit_i_frame.jsp"><img src="/images/search.gif" width="50" height="18" aligh="absmiddle" border="0"></a></td>
            	</tr>
            </table>
        </td>
    </tr>
    </form>
</table>
</body>
</html>