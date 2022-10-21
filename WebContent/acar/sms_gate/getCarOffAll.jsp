<%@ page language="java" contentType="text/html;charset=euc-kr" %>
<%@ page import="java.util.*, acar.util.*, acar.car_office.*"%> 
<jsp:useBean id="co_bean" class="acar.car_office.CarOffBean" scope="page"/>
<%@ include file="/acar/cookies.jsp" %>

<%
	//지역
	String sido = request.getParameter("sido")==null?"":request.getParameter("sido");
	String gugun = request.getParameter("gugun")==null?"":request.getParameter("gugun");
	//제조사
	String cc_id = request.getParameter("cc_id")==null?"":request.getParameter("cc_id");
	
	CarOfficeDatabase umd = CarOfficeDatabase.getInstance();
	CarOffBean co_r [] = umd.getCarOffAll2(sido, gugun, cc_id);
		
%>

<html>
<head><title>FMS</title>
<script language='javascript'>
<!--
<%	
	int car_off_size = co_r.length;
	if(car_off_size > 0){
		for(int i = 0 ; i < car_off_size ; i++){
			co_bean = co_r[i];
%>			parent.add_car_off(0, '', '선택');
			parent.form1.slt_car_off.options[0].selected = true;
			parent.add_car_off(<%=(i+1)%>, '<%=co_bean.getCar_off_id()%>', '<%=co_bean.getCar_off_nm()%>');
<%
		}
	}else{
%>
			parent.add_car_off(0, '', '영업소없음');
<%
	}
%>
-->
</script>
</head>
<link rel=stylesheet type="text/css" href="/include/table.css">
<body leftmargin="15">
</body>
</html>
