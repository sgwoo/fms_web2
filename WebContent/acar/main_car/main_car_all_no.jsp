<%@ page language="java" contentType="text/html; charset=euc-kr" %>
<%@ page import="java.util.*, acar.util.*, acar.estimate_mng.*" %>
<%@ include file="/acar/cookies.jsp" %>

<%
	String auth_rw 		= request.getParameter("auth_rw")==null?"":request.getParameter("auth_rw");
	String base_dt 		= request.getParameter("base_dt")==null?"":request.getParameter("base_dt");
	String car_comp_id 	= request.getParameter("car_comp_id")==null?"":request.getParameter("car_comp_id");	
	String t_wd 		= request.getParameter("t_wd")==null?"":request.getParameter("t_wd");	
	
	String car_id 	= request.getParameter("car_id")==null?"":AddUtil.ChangeString(request.getParameter("car_id"));
	String est_tel 	= request.getParameter("est_tel")==null?"":AddUtil.ChangeString(request.getParameter("est_tel"));
	
	EstiJuyoDatabase ej_db = EstiJuyoDatabase.getInstance();
	int cnt = 0;
	
	//��ü ������
	//if(car_id.equals("")){
	//	cnt  = ej_db.all_no(base_dt);
	//�Ѹ� ������
	//}else{
		cnt  = ej_db.select_no(car_id, est_tel);
	//}
%>

<html>
<head><title>FMS</title>
</head>
<meta http-equiv="Content-Type" content="text/html; charset=euc-kr">
<link rel=stylesheet type="text/css" href="/include/table.css">

<body leftmargin="15">
<script language='javascript'>
<%	if(cnt>0){%>
		alert("ó���Ǿ����ϴ�");
		d_content.location.href = './main_car_frame.jsp?auth_rw=<%=auth_rw%>&base_dt=<%=base_dt%>&car_comp_id=<%=car_comp_id%>&t_wd=<%=t_wd%>';
<%	}else{		%>
		alert("ó������ �ʾҽ��ϴ�");
<%	}			%>
</script>
</body>
</html>
