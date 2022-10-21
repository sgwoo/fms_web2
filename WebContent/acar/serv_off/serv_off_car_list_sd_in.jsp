<%@ page contentType="text/html; charset=euc-kr" %>
<%@ page language="java" %> 
<%@ page import="java.util.*" %>
<%@ page import="acar.util.*" %>
<%@ page import="acar.serv_off.*" %>
<jsp:useBean id="cs_bean" class="acar.serv_off.CustServBean" scope="page"/>

<%
	ServOffDatabase sod = ServOffDatabase.getInstance();
	String auth_rw = "";
	String off_id = "";
		
	if(request.getParameter("auth_rw") !=null) auth_rw = request.getParameter("auth_rw");
	if(request.getParameter("off_id") !=null) off_id = request.getParameter("off_id");
	
	CustServBean [] cs_r = sod.getCustServReg(off_id);

%>
<html>
<head>

<title>FMS</title>
<link rel="stylesheet" type="text/css" href="/include/table_t.css"></link>
<script language="JavaScript">
<!--
function CarListLoad()
{
	var theForm = document.CustServLoadForm;
	theForm.submit();
}
//-->
</script>
</head>
<body>
<table border=0 cellspacing=0 cellpadding=0 width=800>
<form action="./serv_off_car_list_null_ui.jsp" name="CustServDelForm" method="post">
	<tr>
		<td class='line'>
			 <table border="0" cellspacing="1" cellpadding="1" width=800>
<%
    for(int i=0; i<cs_r.length; i++){
        cs_bean = cs_r[i];
%>
            	<tr>
            		<td width=100 align=center><%=cs_bean.getCar_no()%></td>
            		<td width=100 align=center></td>
            		<td width=100 align=center><%=cs_bean.getInit_reg_dt()%></td>
            		<td width=250 align=center><%=cs_bean.getFirm_nm()%></td>
            		<td width=150 align=center><%=cs_bean.getClient_nm()%></td>
            		<td width=100 align=center><%=cs_bean.getMgr_nm()%></td>
            	</tr>
<%}%>
<% if(cs_r.length == 0) { %>
            <tr>
                <td width=800 align=center height=25>등록된 데이타가 없습니다.</td>
            </tr>
<%}%>
            </table>
            <input type="hidden" name="off_id" value="<%=off_id%>">
			<input type="hidden" name="auth_rw" value="<%=auth_rw%>">
        </td>
    </tr>
    
	</form>
</table>

<form action="./serv_off_car_list_id_in.jsp" name="CustServLoadForm" method="post">
<input type="hidden" name="off_id" value="<%=off_id%>">
<input type="hidden" name="auth_rw" value="<%=auth_rw%>">
</form>
</body>
</body>
</html>