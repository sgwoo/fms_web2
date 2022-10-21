<%@ page language="java" contentType="text/html;charset=euc-kr"%>
<%@ page import="java.util.*, acar.util.*, acar.cus_reg.*"%>
<%@ include file="/acar/cookies.jsp"%>
<%
	String car_mng_id = request.getParameter("car_mng_id")==null?"":request.getParameter("car_mng_id");
	String serv_id = request.getParameter("serv_id")==null?"":request.getParameter("serv_id");
	String serv_st = request.getParameter("serv_st")==null?"":request.getParameter("serv_st");	
	int sh_amt = request.getParameter("sh_amt")==null?0:AddUtil.parseInt(request.getParameter("sh_amt"));//재리스수리비 공제금액
	String bus_id2 = request.getParameter("bus_id2")==null?"":request.getParameter("bus_id2");
	
	String rent_mng_id = request.getParameter("rent_mng_id")==null?"":request.getParameter("rent_mng_id");
	String rent_l_cd = request.getParameter("rent_l_cd")==null?"":request.getParameter("rent_l_cd");

	//로그인 사용자정보 가져오기
	LoginBean login = LoginBean.getInstance();
	String user_id = login.getCookieValue(request, "acar_id");
	
	int result = 0;
	CusReg_Database cr_db = CusReg_Database.getInstance();
	
	result = cr_db.updateShAmt(car_mng_id,serv_id, sh_amt, bus_id2);
	
%>
<html>
<head><title>FMS</title>
<link rel=stylesheet type="text/css" href="/include/table.css">
</head>
<body>
<script language="JavaScript">
<!--
<%if(result>0){%>
	alert("재리스수리비 공제금액이 등록되었습니다.");
	parent.location.href = "serv_reg.jsp?car_mng_id=<%= car_mng_id %>&serv_id=<%= serv_id %>";
	parent.opener.location.reload();
<%}else{%>
	alert("데이터베이스에 문제가 발생하였습니다.\n 관리자님께 문의하세요 !");					
<%}%>
//-->
</script>
</body>
</html>
