<%@ page language="java" contentType="text/html;charset=euc-kr" %>
<%@ page import="java.util.*, acar.util.*, acar.estimate_mng.*" %>
<jsp:useBean id="shDb" class="acar.secondhand.SecondhandDatabase" scope="page"/>
<%@ include file="/acar/cookies.jsp" %>

<%
	String auth_rw 	= request.getParameter("auth_rw")==null?"":request.getParameter("auth_rw");
	String gubun 	= request.getParameter("gubun")==null?"":request.getParameter("gubun");
	String gubun_nm = request.getParameter("gubun_nm")==null?"":request.getParameter("gubun_nm");
	String brch_id 	= request.getParameter("brch_id")==null?"":request.getParameter("brch_id");
	String gubun2 	= request.getParameter("gubun2")==null?"":request.getParameter("gubun2");
	int sh_height 	= request.getParameter("sh_height")==null?0:Util.parseInt(request.getParameter("sh_height"));//상단길이
	
	String[] car = request.getParameterValues("pr");
	
	int result = shDb.setSecondhand(car);
	
	
	String car_mng_id = "";
	

	//재리스견적 계산하기
	
	EstiDatabase e_db = EstiDatabase.getInstance();
	
	
	
	for(int i=0 ; i<car.length ; i++){
		car_mng_id = car[i]==null?"":car[i];
		
		//재리스 계산
		//String  d_flag1 =  e_db.call_sp_esti_reg_sh(car_mng_id);
		
		
	}

%>
<html>
<head><title>FMS</title>
<link rel=stylesheet type="text/css" href="/include/table.css">
<meta http-equiv="Content-Type" content="text/html; charset=euc-kr">
<script language="JavaScript">
<!--
	function go_sp_esti(){
		var fm = document.form1;
		fm.action = "http://fms1.amazoncar.co.kr/acar/off_lease/off_lease_frame.jsp";
		fm.submit();
	}
//-->
</script>
</head>
<body>
<form name='form1' method='post' action=''>
<input type='hidden' name='auth_rw' value='<%=auth_rw%>'>
<input type="hidden" name="gubun" value="<%=gubun%>">
<input type="hidden" name="gubun_nm" value="<%=gubun_nm%>">
<input type="hidden" name="brch_id" value="<%=brch_id%>">
<input type="hidden" name="gubun2" value="<%=gubun2%>">
<input type="hidden" name="sh_height" value="<%=sh_height%>">
<%for(int i=0 ; i<car.length ; i++){
	car_mng_id = car[i]==null?"":car[i];%>
<input type="hidden" name="car_mng_id" value="<%=car_mng_id%>">
<%}%>
</form>
<script>
<!--
<%if (result >= 1) {%>
	alert("선택하신 차량이 재리스로 등록되었습니다.\n재리스차량현황에서 확인하시기 바랍니다.");
	window.top.frames["d_content"].location = "/acar/off_lease/off_lease_frame.jsp?auth_rw=<%=auth_rw%>&gubun=<%=gubun%>&gubun_nm=<%=gubun_nm%>";
	//parent.parent.location = "/acar/off_lease/off_lease_frame.jsp?auth_rw=<%=auth_rw%>&gubun=<%=gubun%>&gubun_nm=<%=gubun_nm%>";
	//go_sp_esti();	
<%} else {%>
	alert("데이터베이스에 문제가 발생하였습니다.\n 관리자님께 문의하세요 !");
	window.top.frames["d_content"].location = "/acar/off_lease/off_lease_frame.jsp?auth_rw=<%=auth_rw%>&gubun=<%=gubun%>&gubun_nm=<%=gubun_nm%>";
<%}%>
//-->
</script>
<script language="JavaScript">
<!--
/*
<%	if(result >= 1){%>
	alert("선택하신 차량이 재리스로 등록되었습니다.\n재리스차량현황에서 확인하시기 바랍니다.");
	parent.parent.location = "/acar/off_lease/off_lease_frame.jsp?auth_rw=<%=auth_rw%>&gubun=<%=gubun%>&gubun_nm=<%=gubun_nm%>";
<%}else{%>
	alert("데이터베이스에 문제가 발생하였습니다.\n 관리자님께 문의하세요 !");
	parent.c_foot.inner.location = "/acar/off_lease/off_lease_frame.jsp?auth_rw=<%=auth_rw%>&gubun=<%=gubun%>&gubun_nm=<%=gubun_nm%>";
<%}%>
*/
//-->
</script>
</body>
</html>
