<%@ page language="java" contentType="text/html;charset=euc-kr"%>
<%@ page import="java.util.*, acar.util.*, acar.cus_reg.*"%>
<%@ include file="/acar/cookies.jsp"%>
<%
	String car_mng_id = request.getParameter("car_mng_id")==null?"":request.getParameter("car_mng_id");
	String serv_id = request.getParameter("serv_id")==null?"":request.getParameter("serv_id");
	String serv_st = request.getParameter("serv_st")==null?"":request.getParameter("serv_st");	
	int sh_amt = request.getParameter("sh_amt")==null?0:AddUtil.parseInt(request.getParameter("sh_amt"));//�縮�������� �����ݾ�
	String bus_id2 = request.getParameter("bus_id2")==null?"":request.getParameter("bus_id2");
	
	String rent_mng_id = request.getParameter("rent_mng_id")==null?"":request.getParameter("rent_mng_id");
	String rent_l_cd = request.getParameter("rent_l_cd")==null?"":request.getParameter("rent_l_cd");

	//�α��� ��������� ��������
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
	alert("�縮�������� �����ݾ��� ��ϵǾ����ϴ�.");
	parent.location.href = "serv_reg.jsp?car_mng_id=<%= car_mng_id %>&serv_id=<%= serv_id %>";
	parent.opener.location.reload();
<%}else{%>
	alert("�����ͺ��̽��� ������ �߻��Ͽ����ϴ�.\n �����ڴԲ� �����ϼ��� !");					
<%}%>
//-->
</script>
</body>
</html>
