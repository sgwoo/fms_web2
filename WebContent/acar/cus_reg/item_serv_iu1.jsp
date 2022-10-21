<%@ page language="java" contentType="text/html;charset=euc-kr"%>
<%@ page import="java.util.*, acar.util.*, acar.cus_reg.*"%>
<%@ include file="/acar/cookies.jsp"%>
<%
	String car_mng_id = request.getParameter("car_mng_id")==null?"":request.getParameter("car_mng_id");
	String serv_id = request.getParameter("serv_id")==null?"":request.getParameter("serv_id");
	String serv_st = request.getParameter("serv_st")==null?"":request.getParameter("serv_st");
	int seq_no = request.getParameter("seq_no")==null?0:AddUtil.parseDigit(request.getParameter("seq_no"));	
	String item_st = request.getParameter("item_st")==null?"":request.getParameter("item_st");	
	String item_id = request.getParameter("item_id")==null?"":request.getParameter("item_id");
	String item_cd = request.getParameter("item_cd")==null?"":request.getParameter("item_cd");
	String item = request.getParameter("item")==null?"":request.getParameter("item");
	String wk_st = request.getParameter("wk_st")==null?"":request.getParameter("wk_st");
	int count = request.getParameter("count")==null?0:AddUtil.parseDigit(request.getParameter("count"));
	int price = request.getParameter("price")==null?0:AddUtil.parseDigit(request.getParameter("price"));
	int price1 = request.getParameter("price1")==null?0:AddUtil.parseDigit(request.getParameter("price1"));
	int amt = request.getParameter("amt")==null?0:AddUtil.parseDigit(request.getParameter("amt"));
	int labor = request.getParameter("labor")==null?0:AddUtil.parseDigit(request.getParameter("labor"));
	String bpm = request.getParameter("bpm")==null?"":request.getParameter("bpm");
	int result = 0;
	
	if ( price1 > 0 )  price = price1;
	
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
	
//        System.out.println("seq_no=" + seq_no);
    	
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
   
//	parent.location.reload();	 
	parent.item_serv_in.location.reload();	

<%}else if(result == 3){%>
	alert("car_mng_id �Ǵ� serv_id�� �����ϴ�.\n Ȯ���Ͻʽÿ�");
<%}else{%>
	alert("�����ͺ��̽��� ������ �߻��Ͽ����ϴ�.\n �����ڴԲ� �����ϼ��� !");					
<%}%>
//-->
</script>
</body>
</html>
