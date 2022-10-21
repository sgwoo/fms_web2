<%@ page language="java" contentType="text/html;charset=euc-kr" %>
<%@ page import="java.util.*, acar.util.*, acar.out_car.*"%>
<jsp:useBean id="oc_db" scope="page" class="acar.out_car.OutCarDatabase"/>
<%@ include file="/tax/cookies_base.jsp" %>

<%
	String s_yy 	= request.getParameter("s_yy")==null?"":request.getParameter("s_yy");
	String s_mm 	= request.getParameter("s_mm")==null?"":request.getParameter("s_mm");
	String car_off_id 	= request.getParameter("car_off_id")==null?"":request.getParameter("car_off_id");
	String base_dt = request.getParameter("base_dt")==null?"":request.getParameter("base_dt");
	int serial 		= request.getParameter("serial")==null?0:AddUtil.parseInt(request.getParameter("serial"));
	int tm 				= request.getParameter("tm")==null?1:AddUtil.parseInt(request.getParameter("tm"));
	String reg_type = request.getParameter("reg_type")==null?"":request.getParameter("reg_type");
	
	int flag = 0;
	
	OutStatBean bean = oc_db.getCarCashBackBase(serial);
	
	bean.setUpdate_id(ck_acar_id);
	
	//���	
	if(reg_type.equals("C")){
		if(!oc_db.updateCarStatCancel(bean)) flag += 1;
	//����	
	}else{
		bean.setBase_amt (request.getParameter("base_amt")==null?0:AddUtil.parseDigit4(request.getParameter("base_amt")));
		bean.setIncom_amt(request.getParameter("incom_amt")==null?0:AddUtil.parseDigit4(request.getParameter("incom_amt")));
		
		if(bean.getIncom_amt() > 0 ){
			bean.setM_amt(bean.getBase_amt()-bean.getIncom_amt());
		}else{
			bean.setM_amt(0);
		}
		
		if(!oc_db.updateCarStatBase(bean)) flag += 1;
	}
	
	
	
	
%>

<html>
<head><title>FMS</title>
<script language='JavaScript' src='/include/common.js'></script>
<script language='javascript'>
<!--
	function go_step(){
		var fm = document.form1;
		fm.action = 'car_cash_back_day_list.jsp';
		fm.target = "CardDayList";
		fm.submit();

		fm.action = 'car_cash_back_day_sc.jsp';
		fm.target = "c_foot";
		fm.submit();

	}
//-->
</script>
<meta http-equiv="content-type" content="text/html; charset=euc-kr">
<link rel=stylesheet type="text/css" href="../../include/table.css">
</head>
<body>
<form name='form1' action='' method='post'>
<input type='hidden' name='s_yy' value='<%=s_yy%>'>
<input type='hidden' name='s_mm' value='<%=s_mm%>'>
<input type='hidden' name='base_dt' value='<%=base_dt%>'>
<input type='hidden' name='car_off_id' value='<%=car_off_id%>'>
</form>
<a href="javascript:go_step()">��������</a>
<script language='javascript'>
<!--
<%	if(flag > 0){//�����߻�%>
		alert("������ �߻��Ͽ����ϴ�.");
<%	}else{//����%>
		alert("ó���Ǿ����ϴ�.");
		//go_step();
		window.close();
<%	}%>
//-->
</script>
</body>
</html>
