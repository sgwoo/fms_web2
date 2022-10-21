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

	//로그인 사용자정보 가져오기
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
	alert("점검사항이 등록되었습니다.");
	parent.location.href = "spdchk.jsp?car_mng_id=<%= car_mng_id %>&serv_id=<%= serv_id %>";
	parent.opener.location.reload();	
<%}else{%>
	alert("데이터베이스에 문제가 발생하였습니다.\n 관리자님께 문의하세요 !");					
<%}%>
//-->
</script>
</body>
</html>
