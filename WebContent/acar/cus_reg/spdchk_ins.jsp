<%@ page language="java" contentType="text/html;charset=euc-kr"%>
<%@ page import="java.util.*, acar.util.*, acar.cus_reg.*"%>
<%@ include file="/acar/cookies.jsp"%>

<%
	String car_mng_id = request.getParameter("car_mng_id")==null?"":request.getParameter("car_mng_id");
	String serv_id = request.getParameter("serv_id")==null?"":request.getParameter("serv_id");
	String chk_ids = "";
	
	Enumeration e = request.getParameterNames();
	while(e.hasMoreElements()){
		String name = (String)e.nextElement();
		String value = request.getParameter(name);
		if(name.substring(0,5).equals("radio")){
			chk_ids += (value+":"+name+"/");
//			System.out.println(value+":"+name+"/");
		}
	}

	//�α��� ��������� ��������
	LoginBean login = LoginBean.getInstance();
	String user_id = login.getCookieValue(request, "acar_id");
	
	CusReg_Database cr_db = CusReg_Database.getInstance();
	int result = cr_db.updateService(chk_ids,car_mng_id,serv_id);
	
%>
<html>
<head><title>FMS</title>
<link rel=stylesheet type="text/css" href="/include/table.css">
</head>
<body>
<script language="JavaScript">
<!--
<%if(result>0){%>
	alert("���˻����� ��ϵǾ����ϴ�.");
	parent.location.href = "spdchk.jsp?car_mng_id=<%= car_mng_id %>&serv_id=<%= serv_id %>";
	parent.opener.location.reload();	
<%}else{%>
	alert("�����ͺ��̽��� ������ �߻��Ͽ����ϴ�.\n �����ڴԲ� �����ϼ��� !");					
<%}%>
//-->
</script>
</body>
</html>
