<%@ page contentType="text/html; charset=euc-kr" %>
<%@ page language="java" %> 
<%@ page import="java.util.*" %>
<%@ page import="acar.util.*" %>
<%@ page import="acar.forfeit_mng.*" %>
<jsp:useBean id="fc_bean" class="acar.forfeit_mng.FineCallBean" scope="page"/>
<%@ include file="/acar/cookies.jsp" %>

<%
	ForfeitDatabase fdb = ForfeitDatabase.getInstance();

	String auth_rw = "";
	String cmd = "";
	
	String car_mng_id = "";
	String car_no = "";
	String rent_mng_id = "";
	String rent_l_cd = "";
	String call_dt = "";
	String call_cont = "";
	String reg_nm = "";
	int count = 0;
	
	if(request.getParameter("auth_rw") != null)	auth_rw = request.getParameter("auth_rw");
	if(request.getParameter("cmd") != null) cmd = request.getParameter("cmd");
	if(request.getParameter("car_mng_id") != null) car_mng_id = request.getParameter("car_mng_id");
	if(request.getParameter("car_no") != null) car_no = request.getParameter("car_no");
	if(request.getParameter("rent_mng_id") != null) rent_mng_id = request.getParameter("rent_mng_id");
	if(request.getParameter("rent_l_cd") != null) rent_l_cd = request.getParameter("rent_l_cd");
	if(request.getParameter("call_dt") != null) call_dt = request.getParameter("call_dt");
	if(request.getParameter("call_cont") != null) call_cont = request.getParameter("call_cont");
	if(request.getParameter("reg_nm") != null) reg_nm = request.getParameter("reg_nm");
	
	fc_bean.setCar_mng_id(car_mng_id);
	fc_bean.setCar_no(car_no);
	fc_bean.setRent_mng_id(rent_mng_id);
	fc_bean.setRent_l_cd(rent_l_cd);
	fc_bean.setCall_dt(call_dt);
	fc_bean.setCall_cont(call_cont);
	fc_bean.setReg_nm(reg_nm);
	
	count = fdb.updateFineCall(fc_bean);

%>
<html>
<head>
<meta http-equiv="content-type" content="text/html; charset=euc-kr">
<title>FMS</title>
<link rel="stylesheet" type="text/css" href="/include/table_t.css"></link>
<script language="JavaScript">
<!--
function NullAction()
{
<%
	if(count==0)
	{
%>

<%
		
	}else{

%>
alert("정상적으로 통화기록되었습니다.");
//window.location="about:blank";
<%

	}
%>
}
//-->
</script>
</head>
<body onLoad="javascript:NullAction()">


</body>
</html>