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
	String gubun = "";
	String gubun_nm = "";
		
	if(request.getParameter("auth_rw") !=null) auth_rw = request.getParameter("auth_rw");
	if(request.getParameter("off_id") !=null) off_id = request.getParameter("off_id");
	if(request.getParameter("gubun") !=null) gubun = request.getParameter("gubun");
	if(request.getParameter("gubun_nm") !=null) gubun_nm = request.getParameter("gubun_nm");
	//System.out.println(off_id);
	CustServBean [] cs_r = sod.getCustServAll(gubun, gubun_nm);
%>
<html>
<head>

<title>FMS</title>
<link rel="stylesheet" type="text/css" href="/include/table_t.css"></link>
<script language="JavaScript">
<!--
function CustServLoad()
{
	var theForm = document.CustServLoadForm;
	theForm.submit();
}
//-->
</script>
</head>
<body>
<table border=0 cellspacing=0 cellpadding=0 width=500>
	<form action="./serv_off_serv_car_null_ui.jsp" name="CustServRegForm" method="post">
	<tr>
		<td class='line'>
			 <table border="0" cellspacing="1" cellpadding="1" width=500>
<%
    for(int i=0; i<cs_r.length; i++){
        cs_bean = cs_r[i];
%>
            	<tr>
            		<td width=40 align=center><input type="checkbox" name="car_mng_id" value="<%=cs_bean.getCar_mng_id()%>"></td>
            		<td width=110 align=center><%=cs_bean.getCar_no()%></td>
            		<td width=200 align=left><span title="<%=cs_bean.getFirm_nm()%>"><%=Util.subData(cs_bean.getFirm_nm(),10)%></span></td>
            		<td width=100 align=center><span title="<%=cs_bean.getClient_nm()%>"><%=Util.subData(cs_bean.getClient_nm(),5)%></span></td>
            		<td width=100 align=center><%=cs_bean.getMgr_nm()%></td>
            	</tr>
<%}%>
<% if(cs_r.length == 0) { %>
            <tr>
                <td width=500 align=center height=25>등록된 데이타가 없습니다.</td>
            </tr>
<%}%>
            </table>
            <input type="hidden" name="off_id" value="<%=off_id%>">
        </td>
    </tr>
    </form>
</table>
<form action="./serv_off_serv_car_i_in.jsp" name="CustServLoadForm" method="post">
<input type="hidden" name="off_id" value="<%=off_id%>">
<input type="hidden" name="gubun" value="<%=gubun%>">
<input type="hidden" name="gubun_nm" value="<%=gubun_nm%>">
</form>
</body>
</html>