<%@ page language="java" contentType="text/html;charset=euc-kr"%>
<%@ page import="java.util.*"%>
<%@ page import="acar.util.*"%>
<%@ page import="acar.out_car.*"%>
<jsp:useBean id="oc_db" scope="page" class="acar.out_car.OutCarDatabase"/>

<html>
<head><title>FMS</title>
</head>
<meta http-equiv="Content-Type" content="text/html; charset=euc-kr">
<link rel=stylesheet type="text/css" href="/include/table.css">

<body leftmargin="15">
<%
	String auth_rw = request.getParameter("auth_rw")==null?"":request.getParameter("auth_rw");
	String br_id = request.getParameter("br_id")==null?"":request.getParameter("br_id");
	String user_id = request.getParameter("user_id")==null?"":request.getParameter("user_id");
	int flag3 = 0;
	String s_kd 	= request.getParameter("s_kd")==null?"":request.getParameter("s_kd");
	String t_wd 	= request.getParameter("t_wd")==null?"" :request.getParameter("t_wd");
	String brid 	= request.getParameter("brid")==null?"":request.getParameter("brid");
	String gubun1 = request.getParameter("gubun1")==null?"1":request.getParameter("gubun1");
	String start_dt 	= request.getParameter("start_dt")==null?"":request.getParameter("start_dt");
	String end_dt 	= request.getParameter("end_dt")==null?"":request.getParameter("end_dt");
	String sort_gubun = request.getParameter("sort_gubun")==null?"5":request.getParameter("sort_gubun");
	String asc = request.getParameter("asc")==null?"":request.getParameter("asc");
	String s_cc = request.getParameter("s_cc")==null?"":request.getParameter("s_cc");
	
	String save_dt = request.getParameter("save_dt")==null?"":request.getParameter("save_dt");
	
	int s_year = request.getParameter("s_year")==null?0:Util.parseDigit(request.getParameter("s_year"));
	
	String  d_flag = "";
		


	d_flag =  oc_db.call_out_car_magam(save_dt);
	
	if (!d_flag.equals("0")) flag3 = 1;
	
	
	
%>
<script language='javascript'>

<%	if(flag3 != 0){  %>
		alert('�̹� ��ü�����Ȳ ��������� �Ǿ��ų�, ������� ���� �߻�!');
<%	}else{		%>
		alert("ó���Ǿ����ϴ�");
		parent.location.reload();
		
<%	}			%>

</script>