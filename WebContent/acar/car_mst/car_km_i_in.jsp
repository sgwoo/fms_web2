<%@ page language="java" contentType="text/html; charset=euc-kr" %>
<%@ page import="java.util.*, acar.util.*, acar.car_mst.*" %>
<jsp:useBean id="cd_bean" class="acar.car_mst.CarKmBean" scope="page"/>
<%@ include file="/acar/cookies.jsp" %>

<%
	String auth_rw 		= request.getParameter("auth_rw")	==null?"":request.getParameter("auth_rw");
	String car_comp_id 	= request.getParameter("car_comp_id")	==null?"":request.getParameter("car_comp_id");
	String code 		= request.getParameter("code")		==null?"":request.getParameter("code");
	String car_u_seq 	= request.getParameter("car_u_seq")	==null?"":request.getParameter("car_u_seq");
	String view_dt 		= request.getParameter("view_dt")	==null?"":request.getParameter("view_dt");
	
	if(car_comp_id.equals("")) car_comp_id="0001";
		
	//차량연비 관리 리스트
	AddCarMstDatabase a_cmb = AddCarMstDatabase.getInstance();
	CarKmBean [] cs_r = a_cmb.getCarKmList(car_comp_id, code, view_dt);
%>

<html>
<head>
<title>FMS</title>
<link rel="stylesheet" type="text/css" href="/include/table_t.css">
<script language='JavaScript' src='/include/common.js'></script>
<script language="JavaScript">
	function UpdateCarDcDisp(engine, car_k, car_k_seq, car_k_etc, car_k_dt, use_yn){
		var theForm = parent.document.form1;	
		theForm.engine.value 	= engine;
		theForm.car_k.value 	= car_k;
		theForm.car_k_seq.value 		= car_k_seq;
		theForm.car_k_etc.value 		= car_k_etc;	
		theForm.car_k_dt.value 		= ChangeDate3(car_k_dt);
		
		if(use_yn == 'Y')	theForm.use_yn.checked = true;
		else			theForm.use_yn.checked = false;
		;	
	}	
</script>
</head>
<body>
<form action="./car_dc_null_ui.jsp" name="CarNmForm" method="POST" >
<input type="hidden" name="cmd" value="">
<%	if(cs_r.length > 0){%>
<table border=0 cellspacing=0 cellpadding=0 width="680">
    <tr>
        <td class=line>            
        <table border="0" cellspacing="1" cellpadding="0" width="100%">
          <%	for(int i=0; i<cs_r.length; i++){
			        cd_bean = cs_r[i];%>
          <tr> 
            <td align=center width="7%"><%=i+1%></td>
            <td align=center width="17%"><%=cd_bean.getEngine()%></td>			
            <td align=center width="*"><a href="javascript:UpdateCarDcDisp('<%=cd_bean.getEngine()%>','<%=cd_bean.getCar_k()%>','<%=cd_bean.getCar_k_seq()%>','<%=cd_bean.getCar_k_etc()%>','<%=cd_bean.getCar_k_dt()%>','<%=cd_bean.getUse_yn()%>')" onMouseOver="window.status=''; return true"><%=cd_bean.getCar_k()%></a></td>
            <td align=center width="28%"><%=cd_bean.getCar_k_etc()%></td>
            <td align=center width="10%"><%=cd_bean.getUse_yn()%></td>	
          </tr>
          <%	}	%>
        </table>
        </td>
    </tr>
    <tr>
		<td>&nbsp;</td>
	</tr>	
</table>
<%	}%>                             
</form>
</body>
</html>