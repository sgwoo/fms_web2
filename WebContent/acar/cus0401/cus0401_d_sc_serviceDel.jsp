<%@ page language="java" contentType="text/html;charset=euc-kr" %>
<%@ page import="java.util.*, acar.util.*, acar.car_service.*, acar.res_search.*" %>
<jsp:useBean id="rs_db" scope="page" class="acar.res_search.ResSearchDatabase"/>
<%@ include file="/acar/cookies.jsp" %>
<%
	String auth_rw = request.getParameter("auth_rw")==null?"":request.getParameter("auth_rw");
	String car_mng_id = request.getParameter("car_mng_id")==null?"":request.getParameter("car_mng_id");
	String serv_id = request.getParameter("serv_id")==null?"":request.getParameter("serv_id");

	CarServDatabase csd = CarServDatabase.getInstance();
	
	int result = 0;
	
	//����ý���-������� ����� ����� �������� ���Ѵ�.
	int res_cnt = rs_db.getRentContServChk(car_mng_id,serv_id);
	
	if(res_cnt == 0){
		result = csd.serviceDel(car_mng_id,serv_id);
	}
%>
<html>
<head><title>FMS</title>
</head>
<body>
<script language="JavaScript">
<!--
<%	if(result>=0){%>
	alert("�����Ǿ����ϴ� !");
	parent.location.href = "cus0401_d_sc_carhis_in.jsp?auth_rw=<%=auth_rw%>&car_mng_id=<%=car_mng_id%>";
<%}else{%>
	alert("�����ͺ��̽��� ������ �߻��Ͽ����ϴ�.\n �����ڴԲ� �����ϼ��� !");
	window.close();				
<%}%>
//-->
</script>
</body>
</html>
