<%@ page language="java" contentType="text/html;charset=euc-kr"%>
<%@ page import="java.util.*"%>
<%@ page import="acar.util.*"%>
<%@ page import="acar.parking.*"%>
<jsp:useBean id="pk_db" scope="page" class="acar.parking.ParkIODatabase"/>

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
	
	int s_year = request.getParameter("s_year")==null?0:Util.parseDigit(request.getParameter("s_year"));
	
	String  d_flag = "";
		
	if(brid.equals("1")){//본사
	  d_flag =  pk_db.call_p_park_magam();
  	}else if(brid.equals("3")){//부산지점
	  d_flag =  pk_db.call_p_park_magam_bs();
	}else if(brid.equals("4")){//대전지점
	  d_flag =  pk_db.call_p_park_magam_dj();
	}else if(brid.equals("5")){//광주지점
	  d_flag =  pk_db.call_p_park_magam_kj();
	}else if(brid.equals("6")){//대구지점
	  d_flag =  pk_db.call_p_park_magam_dg();
	}

	
	//d_flag =  pk_db.call_p_park_magam(brid);
	  
	if (!d_flag.equals("0")) flag3 = 1;
	
	
	
%>
<script language='javascript'>

<%	if(flag3 != 0){  %>
		alert('주차현황 마감등록 오류 발생!');
<%	}else{		%>
		alert("처리되었습니다");
		parent.location.reload();
		
		window.open("park_out_list.jsp", "PARKING_CAR", "left=100, top=20, width=700, height=400, scrollbars=yes");
<%	}			%>

</script>