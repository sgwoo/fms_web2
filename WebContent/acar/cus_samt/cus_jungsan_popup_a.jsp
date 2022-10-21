<%@ page language="java" contentType="text/html;charset=euc-kr" %>
<%@ page import="java.util.*, acar.util.*, acar.car_service.*, acar.cus_samt.*"%>
<jsp:useBean id="cs_db" scope="page" class="acar.cus_samt.CusSamt_Database"/>
<%@ include file="/acar/cookies.jsp" %>

<html>
<head>
<title>FMS</title>
<link rel=stylesheet type="text/css" href="/include/table.css">
<script language='JavaScript' src='../../include/common.js'></script>
</head>
<body leftmargin="15">
<%
	String auth_rw = request.getParameter("auth_rw")==null?"":request.getParameter("auth_rw");
	String user_id = request.getParameter("user_id")==null?"":request.getParameter("user_id");
	String br_id = request.getParameter("br_id")==null?"":request.getParameter("br_id");
	
	String car_mng_id = request.getParameter("car_mng_id")==null?"":request.getParameter("car_mng_id");
	String serv_id = request.getParameter("serv_id")==null?"":request.getParameter("serv_id");
	
	String jung_st = request.getParameter("jung_st")==null?"":request.getParameter("jung_st");
	String set_dt = request.getParameter("set_dt")==null?"":request.getParameter("set_dt");
	int count = 1;
	boolean flag1 = true;
	
	//자동차정비등록정보
	ServiceBean sr_bean = cs_db.getServiceId(car_mng_id, serv_id);
	
	sr_bean.setSet_dt(set_dt);
	sr_bean.setJung_st(jung_st);
	sr_bean.setUpdate_id(user_id);
	 
	if( !sr_bean.getPre_set_dt().equals("")) {
		flag1 = cs_db.updateServiceAutoDocuNew(sr_bean);
	} else {
		flag1 = cs_db.updateServiceAutoDocu(sr_bean);
	}
%>
<script language='javascript'>
<%	if(flag1){%>
		alert('정상적으로 처리되었습니다');
		parent.window.close();
	//	parent.opener.location.reload();
<%	}else{ //에러%>
		alert('처리되지 않았습니다\n\n에러발생!');
<%	}%>
</script>
</body>
</html>
