<%@ page language="java" contentType="text/html;charset=euc-kr" %>
<%@ page import="java.util.*, acar.client.*, acar.util.*, acar.cont.*"%>
<jsp:useBean id="l_db" scope="page" class="acar.client.ClientDatabase"/>
<jsp:useBean id="al_db" scope="page" class="acar.client.AddClientDatabase"/>
<jsp:useBean id="olsD" class="acar.offls_sui.Offls_suiDatabase" scope="page"/>

<%
	String car_mng_id = request.getParameter("car_mng_id");

	int result = 0;
   //scd_sui_jan, scd_sui_cont, sui, sui_etc, car_reg off_ls= '3���� , auction actn_st = '4'��   ��Ű� ��� actn_st:2
	result = olsD.cancelSui(car_mng_id);	
	
%>
<html>
<head><title>FMS</title>
<meta http-equiv="Content-Type" content="text/html; charset=euc-kr">
<link rel=stylesheet type="text/css" href="/include/table.css">
</head>
<body>
<script language="JavaScript">
<!--
<%if(result > 0){	%>
	alert("�����Ǿ����ϴ�.");		
<%}else{%>
	alert("�����ͺ��̽��� ������ �߻��Ͽ����ϴ�.\n �����ڴԲ� �����ϼ��� !");
<%}%>
//-->
</script>

</body>
</html>

