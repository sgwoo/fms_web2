<%@ page language="java" contentType="text/html;charset=euc-kr" %>
<%@ page import="java.util.*, acar.ma.*"%> 
<%@ include file="/acar/cookies.jsp" %>

<%
	CodeDatabase c_db = CodeDatabase.getInstance();
	String com_id = request.getParameter("com_id")==null?"":request.getParameter("com_id");
%>
<html>
<head><title></title>
<script language='javascript'>
<!--
<%
	Vector cars = c_db.getCarList(com_id, "", "CAR"); /* 차종 조회 */
	int car_size = cars.size();	
	if(car_size > 0){
		for(int i = 0 ; i < car_size ; i++){
			Hashtable car = (Hashtable)cars.elementAt(i);
%>
			parent.add_car_nm(0, '', '선택');
			parent.form1.slt_car_nm.options[0].selected = true;
			parent.add_car_nm(<%=(i+1)%>, '<%= car.get("CODE")%>', '<%= car.get("CAR_NM")%>');
<%
		}
	}else{
%>
			parent.add_car_nm(0, '', '등록된차량이없습니다');
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