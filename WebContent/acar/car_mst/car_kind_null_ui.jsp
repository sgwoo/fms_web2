<%@ page language="java" contentType="text/html; charset=euc-kr" %>
<%@ page import="java.util.*, acar.util.*, acar.car_mst.*" %>
<jsp:useBean id="cm_bean" class="acar.car_mst.CarMstBean" scope="page"/>
<%@ include file="/acar/cookies.jsp" %>

<%
	String auth_rw = request.getParameter("auth_rw")==null?"":request.getParameter("auth_rw");
	String cmd = request.getParameter("cmd")==null?"":request.getParameter("cmd");
	String car_comp_id = request.getParameter("car_comp_id")==null?"":request.getParameter("car_comp_id");
	String code = request.getParameter("code")==null?"":request.getParameter("code");
	String car_cd = request.getParameter("car_cd")==null?"":request.getParameter("car_cd");
	String car_nm = request.getParameter("car_nm")==null?"":request.getParameter("car_nm");
	String car_yn = request.getParameter("car_yn")==null?"N":request.getParameter("car_yn");
	String est_yn = request.getParameter("est_yn")==null?"N":request.getParameter("est_yn");
	String main_yn = request.getParameter("main_yn")==null?"N":request.getParameter("main_yn");
	String ab_nm = request.getParameter("ab_nm")==null?"N":request.getParameter("ab_nm");
	String dlv_ext = request.getParameter("dlv_ext")==null?"":request.getParameter("dlv_ext");
	
 	int sd_amt = request.getParameter("sd_amt")==null?0:AddUtil.parseDigit(request.getParameter("sd_amt"));
	int count = 0;
	
	CarMstDatabase cmb = CarMstDatabase.getInstance();
	
	cm_bean.setCar_comp_id(car_comp_id);
	cm_bean.setCode(code);
	cm_bean.setCar_cd(car_cd);
	cm_bean.setCar_nm(car_nm);
	cm_bean.setCar_yn(car_yn);
	cm_bean.setSd_amt(sd_amt);
	cm_bean.setEst_yn(est_yn);
	cm_bean.setMain_yn(main_yn);
	cm_bean.setAb_nm(ab_nm);
	cm_bean.setDlv_ext(dlv_ext);
	
	if(cmd.equals("i")){
		count = cmb.insertCarKind(cm_bean);
	}else if(cmd.equals("u")){
		count = cmb.updateCarKind(cm_bean);
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
		parent.SearchCarKind();

<%		}
	}else{
		if(count==1){%>

		alert("정상적으로 등록되었습니다.");
		parent.SearchCarKind();

<%		}
	}	%>
</script>
</body>
</html>
