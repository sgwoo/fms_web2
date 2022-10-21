<%@ page language="java" contentType="text/html;charset=euc-kr"%>
<%@ page import="java.util.*, acar.util.*, acar.cus_reg.*"%>
<%@ include file="/acar/cookies.jsp"%>
<%
	String car_mng_id = request.getParameter("car_mng_id")==null?"":request.getParameter("car_mng_id");
	String serv_id = request.getParameter("serv_id")==null?"":request.getParameter("serv_id");
	String item_st = request.getParameter("item_st")==null?"":request.getParameter("item_st");	
	String item_id = request.getParameter("item_id")==null?"":request.getParameter("item_id");
	String item = request.getParameter("item")==null?"":request.getParameter("item");
	String wk_st = request.getParameter("wk_st")==null?"":request.getParameter("wk_st");
	int count = request.getParameter("count")==null?0:AddUtil.parseDigit(request.getParameter("count"));
	int price = request.getParameter("price")==null?0:AddUtil.parseDigit(request.getParameter("price"));
	int amt = request.getParameter("amt")==null?0:AddUtil.parseDigit(request.getParameter("amt"));
	int labor = request.getParameter("labor")==null?0:AddUtil.parseDigit(request.getParameter("labor"));
	String bpm = request.getParameter("bpm")==null?"":request.getParameter("bpm");
	
	Serv_ItemBean siBn = new Serv_ItemBean();
	siBn.setCar_mng_id(car_mng_id);
	siBn.setServ_id(serv_id);
	siBn.setItem_st(item_st);
	siBn.setItem_id(item_id);
	siBn.setItem(item);
	siBn.setWk_st(wk_st);
	siBn.setCount(count);
	siBn.setPrice(price);
	siBn.setAmt(amt);
	siBn.setLabor(labor);
	siBn.setBpm(bpm);	
	
	CusReg_Database cr_db = CusReg_Database.getInstance();
	int result = cr_db.insertServItem(siBn);	
%>

<html>
<head><title>FMS</title>
<link rel=stylesheet type="text/css" href="/include/table.css">
</head>
<body>
<script language="JavaScript">
<!--
<%if(result>0){%>
	parent.inner4.location.href = "item_serv.jsp?car_mng_id=<%= car_mng_id %>&serv_id=<%= serv_id %>";
<%}else{%>
	alert("데이터베이스에 문제가 발생하였습니다.\n 관리자님께 문의하세요 !");					
<%}%>
//-->
</script>
</body>
</html>
