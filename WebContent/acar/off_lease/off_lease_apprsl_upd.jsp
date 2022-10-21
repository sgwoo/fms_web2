<%@ page language="java" contentType="text/html;charset=euc-kr"%>
<%@ page import="java.util.*"%>
<%@ page import="acar.util.*"%> 
<jsp:useBean id="olyD" class="acar.offls_yb.Offls_ybDatabase" scope="page"/>
<%@ include file="/acar/cookies.jsp"%>
<%
	//로그인사용자정보 가져오기
	LoginBean login = LoginBean.getInstance();
	String user_id = login.getCookieValue(request, "acar_id");

	String auth_rw = request.getParameter("auth_rw")==null?"":request.getParameter("auth_rw");
	String car_mng_id = request.getParameter("car_mng_id")==null?"":request.getParameter("car_mng_id");
	String lev = request.getParameter("apprsl_lev")==null?"":request.getParameter("apprsl_lev");
	String reason = request.getParameter("apprsl_reason")==null?"":request.getParameter("apprsl_reason");
	String car_st = request.getParameter("apprsl_car_st")==null?"":request.getParameter("apprsl_car_st");
	String damdang_id = request.getParameter("damdang_id")==null?"":request.getParameter("damdang_id");
	String apprsl_dt = request.getParameter("apprsl_dt")==null?"":AddUtil.ChangeString(request.getParameter("apprsl_dt"));
	String gubun = request.getParameter("gubun")==null?"":request.getParameter("gubun");
	String driver = request.getParameter("driver")==null?"":request.getParameter("driver");

	int result = 0;
	if(gubun.equals("u")){
		result = olyD.upApprsl(car_mng_id, lev, reason, car_st, damdang_id, user_id, apprsl_dt,driver);
//System.out.println("result=u="+result);
	}else if(gubun.equals("i")){
		result = olyD.inApprsl(car_mng_id, lev, reason, car_st, damdang_id, user_id, apprsl_dt,driver);
//System.out.println("result=i="+result);
	}
%>
<html>
<head><title>FMS</title>
<link rel=stylesheet type="text/css" href="/include/table.css">
</head>
<body>
<script language="JavaScript">
<!--
<%if(result >= 1){
	if(gubun.equals("i")){%>
		alert("등록되었습니다.");
	<%}else if(gubun.equals("u")){%>
		alert("수정되었습니다.");
	<%}%>
	parent.location.href = "off_lease_sc_in_b_apprsl.jsp?auth_rw=<%=auth_rw%>&car_mng_id=<%=car_mng_id%>";
<%}else{%>
	alert("데이터베이스에 문제가 발생하였습니다.\n 관리자님께 문의하세요 !");
	window.close();				
<%}%>
//-->
</script>
</body>
</html>
