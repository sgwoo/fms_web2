<%@ page language="java" contentType="text/html;charset=euc-kr"%>
<%@ page import="java.util.*, acar.util.*, acar.cus_reg.*"%>
<%@ include file="/acar/cookies.jsp"%>
<%
	String car_mng_id = request.getParameter("car_mng_id")==null?"":request.getParameter("car_mng_id");
	String serv_id = request.getParameter("serv_id")==null?"":request.getParameter("serv_id");
	String serv_st = request.getParameter("serv_st")==null?"":request.getParameter("serv_st");	
	String gubun = request.getParameter("gubun")==null?"":request.getParameter("gubun");//��¥�׸� ����
	String bus_id2 = request.getParameter("bus_id2")==null?"":request.getParameter("bus_id2");
	
	String rent_mng_id = request.getParameter("rent_mng_id")==null?"":request.getParameter("rent_mng_id");
	String rent_l_cd = request.getParameter("rent_l_cd")==null?"":request.getParameter("rent_l_cd");

	String spdchk_dt = request.getParameter("spdchk_dt")==null?"":AddUtil.ChangeString(request.getParameter("spdchk_dt"));
	String serv_dt = request.getParameter("serv_dt")==null?"":AddUtil.ChangeString(request.getParameter("serv_dt"));
	String ipgodt = request.getParameter("ipgodt")==null?"":AddUtil.ChangeString(request.getParameter("ipgodt"));
	String ipgodt_h = request.getParameter("ipgodt_h")==null?"":request.getParameter("ipgodt_h");
	String ipgodt_m = request.getParameter("ipgodt_m")==null?"":request.getParameter("ipgodt_m");	
	String chulgodt = request.getParameter("chulgodt")==null?"":AddUtil.ChangeString(request.getParameter("chulgodt"));
	String chulgodt_h = request.getParameter("chulgodt_h")==null?"":request.getParameter("chulgodt_h");
	String chulgodt_m = request.getParameter("chulgodt_m")==null?"":request.getParameter("chulgodt_m");

	if(!ipgodt.equals("")){
		ipgodt = ipgodt+ipgodt_h+ipgodt_m;
	}
	if(ipgodt.equals("0000") || ipgodt.equals("0000    0000")){
		ipgodt = "";
	}
	if(!chulgodt.equals("")){
		chulgodt = chulgodt+chulgodt_h+chulgodt_m;
	}
	if(chulgodt.equals("0000") || chulgodt.equals("0000    0000")){
		chulgodt = "";
	}
		
	//�α��� ��������� ��������
	LoginBean login = LoginBean.getInstance();
	String user_id = login.getCookieValue(request, "acar_id");
	
	int result = 0;
	CusReg_Database cr_db = CusReg_Database.getInstance();
	
	String dt = "";
	if ( gubun.equals("1") ) dt = spdchk_dt;
	if ( gubun.equals("2") ) dt = serv_dt;
	if ( gubun.equals("3") ) dt = ipgodt;
	if ( gubun.equals("4") ) dt = chulgodt;
	
	result = cr_db.updateDt(car_mng_id,serv_id, gubun, dt);
	
%>
<html>
<head><title>FMS</title>
<link rel=stylesheet type="text/css" href="/include/table.css">
</head>
<body>
<script language="JavaScript">
<!--
<%if(result>0){%>
	alert("��¥�� �����Ͽ����ϴ�.");
	parent.location.href = "serv_reg.jsp?car_mng_id=<%= car_mng_id %>&serv_id=<%= serv_id %>";
	parent.opener.location.reload();
<%}else{%>
	alert("�����ͺ��̽��� ������ �߻��Ͽ����ϴ�.\n �����ڴԲ� �����ϼ��� !");					
<%}%>
//-->
</script>
</body>
</html>
