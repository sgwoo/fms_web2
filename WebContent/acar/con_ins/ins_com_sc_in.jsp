<%@ page language="java" contentType="text/html; charset=euc-kr" %>
<%@ page import="java.util.*, acar.util.*, acar.car_mst.*" %>
<jsp:useBean id="cm_bean" class="acar.car_mst.CarMstBean" scope="page"/>
<%@ include file="/acar/cookies.jsp" %>

<%
	String auth_rw = request.getParameter("auth_rw")==null?"":request.getParameter("auth_rw");
	String car_comp_id = request.getParameter("car_comp_id")==null?"0001":request.getParameter("car_comp_id");
	String code = request.getParameter("code")==null?"":request.getParameter("code");

	CarMstDatabase cmd = CarMstDatabase.getInstance();	
	CarMstBean [] cm_r = cmd.getCarNmAll(car_comp_id,code);
%>
<html>
<head>
<meta http-equiv="content-type" content="text/html; charset=euc-kr">
<title>FMS</title>
<link rel="stylesheet" type="text/css" href="/include/table_t.css"></link><script language="JavaScript">
<!--
	function UpdateList(arg){	
		var theForm = document.CarOffUpdateForm;
		theForm.car_off_id.value = arg;
		theForm.target="d_content";
		theForm.submit();
	}
//-->
</script>
</head>
<body>
<table border=0 cellspacing=0 cellpadding=0 width=98%>
    <tr>
        <td class=line>
            <table border=0 cellspacing=1 width=98%>
			<%	for(int i=0; i<cm_r.length; i++){
			        cm_bean = cm_r[i];%>
            	<tr>
            		<td width='100' align=center><%=cm_bean.getCar_comp_nm()%></td>
            		<td width='60' align=center><%=cm_bean.getCar_cd()%></td>
            		<td width='180' align=center><%=cm_bean.getCar_nm()%></td>
            		<td width='300'>&nbsp;&nbsp;<%=cm_bean.getCar_name()%></td>
					<td align=center><%=cm_bean.getCar_name()%></td>
            	</tr>
			<%	}	%>
			<% if(cm_r.length == 0){ %>
				<tr>
					<td width=98% align=center height=25>등록된 데이타가 없습니다.</td>
				</tr>
			<%	}	%>
            </table>
        </td>
    </tr>
</table>
<form action="./car_office_c.jsp" name="CarOffUpdateForm" method="post">
<input type="hidden" name="car_off_id" value="">
<input type="hidden" name="auth_rw" value="<%=auth_rw%>">
</form>
</body>
</html>