<%@ page language="java" contentType="text/html;charset=euc-kr"%>
<%@ page import="java.util.*, acar.util.*, acar.cus_reg.*"%>
<%@ include file="/acar/cookies.jsp"%>
<%
	String car_mng_id = request.getParameter("car_mng_id")==null?"":request.getParameter("car_mng_id");
	String serv_id = request.getParameter("serv_id")==null?"":request.getParameter("serv_id");
	int seq_no = request.getParameter("seq_no")==null?0:AddUtil.parseDigit(request.getParameter("seq_no"));	
	String item_st = request.getParameter("item_st")==null?"":request.getParameter("item_st");	
	String item_id = request.getParameter("item_id")==null?"":request.getParameter("item_id");
	String item_cd = request.getParameter("item_cd")==null?"":request.getParameter("item_cd");
	String item = request.getParameter("item")==null?"":request.getParameter("item");
	String wk_st = request.getParameter("wk_st")==null?"":request.getParameter("wk_st");
	int count = request.getParameter("count")==null?0:AddUtil.parseDigit(request.getParameter("count"));
	int price = request.getParameter("price")==null?0:AddUtil.parseDigit(request.getParameter("price"));
	int amt = request.getParameter("amt")==null?0:AddUtil.parseDigit(request.getParameter("amt"));
	int labor = request.getParameter("labor")==null?0:AddUtil.parseDigit(request.getParameter("labor"));
	String bpm = request.getParameter("bpm")==null?"":request.getParameter("bpm");
	int result = 0;
	
	Serv_ItemBean siBn = new Serv_ItemBean();
	siBn.setCar_mng_id(car_mng_id);
	siBn.setServ_id(serv_id);
	siBn.setSeq_no(seq_no);
	siBn.setItem_st(item_st);
	siBn.setItem_id(item_id);
	siBn.setItem_cd(item_cd);
	siBn.setItem(item);
	siBn.setWk_st(wk_st);
	siBn.setCount(count);
	siBn.setPrice(price);
	siBn.setAmt(amt);
	siBn.setLabor(labor);
	siBn.setBpm(bpm);
	siBn.setReg_id(ck_acar_id);	
	
	CusReg_Database cr_db = CusReg_Database.getInstance();
	
	if(car_mng_id.equals("") || serv_id.equals("")){
		result = 3;
	}else{
		if(seq_no>0){
			result = cr_db.updateServItem(siBn);
		}else{
			result = cr_db.insertServItem(siBn);
		}
	}
%>

<html>
<head><title>FMS</title>
<link rel=stylesheet type="text/css" href="/include/table.css">
</head>
<body>
<script language="JavaScript">
<!--
<%if(result == 1){%>
	parent.inner4.location.href = "item_serv.jsp?car_mng_id=<%= car_mng_id %>&serv_id=<%= serv_id %>";
	parent.opener.item_serv_in.location.reload();
	parent.window.close();
<%}else if(result == 3){%>
	alert("car_mng_id 또는 serv_id가 없습니다.\n 확인하십시오");
<%}else{%>
	alert("데이터베이스에 문제가 발생하였습니다.\n 관리자님께 문의하세요 !");					
<%}%>
//-->
</script>
</body>
</html>
