<%@ page language="java" contentType="text/html; charset=euc-kr" %>
<%@ page import="java.util.*, acar.util.*, acar.car_mst.*" %>
<jsp:useBean id="cm_bean" class="acar.car_mst.CarMstBean" scope="page"/>
<%@ include file="/acar/cookies.jsp" %>

<%
	String auth_rw = request.getParameter("auth_rw")==null?"":request.getParameter("auth_rw");
	String cmd = request.getParameter("cmd")==null?"":request.getParameter("cmd");
	String car_comp_id = request.getParameter("car_comp_id")==null?"":request.getParameter("car_comp_id");
	String code = request.getParameter("code")==null?"":request.getParameter("code");
	String car_id = request.getParameter("car_id")==null?"":request.getParameter("car_id");
	String car_name = request.getParameter("car_name")==null?"":request.getParameter("car_name");
	String car_yn = request.getParameter("car_yn")==null?"N":request.getParameter("car_yn");
	int count = 0;

	CarMstDatabase cmb = CarMstDatabase.getInstance();
	
	cm_bean.setCar_comp_id(car_comp_id);
	cm_bean.setCode(code);
	cm_bean.setCar_id(car_id);
	cm_bean.setCar_name(car_name);
	cm_bean.setCar_yn(car_yn);
	
	if(cmd.equals("i")){
		count = cmb.insertCarNm(cm_bean);
	}else if(cmd.equals("u")){
		count = cmb.updateCarNm(cm_bean);
	}
%>
<html>
<head>

<title>FMS</title>
<link rel="stylesheet" type="text/css" href="/include/table_t.css"></link>
<script language="JavaScript">
<!--
//-->
</script>
</head>
<body>

<script>
<%	if(cmd.equals("u")){
		if(count==1){%>

			alert("정상적으로 수정되었습니다.");
			parent.SearchCarNm();

<%		}
	}else{
		if(count==1){%>

			alert("정상적으로 등록되었습니다.");
			parent.SearchCarNm();

<%		}
	}	%>
</script>
</body>
</html>