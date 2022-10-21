<%@ page contentType="text/html; charset=euc-kr" %>
<%@ page language="java" %> 
<%@ page import="java.util.*" %>
<%@ page import="acar.util.*" %>
<%@ page import="acar.serv_off.*" %>
<jsp:useBean id="so_bean" class="acar.serv_off.ServOffBean" scope="page"/>

<%
	ServOffDatabase sod = ServOffDatabase.getInstance();
	String auth_rw = "";
	String gubun_nm = "";
	
	if(request.getParameter("auth_rw") !=null) auth_rw = request.getParameter("auth_rw");
	if(request.getParameter("gubun_nm") !=null) gubun_nm = request.getParameter("gubun_nm");
	
	ServOffBean so_r [] = sod.getServOffAll(gubun_nm);

%>
<html>
<head>
<meta http-equiv="content-type" content="text/html; charset=euc-kr">
<title>FMS</title>
<link rel="stylesheet" type="text/css" href="/include/table_t.css"></link><script language="JavaScript">
<!--
function ServOffDisp(off_id)
{
	var theForm = document.ServOffDispForm;
	theForm.off_id.value = off_id;
	theForm.target = "d_content";
	theForm.submit();
}
//-->
</script>
</head>
<body>
<table border=0 cellspacing=0 cellpadding=0 width=800>
	<tr>
		<td class='line'>
			 <table border="0" cellspacing="1" cellpadding="1" width=800>
<%
    for(int i=0; i<so_r.length; i++){
        so_bean = so_r[i];
%>
            	<tr>
            		<td width=100 align=center><a href="javascript:ServOffDisp('<%=so_bean.getOff_id()%>')"><%=so_bean.getOff_nm()%></a></td>
            		<td width=100 align=center><%=so_bean.getOff_st_nm()%></td>
            		<td width=100 align=center><%=so_bean.getOwn_nm()%></td>
            		<td width=100 align=center><span title="<%=so_bean.getOff_addr()%>"><%=Util.subData(so_bean.getOff_addr(),3)%></span></td>
            		<td width=100 align=center><%=so_bean.getOff_tel()%></td>
            		<td width=100 align=center><%=so_bean.getOff_fax()%></td>
            		<td width=100 align=center><a href="http://<%=so_bean.getHomepage()%>" target="_blank"><%=so_bean.getHomepage()%></a></td>
            		<td width=100 align=center><span title="<%=so_bean.getNote()%>">비고</span></td>
            		
            	</tr>
<%}%>
<% if(so_r.length == 0) { %>
            <tr>
                <td width=800 align=center height=25>등록된 데이타가 없습니다.</td>
            </tr>
<%}%>
            </table>
        </td>
    </tr>
</table>
<form action="./serv_off_s_frame.jsp" name="ServOffDispForm" method="post">
<input type="hidden" name="auth_rw" value="<%=auth_rw%>">
<input type="hidden" name="off_id" value="">
</form>
</body>
</html>