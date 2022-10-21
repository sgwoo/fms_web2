<%@ page language="java" contentType="text/html; charset=euc-kr" %>
<%@ page import="java.util.*, acar.util.*, acar.car_mst.*" %>
<jsp:useBean id="cm_bean" class="acar.car_mst.CarMstBean" scope="page"/>
<%@ include file="/acar/cookies.jsp" %>

<html>
<head>
<title>FMS</title>
<link rel="stylesheet" type="text/css" href="/include/table_t.css"></link>
<script language="JavaScript">
<!--
	function UpdateCarNmDisp(car_id, car_name, car_yn){
		var theForm = parent.document.CarNmForm;	
		theForm.car_id.value = car_id;
		theForm.car_name.value = car_name;
		if(car_yn == 'Y'){	
			theForm.car_yn.checked = true;			
		}else{
			theForm.car_yn.checked = false;
		}
	}
//-->
</script>
</head>
<body>
<%
	String auth_rw = request.getParameter("auth_rw")==null?"":request.getParameter("auth_rw");
	String car_comp_id = request.getParameter("car_comp_id")==null?"":request.getParameter("car_comp_id");
	String code = request.getParameter("code")==null?"":request.getParameter("code");
	
	CarMstDatabase cmb = CarMstDatabase.getInstance();
	CarMstBean cm_r [] =cmb.getCarNmAll(car_comp_id,code);
%>
<form action="./car_nm_null_ui.jsp" name="CarNmForm" method="POST" >
<input type="hidden" name="cmd" value="">
<%	if(cm_r.length > 0){%>
<table border=0 cellspacing=0 cellpadding=0 width="341">
    <tr>
        <td class=line>
            <table border="0" cellspacing="1" cellpadding="3" width="341">
			<%	for(int i=0; i<cm_r.length; i++){
    				cm_bean = cm_r[i];%>
				<tr>
					<td align=center width=280><a href="javascript:UpdateCarNmDisp('<%=cm_bean.getCar_id()%>','<%=cm_bean.getCar_name()%>','<%=cm_bean.getCar_yn()%>')" onMouseOver="window.status=''; return true"><%=cm_bean.getCar_name()%></a></td>
					<td align=center width=61><%=cm_bean.getCar_yn()%></td>
				</tr>              
			<%	}	%>                             
            </table>
        </td>
    </tr>
</table>
<%	}%>                             
</form>
</body>
</html>