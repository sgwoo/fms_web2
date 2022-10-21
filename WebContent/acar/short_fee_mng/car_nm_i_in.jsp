<%@ page language="java" contentType="text/html; charset=euc-kr" %>
<%@ page import="java.util.*, acar.util.*, acar.car_mst.*" %>
<jsp:useBean id="cm_bean" class="acar.car_mst.CarMstBean" scope="page"/>
<%@ include file="/acar/cookies.jsp" %>

<html>
<head>
<title>FMS</title>
<link rel="stylesheet" type="text/css" href="/include/table_t.css">
<script language="JavaScript">
<!--
	function UpdateCarNmDisp(car_id, car_name, car_yn, section){
		var theForm = parent.document.CarNmForm;	
		theForm.car_id.value = car_id;
		theForm.car_name.value = car_name;
		
		if(car_yn == 'Y')				theForm.car_yn.checked = true;			
		else								theForm.car_yn.checked = false;

		if(section == 'C1')			theForm.section[1].selected = true;			
		else if(section == 'C2')		theForm.section[2].selected = true;		 
		else if(section == 'I1')		theForm.section[3].selected = true;		 		
		else if(section == 'I2')		theForm.section[4].selected = true;		 
		else if(section == 'I3')		theForm.section[5].selected = true;		 
		else if(section == 'J1')		theForm.section[6].selected = true;		 
		else if(section == 'J2')		theForm.section[7].selected = true;		 
		else if(section == 'L1')		theForm.section[8].selected = true;		 
		else if(section == 'L2')		theForm.section[9].selected = true;		 								
		else if(section == 'P1')		theForm.section[10].selected = true;		 
		else if(section == 'P2')		theForm.section[11].selected = true;		 				
		else if(section == 'P3')		theForm.section[12].selected = true;		 
		else if(section == 'S1')		theForm.section[13].selected = true;		 
		else if(section == 'S2')		theForm.section[14].selected = true;		 				
		else if(section == 'S3')		theForm.section[15].selected = true;		 								
		else if(section == 'W1')		theForm.section[16].selected = true;		 
		else if(section == 'W2')		theForm.section[17].selected = true;		 				
		else if(section == 'W3')		theForm.section[18].selected = true;		 
		else								theForm.section[0].selected = true;

	}
//-->
</script>
</head>
<body>
<%
	String auth_rw = request.getParameter("auth_rw")==null?"":request.getParameter("auth_rw");
	String car_comp_id = request.getParameter("car_comp_id")==null?"":request.getParameter("car_comp_id");
	String code = request.getParameter("code")==null?"":request.getParameter("code");
	
	AddCarMstDatabase cmb = AddCarMstDatabase.getInstance();
	CarMstBean cm_r [] =cmb.getCarNmAll(car_comp_id,code);
%>
<form action="./car_nm_null_ui.jsp" name="CarNmForm" method="POST" >
<input type="hidden" name="cmd" value="">
<%	if(cm_r.length > 0){%>
<table border=0 cellspacing=0 cellpadding=0 width="440">
    <tr>
        <td class=line>            
            <table border="0" cellspacing="1" cellpadding="0" width="440">
          <%	for(int i=0; i<cm_r.length; i++){
    				cm_bean = cm_r[i];%>
                <tr> 
                    <td align=center width=30><%=i+1%></td>
                    <td align=center width=270><a href="javascript:UpdateCarNmDisp('<%=cm_bean.getCar_id()%>','<%=cm_bean.getCar_name()%>','<%=cm_bean.getCar_yn()%>','<%=cm_bean.getSection()%>')" onMouseOver="window.status=''; return true"><%=cm_bean.getCar_name()%></a></td>
                    <td align=center width=70><%=cm_bean.getSection()%></td>
                    <td align=center width=70><%=cm_bean.getCar_yn()%></td>
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