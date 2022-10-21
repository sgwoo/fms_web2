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
	String section = request.getParameter("section")==null?"":request.getParameter("section");
	String sec_st = request.getParameter("sec_st")==null?"":request.getParameter("sec_st");
	int count = 0;

	CarMstDatabase cmb = CarMstDatabase.getInstance();
	
	cm_bean.setCar_comp_id(car_comp_id);
	cm_bean.setCode(code);
	cm_bean.setCar_id(car_id);
	cm_bean.setCar_name(car_name);
	cm_bean.setCar_yn(car_yn);
	cm_bean.setSection(section);
	
	if(cmd.equals("u")){
		count = cmb.updateCarNmLink(cm_bean, sec_st);
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
	}	%>
</script>
</body>
</html>